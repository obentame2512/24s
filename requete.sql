#Dernier status de chaque commande
with max_date as (
  select order_id, 
  max(case when REGEXP_CONTAINS(event_date, '-') then PARSE_DATE("%F", event_date) 
  else PARSE_DATE("%d/%m/%Y", event_date)) as last_date
  from order_status )
select order_status.order_id, 
max_date.last_date as event_date, 
order_status.status as last_status
from order_status inner join max_date on order_status.order_id = max_date.order_status 
and order_status.event_date = max_date.last_date
