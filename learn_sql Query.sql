USE learnsql;

SELECT * FROM employees;
SELECT * FROM employees WHERE department = 'sales';
SELECT * FROM employees WHERE department = 'marketing';
SELECT * FROM employees WHERE department = 'sales' && salary > 50000;



SELECT 
    department,
    MAX(salary) AS max_sal
FROM
    employees
GROUP BY department;

SELECT 
    department,
    ROUND(AVG(salary), 2) AS avg_sal
FROM
    employeess
GROUP BY department;

SELECT DISTINCT first_name FROM employees;
SELECT DISTINCT last_name FROM employees;

SELECT * FROM employees
ORDER BY salary DESC
LIMIT 5;


SELECT 
    department, 
    COUNT(*) AS total_emp
FROM
    employees
GROUP BY department;

SELECT * FROM employees
WHERE salary IN (SELECT MAX(salary) FROM employees);

SELECT 
    *
FROM
    employees
WHERE
    salary IN (SELECT MAX(salary) FROM employees)
        && department = 'sales';


SELECT first_name, department FROM employees;

SELECT * FROM employees
WHERE salary >= (SELECT AVG(salary) FROM employees WHERE department = 'sales');

SELECT 
department,
COUNT(*) AS good_sal
FROM employees
WHERE salary >= (SELECT AVG(salary) FROM employees WHERE department = 'sales')
GROUP BY department;

-- verify
SELECT * FROM employees WHERE salary >= 70000 && department = 'sales';

SELECT GENDER, COUNT(*) FROM employees WHERE salary >= 70000 && department = 'sales' GROUP BY gender;

SELECT * FROM employees WHERE city = 'Mumbai';


SELECT * FROM employees WHERE first_name LIKE 'da%';
SELECT * FROM employees WHERE first_name REGEXP 'da$';
SELECT * FROM employees WHERE first_name REGEXP '^da';
SELECT * FROM employees WHERE first_name REGEXP '^d[ef]';
SELECT * FROM employees WHERE first_name REGEXP '[ef]d$';


SELECT * FROM employees ORDER BY salary;
SELECT * FROM employees ORDER BY salary DESC;
SELECT * FROM employees ORDER BY department, salary DESC;
SELECT * FROM employees WHERE department = 'sales' ORDER BY salary DESC;

-- RANDOM
SELECT * FROM employees WHERE department = 'sales' ORDER BY RAND();
SELECT * FROM employees WHERE department = 'sales' ORDER BY RAND() LIMIT 5;

SELECT * FROM employees WHERE salary = 100000;

-- ALTER TABLE `learnsql`.`employees` 
-- CHANGE COLUMN `id` `id` INT NOT NULL AUTO_INCREMENT ,
-- CHANGE COLUMN `first_name` `first_name` VARCHAR(50) NOT NULL ,
-- CHANGE COLUMN `last_name` `last_name` VARCHAR(50) NOT NULL ,
-- CHANGE COLUMN `age` `age` INT NOT NULL ,
-- CHANGE COLUMN `gender` `gender` VARCHAR(20) NOT NULL ,
-- CHANGE COLUMN `dob` `dob` DATE NOT NULL ,
-- CHANGE COLUMN `city` `city` VARCHAR(9) NOT NULL ,
-- CHANGE COLUMN `salary` `salary` INT(6) NOT NULL ,
-- CHANGE COLUMN `department` `department` VARCHAR(25) NOT NULL ,
-- ADD PRIMARY KEY (`id`);


DESC employees;


DROP TABLE IF EXISTS customer;

CREATE TABLE customer (
id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
age INT NOT NULL,
address VARCHAR(50) DEFAULT 'India',
product VARCHAR(50) NOT NULL,
purchase_date DATE 
);

SELECT * FROM customer;
Truncate Table customer;

DESC customer;

INSERT INTO customer VALUE(1, 'John', 33, 'New Delhi, Delhi, India', 'Mixer', '2023-05-11');
INSERT INTO customer VALUE(2, 'Vicky', 23, 'Mumbai, Maharastra, India', 'Table', '2023-05-13');
INSERT INTO customer VALUE(3, 'Ruhi', 32, 'Bengluru, Karnataka, India', 'Kit', '2023-05-14');
INSERT INTO customer VALUE(4, 'Matt', 41, 'Chennai, Tamil Nadu, India', 'Television', '2023-05-11');
INSERT INTO customer VALUE(5, 'Deamon', 25, 'Jaipur, Rajasthan, India', 'PC', '2023-05-13');
INSERT INTO customer VALUE(6, 'Cindia', 37, 'Gurugram, Haryana, India', 'Dryer', '2023-05-17');

INSERT INTO customer VALUE(7, 'Mike', 33, 'New Delhi, Delhi, India', 'Laptop', '2023-05-18');
INSERT INTO customer VALUE(8, 'Vikas', 23, 'Mumbai, Maharastra, India', 'Cricket Bat', '2023-05-18');
INSERT INTO customer VALUE(9, 'Rubika', 32, 'Bengluru, Karnataka, India', 'Train Toy', '2023-05-19');
INSERT INTO customer VALUE(10, 'Mariyam', 41, 'Chennai, Tamil Nadu, India', 'Teblet', '2023-05-21');
INSERT INTO customer VALUE(11, 'Deepika', 25, 'Jaipur, Rajasthan, India', 'Samsung Phone', '2023-05-23');
INSERT INTO customer VALUE(12, 'Chandra', 37, 'Gurugram, Haryana, India', 'Laptop', '2023-05-27');

INSERT INTO customer VALUE(13, 'Mohit', 32, 'Hydrabad, Andhra Predesh, India', 'Mixer', '2023-06-02');
INSERT INTO customer VALUE(14, 'Ramesh', 31, 'Pune, Maharastra, India', 'Laptop', '2023-06-02');

SELECT * FROM customer;

SELECT * FROM employees WHERE salary BETWEEN 35000 AND 45000;
SELECT COUNT(*) AS records FROM employees WHERE salary BETWEEN 35000 AND 45000;

SELECT 
    department, 
    COUNT(*) AS records
FROM
    employees
WHERE
    salary BETWEEN 45000 AND 55000
GROUP BY department
ORDER BY records DESC;



SELECT * FROM customer
WHERE product = 'laptop';

SELECT product, COUNT(*)
FROM customer
GROUP BY product;

DROP TABLE IF EXISTS bonus;

CREATE TABLE bonus (
emp_id INT PRIMARY KEY NOT NULL,
amount INT,
FOREIGN KEY (emp_id) REFERENCES employees(id)
);

TRUNCATE TABLE bonus;
-- INSERT INTO bonus (emp_id) SELECT id FROM employees;
-- INSERT INTO bonus (amount) SELECT salary + salary * .15 FROM employees;

INSERT INTO bonus (emp_id, amount) SELECT id, salary * .15 FROM employees;

SELECT * FROM bonus;

DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
dep_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
department_name VARCHAR(50) NOT NULL
);

SELECT department FROM employees GROUP BY department;

INSERT INTO departments (department_name) SELECT department FROM employees GROUP BY department;

SELECT * FROM departments;

SELECT * FROM employees WHERE salary IN (SELECT max(salary) FROM employees);
SELECT department, max(salary) FROM employees GROUP BY department;



CREATE TABLE orders (
order_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
customer_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
order_date TIMESTAMP DEFAULT NOW()
);

CREATE TABLE products (
product_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
product_name VARCHAR(50) NOT NULL,
price FLOAT NOT NULL
);


SELECT 
    department,
    SUM(salary) AS total,
    (SUM(salary) / COUNT(*)) AS avg_sal,
    MAX(salary) AS max_salary,
    MIN(salary) AS max_salary
FROM
    employees
GROUP BY department;

SELECT salary, COUNT(*) FROM employees GROUP BY salary;




















































































































































