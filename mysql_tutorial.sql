CREATE DATABASE Office;

use Office;

/*Create Tables */
CREATE TABLE `offices` (
    `officeCode` VARCHAR(10) NOT NULL,
    `city` VARCHAR(50) NOT NULL,
    `phone` VARCHAR(50) NOT NULL,
    `addressLine1` VARCHAR(50) NOT NULL,
    `addressLine2` VARCHAR(50) DEFAULT NULL,
    `state` VARCHAR(50) DEFAULT NULL,
    `country` VARCHAR(50) NOT NULL,
    `postalCode` VARCHAR(15) NOT NULL,
    `territory` VARCHAR(10) NOT NULL,
    PRIMARY KEY (`officeCode`)
);

CREATE TABLE `employees` (
    `employeeNumber` INT(11) NOT NULL,
    `lastName` VARCHAR(50) NOT NULL,
    `firstName` VARCHAR(50) NOT NULL,
    `extension` VARCHAR(10) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `officeCode` VARCHAR(10) NOT NULL,
    `reportsTo` INT(11) DEFAULT NULL,
    `jobTitle` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`employeeNumber`),
    FOREIGN KEY (`officeCode`)
        REFERENCES `offices` (`officeCode`)
);

/*Show Tables */
show tables;

/*Drop Tables */
drop table offices;
drop table employees;

/*Truncate Tables */
truncate table offices;




/*Insert Data in `employees` */

insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 
(1001,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President');

insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 
(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),
(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),
(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing'),
(1088,'Patterson','William','x4871','wpatterson@classicmodelcars.com','6',1056,'Sales Manager (APAC)'),
(1102,'Bondur','Gerard','x5408','gbondur@classicmodelcars.com','4',1056,'Sale Manager (EMEA)'),
(1143,'Bow','Anthony','x5428','abow@classicmodelcars.com','1',1056,'Sales Manager (NA)'),
(1165,'Jennings','Leslie','x3291','ljennings@classicmodelcars.com','1',1143,'Sales Rep'),
(1166,'Thompson','Leslie','x4065','lthompson@classicmodelcars.com','1',1143,'Sales Rep'),
(1188,'Firrelli','Julie','x2173','jfirrelli@classicmodelcars.com','2',1143,'Sales Rep'),
(1216,'Patterson','Steve','x4334','spatterson@classicmodelcars.com','2',1143,'Sales Rep'),
(1286,'Tseng','Foon Yue','x2248','ftseng@classicmodelcars.com','3',1143,'Sales Rep'),
(1323,'Vanauf','George','x4102','gvanauf@classicmodelcars.com','3',1143,'Sales Rep'),
(1337,'Bondur','Loui','x6493','lbondur@classicmodelcars.com','4',1102,'Sales Rep'),
(1370,'Hernandez','Gerard','x2028','ghernande@classicmodelcars.com','4',1102,'Sales Rep'),
(1401,'Castillo','Pamela','x2759','pcastillo@classicmodelcars.com','4',1102,'Sales Rep'),
(1501,'Bott','Larry','x2311','lbott@classicmodelcars.com','7',1102,'Sales Rep'),
(1504,'Jones','Barry','x102','bjones@classicmodelcars.com','7',1102,'Sales Rep'),
(1611,'Fixter','Andy','x101','afixter@classicmodelcars.com','6',1088,'Sales Rep'),
(1612,'Marsh','Peter','x102','pmarsh@classicmodelcars.com','6',1088,'Sales Rep'),
(1619,'King','Tom','x103','tking@classicmodelcars.com','6',1088,'Sales Rep'),
(1621,'Nishi','Mami','x101','mnishi@classicmodelcars.com','5',1056,'Sales Rep'),
(1625,'Kato','Yoshimi','x102','ykato@classicmodelcars.com','5',1621,'Sales Rep'),
(1702,'Gerard','Martin','x2312','mgerard@classicmodelcars.com','4',1102,'Sales Rep');





/*Insert Data in `offices` */

insert  into `offices`(`officeCode`,`city`,`phone`,`addressLine1`,`addressLine2`,`state`,`country`,`postalCode`,`territory`) values 
('1','San Francisco','+1 650 219 4782','100 Market Street','Suite 300','CA','USA','94080','NA'),
('2','Boston','+1 215 837 0825','1550 Court Place','Suite 102','MA','USA','02107','NA'),
('3','NYC','+1 212 555 3000','523 East 53rd Street','apt. 5A','NY','USA','10022','NA'),
('4','Paris','+33 14 723 4404','43 Rue Jouffroy D\'abbans',NULL,NULL,'France','75017','EMEA'),
('5','Tokyo','+81 33 224 5000','4-1 Kioicho',NULL,'Chiyoda-Ku','Japan','102-8578','Japan'),
('6','Sydney','+61 2 9264 2451','5-11 Wentworth Avenue','Floor #2',NULL,'Australia','NSW 2010','APAC'),
('7','London','+44 20 7877 2041','25 Old Broad Street','Level 7',NULL,'UK','EC2N 1HN','EMEA');

/*Alter Table - Add new column, modify existing column */
alter table offices modify addressLine1 varchar(100);

alter table offices add col1 varchar(50);

show create table offices;

/*Select Command - All column, few columns, column alias, Distinct, Limit*/
SELECT 
    *
FROM
    offices;

SELECT 
    *
FROM
    offices
LIMIT 3;

SELECT 
    officeCode, city
FROM
    offices
LIMIT 3;

SELECT 
    officeCode, city, postalCode AS zipCode
FROM
    offices
LIMIT 3;

SELECT DISTINCT
    country AS distinct_countries
FROM
    offices;

/*Select Command with inbuilt functions - count, min, max */
SELECT 
    *
FROM
    employees;

SELECT 
    COUNT(*) AS total_rows,
    MIN(employeeNumber) AS min_emp_num,
    MAX(employeeNumber) AS max_emp_num
FROM
    employees;

/*Order By Clause */
SELECT 
    *
FROM
    employees
ORDER BY officeCode;

SELECT 
    *
FROM
    employees
ORDER BY officeCode DESC;

SELECT 
    *
FROM
    offices
ORDER BY country , city DESC;

/* Where Clause - AND, OR, Like, IN, IS NULL, IS NOT NULL */
SELECT 
    *
FROM
    employees;
SELECT 
    *
FROM
    employees
WHERE
    reportsTo = 1102;

SELECT 
    e1.employeeNumber, e1.firstName, e1.reportsTo, e2.firstName
FROM
    employees e1
        LEFT JOIN
    employees e2 ON e1.reportsTo = e2.employeeNumber;



SELECT 
    *
FROM
    employees
WHERE
    officeCode = '1'
        AND jobTitle = 'VP Sales';

SELECT 
    *
FROM
    employees
WHERE
    officeCode = '1'
        OR jobTitle LIKE 'Sales Rep%';

SELECT 
    *
FROM
    employees
WHERE
    jobTitle LIKE 'Sales%';
SELECT 
    *
FROM
    employees
WHERE
    firstName LIKE '____';

SELECT 
    *
FROM
    employees
WHERE
    officeCode IN ('1' , '6');

SELECT 
    *
FROM
    offices;

SELECT 
    *
FROM
    offices
WHERE
    state IS NULL;

SELECT 
    *
FROM
    offices
WHERE
    state IS NOT NULL;

/*Update Command */
set sql_safe_updates = 0;
UPDATE employees 
SET 
    jobTitle = 'Sales Representative'
WHERE
    jobTitle = 'Sales Rep';

SELECT 
    *
FROM
    employees;

/*Delete Command */
DELETE FROM employees 
WHERE
    officeCode = '1';

SELECT 
    *
FROM
    employees;

SELECT 
    *
FROM
    employees;

/*Group By */
SELECT 
    officeCode, COUNT(*) AS total_employees
FROM
    employees
GROUP BY officeCode
ORDER BY total_employees DESC;

SELECT 
    country, COUNT(city) AS total_City
FROM
    offices
GROUP BY country;

SELECT 
    reportsTo, 
    officeCode, 
    COUNT(*) AS total_employees
FROM
    employees
GROUP BY reportsTo , officeCode;

SELECT 
    reportsTo,
    firstName,
    lastName,
    officeCode,
    COUNT(*) AS total_employees
FROM
    employees
GROUP BY reportsTo , firstName , lastName , officeCode;

/*Group By with Having */

SELECT 
    officeCode, COUNT(*) AS total_employees
FROM
    employees
GROUP BY officeCode
HAVING COUNT(*) >= 3;

/* Joins - Inner, Left, Right */

SELECT 
    *
FROM
    employees;

SELECT 
    *
FROM
    offices;

SELECT 
    emp.*, ofc.*
FROM
    employees emp
        INNER JOIN
    offices ofc ON emp.officeCode = ofc.officeCode;


SELECT 
    emp.*, ofc.*
FROM
    employees emp
        LEFT JOIN
    offices ofc ON emp.officeCode = ofc.officeCode;

SELECT 
    emp.*, ofc.*
FROM
    employees emp
        RIGHT JOIN
    offices ofc ON emp.officeCode = ofc.officeCode;
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    