-- ============================================================
-- SILVER LAYER: SERVICE CLEANING & STANDARDIZATION
-- ------------------------------------------------------------
-- This model:
--   ✓ Cleans and standardizes telecom service fields
--   ✓ Converts Yes/No fields into TRUE/FALSE boolean flags
--   ✓ Computes net revenue and streaming service count
--   ✓ Prepares rich service KPIs for BI dashboards & ML models
-- ============================================================

WITH base AS (

    SELECT
        CAST("CUSTOMER ID" AS TEXT) AS customer_id,
        CAST("QUARTER" AS TEXT) AS quarter,

        -- Referral information
        CASE WHEN "REFERRED A FRIEND" = 'Yes' THEN TRUE ELSE FALSE END AS referred_friend_flag,
        COALESCE(TRY_CAST(TO_VARCHAR("NUMBER OF REFERRALS") AS NUMBER), 0) AS number_referrals,
        COALESCE(TRY_CAST(TO_VARCHAR("TENURE IN MONTHS") AS INTEGER), 0) AS tenure_months,

        -- Offers & phone service
        COALESCE("OFFER", 'None') AS offer,
        CASE WHEN "PHONE SERVICE" = 'Yes' THEN TRUE ELSE FALSE END AS phone_service_flag,

        -- Long distance usage
        COALESCE(TRY_CAST(TO_VARCHAR("AVG MONTHLY LONG DISTANCE CHARGES") AS NUMBER), 0) AS avg_monthly_ld_charge,
        CASE
            WHEN TRY_CAST(TO_VARCHAR("AVG MONTHLY LONG DISTANCE CHARGES") AS NUMBER) = 0 THEN 'None'
            WHEN TRY_CAST(TO_VARCHAR("AVG MONTHLY LONG DISTANCE CHARGES") AS NUMBER) < 20 THEN 'Low'
            WHEN TRY_CAST(TO_VARCHAR("AVG MONTHLY LONG DISTANCE CHARGES") AS NUMBER) BETWEEN 20 AND 30 THEN 'Medium'
            ELSE 'High'
        END AS long_distance_category,

        -- Multiple lines / internet services
        CASE WHEN "MULTIPLE LINES" = 'Yes' THEN TRUE ELSE FALSE END AS multiple_lines_flag,
        COALESCE("INTERNET SERVICE", 'None') AS internet_service,
        COALESCE("INTERNET TYPE", 'None') AS internet_type,

        -- Data usage
        COALESCE(TRY_CAST(TO_VARCHAR("AVG MONTHLY GB DOWNLOAD") AS NUMBER), 0) AS avg_monthly_gb,
        CASE
            WHEN TRY_CAST(TO_VARCHAR("AVG MONTHLY GB DOWNLOAD") AS NUMBER) <= 20 THEN 'Low'
            WHEN TRY_CAST(TO_VARCHAR("AVG MONTHLY GB DOWNLOAD") AS NUMBER) <= 50 THEN 'Medium'
            ELSE 'High'
        END AS download_usage_category,

        -- Add-ons (Yes/No → TRUE/FALSE)
        CASE WHEN "ONLINE SECURITY" = 'Yes' THEN TRUE ELSE FALSE END AS online_security_flag,
        CASE WHEN "ONLINE BACKUP" = 'Yes' THEN TRUE ELSE FALSE END AS online_backup_flag,
        CASE WHEN "DEVICE PROTECTION PLAN" = 'Yes' THEN TRUE ELSE FALSE END AS device_protection_flag,
        CASE WHEN "PREMIUM TECH SUPPORT" = 'Yes' THEN TRUE ELSE FALSE END AS premium_tech_support_flag,
        CASE WHEN "STREAMING TV" = 'Yes' THEN TRUE ELSE FALSE END AS streaming_tv_flag,
        CASE WHEN "STREAMING MOVIES" = 'Yes' THEN TRUE ELSE FALSE END AS streaming_movies_flag,
        CASE WHEN "STREAMING MUSIC" = 'Yes' THEN TRUE ELSE FALSE END AS streaming_music_flag,
        CASE WHEN "UNLIMITED DATA" = 'Yes' THEN TRUE ELSE FALSE END AS unlimited_data_flag,

        -- Contract information
        COALESCE("CONTRACT", 'Unknown') AS contract_type,
        CASE
            WHEN "CONTRACT" LIKE '%Month%' THEN 'Short-Term'
            WHEN "CONTRACT" LIKE '%Year%'  THEN 'Long-Term'
            ELSE 'Unknown'
        END AS contract_category,

        -- Billing preferences
        CASE WHEN "PAPERLESS BILLING" = 'Yes' THEN TRUE ELSE FALSE END AS paperless_billing_flag,
        COALESCE("PAYMENT METHOD", 'Unknown') AS payment_method,
        CASE
            WHEN "PAYMENT METHOD" LIKE '%Credit%' THEN 'Credit'
            WHEN "PAYMENT METHOD" LIKE '%Bank%' THEN 'Bank'
            WHEN "PAYMENT METHOD" LIKE '%Check%' THEN 'Check'
            ELSE 'Other'
        END AS payment_category,

        -- Charges & revenue fields
        COALESCE(TRY_CAST(TO_VARCHAR("MONTHLY CHARGE") AS NUMBER), 0) AS monthly_charge,
        COALESCE(TRY_CAST(TO_VARCHAR("TOTAL CHARGES") AS NUMBER), 0) AS total_charges,
        COALESCE(TRY_CAST(TO_VARCHAR("TOTAL REFUNDS") AS NUMBER), 0) AS total_refunds,
        COALESCE(TRY_CAST(TO_VARCHAR("TOTAL EXTRA DATA CHARGES") AS NUMBER), 0) AS total_extra_data_charges,
        ROUND(COALESCE(TRY_CAST(TO_VARCHAR("TOTAL LONG DISTANCE CHARGES") AS NUMBER), 0), 2) AS total_long_distance_charges,
        COALESCE(TRY_CAST(TO_VARCHAR("TOTAL REVENUE") AS NUMBER), 0) AS total_revenue

    FROM {{ source('raw', 'SERVICE') }}

)

SELECT
    base.*,

    -- Net revenue = revenue - refunds
    ROUND(total_revenue - total_refunds, 2) AS net_revenue,

    -- Number of streaming services subscribed
    (
        CASE WHEN streaming_tv_flag     THEN 1 ELSE 0 END +
        CASE WHEN streaming_movies_flag THEN 1 ELSE 0 END +
        CASE WHEN streaming_music_flag  THEN 1 ELSE 0 END
    ) AS streaming_services_count,

    -- Revenue segmentation
    CASE
        WHEN total_revenue >= 4000 THEN 'VIP'
        WHEN total_revenue >= 2000 THEN 'High'
        WHEN total_revenue >= 1000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_segment

FROM base
