{{ config(
    materialized = 'incremental',
    unique_key = 'id',
    cluster_by = ['block_timestamp::date'],
    tags = ['balances','diffs'],
    merge_update_columns = ["id"],
    post_hook = "ALTER TABLE {{ this }} ADD SEARCH OPTIMIZATION"
) }}

WITH base_table AS (

    SELECT
        block_number,
        block_timestamp,
        address,
        contract_address,
        balance,
        _inserted_timestamp
    FROM
        {{ ref('silver__token_balances') }}

{% if is_incremental() %}
WHERE
    _inserted_timestamp >= (
        SELECT
            MAX(
                _inserted_timestamp
            )
        FROM
            {{ this }}
    )
{% endif %}
)

{% if is_incremental() %},
update_records AS (
    SELECT
        A.block_number,
        A.block_timestamp,
        A.address,
        A.contract_address,
        A.balance,
        A._inserted_timestamp
    FROM
        {{ ref('silver__token_balances') }} A
    WHERE
        block_number > 15600000
        AND address IN (
            SELECT
                DISTINCT address
            FROM
                base_table
        )
),
incremental AS (
    SELECT
        block_number,
        block_timestamp,
        address,
        contract_address,
        balance,
        _inserted_timestamp
    FROM
        update_records qualify(ROW_NUMBER() over (PARTITION BY address, contract_address, block_number
    ORDER BY
        _inserted_timestamp DESC)) = 1
)
{% endif %},
FINAL AS (
    SELECT
        block_number,
        block_timestamp,
        address,
        contract_address,
        COALESCE(LAG(balance) ignore nulls over(PARTITION BY address, contract_address
    ORDER BY
        block_number ASC), 0) AS prev_bal_unadj,
        balance AS current_bal_unadj,
        _inserted_timestamp,
        {{ dbt_utils.surrogate_key(
            ['block_number', 'contract_address', 'address']
        ) }} AS id

{% if is_incremental() %}
FROM
    incremental
{% else %}
FROM
    base_table
{% endif %}
)
SELECT
    *
FROM
    FINAL
WHERE
    prev_bal_unadj <> current_bal_unadj
