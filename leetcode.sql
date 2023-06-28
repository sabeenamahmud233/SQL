CREATE DATABASE leetcode;

USE leetcode;

-- 175. Combine Two Tables

CREATE TABLE IF NOT EXISTS Person (
    personId INT,
    firstName VARCHAR(255),
    lastName VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Address (
    addressId INT,
    personId INT,
    city VARCHAR(255),
    state VARCHAR(255)
);

insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen');
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob');

insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York');
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California');

-- Write an SQL query to report the first name, last name, city, 
-- and state of each person in the Person table. If the address of a personId 
-- is not present in the Address table, report null instead.

SELECT p.firstname,
p.lastname,
a.city,
a.state
FROM Person p
LEFT JOIN Address a
ON p.personID = a.personID;


-- 176. Second Highest Salary

CREATE TABLE IF NOT EXISTS Employee (
    id INT,
    salary INT
);

TRUNCATE TABLE Employee;

insert into Employee (id, salary) values ('1', '100');

insert into Employee (id, salary) values ('2', '100');
insert into Employee (id, salary) values ('2', '200');
insert into Employee (id, salary) values ('3', '300');

SELECT * FROM Employee;

-- Write an SQL query to report the second highest salary from the Employee table.
-- If there is no second highest salary, the query should report null.

DROP FUNCTION IF EXISTS getNthHighestSalary;
DELIMITER //
CREATE FUNCTION getNthHighestSalary(N INT) 
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE num INT;
  SET num = N - 1;
  RETURN (
      # Write your MySQL query statement below.  
      SELECT DISTINCT salary FROM Employee ORDER BY salary DESC LIMIT num,1
  );
END //
DELIMITER ;

SELECT getNthHighestSalary(2);

WITH distinctSal AS (
	SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
)
SELECT
	DISTINCT
	NTH_VALUE(salary, 2) OVER  (
		RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) getNthHighestSalary
FROM
	distinctSal;


-- 178. Rank Scores

CREATE TABLE IF NOT EXISTS Scores (
    id INT,
    score DECIMAL(3 , 2 )
);

Truncate table Scores;

insert into Scores (id, score) values ('1', '3.5');
insert into Scores (id, score) values ('2', '3.65');
insert into Scores (id, score) values ('3', '4.0');
insert into Scores (id, score) values ('4', '3.85');
insert into Scores (id, score) values ('5', '4.0');
insert into Scores (id, score) values ('6', '3.65');

SELECT * FROM Scores;


-- Write an SQL query to rank the scores.
-- The ranking should be calculated according to the following rules:
-- -> The scores should be ranked from the highest to the lowest.
-- -> If there is a tie between two scores, both should have the same ranking.
-- -> After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.

SELECT 
		score,
        DENSE_RANK() OVER (ORDER BY score DESC) AS 'rank' 
FROM Scores; 
 

-- 180. Consecutive Numbers

CREATE TABLE IF NOT EXISTS Logs (
    id INT,
    num INT
);

Truncate table Logs;

insert into Logs (id, num) values ('1', '1');
insert into Logs (id, num) values ('2', '1');
insert into Logs (id, num) values ('3', '1');
insert into Logs (id, num) values ('4', '2');
insert into Logs (id, num) values ('5', '1');
insert into Logs (id, num) values ('6', '2');
insert into Logs (id, num) values ('7', '2');

SELECT * FROM Logs;

-- Write an SQL query to find all numbers that appear at least three times consecutively.

SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2
	ON l1.id + 1 = l2.id
JOIN Logs l3
	ON l2.id + 1 = l3.id
WHERE l1.num = l2.num AND l2.num = l3.num AND l1.num = l3.num; 

-- Solution With LEAD Function
select
    distinct num as ConsecutiveNums
from
    (
        select
            *
            , lag(num, 1) over (order by id) as prev
            , lead(num, 1) over (order by id) as next
        from
            Logs
    ) t -- every derived table must have its own alias
where
    num = prev and num = next;


-- Solution with LEAD
with cte as (
    select 
		num,
		lead(num,1) over() num1,
		lead(num,2) over() num2
    from Logs
)
select distinct num AS ConsecutiveNums from cte where (num=num1) and (num=num2);


-- 181. Employees Earning More Than Their Managers
DROP TABLE IF EXISTS Employee;
CREATE TABLE IF NOT EXISTS Employee (
    id INT,
    name VARCHAR(255),
    salary INT,
    managerId INT
);

Truncate table Employee;

insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3');
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4');
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL);
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL);

-- Write an SQL query to find the employees who earn more than their managers.

SELECT 
    e1.*, e2.*
FROM
    Employee e1
        LEFT JOIN
    Employee1 e2 ON e1.managerId = e2.id
WHERE
    e1.salary > e2.salary;


-- 182. Duplicate Emails
CREATE TABLE IF NOT EXISTS Person (
    id INT,
    email VARCHAR(255)
);

Truncate table Person;

insert into Person (id, email) values ('1', 'a@b.com');
insert into Person (id, email) values ('2', 'c@d.com');
insert into Person (id, email) values ('3', 'a@b.com');

-- 183. Customers Who Never Order

CREATE TABLE IF NOT EXISTS Customers (
    id INT,
    name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Orders (
    id INT,
    customerId INT
);

Truncate table Customers;

insert into Customers (id, name) values ('1', 'Joe');
insert into Customers (id, name) values ('2', 'Henry');
insert into Customers (id, name) values ('3', 'Sam');
insert into Customers (id, name) values ('4', 'Max');

Truncate table Orders;

insert into Orders (id, customerId) values ('1', '3');
insert into Orders (id, customerId) values ('2', '1');

-- Write an SQL query to report all customers who never order anything.
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT name AS Employee
FROM Customers
WHERE id NOT IN (SELECT customerId FROM Orders);


-- 601. Human Traffic of Stadium

CREATE TABLE IF NOT EXISTS Stadium (
    id INT,
    visit_date DATE NULL,
    people INT
);

Truncate table Stadium;

insert into Stadium (id, visit_date, people) values ('1', '2017-01-01', '10');
insert into Stadium (id, visit_date, people) values ('2', '2017-01-02', '109');
insert into Stadium (id, visit_date, people) values ('3', '2017-01-03', '150');
insert into Stadium (id, visit_date, people) values ('4', '2017-01-04', '99');
insert into Stadium (id, visit_date, people) values ('5', '2017-01-05', '145');
insert into Stadium (id, visit_date, people) values ('6', '2017-01-06', '1455');
insert into Stadium (id, visit_date, people) values ('7', '2017-01-07', '199');
insert into Stadium (id, visit_date, people) values ('8', '2017-01-09', '188');



SELECT * FROM Stadium;

-- Write an SQL query to display the records with three or more rows with consecutive id's, 
-- and the number of people is greater than or equal to 100 for each.
-- Return the result table ordered by visit_date in ascending order.

-- Solution 1
WITH repeatedVisit AS (
	SELECT 
    id,
    visit_date,
    people AS people,
    LEAD (people, 1) OVER() AS people1,
    LEAD (people, 2) OVER() AS people2,
    LAG (people, 1) OVER() AS prevPeople1,
    LAG (people, 2) OVER() AS prevPeople2
    FROM Stadium    
)
SELECT id, visit_date, people1
FROM repeatedVisit
WHERE people >= 100 AND people1 >= 100 AND people2 >= 100
OR prevPeople1 >= 100 AND people >= 100 AND people1 >= 100
OR prevPeople2 >= 100 AND prevPeople1 >= 100 AND people1 >= 100
ORDER BY visit_date;


-- Solution 2
with new_group as(
    select id,
    visit_date,
    people,
    id - row_number() over(order by id) as new
    from Stadium
    where people >= 100
    )
    select id,visit_date,people 
    from new_group
    where new in(
        select new
        from new_group
        group by new
        having count(id) >= 3
        );



-- 184. Department Highest Salary
DROP TABLE IF EXISTS Employee;
CREATE TABLE IF NOT EXISTS Employee (
    id INT,
    name VARCHAR(255),
    salary INT,
    departmentId INT
);

DROP TABLE IF EXISTS Department;
CREATE TABLE IF NOT EXISTS Department (
    id INT,
    name VARCHAR(255)
);

Truncate table Employee;

insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '70000', '1');
insert into Employee (id, name, salary, departmentId) values ('2', 'Jim', '90000', '1');
insert into Employee (id, name, salary, departmentId) values ('3', 'Henry', '80000', '2');
insert into Employee (id, name, salary, departmentId) values ('4', 'Sam', '60000', '2');
insert into Employee (id, name, salary, departmentId) values ('5', 'Max', '90000', '1');

Truncate table Department;

insert into Department (id, name) values ('1', 'IT');
insert into Department (id, name) values ('2', 'Sales');

-- Write an SQL query to find employees who have the highest salary in each of the departments.

-- Solution 1 
SELECT 
	DISTINCT
	d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d
ON e.departmentId = d.id
WHERE 
     e.salary = (
					SELECT 
						MAX(salary) 
					FROM Employee 
                    WHERE departmentId = d.id
				);


-- Solution 2
SELECT 
	DISTINCT
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d
ON e.departmentId = d.id
WHERE (e.departmentId, e.salary) 
	IN (SELECT departmentId, MAX(salary) FROM Employee GROUP BY departmentId);
	


-- Solution 3
WITH CTE AS (
SELECT departmentId, MAX(salary) AS salary FROM Employee GROUP BY departmentId
)
SELECT 
	DISTINCT
	d.name AS Department,
	e.name AS Employee,
	e.salary AS Salary
FROM Employee e
JOIN CTE c
ON e.departmentID = c.departmentId
JOIN Department d
ON d.id = c.departmentId
WHERE c.salary = e.salary;


-- Solution 4
WITH CTE AS (
SELECT 
	departmentId,
    salary,
    DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC) AS salRank
FROM Employee 
)
SELECT 
	DISTINCT
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d
ON e.departmentId = d.id
JOIN CTE c
ON c.departmentId = d.id
WHERE c.salRank <= 1 AND c.salary = e.salary
ORDER BY Salary DESC;


-- 185. Department Top Three Salaries
DROP TABLE IF EXISTS Employee;

CREATE TABLE IF NOT EXISTS Employee (
    id INT,
    name VARCHAR(255),
    salary INT,
    departmentId INT
);

CREATE TABLE IF NOT EXISTS Department (
    id INT,
    name VARCHAR(255)
);

Truncate table Employee;

insert into Employee (id, name, salary, departmentId) values ('1', 'Joe', '85000', '1');
insert into Employee (id, name, salary, departmentId) values ('2', 'Henry', '80000', '2');
insert into Employee (id, name, salary, departmentId) values ('3', 'Sam', '60000', '2');
insert into Employee (id, name, salary, departmentId) values ('4', 'Max', '90000', '1');
insert into Employee (id, name, salary, departmentId) values ('5', 'Janet', '69000', '1');
insert into Employee (id, name, salary, departmentId) values ('6', 'Randy', '85000', '1');
insert into Employee (id, name, salary, departmentId) values ('7', 'Will', '70000', '1');

Truncate table Department;

insert into Department (id, name) values ('1', 'IT');
insert into Department (id, name) values ('2', 'Sales');

-- A company's executives are interested in seeing who earns the most money in each of the company's departments. 
-- A high earner in a department is an employee who has a salary in the top three unique salaries for that department.

-- Solution 1
WITH CTE AS (
SELECT 
	departmentId,
    salary,
    DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC) AS salRank
FROM Employee 
)
SELECT 
	DISTINCT
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d
ON e.departmentId = d.id
JOIN CTE c
ON c.departmentId = d.id
WHERE c.salRank <= 3 AND c.salary = e.salary
ORDER BY Salary DESC;


-- Solution 2
SELECT 
	d.name AS Department, 
    e.name AS Employee, 
    e.salary AS Salary
FROM Employee e
JOIN Department d ON e.departmentId = d.id
WHERE 
(
  SELECT COUNT(DISTINCT salary)
  FROM Employee
  WHERE departmentId = e.departmentId AND salary > e.salary
) < 3
ORDER BY d.name, e.salary DESC;

SELECT * FROM Employees;


-- Solution 1 Using Employees Table
WITH CTE AS (
SELECT 
	*,
    DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salRank
FROM Employees 
)
SELECT e.first_name,
	   e.department_id,
	   e.salary
FROM Employees e
JOIN CTE c
ON e.emp_id = c.emp_id
WHERE salRank <= 3
ORDER BY department_id, salary DESC;


-- Solution 2 Using Employees Table
SELECT DISTINCT
    e1.first_name, 
    e1.last_name,
    e1.department_id, 
    e1.salary
FROM
    Employees e1
        JOIN
    Employees e2 ON e1.emp_id = e2.emp_id
WHERE
    (SELECT 
            COUNT(DISTINCT salary)
        FROM
            Employees
        WHERE
            department_id = e1.department_id
                AND salary > e1.salary) < 3
ORDER BY e1.department_id , e1.salary DESC;


SELECT DISTINCT
    e1.first_name, 
    e1.last_name,
    e1.department_id, 
    e1.salary
FROM
    Employees e1
WHERE
    (SELECT 
            COUNT(DISTINCT salary)
        FROM
            Employees e2
        WHERE
            e2.department_id = e1.department_id
                AND e2.salary > e1.salary) < 3
ORDER BY e1.department_id , e1.salary DESC;


-- Find the Top N salary Using Function

DROP FUNCTION IF EXISTS maxSalFunction;

DELIMITER //
CREATE FUNCTION maxSalFunction (N INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE sal, M INT DEFAULT 0;
    SET M = N - 1;
	SELECT DISTINCT salary
    INTO sal
    FROM Employee
    WHERE salary = (SELECT DISTINCT salary FROM Employee ORDER BY salary DESC LIMIT M, 1);
    RETURN sal;    
END //
DELIMITER ;

SELECT maxSalFunction(3);


-- Find the Top salary of department by department ID using Function 
DROP FUNCTION IF EXISTS maxSalDepartmentFunction;

DELIMITER //
CREATE FUNCTION maxSalDepartmentFunction (deptID INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE sal INT DEFAULT 0;
	SELECT DISTINCT salary
    INTO sal
    FROM Employee
    WHERE 
		departmentId = deptID
        AND 
        salary IN (SELECT MAX(DISTINCT salary) FROM Employee GROUP BY departmentId);
    RETURN sal;    
END //
DELIMITER ;

SELECT maxSalDepartmentFunction(1);
SELECT maxSalDepartmentFunction(2);
SELECT maxSalDepartmentFunction(3);


-- Find top N salary of department using procedure
DROP PROCEDURE IF EXISTS topNSalDepFun;

DELIMITER //
CREATE PROCEDURE topNSalDepFun (deptID INT, N INT)
DETERMINISTIC
BEGIN
	SELECT 
	DISTINCT
    departmentId,
    salary
	FROM Employee e1
	WHERE 
		(
			SELECT COUNT(DISTINCT salary) 
			FROM Employee e2
			WHERE e1.departmentId = e2.departmentId
					AND 
					e2.salary > e1.salary
		)    < N
    AND
    departmentId = deptID
	ORDER BY departmentId, salary DESC;
END //
DELIMITER ;

CALL topNSalDepFun(1, 1);
CALL topNSalDepFun(1, 2);
CALL topNSalDepFun(1, 3);

CALL topNSalDepFun(1, 1);
CALL topNSalDepFun(2, 1);
CALL topNSalDepFun(3, 1);


-- 196. Delete Duplicate Emails
Create table If Not Exists PersonEmails (Id int, Email varchar(255));

Truncate table PersonEmails;

insert into PersonEmails (id, email) values ('1', 'john@example.com');
insert into PersonEmails (id, email) values ('2', 'bob@example.com');
insert into PersonEmails (id, email) values ('3', 'john@example.com');

# Please write a DELETE statement and DO NOT write a SELECT statement.
# Write your MySQL query statement below

DELETE p1
FROM PersonEmails p1, PersonEmails p2
WHERE p1.email = p2.email AND p1.id > p2.id;



-- 197. Rising Temperature

CREATE TABLE IF NOT EXISTS Weather (
    id INT,
    recordDate DATE,
    temperature INT
);

Truncate table Weather;

insert into Weather (id, recordDate, temperature) values ('1', '2015-01-01', '10');
insert into Weather (id, recordDate, temperature) values ('2', '2015-01-02', '25');
insert into Weather (id, recordDate, temperature) values ('3', '2015-01-03', '20');
insert into Weather (id, recordDate, temperature) values ('4', '2015-01-04', '30');
insert into Weather (id, recordDate, temperature) values ('5', '2015-01-06', '3');
insert into Weather (id, recordDate, temperature) values ('6', '2015-01-05', '-1');

SELECT * FROM Weather;

-- Write an SQL query to find all dates' Id with higher temperatures compared to its previous dates (yesterday).

SELECT 
	  w2.id
FROM Weather w1
JOIN Weather w2
ON date_add(w1.recordDate, INTERVAL 1 DAY) = w2.recordDate
	WHERE w2.temperature > w1.temperature
ORDER BY w2.recordDate;


Select w1.id 
from Weather w1,Weather w2
where 
	datediff(w1.recordDate,w2.recordDate)=1 
    AND 
    w1.temperature > w2.temperature;



-- 262. Trips and Users
CREATE TABLE IF NOT EXISTS Trips (
    id INT,
    client_id INT,
    driver_id INT,
    city_id INT,
    status ENUM('completed', 'cancelled_by_driver', 'cancelled_by_client'),
    request_at VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Users (
    users_id INT,
    banned VARCHAR(50),
    role ENUM('client', 'driver', 'partner')
);

Truncate table Trips;

insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');

Truncate table Users;

insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

/*
	The cancellation rate is computed by dividing the 
	
    number of canceled (by client or driver) requests with unbanned users 
    /
    by the total number of requests with unbanned users
    
    on that day.

	Write a SQL query to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day 
    between "2013-10-01" and "2013-10-03". Round Cancellation Rate to two decimal points.
*/

SELECT * FROM Trips;
SELECT * FROM Users;



SELECT 
    Request_at AS Day,
    ROUND(SUM(IF(Status = 'completed', 0, 1)) / COUNT(Status), 2) AS 'Cancellation Rate'
FROM
    Trips
WHERE
		Client_Id NOT IN 
        (SELECT 
            Users_Id
        FROM
            Users
        WHERE
            Banned = 'Yes')
        AND 
        Driver_Id NOT IN 
        (SELECT 
            Users_Id
        FROM
            Users
        WHERE
            Banned = 'Yes')
        AND Request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY Request_at;



with a as (
	select client_id, driver_id, request_at 
    from Trips
	where status in ("cancelled_by_driver", "cancelled_by_client")
    and client_id in (select users_id from Users where banned = "No")
    and driver_id in (select users_id from Users where banned = "No")),
    
b as (
	select count(client_id) as total_users, request_at 
    from Trips 
    where client_id in (select users_id from Users where banned = "No")
    and driver_id in (select users_id from Users where banned = "No")
    group by request_at)
     
select 
	b.request_at as "Day", 
    round((select count(a.client_id) from a where a.request_at = b.request_at)/b.total_users, 2) as "Cancellation Rate"
from b
where b.request_at between "2013-10-01" and "2013-10-03"
group by b.request_at;


-- 511. Game Play Analysis I

CREATE TABLE IF NOT EXISTS Activity (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT
);

Truncate table Activity;

insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-05-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');

SELECT * FROM Activity;

-- Write an SQL query to report the first login date for each player.

SELECT 
	player_id,
    MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;


-- 584. Find Customer Referee

CREATE TABLE IF NOT EXISTS Customer (
    id INT,
    name VARCHAR(25),
    referee_id INT
);

Truncate table Customer;

insert into Customer (id, name, referee_id) values ('1', 'Will', NULL);
insert into Customer (id, name, referee_id) values ('2', 'Jane', NULL);
insert into Customer (id, name, referee_id) values ('3', 'Alex', '2');
insert into Customer (id, name, referee_id) values ('4', 'Bill', NULL);
insert into Customer (id, name, referee_id) values ('5', 'Zack', '1');
insert into Customer (id, name, referee_id) values ('6', 'Mark', '2');

SELECT * FROM Customer;

-- Write an SQL query to report the names of the customer that are not referred by the customer with id = 2.

SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;


-- 585. Investments in 2016
CREATE TABLE IF NOT EXISTS Insurance (
    pid INT,
    tiv_2015 FLOAT,
    tiv_2016 FLOAT,
    lat FLOAT,
    lon FLOAT
);

Truncate table Insurance;

insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('1', '10', '5', '10', '10');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('2', '20', '20', '20', '20');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('3', '10', '30', '20', '20');
insert into Insurance (pid, tiv_2015, tiv_2016, lat, lon) values ('4', '10', '40', '40', '40');

SELECT * FROM Insurance;

/*
	Write an SQL query to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:

	have the same tiv_2015 value as one or more other policyholders, and
	are not located in the same city like any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
	Round tiv_2016 to two decimal places.
*/

SELECT
	ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE 
tiv_2015 IN (
SELECT tiv_2015 
FROM Insurance
GROUP BY tiv_2015
HAVING COUNT(*) > 1
)
AND
(lat, lon) IN (
SELECT lat, lon
FROM Insurance
GROUP BY lat, lon
HAVING COUNT(*) = 1
);



select
    round(sum(tiv_2016), 2) as tiv_2016
from
    (
        select
            *
            , count(*) over (partition by tiv_2015) as tiv_2015_cnt
            , count(*) over (partition by lat, lon) as location_cnt
        from
            Insurance
    ) t -- every derived table must have its own alias
where tiv_2015_cnt > 1 and location_cnt = 1;


-- 586. Customer Placing the Largest Number of Orders

CREATE TABLE IF NOT EXISTS orders (
    order_number INT,
    customer_number INT
);

Truncate table orders;

insert into orders (order_number, customer_number) values ('1', '1');
insert into orders (order_number, customer_number) values ('2', '2');
insert into orders (order_number, customer_number) values ('3', '3');
insert into orders (order_number, customer_number) values ('4', '3');

SELECT * FROM orders;

-- Write an SQL query to find the customer_number for the customer who has placed the largest number of orders.
-- The test cases are generated so that exactly one customer will have placed more orders than any other customer.

WITH temp AS (
			SELECT 
            customer_number,
            COUNT(*) AS total
			FROM orders
			GROUP BY customer_number
)
SELECT customer_number
FROM temp
WHERE total = (SELECT MAX(total) FROM temp);			


SELECT customer_number
FROM orders
GROUP BY customer_number
ORDER BY COUNT(order_number) DESC LIMIT 1;

WITH temp AS (
	SELECT
		customer_number,
		ROW_NUMBER() OVER (ORDER BY COUNT(order_number) DESC) ranking
	FROM orders
    GROUP BY customer_number
)
SELECT customer_number
FROM temp
WHERE ranking = 1;

WITH temp AS (
	SELECT
		customer_number,
		DENSE_RANK() OVER (ORDER BY COUNT(order_number) DESC) ranking
	FROM orders
    GROUP BY customer_number
)
SELECT customer_number
FROM temp
WHERE ranking = 1;

SELECT customer_number
FROM (
		SELECT
		customer_number,
		DENSE_RANK() OVER (ORDER BY COUNT(order_number) DESC) ranking
		FROM orders
		GROUP BY customer_number
	) temp
WHERE temp.ranking = 1;

-- 595. Big Countries

CREATE TABLE IF NOT EXISTS World (
    name VARCHAR(255),
    continent VARCHAR(255),
    area INT,
    population INT,
    gdp BIGINT
);

Truncate table World;

insert into World (name, continent, area, population, gdp) values ('Afghanistan', 'Asia', '652230', '25500100', '20343000000');
insert into World (name, continent, area, population, gdp) values ('Albania', 'Europe', '28748', '2831741', '12960000000');
insert into World (name, continent, area, population, gdp) values ('Algeria', 'Africa', '2381741', '37100000', '188681000000');
insert into World (name, continent, area, population, gdp) values ('Andorra', 'Europe', '468', '78115', '3712000000');
insert into World (name, continent, area, population, gdp) values ('Angola', 'Africa', '1246700', '20609294', '100990000000');

SELECT * FROM World;

/*
	A country is big if:

	- it has an area of at least three million (i.e., 3000000 km2), or
	- it has a population of at least twenty-five million (i.e., 25000000).
	- Write an SQL query to report the name, population, and area of the big countries.
*/

SELECT 
	name AS 'name',
    population AS 'population',
    area AS 'area'
FROM World
WHERE area >= 3000000 OR population >= 25000000;


-- 596. Classes More Than 5 Students

CREATE TABLE IF NOT EXISTS Courses (
    student VARCHAR(255),
    class VARCHAR(255)
);

Truncate table Courses;

insert into Courses (student, class) values ('A', 'Math');
insert into Courses (student, class) values ('B', 'English');
insert into Courses (student, class) values ('C', 'Math');
insert into Courses (student, class) values ('D', 'Biology');
insert into Courses (student, class) values ('E', 'Math');
insert into Courses (student, class) values ('F', 'Computer');
insert into Courses (student, class) values ('G', 'Math');
insert into Courses (student, class) values ('H', 'Math');
insert into Courses (student, class) values ('I', 'Math');

SELECT * FROM Courses;

-- Write an SQL query to report all the classes that have at least five students.

SELECT 
	class,
    COUNT(*) AS total
FROM Courses
GROUP BY class
HAVING total >= 5
ORDER BY COUNT(*) DESC;

SELECT class
FROM (
	SELECT 
		class,
		COUNT(*) AS total
	FROM Courses
	GROUP BY class
	HAVING total >= 5
	ORDER BY COUNT(*) DESC
    ) temp;

SELECT class
FROM Courses
GROUP BY class
ORDER BY COUNT(student) DESC LIMIT 1;



-- 1050. Actors and Directors Who Cooperated At Least Three Times

CREATE TABLE IF NOT EXISTS ActorDirector (
    actor_id INT,
    director_id INT,
    timestamp INT
);

Truncate table ActorDirector;

insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '0');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '1');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '2');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '3');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '4');
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '5');
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '6');

SELECT * FROM ActorDirector;

-- Write a SQL query for a report that provides the pairs (actor_id, director_id) where the actor has cooperated with the director at least three times.

SELECT 
	actor_id,
    director_id
FROM (
		SELECT 
			actor_id,
            director_id,
            COUNT(*) AS total
		FROM ActorDirector
        GROUP BY director_id, actor_id
        ) temp
WHERE temp.total >= 3;
        
WITH temp AS (
			SELECT 
				actor_id,
				director_id,
				COUNT(*) AS total
			FROM ActorDirector
			GROUP BY director_id, actor_id
		)
SELECT actor_id, director_id
FROM temp t
WHERE t.total >= 3;


SELECT 
    actor_id, director_id
FROM
    ActorDirector
GROUP BY actor_id , director_id
HAVING COUNT(timestamp) >= 3;


-- 1527. Patients With a Condition

CREATE TABLE IF NOT EXISTS Patients (
    patient_id INT,
    patient_name VARCHAR(30),
    conditions VARCHAR(100)
);

Truncate table Patients;

insert into Patients (patient_id, patient_name, conditions) values ('1', 'Daniel', 'YFEV COUGH');
insert into Patients (patient_id, patient_name, conditions) values ('2', 'Alice', '');
insert into Patients (patient_id, patient_name, conditions) values ('3', 'Bob', 'DIAB100 MYOP');
insert into Patients (patient_id, patient_name, conditions) values ('4', 'George', 'ACNE DIAB100');
insert into Patients (patient_id, patient_name, conditions) values ('5', 'Alain', 'DIAB201');
insert into Patients (patient_id, patient_name, conditions) values ('6', 'Daniel', 'SADIAB100');

SELECT * FROM Patients;

-- Write an SQL query to report the patient_id, patient_name and conditions of the patients who have Type I Diabetes. 
-- Type I Diabetes always starts with DIAB1 prefix.

SELECT
	patient_id,
    patient_name,
    conditions
FROM Patients
WHERE conditions LIKE '%DIAB1%';

SELECT
	patient_id,
    patient_name,
    conditions
FROM Patients
WHERE conditions REGEXP '\\bDIAB1' OR conditions REGEXP '\\BDIAB1';


SELECT
	patient_id,
    patient_name,
    conditions
FROM Patients
WHERE REGEXP_LIKE(conditions, '\\bDIAB1|\\BDIAB1');


-- 1070. Product Sales Analysis III

CREATE TABLE IF NOT EXISTS Sales1 (
    sale_id INT,
    product_id INT,
    year INT,
    quantity INT,
    price INT
);

CREATE TABLE IF NOT EXISTS Product (
    product_id INT,
    product_name VARCHAR(10)
);

Truncate table Sales1;

insert into Sales1 (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000');
insert into Sales1 (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000');
insert into Sales1 (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000');

Truncate table Product;

insert into Product (product_id, product_name) values ('100', 'Nokia');
insert into Product (product_id, product_name) values ('200', 'Apple');
insert into Product (product_id, product_name) values ('300', 'Samsung');

SELECT * FROM Sales1;

-- Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.

SELECT 
	s.product_id,
    s.year AS first_year,
    s.quantity,
    s.price
FROM Sales1 s
JOIN Product p
ON s.product_id = p.product_id
WHERE (p.product_id, s.year) IN (SELECT product_id, MIN(year) FROM Sales1 GROUP BY product_id);

WITH first_year_sales AS (
    SELECT 
        s.product_id,
        MIN(s.year) AS first_year
    FROM 
        Sales s
    INNER JOIN 
        Product p ON p.product_id = s.product_id
    GROUP BY 
        s.product_id
)

SELECT 
    f.product_id,
    f.first_year,
    s.quantity,
    s.price
FROM 
    first_year_sales f
JOIN 
    Sales s ON f.product_id = s.product_id AND f.first_year = s.year;


-- 1741. Find Total Time Spent by Each Employee

CREATE TABLE IF NOT EXISTS Employees1 (
    emp_id INT,
    event_day DATE,
    in_time INT,
    out_time INT
);

Truncate table Employees;

insert into Employees1 (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '4', '32');
insert into Employees1 (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '55', '200');
insert into Employees1 (emp_id, event_day, in_time, out_time) values ('1', '2020-12-3', '1', '42');
insert into Employees1 (emp_id, event_day, in_time, out_time) values ('2', '2020-11-28', '3', '33');
insert into Employees1 (emp_id, event_day, in_time, out_time) values ('2', '2020-12-9', '47', '74');

SELECT * FROM Employees1;

-- Write an SQL query to calculate the total time in minutes spent by each employee on each day at the office. 
-- Note that within one day, an employee can enter and leave more than once. The time spent in the office for a single entry is out_time - in_time.

SELECT
	event_day AS 'day',
    emp_id,
	SUM((out_time - in_time)) AS total_time
FROM Employees1
GROUP BY event_day, emp_id
ORDER BY event_day;


-- 1667. Fix Names in a Table

CREATE TABLE IF NOT EXISTS Users1 (
    user_id INT,
    name VARCHAR(40)
);

Truncate table Users1;

insert into Users1 (user_id, name) values ('1', 'aLice');
insert into Users1 (user_id, name) values ('2', 'bOB');

SELECT * FROM Users1;

SELECT
	user_id,
    CONCAT(UPPER(substring(name, 1, 1)), LOWER(SUBSTRING(name, 2))) AS 'name'
FROM Users1;


-- 602. Friend Requests II: Who Has the Most Friends

CREATE TABLE IF NOT EXISTS RequestAccepted (
    requester_id INT NOT NULL,
    accepter_id INT NULL,
    accept_date DATE NULL
);

Truncate table RequestAccepted;

insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09');

SELECT * FROM RequestAccepted;


-- Write an SQL query to find the people who have the most friends and the most friends number.
SELECT id, SUM(num) AS num
FROM (
		SELECT
			accepter_id AS id,
			COUNT(*) AS num
		FROM RequestAccepted
		GROUP BY accepter_id
		UNION
		SELECT
			requester_id AS id,
			COUNT(*) AS num
		FROM RequestAccepted
		GROUP BY requester_id
) temp
GROUP BY id
ORDER BY num DESC
LIMIT 1;



WITH maxFriends AS (
		SELECT
			accepter_id AS id,
			COUNT(accepter_id) AS num
		FROM RequestAccepted
		GROUP BY accepter_id
		UNION
		SELECT
			requester_id AS id,
			COUNT(requester_id) AS num
		FROM RequestAccepted
		GROUP BY requester_id
)
SELECT id, SUM(num) AS num
FROM maxFriends m
GROUP BY id
ORDER BY num DESC
LIMIT 1;


SELECT 
    requester_id AS id,
    (SELECT 
            COUNT(*)
        FROM
            RequestAccepted
        WHERE
            id = requester_id OR id = accepter_id) AS num
FROM
    RequestAccepted
GROUP BY requester_id
ORDER BY num DESC
LIMIT 1;


-- 2356. Number of Unique Subjects Taught by Each Teacher

CREATE TABLE IF NOT EXISTS Teacher (
    teacher_id INT,
    subject_id INT,
    dept_id INT
);

Truncate table Teacher;

insert into Teacher (teacher_id, subject_id, dept_id) values ('1', '2', '3');
insert into Teacher (teacher_id, subject_id, dept_id) values ('1', '2', '4');
insert into Teacher (teacher_id, subject_id, dept_id) values ('1', '3', '3');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '1', '1');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '2', '1');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '3', '1');
insert into Teacher (teacher_id, subject_id, dept_id) values ('2', '4', '1');

SELECT * FROM Teacher;

-- Write an SQL query to report the number of unique subjects each teacher teaches in the university.

SELECT 
    teacher_id, 
    COUNT(DISTINCT subject_id) AS cnt
FROM
    Teacher
GROUP BY teacher_id;















































































































































































