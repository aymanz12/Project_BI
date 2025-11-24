-- models/gold/dim_contract.sql
-- ============================================================
-- GOLD LAYER: CONTRACT DIMENSION
-- ------------------------------------------------------------
-- This model:
--   ✓ Creates a contract/payment dimension from the silver service table
--   ✓ Adds a surrogate key (contract_sk) for BI and fact table joins
-- ============================================================

WITH base AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY customer_id, quarter) AS contract_sk
    FROM {{ ref('service') }}  -- reference silver.service table
)

SELECT
    contract_sk,
    customer_id,
    quarter,
    contract_type,
    contract_category,
    payment_method,
    payment_category,
    offer
FROM base
