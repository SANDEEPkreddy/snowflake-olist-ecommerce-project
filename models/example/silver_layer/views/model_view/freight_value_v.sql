{{
    config(
        materialized = "view"
    )
}}
select distinct o.customer_id, oi.freight_value  from {{ref('orders_items_v')}} as oi join olist_brazildb.bronze.orders_raw as o on 
o.order_id = oi.order_id where oi.freight_value >( select avg(freight_value) as avg_freightvalue from {{ref('orders_items_v')}})