-- Employees Earning More Than Their Managers
select e.emp_id, e.salary from employee3 e JOIN employee3 f ON e.m_id = e.emp_id where e.salary > f.salary;

-- Write a solution to find all customers who never order anything.
select c.id, c.name from customers c LEFT JOIN orders o ON c.id = o.customerId where o.id IS NULL;

-- Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).
select w1.id from
WEATHER w1 JOIN WEATHER w2 ON DATEDIFF(w1.reportDate, w2.reportDate) = 1
WHERE w1.temperature > w2.temperature;

-- Find employees working on multiple projects using a self join.
select emp_id, count(project_id) as no_of_projects from employees group by emp_id having no_of_projects > 1;

-- Find customers whose total order amount is greater than the average order amount.
select c.c_name, sum(o.amount) AS total_order_amount from customers c JOIN orders o ON c.id = o.customerId
 group by c.c_name having sum(o.amount) > (select avg(amount) from orders);

-- Retrieve employees who earn the lowest salary in their department.
WITH minSal AS(
select department, min(salary) as min_salary from Employees group by department
)
select e.employee_id, e.name, e.department, e.salary from Employees e JOIN minSal m ON e.department = m.department where
e.salary = m.min_salary;

-- Determine the percentage of total sales contributed by each employee.
WITH TotalSales AS (
    SELECT SUM(total_amount) AS total_sales
    FROM orders
),
EmployeeSales AS (
    SELECT
        employee_id,
        SUM(total_amount) AS employee_sales
    FROM orders
    GROUP BY employee_id
)
SELECT
    e.employee_id,
    e.employee_sales,
    (e.employee_sales / t.total_sales) * 100 AS sales_percentage
FROM EmployeeSales e
JOIN TotalSales t
ON 1 = 1;  -- Join to access the total sales for each employee

