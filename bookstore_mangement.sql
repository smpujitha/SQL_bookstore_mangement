


CREATE DATABASE IF NOT EXISTS bookstore_capstone_clean;
USE bookstore_capstone_clean;


DROP TRIGGER IF EXISTS trg_order_item_after_insert;
DROP PROCEDURE IF EXISTS sp_search_books;
DROP VIEW IF EXISTS v_book_sales_summary;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS publishers;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;

-- 1. CREATE TABLES

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(150) NOT NULL,
    country VARCHAR(80)
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    author_id INT NOT NULL,
    publisher_id INT,
    category_id INT NOT NULL,
    publication_year SMALLINT,
    price DECIMAL(10,2) NOT NULL,
    CHECK (price >= 0),
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    phone VARCHAR(30),
    created_at DATE NOT NULL
);

CREATE TABLE inventory (
    book_id INT PRIMARY KEY,
    stock_quantity INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 5,
    CHECK (stock_quantity >= 0),
    CHECK (reorder_level >= 0),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status ENUM('Pending','Completed','Cancelled')
        NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    CHECK (quantity > 0),
    CHECK (unit_price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    UNIQUE (order_id, book_id)
);

-- 2. INSERT SAMPLE DATA

INSERT INTO categories (category_name) VALUES
('Fiction'),
('Technology'),
('Science'),
('Business'),
('Self-Help');

INSERT INTO publishers (publisher_name) VALUES
('Penguin Random House'),
('O''Reilly Media'),
('Pearson'),
('HarperCollins');

INSERT INTO authors (author_name, country) VALUES
('George Orwell', 'United Kingdom'),
('Robert C. Martin', 'United States'),
('Yuval Noah Harari', 'Israel'),
('James Clear', 'United States'),
('Andrew S. Tanenbaum', 'Netherlands'),
('Morgan Housel', 'United States'),
('Jane Austen', 'United Kingdom'),
('Kathy Sierra', 'United States');

INSERT INTO books
(isbn, title, author_id, publisher_id, category_id, publication_year, price)
VALUES
('9780451524935', '1984', 1, 1, 1, 1949, 399.00),
('9780132350884', 'Clean Code', 2, 3, 2, 2008, 899.00),
('9780062316097', 'Sapiens', 3, 4, 3, 2015, 599.00),
('9780735211292', 'Atomic Habits', 4, 1, 5, 2018, 499.00),
('9780133591620', 'Computer Networks', 5, 3, 2, 2010, 999.00),
('9780857197689', 'The Psychology of Money', 6, 1, 4, 2020, 450.00),
('9780141439518', 'Pride and Prejudice', 7, 1, 1, 1813, 299.00),
('9780596007126', 'Head First Design Patterns', 8, 2, 2, 2004, 799.00),
('9780061120084', 'To Kill a Mockingbird', 1, 4, 1, 1960, 350.00),
('9780134494166', 'Database Systems', 5, 3, 2, 2019, 750.00);

INSERT INTO customers
(full_name, email, phone, created_at)
VALUES
('Aarav Sharma', 'aarav@example.com', '9000000001', '2025-01-10'),
('Priya Kumar', 'priya@example.com', '9000000002', '2025-01-15'),
('Rahul Verma', 'rahul@example.com', '9000000003', '2025-02-02'),
('Ananya Iyer', 'ananya@example.com', '9000000004', '2025-02-14'),
('Kiran Patel', 'kiran@example.com', '9000000005', '2025-03-01'),
('Meera Nair', 'meera@example.com', '9000000006', '2025-03-12'),
('Vikram Singh', 'vikram@example.com', '9000000007', '2025-04-03'),
('Divya Rao', 'divya@example.com', '9000000008', '2025-04-20');

INSERT INTO inventory (book_id, stock_quantity, reorder_level) VALUES
(1, 20, 5),
(2, 12, 4),
(3, 15, 5),
(4, 18, 5),
(5, 8, 3),
(6, 25, 6),
(7, 14, 4),
(8, 10, 3),
(9, 6, 3),
(10, 9, 4);

INSERT INTO orders (customer_id, order_date, order_status) VALUES
(1, '2025-01-12 10:00:00', 'Completed'),
(2, '2025-01-20 11:30:00', 'Completed'),
(1, '2025-02-05 14:00:00', 'Completed'),
(3, '2025-02-17 09:15:00', 'Completed'),
(4, '2025-03-03 16:20:00', 'Completed'),
(2, '2025-03-19 12:00:00', 'Completed'),
(5, '2025-04-08 13:45:00', 'Completed'),
(6, '2025-04-16 15:10:00', 'Cancelled'),
(1, '2025-05-02 10:25:00', 'Completed'),
(7, '2025-05-14 17:00:00', 'Pending'),
(8, '2025-06-01 09:00:00', 'Completed'),
(3, '2025-06-10 18:30:00', 'Completed');

INSERT INTO order_items
(order_id, book_id, quantity, unit_price)
VALUES
(1, 1, 1, 399.00),
(1, 4, 1, 499.00),
(2, 2, 1, 899.00),
(2, 6, 2, 450.00),
(3, 3, 1, 599.00),
(3, 4, 1, 499.00),
(4, 5, 1, 999.00),
(4, 2, 1, 899.00),
(5, 7, 2, 299.00),
(5, 1, 1, 399.00),
(6, 4, 2, 499.00),
(6, 6, 1, 450.00),
(7, 8, 1, 799.00),
(7, 10, 1, 750.00),
(8, 9, 1, 350.00),
(9, 2, 1, 899.00),
(9, 4, 1, 499.00),
(9, 6, 1, 450.00),
(10, 3, 1, 599.00),
(11, 1, 1, 399.00),
(11, 7, 1, 299.00),
(12, 5, 1, 999.00),
(12, 10, 1, 750.00);

-- 3. INDEXES

CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_category ON books(category_id);
CREATE INDEX idx_books_author ON books(author_id);
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
CREATE INDEX idx_orders_status_date ON orders(order_status, order_date);
CREATE INDEX idx_order_items_book ON order_items(book_id);

-- 4. VIEW: BOOK SALES SUMMARY

CREATE VIEW v_book_sales_summary AS
SELECT
    b.book_id,
    b.title,
    COALESCE(
        SUM(CASE WHEN o.order_status = 'Completed'
            THEN oi.quantity ELSE 0 END), 0
    ) AS units_sold,
    COALESCE(
        SUM(CASE WHEN o.order_status = 'Completed'
            THEN oi.quantity * oi.unit_price ELSE 0 END), 0.00
    ) AS revenue
FROM books b
LEFT JOIN order_items oi ON b.book_id = oi.book_id
LEFT JOIN orders o ON oi.order_id = o.order_id
GROUP BY b.book_id, b.title;

-- 5. STORED PROCEDURE: SEARCH BOOKS

DELIMITER //

CREATE PROCEDURE sp_search_books(IN p_search_term VARCHAR(200))
BEGIN
    SELECT
        b.book_id,
        b.title,
        a.author_name,
        c.category_name,
        b.price,
        i.stock_quantity
    FROM books b
    JOIN authors a ON b.author_id = a.author_id
    JOIN categories c ON b.category_id = c.category_id
    JOIN inventory i ON b.book_id = i.book_id
    WHERE b.title LIKE CONCAT('%', p_search_term, '%')
    ORDER BY b.title;
END //

DELIMITER ;

-- 6. TRIGGER: CHECK STOCK BEFORE ORDER ITEM INSERTION

DELIMITER //

CREATE TRIGGER trg_order_item_after_insert
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE current_stock INT DEFAULT NULL;

    SELECT MAX(stock_quantity)
    INTO current_stock
    FROM inventory
    WHERE book_id = NEW.book_id;

    IF current_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Inventory record not found for this book';
    ELSEIF NEW.quantity > current_stock THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient stock for this book';
    END IF;
END //

DELIMITER ;

-- 7. VALIDATE TABLES AND SAMPLE DATA

SHOW TABLES;

SELECT 'categories' AS table_name, COUNT(*) AS total_rows FROM categories
UNION ALL SELECT 'publishers', COUNT(*) FROM publishers
UNION ALL SELECT 'authors', COUNT(*) FROM authors
UNION ALL SELECT 'books', COUNT(*) FROM books
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;

-- 8. BOOK CATALOGUE

SELECT
    b.title,
    a.author_name,
    c.category_name,
    b.price,
    i.stock_quantity
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id
JOIN inventory i ON b.book_id = i.book_id
ORDER BY b.title;

-- 9. STORED PROCEDURE TEST

CALL sp_search_books('Code');

-- 10. COMPLETED SALES REPORT

SELECT
    COUNT(DISTINCT o.order_id) AS completed_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price) /
        NULLIF(COUNT(DISTINCT o.order_id), 0), 2
    ) AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';

-- 11. TOP-SELLING BOOKS

SELECT title, units_sold, ROUND(revenue, 2) AS revenue
FROM v_book_sales_summary
ORDER BY units_sold DESC, revenue DESC
LIMIT 5;

-- 12. MONTHLY REVENUE AND GROWTH

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),
comparison AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month) AS previous_revenue
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_revenue, 2) AS previous_revenue,
    ROUND(revenue - previous_revenue, 2) AS revenue_change,
    ROUND(
        100 * (revenue - previous_revenue) /
        NULLIF(previous_revenue, 0), 2
    ) AS growth_percentage
FROM comparison
ORDER BY sales_month;

-- 13. RANK BOOKS WITHIN EACH CATEGORY

WITH category_book_sales AS (
    SELECT
        c.category_name,
        b.book_id,
        b.title,
        SUM(
            CASE WHEN o.order_status = 'Completed'
                THEN oi.quantity ELSE 0 END
        ) AS units_sold
    FROM categories c
    JOIN books b ON b.category_id = c.category_id
    LEFT JOIN order_items oi ON oi.book_id = b.book_id
    LEFT JOIN orders o ON o.order_id = oi.order_id
    GROUP BY c.category_name, b.book_id, b.title
)
SELECT
    category_name,
    title,
    units_sold,
    DENSE_RANK() OVER (
        PARTITION BY category_name
        ORDER BY units_sold DESC
    ) AS category_rank
FROM category_book_sales
ORDER BY category_name, category_rank, title;

-- 14. REPEAT CUSTOMER REPORT

SELECT
    c.full_name,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.full_name
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_spent DESC;

-- 15. INVENTORY REORDER REPORT

SELECT
    b.title,
    i.stock_quantity,
    i.reorder_level
FROM inventory i
JOIN books b ON b.book_id = i.book_id
WHERE i.stock_quantity <= i.reorder_level
ORDER BY i.stock_quantity;

-- 16. CUSTOMER SEGMENTATION

WITH customer_metrics AS (
    SELECT
        c.customer_id,
        c.full_name,
        DATEDIFF(
            (SELECT MAX(order_date)
             FROM orders
             WHERE order_status = 'Completed'),
            MAX(CASE WHEN o.order_status = 'Completed'
                THEN o.order_date END)
        ) AS recency_days,
        COUNT(DISTINCT CASE WHEN o.order_status = 'Completed'
            THEN o.order_id END) AS frequency,
        COALESCE(
            SUM(CASE WHEN o.order_status = 'Completed'
                THEN oi.quantity * oi.unit_price ELSE 0 END), 0
        ) AS monetary
    FROM customers c
    LEFT JOIN orders o ON o.customer_id = c.customer_id
    LEFT JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.full_name
)
SELECT
    customer_id,
    full_name,
    recency_days,
    frequency,
    ROUND(monetary, 2) AS monetary,
    CASE
        WHEN frequency >= 2 AND monetary >= 1500 THEN 'High Value'
        WHEN frequency >= 2 THEN 'Repeat Customer'
        WHEN frequency = 1 THEN 'One-Time Customer'
        ELSE 'No Completed Orders'
    END AS customer_segment
FROM customer_metrics
ORDER BY monetary DESC;

-- 17. QUERY EXECUTION PLAN

EXPLAIN
SELECT *
FROM books
WHERE title = 'Clean Code';


