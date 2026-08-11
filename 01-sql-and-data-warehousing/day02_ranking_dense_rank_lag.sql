-- Day 2: DENSE_RANK & LAG
-- 1. 各部门薪资 Top 2 (含并列)
WITH ranked_employees AS (
    SELECT 
        emp_id,
        dept_id,
        emp_name,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY dept_id 
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employee_salaries
)
SELECT * FROM ranked_employees WHERE salary_rank <= 2;

-- 2. LAG 计算与上一位更高薪资者的差额
WITH salary_lag_data AS (
    SELECT 
        emp_id,
        dept_id,
        emp_name,
        salary,
        LAG(salary, 1, salary) OVER (
            PARTITION BY dept_id 
            ORDER BY salary DESC
        ) AS prev_higher_salary
    FROM employee_salaries
)
SELECT 
    emp_id,
    dept_id,
    emp_name,
    salary,
    prev_higher_salary,
    (prev_higher_salary - salary) AS salary_diff
FROM salary_lag_data;
