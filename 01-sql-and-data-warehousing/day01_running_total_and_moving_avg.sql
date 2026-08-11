-- Day 1: Running Total & Moving Average
-- 1. 逐笔准确累计求和 (Running Total)
SELECT 
    transaction_id,
    user_id,
    trans_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY user_id 
        ORDER BY trans_date, transaction_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM user_transactions;

-- 2. 3笔交易移动平均 (Moving Average)
SELECT 
    transaction_id,
    user_id,
    trans_date,
    amount,
    AVG(amount) OVER (
        PARTITION BY user_id 
        ORDER BY trans_date, transaction_id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3_tx
FROM user_transactions;
