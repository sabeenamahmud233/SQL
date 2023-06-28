use mydb;

SELECT * FROM customers;

SELECT * FROM orders;

SELECT * 
FROM customers c
JOIN orders o
ON c.id = o.customer_id;


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
ON o.customer_id = c.id;

SELECT * 
FROM customers c
LEFT JOIN orders o
ON c.id = o.customer_id;

SELECT * 
FROM orders o
RIGHT JOIN customers c
ON c.id = o.customer_id;

SELECT 
    c.first_name, 
    c.last_name, 
    o.order_date, 
    o.amount 
FROM
    customers c
        JOIN
    orders o ON c.id = o.customer_id 
GROUP BY c.first_name, c.last_name, o.order_date, o.amount;			-- This dosen't make sense


SELECT 
    c.first_name, 
    c.last_name, 
    SUM(o.amount) AS total
FROM
    customers c
        JOIN
    orders o ON c.id = o.customer_id 
GROUP BY c.first_name, c.last_name;


SELECT 
    c.first_name, 
    c.last_name, 
    SUM(o.amount) AS total
FROM
    customers c
        JOIN
    orders o ON c.id = o.customer_id 
GROUP BY c.id;

-- LEFT JOIN

SELECT 
    c.first_name, 
    c.last_name, 
    IFNULL(SUM(o.amount), 0) AS total 
FROM
    customers c 
        LEFT JOIN 
    orders o ON c.id = o.customer_id 
GROUP BY c.first_name , c.last_name;


-- RIGHT JOIN

SELECT 
    c.first_name, 
    c.last_name, 
    IFNULL(SUM(amount), 0) AS total
FROM
    orders o
        RIGHT JOIN
    customers c ON o.customer_id = c.id
GROUP BY c.id
ORDER BY total;



































































































