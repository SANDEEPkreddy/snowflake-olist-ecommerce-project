{{
    config(
        materialized = "view"
    )
}}

select  product_id ,product_description_lenght from {{ref('products_raw_v')}}
where product_description_lenght > ( select avg(product_description_lenght) from {{ref('products_raw_v')}})