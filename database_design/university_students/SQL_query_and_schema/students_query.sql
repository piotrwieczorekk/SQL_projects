SELECT * FROM[dbo].[time_dimension];
SELECT * FROM[dbo].[contact_details_dimension];
SELECT * FROM[dbo].[department_dimension];
SELECT * FROM[dbo].[fact_table_student];
SELECT * FROM[dbo].[subject_dimension];


--- Count number of students by department

SELECT t1.*,
t2.DEPARTMENT_NAME
FROM (
SELECT DEPARTMENT_ID,
COUNT(STUDENT_ID) AS NUMBER_OF_STUDENTS
FROM[dbo].[fact_table_student] 
GROUP BY DEPARTMENT_ID) t1
INNER JOIN [dbo].[department_dimension] t2
ON t1.DEPARTMENT_ID = t2.DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;


--- Count number of students by year of birth

SELECT YEAR(DATE_OF_BIRTH) AS YEAR_OF_BIRTH,
COUNT(STUDENT_ID) AS NUMBER_OF_STUDENTS_BY_YEAR_OF_BIRTH
FROM[dbo].[contact_details_dimension]
GROUP BY YEAR(DATE_OF_BIRTH)
ORDER BY YEAR(DATE_OF_BIRTH);


--- Count number of students by year of birth and department


SELECT COUNT(t3.STUDENT_ID) AS NUMBER_OF_STUDENTS_BY_DEPARTMENT_AND_YEAR_OF_BIRTH,
t3.DEPARTMENT_ID,
YEAR(t3.DATE_OF_BIRTH) AS YEAR_OF_BIRTH
FROM (
SELECT t1.*,
t2.DATE_OF_BIRTH
FROM (
SELECT STUDENT_ID,
DEPARTMENT_ID
FROM[dbo].[fact_table_student]) t1
INNER JOIN [dbo].[contact_details_dimension] t2
ON t1.STUDENT_ID = t2.STUDENT_ID) t3
GROUP BY t3.DEPARTMENT_ID,YEAR(t3.DATE_OF_BIRTH)
ORDER BY DEPARTMENT_ID, YEAR_OF_BIRTH;


