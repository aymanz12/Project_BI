-- ============================================================
-- SILVER LAYER: LOCATION CLEANING & STANDARDIZATION
-- ------------------------------------------------------------
-- This model:
--   ✓ Casts location-related fields into clean data types
--   ✓ Converts latitude & longitude to numeric values
--   ✓ Preserves ZIP codes as text to avoid formatting issues
--   ✓ Prepares clean geolocation data for BI and analytics
-- ============================================================

SELECT
    -- Customer ID used as key for joining with other silver models
    CAST("CUSTOMER ID" AS TEXT) AS customer_id,

    -- Basic location information standardized as text
    CAST(country AS TEXT)       AS country,
    CAST(state AS TEXT)         AS state,
    CAST(city AS TEXT)          AS city,

    -- ZIP codes preserved as text to avoid dropping leading zeros
    CAST("ZIP CODE" AS TEXT)    AS zip_code,

    -- Convert latitude/longitude to numeric for geospatial use
    CAST(latitude AS DOUBLE PRECISION)  AS latitude,
    CAST(longitude AS DOUBLE PRECISION) AS longitude

FROM {{ source('raw', 'LOCATION') }}
