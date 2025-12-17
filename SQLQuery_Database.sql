CREATE TABLE employees (
emp_id        INT PRIMARY KEY,
employee_name VARCHAR(50),
department_id INT,
job_title     VARCHAR(50),
salary        INT,
hire_date     DATE,
manager_id    INT);

INSERT INTO employees
(emp_id, employee_name, department_id, job_title, salary, hire_date, manager_id)
VALUES
(1, 'Alice', 1, 'Developer', 80000, '2020-01-10', 3),
(2, 'Bob', 1, 'Developer', 75000, '2019-03-15', 3),
(3, 'Carol', 1, 'Manager', 95000, '2018-06-01', NULL),
(4, 'David', 2, 'HR Exec', 60000, '2021-07-20', 5),
(5, 'Eva', 2, 'HR Manager', 90000, '2017-02-11', NULL),
(6, 'Frank', 3, 'Accountant', 70000, '2019-11-05', 7),
(7, 'Grace', 3, 'Finance Manager', 100000, '2016-09-30', NULL);

SELECT *
FROM employees

CREATE TABLE departments (
department_id INT PRIMARY KEY,
department_name VARCHAR,
dep_location    VARCHAR)

INSERT INTO departments
(department_id, department_name, dep_location)
VALUES
(1, 'IT', 'New York'),
(2, 'HR', 'London'),
(3, 'Finance', 'New York');

ALTER TABLE departments
ALTER COLUMN department_name VARCHAR(50);

ALTER TABLE departments
ALTER COLUMN dep_location VARCHAR(50);

SELECT *
FROM departments

CREATE TABLE projects (
project_id   INT PRIMARY KEY,
project_name VARCHAR (50),
startdate   DATE,
end_date     DATE)

INSERT INTO projects
(project_id, project_name, startdate, end_date)
VALUES
(101, 'Website Revamp', '2023-01-01', '2023-06-30'),
(102, 'Payroll System', '2023-02-15', '2023-12-31'),
(103, 'Audit Tool', '2023-03-01', NULL)

SELECT *
FROM projects

CREATE TABLE employee_projects (
emp_id     INT FOREIGN KEY REFERENCES employees(emp_id),
project_id INT FOREIGN KEY REFERENCES projects(project_id),
hours_worked INT);

INSERT INTO employee_projects
(emp_id, project_id, hours_worked)
VALUES
(1, 101, 120),
(1, 102, 60),
(2, 101, 100),
(3, 102, 40),
(6, 103, 90),
(7, 103, 30);

SELECT *
FROM employee_projects




