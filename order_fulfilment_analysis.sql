#1. Percentage of orders shipped on time vs. late:
SELECT 
    ROUND(100 * SUM(CASE WHEN o.shipped_date <= o.required_date THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_percentage,
    ROUND(100 * SUM(CASE WHEN o.shipped_date > o.required_date THEN 1 ELSE 0 END) / COUNT(*), 2) AS late_percentage
FROM orders o;

#2. Average shipping time (order_date to shipped_date) for each store:
SELECT 
    s.store_name,
    AVG(DATEDIFF(o.shipped_date, o.order_date)) AS avg_shipping_time
FROM stores s
JOIN orders o ON s.store_id = o.store_id
WHERE o.shipped_date IS NOT NULL
GROUP BY s.store_id;

#3. Longest delay in shipping:
SELECT 
    o.order_id, 
    MAX(DATEDIFF(o.shipped_date, o.required_date)) AS longest_delay
FROM orders o
WHERE o.shipped_date > o.required_date;

#4. Number of cancelled orders and their total value:
SELECT 
    COUNT(*) AS cancelled_orders, 
    SUM(oi.quantity * oi.list_price) AS total_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 3;

#5. Fulfilment rate for each store:
SELECT 
    s.store_name,
    ROUND(100 * SUM(CASE WHEN o.shipped_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS fulfilment_rate
FROM stores s
JOIN orders o ON s.store_id = o.store_id
GROUP BY s.store_id;

#6. Average quantity of items in an order:
SELECT 
    AVG(order_quantity) AS avg_items_per_order
FROM (
    SELECT 
        o.order_id, 
        SUM(oi.quantity) AS order_quantity
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
) subquery;

#7. Orders containing items from multiple product categories:
SELECT 
    COUNT(*) AS multi_category_orders
FROM (
    SELECT 
        o.order_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY o.order_id
    HAVING COUNT(DISTINCT p.category_id) > 1
) subquery;

