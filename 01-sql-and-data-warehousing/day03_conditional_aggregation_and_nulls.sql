SELECT
    t.user_id
    , count(*) AS total_orders
    , count(*) FILTER (WHERE t.order_status = 'COMPLETED') AS completed_orders
    , coalesce(sum(t.order_amount) FILTER (WHERE t.order_status = 'COMPLETED') , 0) AS total_completed_amount
    , round((count(1) FILTER (WHERE t.order_status = 'CANCELLED')) * 1.0 / count(*) , 2) AS cancellation_rate
FROM
    user_orders t
GROUP BY
    t.user_id
ORDER BY
    t.user_id;

