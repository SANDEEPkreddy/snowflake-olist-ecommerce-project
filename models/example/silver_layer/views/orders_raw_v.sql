{{
    config(
        materialized = "view"
    )
}}

select * from {{ source('source', 'orders_raw') }}