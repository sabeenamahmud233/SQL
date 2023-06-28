USE mydb;

SELECT FLOOR(RAND() * 15) + 5;
SELECT CEILING(RAND() * 20);

SELECT 
    *
FROM
    cats;


SELECT 
    *
FROM
    cats
WHERE
    age > 10;


SELECT 
    *
FROM
    cats
WHERE
    age = 1;


UPDATE cats 
SET 
    age = 20
WHERE
    average_weight = 15 AND age < 5;


SELECT 
    *
FROM
    cats
WHERE
    average_weight = 15;


SELECT 
    *
FROM
    cats
WHERE
    age > 60;


UPDATE cats 
SET 
    age = CEILING(RAND() * 20);



-- String

-- CONCAT()

USE mydb;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees AS (SELECT * FROM sql_hr.employees);

SELECT * FROM employees;

DESC employees;

SELECT first_name, last_name, concat(first_name, ' ', last_name) AS full_name
FROM employees;


SELECT substring(first_name, 5)
FROM employees;

SELECT substring(first_name, -5)
FROM employees;

SELECT 
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) AS full_name,
    SUBSTRING(CONCAT(first_name, ' ', last_name), 7) AS sub_string
FROM
    employees;

-- REPLACE

SELECT REPLACE('Hello World', ' ', '-') AS Word;

-- REVERSE

SELECT REVERSE('Hello World') AS Word;

SELECT REVERSE(first_name) AS Word
FROM employees;

SELECT 
    first_name, 
    CHAR_LENGTH(first_name) AS length
FROM
    employees;

SELECT 
    first_name, 
    CHAR_LENGTH(first_name) AS length,
    CONCAT(first_name, ' is ', CHAR_LENGTH(first_name), ' character long.') AS length_text
FROM
    employees;


SELECT upper('hello world') AS text;
SELECT lower('hello world') AS text;

SELECT reverse('Why does my cat look at me with such hatred') AS text_out;

SELECT upper(
reverse('Why does my cat look at me with such hatred')
) 
AS text_out;

SELECT concat('I', ' ', 'Like', ' ', 'cats')
AS text_out;

SELECT replace(concat('I', ' ', 'Like', ' ', 'cats'), ' ', '-')
AS text_out;


SELECT 
    first_name AS forwards, REVERSE(first_name) AS backwards
FROM
    employees;


SELECT 
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) AS full_name,
    char_length( CONCAT(first_name, ' ', last_name) ) AS full_name_length    
FROM
    employees;


SELECT 
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) AS full_name,
    CONCAT(
    left(
    CONCAT(first_name, ' ', last_name) , 8)
    , '...')
    AS short_name 
FROM
    employees;


SELECT * FROM books;

SELECT DISTINCT author_fname
FROM books;

SELECT DISTINCT author_lname
FROM books;

DROP VIEW IF EXISTS fullname;

CREATE VIEW fullname AS
    (SELECT 
        author_fname,
        author_lname,
        CONCAT(author_fname, ' ', author_lname) AS full_name
    FROM
        books);


SELECT * FROM fullname;

SELECT DISTINCT full_name FROM fullname
ORDER BY full_name;

SELECT * FROM books ORDER BY released_year;
SELECT * FROM books ORDER BY released_year DESC;
SELECT * FROM books ORDER BY released_year DESC LIMIT 3;
SELECT * FROM books ORDER BY released_year DESC LIMIT 0, 3;
SELECT * FROM books ORDER BY released_year DESC LIMIT 4, 3;
SELECT * FROM books ORDER BY released_year DESC LIMIT 10, 1;
SELECT * FROM books ORDER BY released_year DESC LIMIT 4, 111;


SELECT * FROM books 
WHERE title like 'Coraline';

SELECT * FROM books 
WHERE title like '%lin%';

SELECT * FROM books 
WHERE author_fname like '%da%';

SELECT * FROM books 
WHERE author_fname like 'da%';

SELECT * FROM books 
WHERE author_fname like 'M%';

SELECT * FROM books 
WHERE author_fname like '%a';

SELECT * FROM books
WHERE stock_quantity LIKE '___';

SELECT * FROM books
WHERE stock_quantity LIKE '2_';

SELECT * FROM books
WHERE stock_quantity LIKE '_5_';

SELECT * FROM books
WHERE stock_quantity LIKE '2_';

SELECT * FROM books;

SELECT * FROM books 
WHERE title like '%\:%';


SELECT * FROM books 
WHERE title like '%\_%';

-- Eeercise

SELECT * FROM books
WHERE title LIKE '%stories%';


SELECT * FROM books
ORDER BY pages DESC LIMIT 1;

SELECT * FROM books
ORDER BY pages DESC LIMIT 0, 1;

SELECT concat(title, ' - ', released_year) AS summary
FROM books
ORDER BY released_year DESC LIMIT 4;

SELECT concat(title, ' - ', released_year) AS summary
FROM books
ORDER BY released_year DESC LIMIT 1, 4;


SELECT * FROM books
WHERE author_lname LIKE '%\ %';


SELECT * FROM books
ORDER BY stock_quantity limit 3;

SELECT * FROM books
ORDER BY author_lname, title;

SELECT 
    CONCAT('MY FAVORITE AUTHOR IS ',
            UPPER(author_fname),
            ' ',
            UPPER(author_lname),
            '!') AS yell
FROM
    books
ORDER BY author_lname;


SELECT COUNT(author_fname)
FROM books;


SELECT COUNT(DISTINCT author_fname) AS Total_Author
FROM books;

SELECT COUNT(DISTINCT author_lname) AS Total_Author
FROM books;

SELECT COUNT(DISTINCT author_lname, author_fname) AS Total_Author
FROM books;

SELECT title FROM books
WHERE title LIKE '%the%';

SELECT COUNT(title) FROM books
WHERE title LIKE '%the%';



















