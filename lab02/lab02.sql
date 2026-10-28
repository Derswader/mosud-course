create or replace view cte as (
select p.product_id, cu.customer_state
from olist.products p
inner join olist.order_items oi
on p.product_id = oi.product_id
inner join olist.orders o
on oi.order_id = o.order_id
inner join olist.customers cu
on cu.customer_id = o.customer_id
and o.order_status = 'delivered'
);

create or replace temp view MT as (select product_id from cte where customer_state = 'MT');

create or replace temp view MS as (select product_id from cte where customer_state = 'MS');

-- кол-во MT
select count(*), count(distinct(product_id)) as cnt_dis from MT;

-- кол-во MS
select count(*), count(distinct(product_id)) as cnt_dis from MS;

-- кол-во MT + MS c удалением дубликатов
select count(*) as mt_union_ms from (
select * from MT
union 
select * from MS
);

-- кол-во MT + MS без удаления дубликатов
select count(*) as mt_unionALL_ms from (
select distinct(product_id) from MT
union all
select distinct(product_id) from MS
);

-- кол-во пересечений MT и MS
select count(*) as mt_intersect_ms from (
select product_id from MT
intersect
select product_id from MS
);

-- проверка коммутативности
select count(*) as ms_unionALL_mt from (
select * from MS
union
select * from MT
);

select count(*) as ms_intersect_mt from (
select distinct(product_id) from MS
intersect
select distinct(product_id) from MT
);

-- кол-во MT - MS
select count(*) as MT_except_MS_cnt from (
select * from MT
except
select * from MS
);

-- кол-во MS - MT
select count(*) as MS_except_MT_cnt from (
select * from MS
except
select * from MT
);

-- пересечение без INTERSECT, используя EXISTS.
select distinct MS.product_id from MS
where exists (select 1 from MT where MS.product_id = MT.product_id);

-- кол-во MT + MS вообще без избавления от дубликатов (возвращает мультимножество)
select count(*) as MS_unionALL_MT_cnt_multi from (
select * from MT
union all
select * from MS
)

/*
union возвращает множество уникальных строк

intersect возвращает множество общих элементов

except возвращает множество элементов первого запроса, которых нет во втором

приписка ALL сохраняет повторения, может возвращать мультимножество если данные повторяются между собой

union и intersect коммутативны, except некоммутативен
*/

