{{
    config(
        materialized = "view"
    )
}}

select c.customer_unique_id ,o.order_id,order_purchase_timestamp, 
row_number() over(partition by c.customer_unique_id order by o.order_purchase_timestamp desc) as index_num 
from {{ref('orders_raw_v')}} as o join {{ref('customer_raw_v')}} as c on c.CUSTOMER_ID = o.CUSTOMER_ID limit 4;
