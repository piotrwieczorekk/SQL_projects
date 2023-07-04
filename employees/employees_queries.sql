## -- Use the employees database
USE employees;

## -- Take a look at all of the tables in the database
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;

### --- Get data about Senior Enginners and Enginners and join data about their salary (only for current employees)
SELECT 
    t1.emp_no,
    t1.title,
    t1.from_date AS title_from_date,
    t1.to_date AS title_to_date,
    t2.salary,
    t2.from_date AS salary_from_date,
    t2.to_date AS salary_to_date
FROM
    (SELECT 
        emp_no, title, from_date, to_date
    FROM
        titles
    WHERE
        to_date = '9999-01-01'
            AND title IN ('Senior Engineer' , 'Engineer')) t1
        INNER JOIN
    salaries t2 ON t1.emp_no = t2.emp_no
WHERE
    t2.to_date = '9999-01-01';

### --- Check count of each title (only for current employees)
SELECT title, COUNT(title) AS title_freq FROM titles
WHERE to_date = '9999-01-01'
GROUP BY title 
ORDER BY title_freq DESC;

### --- Check how many current employees work in different departments
SELECT COUNT(t3.dept_no) AS dept_no_freq, t3.dept_no, t3.dept_name FROM
(SELECT t1.dept_no, t2.dept_name
FROM
(SELECT dept_no FROM dept_emp
WHERE to_date = '9999-01-01') t1
INNER JOIN departments t2 ON t1.dept_no = t2.dept_no) t3
GROUP BY t3.dept_no
ORDER BY dept_no_freq DESC;

## -- Get average salary per deparment for current employees

SELECT t4.dept_no, t4.dept_name, AVG(t4.salary) AS avg_sal_per_dept 
FROM (
SELECT t1.dept_no,t1.emp_no, t1.from_date AS dept_from_date, t1.to_date AS dept_to_date,
t2.salary, t2.from_date AS salary_from_date, t2.to_date AS salary_to_date, t3.dept_name 
FROM
(SELECT dept_no,emp_no,from_date,to_date
FROM dept_emp
WHERE to_date = '9999-01-01') t1
INNER JOIN salaries t2 ON t1.emp_no = t2.emp_no
INNER JOIN departments t3 on t1.dept_no = t3.dept_no
WHERE t2.to_date ='9999-01-01') t4
GROUP BY t4.dept_no
ORDER BY t4.dept_no;

## -- Check how many employees (by title) were employed in different years

SELECT t1.title, COUNT(t1.title) AS title_freq, YEAR(t1.from_date) AS hire_date FROM titles t1
GROUP BY t1.title, YEAR(t1.from_date)
ORDER BY YEAR(t1.from_date);



