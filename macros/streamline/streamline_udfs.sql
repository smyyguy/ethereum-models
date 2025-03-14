{% macro create_udf_get_token_balances() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_get_token_balances(
        json variant
    ) returns text api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/bulk_get_token_balances'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/bulk_get_token_balances'
    {%- endif %};
{% endmacro %}

{% macro create_udf_get_eth_balances() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_get_eth_balances(
        json variant
    ) returns text api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/bulk_get_eth_balances'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/bulk_get_eth_balances'
    {%- endif %};
{% endmacro %}

{% macro create_udf_get_reads() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_get_reads() returns text api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/bulk_get_reads'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/bulk_get_reads'
    {%- endif %};
{% endmacro %}

{% macro create_udf_get_contract_abis() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_get_contract_abis() returns text api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/bulk_get_contract_abis'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/bulk_get_contract_abis'
    {%- endif %};
{% endmacro %}

{% macro create_udf_get_blocks() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_get_blocks(
        json variant
    ) returns text api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/bulk_get_blocks'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/bulk_get_blocks'
    {%- endif %};
{% endmacro %}

{% macro create_udf_get_transactions() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_get_transactions(
        json variant
    ) returns text api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/bulk_get_transactions'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/bulk_get_transactions'
    {%- endif %};
{% endmacro %}

{% macro create_udf_get_beacon_blocks() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_get_beacon_blocks(
        json variant
    ) returns text api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/bulk_get_beacon_blocks'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/bulk_get_beacon_blocks'
    {%- endif %};
{% endmacro %}

{% macro create_udf_get_chainhead() %}
    CREATE EXTERNAL FUNCTION IF NOT EXISTS streamline.udf_get_chainhead() returns variant api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/get_chainhead'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/get_chainhead'
    {%- endif %};
{% endmacro %}

{% macro create_udf_get_beacon_chainhead() %}
    CREATE EXTERNAL FUNCTION IF NOT EXISTS streamline.udf_get_beacon_chainhead() returns variant api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/get_beacon_chainhead'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/get_beacon_chainhead'
    {%- endif %};
{% endmacro %}

{% macro create_udf_call_eth_node() %}
    CREATE EXTERNAL FUNCTION IF NOT EXISTS streamline.udf_json_rpc_call(
        DATA ARRAY
    ) returns variant api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/call_eth_node'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/call_eth_node'
    {%- endif %};
{% endmacro %}

{% macro create_udf_call_node() %}
    CREATE EXTERNAL FUNCTION IF NOT EXISTS streamline.udf_json_rpc_call(node_url VARCHAR, headers OBJECT, data ARRAY) returns variant api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/call_node'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/call_node'
    {%- endif %};
{% endmacro %}

{% macro create_udf_call_read_batching() %}
    CREATE EXTERNAL FUNCTION IF NOT EXISTS streamline.udf_json_rpc_read_calls(node_url VARCHAR, headers OBJECT, calls ARRAY) returns variant api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/call_read_batching'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/call_read_batching'
    {%- endif %};
{% endmacro %}

{% macro create_udf_api() %}
    CREATE EXTERNAL FUNCTION IF NOT EXISTS streamline.udf_api(
        method VARCHAR,
        url VARCHAR,
        headers OBJECT,
        DATA OBJECT
    ) returns variant api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/udf_api'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/udf_api'
    {%- endif %};
{% endmacro %}

{% macro create_udf_decode_array_string() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_decode(
        abi ARRAY,
        DATA STRING
    ) returns ARRAY api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/decode_function'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/decode_function'
    {%- endif %};
{% endmacro %}

{% macro create_udf_decode_array_object() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_decode(
        abi ARRAY,
        DATA OBJECT
    ) returns ARRAY api_integration = aws_ethereum_api AS {% if target.name == "prod" %}
        'https://e03pt6v501.execute-api.us-east-1.amazonaws.com/prod/decode_log'
    {% else %}
        'https://mryeusnrob.execute-api.us-east-1.amazonaws.com/dev/decode_log'
    {%- endif %};
{% endmacro %}
