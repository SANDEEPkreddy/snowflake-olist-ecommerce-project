{{
    config(
        materialized = "view"
    )
}}
select p.product_id , c._product_category_ame from {{ref('products_raw_v')}} as p inner join {{ref('category_names_raw_v')}} as c on
 p.product_category_name = c._product_category_name where c._product_category_ame like '%electronics%'