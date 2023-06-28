CREATE DATABASE edureka;

USE edureka;

SHOW TABLES;

CREATE TABLE employees AS (SELECT * FROM mydb.employees);
CREATE TABLE salary AS (SELECT * FROM mydb.salary);

ALTER TABLE EMPLOYEES
DROP COLUMN salary;

SELECT * FROM employees;
SELECT * FROM salary;

UPDATE salary
SET salary = (FLOOR(salary/1000) * 1000);

ALTER TABLE abc
RENAME TO xyz;

SELECT * 
FROM employees e
JOIN salary s ON e.employee_id = s.id;

CREATE VIEW emp AS SELECT * FROM employees;
CREATE VIEW sal AS SELECT * FROM salary;

SELECT * FROM emp;
SELECT * FROM sal;

SELECT * INTO abc FROM sal;

SELECT job_title, COUNT(*) as TOTAL from emp GROUP BY job_title;

