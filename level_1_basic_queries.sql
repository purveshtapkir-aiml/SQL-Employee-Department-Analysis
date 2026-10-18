USE OnlineStoreDB;

-- =========================================
-- LEVEL 1: BASIC SQL QUERIES
-- =========================================

-- Q1. Find employees earning more than 60000.
SELECT *
FROM employees
WHERE salary > 60000;


-- Q2. Find customers who live in Pune.
SELECT CustomerName
FROM customers
WHERE City = 'Pune';


-- Q3. Calculate the average salary of employees.
SELECT AVG(salary) AS AverageSalary
FROM employees;


-- Q4. Display employee names with their department names.
SELECT
    e.FirstName,
    e.LastName,
    d.DepartmentName
FROM employees e
INNER JOIN departments d
    ON e.DepartmentID = d.DepartmentID;


-- Q5. Find the highest-paid employee(s).
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM employees
WHERE Salary = (
    SELECT MAX(Salary)
    FROM employees
);
