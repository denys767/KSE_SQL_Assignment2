-- Step 1: Query refactoring using CTEs
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