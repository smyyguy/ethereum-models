{{ config(
    materialized = 'view',
    tags = ['balances'],
    persist_docs ={ "relation": true,
    "columns": true }
) }}

SELECT
    block_number,
    block_timestamp,
    user_address,
    contract_address,
    prev_bal_unadj,
    prev_bal,
    current_bal_unadj,
    current_bal,
    prev_bal_usd,
    current_bal_usd,
    bal_delta_unadj,
    bal_delta,
    bal_delta_usd,
    symbol,
    token_name,
    decimals,
    has_decimal,
    has_price
FROM
    (
        SELECT
            block_number,
            block_timestamp,
            base.address AS user_address,
            contract_address,
            COALESCE(LAG(balance) ignore nulls over(PARTITION BY base.address, contract_address
        ORDER BY
            block_number ASC), 0) AS prev_bal_unadj,
            CASE
                WHEN C.decimals IS NOT NULL THEN prev_bal_unadj / pow(
                    10,
                    C.decimals
                )
            END AS prev_bal,
            balance AS current_bal_unadj,
            CASE
                WHEN C.decimals IS NOT NULL THEN current_bal_unadj / pow(
                    10,
                    C.decimals
                )
            END AS current_bal,
            CASE
                WHEN C.decimals IS NOT NULL THEN ROUND(
                    prev_bal * price,
                    2
                )
            END AS prev_bal_usd,
            CASE
                WHEN C.decimals IS NOT NULL THEN ROUND(
                    current_bal * price,
                    2
                )
            END AS current_bal_usd,
            current_bal_unadj - prev_bal_unadj AS bal_delta_unadj,
            current_bal - prev_bal AS bal_delta,
            current_bal_usd - prev_bal_usd AS bal_delta_usd,
            C.symbol AS symbol,
            NAME AS token_name,
            C.decimals AS decimals,
            CASE
                WHEN C.decimals IS NULL THEN FALSE
                ELSE TRUE
            END AS has_decimal,
            CASE
                WHEN price IS NULL THEN FALSE
                ELSE TRUE
            END AS has_price
        FROM
            {{ ref("silver__token_balances") }}
            base
            LEFT JOIN {{ ref("core__dim_contracts") }} C
            ON C.address = contract_address
            LEFT JOIN {{ ref("core__fact_hourly_token_prices") }}
            ON DATE_TRUNC(
                'hour',
                block_timestamp
            ) = HOUR
            AND token_address = contract_address
        UNION ALL
        SELECT
            block_number,
            block_timestamp,
            base.address AS user_address,
            NULL AS contract_address,
            COALESCE(LAG(balance) ignore nulls over(PARTITION BY base.address
        ORDER BY
            block_number ASC), 0) AS prev_bal_unadj,
            prev_bal_unadj / pow(
                10,
                18
            ) AS prev_bal,
            balance AS current_bal_unadj,
            current_bal_unadj / pow(
                10,
                18
            ) AS current_bal,
            ROUND(
                prev_bal * price,
                2
            ) AS prev_bal_usd,
            ROUND(
                current_bal * price,
                2
            ) AS current_bal_usd,
            current_bal_unadj - prev_bal_unadj AS bal_delta_unadj,
            current_bal - prev_bal AS bal_delta,
            current_bal_usd - prev_bal_usd AS bal_delta_usd,
            'ETH' AS symbol,
            'Native Ether' AS token_name,
            18 AS decimals,
            TRUE AS has_decimal,
            CASE
                WHEN price IS NULL THEN FALSE
                ELSE TRUE
            END AS has_price
        FROM
            {{ ref("silver__eth_balances") }}
            base
            LEFT JOIN {{ ref("core__fact_hourly_token_prices") }}
            ON DATE_TRUNC(
                'hour',
                block_timestamp
            ) = HOUR
            AND token_address = '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
    )
WHERE
    current_bal_unadj <> prev_bal_unadj
