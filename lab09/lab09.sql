create table lab.nf_8_price_rules (
price_rule_code varchar(20) not null,
price_rule_name varchar(100) not null,

constraint pk_nf_8_price_rules primary key (price_rule_code),
constraint uq_nf_8_price_rule_name unique (price_rule_name)
);

create table lab.nf_8_bundles (
bundle_id integer not null,
bundle_name varchar(100) not null,
price_rule_code varchar(20) not null,

constraint pk_nf_8_bundles primary key (bundle_id),
constraint fk_nf_8_bundle_rule foreign key (price_rule_code)
references lab.nf_8_price_rules(price_rule_code)
);

create table lab.nf_8_products (
product_id varchar(32) not null,
category_name varchar(100) not null,

constraint pk_nf_8_products primary key (product_id)
);

create table lab.nf_8_bundle_items (
bundle_id integer not null,
product_id varchar(32) not null,
qty integer not null,

constraint pk_nf_8_bundle_items primary key (bundle_id, product_id),
constraint fk_nf_8_item_bundle foreign key (bundle_id)
references lab.nf_8_bundles(bundle_id),
constraint fk_nf_8_item_product foreign key (product_id)
references lab.nf_8_products(product_id),
constraint ck_nf_8_qty check (qty > 0)
);

insert into lab.nf_8_price_rules
(price_rule_code, price_rule_name)
values
('BASE', 'Базовое'),
('SALE', 'Акционное'),
('VIP', 'Особое');

insert into lab.nf_8_bundles
(bundle_id, bundle_name, price_rule_code)
select
bundle_id,
bundle_name,
case when bundle_code in ('1', '2') then 'BASE'
else 'SALE' end
from lab.bundles
where bundle_code in ('1', '2', '3');

insert into lab.nf_8_products
(product_id, category_name)
select distinct
p.product_id,
coalesce(p.product_category_name, 'Без категории')
from lab.bundle_items bi
inner join lab.nf_8_bundles b
on bi.bundle_id = b.bundle_id
inner join olist.products p
on bi.product_id = p.product_id
order by p.product_id
limit 4;

insert into lab.nf_8_bundle_items
(bundle_id, product_id, qty)
select
bi.bundle_id,
bi.product_id,
bi.quantity
from lab.bundle_items bi
inner join lab.nf_8_bundles b
on bi.bundle_id = b.bundle_id
inner join lab.nf_8_products p
on bi.product_id = p.product_id
order by bi.bundle_id, bi.product_id
limit 5;

select 'price_rules' as table_name, count(*)
from lab.nf_8_price_rules

union all

select 'bundles', count(*)
from lab.nf_8_bundles

union all

select 'products', count(*)
from lab.nf_8_products

union all

select 'bundle_items', count(*)
from lab.nf_8_bundle_items;

select
r.price_rule_code,
r.price_rule_name,
count(b.bundle_id) as bundle_count
from lab.nf_8_price_rules r
left join lab.nf_8_bundles b
on r.price_rule_code = b.price_rule_code
group by r.price_rule_code, r.price_rule_name
order by r.price_rule_code;

select
b.bundle_id,
b.bundle_name,
p.product_id,
p.category_name,
bi.qty,
r.price_rule_code,
r.price_rule_name
from lab.nf_8_bundle_items bi
inner join lab.nf_8_bundles b
on bi.bundle_id = b.bundle_id
inner join lab.nf_8_products p
on bi.product_id = p.product_id
inner join lab.nf_8_price_rules r
on b.price_rule_code = r.price_rule_code
order by b.bundle_id, p.product_id;

select
table_name,
constraint_name,
constraint_type
from information_schema.table_constraints
where table_schema = 'lab'
and table_name in (
'nf_8_bundles',
'nf_8_products',
'nf_8_price_rules',
'nf_8_bundle_items'
)
order by table_name, constraint_type;
