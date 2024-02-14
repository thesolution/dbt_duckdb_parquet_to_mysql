-- See more config options here: https://duckdb.org/docs/sql/configuration
-- run 'from duckdb_settings();'
set memory_limit = '1GB';
set threads = 1;

----------------------------------------------
--         import from parquet
----------------------------------------------
-- drop table if exists
DROP TABLE IF EXISTS raw_customers;

-- create table from parquet
CREATE TABLE raw_customers AS 
SELECT
    cnum as id,
    fname as first_name,
    lname as last_name,
FROM read_parquet('external/raw_customers.parquet');


----------------------------------------------
--         export to mysql
----------------------------------------------
-- attach mysql to duckdb
ATTACH 'mysql:host={{ MYSQL_HOST }} port={{ MYSQL_PORT }} database={{ MYSQL_DATABASE }} user={{ MYSQL_USER }} password={{ MYSQL_PASSWORD }}' AS mysql;

-- drop table if exists
DROP TABLE IF EXISTS mysql.app_schema.duckdb_customers;

-- create table
CREATE TABLE mysql.app_schema.duckdb_customers AS SELECT * FROM raw_customers;


----------------------------------------------
--         show data from duckdb
----------------------------------------------
-- show 5 rows
select * from raw_customers limit 5;

-- show row count
select count(*) as 'raw_customers.count' from raw_customers;

----------------------------------------------
--         show data from mysql
----------------------------------------------
-- show 5 rows
select * from mysql.app_schema.duckdb_customers limit 5;

-- show row count
select count(*) as 'duckdb_customers.count' from mysql.app_schema.duckdb_customers limit 5;


----------------------------------------------
--         duckdb information_schema
----------------------------------------------
-- duckdb information_schema.tables
    SELECT table_catalog, table_schema, table_name, table_type,
    is_insertable_into, is_typed from information_schema.tables
    where table_schema != 'information_schema' and table_name not like 'dbt_%'
    limit 10;

-- duckdb information_schema.columns
    SELECT table_catalog, table_schema, table_name, column_name, ordinal_position,
    column_default, is_nullable, data_type, character_maximum_length, character_octet_length,
    numeric_precision, numeric_precision_radix, numeric_scale from information_schema.columns
    where table_schema not in ('information_schema') and table_name not like 'dbt_%'
    limit 10;


----------------------------------------------
--         mysql information_schema
----------------------------------------------
-- mysql information_schema.tables
    select replace(TABLE_CATALOG, 'def', 'mysql') AS 'TABLE_CATALOG', TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, 
    TABLE_ROWS, AVG_ROW_LENGTH, DATA_LENGTH, MAX_DATA_LENGTH, INDEX_LENGTH, 
    AUTO_INCREMENT, CREATE_TIME, UPDATE_TIME from mysql.information_schema.tables
    where table_schema not in ('information_schema','performance_schema') and table_name not like 'dbt_%'
    limit 10;

-- mysql information_schema.columns
    select replace(TABLE_CATALOG, 'def', 'mysql') AS 'TABLE_CATALOG', TABLE_SCHEMA, TABLE_NAME,
    COLUMN_NAME, ORDINAL_POSITION, COLUMN_DEFAULT, IS_NULLABLE, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION from mysql.information_schema.columns
    where table_schema not in ('information_schema','performance_schema') and table_name not like 'dbt_%'
    limit 10;

