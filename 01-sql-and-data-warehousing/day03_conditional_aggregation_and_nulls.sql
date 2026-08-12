select
    t.user_id,
    count(*) as total_orders,
    count(*) filter (where t.order_status = 'COMPLETED' ) as completed_orders,
    coalesce( sum(t.order_amount) filter (where t.order_status = 'COMPLETED'), 0) as total_completed_amount,
    round((count(1) filter (where t.order_status = 'CANCELLED')) * 1.0 / count(*), 2) as cancellation_rate
from user_orders t
group by t.user_id
order by t.user_id;