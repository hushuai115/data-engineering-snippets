CREATE TABLE user_logins(
    user_id int
    , login_date date
);

INSERT INTO user_logins
VALUES
    (101 , '2026-08-01')
    ,(101 , '2026-08-01') , -- 重复登录记录
(101 , '2026-08-02')
    ,(101 , '2026-08-03') , -- 连续 3 天
(101 , '2026-08-05')
    ,(101 , '2026-08-06') , -- 连续 2 天
(102 , '2026-08-01')
    ,(102 , '2026-08-03');

-- 不连续
WITH tmp01 AS (
    SELECT
        t.user_id
        , t.login_date
        , row_number() OVER (PARTITION BY t.user_id
            , t.login_date) rn
    FROM user_logins t
)
, tmp02 AS (
    SELECT
        t1.user_id
        , t1.login_date
    FROM
        tmp01 t1
    WHERE
        t1.rn = 1
)
, tmp03 AS (
    SELECT
        t2.user_id
        , t2.login_date
        , t2.login_date - cast(row_number() OVER (PARTITION BY t2.user_id ORDER BY t2.login_date) AS int) AS int_diff
    FROM
        tmp02 t2
)
, tmp04 AS (
    SELECT
        t3.user_id
        , t3.int_diff
        , count(*) max_log
        , max(t3.login_date)
        , min(t3.login_date)
    FROM
        tmp03 t3
    GROUP BY
        t3.user_id
        , t3.int_diff
)
SELECT
    t4.user_id
    , max(t4.max_log)
FROM
    tmp04 t4
GROUP BY
    t4.user_id;

