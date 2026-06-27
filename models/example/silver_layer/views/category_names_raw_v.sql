{{
    config(
        materialized = "view"
    )
}}

select * from {{ source('source', 'category_names_raw') }}