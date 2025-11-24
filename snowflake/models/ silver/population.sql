-- ============================================================
-- SILVER LAYER: POPULATION CLEANING & STANDARDIZATION
-- ------------------------------------------------------------
-- This model:
--   ✓ Ensures ID and population values are numeric using TRY_CAST
--   ✓ Preserves ZIP codes as text to avoid formatting issues
--   ✓ Creates BI-friendly population category buckets
--   ✓ Cleans raw data and prepares it for Gold models
-- ============================================================

WITH base AS (
    SELECT
        -- Convert ID to numeric safely
        TRY_CAST(TO_VARCHAR(ID) AS NUMBER) AS id,

        -- ZIP codes preserved as text for consistency
        CAST("ZIP CODE" AS TEXT) AS zip_code,

        -- Convert population to numeric safely
        TRY_CAST(TO_VARCHAR(POPULATION) AS NUMBER) AS population
    FROM {{ source('raw', 'POPULATION') }}
)

SELECT
    id,
    zip_code,
    population,

    -- Create categorized buckets for BI dashboards
    CASE
        WHEN population IS NULL THEN 'Unknown'
        WHEN population < 1000 THEN 'Very Small'
        WHEN population BETWEEN 1000 AND 10000 THEN 'Small'
        WHEN population BETWEEN 10001 AND 50000 THEN 'Medium'
        ELSE 'Large'
    END AS population_category

FROM base
