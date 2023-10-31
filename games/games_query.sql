SELECT * FROM[dbo].[game];
SELECT * FROM[dbo].[game_platform];
SELECT * FROM[dbo].[game_publisher];
SELECT * FROM[dbo].[genre];
SELECT * FROM[dbo].[platform];
SELECT * FROM[dbo].[publisher];
SELECT * FROM[dbo].[region];
SELECT * FROM[dbo].[region_sales];


--- Counting all game genres in the database

SELECT t2.genre_id,
t3.genre_name,
t2.genre_count
FROM (
SELECT t1.genre_id,
COUNT(t1.genre_id) AS genre_count 
FROM[dbo].[game] t1
GROUP BY t1.genre_id) t2
INNER JOIN [dbo].[genre] t3
ON t2.genre_id = t3.id
ORDER BY genre_id ASC;


--- Counting all games by platform and release year

SELECT t6.game_count,
t6.platform_id,
t7.platform_name,
t6.release_year
FROM (
SELECT COUNT(t5.game_id) AS game_count,
t5.platform_id,
t5.release_year
FROM (
SELECT t3.*,
t4.release_year,
t4.platform_id
FROM (
SELECT t1.id AS game_id,
t2.publisher_id
FROM [dbo].[game] t1
INNER JOIN [dbo].[game_publisher] t2
ON t1.id = t2.game_id) t3
INNER JOIN [dbo].[game_platform] t4
ON t3.publisher_id = t4.game_publisher_id) t5
GROUP BY t5.release_year, t5.platform_id) t6
INNER JOIN [dbo].[platform] t7
ON t7.id = t6.platform_id;


--- Counting all games by platform genre and release year



SELECT COUNT(t8.game_id) AS game_count, 
t8.platform_name, 
t8.genre_name,
t8.release_year
FROM (
SELECT t5.*,
t6.genre_name,
t7.platform_name
FROM (
SELECT t3.*,
t4.release_year,
t4.platform_id
FROM (
SELECT t1.id AS game_id,
t1.genre_id,
t2.publisher_id
FROM [dbo].[game] t1
INNER JOIN [dbo].[game_publisher] t2
ON t1.id = t2.game_id) t3
INNER JOIN [dbo].[game_platform] t4
ON t3.publisher_id = t4.game_publisher_id) t5
INNER JOIN [dbo].[genre] t6
ON t5.genre_id = t6.id
INNER JOIN [dbo].[platform] t7
ON t5.platform_id = t7.id) t8
GROUP BY t8.platform_name,t8.genre_name,t8.release_year
ORDER BY t8.release_year ASC;



