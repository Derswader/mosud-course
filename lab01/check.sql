-- кол-во строк по таблицам

select 'customers' as table_name, count(*) as row_count
from olist.customers
union all
select 'geolocation', count(*)
from olist.geolocation
union all
select 'orders', count(*)
from olist.orders
union all
select 'order_items', count(*)
from olist.order_items
union all
select 'order_payments', count(*)
from olist.order_payments
union all
select 'order_reviews', count(*)
from olist.order_reviews
union all
select 'products', count(*)
from olist.products
union all
select 'sellers', count(*)
from olist.sellers
union all
select 'product_category_name_translation', count(*)
from olist.product_category_name_translation;


-- null по таблицам

select 'customers.customer_id' as field, count(*) as null_count
from olist.customers
where customer_id is null
union all
select 'geolocation.geolocation_zip_code_prefix', count(*)
from olist.geolocation
where geolocation_zip_code_prefix is null
union all
select 'orders.order_id', count(*)
from olist.orders
where order_id is null
union all
select 'orders.customer_id', count(*)
from olist.orders
where customer_id is null
union all
select 'order_items.order_id', count(*)
from olist.order_items
where order_id is null
union all
select 'order_items.order_item_id', count(*)
from olist.order_items
where order_item_id is null
union all
select 'order_items.product_id', count(*)
from olist.order_items
where product_id is null
union all
select 'order_items.seller_id', count(*)
from olist.order_items
where seller_id is null
union all
select 'order_payments.order_id', count(*)
from olist.order_payments
where order_id is null
union all
select 'order_payments.payment_sequential', count(*)
from olist.order_payments
where payment_sequential is null
union all
select 'order_reviews.review_id', count(*)
from olist.order_reviews
where review_id is null
union all
select 'order_reviews.order_id', count(*)
from olist.order_reviews
where order_id is null
union all
select 'products.product_id', count(*)
from olist.products
where product_id is null
union all
select 'sellers.seller_id', count(*)
from olist.sellers
where seller_id is null
union all
select 'product_category_name_translation.product_category_name', count(*)
from olist.product_category_name_translation
where product_category_name is null;


-- проверка null при соединении

select 'orders -> customers' as relation, count(*) as orphan_count
from olist.orders o
left join olist.customers c
    on o.customer_id = c.customer_id
where o.customer_id is not null
    and c.customer_id is null
union all
select 'order_items -> orders', count(*)
from olist.order_items i
left join olist.orders o
    on i.order_id = o.order_id
where i.order_id is not null
    and o.order_id is null
union all
select 'order_items -> products', count(*)
from olist.order_items i
left join olist.products p
    on i.product_id = p.product_id
where i.product_id is not null
    and p.product_id is null
union all
select 'order_items -> sellers', count(*)
from olist.order_items i
left join olist.sellers s
    on i.seller_id = s.seller_id
where i.seller_id is not null
    and s.seller_id is null
union all
select 'order_payments -> orders', count(*)
from olist.order_payments p
left join olist.orders o
    on p.order_id = o.order_id
where p.order_id is not null
    and o.order_id is null
union all
select 'order_reviews -> orders', count(*)
from olist.order_reviews r
left join olist.orders o
    on r.order_id = o.order_id
where r.order_id is not null
    and o.order_id is null;


-- analyze

analyze olist.customers;
analyze olist.geolocation;
analyze olist.orders;
analyze olist.order_items;
analyze olist.order_payments;
analyze olist.order_reviews;
analyze olist.products;
analyze olist.sellers;
analyze olist.product_category_name_translation;

select version();
