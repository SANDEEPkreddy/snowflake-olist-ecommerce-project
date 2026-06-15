{{
  config(
    materialized = "view"
  )
}}
select * from BRONZE.ORDERS_ITEMS_RAW