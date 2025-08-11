create table Employee1(
employee_id int,
department varchar(20),
name varchar(20),
job_title varchar(20),
salary int
);

insert into Employee1 values(1, 'HR', 'Alice', 'Manager', 30000);
insert into Employee1 values(2, 'IT', 'Bob', 'Developer', 35000);
insert into Employee1 values(3, 'HR', 'Carol', 'Senior Associate',20000);
insert into Employee1 values(4, 'IT', 'Dave', 'Sr. Developer', 50000);
insert into Employee1 values(5, 'Sales', 'Mark', 'Assistant', 15000);
insert into Employee1 values(6, 'Sales', 'Frank','Assistant',23000);
insert into Employee1 values(7, 'Sales', 'Eve', 'Intern' ,25000);
insert into Employee1 values(8, 'IT', 'Ronald', 'Developer', 35000);


create table Employee2(
emp_id int,
first_name varchar(20),
last_name varchar(20),
m_id int
);

insert into Employee2 values (4529, "Nancy", "Young", 4125);
insert into Employee2 values (4238, "Jon", "Simon", 4329);
insert into Employee2 values (4329, "Martina", "Candreva", 4125);
insert into Employee2 values (4009, "Klaus", "Koch", 4329);
insert into Employee2 values (4125, "Mafalda", "Ranieri", NULL);
insert into Employee2 values (4500, "Jakub", "Hrabal", 4529);
insert into Employee2 values (4118, "Moira", "Areas", 4952);
insert into Employee2 values (4012, "Jon", "Nilssen", 4952);
insert into Employee2 values (4952, "Sandra", "Rajkovic", 4529);
insert into Employee2 values (4444, "Seamus", "Quinn", 4329);


create table Emails(email varchar(40), last_used timestamp);

insert into Emails values ("x@y.com", '2024-07-02 00:00:00');
insert into Emails values ("x@y.com", '2024-07-01 00:00:00');
insert into Emails values ("x@y.com", '2024-07-04 00:00:00');
insert into Emails values ("x@y.com", '2024-07-04 00:00:00');
insert into Emails values ("y@m.com", '2024-07-01 00:00:00');
insert into Emails values ("z@c.com", '2024-07-01 00:00:00');
insert into Emails values ("y@m.com", '2024-07-03 00:00:00');

create table Employee3(
emp_id int,
name varchar(20),
salary int,
m_id int
);

insert into Employee2 values (101, "John",25000, 105);
insert into Employee2 values (102, "Jack", 35000, 105);
insert into Employee2 values (103, "Mark", 15000, 102);
insert into Employee2 values (104, "kelvin", 23000, 105);
insert into Employee2 values (105, "Sam", 100000, NULL);

create table Emails2(id varchar(5), email varchar(20));
insert into Emails2 values (1, "x@y.com");
insert into Emails2 values (2, "x@y.com");
insert into Emails2 values (3, "y@y.com");
insert into Emails2 values (4, "o@y.com");
insert into Emails2 values (5, "o@y.com");


create table customers(id varchar(5), name varchar(20));
create table orders(id varchar(5), customerId varchar(5));

insert into customers values (1, "John");
insert into customers values (2, "Don");
insert into customers values (3, "Ron");
insert into customers values (4, "Sam");
insert into customers values(5, "David");

insert into orders values(101, 2);
insert into orders values(102, 2);
insert into orders values(103, 4);

create table Weather(
id int,
recordDate date,
temperature int
);

insert into Weather values(1, '2000-01-01', 10);
insert into Weather values(2, '2000-01-02', 25);
insert into Weather values(3, '2015-01-03', 20);
insert into Weather values(4, '2015-01-04', 30);
insert into Weather values(5, '2015-01-05', 25);

CREATE TABLE special_orders (
    order_id INT PRIMARY KEY,
    cust_id INT,
    cust_name VARCHAR(100),
    order_date DATE,
    total_amount DECIMAL(10, 2)
);

INSERT INTO special_orders (order_id, cust_id, cust_name, order_date, total_amount) VALUES
(1, 1, 'John', '2025-01-01', 100.00),
(2, 1, 'John', '2025-02-01', 150.00),
(3, 1, 'John', '2025-03-01', 200.00),
(4, 2, 'Mark', '2025-02-15', 250.00),
(5, 2, 'Mark', '2025-04-01', 300.00),
(6, 3, 'Sarah', '2025-01-10', 120.00),
(7, 3, 'Sarah', '2025-03-05', 180.00);

CREATE TABLE Scores(
id int,
name varchar(20),
score int
)

INSERT INTO Scores VALUES(1, 'Ram', 311);
INSERT INTO Scores VALUES(2, 'Shyam', 321);
INSERT INTO Scores VALUES(3, 'Rakesh', 317);
INSERT INTO Scores VALUES(4, 'Suresh', 322);