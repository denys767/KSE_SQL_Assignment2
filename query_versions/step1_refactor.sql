

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
        ro.customer_id,
        oi.order_id,
        SUM(oi.quantity * p.price) AS order_amount
    FROM recent_orders ro
    JOIN order_items oi ON ro.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY ro.customer_id, oi.order_id
),
customer_categories AS (
    SELECT DISTINCT
        ro.customer_id,
        cat.category_name
    FROM recent_orders ro
    JOIN order_items oi ON ro.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT ot.order_id) AS total_orders,
    SUM(ot.order_amount) AS total_spent,
    GROUP_CONCAT(DISTINCT cc.category_name SEPARATOR ', ') AS categories_purchased
FROM customers c
JOIN order_totals ot ON c.customer_id = ot.customer_id
LEFT JOIN customer_categories cc ON c.customer_id = cc.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;