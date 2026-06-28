{{
    config(
        materialized = "table"
    )
}}
select s.seller_city, s.seller_id,count(o.product_id) as most_successful_products_shiped  from 
{{ref('orders_items_v')}} as o join {{ref('sellers_raw_v')}} as s  on s.seller_id = o.seller_id 
join {{ref('orders_raw_v')}} as oi on o.order_id = oi.order_id where oi.order_status = 'delivered'  
group by s.seller_id,s.seller_city order by most_successful_products_shiped desc