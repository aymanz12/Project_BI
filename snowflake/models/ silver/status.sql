-- ============================================================
-- SILVER LAYER: STATUS CLEANING & STANDARDIZATION
-- ------------------------------------------------------------
-- This model:
--   ✓ Casts customer status & churn-related metrics to correct types
--   ✓ Prepares service KPIs for BI dashboards & ML models
--   ✓ Cleans and standardizes fields for BI dashboards and ML features
-- ============================================================

WITH base AS (
    SELECT
        -- Identifiers
        CAST("CUSTOMER ID" AS TEXT) AS customer_id,
        CAST("QUARTER" AS TEXT) AS quarter,

        -- Scores and metrics
        CAST("SATISFACTION SCORE" AS INTEGER) AS satisfaction_score,
        CAST("CHURN VALUE" AS INTEGER) AS churn_value,
        CAST("CHURN SCORE" AS INTEGER) AS churn_score,
        CAST(CLTV AS INTEGER) AS cltv,

        -- Categorical fields
        UPPER(TRIM(CAST("CUSTOMER STATUS" AS TEXT))) AS customer_status,
        CAST("CHURN CATEGORY" AS TEXT) AS churn_category,
        CAST("CHURN LABEL" AS TEXT) AS churn_label,
        CAST("CHURN REASON" AS TEXT) AS churn_reason

    FROM {{ source('raw', 'STATUS') }}
)

SELECT
    base.*,

    -- ===============================
    -- Satisfaction Category
    -- ===============================
    CASE
        WHEN satisfaction_score IS NULL THEN 'Unknown'
        WHEN satisfaction_score <= 2 THEN 'Low'
        WHEN satisfaction_score = 3 THEN 'Medium'
        WHEN satisfaction_score >= 4 THEN 'High'
    END AS satisfaction_category,

    -- ===============================
    -- Churn Risk Category
    -- ===============================
    CASE
        WHEN customer_status = 'CHURNED' THEN 'Already Churned'
        WHEN churn_score IS NULL THEN 'Unknown'
        WHEN churn_score < 20 THEN 'Low Risk'
        WHEN churn_score BETWEEN 20 AND 50 THEN 'Medium Risk'
        WHEN churn_score > 50 THEN 'High Risk'
    END AS churn_risk_category

FROM base
