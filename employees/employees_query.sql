USE employees;

SELECT * FROM departments LIMIT 10;
SELECT * FROM dept_emp LIMIT 10;
SELECT * FROM dept_manager LIMIT 10;
SELECT * FROM employees LIMIT 10;
SELECT * FROM salaries LIMIT 10;
SELECT * FROM titles LIMIT 10;


SELECT * FROM departments LIMIT 10;

-- Select employees count by department (only employees that currently work for the company)

WITH emp_count AS (
SELECT
	t1.dept_no,
    COUNT(t1.emp_no) AS emp_count_by_dept
FROM (
SELECT 
	* 
FROM 
	dept_emp
WHERE
	to_date = '9999-01-01' ) t1
GROUP BY
	t1.dept_no
)
SELECT 
	t2.*,
    t3.dept_name
FROM
	emp_count t2
INNER JOIN
	departments t3
ON 
	t2.dept_no = t3.dept_no
ORDER BY 
	dept_no;



-- Select employees count by department and their job title (only employees that currently work for the company)

SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM departments LIMIT 10;
SELECT * FROM dept_emp;

-- the counts are equal
SELECT COUNT(*) FROM employees;
SELECT COUNT(DISTINCT(emp_no)) FROM employees;

-- the counts are not equal because some employees have been employed on different positions (while remaining the same ID)
SELECT COUNT(*) FROM titles;
SELECT COUNT(DISTINCT(emp_no)) FROM titles;

-- Select employees count by department, their job title and gender (only employees that currently work for the company)

SELECT	
	COUNT(t6.emp_no) AS emp_count,
    t6.title,
    t6.gender,
    t6.dept_name
FROM ( 
SELECT 
	t5.emp_no,
	t5.title,
    t5.gender,
    t5.dept_name
FROM (
SELECT
	t1.*,
    t2.gender,
    t3.title,
    t4.dept_name
FROM ( 
SELECT
	*
FROM 
	dept_emp
WHERE 
	to_date = "9999-01-01" ) t1
INNER JOIN 
	employees t2
ON 
	t1.emp_no = t2.emp_no
INNER JOIN 
	(SELECT 
		emp_no,
        title
	FROM 
		titles 
	WHERE 
		to_date = '9999-01-01') t3
ON 
	t1.emp_no = t3.emp_no
INNER JOIN
	departments t4
ON 
	t1.dept_no = t4.dept_no ) t5 ) t6
GROUP BY
	t6.dept_name,
    t6.title,
    t6.gender
ORDER BY 
	dept_name;
    
-- select average salary for employees that currently work at the company grouped by their job titles

SELECT 
	t3.title,
    AVG(t3.salary) AS AvgSalaryByTitle
FROM ( 
SELECT 
	t1.*,
    t2.salary
FROM (
SELECT 
	*
FROM 
	titles t1
WHERE
	to_date = '9999-01-01' ) t1
INNER JOIN
	(SELECT 
		emp_no,
        salary 
	FROM 
		salaries 
	WHERE 
		to_date = '9999-01-01') t2 
ON
	t1.emp_no = t2.emp_no ) t3
GROUP BY
	t3.title;
    
    
-- Create stored procedure to get data about employee's current salary based on emp_no

DELIMITER //
CREATE PROCEDURE `EmpSalaryData`(IN emp_number INT)
BEGIN
	SELECT 
		t3.*
	FROM ( 
	SELECT 
		t1.emp_no,
		t1.salary,
		t2.first_name,
		t2.last_name,
		t2.birth_date,
		t2.hire_date
	FROM ( 
	SELECT 
		* 
	FROM 
		salaries
	WHERE 
		to_date = '9999-01-01' ) t1
	INNER JOIN
		employees t2
	ON 
		t1.emp_no = t2.emp_no) t3
	WHERE 
		t3.emp_no = emp_number;
END //
DELIMITER ;


call employees.EmpSalaryData(10005);

    
