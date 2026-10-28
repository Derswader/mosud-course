--по заданию
select count(*) from customers c
inner join orders o
on c.customer_id = o.customer_id
left join order_reviews ord_r
on ord_r.order_id = o.order_id;

--антисоединение
select count(*) from customers c
where not exists (
select 1 from orders o
inner join order_reviews ord_r
on ord_r.order_id = o.order_id
where o.customer_id = c.customer_id)

--неправильно
select o.order_id, count(o.order_id) as order_cnt
from order_items oi
inner join orders o
on oi.order_id = o.order_id
inner join order_payments op
on o.order_id = op.order_id
group by o.order_id
order by order_cnt desc;

--правильнее
select o.order_id, count(o.order_id) as order_cnt
from orders o
where exists (
select 1 from order_payments op
where o.order_id = op.order_id
intersect
select 1 from order_items oi
where o.order_id = oi.order_id)
group by o.order_id
order by order_cnt desc;
