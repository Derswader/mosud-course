with target_states as (
select 'MS' as state
union
select 'MT'
union
select 'GO'
)
select distinct p.product_category_name
from products p
where not exists (
select 1
from target_states s
where not exists (
select 1
from order_items oi
inner join orders o
on oi.order_id = o.order_id
inner join customers c
on o.customer_id = c.customer_id
inner join products p2
on oi.product_id = p2.product_id
where p2.product_category_name = p.product_category_name
and c.customer_state = s.state
and o.order_status = 'delivered'
)
);

select p.product_category_name
from products p
inner join order_items oi
on p.product_id = oi.product_id
inner join orders o
on oi.order_id = o.order_id
inner join customers cu
on cu.customer_id = o.customer_id
where cu.customer_state in ('MS', 'MT', 'GO')
and o.order_status = 'delivered'
and p.product_category_name is not null
group by p.product_category_name
having count(distinct cu.customer_state) = 3;

with target_states as (
select 'MS' as state
union
select 'MT'
union
select 'GO'
)
select distinct p.product_category_name
from products p
where p.product_category_name is not null
and not exists (
select s.state
from target_states s
except
select c.customer_state
from order_items oi
inner join orders o
on oi.order_id = o.order_id
inner join customers c
on o.customer_id = c.customer_id
inner join products p2
on oi.product_id = p2.product_id
where p2.product_category_name = p.product_category_name
and o.order_status = 'delivered'
and c.customer_state in ('MS', 'MT', 'GO')
);





with target_states as (
select 'MS' as state
union
select 'MT'
union
select 'GO'
)
select distinct p.product_category_name
from products p
where not exists (
select 1
from target_states s
where not exists (
select 1
from order_items oi
inner join orders o
on oi.order_id = o.order_id
inner join customers c
on o.customer_id = c.customer_id
inner join products p2
on oi.product_id = p2.product_id
where p2.product_category_name = p.product_category_name
and c.customer_state = s.state
and o.order_status = 'delivered'
)
)
except
select p.product_category_name
from products p
inner join order_items oi
on p.product_id = oi.product_id
inner join orders o
on oi.order_id = o.order_id
inner join customers cu
on cu.customer_id = o.customer_id
where cu.customer_state in ('MS', 'MT', 'GO')
and o.order_status = 'delivered'
and p.product_category_name is not null
group by p.product_category_name
having count(distinct cu.customer_state) = 3;






with category_orders as (
select p.product_category_name, cu.customer_state,
count(distinct o.order_id) as order_cnt
from products p
inner join order_items oi
on p.product_id = oi.product_id
inner join orders o
on oi.order_id = o.order_id
inner join customers cu
on cu.customer_id = o.customer_id
where cu.customer_state in ('MS', 'MT', 'GO')
and o.order_status = 'delivered'
and p.product_category_name is not null
group by p.product_category_name, cu.customer_state
)
select customer_state, order_cnt
from category_orders
where product_category_name = (
select product_category_name
from category_orders
group by product_category_name
having count(*) = 3
order by product_category_name
limit 1
)
order by customer_state;



