{{
    config(
        materialized = "table"
    )
}}


select count(order_id) as total_orders , month(order_purchase_timestamp) as months 
from {{ref('orders_raw_v')}} group by months order by total_orders desc