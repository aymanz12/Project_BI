-- models/gold/dim_customer.sql
-- ============================================================
-- GOLD LAYER: CUSTOMER DIMENSION
-- ------------------------------------------------------------
-- This model:
--   ✓ Creates a customer dimension from the silver demographics table
--   ✓ Adds a surrogate key (customer_sk) for BI and fact table joins
-- ============================================================

WITH base AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_sk
    FROM {{ ref('demographics') }}  -- reference the silver table
)

SELECT
    customer_sk,
    customer_id,
    gender,
    age,
    age_group,
    senior_citizen,
    married,
    number_of_dependents,
    dependents_category
FROM base
