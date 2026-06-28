{{
    config(
        materialized='table'
    )
}}

SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM {{ ref('orders_items_v') }}
GROUP BY seller_id
ORDER BY total_orders DESC;