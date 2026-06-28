{{
    config(
        materialized = "table"
    )
}}

select s.seller_city, s.seller_id, sum(o.price) as total_revenue_by_seller,  from 
{{ref('orders_items_v')}} as o join {{ref('sellers_raw_v')}} as s  on s.seller_id = o.seller_id group by s.seller_id,s.seller_city