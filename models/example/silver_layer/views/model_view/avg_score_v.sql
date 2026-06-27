{{
    config(
        materialized="view"
    )
}}

select review_score , order_id from {{ref('reviews_v')}}  
where review_score < (select avg(review_score) as avg_score from {{ref('reviews_v')}}  )