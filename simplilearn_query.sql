USE simplilearn;

SELECT * FROM employees;

SELECT * FROM employees WHERE hire_date BETWEEN '2005-01-01' AND '2007-12-31';
SELECT * FROM employees WHERE hire_date BETWEEN '2005-01-01' AND '2007-12-31';
SELECT * FROM employees WHERE hire_date BETWEEN '2022-01-01' AND '2022-12-31';


SELECT * FROM employees
WHERE salary >= (SELECT AVG(salary) FROM employees);


SELECT city, count(*) AS total FROM employees GROUP BY city ORDER BY total DESC;


DROP TABLE IF EXISTS emp1;
CREATE TABLE emp1 (SELECT * FROM employees);

SELECT * FROM emp1;

INSERT INTO emp1 
SELECT * FROM employees WHERE salary IN (SELECT salary FROM employees WHERE salary > 55000);

SELECT city, ROUND(AVG(salary), 2) AS avg_sal FROM employees 
GROUP BY city;

SELECT city, ROUND(AVG(salary), 2) AS avg_sal FROM employees 
GROUP BY city
HAVING avg_sal > 69250;



-- FUNCTIONS

/* 
DELIMITER $$
CREATE FUNCTION function_name (
	parameter1 datatype
	parameter2 datatype
)

RETURNS datatype
DETERMINISTIC
BEGIN

-- LOGIC CODE --

END $$

*/ 

DROP FUNCTION IF EXISTS bonus_status;

/*
DELIMITER $$
CREATE FUNCTION bonus_status (
salary INT
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	IF salary < 55000
    THEN RETURN 'Eligible';
    ELSE RETURN 'Not Eligible';
    END IF;
END $$
*/


SELECT bonus_status(50000);
SELECT bonus_status(70000);


SELECT emp_id, first_name, last_name, bonus_status(salary) AS eligibility FROM employees;

-- CAST and CONVERT

SELECT cast(salary AS DECIMAL(10, 2)) FROM employees;
SELECT cast(AVG(salary) AS DECIMAL(10, 2)) AS avg_sal FROM employees;
SELECT cast(75 AS DECIMAL(10,1));
SELECT cast(75 AS DECIMAL(10,1));

SELECT cast(22.65 AS SIGNED);
SELECT CAST('26-02-20' AS DATE);


SELECT convert('25,2,22' ,  DATE);
SELECT convert(25.33 ,  SIGNED) AS casting;


SELECT * FROM employees;




-- COMMIT
-- ROLLBACK

SET AUTOCOMMIT = 0;
SET AUTOCOMMIT = 1;

DROP TABLE IF EXISTS items;

CREATE TABLE items (
id INT,
item VARCHAR(20),
price DECIMAL(6, 2)
);

SELECT * FROM items;

INSERT INTO items VALUES (1, 'tea', 25.65);
INSERT INTO items VALUES (2, 'Sugar', 12.75);

COMMIT;

UPDATE items
SET price = 25.50 WHERE id = 1;

UPDATE items
SET price = 12.50 WHERE id = 2;

ROLLBACK;

DELETE FROM items WHERE id = 2;

SELECT * FROM items;

ROLLBACK;


-- LIKE

SELECT * FROM employees WHERE first_name LIKE 'ab%';
SELECT * FROM employees WHERE first_name LIKE '%ab%';
SELECT * FROM employees WHERE first_name LIKE '%ab';
SELECT * FROM employees WHERE first_name LIKE '_ab%';
SELECT * FROM employees WHERE first_name LIKE '%ab_';
SELECT * FROM employees WHERE first_name LIKE '%___c';
SELECT * FROM employees WHERE first_name LIKE '___';
SELECT * FROM employees WHERE first_name LIKE 'L___y';
SELECT * FROM employees WHERE first_name LIKE 'L___y' && city = 'delhi';


-- Nth Highest salary

SELECT * FROM employees;

SELECT * FROM employees ORDER BY salary DESC;

SELECT * FROM employees
WHERE salary = (SELECT MAX(salary) AS max_sal FROM employees);

-- Second Highest Salary
SELECT MAX(salary) AS max_sal FROM employees
WHERE salary < (SELECT MAX(salary) AS max_sal FROM employees);

SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT 0,1;		-- Highest Salary
SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT 1,1;		-- 2nd Highest Salary
SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT 2,1;		-- 3rd Highest Salary
SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT 3,1;		-- 4th Highest Salary
SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT 4,1;		-- 5th Highest Salary
SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT 0,5;		-- Top 5 Highest Salary


SELECT 
    *
FROM
    employees
WHERE
    salary = (SELECT DISTINCT
            salary
        FROM
            employees
        ORDER BY salary DESC
        LIMIT 4 , 1);



-- DENSE RANK

SELECT DISTINCT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS salrank FROM employees;

SELECT * 
FROM (SELECT *, DENSE_RANK() OVER (ORDER BY salary DESC) AS salrank FROM employees) AS temp
WHERE salrank = 2;


SELECT * 
FROM (SELECT *, DENSE_RANK() OVER (ORDER BY salary DESC) AS salrank FROM employees) AS temp
WHERE salrank = 14;

CREATE VIEW tempRank AS (SELECT *, DENSE_RANK() OVER (ORDER BY salary DESC) AS salrank FROM employees);

SELECT * FROM temprank;
SELECT * FROM temprank WHERE salrank =2;

-- Method using NTH_VALUE
WITH distinctSal AS (
	SELECT DISTINCT salary
    FROM employees
    ORDER BY salary DESC
)
SELECT
	DISTINCT
	NTH_VALUE(salary, 5) OVER  (
		RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) getNthHighestSalary
FROM
	distinctSal;


-- PROCEDURES
USE simplilearn;

CREATE table dogs AS (SELECT * FROM mydb.dogs);

SELECT * FROM dogs;

DROP PROCEDURE IF EXISTS addDog;
DELIMITER $$
CREATE PROCEDURE addDog (
	IN dogId INT,
    OUT dogbreed VARCHAR(100)
)
BEGIN
	SELECT breed INTO dogbreed FROM dogs 
    WHERE id = dogID;
END $$

DELIMITER ;

SHOW PROCEDURE STATUS;
CALL addDog(20, @statusReport);
SELECT @statusReport;


-- RANK
SELECT * FROM dogs;

SELECT 
	*, 
	RANK() OVER (PARTITION BY gender ORDER BY id) AS rankDog
    FROM dogs;


SELECT gender, COUNT(*) AS total FROM dogs GROUP BY gender ORDER BY total DESC;


-- ROW NUMBER
SELECT * FROM dogs;

SELECT 
	*, 
	ROW_NUMBER() OVER (PARTITION BY gender ORDER BY id) AS rowNum
    FROM dogs;


DROP TABLE IF EXISTS cats ;
CREATE TABLE cats (
	id INT NOT NULL AUTO_INCREMENT, 
    name VARCHAR (50),
    age INT,
    addDate TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (id)
);


INSERT INTO cats (name, age) VALUES ('Bill',7);
INSERT INTO cats (name, age) VALUES ('Mice',3);
INSERT INTO cats (name, age) VALUES ('Timmy',4);
INSERT INTO cats (name, age) VALUES ('Toad',6);
INSERT INTO cats (name, age) VALUES ('Tipcy',9);
INSERT INTO cats (name, age) VALUES ('Rocky',2);
INSERT INTO cats (name, age) VALUES ('Caty',5);
INSERT INTO cats (name, age) VALUES ('Billy',5);

SELECT * FROM cats;

INSERT INTO cats (name, age) VALUES ('Toad',6);
INSERT INTO cats (name, age) VALUES ('Tipcy',9);
INSERT INTO cats (name, age) VALUES ('Rocky',2);
INSERT INTO cats (name, age) VALUES ('Toad',6);
INSERT INTO cats (name, age) VALUES ('Tipcy',9);
INSERT INTO cats (name, age) VALUES ('Rocky',2);

SELECT * FROM cats;
SELECT name, COUNT(*) total FROM cats GROUP BY name;


DELETE FROM cats
WHERE id IN (
SELECT id FROM (
					SELECT 
							*,
							ROW_NUMBER() OVER (PARTITION BY name ORDER BY name) AS rowNum
					FROM cats
				) AS temp WHERE rowNum > 1
);


SELECT * FROM employees;

CREATE INDEX empIndex ON employees (emp_id, hire_date, department_id);

SELECT * FROM employees WHERE first_name REGEXP 'l{2,}a';
SELECT * FROM employees WHERE first_name REGEXP 'll+';
SELECT * FROM employees WHERE first_name REGEXP 'xa?';

-- Common Table Expression (CTE)
/*
	WITH cte_name (column_names) AS (query)   
	SELECT * FROM cte_name;    
*/


-- Recursive CTE
/*
	WITH RECURSIVE cte_name (column_names) AS ( subquery )   
	SELECT * FROM cte_name;  
*/

WITH RECURSIVE   
odd_num_cte (id, num) AS  
(  
SELECT 1, 1   
UNION ALL  
SELECT id+1, num+3 from odd_num_cte where id < 5   
)  
SELECT * FROM odd_num_cte;  



-- ---------------------------------------------------------------------------------------
-- INTERVIEW QUESTIONS
-- 1. Third last record

SELECT *,
		ROW_NUMBER() OVER (ORDER BY emp_id DESC) AS row_num
FROM employees
LIMIT 2, 1;

WITH rowEmp AS (
SELECT *,
		ROW_NUMBER() OVER (ORDER BY emp_id DESC) AS row_num
FROM employees
)
SELECT * FROM rowEmp WHERE row_num = 3;


-- 2. Third last record
SELECT *
FROM olympics o1
JOIN olympics o2
ON o1.id = o2.id
WHERE o1.country = o2.country AND o1.type != o2.type;


DESC olympics;
SELECT * FROM olympics;

-- 3. Find the employees with highest and lowest salary.

SELECT 
    *
FROM
    employees
WHERE
    salary IN (SELECT 
            MAX(salary)
        FROM
            employees)
        OR salary IN (SELECT 
            MAX(salary)
        FROM
            employees);



-- 4. Find the 7th highest salary from emp
SELECT *,
	DENSE_RANK() OVER (ORDER BY salary DESC) AS sal_rank
FROM employees;

SELECT *
FROM (SELECT *,
	DENSE_RANK() OVER (ORDER BY salary DESC) AS sal_rank
FROM employees) AS temp
WHERE sal_rank = 7;


-- 5. FIND all the shows and countries with sort as india comes first and rest at asc order

SELECT * FROM netflix;
SELECT COUNT(*) FROM netflix;

SELECT title, type, production_countries FROM netflix
WHERE type = 'SHOW'
ORDER BY (CASE WHEN production_countries LIKE 'IN' THEN 0 ELSE 1 END) , production_countries;



-- -----------------------------------------------------------------------------------------
-- SQL QUESTIONS
-- https://techtfq.com/blog/learn-how-to-write-sql-queries-practice-complex-sql-queries


-- 1. Write a SQL Query to fetch all the duplicate records in a table.
SELECT first_name,
		COUNT(*) AS total
FROM employees
GROUP BY first_name
HAVING total > 1;


SELECT * FROM employees e1
JOIN employees e2
ON e1.first_name = e2.first_name AND e1.emp_id != e2.emp_id;


-- 2. Write a SQL query to fetch the second last record from employee table.
WITH rowEmp AS (
	SELECT *,
			ROW_NUMBER() OVER (ORDER BY emp_id DESC) AS rowNum
	FROM employees
)
SELECT * FROM rowEmp
LIMIT 1,1;


-- 3. Write a SQL query to display only the details of employees who either earn the highest salary or the lowest salary in each department from the employee table.

SELECT * FROM employees
WHERE salary IN (SELECT MAX(salary) OVER (PARTITION BY department_id) FROM employees) OR salary IN (SELECT MIN(salary) OVER (PARTITION BY department_id) FROM employees) ;

select x.*
from employees e
join (select *,
max(salary) over (partition by department_id) as max_salary,
min(salary) over (partition by department_id) as min_salary
from employees) x
on e.emp_id = x.emp_id
and (e.salary = x.max_salary or e.salary = x.min_salary)
order by x.department_id, x.salary;


-- 4. From the doctors table, fetch the details of doctors who work in the same hospital but in different specialty.

SELECT * 
FROM doctors d1
JOIN doctors d2
ON d1.hospital = d2.hospital
WHERE d1.hospital = d2.hospital AND d1.speciality != d2.speciality;

-- 5. Fetch the users who ordered in consecutively 3 or more times.

SELECT l1.*, l2.*, l3.*
FROM login_details l1
JOIN login_details l2
ON l1.login_id + 1 = l2.login_id
JOIN login_details l3
ON l1.login_id + 2 = l3.login_id
WHERE l1.user_name = l2.user_name AND l2.user_name = l3.user_name;

WITH userlogin AS (
	SELECT l1.login_id,
		l1.user_name, 
		l1.login_date
	FROM login_details l1
		JOIN login_details l2
		ON l1.login_id + 1 = l2.login_id
			JOIN login_details l3
			ON l1.login_id + 2 = l3.login_id
	WHERE l1.user_name = l2.user_name AND l2.user_name = l3.user_name
)
SELECT DISTINCT user_name FROM userlogin;


SELECT o.order_date, COUNT(*) AS total FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY o.order_date
HAVING total >= 3;


SELECT 
	c.id,
	c.first_name,
	COUNT(*) AS total 
FROM customers c
	JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.first_name
HAVING total <= 3;


WITH totalOrders AS (
	SELECT 
		c.id,
		c.first_name,
		COUNT(*) AS total 
	FROM customers c
	JOIN orders o ON c.id = o.customer_id
	GROUP BY c.id, c.first_name
)
SELECT * 
FROM customers c
JOIN totalOrders tos 
ON c.id = tos.id
WHERE total >= 3;



-- 6. From the students table, write a SQL query to interchange the adjacent student names.
SELECT * FROM students;

CREATE VIEW newStudents AS 
SELECT 
    *, 
    SUBSTRING(ID, 4, 9) AS newID
FROM
    students;
    


SELECT
		newID,
        first_name,
        (SELECT 
			CASE 
				WHEN newID % 2 = 1 THEN newID + 1
                WHEN newID % 2 = 0 THEN newID - 1
				ELSE id
            END
		) AS new_id
FROM newStudents
ORDER BY new_id ASC;


SELECT newID,
		( CASE
            WHEN newid%2 = 1 AND newid != counts THEN newid+1
            WHEN newid%2 = 1 AND newid = counts THEN newid
            ELSE newid-1
        END) AS changedID, first_name
FROM newStudents, (select count(*) as counts from newStudents) AS seat_counts
ORDER BY changedID ASC;


























































































































