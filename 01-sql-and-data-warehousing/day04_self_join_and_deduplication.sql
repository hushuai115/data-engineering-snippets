CREATE TABLE employee_hierarchy(
    emp_id int
    , emp_name varchar(50)
    , salary DECIMAL(10 , 2)
    , manager_id int
    , updated_at timestamp
);

INSERT INTO employee_hierarchy
VALUES
    (1 , 'Boss Alice' , 15000.00 , NULL , '2026-08-01 10:00:00')
    ,(2 , 'Dev Bob' , 9000.00 , 1 , '2026-08-01 10:00:00')
    ,(2 , 'Dev Bob' , 9500.00 , 1 , '2026-08-02 11:00:00')
    ,(3 , 'Dev Charlie' , 16000.00 , 1 , '2026-08-01 10:00:00')
    ,(4 , 'Dev David' , 8000.00 , 2 , '2026-08-01 10:00:00');

WITH tmp01 AS (
    SELECT
        t.*
        , row_number() OVER (PARTITION BY t.emp_id ORDER BY t.updated_at DESC) rn
    FROM employee_hierarchy t
)
, tmp02 AS (
    SELECT
        *
    FROM
        tmp01 a
    WHERE
        a.rn = 1
)
SELECT
    t1.*
    , t2.emp_name AS manager_name
    , t2.salary AS manager_salary
FROM
    tmp02 t1
    INNER JOIN tmp02 t2 ON t2.emp_id = t1.manager_id
WHERE
    t1.salary > t2.salary;

