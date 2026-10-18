
USE OnlineStoreDB;

-- =========================================
-- LEVEL 5: MASTER SQL QUERIES
-- =========================================

-- Q1. Find employees in the top 20% salary group.
-- NTILE(5) divides the employees into five groups.
WITH SalaryGroups AS (
    SELECT EmployeeID, FirstName, LastName,
           Salary,
           NTILE(5) OVER (
               ORDER BY Salary DESC
           ) AS SalaryGroup
    FROM employees
)
SELECT *
FROM SalaryGroups
WHERE SalaryGroup = 1;


-- Q2. Find employees in the top 3 distinct salary ranks
-- within each department, including ties.
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
WHERE SalaryRank <= 3;


-- Q3. Find the department whose average salary is closest
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
    SELECT da.DepartmentID,
           da.AverageSalary AS DepartmentAverage,
           ca.AverageSalary AS CompanyAverage,
           ABS(da.AverageSalary - ca.AverageSalary) AS Difference
    FROM DepartmentAverages da
    CROSS JOIN CompanyAverage ca
)
SELECT d.DepartmentName,
       dif.DepartmentAverage,
       dif.CompanyAverage,
       dif.Difference
FROM Differences dif
JOIN departments d
    ON dif.DepartmentID = d.DepartmentID
WHERE dif.Difference = (
    SELECT MIN(Difference)
    FROM Differences
);


-- Q4. Find employees earning above their department average
-- but below the company-wide average.
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
       d.DepartmentName, e.Salary,
       da.AverageSalary AS DepartmentAverage,
       ca.AverageSalary AS CompanyAverage
FROM employees e
JOIN DepartmentAverages da
    ON e.DepartmentID = da.DepartmentID
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
CROSS JOIN CompanyAverage ca
WHERE e.Salary > da.AverageSalary
  AND e.Salary < ca.AverageSalary;


-- Q5. Find employees in the department with the highest
-- average salary, provided they earn above the company average.
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
HighestAverageDepartment AS (
    SELECT DepartmentID, AverageSalary
    FROM DepartmentAverages
    WHERE AverageSalary = (
        SELECT MAX(AverageSalary)
        FROM DepartmentAverages
    )
)
SELECT e.EmployeeID, e.FirstName, e.LastName,
       d.DepartmentName, e.Salary,
       had.AverageSalary AS DepartmentAverage,
       ca.AverageSalary AS CompanyAverage
FROM employees e
JOIN HighestAverageDepartment had
    ON e.DepartmentID = had.DepartmentID
JOIN departments d
    ON e.DepartmentID = d.DepartmentID
CROSS JOIN CompanyAverage ca
WHERE e.Salary > ca.AverageSalary;
