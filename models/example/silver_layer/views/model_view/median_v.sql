{{ config(
    materialized = "view"
)}}
with ranked_rn as (
select  payment_value ,row_number() over(order by payment_value)  as ranked , count(*) over()  as total 
from {{ref('payments_v')}} where payment_type = 'voucher'), 
median_as as ( select avg(payment_value) as median_value 
from ranked_rn where ranked in ( 
floor((total + 1) / 2)
,floor((total + 2) / 2)))
select  op.order_id , op.payment_value from {{ref('payments_v')}} as op 
cross join median_as as mv  WHERE op.payment_type = 'voucher'
AND op.payment_value > mv.median_value;