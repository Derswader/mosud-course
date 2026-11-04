create or replace view lab.v_order_summary as
select
o.order_id,
o.order_purchase_timestamp,
o.order_status,
c.customer_state,
count(oi.order_item_id) as item_count,
coalesce(sum(oi.price + oi.freight_value), 0) as total_amount
from olist.orders o
join olist.customers c
on o.customer_id = c.customer_id
left join olist.order_items oi
on o.order_id = oi.order_id
group by
o.order_id,
o.order_purchase_timestamp,
o.order_status,
c.customer_state;

drop materialized view if exists lab.mv_monthly_state_sales;

create materialized view lab.mv_monthly_state_sales as
select
date_trunc('month', order_purchase_timestamp)::date as month,
customer_state,
count(*) as orders_count,
sum(total_amount) as total_sales
from lab.v_order_summary
where order_status = 'delivered'
and order_purchase_timestamp is not null
group by
date_trunc('month', order_purchase_timestamp)::date,
customer_state;

refresh materialized view lab.mv_monthly_state_sales;

select *
from lab.mv_monthly_state_sales
order by month, customer_state;

with delivered_orders as (
select
order_id,
date_trunc('month', order_purchase_timestamp)::date as month,
customer_state,
total_amount
from lab.v_order_summary
where order_status = 'delivered'
and order_purchase_timestamp is not null
),
monthly_sales as (
select
month,
customer_state,
count(*) as orders_count,
sum(total_amount) as total_sales
from delivered_orders
group by month, customer_state
),
ranked_states as (
select
month,
customer_state,
orders_count,
total_sales,
dense_rank() over (
partition by month
order by total_sales desc
) as place
from monthly_sales
)
select *
from ranked_states
where place <= 3
order by month, place, customer_state;

create table if not exists lab.geo_tree (
node_id text primary key,
parent_id text references lab.geo_tree(node_id),
node_type text not null check (node_type in ('country', 'state', 'city')),
node_name text not null
);

truncate table lab.geo_tree;

insert into lab.geo_tree
(node_id, parent_id, node_type, node_name)
values ('BR', null, 'country', 'Brazil');

insert into lab.geo_tree
(node_id, parent_id, node_type, node_name)
select
'ST:' || customer_state,
'BR',
'state',
customer_state
from olist.customers
where customer_state is not null
group by customer_state;

with city_counts as (
select
customer_state,
customer_city,
count(*) as client_count
from olist.customers
where customer_state is not null
and customer_city is not null
group by customer_state, customer_city
),
ranked_cities as (
select
customer_state,
customer_city,
row_number() over (
partition by customer_state
order by client_count desc, customer_city
) as rn
from city_counts
)
insert into lab.geo_tree
(node_id, parent_id, node_type, node_name)
select
'CITY:' || customer_state || ':' || customer_city,
'ST:' || customer_state,
'city',
customer_city
from ranked_cities
where rn <= 20;

select *
from lab.geo_tree
order by node_type, parent_id, node_name;

with recursive subtree as (
select
node_id,
parent_id,
node_name,
0 as depth,
node_id as path,
array[node_id] as visited
from lab.geo_tree
where node_id = 'ST:PE'

union all

select
g.node_id,
g.parent_id,
g.node_name,
s.depth + 1,
s.path || ' -> ' || g.node_id,
s.visited || g.node_id
from lab.geo_tree g
join subtree s
on g.parent_id = s.node_id
where not (g.node_id = any(s.visited))
)
select
depth,
node_id,
path,
node_name
from subtree
order by depth, node_name;

with recursive ancestors as (
select
node_id,
parent_id,
node_name,
0 as depth,
node_id as path,
array[node_id] as visited
from lab.geo_tree
where node_id = (
select node_id
from lab.geo_tree
where parent_id = 'ST:PE'
and node_type = 'city'
order by node_name
limit 1
)

union all

select
g.node_id,
g.parent_id,
g.node_name,
a.depth + 1,
a.path || ' -> ' || g.node_id,
a.visited || g.node_id
from lab.geo_tree g
join ancestors a
on g.node_id = a.parent_id
where not (g.node_id = any(a.visited))
)
select
depth,
node_id,
path,
node_name
from ancestors
order by depth;

with recursive descendants as (
select
node_id as state_id,
node_id,
0 as depth,
array[node_id] as visited
from lab.geo_tree
where node_type = 'state'

union all

select
d.state_id,
g.node_id,
d.depth + 1,
d.visited || g.node_id
from lab.geo_tree g
join descendants d
on g.parent_id = d.node_id
where not (g.node_id = any(d.visited))
)
select
s.node_id,
s.node_name,
count(d.node_id) - 1 as descendant_count
from lab.geo_tree s
join descendants d
on s.node_id = d.state_id
where s.node_type = 'state'
group by s.node_id, s.node_name
order by descendant_count desc, s.node_id;
