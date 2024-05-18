SELECT * FROM [dbo].[country];
SELECT * FROM[dbo].[ranking_criteria];
SELECT * FROM[dbo].[ranking_system];
SELECT * FROM[dbo].[university];
SELECT * FROM[dbo].[university_ranking_year];
SELECT * FROM[dbo].[university_year];

--- Select the number of universities in the ranking by year, country and ranking system

SELECT t11.year,
t11.country_name,
t11.system_name,
COUNT(t11.university_id) AS university_count
FROM (
SELECT t9.*,
t10.system_name
FROM (
SELECT t7.*, 
t8.ranking_system_id
FROM (
SELECT t5.university_id,
t5.ranking_criteria_id, t5.year, t5.country_name
FROM (
SELECT t3.*,
t4.country_name
FROM (
SELECT t1.university_id,
t1.ranking_criteria_id,
t1.year,
t1.score,
t2.country_id,
t2.university_name
FROM [dbo].[university_ranking_year] t1
INNER JOIN [dbo].[university] t2
ON t1.university_id = t2.id) t3
INNER JOIN [dbo].[country] t4
ON t4.id = t3.country_id) t5) t7
INNER JOIN [dbo].[ranking_criteria] t8
ON t7.ranking_criteria_id = t8.id) t9
INNER JOIN [dbo].[ranking_system] t10
ON t9.ranking_system_id = t10.id) t11
GROUP BY t11.year, t11.country_name, t11.system_name
ORDER BY t11.year DESC, COUNT(t11.university_id) DESC;


--- Select the sum of points in the ranking by year, country and ranking system

SELECT t11.year,
t11.country_name,
t11.system_name,
SUM(t11.score) AS score_sum
FROM (
SELECT t9.*,
t10.system_name
FROM (
SELECT t7.*, 
t8.ranking_system_id
FROM (
SELECT t5.university_id,
t5.ranking_criteria_id, t5.year, t5.country_name, t5.score
FROM (
SELECT t3.*,
t4.country_name
FROM (
SELECT t1.university_id,
t1.ranking_criteria_id,
t1.year,
t1.score,
t2.country_id,
t2.university_name
FROM [dbo].[university_ranking_year] t1
INNER JOIN [dbo].[university] t2
ON t1.university_id = t2.id) t3
INNER JOIN [dbo].[country] t4
ON t4.id = t3.country_id ) t5) t7
INNER JOIN [dbo].[ranking_criteria] t8
ON t7.ranking_criteria_id = t8.id)t9
INNER JOIN [dbo].[ranking_system] t10
ON t9.ranking_system_id = t10.id ) t11
GROUP BY t11.year, t11.country_name, t11.system_name
ORDER BY t11.year DESC, t11.country_name, t11.system_name, SUM(t11.score) DESC;