/*INSTAGRAM CLONE EXPLORATORY DATA ANALYSIS USING SQL*/

/*SQL SKILLS: joins, date manipulation, regular expressions, views, stored procedures, aggregate functions, string manipulation*/
-- --------------------------------------------------------------------------------------------------------------

/*Ques.1 The first 10 users*/

SELECT
    username,
    created_at
FROM
    users
ORDER BY created_at ASC
LIMIT 10;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.2 Total number of registrations*/

SELECT 
    COUNT(*) AS 'total_registrations'
FROM
    users;
/*Ques.3 Find the 5 oldest users*/

SELECT
    username,
    created_at
FROM 
    users
ORDER BY
    created_at ASC
LIMIT 5;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.4 What day of the week do most users register on?*/

CREATE VIEW vwtotalregistrations AS
    SELECT 
        DATE_FORMAT(created_at, '%W') AS 'day of the week',
        COUNT(*) AS 'total number of registration'
    FROM
        ig_clone.users
    GROUP BY 1
    ORDER BY 2 DESC;
    
SELECT 
    *
FROM
    vwtotalregistrations;

/*Another Solution*/

SELECT 
    DAYNAME(created_at) AS day,
    COUNT(*) AS total
FROM
    users
GROUP BY day
ORDER BY total DESC
LIMIT 2;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.5 Identify inactive users*/

SELECT
    username AS 'inactive_users'
FROM 
    users
LEFT JOIN photos
    ON users.id = photos.user_id
WHERE image_url IS NULL;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.6 Most liked photo*/

SELECT
    username,
    photos.id,
    photos.image_url,
    COUNT(*) AS 'likes'
FROM
    photos
INNER JOIN likes
    ON likes.photo_id = photos.id
INNER JOIN users
    ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY likes DESC
LIMIT 1;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.7 Average user post*/

SELECT
    (SELECT COUNT(*)
    FROM photos) / 
    (SELECT COUNT(*)
    FROM users) AS avg;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.8 Top 5 hashtags*/

SELECT   
    tag_name,
    COUNT(tag_name) AS total 
FROM 
    photo_tags
JOIN tags 
    ON photo_tags.tag_id = tags.id
GROUP BY tags.tag_name
ORDER BY total DESC
LIMIT 5;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.9 Top 5 hashtags*/

SELECT
    username,
    COUNT(*) AS num_likes
FROM
    users
INNER JOIN likes
    ON users.id = likes.user_id
GROUP BY likes.user_id
HAVING
    num_likes = (SELECT COUNT(*)
                 FROM photos);
-- --------------------------------------------------------------------------------------------------------------

/*Ques.10 The first 10 users*/

SELECT
    username,
    created_at
FROM
    users
ORDER BY created_at ASC
LIMIT 10;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.11 Total number of registrations*/

SELECT 
    COUNT(*) AS 'total_registrations'
FROM
    users;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.12 Usernames with numbers as ending*/

SELECT
    id,
    username
FROM    
    users
WHERE 
    username REGEXP '[$0-9]';
-- --------------------------------------------------------------------------------------------------------------

/*Ques.13 Usernames with charachter as ending*/
    
SELECT
    id,
    username
FROM
    users
WHERE
    username NOT REGEXP '[$0-9]';
-- --------------------------------------------------------------------------------------------------------------

/*Ques.14 Usernames that start with letter 'A'*/

SELECT
    id,
    username
FROM
    users
WHERE
    username REGEXP '^[A]';
-- --------------------------------------------------------------------------------------------------------------

/*Ques.15 The average time on the platform */

SELECT
    ROUND(AVG(DATEDIFF(CURRENT_TIMESTAMP, created_at)/360), 2) AS 'time_on_platform (yrs.)'
FROM
    users;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.16 Clean URLs of photos posted on the platform*/

SELECT   
    SUBSTRING(image_url,
        LOCATE('/', image_url) +2,
        LENGTH(image_url) - LOCATE('/', image_url)) AS image_url
FROM
    photos;
-- --------------------------------------------------------------------------------------------------------------

/*Ques.17 Percentage of users who have not commented or liked a photo*/ 

SELECT 
    tableA.total_A AS 'Number Of Users who never commented',
    (tableA.total_A / (SELECT 
            COUNT(*)
        FROM
            users u)) * 100 AS '%',
    tableB.total_B AS 'Number of Users who likes every photos',
    (tableB.total_B / (SELECT 
            COUNT(*)
        FROM
            users u)) * 100 AS '%'
FROM
    (SELECT 
        COUNT(*) AS total_A
    FROM
        (SELECT 
        u.username, c.comment_text
    FROM
        users u
    LEFT JOIN comments c ON u.id = c.user_id
    GROUP BY u.id , c.comment_text
    HAVING comment_text IS NULL) AS total_number_of_users_without_comments) AS tableA
    JOIN
    (SELECT 
        COUNT(*) AS total_B
    FROM
        (SELECT 
        u.id, u.username, COUNT(u.id) AS total_likes_by_user
    FROM
        users u
    JOIN likes l ON u.id = l.user_id
    GROUP BY u.id , u.username
    HAVING total_likes_by_user = (SELECT 
            COUNT(*)
        FROM
            photos p)) AS total_number_users_likes_every_photos) AS tableB;
-- --------------------------------------------------------------------------------------------------------------

/*CREATING STORED PROCEDURES */

/*Ques.1 Popular hashtags list*/
