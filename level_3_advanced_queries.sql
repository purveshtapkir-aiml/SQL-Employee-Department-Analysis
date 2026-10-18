
USE OnlineStoreDB;

-- =========================================
-- LEVEL 3: ADVANCED SQL QUERIES
-- =========================================

-- Q1. Find the second-highest distinct salary.
SELECT MAX(Salary) AS SecondHighestSalary
FROM employees
WHERE Salary < (
    SELECT MAX(Salary)
    FROM employees
);


-- Q2. Find employees earning more than their department's average salary.
SELECT e.EmployeeID, e.FirstName, e.LastName,
       d.DepartmentName, e.Salary
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
JOIN (
    SELECT DepartmentID, AVG(Salary) AS DepartmentAverage
    FROM employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
) da
    ON e.DepartmentID = da.DepartmentID
WHERE e.Salary > da.DepartmentAverage;


-- Q3. Find the department with the highest total salary expense.
SELECT d.DepartmentName, SUM(e.Salary) AS TotalSalaryExpense
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
HAVING SUM(e.Salary) = (
    SELECT MAX(TotalSalary)
    FROM (
        SELECT SUM(Salary) AS TotalSalary
        FROM employees
        WHERE DepartmentID IS NOT NULL
        GROUP BY DepartmentID
    ) dept_totals
);


-- Q4. Rank employees by salary within each department.
SELECT EmployeeID, FirstName, LastName,
       DepartmentID, Salary,
       RANK() OVER (
           PARTITION BY DepartmentID
           ORDER BY Salary DESC
       ) AS SalaryRank
FROM employees
WHERE DepartmentID IS NOT NULL;


-- Q5. Find the top 2 salary ranks in each department, including ties.
SELECT EmployeeID, FirstName, LastName,
       DepartmentID, Salary, SalaryRank
FROM (
    SELECT e.EmployeeID, e.FirstName, e.LastName,
           e.DepartmentID, e.Salary,
           RANK() OVER (
               PARTITION BY e.DepartmentID
               ORDER BY e.Salary DESC
           ) AS SalaryRank
    FROM employees e
    WHERE e.DepartmentID IS NOT NULL
) ranked
WHERE SalaryRank <= 2;


-- Q6. Find the department with the most employees.
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS EmployeeCount
FROM departments d
JOIN employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
HAVING COUNT(e.EmployeeID) = (
    SELECT MAX(EmployeeCount)
    FROM (
        SELECT COUNT(*) AS EmployeeCount
        FROM employees
        WHERE DepartmentID IS NOT NULL
        GROUP BY DepartmentID
    ) dept_counts
);


-- Q7. Display employees with their manager names.
SELECT e.EmployeeID,
       CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName
FROM employees e
LEFT JOIN employees m
    ON e.ManagerID = m.EmployeeID;


-- Q8. Find employees who earn more than their managers.
SELECT e.EmployeeID,
       CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       e.Salary AS EmployeeSalary,
       CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
       m.Salary AS ManagerSalary
FROM employees e
JOIN employees m
    ON e.ManagerID = m.EmployeeID
WHERE e.Salary > m.Salary;


-- Q9. Find employees whose salary equals the highest salary
-- in their department.
SELECT e.EmployeeID, e.FirstName, e.LastName,
       d.DepartmentName, e.Salary
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
WHERE e.Salary = (
    SELECT MAX(e2.Salary)
    FROM employees e2
    WHERE e2.DepartmentID = e.DepartmentID
);


-- Q10. Find each department's salary range.
SELECT d.DepartmentName,
       MAX(e.Salary) AS HighestSalary,
       MIN(e.Salary) AS LowestSalary,
       MAX(e.Salary) - MIN(e.Salary) AS SalaryRange
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName;
