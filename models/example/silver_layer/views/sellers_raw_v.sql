{{
    config(
        materialized = "view"
    )
}}

select * from {{ source('source', 'sellers_raw') }}