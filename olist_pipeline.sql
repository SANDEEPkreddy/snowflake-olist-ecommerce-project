create warehouse Olist_wh
warehouse_size = 'small'
auto_suspend = 300
auto_resume = true

create database OLIST_BRAZILDB

create schema OLIST_SC;

create schema BRONZE;
create schema SLIVER;
create schema GOLD;

======== BRONZE LAYER CREATION =========
 drop schema sliver;
 drop schema bronze;
create or replace table BRONZE.customer_raw as
select * from olist_brazildb.olist_sc.customer;

create or replace table BRONZE.cateory_names_raw as
select * from olist_brazildb.olist_sc.category_names;


create or replace table BRONZE.Gelocation_raw as
select * from olist_brazildb.olist_sc.geolocation;

create or replace table BRONZE.Orders_raw as
select * from olist_brazildb.olist_sc.orders;

create or replace table BRONZE.Orders_items_raw as
select * from olist_brazildb.olist_sc.orders_items;

create or replace table BRONZE.Payments_raw as
select * from olist_brazildb.olist_sc.payments;

create or replace table BRONZE.Products_raw as
select * from olist_brazildb.olist_sc.products;

create or replace table BRONZE.Reviews_raw as
select * from olist_brazildb.olist_sc.reviews;

create or replace table BRONZE.Seller_raw as
select * from olist_brazildb.olist_sc.sellers



========== create sliver layer ======
create or replace table sliver.customer_clean as 
select distinct customer_id ,
trim (CUSTOMER_UNIQUE_ID) as customer_unique_id,
CUSTOMER_ZIP_CODE_PREFIX,customer_city,customer_state
from bronze.customer_raw where customer_id is not null;


create or replace table sliver.category_names_clean  as
select *  from bronze.cateory_names_raw;

create or replace table sliver.geolocation_clean as 
select * from bronze.gelocation_raw where geolocation_city is not null;

create or replace table sliver.orders_clean as
select distinct order_id , customer_id,order_status,order_purchase_timestamp,order_approved_at,order_delivered_carrier_date,order_delivered_customer_date,order_estimated_delivery_date from bronze.orders_raw where order_id is not null;

create or replace table sliver.orders_items as 
select distinct order_id , order_item_id,product_id,seller_id,shipping_limit_date,price,freight_value  from bronze.orders_items_raw where order_id is not null;

create or replace table sliver.payments_clean as 
select distinct order_id, payment_value, payment_installments, payment_sequential,payment_type from bronze.payments_raw where order_id is not null;

 create or replace table sliver.products_clean as
 select distinct product_id, product_category_name,product_length_cm,product_description_lenght,product_name_lenght,product_photos_qty,product_weight_g,product_width_cm, product_height_cm from bronze.products_raw where product_id is not null;

create or replace table sliver.reviews as 
select DISTINCT review_id, order_id, review_score,review_comment_message,review_comment_title,review_creation_date,review_answer_timestamp from bronze.reviews_raw where review_id is not null;
 
create or replace table sliver.sellers_clean as
select distinct seller_id, seller_zip_code_prefix,seller_state,seller_city from bronze.seller_raw where seller_id is not null;
 


delete   from sliver.orders_clean where order_id is null 
or customer_id is null
or order_approved_at is null
or order_delivered_carrier_date is null
or order_delivered_customer_date is null
or order_estimated_delivery_date is null
or order_id is null
or order_purchase_timestamp is null
or order_status is null


delete from olist_brazildb.sliver.customer_clean where customer_id is null
or customer_unique_id is null or 
customer_zip_code_prefix is null or 
customer_city is null or
customer_state is null;

delete from olist_brazildb.sliver.geolocation_clean where geolocation_zip_code_prefix is null or 
geolocation_lat is null or 
geolocation_lng is null or 
geolocation_city is null or 
geolocation_lng is null


delete from olist_brazildb.sliver.orders_items where order_id is null  or 
order_item_id is null or 
product_id is null or 
price is null or seller_id is null or 
shipping_limit_date is null or 
freight_value is null


delete from olist_brazildb.sliver.payments_clean where order_id is null or
payment_value is null or
payment_installments is null or 
payment_sequential is null or 
payment_type is null


delete from olist_brazildb.sliver.products_clean where product_id is null or 
product_category_name is null 
or product_length_cm is null or 
product_description_lenght is null or 
product_name_lenght is null or 
product_photos_qty is null or  product_weight_g is null or product_width_cm is null
show tables in olist_brazildb.sliver
select * from olist_brazildb.sliver.sellers_clean; 

delete from olist_brazildb.sliver.reviews where review_id is null or
order_id is null or review_score is null or review_comment_message is null 
or review_comment_title is null or review_creation_date is null or review_answer_timestamp is null

delete from olist_brazildb.sliver.sellers_clean where seller_id is null or 
seller_zip_code_prefix is null or seller_state is null or seller_city is  null;

select count(*) from bronze.orders_raw;
union all
select count(*) from sliver.orders_clean;
select * from olist_brazildb.olist_sc.orders where order_id is null or 
order_approved_at is null 
or order_delivered_carrier_date is null
or order_delivered_customer_date is null 
or order_estimated_delivery_date is null
or order_estimated_delivery_date is null 
or order_status is null 
or order_purchase_timestamp is null;
 
========== create golden layer ======
create or replace table olist_brazildb.gold.customer as 
select distinct customer_id ,
trim (CUSTOMER_UNIQUE_ID) as customer_unique_id,
CUSTOMER_ZIP_CODE_PREFIX,customer_city,customer_state
from bronze.customer_raw where customer_id is not null;


create or replace table olist_brazildb.gold.category_names  as
select *  from bronze.cateory_names_raw;

create or replace table olist_brazildb.gold.geolocation_clean as 
select * from bronze.gelocation_raw where geolocation_city is not null;

create or replace table olist_brazildb.gold.orders as
select distinct order_id , customer_id,order_status,order_purchase_timestamp,order_approved_at,order_delivered_carrier_date,order_delivered_customer_date,order_estimated_delivery_date from bronze.orders_raw where order_id is not null;

create or replace table olist_brazildb.gold.orders_items as 
select distinct order_id , order_item_id,product_id,seller_id,shipping_limit_date,price,freight_value  from bronze.orders_items_raw where order_id is not null;

create or replace table olist_brazildb.gold.payments_clean as 
select distinct order_id, payment_value, payment_installments, payment_sequential,payment_type from bronze.payments_raw where order_id is not null;

 create or replace table olist_brazildb.gold.products_clean as
 select distinct product_id, product_category_name,product_length_cm,product_description_lenght,product_name_lenght,product_photos_qty,product_weight_g,product_width_cm, product_height_cm from bronze.products_raw where product_id is not null;

create or replace table olist_brazildb.gold.reviews as 
select DISTINCT review_id, order_id, review_score,review_comment_message,review_comment_title,review_creation_date,review_answer_timestamp from bronze.reviews_raw where review_id is not null;
 
create or replace table olist_brazildb.gold.sellers_clean as
select distinct seller_id, seller_zip_code_prefix,seller_state,seller_city from bronze.seller_raw where seller_id is not null;
 
OLIST_BRAZILDB.BRONZE.PRODUCTS_RAW drop table olist_brazildb.gold.customer_clean
create or replace file format csv_format
type = 'csv'
field_optionally_enclosed_by = '"'
field_delimiter = ','
skip_header = 1
null_if = ('NULL','null',' ')

create or replace stage OLIST_STAGE
FILE_FORMAT = csv_format;
put 'file://C:\\Users\\madhu\\Downloads\\archive (12)\\olist_orders_dataset.csv' @OLIST_STAGE;
show stages;
SHOW TABLES;

#1 How many records exist in each table?
SELECT COUNT(*) AS TOTAL_RECORDS FROM olist_brazildb.olist_sc.ORDERS;
select count(*) as total_records from olist_brazildb.bronze.orders_raw;
select count(*) as total_records from olist_brazildb.sliver.orders_clean;

SELECT COUNT(*) AS TOTAL_RECORDS FROM ORDERS_ITEMS;
select count(*) as total_records from olist_brazildb.bronze.orders_items_raw;
select count(*) as total_records from olist_brazildb.sliver.orders_items;

# 2 How many customers belong to each state?
select count(*) as state_wise_count, customer_state from customer group by customer_state order by state_wise_count desc;

# 3 Which columns contain NULL values?
select column_name from information_schema.columns where table_name = 'CUSTOMER'

select count_if(customer_id is null) as customer_id_nulls,
count_if(CUSTOMER_UNIQUE_ID is null) as unique_if_null,
count_if(customer_zip_code_prefix is null) as zip_code_null,
count_if(customer_city is null) as customer_city_null,
count_if(customer_state is null) as customer_state_null
from olist_brazildb.olist_sc.customer;

select * from olist_brazildb.olist_sc.customer


# 4 How many orders have missing delivery dates
select count(order_id) as missingorder, order_status , order_delivered_customer_date from orders where  order_delivered_customer_date IS NULL group by order_status,order_delivered_customer_date order by missingorder desc;

# 5 Are there orders without payments?
select count(*) as without_payment from payments as p right join orders as o on p.order_id = o.order_id  where p.order_id is null;


# 6 Are there orders without reviews?

select count(*) as without_reviews from reviews as r right join orders as o on r.order_id = o.order_id where r.order_id is null;

select count(*) as without_review from reviews where review_comment_message is null and review_comment_title is null;

#  7 Which product categories are missing translations?
select * from products;
select * from category_names;
select * from orders_items


# 8 How many sellers belong to each state?
select count(*) as seller_state_count , seller_state from sellers group by seller_state  order by seller_state_count desc;

# 9 Which states have the most customers?
select customer_state , count(*) as customer_state_count from customer group by customer_state order by customer_state_count desc;

# 10 How many unique customers exist?
select count(distinct(customer_id)) as unique_customer from customer;

#11 Which cities have the most customers?
select customer_city , count(distinct (customer_id))  as city_customer_count from customer  group by customer_city order by city_customer_count desc;

# 12 How many customers made only one purchase?
select count(*) as one_orders from (select c.customer_unique_id,count(o.order_id) as total_orders from olist_brazildb.olist_sc.customer as c join olist_brazildb.olist_sc.orders as o on o.customer_id =c.customer_id group by c.customer_unique_id having COUNT(o.order_id) = 1) one_orders;

# 13 How many customers are repeat buyers?
select count(*) as repeat_ordes from ( select c.customer_unique_id , count(o.order_id) as total_orders from olist_brazildb.olist_sc.customer as c join olist_brazildb.olist_sc.orders as o on o.customer_id = c.customer_id group by c.customer_unique_id having total_orders > 1 order by total_orders desc) orders_re;

# 14 Who are the top 20 customers by spending?
select c.customer_unique_id , sum(p.payment_value) as total_spending from olist_brazildb.olist_sc.payments as p join olist_brazildb.olist_sc.orders as o on o.order_id = p.order_id 
join olist_brazildb.olist_sc.customer as c on o.customer_id = c.customer_id group by c.customer_unique_id order by total_spending desc limit 20;


# 15 What is the average spending per customer?
select avg(avg_spending) as avg_spending_per_cusomer from (select c.customer_unique_id , avg(p.payment_value) as avg_spending from olist_brazildb.olist_sc.payments as p join olist_brazildb.olist_sc.orders as o on o.order_id = p.order_id 
join olist_brazildb.olist_sc.customer as c on o.customer_id = c.customer_id group by c.customer_unique_id ) avg_per_customer;

# 16 Which customers placed the highest number of orders?

select c.customer_unique_id , count(o.order_id) as total_orders from olist_brazildb.olist_sc.customer as c join olist_brazildb.olist_sc.orders as o on o.customer_id = c.customer_id group by c.customer_unique_id having total_orders > 1 order by total_orders desc

# 17 What is the average order value per customer?

select avg(total_orders) as avg_order_value_per_customer from (select c.customer_unique_id , count(o.order_id) as total_orders from olist_brazildb.olist_sc.customer as c join olist_brazildb.olist_sc.orders as o on o.customer_id = c.customer_id group by c.customer_unique_id having total_orders > 1 )  avg_order_value_per_customers

# 18 What is the total revenue generated?
select sum(payment_value) as total_revenue from olist_brazildb.olist_sc.payments

# 19 What is the monthly revenue trend?
select month(o.order_purchase_timestamp) as months , sum(p.payment_value) as total_revenue_month from olist_brazildb.olist_sc.orders as o join olist_brazildb.olist_sc.payments as p on p.order_id = o.order_id group by MONTH(o.order_purchase_timestamp)
ORDER BY months;

# 20 What is the yearly revenue trend?

select year(o.order_purchase_timestamp) as years , sum(p.payment_value) as total_revenue_month from olist_brazildb.olist_sc.orders as o join olist_brazildb.olist_sc.payments as p on p.order_id = o.order_id group by year(o.order_purchase_timestamp)
ORDER BY years;

select date_trunc('year',o.order_purchase_timestamp) as years , sum(p.payment_value) as total_revenue_month from olist_brazildb.olist_sc.orders as o join olist_brazildb.olist_sc.payments as p on p.order_id = o.order_id group by years
ORDER BY years;

# 21 Which month generated the highest revenue?

select date_trunc('month',o.order_purchase_timestamp) as months , sum(p.payment_value) as total_revenue_month from olist_brazildb.olist_sc.orders as o join olist_brazildb.olist_sc.payments as p on p.order_id = o.order_id  group by months order by total_revenue_month desc limit 1;

#22 Which month generated the lowest revenue?

select date_trunc('month',o.order_purchase_timestamp) as months , sum(p.payment_value) as total_revenue_month from olist_brazildb.olist_sc.orders as o join olist_brazildb.olist_sc.payments as p on p.order_id = o.order_id  group by months order by total_revenue_month asc limit 1;

# 23 What is the average order value?
select sum(payment_value)/count(distinct order_id) as  avg_order_value from olist_brazildb.olist_sc.payments;

# 24 Which states generate the highest revenue?
select c.customer_state , sum(p.payment_value) as highest_revenue_state from olist_brazildb.olist_sc.payments as p join olist_brazildb.olist_sc.orders as o on o.order_id = p.order_id join  olist_brazildb.olist_sc.customer as c on o.customer_id = c.customer_id group by c.customer_state order by highest_revenue_state desc limit 5;

# 25 Which cities generate the highest revenue?
select c.customer_city , sum(p.payment_value) as highest_revenue_cities from olist_brazildb.olist_sc.payments as p join olist_brazildb.olist_sc.orders as o on o.order_id = p.order_id join  olist_brazildb.olist_sc.customer as c on o.customer_id = c.customer_id group by c.customer_city order by highest_revenue_cities desc limit 5;

# 26 Which product categories generate the highest revenue?
select p.product_category_name , sum(py.payment_value) as highest_revenue_pc from olist_brazildb.olist_sc.products as p join olist_brazildb.olist_sc.orders_items as o on o.product_id = p.product_id join olist_brazildb.olist_sc.payments as py on py.order_id=o.order_id group by p.product_category_name order by highest_revenue_pc desc;

# 27 Which product categories have the highest sales volume?
select p.product_category_name , count(o.order_id) as highest_sales_volume from olist_brazildb.olist_sc.products as p join olist_brazildb.olist_sc.orders_items as o on o.product_id = p.product_id join olist_brazildb.olist_sc.payments as py on py.order_id=o.order_id group by p.product_category_name order by highest_sales_volume  desc;


# 28 What are the top 20 best-selling products?
select * from olist_brazildb.olist_sc.products
select * from olist_brazildb.olist_sc.orders_items

# 29 Which categories have the highest average selling price?

select p.product_category_name , avg(py.payment_value) as highest_avg_selling_price from olist_brazildb.olist_sc.products as p join olist_brazildb.olist_sc.orders_items as o on o.product_id = p.product_id join olist_brazildb.olist_sc.payments as py on py.order_id=o.order_id group by p.product_category_name order by highest_avg_selling_price desc;

# 30 What percentage of revenue comes from each category?
select p.product_category_name , sum(py.payment_value) as category_revenue,
round(
(sum(py.payment_value) * 100 ) / (select sum(payment_value) from olist_brazildb.olist_sc.payments),2) as percentage_revenue   from olist_brazildb.olist_sc.products as p join olist_brazildb.olist_sc.orders_items as o on o.product_id = p.product_id join olist_brazildb.olist_sc.payments as py on py.order_id=o.order_id group by p.product_category_name order by percentage_revenue  desc;


# 31 Which categories have the lowest sales?
select p.product_category_name , count(o.order_id) as lowest_sales_volume from olist_brazildb.olist_sc.products as p join olist_brazildb.olist_sc.orders_items as o on o.product_id = p.product_id join olist_brazildb.olist_sc.payments as py on py.order_id=o.order_id group by p.product_category_name order by lowest_sales_volume  asc;

# 32 Which categories have the most reviews?
select p.product_category_name , count(distinct r.review_id) as most_review_volume from olist_brazildb.olist_sc.products as p join olist_brazildb.olist_sc.orders_items as o on o.product_id = p.product_id join olist_brazildb.olist_sc.reviews as r on r.order_id=o.order_id group by p.product_category_name order by most_review_volume  desc;

# 33 Which categories receive the best ratings?
select p.product_category_name , round(avg(r.review_score),2) as most_review_rating from olist_brazildb.olist_sc.products as p join olist_brazildb.olist_sc.orders_items as o on o.product_id = p.product_id join olist_brazildb.olist_sc.reviews as r on r.order_id=o.order_id group by p.product_category_name order by most_review_rating  desc;

# 34 Which categories receive the worst ratings?
select p.product_category_name , round(avg(r.review_score),2) as worst_review_rating from olist_brazildb.olist_sc.products as p join olist_brazildb.olist_sc.orders_items as o on o.product_id = p.product_id join olist_brazildb.olist_sc.reviews as r on r.order_id=o.order_id group by p.product_category_name order by worst_review_rating  asc;

# 35 How many sellers exist?
select count(distinct seller_id) as seller_count from olist_brazildb.olist_sc.sellers

# 36 Which states have the most sellers?
select seller_state ,count(distinct seller_id) as seller_count from olist_brazildb.olist_sc.sellers group by seller_state order by seller_count desc;

# 39 Which sellers generate the highest revenue?
select s.seller_id  ,sum(p.payment_value) as highest_revenue_seller from olist_brazildb.olist_sc.sellers as s join
 olist_brazildb.olist_sc.orders_items as o on o.seller_id = s.seller_id
 join olist_brazildb.olist_sc.payments as p on p.order_id = o.order_id group by s.seller_id order by highest_revenue_seller desc;

 # 40 Which sellers process the most orders?
 select s.seller_id  ,count( distinct o.order_id) as most_orders from olist_brazildb.olist_sc.sellers as s join
 olist_brazildb.olist_sc.orders_items as o on o.seller_id = s.seller_id group by s.seller_id order by most_orders desc;

# 41 What is the average revenue per seller?
select s.seller_id , count(o.order_id) as total_orders , round(sum(o.price),2) as total_revenue , round(avg(o.price),2) as avg_order_value from olist_brazildb.olist_sc.sellers as s join olist_brazildb.olist_sc.orders_items as o on o.seller_id = s.seller_id
group by s.seller_id order by total_revenue desc;

# 42 Rank sellers by revenue within each state.
select s.seller_id ,s.seller_state ,sum(o.price) as highest_revenue_seller,dense_rank() over(partition by s.seller_state order by sum(o.price) desc ) as seller_rank from olist_brazildb.olist_sc.sellers as s join
 olist_brazildb.olist_sc.orders_items as o on o.seller_id = s.seller_id
 join olist_brazildb.olist_sc.payments as p on p.order_id = o.order_id group by s.seller_id,s.seller_state order by highest_revenue_seller desc;

 # 43 Identify the top 5 sellers in each state.
select s.seller_id ,s.seller_state ,count(distinct o.order_id) as count_seller_order ,dense_rank() over(partition by s.seller_state order by count(distinct o.order_id)desc ) as seller_rank from olist_brazildb.olist_sc.sellers as s join
 olist_brazildb.olist_sc.orders_items as o on o.seller_id = s.seller_id
 join olist_brazildb.olist_sc.payments as p on p.order_id = o.order_id group by s.seller_id,s.seller_state QUALIFY seller_rank <= 5 order by count_seller_order desc;

 # 44 Which payment method is most frequently used?
 select payment_type ,count(payment_type) as payment_method_count  from olist_brazildb.olist_sc.payments group by payment_type order by  payment_method_count   desc 

 # 45 What percentage of orders use each payment type?
 select payment_type ,count(distinct order_id) as total_orders, round(count(distinct order_id) * 100 /(select count(distinct order_id) from olist_brazildb.olist_sc.payments),2) as payment_percentage from olist_brazildb.olist_sc.payments group by payment_type order by  payment_percentage    desc 

 # 46 What is the average payment amount by payment type?
 select payment_type,avg(payment_value) as avg_payment_amount from olist_brazildb.olist_sc.payments group by payment_type order by avg_payment_amount desc;

 # 47 Which payment method generates the most revenue
 select payment_type,sum(payment_value) as total_payment_amount from olist_brazildb.olist_sc.payments group by payment_type order by total_payment_amount desc;

 # 48 What is the average installment count?
 select avg(payment_installments) as avg_installments_count from olist_brazildb.olist_sc.payments

 # 49 Which installment range is most common?
 
 select payment_installments ,count(*) as installment_count from olist_brazildb.olist_sc.payments group by payment_installments order by installment_count desc

 # 50 How many orders are paid in a single installment?
 select count(distinct order_id) as count_orders from olist_brazildb.olist_sc.payments where payment_installments = 1;

 
