CREATE DATABASE bookstore;
USE bookstore;

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100),
    price INT);
INSERT INTO books VALUES 
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', 12),
(2, '1984', 'George Orwell', 10),
(3, 'To Kill a Mockingbird', 'Harper Lee', 9),
(4, 'Pride and Prejudice', 'Jane Austen', 8),
(5, 'The Hobbit', 'J.R.R. Tolkien', 14);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    join_date DATE
);
INSERT INTO customers VALUES
(1, 'John Smith', 'john@example.com', '2022-01-15'),
(2, 'Alice Johnson', 'alice@example.com', '2022-02-20'),
(3, 'Bob Brown', 'bob@example.com', '2022-03-10'),
(4, 'Emily Davis', 'emily@example.com', '2022-04-05');

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total_amount INT
);
INSERT INTO orders VALUES
(101, 1, '2022-05-01', 38),
(102, 2, '2022-05-02', 21),
(103, 1, '2022-05-10', 14),
(104, 3, '2022-05-15', 30);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    book_id INT REFERENCES books(book_id),
    quantity INT
);
INSERT INTO order_items VALUES
(1001, 101, 1, 1),
(1002, 101, 3, 2),
(1003, 102, 2, 1),
(1004, 102, 4, 1),
(1005, 103, 5, 1),
(1006, 104, 1, 1),
(1007, 104, 2, 2);

CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    book_id INT REFERENCES books(book_id),
    customer_id INT REFERENCES customers(customer_id),
    rating INT CHECK (rating BETWEEN 1 AND 5)
);
INSERT INTO reviews VALUES
(5001, 1, 1, 5),
(5002, 3, 1, 4),
(5003, 2, 2, 3),
(5004, 4, 2, 5),
(5005, 1, 3, 4),
(5006, 5, 4, 5);

SELECT title, author, price
FROM books
WHERE price > 10
ORDER BY price DESC;

SELECT customers.name, orders.order_date, orders.total_amount
FROM customers
JOIN orders ON customers.customer_id= orders.customer_id
WHERE orders.total_amount > 20;

SELECT title, price
FROM books
WHERE book_id IN(
SELECT book_id
FROM reviews
WHERE rating=5 );

SELECT "High Rated" as category, title
FROM books 
WHERE book_id IN(SELECT book_id FROM reviews WHERE rating >= 4)
UNION
SELECT "Low Rated" as category, title
FROM books
WHERE book_id IN(SELECT book_id FROM reviews WHERE rating <4);


SELECT 
    c.name,
    COUNT(o.order_id) as order_count,
    SUM(o.total_amount) as total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.order_id) > 0;
