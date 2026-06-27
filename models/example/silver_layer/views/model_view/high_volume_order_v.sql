{{
    config(
        materialized = "view"
    )
}}
select order_id , payment_value from {{ref('payments_v')}}  where payment_value > 500
union all
select order_id , payment_type from (select order_id, payment_value , count(payment_sequential) as cnt from {{ref('payments_v')}} where payment_type = 'voucher'
 group by order_id, payment_value) t where cnt < 4;