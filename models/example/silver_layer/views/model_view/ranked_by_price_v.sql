{{
    config(
        materialized ="view"
    )
}}
select order_id,price,product_id , rank() over(partition by product_id order by price desc) as ranked_by_price from {{ref('orders_items_v')}}