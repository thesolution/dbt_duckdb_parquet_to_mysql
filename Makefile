
.PHONY: % #it's all fake

check-mysql-host:
ifeq ($(shell echo $${MYSQL_HOST}x ),x)
	$(error "MYSQL_HOST is not set. Try running `source env.sample`")
endif
	
check-mysql-password:
ifeq ($(shell echo $${MYSQL_PASSWORD}x ),x)
	$(error "MYSQL_PASSWORD is not set. Try running `source env.sample`")
endif

check-mysql-user:
ifeq ($(shell echo $${MYSQL_USER}x ),x)
	$(error "MYSQL_USER is not set. Try running `source env.sample`")
endif

check-mysql-database:
ifeq ($(shell echo $${MYSQL_DATABASE}x ),x)
	$(error "MYSQL_DATABASE is not set. Try running `source env.sample`")
endif

check-mysql-port:
ifeq ($(shell echo $${MYSQL_PORT}x ),x)
	$(error "MYSQL_PORT is not set. Try running `source env.sample`")
endif

check-env: check-mysql-host check-mysql-password check-mysql-user check-mysql-database check-mysql-port

check-docker:
ifeq ($(shell command -v docker 2> /dev/null),)
	$(error "docker not in the path")
endif

install-prereqs:
	pip install -r requirements.txt --require-virtualenv

docker-compose-up: check-env check-docker
ifeq ($(shell docker compose ps --service 2> /dev/null),)
	@echo "docker compose not running"
	docker-compose up --wait
else
	@echo "docker compose stack appears to be running"
endif





naive-build:
	@# 1. Render template with Jinja-cli until dbt-duckdb and dagster-duckdb
	@# update to work with duckdb==0.10.0.
	@# run `jinja --env-regex '^MYSQL_.*' --output duckdb.sql duckdb.j2.sql'
	@# 2. Run the rendered SQL file with duckdb-cli
	@# run `duckdb -echo < duckdb.sql`
	jinja --env-regex '^MYSQL_.*' --output naive/duckdb.sql naive/duckdb.j2.sql
	duckdb -echo naive/duckdb.duckdb < naive/duckdb.sql | tee docs/naive_duckdb.log


# grep --extended-regexp --ignore-case --only-matching '^[^=<>]*' requirements.txt 