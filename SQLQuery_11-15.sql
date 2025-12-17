/* display:
employee name
project name
hours worked
For all employees, including those not assigned to any project.*/

/*Business Insight This Query Enables
Identify idle employees
Analyze workload distribution
Detect resource allocation gaps */

SELECT 
	e.employee_name,
	COALESCE(p.project_name, 'No Project') as project_name,
	COALESCE(ep.hours_worked, 0) as hours_worked
FROM employees e
LEFT JOIN employee_projects ep
	ON e.emp_id = ep.emp_id
LEFT JOIN projects p
	ON ep.project_id = p.project_id;

/* display:
project name
total hours worked
number of employees assigned
For each project, including projects with no employees assigned. */

/*Business Insight This Enables
Identify underutilized or idle projects
Compare workload vs staffing
Support resource planning decisions */

SELECT 
	p.project_name,
	COALESCE(SUM(ep.hours_worked), 0) as total_hours_worked,
	COUNT(ep.emp_id) as number_of_emp_assigned
FROM projects p
LEFT JOIN employee_projects ep
	ON p.project_id = ep.project_id
GROUP BY p.project_name;

/* display:
employee name
total hours worked across all projects
Only for employees whose total hours worked is greater than the company average total hours per employee. */

WITH employee_total_hours AS (
	SELECT 
		e.emp_id,
		e.employee_name,
		SUM(COALESCE(ep.hours_worked, 0)) AS total_hours_worked
	FROM employees e
	LEFT JOIN employee_projects ep
		ON e.emp_id = ep.emp_id
	GROUP BY e.emp_id, e.employee_name
),
company_avg AS (
	SELECT 
		AVG(total_hours_worked) AS avg_hours
	FROM employee_total_hours
)
SELECT 
	eth.employee_name,
	eth.total_hours_worked,
	ca.avg_hours
FROM employee_total_hours eth
CROSS JOIN company_avg ca
WHERE eth.total_hours_worked > ca.avg_hours;

-- Alternative Solution (Subquery – Compact)

SELECT 
	e.employee_name,
	SUM(COALESCE(ep.hours_worked, 0)) AS total_hours_worked
FROM employees e
LEFT JOIN employee_projects ep
	ON e.emp_id = ep.emp_id
GROUP BY e.emp_id, e.employee_name
HAVING SUM(COALESCE(ep.hours_worked, 0)) > 
(	
	SELECT AVG(total_hours)
	FROM (
		SELECT 
		SUM(COALESCE(hours_worked, 0)) AS total_hours
		FROM employees e2
		LEFT JOIN employee_projects ep2
			ON e2.emp_id = ep2.emp_id
		GROUP BY e2.emp_id
	) t
);

/* display:
project name
employee name
hours worked
percentage of total project hours contributed by each employee */

SELECT 
	p.project_name,
	e.employee_name,
	ep.hours_worked,
	CASE
		WHEN SUM(ep.hours_worked) OVER (PARTITION BY p.project_id) IS NULL
		THEN 0
	ELSE CAST (
		100.0 * ep.hours_worked 
		/ SUM(ep.hours_worked) OVER (PARTITION BY p.project_id) AS DECIMAL(5,2)
		)
	END AS percentage_of_contribution
FROM projects p
LEFT JOIN employee_projects ep
	ON p.project_id = ep.project_id
LEFT JOIN employees e
	ON e.emp_id = ep.emp_id;

/* display:
project name
project duration in days
total hours worked
average hours worked per day */

WITH project_metrics AS (
SELECT 
	p.project_id,
	p.project_name,
	DATEDIFF(DAY, p.startdate, COALESCE(p.end_date, GETDATE())) AS project_duration_days,
	SUM(COALESCE(ep.hours_worked, 0)) AS total_hours_worked
FROM projects p
LEFT JOIN employee_projects ep
	ON p.project_id = ep.project_id
GROUP BY
	p.project_id,
	p.project_name,
	p.startdate,
	p.end_date
)
SELECT 
	project_name,
	project_duration_days,
	total_hours_worked,
	CASE 
		WHEN project_duration_days = 0 THEN 0
		ELSE CAST ( 
		1.0 * total_hours_worked / project_duration_days AS DECIMAL(10,2)
		)
	END AS avg_hours_worked_per_day
FROM project_metrics


