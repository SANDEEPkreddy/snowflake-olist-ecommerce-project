{{
    config(
        materialized = "view"
    )
}}

select * from {{ source('source', 'geolocation_raw') }}