{{
  config(
    materialized = "view"
  )
}}

select * from BRONZE.ORDERS_RAW

