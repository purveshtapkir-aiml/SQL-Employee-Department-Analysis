
-- =========================================================
-- Project: SQL Employee & Department Analysis
-- File: database_setup.sql
-- Database: OnlineStoreDB
-- Description: Creates the departments and employees tables
-- =========================================================

CREATE DATABASE IF NOT EXISTS OnlineStoreDB;
USE OnlineStoreDB;

-- Temporarily disable foreign key checks to allow safe
-- removal of the existing tables in dependency order.
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------
-- 1. Create departments table
-- ---------------------------------------------------------
CREATE TABLE departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

-- ---------------------------------------------------------
-- 2. Create employees table
-- ---------------------------------------------------------
CREATE TABLE employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DepartmentID INT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    HireDate DATE,
    ManagerID INT NULL,

    CONSTRAINT fk_employee_department
        FOREIGN KEY (DepartmentID)
        REFERENCES departments(DepartmentID),

    CONSTRAINT fk_employee_manager
        FOREIGN KEY (ManagerID)
        REFERENCES employees(EmployeeID)
);

-- ---------------------------------------------------------
-- 3. Insert departments
-- ---------------------------------------------------------
INSERT INTO departments (DepartmentID, DepartmentName)
VALUES
    (1, 'IT'),
    (2, 'HR'),
    (3, 'Sales'),
    (4, 'Finance'),
    (5, 'Marketing');

-- ---------------------------------------------------------
-- 4. Insert employees
-- Managers are inserted before their direct reports.
-- ---------------------------------------------------------
INSERT INTO employees
    (EmployeeID, FirstName, LastName, DepartmentID,
     Salary, HireDate, ManagerID)
VALUES
    (101, 'Alice',   'Johnson', 1, 75000, '2020-01-15', NULL),
    (103, 'Charlie', 'Lee',     2, 55000, '2021-03-10', NULL),
    (104, 'Diana',   'Prince',  3, 85000, '2019-07-22', NULL),
    (106, 'Fiona',   'Brown',   4, 90000, '2018-11-05', NULL),
    (107, 'George',  'White',   5, 58000, '2022-02-14', NULL),
    (109, 'Ian',     'Miller',  NULL, 50000, '2023-06-01', NULL),
    (102, 'Bob',     'Smith',   1, 65000, '2021-05-20', 101),
    (105, 'Ethan',   'Hunt',    3, 60000, '2022-08-18', 104),
    (108, 'Helen',   'Davis',   1, 70000, '2020-09-12', 101);

-- ---------------------------------------------------------
-- 5. Verify the setup
-- ---------------------------------------------------------
SELECT * FROM departments ORDER BY DepartmentID;
SELECT * FROM employees ORDER BY EmployeeID;
