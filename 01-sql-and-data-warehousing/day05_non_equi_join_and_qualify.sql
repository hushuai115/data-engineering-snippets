-- 交易表
CREATE TABLE sales_transactions(
    tx_id int
    , product_id int
    , tx_date date
    , amount DECIMAL(10 , 2)
);

-- 价格历史维表 (SCD Type 2 时间段模型)
CREATE TABLE product_price_history(
    product_id int
    , price DECIMAL(10 , 2)
    , effective_start date
    , effective_end date
);

INSERT INTO sales_transactions
    VALUES (101 , 1 , '2026-01-15' , 100.00) , -- 应匹配价格 10.00
(102 , 1 , '2026-03-20' , 200.00) , -- 应匹配价格 12.50
(103 , 2 , '2026-02-01' , 150.00);

-- 无匹配价格（边界外）
INSERT INTO product_price_history
VALUES
    (1 , 10.00 , '2026-01-01' , '2026-03-01')
    ,(1 , 12.50 , '2026-03-01' , '2026-12-31');

SELECT
    t1.*
    , coalesce(t2.price , 0) AS price
    , t1.amount * coalesce(t2.price , 0) AS total_cost
FROM
    sales_transactions t1
    LEFT JOIN product_price_history t2 ON t1.product_id = t2.product_id
        AND t1.tx_date >= t2.effective_start
        AND t1.tx_date <= t2.effective_end;

