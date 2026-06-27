{{
    config(
        materialized = "view"
    )
}}

select * from {{ source('source', 'orders_items_raw') }}