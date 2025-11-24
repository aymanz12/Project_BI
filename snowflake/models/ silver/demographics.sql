-- ============================================================
-- SILVER LAYER: DEMOGRAPHICS CLEANING & STANDARDIZATION
-- ------------------------------------------------------------
-- This model:
--   ✓ Casts columns into correct data types
--   ✓ Creates an age_group dimension (19–80)
--   ✓ Standardizes dependents into categorical buckets
--   ✓ Prepares demographic data for BI & Gold models
-- ============================================================

select
    -- Convert customer ID to text for consistent joins
    cast("CUSTOMER ID" as text) as customer_id,

    -- Standardize gender as text category
    cast(gender as text) as gender,

    -- Ensure age is numeric
    cast(age as integer) as age,

    -- Create age group buckets for BI segmentation
    case
        when age between 19 and 29 then 'Young Adult'
        when age between 30 and 44 then 'Adult'
        when age between 45 and 59 then 'Middle Age'
        when age between 60 and 80 then 'Senior'
        else 'Unknown'
    end as age_group,

    -- Keep original senior citizen flag (Yes/No)
    cast("SENIOR CITIZEN" as text) as senior_citizen,

    -- Standardize marital status field
    cast(married as text) as married,

    -- Standardize dependents field
    cast(dependents as text) as dependents,

    -- Convert dependents count to integer
    cast("NUMBER OF DEPENDENTS" as integer) as number_of_dependents,

    -- Create dependents category for BI
    case
        when "NUMBER OF DEPENDENTS" = 0 then 'None'
        when "NUMBER OF DEPENDENTS" between 1 and 2 then 'Low'
        when "NUMBER OF DEPENDENTS" between 3 and 5 then 'Medium'
        else 'High'
    end as dependents_category

from {{ source('raw', 'DEMOGRAPHICS') }}
