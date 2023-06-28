create database mydb;

use mydb;

DROP TABLE IF EXISTS cats;
create TABLE cats (
					cat_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                    name varchar(250),
                    breed varchar(250),
                    age INT
);

create TABLE mycats (
					cat_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                    name varchar(250),
                    breed varchar(250),
                    age INT
);


INSERT INTO mycats (name, breed, age) VALUES ('Ringo', 'Tabby', 4),
										   ('Cindy', 'Main Coon', 10),
                                           ('Dumbledoor', 'Main coon', 11),
                                           ('Egg', 'Persian', 4),
                                           ('Misty', 'Tabby', 13),
                                           ('George', 'Ragdoll', 9),
                                           ('Jackson', 'Sphynx', 7);
                                           
                                           
SELECT* FROM mycats;

SELECT name from mycats;
SELECT age from mycats;
SELECT name, age from mycats;
SELECT name, age, cat_id from mycats;

SELECT * FROM cats
WHERE age < 15;

SELECT * FROM cats
WHERE age = 5;


SELECT * FROM cats c1
JOIN cats c2 ON c1.cat_id = c2.cat_id
WHERE c1.name = c2.name;

SELECT * FROM cats
WHERE cat_id = age;

SELECT * FROM cats
WHERE breed = 'American Shorthair';


SELECT * FROM cats
WHERE breed = 'American Shorthair'
AND grooming_needs = 'Medium';


SELECT * FROM cats
WHERE origin_country = 'China';

SELECT * FROM cats
WHERE origin_country = 'India';

SELECT * FROM cats
WHERE origin_country = 'Nepal';


SELECT * FROM cats
WHERE breed = 'Bengal';


SELECT * FROM mycats;

SELECT * FROM mycats
WHERE name = 'Egg';

DELETE FROM mycats
WHERE name = 'Egg';

SELECT * FROM mycats;

DELETE from mycats;

SELECT * FROM mycats;

DELETE FROM mycats
WHERE age = 4;


-- SHIRT DATA
SELECT * FROM shirt;

SELECT * FROM shirt
WHERE color = 'purple';

SELECT * FROM shirt
WHERE last_worn = 15;

SELECT * FROM shirt
WHERE last_worn = 20;

SELECT * FROM shirt
WHERE last_worn = 0 AND article = 't-shirt';

SELECT * FROM shirt
WHERE last_worn = 0;

UPDATE shirt SET last_worn = 0
WHERE last_worn = 17 AND shirt_size = '2XL';

SELECT * FROM shirt
WHERE last_worn = 0;

DESC shirt;


































































