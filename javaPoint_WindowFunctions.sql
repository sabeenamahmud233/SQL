CREATE DATABASE windowFunctions;
USE windowFunctions;

CREATE TABLE Sales(  
    Employee_Name VARCHAR(45) NOT NULL,  
    Year INT NOT NULL,  
            Country VARCHAR(45) NOT NULL,  
    Product VARCHAR(45) NOT NULL,  
    Sale DECIMAL(12,2) NOT NULL,  
    PRIMARY KEY(Employee_Name, Year)  
);  


INSERT INTO Sales(Employee_Name, Year, Country, Product, Sale)  
VALUES('Joseph', 2017, 'India', 'Laptop', 10000),  
('Joseph', 2018, 'India', 'Laptop', 15000),  
('Joseph', 2019, 'India', 'TV', 20000),  
('Bob', 2017, 'US', 'Computer', 15000),  
('Bob', 2018, 'US', 'Computer', 10000),  
('Bob', 2019, 'US', 'TV', 20000),  
('Peter', 2017, 'Canada', 'Mobile', 20000),  
('Peter', 2018, 'Canada', 'Calculator', 1500),  
('Peter', 2019, 'Canada', 'Mobile', 25000);  


/*
Analytical Functions
It is a function, which is locally represented by a power series. Some of the important analytical functions are:

NTILE, LEAD, LAG, NTH, FIRST_VALUE, LAST_VALUE, etc.
*/

-- NTILE window function

SELECT * FROM Sales;

SELECT *, NTILE(3) OVER() FROM Sales;
SELECT *, NTILE(4) OVER() FROM Sales;

SELECT Year, Product, Sale,   
NTile(4) OVER() AS Total_Sales   
FROM Sales;

-- LEAD window function
SELECT Year, Product, Sale,   
LEAD(Sale,1) OVER(ORDER BY Year) AS Next_Row_Sales   
FROM Sales; 

-- LAG Window Function
SELECT Year, Product, Sale,
LEAD(Sale,1) OVER(ORDER BY Year) AS Next_Row_Sales,
LAG(Sale,1) OVER(ORDER BY Year) AS Prev_Row_Sales
FROM Sales; 


-- FIRST_VALUE Window Function
SELECT Year, Product, Sale,
FIRST_VALUE(Sale) OVER(PARTITION BY Year ORDER BY Year) AS Next_Row_Sales
FROM Sales; 

-- LAST VALUE Window Function
SELECT Year, Product, Sale,
LAST_VALUE(Sale) OVER(PARTITION BY Year ORDER BY Year) AS Next_Row_Sales
FROM Sales; 

-- FIRST and LAST VALUE Window Function
SELECT Year, Product, Sale,
FIRST_VALUE(Sale) OVER(PARTITION BY Year ORDER BY Year) AS Next_Row_Sales,
LAST_VALUE(Sale) OVER(PARTITION BY Year ORDER BY Year) AS Next_Row_Sales
FROM Sales;  


CREATE TABLE overtime (
    employee_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    hours INT NOT NULL,
    PRIMARY KEY (employee_name , department)
);

INSERT INTO overtime(employee_name, department, hours)
VALUES('Diane Murphy','Accounting',37),
('Mary Patterson','Accounting',74),
('Jeff Firrelli','Accounting',40),
('William Patterson','Finance',58),
('Gerard Bondur','Finance',47),
('Anthony Bow','Finance',66),
('Leslie Jennings','IT',90),
('Leslie Thompson','IT',88),
('Julie Firrelli','Sales',81),
('Steve Patterson','Sales',29),
('Foon Yue Tseng','Sales',65),
('George Vanauf','Marketing',89),
('Loui Bondur','Marketing',49),
('Gerard Hernandez','Marketing',66),
('Pamela Castillo','SCM',96),
('Larry Bott','SCM',100),
('Barry Jones','SCM',65);

SELECT
    employee_name,
    hours,
    FIRST_VALUE(employee_name) OVER (
        ORDER BY hours
    ) least_over_time
FROM
    overtime;


SELECT
    employee_name,
    department,
    hours,
    FIRST_VALUE(employee_name) OVER (
        PARTITION BY department
        ORDER BY hours
    ) least_over_time
FROM
    overtime;


-- NTH_VALUE Function

CREATE TABLE basic_pays(
    employee_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary INT NOT NULL,
    PRIMARY KEY (employee_name , department)
);

INSERT INTO 
	basic_pays(employee_name, 
			   department, 
			   salary)
VALUES
	('Diane Murphy','Accounting',8435),
	('Mary Patterson','Accounting',9998),
	('Jeff Firrelli','Accounting',8992),
	('William Patterson','Accounting',8870),
	('Gerard Bondur','Accounting',11472),
	('Anthony Bow','Accounting',6627),
	('Leslie Jennings','IT',8113),
	('Leslie Thompson','IT',5186),
	('Julie Firrelli','Sales',9181),
	('Steve Patterson','Sales',9441),
	('Foon Yue Tseng','Sales',6660),
	('George Vanauf','Sales',10563),
	('Loui Bondur','SCM',10449),
	('Gerard Hernandez','SCM',6949),
	('Pamela Castillo','SCM',11303),
	('Larry Bott','SCM',11798),
	('Barry Jones','SCM',10586);


SELECT
    employee_name,
    salary,
    NTH_VALUE(employee_name, 2) OVER  (
        ORDER BY salary DESC
    ) second_highest_salary
FROM
    basic_pays;


SELECT
	employee_name,
	department,
	salary,
	NTH_VALUE(employee_name, 2) OVER  (
		PARTITION BY department
		ORDER BY salary DESC
		-- RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) second_highest_salary
FROM
	basic_pays;


-- CUME_DIST() Function

CREATE TABLE scores (
    name VARCHAR(20) PRIMARY KEY,
    score INT NOT NULL
);

INSERT INTO
	scores(name, score)
VALUES
	('Smith',81),
	('Jones',55),
	('Williams',55),
	('Taylor',62),
	('Brown',62),
	('Davies',84),
	('Evans',87),
	('Wilson',72),
	('Thomas',72),
	('Johnson',100);


SELECT
	name,
    score,
    ROW_NUMBER() OVER (ORDER BY score) row_num,
    CUME_DIST() OVER (ORDER BY score) cume_dist_val
FROM
	scores;


-- PERCENT_RANK Function































































































































































































































































































































































































































































































































































































































































































































































































































































CREATE TABLE Sales(       Employee_Name VARCHAR(45) NOT NULL,       Year INT NOT NULL,               Country VARCHAR(45) NOT NULL,       Product VARCHAR(45) NOT NULL,       Sale DECIMAL(12,2) NOT NULL,       PRIMARY KEY(Employee_Name, Year)   )
