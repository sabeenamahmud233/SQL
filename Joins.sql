use vishnu;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers LIKE mydb.customers;
CREATE TABLE orders LIKE mydb.orders;

SELECT * FROM customers;
SELECT * FROM orders;

SELECT * FROM orders WHERE customer_id = 1;

SELECT 
    c.first_name, 
    c.last_name, 
    IFNULL(SUM(o.amount), 0) AS total 
FROM
    customers c 
        JOIN 
    orders o ON c.id = o.customer_id 
GROUP BY c.first_name , c.last_name;


SELECT 
    c.first_name, 
    c.last_name, 
    IFNULL(SUM(o.amount), 0) AS total 
FROM
    customers c 
        JOIN 
    orders o ON c.id = o.customer_id 
GROUP BY c.first_name , c.last_name;


SELECT * 
FROM orders o
JOIN customers c
ON o.customer_id = c.id
ORDER BY c.id;


SELECT 
    *
FROM
    orders o
        JOIN
    customers c ON o.customer_id = c.id
WHERE
    c.id = 1
ORDER BY c.id;

SELECT 
    c.first_name, 
    c.last_name,
    SUM(o.amount) AS total
FROM
    customers c
        JOIN
    orders o ON c.id = o.customer_id 
GROUP BY c.id;


SELECT 
    c.first_name, 
    SUM(o.amount) AS total
FROM
    customers c
        LEFT JOIN
    orders o ON c.id = o.customer_id
GROUP BY c.id
ORDER BY total DESC;

-- Left Join

SELECT * 
FROM customers c
LEFT JOIN orders o
ON c.id = o.customer_id;		-- There is not a NULL data because every customer have at least 1 order


-- RIGHT JOIN

SELECT * 
FROM orders o
RIGHT JOIN customers c
ON c.id = o.customer_id;		-- There is not a NULL data because every order done by customer

DESC orders;


-- Exercise

USE mydb;

DROP TABLE IF EXISTS Students, Papers;

CREATE TABLE Students (
id INT NOT NULL AUTO_INCREMENT,
first_name varchar(20),
PRIMARY KEY (id)
);

CREATE TABLE Papers (
title varchar(100),
grade INT,
student_id INT NOT NULL,
FOREIGN KEY (student_id)
REFERENCES students(id)
ON DELETE CASCADE
);


SELECT * FROM students;
SELECT * FROM papers;


SELECT 
    s.first_name, 
    p.title, 
    p.grade 
FROM 
    students s
        JOIN
    papers p ON s.id = p.student_id
ORDER BY grade DESC;


SELECT 
    s.first_name, 
    p.title, 
    p.grade 
FROM 
    students s
        LEFT JOIN
    papers p ON s.id = p.student_id;


SELECT 
    s.first_name, 
    IFNULL(p.title, 'MISSING') AS title, 
    IFNULL(p.grade, 0) AS grade
FROM 
    students s
        LEFT JOIN
    papers p ON s.id = p.student_id;


SELECT 
    s.first_name, 
    IFNULL(AVG(grade), 0) AS average 
FROM 
    students s
        LEFT JOIN
    papers p ON s.id = p.student_id
GROUP BY s.id
ORDER BY average DESC;


SELECT 
    s.first_name,
    IFNULL(AVG(grade), 0) AS average,
    CASE
        WHEN AVG(grade) > NULL THEN 'FAILING'
        WHEN AVG(grade) > 60 THEN 'PASSING'
        ELSE 'FAILING'
    END AS passing_status
FROM
    students s
        LEFT JOIN
    papers p ON s.id = p.student_id
GROUP BY s.id
ORDER BY average DESC;









































































































































