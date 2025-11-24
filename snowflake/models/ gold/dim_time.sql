-- models/gold/dim_time.sql
-- ============================================================
-- GOLD LAYER: TIME DIMENSION
-- ------------------------------------------------------------
-- This model:
--   ✓ Creates a time dimension from distinct quarters
--   ✓ Adds a surrogate key (time_sk) for BI and fact table joins
-- ============================================================

WITH quarters AS (
    SELECT DISTINCT quarter
    FROM {{ ref('service') }}  -- reference the silver.service table
)

SELECT
    ROW_NUMBER() OVER (ORDER BY quarter) AS time_sk,
    quarter
FROM quarters
