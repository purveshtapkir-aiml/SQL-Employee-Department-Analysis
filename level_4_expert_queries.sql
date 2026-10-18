
USE OnlineStoreDB;

-- =========================================
-- LEVEL 4: EXPERT SQL QUERIES
-- =========================================

-- Q1. Find the third-highest distinct salary in each department.
WITH SalaryRanks AS (
    SELECT EmployeeID, FirstName, LastName,
           DepartmentID, Salary,
           DENSE_RANK() OVER (
               PARTITION BY DepartmentID
               ORDER BY Salary DESC
           ) AS SalaryRank
    FROM employees
    WHERE DepartmentID IS NOT NULL
)
SELECT *
FROM SalaryRanks
WHERE SalaryRank = 3;


-- Q2. Find employees who earn more than their managers.
SELECT e.EmployeeID,
       CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       e.Salary AS EmployeeSalary,
       CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
       m.Salary AS ManagerSalary
FROM employees e
JOIN employees m
    ON e.ManagerID = m.EmployeeID
WHERE e.Salary > m.Salary;


-- Q3. Find pairs of employees who earn the same salary.
SELECT e1.EmployeeID AS Employee1ID,
       CONCAT(e1.FirstName, ' ', e1.LastName) AS Employee1,
       e2.EmployeeID AS Employee2ID,
       CONCAT(e2.FirstName, ' ', e2.LastName) AS Employee2,
       e1.Salary
FROM employees e1
JOIN employees e2
    ON e1.Salary = e2.Salary
   AND e1.EmployeeID < e2.EmployeeID;


-- Q4. Use a CTE to find employees earning above their department average.
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(Salary) AS AverageSalary
    FROM employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.FirstName, e.LastName,
       e.Salary, da.AverageSalary
FROM employees e
JOIN DepartmentAverages da
    ON e.DepartmentID = da.DepartmentID
WHERE e.Salary > da.AverageSalary;


-- Q5. Find the top 2 salary ranks per department, including ties.
WITH RankedEmployees AS (
    SELECT EmployeeID, FirstName, LastName,
           DepartmentID, Salary,
           RANK() OVER (
               PARTITION BY DepartmentID
               ORDER BY Salary DESC
           ) AS SalaryRank
    FROM employees
    WHERE DepartmentID IS NOT NULL
)
SELECT *
FROM RankedEmployees
WHERE SalaryRank <= 2;


-- Q6. Find department(s) with the highest total salary expense.
WITH DepartmentTotals AS (
    SELECT DepartmentID, SUM(Salary) AS TotalSalary
    FROM employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT d.DepartmentName, dt.TotalSalary
FROM DepartmentTotals dt
JOIN departments d
    ON dt.DepartmentID = d.DepartmentID
WHERE dt.TotalSalary = (
    SELECT MAX(TotalSalary)
    FROM DepartmentTotals
);


-- Q7. Show each employee's salary difference from their manager.
SELECT e.EmployeeID,
       CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       e.Salary AS EmployeeSalary,
       CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
       m.Salary AS ManagerSalary,
       e.Salary - m.Salary AS SalaryDifference
FROM employees e
JOIN employees m
    ON e.ManagerID = m.EmployeeID;


-- Q8. Show the highest-paid employee in each department,
-- their department average, and difference from that average.
WITH DepartmentStats AS (
    SELECT DepartmentID,
           AVG(Salary) AS AverageSalary,
           MAX(Salary) AS HighestSalary
    FROM employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.FirstName, e.LastName,
       d.DepartmentName, e.Salary,
       ds.AverageSalary,
       e.Salary - ds.AverageSalary AS DifferenceFromAverage
FROM employees e
JOIN DepartmentStats ds
    ON e.DepartmentID = ds.DepartmentID
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
WHERE e.Salary = ds.HighestSalary;


-- Q9. Find the department(s) with the largest salary range.
WITH SalaryRanges AS (
    SELECT DepartmentID,
           MAX(Salary) - MIN(Salary) AS SalaryRange
    FROM employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT d.DepartmentName, sr.SalaryRange
FROM SalaryRanges sr
JOIN departments d
    ON sr.DepartmentID = d.DepartmentID
WHERE sr.SalaryRange = (
    SELECT MAX(SalaryRange)
    FROM SalaryRanges
);


-- Q10. Find the highest-paid employee and compare their salary
-- with the company-wide average.
WITH CompanyStats AS (
    SELECT AVG(Salary) AS CompanyAverage,
           MAX(Salary) AS HighestSalary
    FROM employees
)
SELECT e.EmployeeID, e.FirstName, e.LastName,
       d.DepartmentName, e.Salary,
       cs.CompanyAverage,
       e.Salary - cs.CompanyAverage AS DifferenceFromAverage
FROM employees e
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
CROSS JOIN CompanyStats cs
WHERE e.Salary = cs.HighestSalary;


-- Q11. Find the highest-paid employee in each department
-- only when their salary is above the company average.
WITH CompanyAverage AS (
    SELECT AVG(Salary) AS AverageSalary
    FROM employees
),
DepartmentHighest AS (
    SELECT DepartmentID, MAX(Salary) AS HighestSalary
    FROM employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.FirstName, e.LastName,
       d.DepartmentName, e.Salary
FROM employees e
JOIN DepartmentHighest dh
    ON e.DepartmentID = dh.DepartmentID
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
CROSS JOIN CompanyAverage ca
WHERE e.Salary = dh.HighestSalary
  AND e.Salary > ca.AverageSalary;


-- Q12. Rank employees by salary and show the department average.
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(Salary) AS AverageSalary
    FROM employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.FirstName, e.LastName,
       d.DepartmentName, e.Salary,
       da.AverageSalary,
       e.Salary - da.AverageSalary AS DifferenceFromAverage,
       DENSE_RANK() OVER (
           PARTITION BY e.DepartmentID
           ORDER BY e.Salary DESC
       ) AS SalaryRank
FROM employees e
JOIN DepartmentAverages da
    ON e.DepartmentID = da.DepartmentID
JOIN departments d
    ON e.DepartmentID = d.DepartmentID;


-- Q13. Find the department whose average salary is closest
-- to the company-wide average salary.
WITH CompanyAverage AS (
    SELECT AVG(Salary) AS AverageSalary
    FROM employees
),
DepartmentAverages AS (
    SELECT DepartmentID, AVG(Salary) AS AverageSalary
    FROM employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
),
Differences AS (
    SELECT da.DepartmentID, da.AverageSalary,
           ABS(da.AverageSalary - ca.AverageSalary) AS Difference
    FROM DepartmentAverages da
    CROSS JOIN CompanyAverage ca
)
SELECT d.DepartmentName, dif.AverageSalary,
       dif.Difference
FROM Differences dif
JOIN departments d
    ON dif.DepartmentID = d.DepartmentID
WHERE dif.Difference = (
    SELECT MIN(Difference)
    FROM Differences
);


-- Q14. Find employees earning above their department average
-- but below the company average.
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(Salary) AS AverageSalary
    FROM employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
),
CompanyAverage AS (
    SELECT AVG(Salary) AS AverageSalary
    FROM employees
)
SELECT e.EmployeeID, e.FirstName, e.LastName,
       d.DepartmentName, e.Salary
FROM employees e
JOIN DepartmentAverages da
    ON e.DepartmentID = da.DepartmentID
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
CROSS JOIN CompanyAverage ca
WHERE e.Salary > da.AverageSalary
  AND e.Salary < ca.AverageSalary;


-- Q15. Find the department with the second-highest total salary expense.
WITH DepartmentTotals AS (
    SELECT DepartmentID, SUM(Salary) AS TotalSalary
    FROM employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
),
RankedDepartments AS (
    SELECT DepartmentID, TotalSalary,
           DENSE_RANK() OVER (
               ORDER BY TotalSalary DESC
           ) AS ExpenseRank
    FROM DepartmentTotals
)
SELECT d.DepartmentName, rd.TotalSalary
FROM RankedDepartments rd
JOIN departments d
    ON rd.DepartmentID = d.DepartmentID
WHERE rd.ExpenseRank = 2;
