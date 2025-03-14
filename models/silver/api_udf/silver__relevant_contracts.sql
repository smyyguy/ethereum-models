{{ config (
    materialized = "table",
    unique_key = "contract_address"
) }}

SELECT
    contract_address,
    'ethereum' AS blockchain,
    COUNT(*) AS events,
    MIN(block_number) + 1 AS first_block
FROM
    {{ ref('silver__logs') }}
GROUP BY
    1,
    2
HAVING
    COUNT(*) >= 25
