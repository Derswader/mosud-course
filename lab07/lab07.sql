select
count(*) as total_orders,
count(case when order_approved_at is null then 1 end) as null_approved,
count(case when order_delivered_carrier_date is null then 1 end) as null_carrier_date,
count(case when order_delivered_customer_date is null then 1 end) as null_customer_date,
count(case when order_estimated_delivery_date is null then 1 end) as null_estimated_date
from orders;

select
count(*) as total_products,
count(case when product_category_name is null then 1 end) as null_category,
count(case when product_name_lenght is null then 1 end) as null_name_length,
count(case when product_description_lenght is null then 1 end) as null_description_length,
count(case when product_photos_qty is null then 1 end) as null_photos,
count(case when product_weight_g is null then 1 end) as null_weight,
count(case when product_length_cm is null then 1 end) as null_length,
count(case when product_height_cm is null then 1 end) as null_height,
count(case when product_width_cm is null then 1 end) as null_width
from products;

select
count(*) as total_reviews,
count(case when review_comment_title is null then 1 end) as null_title,
count(case when review_comment_message is null then 1 end) as null_message,
count(case when review_creation_date is null then 1 end) as null_creation_date,
count(case when review_answer_timestamp is null then 1 end) as null_answer_timestamp
from order_reviews;


select
count(*) as cnt,
count(order_delivered_customer_date) as order_delivered_customer_date_cnt,
count(*) - count(order_delivered_customer_date) as diff
from orders;

--неправильно
select count(*)
from orders
where order_delivered_customer_date = null;

--правильно
select count(*)
from orders
where order_delivered_customer_date is null;

select null is distinct from 'c' as result;
select null is distinct from null as result; -- для istinct null=null

create temporary table temp_ids (id text);
insert into temp_ids
select order_id
from orders
limit 1;
insert into temp_ids
values (null);

select count(*)
from orders
where order_id not in (select id from temp_ids); --0 т.к есть null

select count(*)
from orders o
where not exists (
select 1
from temp_ids t
where t.id = o.order_id
); -- работает корерктно

select count(distinct o.order_id)
from orders o
left join order_reviews r
on o.order_id = r.order_id
and r.review_score >= 4;

select count(distinct o.order_id)
from orders o
left join order_reviews r
on o.order_id = r.order_id
where r.review_score >= 4;

select
review_id,
coalesce(review_comment_message, 'нет') as comment
from order_reviews;

select
order_id,
price / nullif(freight_value, 0) as result
from order_items;



select
'доля заказов без фактической даты доставки' as a,
round(100.0 * count(case when order_delivered_customer_date is null then 1 end) / count(*), 2) as percent
from orders

union all

select
'доля товаров без категории',
round(100.0 * count(case when product_category_name is null then 1 end) / count(*), 2)
from products

union all

select
'доля отзывы без текста',
round(100.0 * count(case when review_comment_message is null then 1 end) / count(*), 2)
from order_reviews;
