{{
    config(
        materialized = "view"
    )
}}


select customer_city  as shared_city_name from {{ref('customer_raw_v')}}
intersect
select seller_city as shared_city_name  from {{ref('sellers_raw_v')}}