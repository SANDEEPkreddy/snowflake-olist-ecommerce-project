{{
    config(
        materialized = "view"
    )
}}

select * from {{ source('source', 'reviews_raw') }}