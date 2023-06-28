use mydb;

-- GROUP BY

SELECT SUM(pages) AS total_pages
FROM books;

SELECT released_year, SUM(pages) AS total_pages
FROM books
GROUP BY released_year;

SELECT released_year, SUM(pages) AS total_pages, count(title) AS boosk_count
FROM books
GROUP BY released_year;


SELECT count(title), author_lname
FROM books
GROUP BY author_lname;

SELECT count(title), author_fname
FROM books
GROUP BY author_fname;

SELECT 
    COUNT(title), 
    concat(author_fname, ' ', author_lname) AS author
FROM
    books
GROUP BY author;

SELECT 
    author_lname,
    COUNT(*) AS total
FROM
    books
GROUP BY author_lname;


SELECT 
    released_year,
    COUNT(*) AS total_books
FROM
    books
GROUP BY released_year;


SELECT 
    concat('In ', released_year, ' ',  COUNT(*), ' books relaesed') AS yell,
    released_year,
    COUNT(*) AS total_books
FROM
    books
GROUP BY released_year;

SELECT MIN(released_year)
FROM books;

SELECT MAX(released_year)
FROM books;

SELECT COUNT(released_year)
FROM books;

SELECT SUM(pages)
FROM books;

SELECT 
    LENGTH(title), title
FROM
    books;


SELECT 
    *
FROM
    books
WHERE
    pages = 
		(SELECT 
            MAX(pages)
        FROM
            books);

SELECT 
    *
FROM
    books
WHERE
    pages = 
		(SELECT 
            MIN(pages)
        FROM
            books);

-- EASY WAY THAT WONT TAKE MUCH TIME TO EXECUTE

SELECT * FROM books ORDER BY pages LIMIT 1;
SELECT * FROM books ORDER BY pages DESC LIMIT 1;


SELECT 
    MIN(released_year) AS year,
    CONCAT(author_fname, ' ', author_lname) AS author_name
FROM
    books
GROUP BY author_name;

SELECT 
    MIN(released_year) AS year,
    author_fname,
    author_lname
FROM
    books
GROUP BY author_fname, author_lname;


SELECT 
    CONCAT(author_fname, ' ', author_lname) AS author,
    MAX(pages) AS pages 
FROM
    books 
GROUP BY author_fname , author_lname 
ORDER BY pages DESC;


SELECT author_fname, SUM(pages) as total_pages
FROM books GROUP BY author_fname; 

SELECT author_fname, SUM(pages) as total_pages 
FROM books GROUP BY author_fname 
ORDER BY total_pages DESC 
LIMIT 1;


SELECT AVG(released_year) Avg_year
FROM books;

SELECT ROUND(AVG(released_year)) AS Avg_year
FROM books;

SELECT 
    released_year, 
    ROUND(AVG(stock_quantity)) AS avg_stock
FROM
    books
GROUP BY released_year;


SELECT 
    author_fname, 
    author_lname,
    ROUND(AVG(pages)) AS avg_pages    
FROM
    books
GROUP BY author_fname, author_lname;


SELECT ROUND(SUM(stock_quantity)) AS total_books
FROM books;

SELECT released_year,
		COUNT(title) AS total_books_released
FROM books
GROUP BY released_year
ORDER BY released_year;

SELECT 
    author_fname,
    author_lname,
    ROUND(AVG(released_year)) AS avg_year
FROM
    books
GROUP BY author_fname , author_lname;

SELECT 
    CONCAT(author_fname, ' ', author_lname) AS author_name,
    pages
FROM
    books
WHERE
    pages = (SELECT 
            MAX(pages)
        FROM
            books);


SELECT * 
FROM books
ORDER BY pages DESC
LIMIT 1;


SELECT
released_year AS year,
COUNT(title) AS '#books',
AVG(pages) AS avg_pages
FROM books
GROUP BY year
ORDER BY released_year;


SELECT 
    *
FROM
    mydb.books
WHERE
    author_lname = 'eGGers';

SELECT * FROM books
WHERE released_year >= 2004 AND released_year <= 2015
ORDER BY released_year;

SELECT * FROM books
WHERE released_year BETWEEN 2004 AND 2015
ORDER BY released_year;


SELECT * FROM books
WHERE released_year NOT BETWEEN 2004 AND 2015
ORDER BY released_year;

SELECT * FROM books
WHERE released_year BETWEEN 2004 AND 2015
ORDER BY released_year;


SELECT 
    title,
    released_year,
    CASE
        WHEN released_year >= 2000 THEN 'Modern List'
        ELSE '20th Century List'
    END AS Genre 
FROM 
    books 
ORDER BY released_year;


SELECT * FROM books;

SELECT 
    title,
    stock_quantity,
    CASE
        WHEN stock_quantity <= 50 THEN '*'
        WHEN stock_quantity <= 100 THEN '**'
        WHEN stock_quantity <= 150 THEN '***'
        ELSE '****'
    END AS stock
FROM
    books
ORDER BY stock_quantity;


SELECT 
    title,
    stock_quantity,
    CASE
        WHEN stock_quantity < 50 THEN '*'
        WHEN stock_quantity BETWEEN 50 AND 100 THEN '**'
        WHEN stock_quantity BETWEEN 101 AND 150 THEN '***'
        ELSE '****'
    END AS stock
FROM
    books
ORDER BY stock_quantity;


SELECT * FROM books
WHERE author_lname = 'Eggers' || author_lname = 'Chabon';


SELECT * FROM books
WHERE author_lname = 'Lahiri' AND released_year > 2000;

SELECT * FROM books
WHERE pages BETWEEN 100 AND 200;


SELECT * FROM books
WHERE author_lname LIKE 'C%' || author_lname LIKE 'S%';

SELECT * FROM books
WHERE SUBSTR(author_lname, 1, 1) = 'C' OR
		SUBSTR(author_lname, 1, 1) = 'S';
        
SELECT * FROM books
WHERE SUBSTR(author_lname, 1, 1) IN ('C', 'S');

SELECT 
    SUBSTR(author_lname, 1, 1) AS A,
    SUBSTR(author_lname, 1, 2) AS B,
    SUBSTR(author_lname, 1, 3) AS C,
    SUBSTR(author_lname, 2, 1) AS D,
    SUBSTR(author_lname, 3, 1) AS E
FROM
    books;

SELECT 
    title,
    author_lname,
    CASE
        WHEN title LIKE '%Stories%' THEN 'Short Stories'
        WHEN title LIKE '%just kids%' OR title LIKE '%A Heartbreaking Work%' THEN 'Memoir'
        ELSE 'Novel'
    END AS Type
FROM
    books
ORDER BY title;


SELECT title,
author_lname,
(SELECT COUNT(title) AS COUNT FROM books GROUP BY author_lname) AS COUNT
FROM books
ORDER By title;


SELECT title,
author_lname,
count(title) AS _COUNT
FROM books
GROUP BY title, author_lname
ORDER By title;


SELECT author_lname, COUNT(*) FROM books GROUP BY author_lname;

SELECT 
    author_fname,
    author_lname,
    CASE
    WHEN COUNT(*) = 1 THEN '1 book'
    ELSE concat(COUNT(*), ' books')
    END AS COUNT
FROM
    books
GROUP BY author_lname, author_fname;



























