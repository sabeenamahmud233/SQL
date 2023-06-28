USE mydb;

SELECT * FROM books;
SELECT * FROM cats;
SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM orders;
SELECT * FROM shirt;

-- Many to Many Relationships

DROP TABLE IF EXISTS series;
DROP TABLE IF EXISTS Reviewer;
DROP TABLE IF EXISTS Reviews;

DROP TABLE IF EXISTS Reviews, Series, reviewer;

CREATE TABLE Reviewer (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);


CREATE TABLE Series (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    title VARCHAR(100),
    released_year YEAR(4),
    genre VARCHAR(50)
);


CREATE TABLE Reviews (
id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
rating DECIMAL(2, 1),
series_id INT,
reviewer_id INT,
FOREIGN KEY(series_id) REFERENCES series(id),
FOREIGN KEY(reviewer_id) REFERENCES reviewer(id)
);


SELECT * FROM series;
SELECT * FROM reviewer;
SELECT * FROM reviews;


SELECT *
FROM series s
JOIN reviews r
ON s.id = r.series_id;


SELECT *
FROM series s
JOIN reviews r
ON s.id = r.series_id
JOIN reviewer rr 
ON r.reviewer_id = rr.id;


SELECT *
FROM series s
LEFT JOIN reviews r
ON s.id = r.series_id
JOIN reviewer rr 
ON r.reviewer_id = rr.id;

SELECT 
    s.id,
    s.title,
    s.released_year,
    s.genre,
    r.rating,
    rr.first_name,
    rr.last_name
FROM
    series s
        JOIN
    reviews r ON s.id = r.series_id
        JOIN
    reviewer rr ON r.reviewer_id = rr.id
ORDER BY s.id;


SELECT 
    s.id,
    s.title,
    s.released_year,
    s.genre,
    r.rating,
    rr.first_name,
    rr.last_name 
FROM 
    series s 
        LEFT JOIN 
    reviews r ON s.id = r.series_id 
        LEFT JOIN 
    reviewer rr ON r.reviewer_id = rr.id 
ORDER BY s.id;


SELECT 
    title, 
    ROUND(AVG(rating), 1) AS rating
FROM
    series s
        JOIN
    reviews r ON s.id = r.series_id
GROUP BY s.id
ORDER BY rating;


SELECT 
    rr.first_name, 
    rr.last_name, 
    r.rating
FROM
    reviewer rr
        JOIN
    reviews r ON rr.id = r.reviewer_id;


SELECT 
    rr.first_name, 
    rr.last_name, 
    ROUND(AVG(r.rating), 1) AS rating
FROM
    reviewer rr
        JOIN
    reviews r ON rr.id = r.reviewer_id
GROUP BY rr.id;


SELECT s.title AS unreviewed_series
FROM series s
LEFT JOIN reviews r
ON s.id = r.series_id
WHERE r.rating IS NULL;


SELECT 
    s.title AS unreviewed_series,
    r.rating
FROM
    series s
        LEFT JOIN
    reviews r ON s.id = r.series_id
WHERE
    r.rating IS NULL;


SELECT 
    s.title AS unreviewed_series,
    r.rating
FROM
    series s
        LEFT JOIN
    reviews r ON s.id = r.series_id
WHERE
    r.rating IS NULL;


SELECT 
    s.genre,
    ROUND(AVG(r.rating), 1) AS rating
FROM
    series s
        JOIN
    reviews r ON s.id = r.series_id
GROUP BY genre;


SELECT 
    rr.first_name, 
    rr.last_name, 
    COUNT(rating) AS review_count, 
    MIN(r.rating) AS MIN_rating, 
    MAX(r.rating) AS MAX_rating, 
    ROUND(AVG(r.rating), 1) AS AVG_rating, 
    CASE
        WHEN COUNT(r.rating) > 0 THEN 'ACTIVE'
        ELSE 'INACTIVE'
    END AS status 
FROM
    reviewer rr 
        JOIN 
    reviews r ON rr.id = r.reviewer_id 
GROUP BY rr.first_name , rr.last_name;


SELECT 
    rr.first_name, 
    rr.last_name, 
    COUNT(rating) AS review_count, 
    MIN(r.rating) AS MIN_rating, 
    MAX(r.rating) AS MAX_rating, 
    ROUND(AVG(r.rating), 1) AS AVG_rating, 
    CASE
        WHEN COUNT(r.rating) > 0 THEN 'ACTIVE'
        ELSE 'INACTIVE'
    END AS status 
FROM
    reviewer rr 
        LEFT JOIN 
    reviews r ON rr.id = r.reviewer_id 
-- GROUP BY rr.id;
GROUP BY rr.first_name , rr.last_name;


SELECT 
    s.title, 
    r.rating, 
    CONCAT(rr.first_name, ' ', rr.last_name) AS reviewer
FROM
    series s
        JOIN
    reviews r ON s.id = r.series_id
        JOIN
    reviewer rr ON rr.id = r.reviewer_id
ORDER BY s.title;






























































































































































