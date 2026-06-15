{{
  config(
    materialized = "view"
  )
}}

select * from {{ source('source', 'customer_raw') }}
