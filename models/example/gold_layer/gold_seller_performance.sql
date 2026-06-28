{{
    config(
        materialized='table'
    )
}}

SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(product_id) AS total_products_shipped,
    SUM(price) AS total_revenue,
    ROUND(AVG(price), 2) AS average_revenue,
    ROUND(AVG(price + freight_value), 2) AS average_order_value
FROM {{ ref('orders_items_v') }}
GROUP BY seller_id
ORDER BY total_revenue DESC;