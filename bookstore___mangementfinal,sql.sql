

CREATE DATABASE IF NOT EXISTS book_management_system_v2;

USE book_management_system_v2;

USE book_management_system_v2;

SHOW TABLES;


CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT NOT NULL,
    category_id INT NOT NULL,
    publisher_id INT NOT NULL,
    publication_year SMALLINT,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    city VARCHAR(100)
);

CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL UNIQUE,
    stock_quantity INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 5,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);


INSERT INTO categories (category_name) VALUES
('Programming'),
('Fiction'),
('Science'),
('Business'),
('Self-Help');

INSERT INTO authors (author_name) VALUES
('Robert C. Martin'),
('George Orwell'),
('James Clear'),
('Yuval Noah Harari'),
('Andrew Hunt');

INSERT INTO publishers (publisher_name) VALUES
('Tech Publications'),
('Knowledge Press'),
('Bright Books'),
('Modern Publishing');

INSERT INTO books
(title, author_id, category_id, publisher_id, publication_year, price)
VALUES
('Clean Code', 1, 1, 1, 2008, 42.50),
('1984', 2, 2, 2, 1949, 15.99),
('Atomic Habits', 3, 5, 3, 2018, 21.50),
('Sapiens', 4, 3, 2, 2011, 24.00),
('The Pragmatic Programmer', 5, 1, 1, 1999, 39.99),
('Animal Farm', 2, 2, 2, 1945, 13.50),
('Clean Architecture', 1, 1, 1, 2017, 36.00),
('The Psychology of Money', 3, 4, 4, 2020, 19.95);

INSERT INTO customers (customer_name, email, city) VALUES
('Arun Kumar', 'arun@example.com', 'Chennai'),
('Priya Sharma', 'priya@example.com', 'Bengaluru'),
('Rahul Das', 'rahul@example.com', 'Hyderabad'),
('Meera Iyer', 'meera@example.com', 'Chennai'),
('Kavin Raj', 'kavin@example.com', 'Coimbatore');

INSERT INTO inventory (book_id, stock_quantity, reorder_level) VALUES
(1, 15, 5),
(2, 20, 5),
(3, 12, 4),
(4, 8, 3),
(5, 6, 3),
(6, 3, 5),
(7, 10, 4),
(8, 7, 3);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2026-01-05', 'Completed'),
(2, '2026-01-15', 'Completed'),
(3, '2026-02-10', 'Pending'),
(1, '2026-02-20', 'Completed'),
(4, '2026-03-05', 'Completed'),
(5, '2026-03-15', 'Cancelled'),
(2, '2026-04-01', 'Completed');

INSERT INTO order_items (order_id, book_id, quantity, unit_price) VALUES
(1, 1, 1, 42.50),
(2, 2, 2, 15.99),
(3, 3, 1, 21.50),
(4, 3, 1, 21.50),
(4, 5, 1, 39.99),
(5, 4, 1, 24.00),
(6, 6, 1, 13.50),
(7, 7, 1, 36.00);




SHOW TABLES;


SELECT * FROM books;

SELECT title, price FROM books;

SELECT *
FROM books
WHERE price > 20;


SELECT title, price
FROM books
ORDER BY price DESC;

SELECT title, price
FROM books
ORDER BY price DESC
LIMIT 5;

SELECT COUNT(*) AS total_books
FROM books;


SELECT AVG(price) AS average_price
FROM books;


SELECT c.category_name,
       COUNT(b.book_id) AS total_books
FROM categories c
LEFT JOIN books b
    ON c.category_id = b.category_id
GROUP BY c.category_id, c.category_name;

SELECT c.category_name,
       COUNT(b.book_id) AS total_books
FROM categories c
JOIN books b
    ON c.category_id = b.category_id
GROUP BY c.category_id, c.category_name
HAVING COUNT(b.book_id) > 1;


SELECT b.title,
       a.author_name,
       c.category_name,
       p.publisher_name,
       b.price
FROM books b
JOIN authors a
    ON b.author_id = a.author_id
JOIN categories c
    ON b.category_id = c.category_id
JOIN publishers p
    ON b.publisher_id = p.publisher_id;


SELECT c.customer_name,
       o.order_id,
       o.order_date,
       o.status
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id;



SELECT b.title,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price) AS sales_amount
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN books b
    ON oi.book_id = b.book_id
WHERE o.status = 'Completed'
GROUP BY b.book_id, b.title
ORDER BY units_sold DESC;



SELECT b.title,
       i.stock_quantity,
       i.reorder_level
FROM inventory i
JOIN books b
    ON i.book_id = b.book_id
WHERE i.stock_quantity <= i.reorder_level
ORDER BY i.stock_quantity;



CREATE INDEX idx_books_title
ON books(title);

CREATE INDEX idx_books_category
ON books(category_id);

CREATE INDEX idx_orders_customer_date
ON orders(customer_id, order_date);

CREATE INDEX idx_order_items_book
ON order_items(book_id);


SHOW INDEX FROM books;



CREATE VIEW book_sales_summary AS
SELECT b.book_id,
       b.title,
       COALESCE(SUM(
           CASE
               WHEN o.status = 'Completed'
               THEN oi.quantity
               ELSE 0
           END
       ), 0) AS units_sold,
       COALESCE(SUM(
           CASE
               WHEN o.status = 'Completed'
               THEN oi.quantity * oi.unit_price
               ELSE 0
           END
       ), 0) AS revenue
FROM books b
LEFT JOIN order_items oi
    ON b.book_id = oi.book_id
LEFT JOIN orders o
    ON oi.order_id = o.order_id
GROUP BY b.book_id, b.title;

SELECT *
FROM book_sales_summary
ORDER BY revenue DESC;



DELIMITER //

CREATE PROCEDURE search_books(IN search_text VARCHAR(100))
BEGIN
    SELECT book_id, title, price
    FROM books
    WHERE title LIKE CONCAT('%', search_text, '%')
    ORDER BY title;
END //

DELIMITER ;

CALL search_books('Clean');



DELIMITER //

CREATE TRIGGER validate_book_stock
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE available_stock INT DEFAULT NULL;

    SELECT stock_quantity
    INTO available_stock
    FROM inventory
    WHERE book_id = NEW.book_id;

    IF available_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inventory record not found';

    ELSEIF NEW.quantity > available_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient book stock';
    END IF;
END //

DELIMITER ;



WITH category_summary AS (
    SELECT c.category_name,
           COUNT(b.book_id) AS total_books
    FROM categories c
    LEFT JOIN books b
        ON c.category_id = b.category_id
    GROUP BY c.category_id, c.category_name
)
SELECT *
FROM category_summary
ORDER BY total_books DESC;


WITH book_sales AS (
    SELECT b.book_id,
           b.title,
           COALESCE(SUM(
               CASE
                   WHEN o.status = 'Completed'
                   THEN oi.quantity
                   ELSE 0
               END
           ), 0) AS units_sold
    FROM books b
    LEFT JOIN order_items oi
        ON b.book_id = oi.book_id
    LEFT JOIN orders o
        ON oi.order_id = o.order_id
    GROUP BY b.book_id, b.title
)
SELECT title,
       units_sold,
       DENSE_RANK() OVER (
           ORDER BY units_sold DESC
       ) AS sales_rank
FROM book_sales
ORDER BY sales_rank, title;



EXPLAIN
SELECT book_id, title, price
FROM books
WHERE title = 'Clean Code';



SELECT COUNT(*) AS total_books
FROM books;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT * FROM book_sales_summary;

