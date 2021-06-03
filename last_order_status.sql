with clean_order_status as (
      select order_id,
      status,
      case when REGEXP_CONTAINS(event_date, '-') then PARSE_DATE("%F", event_date) 
  else PARSE_DATE("%d/%m/%Y", event_date) end as event_date
  from test24s.order_status
  ),max_date as (
  select order_id, 
  max(event_date) as last_date
  from clean_order_status group by order_id )
select clean_order_status.order_id, 
max_date.last_date as event_date, 
clean_order_status.status as last_status
from clean_order_status inner join max_date on clean_order_status.order_id = max_date.order_id
and clean_order_status.event_date = max_date.last_date
