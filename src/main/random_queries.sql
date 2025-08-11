-- ① Get the 3rd Highest Salary from an Employee Table
SELECT DISTINCT salary
FROM employee
ORDER BY salary DESC
LIMIT 1 OFFSET 2;

-- ② Count of Users Who Logged in Daily for the Last 7 Days
SELECT user_id, COUNT(DISTINCT login_date)
FROM logins
WHERE login_date >= CURRENT_DATE - INTERVAL 6 DAY
GROUP BY user_id
HAVING COUNT(DISTINCT login_date) = 7;

-- ③ Find Duplicate Records in a Table
SELECT col1, COUNT(*)
FROM table_name
GROUP BY col1
HAVING COUNT(*) > 1;

-- ④ Get Customers with No Orders
SELECT c.customer_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- ⑤ Running Total of Sales by Date
SELECT order_date,
 SUM(sales) OVER (ORDER BY order_date) AS running_total
FROM orders;

-- ⑥ Top 2 Products Sold Per Category
SELECT *
FROM (
 SELECT *,
 RANK() OVER (PARTITION BY category ORDER BY sales DESC) AS rnk
 FROM products
) t
WHERE rnk <= 2;

-- ⑦ Find Gaps in Sequential IDs
SELECT id + 1 AS missing_id
FROM your_table
WHERE (id + 1) NOT IN (SELECT id FROM your_table);

-- ⑧ Find the Most Frequently Ordered Item
SELECT item_id
FROM orders
GROUP BY item_id
ORDER BY COUNT(*) DESC
LIMIT 1;

-- ⑨ Last Non-Null Value Per Group (Using LAG)
SELECT user_id,
 LAG(value, 1) IGNORE NULLS OVER (PARTITION BY user_id ORDER BY date) AS last_value
FROM events;

-- ⑩ Daily Active Users with Rolling 7-Day Average
SELECT log_date,
 COUNT(DISTINCT user_id) AS dau,
 AVG(COUNT(DISTINCT user_id)) OVER (ORDER BY log_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM logins
GROUP BY log_date;