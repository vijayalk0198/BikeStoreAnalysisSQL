#Monthly revenue trend for each store:
SELECT 
    s.store_name,
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * (oi.list_price - oi.sale_price)) AS monthly_revenue
FROM stores s
JOIN orders o ON s.store_id = o.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name, DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY s.store_name, month;

#Total revenue generated in each quarter:
SELECT 
    CONCAT(YEAR(o.order_date), '-Q', QUARTER(o.order_date)) AS quarter,
    SUM(oi.quantity * (oi.list_price - (oi.sale_price))) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date), QUARTER(o.order_date)
ORDER BY quarter;

#Revenue trend for the top 3 product categories over the past year:
WITH TopCategories AS (
    SELECT 
        c.category_id,
        c.category_name,
        SUM(oi.quantity * (oi.list_price - oi.sale_price)) AS total_revenue
    FROM categories c
    JOIN products p ON c.category_id = p.category_id
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    GROUP BY c.category_id, c.category_name
    ORDER BY total_revenue DESC
    LIMIT 3
)
SELECT 
    tc.category_name,
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * (oi.list_price - oi.sale_price)) AS monthly_revenue
FROM TopCategories tc
JOIN products p ON tc.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY tc.category_name, DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY tc.category_name, month;

#Months with the highest number of orders:
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(o.order_id) AS order_count
FROM orders o
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY order_count DESC
LIMIT 1;

#Average shipping delay by month:
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    AVG(DATEDIFF(o.shipped_date, o.order_date)) AS avg_shipping_delay
FROM orders o
WHERE o.shipped_date IS NOT NULL
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

#Total revenue for each year:
SELECT 
    YEAR(o.order_date) AS year,
    SUM(oi.quantity * oi.sale_price) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date)
ORDER BY year;

#Average order size change over the years:
SELECT 
    YEAR(o.order_date) AS year,
    AVG(oi.quantity) AS avg_order_size
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date)
ORDER BY year;

