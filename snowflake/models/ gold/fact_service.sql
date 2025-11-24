-- models/gold/fact_service.sql
-- ============================================================
-- GOLD LAYER: FACT SERVICE
-- ------------------------------------------------------------
-- This model:
--   ✓ Combines silver service & status data
--   ✓ Joins with gold dimensions (customer, location, contract, time, population)
--   ✓ Includes numeric metrics only (no categorical fields)
-- ============================================================

WITH joined AS (
    SELECT
        s.*,
        st.churn_score,
        st.churn_value,
        st.satisfaction_score
    FROM {{ ref('service') }} s
    LEFT JOIN {{ ref('status') }} st
        ON s.customer_id = st.customer_id
       AND s.quarter = st.quarter
)

SELECT
    c.customer_sk,
    t.time_sk,
    l.location_sk,
    p.population_sk,
    cn.contract_sk,

    -- Numeric measures
    number_referrals,
    tenure_months,
    avg_monthly_ld_charge,
    avg_monthly_gb,
    monthly_charge,
    total_charges,
    total_refunds,
    net_revenue,
    total_extra_data_charges,
    total_long_distance_charges,
    total_revenue,
    streaming_services_count,
    churn_score,
    churn_value,
    satisfaction_score

FROM joined j
LEFT JOIN {{ ref('dim_customer') }} c
    ON j.customer_id = c.customer_id
LEFT JOIN {{ ref('dim_location') }} l
    ON j.customer_id = l.customer_id
LEFT JOIN {{ ref('dim_population') }} p
    ON l.zip_code = p.zip_code
LEFT JOIN {{ ref('dim_contract') }} cn
    ON j.customer_id = cn.customer_id
   AND j.quarter = cn.quarter
LEFT JOIN {{ ref('dim_time') }} t
    ON j.quarter = t.quarter
