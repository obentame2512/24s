#Dernier status de chaque commande
create last_order_status as(
with max_date as (
  select order_id, 
  max(case when REGEXP_CONTAINS(event_date, '-') then PARSE_DATE("%F", event_date) 
  else PARSE_DATE("%d/%m/%Y", event_date)) as last_date
  from order_status group by order_id )
select order_status.order_id, 
max_date.last_date as event_date, 
order_status.status as last_status
from order_status inner join max_date on order_status.order_id = max_date.order_status 
and order_status.event_date = max_date.last_date)


#Nombre de produits livrés par famille de produit
create family_delivery_repartition as (
with product_last_status as (
    select products.product_id,
    products.product_family,
    items.order_id,
    last_order_status.order_status
    from products join items on products.product_id = items.product_id
    join last_order_status on items.order_id = last_order_status.order_id)
select product_family,
sum(case when order_status = '04_delivered' then 1 else 0)
from product_last_status group by product_family


