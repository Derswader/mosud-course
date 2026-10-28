select oi.seller_id
from order_items oi
inner join sellers s
on oi.seller_id = s.seller_id
group by oi.seller_id
having avg(freight_value) > 
(select avg(freight_value) from order_items oi);

select oi.seller_id
from order_items oi
group by oi.seller_id
having avg(oi.freight_value) > (
select avg(freight_value)
from order_items
)
and exists (
select 1
from sellers s
where s.seller_id = oi.seller_id
);

with seller_avg as (
select seller_id, avg(freight_value) as avg_freight
from order_items
group by seller_id
),
total_avg as (
select avg(freight_value) as avg_freight
from order_items
)
select sa.seller_id
from seller_avg sa
inner join sellers s on sa.seller_id = s.seller_id
cross join total_avg ta
where sa.avg_freight > ta.avg_freight;







select oi.seller_id
from order_items oi
inner join sellers s
on oi.seller_id = s.seller_id
group by oi.seller_id
having avg(freight_value) > 
(select avg(freight_value) from order_items oi)
except
select oi.seller_id
from order_items oi
group by oi.seller_id
having avg(oi.freight_value) > (
select avg(freight_value)
from order_items
)
and exists (
select 1
from sellers s
where s.seller_id = oi.seller_id
);



select oi.seller_id
from order_items oi
group by oi.seller_id
having avg(oi.freight_value) > (
select avg(freight_value)
from order_items
)
and exists (
select 1
from sellers s
where s.seller_id = oi.seller_id
)
except
select oi.seller_id
from order_items oi
inner join sellers s
on oi.seller_id = s.seller_id
group by oi.seller_id
having avg(freight_value) > 
(select avg(freight_value) from order_items oi);





select seller_id
from order_items oi
group by oi.seller_id
having avg(oi.freight_value) > all (
select avg(freight_value)
from order_items
);
