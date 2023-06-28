USE sql_hr;

SELECT* FROM employees;

SELECT 
	office_id,
	ROUND(AVG(salary), 1) AS avg_salary
FROM employees
GROUP BY office_id;

SELECT
	city,
	COUNT(customer_id) AS total_customers
FROM sql_store.customers
GROUP BY city
ORDER BY city;

SHOW DATABASES;

SELECT * FROM world.city
JOIN world.country ON world.city.countrycode = world.country.code
WHERE continent = 'asia' AND world.country.name = 'India'
ORDER BY world.city.population;

SELECT * FROM world.city
ORDER BY population desc
Limit 3;

SELECT countrycode, SUM(population) AS population FROM world.city
GROUP BY countrycode;










