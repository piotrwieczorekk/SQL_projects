USE world;

-- Create temp table and store data about languages spoken in european countries

CREATE TEMPORARY TABLE Languages
(
`Code` CHAR(3),
`Name` VARCHAR(100),
`Language` VARCHAR(100),
IsOfficial BOOLEAN,
Percentage DECIMAL(5,2)
);
INSERT INTO Languages
(
`Code`,
`Name`,
`Language`,
IsOfficial,
Percentage
)
SELECT 
	t4.`Code`,
    t4.`Name`,
    t4.`Language`,
    t4.IsOfficial,
    t4.Percentage
FROM ( 
SELECT 
	t1.*,
    t2.`Language`,
    t2.IsOfficial,
    t2.Percentage
FROM 
	(
    SELECT 
		* 
	FROM 
		country  
	WHERE Continent = "Europe"
    ) t1
INNER JOIN
	countrylanguage t2
ON 
	t1.`Code` = t2.CountryCode
    ) t4;
	
    
-- Select european countries which government form is based on monarchy

SELECT
	t1.`Name`,
    t1.GovernmentForm,
    t1.HeadOfState
FROM (
SELECT 
	* 
FROM 
	country
WHERE 
	HeadOfState IS NOT NULL
AND
	GovernmentForm LIKE "%Monarchy%"
AND
	Continent = "Europe" ) t1;
    
    
-- Select european countries with GNP higher than the average (the average for only european countries, where surface area > 1000 and GNP > 0

SELECT
	t2.*,
    CASE 
		WHEN t2.GNP > t2.AVGGNP THEN 'True'
		ELSE 'False'
	END AS GNPHigherThanAVG
FROM ( 
SELECT 
	t1.`Name`,
    t1.GNP,
	DENSE_RANK() OVER(ORDER BY t1.GNP DESC) AS GNPRank,
	AVG(t1.GNP) OVER() AS AVGGNP
FROM ( 
SELECT 
	*
FROM 
	country
WHERE
	Continent = "Europe"
AND
	SurfaceArea > 1000
AND
	GNP > 0) t1 ) t2;
    
-- Achieve the same thing but with declaring a variable

SET @AverageGNP = (
SELECT
	AVG(t1.GNP)
FROM ( 
SELECT 
	*
FROM 
	country
WHERE
	Continent = "Europe"
AND
	SurfaceArea > 1000
AND
	GNP > 0 ) t1 );
    
SELECT 
	t1.`Name`,
    t1.GNP,
    @AverageGNP AS AverageGNP,
    CASE 
		WHEN t1.GNP > @AverageGNP THEN 'True'
		ELSE 'False'
	END AS GNPHigherThanAVG
FROM ( 
SELECT
	*
FROM 
	country
WHERE
	Continent = "Europe"
AND
	SurfaceArea > 1000
AND
	GNP > 0 ) t1;


    

    