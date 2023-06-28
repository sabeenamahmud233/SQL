-- INTERVIEW QUESTIONS
USE mydb;

SELECT * FROM dogs;

SELECT * FROM dogs
WHERE dogs.name IN (SELECT DISTINCT name FROM cats)
ORDER BY id;

SELECT *
FROM dogs d
JOIN cats c ON d.name = c.name
ORDER BY id;

-- Repeated name in dogs table
SELECT 
    name, 
    COUNT(id) AS repeatname
FROM
    dogs
GROUP BY name
HAVING repeatname > 1;

-- verify the answer

SELECt *
FROM dogs
WHERE name = 'Iris'; 


SELECT name
FROM dogs 
INTERSECT
SELECT name
FROM cats;


SELECT name
FROM dogs
UNION
SELECT name
FROM cats;


DROP TABLE IF EXISTS salary;

CREATE TABLE salary AS SELECT employee_id AS id, salary FROM employees;
-- CREATE TABLE salary LIKE employees; 

SELECT * FROM salary;

SELECT 
    e.employee_id, 
    e.first_name, 
    s.salary
FROM
    employees e
        JOIN
    salary s ON e.employee_id = s.id;

SELECT * FROM students;

-- ALTER TABLE
ALTER TABLE `mydb`.`papers` 
RENAME TO  `mydb`.`paper` ;


ALTER TABLE students
ADD COLUMN `marks` INT NOT NULL AFTER `first_name`,
CHANGE COLUMN `first_name` `first_name` VARCHAR(20) NOT NULL ;

ALTER TABLE students
ADD COLUMN `gender` CHAR(1) NOT NULL AFTER `first_name`;

UPDATE `mydb`.`students` SET `gender` = 'M' WHERE (`id` = '1');
UPDATE `mydb`.`students` SET `gender` = 'F' WHERE (`id` = '2');
UPDATE `mydb`.`students` SET `gender` = 'M' WHERE (`id` = '3');
UPDATE `mydb`.`students` SET `gender` = 'M' WHERE (`id` = '4');
UPDATE `mydb`.`students` SET `gender` = 'F' WHERE (`id` = '5');


ALTER TABLE `mydb`.`mycats` 
CHANGE COLUMN `cat_id` `cat_id` INT NULL ,
DROP PRIMARY KEY;

ALTER TABLE `mydb`.`mycats` 
CHANGE COLUMN `cat_id` `cat_id` INT NOT NULL AUTO_INCREMENT ,
CHANGE COLUMN `name` `name` VARCHAR(250) NOT NULL ,
CHANGE COLUMN `breed` `breed` VARCHAR(250) NOT NULL ,
CHANGE COLUMN `age` `age` INT NOT NULL ,
ADD PRIMARY KEY (`cat_id`);


-- CREATING INDEX
CREATE INDEX nameScore ON students (first_name, marks);

SHOW index from students;

SELECT * FROM students ORDER BY id DESC;


-- VIEWS
CREATE VIEW catView AS (
SELECT * FROM cats ORDER BY cat_id DESC);

CREATE VIEW catViewF AS (
SELECT * FROM cats WHERE gender = 'F');

CREATE VIEW catViewM AS (
SELECT * FROM cats WHERE gender = 'M');

SELECT * FROM catView;
SELECT * FROM catViewF;
SELECT * FROM catViewM;

SELECT * FROM cats WHERE name REGEXP 'a$';
SELECT * FROM cats WHERE name REGEXP '^a';
SELECT * FROM cats WHERE name REGEXP '[abc]';
SELECT * FROM cats WHERE name REGEXP '^[xyz]';
SELECT * FROM cats WHERE name REGEXP '[xyz]$';
SELECT * FROM cats WHERE name REGEXP '[xz]';
SELECT * FROM cats WHERE name REGEXP '[xz]';


-- NORMAL FORM

/* 
1st Normal Form - There are not multivalued attributes
Means
A column can not have more than 1 value.
*/


/* 
SQL Statement Type
1. Data Defination Language					-- CREATE, DROP 
2. Data Query Language						-- SELECT
3. Data Manipulation Language				-- INSERT, UPDATE
4. Data Control Language					-- GRANT, REVOKE
*/


SELECT 
    gender, 
    COUNT(*) AS total_student, 
    AVG(marks) AS avgMarks
FROM
    students
GROUP BY gender;
















