{{
    config(
        materialized = "view"
    )
}}

select customer_city  as exclusive_customer_city from {{ref('customer_raw_v')}}
except
select seller_city as exclusive_customer_city from {{ref('sellers_raw_v')}}