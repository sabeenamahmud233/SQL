CREATE TABLE athlete_events AS (SELECT * FROM mydb.olympic_games);

SELECT COUNT(*) FROM athlete_events;
SELECT MAX(rowNumber) FROM athlete_events;
SELECT MAX(id) FROM athlete_events;

-- CREATE INDEXS
CREATE INDEX olympics_rows ON athlete_events(rowNumber);
CREATE INDEX olympics_id ON athlete_events(id);
CREATE INDEX olympics_noc ON athlete_events(NOC(3));

-- SHOW INDEXES
SELECT DISTINCT
    TABLE_NAME,
    INDEX_NAME
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'simplilearn';

SHOW INDEXES FROM athlete_events;

-- Slecting Duplicate Values
SELECT 
    ID , Name , Sex , Age , Height , Weight , Team , NOC , Games , Year , Season , City , Sport , Event , Medal,
    COUNT(*) AS total
FROM
    athlete_events e1
GROUP BY ID , Name , Sex , Age , Height , Weight , Team , NOC , Games , Year , Season , City , Sport , Event , Medal
HAVING total > 1;



-- 1. How many olympics games have been held?
SELECT
	COUNT(DISTINCT Games) AS total_games
FROM athlete_events;

-- 2. List down all Olympics games held so far.
SELECT 
	DISTINCT
    Games,
    Year,
    City
FROM athlete_events
ORDER BY Games;

-- 3. Mention the total no of nations who participated in each olympics game?
SELECT
	Games,
    COUNT(DISTINCT NOC) AS total_country
FROM athlete_events
GROUP BY Games
ORDER BY Games;


-- 4. Which year saw the highest and lowest no of countries participating in olympics?
WITH CTE AS (
				SELECT
					Games,
                    Year,
					COUNT(DISTINCT r.region) AS total_country
				FROM athlete_events a
                JOIN regions r
                ON a.NOC = r.NOC
				GROUP BY Games, Year
				ORDER BY total_country
)
SELECT
	DISTINCT
	CONCAT(FIRST_VALUE(Games) OVER(ORDER BY total_country), '-' , FIRST_VALUE(total_country) OVER(ORDER BY total_country))AS min_country_year,
	CONCAT(FIRST_VALUE(Games) OVER(ORDER BY total_country), '-' , FIRST_VALUE(total_country) OVER(ORDER BY total_country DESC))AS max_country_year
FROM CTE;


WITH all_countries AS (
				SELECT
					Games,
                    r.region
				FROM athlete_events a
                JOIN regions r
                ON a.NOC = r.NOC
				GROUP BY Games, r.region
				ORDER BY Games
),
total_countries AS (
				SELECT 
					Games,
					COUNT(1) AS total_country
				FROM all_countries
                GROUP BY Games
)
SELECT DISTINCT
	CONCAT(
    FIRST_VALUE(Games) OVER(ORDER BY total_country), 
    ' ',
    FIRST_VALUE(total_country) OVER(ORDER BY total_country)
    ) AS minCountryYear,
    CONCAT(LAST_VALUE(Games) OVER(ORDER BY total_country RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
    ' ',
	LAST_VALUE(total_country) OVER(ORDER BY total_country RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
    ) AS maxCountryYear
FROM total_countries;

-- 5. Which nation has participated in all of the olympic games?
WITH CTE1 AS(
SELECT 
	r.region AS Country,
    Team,
    COUNT(DISTINCT Games) AS total1
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
GROUP BY Country, Team
ORDER BY total1 DESC
),
CTE2 AS(
SELECT
	COUNT(DISTINCT Games) AS total2
FROM athlete_events
)
SELECT 
    Team,
    c1.total1
FROM CTE1 c1, CTE2 c2
WHERE c1.total1 = c2.total2;


-- 7. Which Sports were just played only once in the olympics.
SELECT 
	DISTINCT
	Sport,
    COUNT(1) AS total
FROM athlete_events
GROUP BY Sport
HAVING total = 1;

SELECT 
	DISTINCT
	Sport,
    Event,
    COUNT(1) AS total
FROM athlete_events
GROUP BY Sport, Event
HAVING total = 1;

-- 8. Fetch the total no of sports played in each olympic games.
SELECT
	Games,
    COUNT(DISTINCT Sport) AS total
FROM athlete_events
GROUP BY Games
ORDER BY total DESC, Games;


-- 9. Fetch oldest athletes to win a gold medal
WITH CTE1 AS(
	SELECT *
	FROM athlete_events
    WHERE Medal = 'Gold'
),
CTE2 AS(
SELECT
	MAX(Age) AS maxAge
FROM CTE1
)
SELECT c1.*
FROM CTE1 c1, CTE2 c2
WHERE c1.Age = c2.maxAge;


-- 10. Find the Ratio of male and female athletes participated in all olympic games.
WITH maleCount AS(
SELECT
	COUNT(DISTINCT ID) AS Male
FROM athlete_events
WHERE Sex = 'M'
),
femaleCount AS(
SELECT
    COUNT(DISTINCT ID) AS Female
FROM athlete_events
WHERE Sex = 'F'
)
SELECT
    concat("1", ":", round(Male/Female,2)) as Sex_ratio
FROM maleCount c1, femaleCount c2;


with t1 as
		(select sex, count(1) as cnt
		from athlete_events
		group by sex),
	t2 as
		(select *, row_number() over(order by cnt) as rn
		 from t1),
	min_cnt as
		(select MIN(cnt) AS minimumCount from t2),
	max_cnt as
		(select MAX(cnt) AS maximumCount from t2)
select concat('1 : ', round(max_cnt.maximumCount/min_cnt.minimumCount, 2)) as ratio
from min_cnt, max_cnt;


-- 11. Fetch the top 5 athletes who have won the most gold medals.
WITH maxGoldPlayer AS (
SELECT
	ID,
    Name,
    COUNT(*) AS total
FROM athlete_events
WHERE Medal = 'Gold'
GROUP BY ID, Name
ORDER BY total DESC
),
totalGoldRank AS (
SELECT 
	*,
	DENSE_RANK() OVER(ORDER BY total DESC) AS goldRank
FROM maxGoldPlayer
)
SELECT *
FROM totalGoldRank
WHERE goldRank <= 5;


-- 12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
WITH mostMedalsPlayer AS (
SELECT
	ID, NAME, Team,
    COUNT(*) AS totalMedals
FROM athlete_events
WHERE Medal IS NOT NULL
GROUP BY ID, Name, Team
ORDER BY totalMedals DESC
),
totalMedalsRank AS (
SELECT 
	*,
	DENSE_RANK() OVER(ORDER BY totalMedals DESC) AS medalRank
FROM mostMedalsPlayer
)
SELECT *
FROM totalMedalsRank
WHERE medalRank <= 5;


-- 13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
SELECT
	r.region,
    COUNT(Medal) AS total
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
GROUP BY r.region
ORDER BY total DESC;

SELECT *
FROM athlete_events
WHERE NOC = 'AFG' AND Medal IS NOT NULL;

SELECT *
FROM athlete_events
WHERE NOC = 'IND' AND Medal IS NOT NULL;



-- 14. List down total gold, silver and bronze medals won by each country.
WITH CTE AS (
SELECT
	Games,
	region,
    COUNT(CASE WHEN Medal = 'Gold' THEN Medal END) AS Gold,
    COUNT(CASE WHEN Medal = 'Silver' THEN Medal END) AS Silver,
    COUNT(CASE WHEN Medal = 'Bronze' THEN Medal END) AS Bronze
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
GROUP BY Games, region
ORDER BY Games, region
)
SELECT *
FROM CTE
WHERE Gold > 0 OR Silver > 0 OR Bronze > 0;






WITH allGoldMedals AS(
SELECT
	r.region,
    COUNT(Medal) AS total
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
WHERE a.Medal = 'Gold'
GROUP BY r.region
ORDER BY total DESC
),
allSilverMedals AS(
SELECT
	r.region,
    COUNT(Medal) AS total
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
WHERE a.Medal = 'Silver'
GROUP BY r.region
ORDER BY total DESC
),
allBronzeMedals AS(
SELECT
	r.region,
    COUNT(Medal) AS total
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
WHERE a.Medal = 'Bronze'
GROUP BY r.region
ORDER BY total DESC
)
SELECT 
	g.region AS Country,
    g.total AS totalGolds,
    s.total AS totalSilvers,
    b.total AS totalBronzes
FROM allGoldMedals g
JOIN allSilverMedals s
ON g.region = s.region
JOIN allBronzeMedals b
ON b.region = s.region;


SELECT 
	NOC,
    COUNT(1) AS totalMedals
FROM athlete_events
WHERE Medal REGEXP 'Gold|Silver|Bronze'
GROUP BY NOC
ORDER BY totalMedals DESC;


-- 15. List down total gold, silver and bronze medals won by each country corresponding to each olympic games.
WITH CTE AS (
SELECT
	a.*,
    r.region AS Country
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
),
goldMedals AS (
SELECT 
	Country,
    Games,
    COUNT(*) AS totalGold
FROM CTE
WHERE Medal = 'Gold'
GROUP BY Games, Country
),
silverMedals AS (
SELECT 
	Country,
    Games,
    COUNT(*) AS totalSilver
FROM CTE
WHERE Medal = 'Silver'
GROUP BY Games, Country
),
bronzeMedals AS (
SELECT 
	Country,
    Games,
    COUNT(*) AS totalBronze
FROM CTE
WHERE Medal = 'Bronze'
GROUP BY Games, Country
)
SELECT
	g.Games,
    g.Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze
FROM goldMedals g
LEFT JOIN silverMedals s
ON g.Country = s.Country AND g.Games = s.Games
LEFT JOIN bronzeMedals b
ON g.Country = b.Country AND g.Games = b.Games
ORDER BY g.Games, g.Country;




WITH CTE AS (
SELECT
	a.*,
    r.region AS Country
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
),
goldMedals AS (
SELECT 
	Country,
    Games,
    COUNT(*) AS totalGold
FROM CTE
WHERE Medal = 'Gold'
GROUP BY Games, Country
),
silverMedals AS (
SELECT 
	Country,
    Games,
    COUNT(*) AS totalSilver
FROM CTE
WHERE Medal = 'Silver'
GROUP BY Games, Country
),
bronzeMedals AS (
SELECT 
	Country,
    Games,
    COUNT(*) AS totalBronze
FROM CTE
WHERE Medal = 'Bronze'
GROUP BY Games, Country
),
finalData AS (
SELECT
	g.Games AS Games,
    g.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze
FROM goldMedals g
LEFT JOIN silverMedals s
ON g.Country = s.Country AND g.Games = s.Games
LEFT JOIN bronzeMedals b
ON g.Country = b.Country AND g.Games = b.Games
UNION
SELECT
	s.Games AS Games,
    s.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze
FROM silverMedals s
LEFT JOIN goldMedals g
ON g.Country = s.Country AND g.Games = s.Games
LEFT JOIN bronzeMedals b
ON s.Country = b.Country AND s.Games = b.Games
UNION
SELECT
	b.Games AS Games,
    b.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze
FROM bronzeMedals b
LEFT JOIN silverMedals s
ON b.Country = s.Country AND b.Games = s.Games
LEFT JOIN goldMedals g
ON g.Country = b.Country AND g.Games = b.Games
)
SELECT *
FROM finalData
ORDER BY Games, Country;




-- Verify the answer
SELECT 
	Games,
    r.region AS Country,
    COUNT(*) AS totalGold
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
WHERE r.region = 'Finland' AND Medal = 'Gold' AND Games = '2010 Winter'
GROUP BY Games;

SELECT 
	Games,
    r.region AS Country,
    COUNT(*) AS totalGold
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
WHERE r.region = 'Finland' AND Medal = 'Silver' AND Games = '2010 Winter'
GROUP BY Games;

SELECT 
	Games,
    r.region AS Country,
    COUNT(*) AS totalGold
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
WHERE r.region = 'Finland' AND Medal = 'Bronze' AND Games = '2010 Winter'
GROUP BY Games;


-- 16. Identify which country won the most gold, most silver and most bronze medals in each olympic games.
WITH CTE AS (
SELECT 
	a.*,
    r.region AS Country
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
WHERE Medal <> ''
),
allGold AS (
SELECT
	Games,
    Country,
    Count(*) AS totalGold
FROM CTE
WHERE Medal = 'Gold'
GROUP BY Games, Country
),
allSilver AS (
SELECT
	Games,
    Country,
    Count(*) AS totalSilver
FROM CTE
WHERE Medal = 'Silver'
GROUP BY Games, Country
),
allBronze AS (
SELECT
	Games,
    Country,
    Count(*) AS totalBronze
FROM CTE
WHERE Medal = 'Bronze'
GROUP BY Games, Country
),
unionTable AS (
SELECT 
	g.Games AS Games,
    g.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze
FROM allGold g
LEFT JOIN allSilver s
ON g.Games = s.Games AND g.Country = s.Country
LEFT JOIN allBronze b
ON g.Games = b.Games AND g.Country = b.Country
UNION
SELECT 
	s.Games AS Games,
    s.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze
FROM allSilver s
LEFT JOIN allGold g
ON g.Games = s.Games AND g.Country = s.Country
LEFT JOIN allBronze b
ON s.Games = b.Games AND s.Country = b.Country
UNION
SELECT 
	b.Games AS Games,
    b.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze
FROM allBronze b
LEFT JOIN allSilver s
ON b.Games = s.Games AND b.Country = s.Country
LEFT JOIN allGold g
ON g.Games = b.Games AND g.Country = b.Country
)
SELECT 
	DISTINCT
	Games,
    CONCAT(FIRST_VALUE(Country) OVER(PARTITION BY Games ORDER BY Gold DESC), '-', MAX(Gold) OVER(PARTITION BY Games ORDER BY Gold DESC)) AS maxGolds,
    CONCAT(FIRST_VALUE(Country) OVER(PARTITION BY Games ORDER BY Silver DESC), '-', MAX(Silver) OVER(PARTITION BY Games ORDER BY Silver DESC)) AS maxSilvers,
    CONCAT(FIRST_VALUE(Country) OVER(PARTITION BY Games ORDER BY Bronze DESC), '-', MAX(Bronze) OVER(PARTITION BY Games ORDER BY Bronze DESC)) AS maxBronze
FROM unionTable;



-- 17. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
WITH CTE AS (
SELECT 
	a.*,
    r.region AS Country
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
WHERE Medal <> ''
),
allMedal AS (
SELECT
	Games,
    Country,
    Count(*) AS totalMedal
FROM CTE
WHERE Medal <> ''
GROUP BY Games, Country
),
allGold AS (
SELECT
	Games,
    Country,
    Count(*) AS totalGold
FROM CTE
WHERE Medal = 'Gold'
GROUP BY Games, Country
),
allSilver AS (
SELECT
	Games,
    Country,
    Count(*) AS totalSilver
FROM CTE
WHERE Medal = 'Silver'
GROUP BY Games, Country
),
allBronze AS (
SELECT
	Games,
    Country,
    Count(*) AS totalBronze
FROM CTE
WHERE Medal = 'Bronze'
GROUP BY Games, Country
),
unionTable AS (
SELECT 
	g.Games AS Games,
    g.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze,
    IFNULL(m.totalMedal, 0) AS total
FROM allGold g
LEFT JOIN allSilver s
ON g.Games = s.Games AND g.Country = s.Country
LEFT JOIN allBronze b
ON g.Games = b.Games AND g.Country = b.Country
LEFT JOIN allMedal m
ON g.Games = m.Games AND g.Country = m.Country
UNION
SELECT 
	s.Games AS Games,
    s.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze,
    IFNULL(m.totalMedal, 0) AS total
FROM allSilver s
LEFT JOIN allGold g
ON g.Games = s.Games AND g.Country = s.Country
LEFT JOIN allBronze b
ON s.Games = b.Games AND s.Country = b.Country
LEFT JOIN allMedal m
ON s.Games = m.Games AND s.Country = m.Country
UNION
SELECT 
	b.Games AS Games,
    b.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze,
    IFNULL(m.totalMedal, 0) AS total
FROM allBronze b
LEFT JOIN allSilver s
ON b.Games = s.Games AND b.Country = s.Country
LEFT JOIN allGold g
ON g.Games = b.Games AND g.Country = b.Country
LEFT JOIN allMedal m
ON b.Games = m.Games AND b.Country = m.Country
)
SELECT 
	DISTINCT
	Games,
    CONCAT(FIRST_VALUE(Country) OVER(PARTITION BY Games ORDER BY Gold DESC), '-', MAX(Gold) OVER(PARTITION BY Games ORDER BY Gold DESC)) AS maxGolds,
    CONCAT(FIRST_VALUE(Country) OVER(PARTITION BY Games ORDER BY Silver DESC), '-', MAX(Silver) OVER(PARTITION BY Games ORDER BY Silver DESC)) AS maxSilvers,
    CONCAT(FIRST_VALUE(Country) OVER(PARTITION BY Games ORDER BY Bronze DESC), '-', MAX(Bronze) OVER(PARTITION BY Games ORDER BY Bronze DESC)) AS maxBronze,
    CONCAT(FIRST_VALUE(Country) OVER(PARTITION BY Games ORDER BY total DESC), '-', MAX(total) OVER(PARTITION BY Games ORDER BY total DESC)) AS maxMedal
FROM unionTable;



-- 18. Which countries have never won gold medal but have won silver/bronze medals?
WITH CTE AS (
SELECT 
	a.*,
    r.region AS Country
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
WHERE Medal <> ''
),
allMedal AS (
SELECT
	Games,
    Country,
    Count(*) AS totalMedal
FROM CTE
WHERE Medal <> ''
GROUP BY Games, Country
),
allGold AS (
SELECT
	Games,
    Country,
    Count(*) AS totalGold
FROM CTE
WHERE Medal = 'Gold'
GROUP BY Games, Country
),
allSilver AS (
SELECT
	Games,
    Country,
    Count(*) AS totalSilver
FROM CTE
WHERE Medal = 'Silver'
GROUP BY Games, Country
),
allBronze AS (
SELECT
	Games,
    Country,
    Count(*) AS totalBronze
FROM CTE
WHERE Medal = 'Bronze'
GROUP BY Games, Country
),
unionTable AS (
SELECT 
	g.Games AS Games,
    g.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze,
    IFNULL(m.totalMedal, 0) AS total
FROM allGold g
LEFT JOIN allSilver s
ON g.Games = s.Games AND g.Country = s.Country
LEFT JOIN allBronze b
ON g.Games = b.Games AND g.Country = b.Country
LEFT JOIN allMedal m
ON g.Games = m.Games AND g.Country = m.Country
UNION
SELECT 
	s.Games AS Games,
    s.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze,
    IFNULL(m.totalMedal, 0) AS total
FROM allSilver s
LEFT JOIN allGold g
ON g.Games = s.Games AND g.Country = s.Country
LEFT JOIN allBronze b
ON s.Games = b.Games AND s.Country = b.Country
LEFT JOIN allMedal m
ON s.Games = m.Games AND s.Country = m.Country
UNION
SELECT 
	b.Games AS Games,
    b.Country AS Country,
    IFNULL(g.totalGold, 0) AS Gold,
    IFNULL(s.totalSilver, 0) AS Silver,
    IFNULL(b.totalBronze, 0) AS Bronze,
    IFNULL(m.totalMedal, 0) AS total
FROM allBronze b
LEFT JOIN allSilver s
ON b.Games = s.Games AND b.Country = s.Country
LEFT JOIN allGold g
ON g.Games = b.Games AND g.Country = b.Country
LEFT JOIN allMedal m
ON b.Games = m.Games AND b.Country = m.Country
)
SELECT *
FROM unionTable
WHERE Gold = 0
ORDER BY Bronze DESC;


-- 19. In which Sport/event, India has won highest medals.
SELECT 
	Sport AS Sport_Name,
    COUNT(Medal) AS total
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
WHERE region = 'India' AND Medal <> ''
GROUP BY Sport
ORDER BY total DESC
LIMIT 1;


-- 20. Break down all olympic games where India won medal for Hockey and how many medals in each olympic games
WITH CTE AS (
SELECT 
	a.*,
    r.region AS Country
FROM athlete_events a
JOIN regions r
ON a.NOC = r.NOC
WHERE Medal <> ''
)
SELECT 
	Country,
    Sport,
    Games,
    COUNT(*) AS total
FROM CTE
WHERE NOC = 'IND' AND Sport = 'Hockey' AND Medal <> ''
GROUP BY Country, Sport, Games
ORDER BY total DESC;






























































































































