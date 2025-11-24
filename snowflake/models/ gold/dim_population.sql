-- models/gold/dim_population.sql
-- ============================================================
-- GOLD LAYER: POPULATION DIMENSION
-- ------------------------------------------------------------
-- This model:
--   ✓ Creates a population dimension from the silver population table
--   ✓ Adds a surrogate key (population_sk) for BI and fact table joins
-- ============================================================

WITH base AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY zip_code) AS population_sk
    FROM {{ ref('population') }}  -- reference the silver population table
)

SELECT
    population_sk,
    zip_code,
    population,
    population_category
FROM base
