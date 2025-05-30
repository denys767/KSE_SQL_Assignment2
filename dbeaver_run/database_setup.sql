-- Create database
CREATE DATABASE IF NOT EXISTS ecommerce_optimization;
USE ecommerce_optimization;

-- Create tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50),
    description TEXT
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    category_id INT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    description TEXT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP,
    status VARCHAR(20),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data
-- Categories
INSERT INTO categories VALUES 
(1, 'Electronics', 'Electronic devices and accessories'),
(2, 'Clothing', 'Apparel and fashion items'),
(3, 'Books', 'Books and publications'),
(4, 'Home & Garden', 'Home improvement and garden supplies');

-- Products
INSERT INTO products VALUES 
(1, 1, 'Smartphone', 699.99, 'Latest model smartphone'),
(2, 1, 'Laptop', 1299.99, 'High-performance laptop'),
(3, 2, 'T-Shirt', 19.99, 'Cotton t-shirt'),
(4, 2, 'Jeans', 49.99, 'Denim jeans'),
(5, 3, 'Novel', 14.99, 'Bestselling novel'),
(6, 4, 'Garden Tools', 29.99, 'Basic garden tool set');

-- Customers
INSERT INTO customers VALUES 
(1, 'John', 'Doe', 'john@example.com', '2023-01-01'),
(2, 'Jane', 'Smith', 'jane@example.com', '2023-01-15'),
(3, 'Bob', 'Johnson', 'bob@example.com', '2023-02-01'),
(4, 'Alice', 'Brown', 'alice@example.com', '2023-02-15'),
(5, 'Charlie', 'Wilson', 'charlie@example.com', '2023-03-01');

-- Orders
INSERT INTO orders VALUES 
(1, 1, '2023-12-01', 'completed', 719.98),
(2, 1, '2023-12-15', 'completed', 1299.99),
(3, 2, '2023-12-05', 'completed', 69.98),
(4, 3, '2023-12-10', 'completed', 14.99),
(5, 4, '2023-12-20', 'completed', 79.98),
(6, 5, '2023-12-25', 'completed', 29.99);

-- Order Items
INSERT INTO order_items VALUES 
(1, 1, 1, 699.99),
(1, 3, 1, 19.99),
(2, 2, 1, 1299.99),
(3, 3, 2, 19.99),
(3, 4, 1, 49.99),
(4, 5, 1, 14.99),
(5, 4, 1, 49.99),
(5, 6, 1, 29.99),
(6, 6, 1, 29.99);