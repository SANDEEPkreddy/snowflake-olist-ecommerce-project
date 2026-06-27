{{
    config(
        materialized = "view"
    )
}}

select * from {{ source('source', 'payments_raw') }}