
-- =========================================================
-- Project: SQL Employee & Department Analysis
-- File: database_setup.sql
-- Database: OnlineStoreDB
-- Description: Creates all six tables and sample data
-- SQL Dialect: MySQL
-- =========================================================

CREATE DATABASE IF NOT EXISTS OnlineStoreDB;
USE OnlineStoreDB;

-- WARNING:
-- This setup script drops and recreates the project tables.
-- Existing data in these six tables will be deleted.

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS departments;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- 1. DEPARTMENTS
-- =========================================================

CREATE TABLE departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);

INSERT INTO departments (DepartmentID, DepartmentName)
VALUES
    (1, 'IT'),
    (2, 'HR'),
    (3, 'Sales'),
    (4, 'Finance'),
    (5, 'Marketing');

-- =========================================================
-- 2. CUSTOMERS
-- =========================================================

CREATE TABLE customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    City VARCHAR(50),
    RegistrationDate DATE
);

INSERT INTO customers
    (CustomerID, CustomerName, Email, City, RegistrationDate)
VALUES
    (1, 'Rahul Sharma', 'rahul@gmail.com', 'Pune', '2023-01-10'),
    (2, 'Priya Patel', 'priya@gmail.com', 'Mumbai', '2023-02-15'),
    (3, 'Amit Verma', 'amit@gmail.com', 'Delhi', '2023-03-20'),
    (4, 'Sneha Joshi', 'sneha@gmail.com', 'Pune', '2023-04-05'),
    (5, 'Rohan Mehta', 'rohan@gmail.com', 'Bangalore', '2023-05-12'),
    (6, 'Neha Singh', 'neha@gmail.com', 'Mumbai', '2023-06-18'),
    (7, 'Vikas Kumar', 'vikas@gmail.com', 'Hyderabad', '2023-07-22'),
    (8, 'Anjali Rao', 'anjali@gmail.com', 'Pune', '2023-08-30'),
    (9, 'Karan Shah', 'karan@gmail.com', 'Ahmedabad', '2023-09-14'),
    (10, 'Pooja Desai', 'pooja@gmail.com', 'Nashik', '2023-10-01');

-- =========================================================
-- 3. PRODUCTS
-- =========================================================

CREATE TABLE products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT,
    Supplier VARCHAR(100)
);

INSERT INTO products
    (ProductID, ProductName, Category, Price, Stock, Supplier)
VALUES
    (201, 'Laptop', 'Electronics', 55000, 10, 'TechWorld'),
    (202, 'Mouse', 'Electronics', 800, 50, 'TechWorld'),
    (203, 'Keyboard', 'Electronics', 1500, 30, 'TechWorld'),
    (204, 'Office Chair', 'Furniture', 7000, 15, 'FurniHome'),
    (205, 'Desk', 'Furniture', 12000, 8, 'FurniHome'),
    (206, 'Notebook', 'Stationery', 100, 100, 'PaperMart'),
    (207, 'Pen', 'Stationery', 50, 200, 'PaperMart'),
    (208, 'Headphones', 'Electronics', 2500, 25, 'SoundMax'),
    (209, 'Monitor', 'Electronics', 15000, 12, 'TechWorld'),
    (210, 'Backpack', 'Accessories', 1800, 40, 'BagWorld');

-- =========================================================
-- 4. EMPLOYEES
-- =========================================================

CREATE TABLE employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10,2),
    HireDate DATE,
    ManagerID INT,

    CONSTRAINT fk_employee_department
        FOREIGN KEY (DepartmentID)
        REFERENCES departments(DepartmentID),

    CONSTRAINT fk_employee_manager
        FOREIGN KEY (ManagerID)
        REFERENCES employees(EmployeeID)
);

-- Insert employees without managers first, so manager
-- references are valid when their direct reports are added.

INSERT INTO employees
    (EmployeeID, FirstName, LastName, DepartmentID,
     Salary, HireDate, ManagerID)
VALUES
    (101, 'Alice', 'Johnson', 1, 75000, '2020-01-15', NULL),
    (103, 'Charlie', 'Lee', 2, 55000, '2019-06-10', NULL),
    (104, 'Diana', 'Prince', 3, 85000, '2018-09-23', NULL),
    (106, 'Fiona', 'Brown', 4, 90000, '2017-11-05', NULL),
    (107, 'George', 'White', 5, 58000, '2020-07-18', NULL),
    (109, 'Ian', 'Miller', NULL, 50000, '2024-04-01', NULL);

INSERT INTO employees
    (EmployeeID, FirstName, LastName, DepartmentID,
     Salary, HireDate, ManagerID)
VALUES
    (102, 'Bob', 'Smith', 1, 65000, '2021-03-20', 101),
    (105, 'Ethan', 'Hunt', 3, 60000, '2022-02-11', 104),
    (108, 'Helen', 'Davis', 1, 70000, '2023-01-25', 101);

-- =========================================================
-- 5. ORDERS
-- =========================================================

CREATE TABLE orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderStatus VARCHAR(30),
    TotalAmount DECIMAL(10,2),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (CustomerID)
        REFERENCES customers(CustomerID)
);

INSERT INTO orders
    (OrderID, CustomerID, OrderDate, OrderStatus, TotalAmount)
VALUES
    (301, 1, '2024-01-05', 'Delivered', 55800),
    (302, 2, '2024-01-10', 'Delivered', 1500),
    (303, 3, '2024-01-15', 'Pending', 12000),
    (304, 1, '2024-02-01', 'Delivered', 2500),
    (305, 4, '2024-02-05', 'Cancelled', 7000),
    (306, 5, '2024-02-10', 'Delivered', 15000),
    (307, 6, '2024-02-15', 'Pending', 1800),
    (308, 7, '2024-03-01', 'Delivered', 800),
    (309, 8, '2024-03-05', 'Delivered', 55000),
    (310, 2, '2024-03-10', 'Pending', 2500),
    (311, 9, '2024-03-15', 'Delivered', 12000),
    (312, 10, '2024-03-20', 'Cancelled', 100);

-- =========================================================
-- 6. ORDER_ITEMS
-- =========================================================

CREATE TABLE order_items (
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (OrderID)
        REFERENCES orders(OrderID),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (ProductID)
        REFERENCES products(ProductID)
);

INSERT INTO order_items
    (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES
    (1, 301, 201, 1, 55000),
    (2, 301, 202, 1, 800),
    (3, 302, 203, 1, 1500),
    (4, 303, 205, 1, 12000),
    (5, 304, 208, 1, 2500),
    (6, 305, 204, 1, 7000),
    (7, 306, 209, 1, 15000),
    (8, 307, 210, 1, 1800),
    (9, 308, 202, 1, 800),
    (10, 309, 201, 1, 55000),
    (11, 310, 208, 1, 2500),
    (12, 311, 205, 1, 12000),
    (13, 312, 206, 1, 100);

-- =========================================================
-- 7. VERIFY TABLES AND SAMPLE DATA
-- =========================================================

SHOW TABLES;

SELECT COUNT(*) AS total_departments FROM departments;
SELECT COUNT(*) AS total_employees FROM employees;
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_order_items FROM order_items;
