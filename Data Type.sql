use mydb;

-- Date 

SELECT * FROM dogs;

DESC dogs;

SELECT year(1990-06-06) AS today;

SELECT * FROM dogs
WHERE breed LIKE '%GERMAN%';


SELECT curdate() AS _date;
SELECT curtime() AS _time;
SELECT now() AS _datetime;
SELECT date(now()) AS _date;
SELECT day(now()) AS _date;
SELECT month(now()) AS _date;
SELECT year(now()) AS _date;
SELECT dayname(now()) AS _date;
SELECT monthname(now()) AS _date;
SELECT dayofweek(now()) AS _date;
SELECT dayofyear(now()) AS _date;

SELECT CONCAT(monthname(now()), ' ', dayofmonth(now()), ' ', year(now()) ) AS date;

SELECT date_format(now(), '%a') AS _date;
SELECT date_format(now(), '%b') AS _date;
SELECT date_format(now(), '%c') AS _date;
SELECT date_format(now(), '%d') AS _date;
SELECT date_format(now(), '%e') AS _date;
SELECT date_format(now(), '%h') AS _date;
SELECT date_format(now(), '%i') AS _date;
SELECT date_format(now(), '%j') AS _date;
SELECT date_format(now(), '%k') AS _date;
SELECT date_format(now(), '%l') AS _date;
SELECT date_format(now(), '%m') AS _date;
SELECT date_format(now(), '%p') AS _date;
SELECT date_format(now(), '%r') AS _date;
SELECT date_format(now(), '%s') AS _date;
SELECT date_format(now(), '%u') AS _date;
SELECT date_format(now(), '%v') AS _date;
SELECT date_format(now(), '%w') AS _date;
SELECT date_format(now(), '%x') AS _date;
SELECT date_format(now(), '%y') AS _date;

SELECT date_format(now(), '%D') AS _date;
SELECT date_format(now(), '%H') AS _date;
SELECT date_format(now(), '%I') AS _date;
SELECT date_format(now(), '%M') AS _date;
SELECT date_format(now(), '%S') AS _date;
SELECT date_format(now(), '%T') AS _date;
SELECT date_format(now(), '%U') AS _date;
SELECT date_format(now(), '%V') AS _date;
SELECT date_format(now(), '%W') AS _date;
SELECT date_format(now(), '%X') AS _date;
SELECT date_format(now(), '%Y') AS _date;


SELECT FIRST_NAME,
date_format(DOB, '%a %b %y') AS _date
FROM vishnu.students;

SELECT FIRST_NAME,
date_format(DOB, '%a-%b-%Y') AS _date
FROM vishnu.students;


SELECT FIRST_NAME,
date_format(DOB, '%D - %b - %Y') AS _date 
FROM vishnu.students;

SELECT FIRST_NAME,
date_format(DOB, '%d/%m/%Y') AS _date
FROM vishnu.students;


SELECT 
    FIRST_NAME, 
    dob,    
    datediff(now(), dob) AS age
FROM
    vishnu.students;


SELECT 
    FIRST_NAME, 
    dob,    
    datediff(now(), dob) / 365 AS age,
    datediff(now(), dob) / 365 AS age,
    ((datediff(now(), dob) % 365) / 30) AS age,
    ((datediff(now(), dob) % 365) % 30) AS age
FROM
    vishnu.students;

SELECT 
    FIRST_NAME,
    dob,
    CONCAT(FLOOR(DATEDIFF(NOW(), dob) / 365),
            ' year ',
            FLOOR(((DATEDIFF(NOW(), dob) % 365) / 30.4)),
            ' Month ',
            ((DATEDIFF(NOW(), dob) % 365) % 30),
            ' Days') AS age
FROM
    vishnu.students;


SELECT (DATEDIFF(NOW(), DOB))
FROM vishnu.students;

SELECT first_name,
dob,
CONCAT(
DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), dob)), '%y'), ' Year ', 
DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), dob)), '%m'), ' Month ',
DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), dob)), '%d'), ' Days'
) AS age
 FROM vishnu.students
 ORDER BY age DESC;
 
 

SELECT TIMESTAMP(NOW()) AS _date;

SELECT current_timestamp() AS _date;

SELECT day(now()) AS _date;
SELECT year(now()) AS _date;
SELECT month(now()) AS _date;
SELECT dayname(now()) AS _date;
SELECT monthname(now()) AS _date;


SELECT * FROM vishnu.students ORDER BY DOB;
SELECT * FROM vishnu.students ORDER BY DOB DESC;

SELECT * FROM vishnu.students
WHERE DOB BETWEEN '2005-01-01' AND '2010-12-31';

SELECT * FROM vishnu.students
WHERE DOB > '2010-12-31'
ORDER BY DOB;































































































































































