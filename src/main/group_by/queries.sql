-- Find the number of employees in each department.
select department, count(*) from employee1 group by department;

-- Find the total salary by department.
select department, sum(salary) from employee1 group by department;

-- Find the average salary by department.
select department, avg(salary) from employee1 group by department;

-- Find departments with an average salary greater than 25000
select department, avg(salary) from employee1 group by department having avg(salary) > 25000;

--  Find the number of employees in each department for each job title.
select department, job_title, count(*) as employee_count from employee1 group by department, job_title;

-- Write a query to find the department with the highest average salary.
select department, avg(salary) from employee1 group by department order by avg(salary) desc limit 1;

-- Write a query to find employees who earn above the average salary within their department.
select e.employee_id, e.name, e.department, e.salary from employee1 e
JOIN(
select avg(salary) as avgSal, department from employee1 group by department
) as avg_salary_dept
ON e.department = avg_salary_dept.department
where e.salary > avg_salary_dept.avgSal;

-- Write a query to find the second highest salary for each department.
select e.department, max(e.salary) from employee1 e where salary < (select max(f.salary) from employee1 f where e.department = f.department) group by department ;

-- Find departments that have more than one employee earning above the average salary of their department.
WITH dept_avg AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
),
above_avg_emps AS (
    SELECT e.department, e.emp_id
    FROM employees e
    JOIN dept_avg d ON e.department = d.department
    WHERE e.salary > d.avg_salary
)
SELECT department
FROM above_avg_emps
GROUP BY department
HAVING COUNT(emp_id) > 1;


-- Write SQL Query to Count All Employees Under Each Manager
select e.m_id, m.first_name, m.last_name, count(e.emp_id) AS no_of_employees from Employee2 e JOIN Employee2 m ON e.m_id = m.emp_id
GROUP BY e.m_id, m.first_name, m.last_name ORDER BY no_of_employees DESC

-- Write a query to select distinct email id’s with latest timestamp
select email, max(last_used) as latest_used from Emails group by email;

-- Write a solution to report all the duplicate emails. Note that it's guaranteed that the email field is not NULL.
select email, count(email) from emails group by email having count(email) > 1;

-- A single number is a number that appeared only once in the MyNumbers table.
select max(num) from MyNumbers where num IN (select num from MyNumbers group by num having count(num) = 1);

-- Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
delete p1 from Persons p1 JOIN Persons p2 where p1.email = p2.email where p1.id > p2.id;

-- You have a table called "products" with columns "product_id", "product_name", "price", and "product_category".
-- Write a query to find the products that have a price greater than the average price of all products in their category,
-- but less than the maximum price in their category.

WITH AvgPrice AS(
select avg(price) as avg_price, max(price) as max_price, product_category from products group by product_category
)
select p.product_id, a.product_category, p.price from products p JOIN AvgPrice a ON p.product_category = a.product_category where
p.price > a.avg_price AND p.price < a.max_price;

-- You have a table called "orders" with columns "order_id", "customer_id", "order_date", and "total_amount".
-- Write a query to find the customers who have placed an order in the last 30 days, but not in the last 14 days.

select customer_id from orders where order_date BETWEEN DATEADD(DAY, -30, GETDATE()) AND DATEADD(DAY, -14, GETDATE()) group by customer_id having count(order_id) > 0;

-- Write a query to find all employees whose salaries exceed the company's average salary.
select emp_id, emp_name, salary from Employees where salary > (select avg(salary) from employees);

-- Write a query to retrieve the names of employees who work in the same department as 'John Doe'.
select e_name from employees where department = (select department from employees where e_name = 'John Doe');

-- Write a query to find all customers who have placed more than five orders.
select c.name, c.id, count(o.id) as num_orders from customers c join orders o on c.id = o.cid group by c.name, c.id having num_orders > 5;

-- Write a query to count the total number of orders placed by each customer.
select c.name, c.id, count(o.id) as total_num from customers c join orders o on c.id = o.cid group by c.name, c.id order by total_num desc;

-- Write a query to list all products that have never been sold.
select p.product_id from products p LEFT JOIN orders o ON p.product_id = o.product_id where o.order_id IS NULL;

-- Query to find employees who earn more than their managers
select e.emp_name from Employees e JOIN Employees m ON e.m_id = m.e_id where e.salary > m.salary;

-- Write a query to calculate the total revenue generated by each region.
SELECT
  region,
  SUM(revenue) AS total_revenue
FROM orders
GROUP BY region
ORDER BY total_revenue DESC;

-- write sql query to find count of Users Who Logged in Daily for the Last 7 Days

SELECT
    user_id
FROM
    user_logins
WHERE
   login_date BETWEEN current_date - interval '6 days' AND current_date
GROUP BY
    user_id
HAVING count(distinct(login_date)) = 7;

-- Find customers whose earliest phone activation date is after 2023-01-01
-- Table: customer_phones(custname, number, status, activation_date)

select custname, min(activation_date) from customer_phones group by custname where activation_date > '2023-01-01';

-- Find departments where the average salary of 'Manager' roles is greater than 100k
-- Table: employees(dept, role, salary)

   select dept from employees where role = 'Manager' group by dept having avg(salary) > 100000;

-- Find products where the max price difference between cities is greater than $20
-- Table: product_prices(product, city, price)

select product from product_prices group by product having max(price) - min(price) > 20;

-- Find customers who made at least 3 purchases, and none of them failed
Table: transactions(cust_id, txn_id, status) Status values: 'Success', 'Fail'

select cust_id from transactions group by cust_id
having count(txn_id) >= 3
AND
sum(case when status = 'Fail' then 1 else 0 end) = 0;

-- Find vendors where the sum of orders with 'Delayed' delivery is more than $5000
Table: orders(vendor_id, order_amount, delivery_status)

select vendor_id, sum(order_amount) as total_amount
 from orders
 where delivery_status = 'Delayed'
 group by vendor_id
 having total_amount > 5000;

-- Find movies where all reviews are rated above 3 stars
Table: reviews(movie_id, user_id, rating)

select movie_id from reviews group by movie_id having
 count(case when rating <= 3 then 1 end) = 0;

-- Find students who have passed all subjects
Table: marks(student_id, subject, score)

select student_id from marks group by student_id
having count(case when score < 40 then 1 end) = 0;

-- Find authors who have written books in more than 2 genres.
Table: books(author, title, genre)
select author from books group by author having count(distinct genre) > 2;

-- Find cities where all the hotels are rated at least 4 stars.
Table: hotels(city, hotel_name, rating)

select city from hotels group by city having count(case when rating < 4 then 1 end) = 0;

-- Find categories where the top product (by sales) has sold more than 10k units.
Table: sales(product_id, category, units_sold)

WITH RankProduct AS(
select product_id, category, units_sold, RANK() over (partition by category order by units_sold desc) as rnk from sales
)

select distinct category from RankProduct where rnk = 1 and units_sold > 100000

-- Find customers who have purchased at least one item from every available product category.
Table: purchases(cust_id, product_id)
       products(product_id, category)

WITH TotalCategoryCount AS (
select count(distinct(category)) as total_category from products
),
PurchaseWithCategory AS(
select p.cust_id, p.product_id, pr.category from purchases p JOIN products pr ON p.product_id = pr.product_id
),
select p.cust_id from PurchaseWithCategory p, TotalCategoryCount t
 group by cust_id having count(distinct (p.category)) =  t.total_category;

-- Find drivers who have never canceled a ride.
   Table: rides(driver_id, status)
   (Status = 'Completed', 'Cancelled')

select driver_id from rides group by driver_id having count(case when status = 'Cancelled' then 1 end) = 0;

-- Find brands where the average price of ‘Men’ products is higher than ‘Women’ products.
   Table: products(brand, gender, price)

select brand from products group by brand
having
   avg(case when gender = 'Men' then price end) >
   avg(case when gender = 'Women' then price end);

-- Find students who scored the same mark in all subjects.
   Table: scores(student_id, subject, score)

select student_id from scores group by student_id
having count(distinct score) = 1;

-- Find employees who have worked in more than 1 department over time.
   Table: employment(emp_id, department, start_date, end_date)

select emp_id from employment group by emp_id having count(distinct department) > 1;

-- Find stores where over 80% of sales come from 'Electronics' category.
   Table: transactions(store_id, category, amount)

select store_id from transactions group by store_id having
(sum(case when category = 'Electronics' then amount ELSE 0 END) / sum(amount)) * 100 > 80;

-- Find users who’ve placed more orders at night than during the day.
   Table: orders(user_id, order_time)
   (Assume you classify order_time into day/night)

 select user_id from orders group by user_id having count( case when order_time = 'night' then 1 end) > count( case when order_time = 'day' then 1 end);