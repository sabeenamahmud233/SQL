-- Write a SQL query to find the total no of Olympic Games held as per the dataset.

select count(distinct games) from athlete_events;

-- List down all Olympics games held so far

select distinct year,season,city from athlete_events
order by year;

-- Mention the total no of nations who participated in each olympics game

select Games,count(distinct region) as team_count from athlete_events as a
join regions as n on a.NOC=n.NOC
group by Games
order by games;

-- Which year saw the highest and lowest no of countries participating in olympics

WITH cte AS (
SELECT Games, COUNT(DISTINCT region) AS team_count
FROM athlete_events AS a
JOIN regions AS n ON a.NOC = n.NOC
GROUP BY Games)
SELECT distinct CONCAT(FIRST_VALUE(Games) OVER (ORDER BY team_count ),"-",FIRST_VALUE(team_count) OVER (ORDER BY team_count ASC)) AS min_team_count,
CONCAT(FIRST_VALUE(Games) OVER (ORDER BY team_count DESC),"-",FIRST_VALUE(team_count) OVER (ORDER BY team_count desc)) AS max_team_count
FROM cte;

-- Which nation has participated in all of the olympic games

select region as country,count(distinct games) as total_participated_game from athlete_events AS a
JOIN regions AS n ON a.NOC = n.NOC
group by region
having total_participated_game=(select count(distinct games) from athlete_events);

-- Identify the sport which was played in all summer olympics.

with cte as (
select sport,count(distinct games) as No_of_game_palyed ,count(distinct games) as Total_game,
rank() over(order by count(distinct games) desc) as rnk
from athlete_events
where season ="Summer"
group by sport)
select sport,No_of_game_palyed,Total_game from cte
where rnk=1
group by sport;

-- Which Sports were just played only once in the olympics.

with cte as (
select distinct sport,count(distinct games) as on_of_games,
rank() over (order by count(distinct games) asc ) as rnk
from athlete_events
group by sport,games)
select sport,on_of_games from cte
where rnk=1;

-- Fetch the total no of sports played in each olympic games.

select games,count(distinct sport) as no_of_sport from athlete_events
group by games
order by no_of_sport desc;

-- Fetch oldest athletes to win a gold medal

with cte as
(select * ,rank() over (order by age desc) as rnk from athlete_events
where medal="Gold" )
select ID,Name,Sex,age,team,games,city,sport,event,medal from cte
where rnk=1;

-- Find the Ratio of male and female athletes participated in all olympic games.

with cte as (
select 
		(select count(distinct ID ) as CM from athlete_events where Sex="M") as M,
		(select count(distinct ID ) as CM from athlete_events where Sex="F") as F
)
select 
	concat("1",":",round(M/F,2)) as Sex_ratio 
from cte;

-- Fetch the top 5 athletes who have won the most gold medals.

with cte as (
select name,team,count(medal) as Total_gold_medal ,
dense_rank() over ( order by count(medal) desc) as rnk
from athlete_events
where medal="Gold"
group by name,team)
select name,team,Total_gold_medal from cte
where rnk <= 5;

-- Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)

with cte as (
select name,team,count(medal) as Total_gold_medal ,
dense_rank() over ( order by count(medal) desc) as rnk
from athlete_events
where medal in ("gold","sliver","bronze")
group by name,team)
select name,team,Total_gold_medal from cte
where rnk <= 5;

-- Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won

select region ,count(medal) as Total_medal_win,
dense_rank() over (order by count(medal) desc ) as rnk
from athlete_events AS a
JOIN regions AS n ON a.NOC = n.NOC
where medal in ("gold","sliver","bronze")
group by region
order by Total_medal_win desc limit 5;

-- List down total gold, silver and bronze medals won by each country.

SELECT region,
COUNT(CASE WHEN medal = 'Gold' THEN medal END) AS Gold_medal,
COUNT(CASE WHEN medal = 'Silver' THEN medal END) AS Silver_medal,
COUNT(CASE WHEN medal = 'Bronze' THEN medal END) AS Bronze_medal
FROM athlete_events AS a
JOIN regions AS n ON a.NOC = n.NOC
GROUP BY region
order by Gold_medal desc;

-- List down total gold, silver and bronze medals won by each country corresponding to each olympic games.

SELECT games, region,
COUNT(CASE WHEN medal = 'Gold' THEN medal END) AS Gold_medal,
COUNT(CASE WHEN medal = 'Silver' THEN medal END) AS Silver_medal,
COUNT(CASE WHEN medal = 'Bronze' THEN medal END) AS Bronze_medal
FROM athlete_events AS a
JOIN regions AS n ON a.NOC = n.NOC
GROUP BY games,region
order by games;

-- Identify which country won the most gold, most silver and most bronze medals in each olympic games.

with t as (
select 
	games,
    region,
	COUNT(CASE WHEN medal = 'Gold' THEN medal END) AS Gold,
	COUNT(CASE WHEN medal = 'Silver' THEN medal END) AS Silver,
	COUNT(CASE WHEN medal = 'Bronze' THEN medal END) AS Bronze
FROM athlete_events AS a
JOIN regions AS n ON a.NOC = n.NOC
group by games,region
)
select 
	distinct games,
    concat(first_value(region) over(partition by games order by gold desc), ' - ', first_value(Gold) over(partition by games order by gold desc)) as Max_Gold, 
    concat(first_value(region) over(partition by games order by silver desc), ' - ', first_value(Silver) over(partition by games order by silver desc)) as Max_Silver,
    concat(first_value(region) over(partition by games order by bronze desc), ' - ', first_value(Bronze) over(partition by games order by bronze desc)) as Max_Bronze
from t
order by games;

-- Which countries have never won gold medal but have won silver/bronze medals?

SELECT 
	region,
	COUNT(CASE WHEN medal = 'Gold' THEN medal END) AS Gold_medal,
	COUNT(CASE WHEN medal = 'Silver' THEN medal END) AS Silver_medal,
	COUNT(CASE WHEN medal = 'Bronze' THEN medal END) AS Bronze_medal
FROM athlete_events AS a
JOIN regions AS n ON a.NOC = n.NOC
GROUP BY region
having Gold_medal = 0
order by Silver_medal desc;

-- In which Sport/event, India has won highest medals.

select 
	sport,
    count(medal) as Total_medal 
FROM athlete_events AS a
JOIN regions AS n ON a.NOC = n.NOC
where region = "India" AND Medal <> ''
group by sport
order by Total_medal desc limit 1;

-- Break down all olympic games where India won medal for Hockey and how many medals in each olympic games

SELECT 
	team,
    sport, 
    games, 
    COUNT(medal) AS Total_medal
FROM athlete_events
WHERE team = 'India' AND sport = 'Hockey' and medal <> ''
GROUP BY team, sport, games
ORDER BY Total_medal desc;