-- Queries

USE instagram;

SELECT * 
FROM users u;

SELECT * 
FROM photos p;

-- Total pics uploaded by user

SELECT u.username,
p.image_url
FROM users u
JOIN photos p ON u.id = p.user_id;

-- Total pics(COUNT) uploaded by user
SELECT 
    u.username, 
    COUNT(image_url) AS total_pics
FROM
    users u
        JOIN
    photos p ON u.id = p.user_id
GROUP BY u.id
ORDER BY total_pics DESC;

SELECT 
    u.username, 
    COUNT(image_url) AS total_pics
FROM
    users u
        LEFT JOIN
    photos p ON u.id = p.user_id
GROUP BY u.id
ORDER BY total_pics DESC;


-- 1. Oldes 5 users

SELECT * FROM users
ORDER BY created_at DESC
LIMIT 5;

SELECT * FROM users
ORDER BY created_at
LIMIT 5;

-- 2. What day of week most users register on?

SELECT 
    DAYNAME(created_at) AS _day, 
    COUNT(id) AS total_account
FROM
    users
GROUP BY _day
ORDER BY total_account DESC;

SELECT 
    DAYNAME(created_at) AS _day, 
    COUNT(id) AS total_account
FROM
    users
GROUP BY _day
ORDER BY total_account DESC
LIMIT 2;


-- 3. Users they didn't posted a single pic

SELECT * 
FROM users u
LEFT JOIN photos p ON u.id = p.user_id;


SELECT * 
FROM users u
LEFT JOIN photos p ON u.id = p.user_id
WHERE p.id IS NULL;


-- 4. Select users with most likes
SELECT u.username,
		COUNT(*) AS total_likes
FROM users u
JOIN photos p ON u.id = p.user_id
JOIN likes l ON p.id = l.photo_id
GROUP BY p.id
ORDER BY total_likes DESC;

SELECT p.image_url,
		COUNT(*) AS total_likes
FROM photos p
JOIN likes l ON p.id = l.photo_id
GROUP BY p.id
ORDER BY total_likes DESC;


SELECT 
    u.username, 
    u.id, 
    p.id, 
    COUNT(*) AS total_likes
FROM
    users u
        JOIN
    photos p ON u.id = p.user_id
        JOIN
    likes l ON p.id = l.photo_id
GROUP BY p.id
ORDER BY total_likes DESC;

-- User with most likes

SELECT 
    u.username,
    u.id,     
    COUNT(*) AS total_likes
FROM
    users u
        JOIN
    photos p ON u.id = p.user_id
        JOIN
    likes l ON p.id = l.photo_id
GROUP BY u.id
ORDER BY total_likes DESC;


-- AVG number of photos posted by user

SELECT 
    u.username,
    u.id,     
    COUNT(p.id) AS total_photos 
FROM
    users u
        JOIN
    photos p ON u.id = p.user_id
GROUP BY u.id
ORDER BY total_photos DESC;


SELECT (
(SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users)
)  AS avg_post;


-- Top 5 commanly used hashtags

SELECT 
    t.id, 
    t.tag_name, 
    COUNT(*) AS total_used
FROM
    tags t
        JOIN
    photo_tags pt ON t.id = pt.tag_id
GROUP BY t.id
ORDER BY total_used DESC
LIMIT 5;


-- total tags used on every photo

SELECT 
    p.id, 
    p.image_url, 
    COUNT(*) AS total_tags
FROM
    photos p
        JOIN
    photo_tags pt ON p.id = pt.photo_id
GROUP BY p.id
ORDER BY total_tags DESC;


-- Find users that have likes every photos

SELECT 
    u.username
FROM
    users u
JOIN likes l ON u.id = l.user_id
GROUP BY u.id
HAVING COUNT(*) = (SELECT COUNT(*) FROM photos);

SELECT 
    u.id,     
    u.username,
    COUNT(*) AS total_likes
FROM
    users u
        JOIN
    likes l ON u.id = l.user_id
GROUP BY user_id
HAVING total_likes = (SELECT COUNT(*) FROM photos);

SELECT 
    u.id,     
    u.username,
    COUNT(*) AS total_likes
FROM
    users u
        JOIN
    likes l ON u.id = l.user_id
GROUP BY user_id
HAVING total_likes > 100
ORDER BY total_likes DESC
LIMIT 13;



SHOW CREATE TABLE likes;
DESC likes;





















































































