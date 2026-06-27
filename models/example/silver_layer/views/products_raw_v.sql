{{
    config(
        materialized = "view"
    )
}}

select * from {{ source('source', 'products_raw') }}