#1. Stores with the highest stock levels for each product:
SELECT 
    p.product_name,
    s.store_name,
    st.quantity AS stock_level
FROM stocks st
JOIN stores s ON st.store_id = s.store_id
JOIN products p ON st.product_id = p.product_id
WHERE (p.product_id, st.quantity) IN (
    SELECT product_id, MAX(quantity)
    FROM stocks
    GROUP BY product_id
);

#2. Products out of stock in all stores:
SELECT p.product_name
FROM products p
LEFT JOIN stocks st ON p.product_id = st.product_id
WHERE st.quantity IS NULL OR st.quantity = 0
GROUP BY p.product_id;

#3. Number of unique products available in each store:
SELECT 
    s.store_name, 
    COUNT(DISTINCT st.product_id) AS unique_products
FROM stores s
JOIN stocks st ON s.store_id = st.store_id
WHERE st.quantity > 0
GROUP BY s.store_id;

#4. Stores with the lowest average product quantity in stock:
SELECT 
    s.store_name, 
    AVG(st.quantity) AS avg_quantity
FROM stores s
JOIN stocks st ON s.store_id = st.store_id
GROUP BY s.store_id
ORDER BY avg_quantity ASC
LIMIT 1;

#5. Total value of inventory in each store:
SELECT 
    s.store_name,
    SUM(st.quantity * p.list_price) AS total_inventory_value
FROM stores s
JOIN stocks st ON s.store_id = st.store_id
JOIN products p ON st.product_id = p.product_id
GROUP BY s.store_id;

#6. Products only available in one store:
SELECT 
    p.product_name, 
    COUNT(DISTINCT st.store_id) AS store_count
FROM products p
JOIN stocks st ON p.product_id = st.product_id
GROUP BY p.product_id
HAVING store_count = 1;

#7. Stock count for each brand across all stores:
SELECT 
    b.brand_name, 
    SUM(st.quantity) AS total_stock
FROM brands b
JOIN products p ON b.brand_id = p.brand_id
JOIN stocks st ON p.product_id = st.product_id
GROUP BY b.brand_name;


#8. Categories with the lowest stock levels across all stores:
SELECT 
    c.category_name, 
    SUM(st.quantity) AS total_stock
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN stocks st ON p.product_id = st.product_id
GROUP BY c.category_name
ORDER BY total_stock ASC
LIMIT 1;

#9. Number of stores with fewer than 10 units in stock for any product:
SELECT COUNT(DISTINCT s.store_id) AS store_count
FROM stores s
JOIN stocks st ON s.store_id = st.store_id
WHERE st.quantity < 10;

#10. Most stocked product across all stores:
SELECT 
    p.product_name, 
    SUM(st.quantity) AS total_stock
FROM products p
JOIN stocks st ON p.product_id = st.product_id
GROUP BY p.product_id
ORDER BY total_stock DESC
LIMIT 1;

