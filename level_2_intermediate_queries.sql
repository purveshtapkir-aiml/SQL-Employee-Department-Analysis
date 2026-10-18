
USE OnlineStoreDB;

-- =========================================
-- LEVEL 2: INTERMEDIATE SQL QUERIES
-- =========================================

-- Q1. Find the top 3 highest-paid employees.
SELECT EmployeeID, FirstName, LastName, Salary
FROM employees
ORDER BY Salary DESC
LIMIT 3;


-- Q2. Count employees in each department.
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS EmployeeCount
FROM departments d
LEFT JOIN employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName;


-- Q3. Find departments with an average salary greater than 65000.
SELECT d.DepartmentName, AVG(e.Salary) AS AverageSalary
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
HAVING AVG(e.Salary) > 65000;


-- Q4. Find the second-highest distinct salary.
SELECT DISTINCT Salary
FROM employees
ORDER BY Salary DESC
LIMIT 1 OFFSET 1;


-- Q5. Find employees earning more than the company-wide average salary.
SELECT EmployeeID, FirstName, LastName, Salary
FROM employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM employees
);


-- Q6. Find the department with the highest average salary.
SELECT d.DepartmentName, AVG(e.Salary) AS AverageSalary
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY AverageSalary DESC
LIMIT 1;


-- Q7. Find the highest-paid employee in each department.
SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary
FROM (
    SELECT e.*,
           ROW_NUMBER() OVER (
               PARTITION BY DepartmentID
               ORDER BY Salary DESC, EmployeeID
           ) AS SalaryRank
    FROM employees e
    WHERE DepartmentID IS NOT NULL
) ranked
WHERE SalaryRank = 1;


-- Q8. Find the top 2 highest-paid employees in each department.
SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary
FROM (
    SELECT e.*,
           ROW_NUMBER() OVER (
               PARTITION BY DepartmentID
               ORDER BY Salary DESC, EmployeeID
           ) AS SalaryRank
    FROM employees e
    WHERE DepartmentID IS NOT NULL
) ranked
WHERE SalaryRank <= 2;


-- Q9. Find employees whose salary is greater than their department's average.
SELECT e.EmployeeID, e.FirstName, e.LastName,
       d.DepartmentName, e.Salary
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > (
    SELECT AVG(e2.Salary)
    FROM employees e2
    WHERE e2.DepartmentID = e.DepartmentID
);


-- Q10. Find departments whose total salary expense exceeds 100000.
SELECT d.DepartmentName, SUM(e.Salary) AS TotalSalaryExpense
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
HAVING SUM(e.Salary) > 100000;
