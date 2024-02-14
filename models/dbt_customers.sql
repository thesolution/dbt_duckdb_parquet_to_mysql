{{ config(
    database="mysql"
) }}


select * from {{ rel('raw_customers') }} 