#1. Total number of customers:
SELECT COUNT(*) AS total_customers
FROM customers;

#2. How many customers are from each state:
SELECT state, COUNT(*) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC;

#3. Top 10 customers based on total amount spent:
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
       SUM(oi.quantity * oi.sale_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 10;

#4. Average number of orders placed per customer:
SELECT AVG(order_count) AS avg_orders_per_customer
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
) subquery;

#5. Customers with the highest number of orders:
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_orders DESC
LIMIT 10;

#6. Customers with the highest quantity of products in a single order:
SELECT o.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
       o.order_id, SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.customer_id, customer_name
ORDER BY total_quantity DESC
LIMIT 5;

#7. Percentage of customers from states with active stores:
SELECT 
    ROUND(100 * (
        SELECT COUNT(DISTINCT c.customer_id)
        FROM customers c
        WHERE c.state IN (SELECT DISTINCT state FROM stores)
    ) / COUNT(DISTINCT c.customer_id), 2) AS percentage_active_states,
    ROUND(100 * (
        SELECT COUNT(DISTINCT c.customer_id)
        FROM customers c
        WHERE c.state NOT IN (SELECT DISTINCT state FROM stores)
    ) / COUNT(DISTINCT c.customer_id), 2) AS percentage_inactive_states
FROM customers c;

#8. Number of repeat customers:
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) subquery;


