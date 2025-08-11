-- Write a query to display the second highest salary from the Employee table without using the MAX function twice.
WITH SecHighSal AS (
select salary, DENSE_RANK() over (ORDER BY salary DESC) as rank from Employee
)
select salary AS second_highest_salary from SecHighSal where rank = 2;

-- Write a query to remove duplicate rows from a table.
WITH RankedPersons AS (
    SELECT id, name, RANK() OVER (PARTITION BY id ORDER BY name) AS row_nums
    FROM Person
)
DELETE FROM Person
WHERE EXISTS (
    SELECT 1
    FROM RankedPersons rp
    WHERE rp.row_nums > 1
    AND rp.id = Person.id
    AND rp.name = Person.name
);

-- Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).
WITH TempWindow AS(
select id, recordDate, temperature,
LAG(temperature) OVER (ORDER BY recordDate) as previous_temp,
LAG(recordDate) OVER (ORDER BY recordDate) as previous_date from Weather
)
select id from TempWindow
where previous_temp IS NOT NULL
  AND previous_temp < temperature
  AND DATEDIFF(recordDate, previous_date) = 1;

-- SQL query to find department wise top 3 salaries ?
WITH Dept_Sal AS (
select salary, department, rank() OVER (PARTITION BY DEPARTMENT ORDER BY salary DESC) as rank from Employees
)
select salary, department from Dept_Sal where rank < 4;

-- Calculate the moving average of sales for the past 3 months.

-- Retrieve the first and last order date for each customer.
WITH CustOrd AS (
select cust_id, cust_name, order_date,
 row_number() OVER (PARTITION BY cust_id ORDER BY order_date) as asc_rank,
 row_number() OVER (PARTITION BY cust_id ORDER BY order_date desc) as desc_rank
 from customers
)
select cust_id, cust_name,
 max(CASE WHEN asc_rank = 1 THEN order_date END) as first_order,
 max(CASE WHEN desc_rank = 1 THEN order_date END) as last_order
 from CustOrd
 group by cust_id, cust_name;

-- Find the Nth highest salary for each department using window functions.
WITH DeptSal AS (
    SELECT
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num
    FROM Employees
)
SELECT
    department,
    salary AS Nth_highest_salary
FROM DeptSal
WHERE row_num = N;  -- Replace N with the desired Nth position



-- Given a table of students and their GRE test scores,
-- write a query to return the two students with the closest test scores and their score difference.
WITH PrevScore AS (
select id, name, score,
LAG(score) OVER (ORDER BY score) as previous_score,
LAG(name) OVER (ORDER BY score) as previous_name
from Scores
)

select name, previous_name, ABS(score - previous_score) as difference from PrevScore
where previous_score IS NOT NULL
order by difference
limit 1;

-- Determine the time difference between consecutive logins for each user.
SELECT
  user_id,
  login_time,
  LAG(login_time) OVER (PARTITION BY user_id ORDER BY login_time) AS previous_login,
  EXTRACT(EPOCH FROM (login_time - LAG(login_time) OVER (PARTITION BY user_id ORDER BY login_time))) AS seconds_since_last_login
FROM user_logins
ORDER BY user_id, login_time;

-- Identify the 90th percentile salary for each department.
SELECT DISTINCT
  department,
  PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY salary) OVER (PARTITION BY department) AS percentile_90_salary
FROM employees;

-- Determine the 75th percentile of order delivery times for each region.
SELECT DISTINCT
  region,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY EXTRACT(EPOCH FROM delivery_time - order_time))
    OVER (PARTITION BY region) AS percentile_75_delivery_secs
FROM orders;

-- Median of the salary per company
WITH medianSal AS (
  SELECT
    company_id,
    salary,
    ROW_NUMBER() OVER (PARTITION BY company_id ORDER BY salary) AS rank_asc,
    ROW_NUMBER() OVER (PARTITION BY company_id ORDER BY salary DESC) AS rank_dsc
  FROM company_data
)
SELECT
  company_id,
  AVG(salary) AS median_salary
FROM medianSal
WHERE
  rank_asc = rank_dsc
  OR rank_asc + 1 = rank_dsc
  OR rank_asc = rank_dsc + 1
GROUP BY company_id
ORDER BY company_id;

-- Identify the 90th percentile salary for each department.
with xyz as (
select department, salary,
ntile(100) over (partition by department order by salary) as percentile_90_salary
from employees
)

select department, max(salary) from xyz where percentile_90_salary = 90 group by department_id

-- Determine the 75th percentile of order delivery times for each region.
WITH RankedOrders AS (
  SELECT
    region,
    delivery_time,
    NTILE(100) OVER (PARTITION BY region ORDER BY delivery_time) AS percentile_rank
  FROM orders
)
SELECT
  region,
  MAX(delivery_time) AS percentile_75_delivery_time
FROM RankedOrders
WHERE percentile_rank = 75
GROUP BY region;

-- Find the last order date per customer along with the number of days since that last order (from today)?

SELECT
  customer_id,
  MAX(order_date) AS last_order_date,
  DATEDIFF(CURRENT_DATE, MAX(order_date)) AS days_since_last_order
FROM orders
GROUP BY customer_id;

-- Find users whose most frequent device used is 'Mobile'
-- Table: user_sessions(user_id, device_type)
-- device_type: Mobile, Desktop, Tablet)

WITH DeviceUsage AS (
select user_id, device_type, count(*) as device_usage from user_sessions group by user_id, device_type
)
WITH RankDevice AS(
select user_id, device_type, device_usage, rank() over (partition by user_id order by device_usage) as rnk
from DeviceUsage
)

select user_id from RankDevice where rnk = 1 and device_type = 'Mobile';

-- Given a user login table with timestamps, find the hour of the day (0-23) when each user most frequently logs in.
-- If there is a tie, return the earliest hour.

WITH login_hours AS (
  SELECT
    user_id,
    EXTRACT(HOUR FROM login_time) AS login_hour
  FROM user_logins
),
hour_counts AS (
  SELECT
    user_id,
    login_hour,
    COUNT(*) AS cnt
  FROM login_hours
  GROUP BY user_id, login_hour
),
ranked_hours AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY user_id
           ORDER BY cnt DESC, login_hour ASC
         ) AS rn
  FROM hour_counts
)
SELECT user_id, login_hour AS most_frequent_hour
FROM ranked_hours
WHERE rn = 1;


-- You are given a table of user orders.
-- For each user, detect if there is any gap of more than 60 days between two consecutive orders.
-- Return a list of user IDs who had at least one such gap.

WITH order_gaps AS (
  SELECT
    user_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
  FROM orders
),
gap_check AS (
  SELECT
    user_id,
    DATEDIFF(order_date, prev_order_date) AS gap_days
  FROM order_gaps
  WHERE prev_order_date IS NOT NULL
)
SELECT DISTINCT user_id
FROM gap_check
WHERE gap_days > 60;

-- Given a table of user orders, identify all users who have placed at least one order in three consecutive
-- calendar months (e.g., Jan-Feb-Mar, or Nov-Dec-Jan of next year).

WITH months_only AS (
  SELECT DISTINCT
    user_id,
    DATE_TRUNC('month', order_date) AS order_month
  FROM orders
),
with_lag AS (
  SELECT
    user_id,
    order_month,
    LAG(order_month, 1) OVER (PARTITION BY user_id ORDER BY order_month) AS prev_month1,
    LAG(order_month, 2) OVER (PARTITION BY user_id ORDER BY order_month) AS prev_month2
  FROM months_only
),
qualified_users AS (
  SELECT
    user_id
  FROM with_lag
  WHERE
    prev_month1 IS NOT NULL AND
    prev_month2 IS NOT NULL AND
    DATEDIFF(order_month, prev_month1) = 30 AND
    DATEDIFF(prev_month1, prev_month2) = 30
)
SELECT DISTINCT user_id
FROM qualified_users;

-- Given tickets(ticket_id, status, updated_time) where status goes from 'open' → 'in progress' → 'resolved'
-- Compute time taken from 'open' to 'resolved' per ticket.

WITH ticket_states AS (
  SELECT
    ticket_id,
    MAX(CASE WHEN status = 'open' THEN updated_time END) AS open_time,
    MAX(CASE WHEN status = 'resolved' THEN updated_time END) AS resolved_time
  FROM tickets
  GROUP BY ticket_id
)
SELECT
  ticket_id,
  open_time,
  resolved_time,
  EXTRACT(EPOCH FROM resolved_time - open_time) AS resolution_seconds
FROM ticket_states
WHERE open_time IS NOT NULL AND resolved_time IS NOT NULL;

-- From user_activity(user_id, activity_date), find periods where the user was inactive for more than 5 days.

WITH gaps AS (
  SELECT
    user_id,
    activity_date,
    LAG(activity_date) OVER (PARTITION BY user_id ORDER BY activity_date) AS prev_date
  FROM user_activity
),
gap_periods AS (
  SELECT *,
    activity_date - prev_date AS gap
  FROM gaps
  WHERE prev_date IS NOT NULL AND activity_date - prev_date > INTERVAL '5 days'
)
SELECT * FROM gap_periods;
