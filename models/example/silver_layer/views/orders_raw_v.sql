{{
  config(
    materialized = "views"
  )
}}

select * from BRONZE.ORDERS_RAW
