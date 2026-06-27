{{
    config(
        materialized = "view"
    )
}}

SELECT 
    seller_id, 
    price 
FROM {{ ref('orders_items_v') }}
WHERE price = (
    SELECT MAX(price) 
    FROM {{ ref('orders_items_v') }}
)