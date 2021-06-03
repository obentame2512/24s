with product_last_status as (
    select products.product_id,
    products.product_family,
    items.order_id,
    order_status.status
    from test24s.products join test24s.items on products.product_id = items.product_id
    join test24s.order_status on items.order_id = order_status.order_id)
select product_family,
sum(case when status = '04_delivered' then 1 else 0 end) as nb_delivered_products
from product_last_status group by product_family
