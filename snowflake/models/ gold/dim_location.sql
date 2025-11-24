-- models/gold/dim_location.sql
-- ============================================================
-- GOLD LAYER: LOCATION DIMENSION
-- ------------------------------------------------------------
-- This model:
--   ✓ Creates a location dimension from the silver location table
--   ✓ Adds a surrogate key (location_sk) for BI and fact table joins
-- ============================================================

WITH base AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY zip_code) AS location_sk
    FROM {{ ref('location') }}  -- reference the silver location table
)

SELECT
    location_sk,
    customer_id,
    country,
    state,
    city,
    zip_code,
    latitude,
    longitude
FROM base
