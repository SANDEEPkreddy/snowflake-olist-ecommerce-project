{{
    config(
        materialized = "table"
    )
}}

select sum(oi.price) as total_money_spend, o.customer_id from  {{ref('orders_items_v')}} as oi 
join {{ref('orders_raw_v')}} as o on o.ORDER_ID = oi.ORDER_ID group by o.CUSTOMER_ID order by total_money_spend desc;