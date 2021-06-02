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

#Le chiffre d’affaires en euros livré par mois de livraison
create ca as (
with tmp as(
    select EXTRACT(MONTH from last_order_status.event_date) as delivery_month,
    last_order_status.event_date,
    last_order_status.order_status,
    orders.order_id,
    orders.currency,
    items.amount,
    currency.eur_value,
    currency.start_date
    from last_order_status join orders on last_order_status.order_id = orders.order_id
    join items on orders.order_id = items.order_id
    join currency on items.currency = currency.currency
    where last_order_status.event_date > currency.start_date and last_order_status.order_status = '04_delivered'
), tmp_max as(
    select order_id, max(start_date) as start_date from tmp group by order_id)
    select delivery_month, sum(amount * eur_value)
    from tmp join tmp_max
    on tmp.order_id = tmp_max.order_id and tmp.start_date = tmp_max.start_date
    group by delivery_month)
)

#Le chiffre d’affaires en euros livré par marque
create ca as (
with tmp as(
    select last_order_status.event_date,
    last_order_status.order_status,
    orders.order_id,
    orders.currency,
    items.amount,
    currency.eur_value,
    currency.start_date, 
    products.product_brand
    from last_order_status join orders on last_order_status.order_id = orders.order_id
    join items on orders.order_id = items.order_id
    join products on items.product_id = products.product_id
    join currency on items.currency = currency.currency
    where last_order_status.event_date > currency.start_date and last_order_status.order_status = '04_delivered'
), tmp_max as(
    select order_id, max(start_date) as start_date from tmp group by order_id)
    select product_brand, sum(amount * eur_value)
    from tmp join tmp_max
    on tmp.order_id = tmp_max.order_id and tmp.start_date = tmp_max.start_date
    group by product_brand)
)

