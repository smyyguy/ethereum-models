{{ config(
    materialized = 'view',
    persist_docs ={ "relation": true,
    "columns": true }
) }}

SELECT
    contract_address AS feed_address,
    block_number,
    read_result AS latest_answer
FROM
    {{ ref('silver__chainlink_feeds') }}
