
WITH parquet_in AS (
    SELECT * FROM {{ source('external_source','raw_customers') }}
)

SELECT 
cnum as id,
fname as first_name,
lname as last_name
FROM parquet_in