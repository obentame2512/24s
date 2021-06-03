with clean_order_status as (
      select order_id,
      status,
      case when REGEXP_CONTAINS(event_date, '-') then PARSE_DATE("%F", event_date) 
  else PARSE_DATE("%d/%m/%Y", event_date) end as event_date
  from test24s.order_status),
delivered_amount_currency as(
    select clean_order_status.event_date,
    clean_order_status.status,
    orders.order_id,
    orders.currency,
    items.amount,
    currency.eur_value,
    currency.start_date as currency_date,
    upper(products.product_brand) as product_brand
    from test24s.orders join clean_order_status on clean_order_status.order_id = orders.order_id
    join test24s.items on orders.order_id = items.order_id
    join test24s.products on items.product_id = products.product_id
    join test24s.currency on orders.currency = currency.currency
    where clean_order_status.event_date > currency.start_date and clean_order_status.status = '04_delivered'
), delivered_amount_currency_date as(
    select order_id, max(currency_date) as currency_date from delivered_amount_currency group by order_id)
    select product_brand, sum(amount * eur_value) as ca_month
    from delivered_amount_currency join delivered_amount_currency_date
    on delivered_amount_currency.order_id = delivered_amount_currency_date.order_id and delivered_amount_currency.currency_date = delivered_amount_currency_date.currency_date
    group by product_brand
