USE ecommerce_optimization;

-- Original Query
EXPLAIN ANALYZE
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(oi.quantity * p.price) as total_spent,
    GROUP_CONCAT(DISTINCT cat.category_name SEPARATOR ', ') as categories_purchased
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
WHERE o.order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
    AND o.status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT o.order_id) > 0
ORDER BY total_spent DESC;

-- Step 1: Refactored Query
EXPLAIN ANALYZE
WITH recent_orders AS (
    SELECT 
        order_id,
        customer_id
    FROM orders
    WHERE order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
        AND status = 'completed'
),
order_totals AS (
    SELECT 
        oi.order_id,
        SUM(oi.quantity * p.price) as order_amount
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY oi.order_id
),
customer_categories AS (
    SELECT DISTINCT
        o.customer_id,
        cat.category_name
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    WHERE o.order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
        AND o.status = 'completed'
)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT ro.order_id) as total_orders,
    SUM(ot.order_amount) as total_spent,
    GROUP_CONCAT(DISTINCT cc.category_name SEPARATOR ', ') as categories_purchased
FROM customers c
JOIN recent_orders ro ON c.customer_id = ro.customer_id
JOIN order_totals ot ON ro.order_id = ot.order_id
LEFT JOIN customer_categories cc ON c.customer_id = cc.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Step 2: Query with Index Hints
CREATE INDEX idx_orders_date_status ON orders(order_date, status);
CREATE INDEX idx_order_items_product ON order_items(order_id, product_id);
CREATE INDEX idx_products_category ON products(product_id, category_id);
CREATE INDEX idx_categories_name ON categories(category_id, category_name);
EXPLAIN ANALYZE
WITH recent_orders AS (
    SELECT 
        order_id,
        customer_id
    FROM orders FORCE INDEX (idx_orders_date_status)
    WHERE order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
        AND status = 'completed'
),
order_totals AS (
    SELECT 
        oi.order_id,
        SUM(oi.quantity * p.price) as order_amount
    FROM order_items oi FORCE INDEX (idx_order_items_product)
    JOIN products p FORCE INDEX (idx_products_category)
        ON oi.product_id = p.product_id
    GROUP BY oi.order_id
),
customer_categories AS (
    SELECT DISTINCT
        o.customer_id,
        cat.category_name
    FROM orders o FORCE INDEX (idx_orders_date_status)
    JOIN order_items oi FORCE INDEX (idx_order_items_product)
        ON o.order_id = oi.order_id
    JOIN products p FORCE INDEX (idx_products_category)
        ON oi.product_id = p.product_id
    JOIN categories cat FORCE INDEX (idx_categories_name)
        ON p.category_id = cat.category_id
    WHERE o.order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
        AND o.status = 'completed'
)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT ro.order_id) as total_orders,
    SUM(ot.order_amount) as total_spent,
    GROUP_CONCAT(DISTINCT cc.category_name SEPARATOR ', ') as categories_purchased
FROM customers c
JOIN recent_orders ro ON c.customer_id = ro.customer_id
JOIN order_totals ot ON ro.order_id = ot.order_id
LEFT JOIN customer_categories cc ON c.customer_id = cc.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC; 