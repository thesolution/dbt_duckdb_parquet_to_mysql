{% macro attach_vars_mysql(alias) %}
{{ log("start attach_vars_mysql") }}

{% set host = env_var("MYSQL_HOST") %}
{% set user = env_var("MYSQL_USER") %}
{% set password = env_var("MYSQL_PASSWORD") %}
{% set database = env_var("MYSQL_DDATABASE") %}
{% set port = env_var("MYSQL_PORT") %}
{% set statement -%}
ATTACH 'host={{ host }} user={{ user }} password={{ password }} database={{ database }} port={{ port }}' as {{ alias }} (TYPE mysql_scanner);
{%- endset %}
{{ log("end attach_vars_mysql. returns: " ~ statement) }}
{{ statement }}
{% endmacro %}
