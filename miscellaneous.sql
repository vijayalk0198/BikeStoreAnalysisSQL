#1. Total revenue from repeat customers vs. new customers:
WITH CustomerOrders AS (
    SELECT 
        c.customer_id,
        COUNT(o.order_id) AS order_count,
        SUM(oi.quantity * oi.sale_price) AS total_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id
)
SELECT 
    SUM(CASE WHEN order_count > 1 THEN total_revenue ELSE 0 END) AS repeat_customer_revenue,
    SUM(CASE WHEN order_count = 1 THEN total_revenue ELSE 0 END) AS new_customer_revenue
FROM CustomerOrders;

#2. State with the highest revenue per customer:
SELECT 
    c.state,
    SUM(oi.quantity * oi.sale_price) / COUNT(DISTINCT c.customer_id) AS revenue_per_customer
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.state
ORDER BY revenue_per_customer DESC
LIMIT 1;

#4. Customers ordering products from multiple brands:
SELECT 
    COUNT(DISTINCT o.customer_id) AS multi_brand_customers
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.customer_id
HAVING COUNT(DISTINCT p.brand_id) > 1;

#5. Product and category combination generating the highest revenue:
SELECT 
    p.product_name, 
    c.category_name, 
    SUM(oi.quantity * oi.sale_price) AS total_revenue
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, c.category_name
ORDER BY total_revenue DESC
LIMIT 1;

#Customer retention rate (customers ordering in multiple years):
WITH CustomerYears AS (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT YEAR(o.order_date)) AS order_years
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT 
    COUNT(CASE WHEN order_years > 1 THEN 1 END) / COUNT(*) * 100 AS retention_rate
FROM CustomerYears;

WITH CustomerOrderDurations AS (
    SELECT 
        c.customer_id,
        DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS time_between_orders
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT 
    AVG(time_between_orders) AS avg_time_between_orders
FROM CustomerOrderDurations;
