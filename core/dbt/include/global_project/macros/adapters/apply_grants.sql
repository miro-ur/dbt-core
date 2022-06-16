{% macro get_show_grant_sql(relation) %}
{{ return(adapter.dispatch("get_show_grant_sql", "dbt")(relation)) }}
{% endmacro %}

{% macro default__get_show_grant_sql(relation) %}
show grants on {{ relation.type }} {{ relation }}
{% endmacro %}

{% macro get_grant_sql(relation, grant_config) %}
{{ return(adapter.dispatch('get_grant_sql', 'dbt')(relation, grant_config)) }}
{% endmacro %}

{% macro default__get_grant_sql(relation, grant_config) %}
    {% for privilege in grant_config.keys() %}
        {% set recipients = grant_config[privilege] %}
        grant {{ privilege }} on {{ relation.type }} {{ relation }} to {{ recipients | join(', ') }}
    {% endfor %}
{% endmacro %}

{% macro get_revoke_sql(relation, grant_config) %}
{{ return(adapter.dispatch("get_revoke_sql", "dbt")(relation, grant_config)) }}
{% endmacro %}

{% macro default__get_revoke_sql(relation, grant_config) %}
revoke all on {{ relation }} from {{ grant_config["select"].join(", ") }}
where grantee != {{ target.user }}
{% endmacro %}

{% macro apply_grants(relation, grant_config, should_revoke) %}
{{ return(adapter.dispatch("apply_grants", "dbt")(relation, grant_config, should_revoke)) }}
{% endmacro %}

{% macro default__apply_grants(relation, grant_config, should_revoke=True) %}
{% if grant_config %}
    {% call statement('grants') %}
        {% if should_revoke %}
            {% set current_grants =  run_query(get_show_grant_sql(relation)) %}
            {{ get_revoke_sql(relation, grant_config) }}
        {% endif %}
        {{ get_grant_sql(relation, grant_config) }}
    {% endcall %}
{% endif %}
{% endmacro %}
