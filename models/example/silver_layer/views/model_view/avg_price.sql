{{
    config(
        materialized = "view"
    )
}}
SELECT product_id, price
FROM {{ref('orders_items_v')}}
WHERE price > (SELECT AVG(price) FROM {{ref('orders_items_v')}}); 