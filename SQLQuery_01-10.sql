/* display all employees with:
name
job_title
salary
sorted by salary descending. */

SELECT 
	employee_name,
	job_title,
	salary
FROM employees
ORDER BY salary DESC; 

/* display:
employee name
department name
location
For all employees */

SELECT 
	e.employee_name,
	d.department_name,
	d.dep_location
FROM employees e
LEFT JOIN departments d
	ON e.department_id = d.department_id;

/* display:
employee name
department name
salary
Only for employees:
working in New York
with salary greater than 75,000 */

SELECT 
	e.employee_name,
	d.department_name,
	e.salary
FROM employees e
INNER JOIN departments d
	ON d.department_id = e.department_id
WHERE d.dep_location = 'New York' 
	AND e.salary > 75000;

/*display:
department name
total number of employees
average salary
For each department */

SELECT 
	d.department_name,
	COUNT(DISTINCT e.emp_id) as total_number_of_employees,
	AVG(e.salary) as avg_salary
FROM departments d
LEFT JOIN employees e
	ON d.department_id = e.department_id
GROUP BY d.department_name;

/* display:
department name
average salary
Only for departments where the average salary is greater than 80,000 */

SELECT 
	d.department_name,
	AVG(e.salary) as avg_salary
FROM departments d
LEFT JOIN employees e
	ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) > 80000;

/* display:
employee name
salary
For employees whose salary is greater than the average salary of their own department. */

SELECT 
	employee_name,
	salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);


/* display:
employee name
department name
salary
average salary of the department (shown on each row) */

SELECT 
	e.employee_name,
	d.department_name,
	e.salary,
	AVG(e.salary) OVER(PARTITION BY d.department_name) as avg_dept_salary
FROM employees e
LEFT JOIN departments d
	ON e.department_id = d.department_id;

/* display:
employee name
department name
salary
rank of employee by salary within their department */

SELECT 
	e.employee_name,
	d.department_name,
	e.salary,
	RANK() OVER(PARTITION BY e.department_id ORDER BY e.salary DESC) rank_of_emp_by_salary
FROM employees e
LEFT JOIN departments d
	ON e.department_id = d.department_id

/* display:
top 2 highest-paid employees in each department
Include:
employee name
department name
salary */

WITH ranked_employee AS (
SELECT
	e.employee_name,
	d.department_name,
	e.salary,
	RANK() OVER(PARTITION BY e.department_id ORDER BY e.salary DESC) as ranking
FROM employees e
LEFT JOIN departments d
	ON e.department_id = d.department_id
)
SELECT
	employee_name,
	department_name,
	salary
FROM ranked_employee
WHERE ranking <= 2

/* display:
employee name
manager name
For all employees, including those without a manager. */

SELECT 
	e.employee_name as employee_name,
	m.employee_name as manager_name
FROM employees e
LEFT JOIN employees m
	ON e.manager_id = m.emp_id;










