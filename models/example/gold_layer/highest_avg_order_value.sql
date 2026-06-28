{{
    config(
        materialized='table'
    )
}}

SELECT
    seller_id,
    ROUND(AVG(price + freight_value), 2) AS average_order_value
FROM {{ ref('orders_items_v') }}
GROUP BY seller_id
ORDER BY average_order_value DESC;