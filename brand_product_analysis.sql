#Total revenue for each product category:
SELECT 
    c.category_name, 
    SUM(oi.quantity * oi.sale_price ) AS total_revenue
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_name;

#Products never ordered:
SELECT 
    p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

#Average list price of products in each category:
SELECT 
    c.category_name, 
    AVG(p.list_price) AS avg_list_price
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;

#Number of products associated with each brand:
SELECT 
    b.brand_name, 
    COUNT(p.product_id) AS product_count
FROM brands b
JOIN products p ON b.brand_id = p.brand_id
GROUP BY b.brand_name;

#Top 5 categories based on the number of orders placed:
SELECT 
    c.category_name, 
    COUNT(oi.order_id) AS order_count
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY order_count DESC
LIMIT 5;

#Product with the highest average discount applied:
SELECT 
    p.product_name, 
    AVG(oi.discount_percentage) AS avg_discount
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY avg_discount DESC
LIMIT 1;

#Total revenue generated for each category:
SELECT 
    c.category_name, 
    SUM(oi.quantity * oi.sale_price) AS total_revenue
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_name;
