{{
    config(
        materialized = "view"
    )
}}
select c.customer_id from {{ref('customer_raw_v')}} as c join olist_brazildb.bronze.orders_raw as o on c.customer_id = o.customer_id where c.customer_id not in 
(select customer_id from {{ref('orders_raw_v')}} where customer_id is not null)