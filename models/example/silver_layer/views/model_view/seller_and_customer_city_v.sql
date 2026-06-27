{{
    config(
        materialized = "view"
    )
}}
select customer_city from {{ref('customer_raw_v')}}
union 
select seller_city from {{ref('sellers_raw_v')}}