create schema if not exists lab;

create table lab.bundles (
bundle_id integer generated always as identity,
bundle_code varchar(20) not null,
bundle_name varchar(100) not null,
seller_id varchar(32) not null,
status varchar(20) not null default 'active',

constraint pk_bundles primary key (bundle_id),
constraint uq_bundle_code unique (bundle_code),
constraint fk_bundle_seller foreign key (seller_id)
references olist.sellers(seller_id),
constraint ck_bundle_status check (status in ('active', 'inactive'))
);

create table lab.bundle_items (
bundle_id integer not null,
product_id varchar(32) not null,
quantity integer not null,

constraint pk_bundle_items primary key (bundle_id, product_id),
constraint fk_item_bundle foreign key (bundle_id)
references lab.bundles(bundle_id),
constraint fk_item_product foreign key (product_id)
references olist.products(product_id),
constraint ck_item_quantity check (quantity > 0)
);

create table lab.bundle_prices (
price_id integer generated always as identity,
bundle_id integer not null,
price numeric(12,2) not null,
valid_from date not null,
valid_to date,

constraint pk_bundle_prices primary key (price_id),
constraint fk_price_bundle foreign key (bundle_id) references lab.bundles(bundle_id),
constraint uq_bundle_price_date unique (bundle_id, valid_from),
constraint ck_bundle_price check (price > 0),
constraint ck_price_dates check (valid_to is null or valid_to >= valid_from)
);

truncate table lab.bundles, lab.bundle_prices, lab.bundle_items restart identity;

with seller as (
select seller_id
from olist.order_items
group by seller_id
having count(distinct product_id) >= 6
limit 1
)
insert into lab.bundles
(bundle_code, bundle_name, seller_id, status)
select
n::text,
'комплектик - ' || n,
seller_id,
'active'
from seller, generate_series(1,5) n;

with products as (
select distinct oi.product_id
from olist.order_items oi
inner join lab.bundles b
on oi.seller_id = b.seller_id
where b.bundle_code = '1'
order by oi.product_id
limit 6
),
numbered_products as (
select product_id,
row_number() over (order by product_id) as rn
from products
),
numbered_bundles as (
select bundle_id,
row_number() over (order by bundle_code) as rn
from lab.bundles
where bundle_code between '1' and '5'
)
insert into lab.bundle_items
(bundle_id, product_id, quantity)
select b.bundle_id, p.product_id, 1
from numbered_bundles b
inner join numbered_products p
on p.rn = 1 or p.rn = b.rn + 1;

insert into lab.bundle_prices
(bundle_id, price, valid_from)
select
bundle_id,
100 + row_number() over (order by bundle_code) * 50,
current_date
from lab.bundles
where bundle_code between '1' and '5';


update lab.bundle_items
set quantity = -5
where bundle_id = 1;

insert into lab.bundle_items
(bundle_id, product_id, quantity)
values (1, 'палпгщп', 2);

update lab.bundle_prices
set price = -100
where bundle_id = 1;

select table_name
from information_schema.tables
where table_schema = 'lab'
and table_name in ('bundles', 'bundle_items', 'bundle_prices');
