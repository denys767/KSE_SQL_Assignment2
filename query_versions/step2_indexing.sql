CREATE INDEX idx_orders_status_date ON orders(status, order_date);

-- Covering index to avoid table scan on order_items
CREATE INDEX idx_order_items_covering ON order_items(order_id, product_id, quantity);
CREATE INDEX idx_products_productid_price ON products(product_id, price, category_id);
CREATE INDEX idx_categories_categoryid_name ON categories(category_id, category_name);





WITH recent_orders AS (
    SELECT 
        order_id,
        customer_id
    FROM orders USE INDEX (idx_orders_status_date)
    WHERE order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
      AND status = 'completed'
),
order_totals AS (
    SELECT 
        ro.customer_id,
        oi.order_id,
        SUM(oi.quantity * p.price) AS order_amount
    FROM recent_orders ro
    JOIN order_items oi USE INDEX (idx_order_items_covering) ON ro.order_id = oi.order_id
    JOIN products p USE INDEX (idx_products_productid_price) ON oi.product_id = p.product_id
    GROUP BY ro.customer_id, oi.order_id
),
customer_categories AS (
    SELECT DISTINCT
        ro.customer_id,
        cat.category_name
    FROM recent_orders ro
    JOIN order_items oi USE INDEX (idx_order_items_covering) ON ro.order_id = oi.order_id
    JOIN products p USE INDEX (idx_products_productid_price) ON oi.product_id = p.product_id
    JOIN categories cat USE INDEX (idx_categories_categoryid_name) ON p.category_id = cat.category_id
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
