# Bookstore Database Management System

## 1. Project Overview

The **Bookstore Database Management System** is a MySQL-based database project designed to manage the major operations of a bookstore. It stores and organizes information about books, authors, publishers, customers, inventory, and customer orders.

The project uses relational database concepts and SQL queries to maintain relationships between data, enforce data integrity, search for books, monitor inventory, and generate sales reports.

## 2. Problem Statement

A bookstore needs to maintain information about books, authors, publishers, customers, stock availability, and sales transactions. Managing these records manually or using disconnected data sources can lead to duplicate information, inconsistent records, difficulty tracking inventory, and time-consuming sales analysis.

The main problem addressed by this project is how to organize bookstore data in a structured database and retrieve meaningful information efficiently while maintaining data consistency.

## 3. Project Objectives

- Design a relational database for bookstore operations.
- Organize book, author, publisher, category, customer, inventory, and order information.
- Establish relationships between tables using primary keys and foreign keys.
- Maintain data integrity using constraints.
- Search for books using SQL and a stored procedure.
- Monitor stock levels and identify books that need restocking.
- Analyze sales, revenue, popular books, and customer purchasing behavior.
- Improve data retrieval using indexes.
- Apply advanced SQL concepts such as views, triggers, Common Table Expressions (CTEs), and window functions.

## 4. Proposed Solution

The project implements a centralized MySQL database containing eight related tables. Each table stores a specific type of information, reducing unnecessary duplication and allowing related records to be connected through keys.

SQL queries retrieve information from multiple tables and produce reports that help demonstrate bookstore operations. Additional database objects, including indexes, a view, a stored procedure, and a trigger, demonstrate techniques for improving data access, reusing queries, and enforcing business rules.

## 5. Technologies Used

- **Database:** MySQL
- **Database tool:** MySQL Workbench
- **Query language:** SQL
- **Advanced concepts:** Joins, aggregate functions, indexes, views, stored procedures, triggers, CTEs, window functions, and query execution plans

## 6. Database Design

The database contains eight tables:

| Table | Purpose |
|---|---|
| `categories` | Stores book categories. |
| `publishers` | Stores publisher information. |
| `authors` | Stores author names and countries. |
| `books` | Stores book details, ISBN, price, publication year, and related IDs. |
| `customers` | Stores customer contact information and registration dates. |
| `inventory` | Stores current stock quantities and reorder levels. |
| `orders` | Stores customer orders, dates, and order statuses. |
| `order_items` | Stores the books, quantities, and unit prices associated with each order. |

### Relationships

- One category can contain multiple books.
- One author can be associated with multiple books.
- One publisher can publish multiple books.
- One customer can place multiple orders.
- One order can contain multiple books through `order_items`.
- Each book has an inventory record in the sample dataset.

Primary keys uniquely identify records, while foreign keys connect related tables and help prevent invalid references.

## 7. Methods and SQL Concepts Used

### A. Relational Database Design

Tables are organized by entity, with primary keys, foreign keys, unique constraints, and appropriate data types. This structure helps maintain consistent and related records.

### B. Data Integrity

`NOT NULL`, `UNIQUE`, `CHECK`, and foreign key constraints are used to restrict invalid or inconsistent data. For example, book prices and inventory quantities cannot be negative under the defined constraints.

### C. Data Retrieval and Joins

`SELECT`, `WHERE`, `ORDER BY`, and different joins retrieve and combine information from related tables. A book catalogue query combines book details with author, category, and inventory information.

### D. Aggregate Functions and Grouping

`COUNT()`, `SUM()`, and `GROUP BY` calculate order counts, sales revenue, quantities sold, and customer purchasing totals. `HAVING` can be used to filter grouped results.

### E. Indexing

Indexes are created on commonly searched columns and reporting fields, such as book titles, categories, authors, customer order dates, order statuses, and book references in order items. Indexes can improve suitable queries, although their benefit depends on the query and data.

### F. Views

The view `v_book_sales_summary` provides a reusable summary of completed book sales, units sold, and revenue. It simplifies access to frequently used reporting logic.

### G. Stored Procedures

The stored procedure `sp_search_books` accepts a search term and returns matching books with their authors, categories, prices, and available stock.

### H. Triggers

The trigger `trg_order_item_after_insert`, which runs before an order-item insertion, checks whether an inventory record exists and whether the requested quantity exceeds available stock. It rejects invalid insertions.

The trigger does not automatically decrease inventory after a sale; that would require additional logic.

### I. Common Table Expressions and Window Functions

CTEs organize complex queries into readable steps. `LAG()` compares monthly revenue with the previous available month, while `DENSE_RANK()` ranks books within their categories based on units sold.

### J. Query Execution Plans

`EXPLAIN` is used to inspect how MySQL plans to execute a query and to introduce query-performance analysis.

## 8. Reports and Analysis

The project includes SQL queries for:

- Displaying the book catalogue with author, category, price, and stock.
- Searching books by a partial title.
- Summarizing completed orders, unique customers, total revenue, and average order value.
- Identifying top-selling books.
- Comparing monthly revenue and calculating revenue changes.
- Ranking books within each category.
- Identifying repeat customers and calculating their spending.
- Finding books whose stock is at or below their reorder level.
- Segmenting customers using purchase recency, order frequency, and monetary value.
- Inspecting a query execution plan.

## 9. Expected Benefits

- Centralizes bookstore information in a relational database.
- Maintains relationships between books, customers, orders, and inventory.
- Reduces inconsistent records through database constraints.
- Simplifies book searches and routine reporting.
- Provides sample sales and customer insights through SQL analytics.
- Demonstrates practical use of fundamental and advanced MySQL concepts.

## 10. Limitations and Future Enhancements

This project is an educational database prototype populated with sample data. It does not include a complete application interface or a live payment system.

Possible future improvements include:

- Automatically updating stock after completed sales and handling concurrent purchases safely.
- Implementing and testing database user roles and permissions.
- Adding transaction management and order-cancellation handling.
- Connecting the database to a web or desktop application.
- Using larger, realistic datasets to evaluate query performance.
- Adding automated database backups and recovery procedures.

## 11. Conclusion

The Bookstore Database Management System demonstrates how MySQL can be used to design a relational database, maintain data integrity, manage sample bookstore transactions, and generate useful reports. The project applies core SQL operations and advanced database features to a practical business scenario and provides a foundation for further development into a complete bookstore application.
