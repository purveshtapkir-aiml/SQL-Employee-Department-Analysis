# SQL Employee & Department Analysis

## Project Overview

This project demonstrates SQL skills through structured practice exercises using a sample company database. It covers employee and department analysis, customer information, product inventory, and order management.

The project progresses from basic SQL queries to advanced analytical techniques, including subqueries, Common Table Expressions (CTEs), window functions, and self joins.

## Project Objectives

- Analyze employee salaries and department performance.
- Retrieve and filter data using SQL queries.
- Calculate aggregates and compare salary statistics.
- Rank employees and departments using window functions.
- Analyze customers, products, orders, and order items.
- Practice solving business problems using SQL.

## Tools & Technologies

- **Database:** MySQL 8.0+
- **Language:** SQL
- **Platform:** GitHub

## Repository Structure

```text
SQL-Employee-Department-Analysis/
├── database_setup.sql
├── level_1_basic_queries.sql
├── level_2_intermediate_queries.sql
├── level_3_advanced_queries.sql
├── level_4_expert_queries.sql
├── level_5_master_queries.sql
└── README.md
```


## Database Tables

| Table | Description |
|---|---|
| `employees` | Employee details, salaries, departments, and managers |
| `departments` | Department information |
| `customers` | Customer details and registration information |
| `products` | Product categories, prices, stock, and suppliers |
| `orders` | Customer orders, dates, statuses, and amounts |
| `order_items` | Products and quantities associated with orders |

## SQL Topics Covered

### Level 1 — Basic
- SELECT, WHERE
- Aggregate functions
- INNER JOIN
- Subqueries

### Level 2 — Intermediate
- ORDER BY and LIMIT
- GROUP BY and HAVING
- Correlated subqueries
- Salary comparisons
- ROW_NUMBER()

### Level 3 — Advanced
- RANK() and window functions
- Self joins
- Aggregate subqueries
- Department salary analysis

### Level 4 — Expert
- Common Table Expressions (CTEs)
- DENSE_RANK()
- Salary ranking and comparisons
- Department salary ranges
- Company-wide versus department averages

### Level 5 — Master
- NTILE()
- Advanced CTE combinations
- Top salary groups
- Ranking and analytical comparisons
- Multi-step business queries

## How to Run the Project

1. Install MySQL 8.0 or later.
2. Open MySQL Workbench or your preferred MySQL client.
3. Open `database_setup.sql` and execute it to create and populate the sample database.
4. Open any level-specific SQL file.
5. Execute the queries individually and inspect the results.

**Important:** `database_setup.sql` drops and recreates the project tables. Running it against an existing database with important data in these tables can delete that data. Back up any important data first.

## Key Learning Outcomes

- Improved SQL querying and data retrieval skills.
- Practical understanding of joins, subqueries, and aggregations.
- Experience with CTEs and window functions.
- Ability to analyze salary distributions and department performance.
- Practice translating business questions into SQL solutions.

## About

This repository is a learning project created to strengthen SQL skills through hands-on exercises, from foundational queries to advanced data analysis.
