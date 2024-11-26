#1) Brands Table: Check if there are any NULL values in any columns
SELECT * FROM brands
WHERE brand_id IS NULL OR brand_name IS NULL;

#2) Categories Table: Check if there are any NULL values in any columns
SELECT * FROM categories
WHERE category_id IS NULL OR category_name IS NULL;

#3) Customers Table:
-- Check for NULL values in the customers table
SELECT * FROM customers
WHERE customer_id IS NULL 
   OR first_name IS NULL 
   OR last_name IS NULL 
   OR phone IS NULL 
   OR email IS NULL 
   OR street IS NULL 
   OR city IS NULL 
   OR state IS NULL 
   OR zip_code IS NULL;



-- Check if first_name and last_name start with a capital letter
SELECT customer_id, first_name, last_name
FROM customers
WHERE NOT first_name REGEXP '^[A-Z]'  -- first_name does not start with a capital letter
   OR NOT last_name REGEXP '^[A-Z]';  -- last_name does not start with a capital letter

-- Check if zip_code is not exactly 5 digits
SELECT customer_id, zip_code
FROM customers
WHERE LENGTH(zip_code) != 5 
   OR zip_code NOT REGEXP '^[0-9]{5}$'; -- only digits and exactly 5 digits

-- Check if email format is valid (basic email validation)
SELECT customer_id, email
FROM customers
WHERE email NOT REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

-- Check for NULL values in the order_items table
SELECT * FROM order_items
WHERE order_id IS NULL 
   OR item_id IS NULL 
   OR product_id IS NULL 
   OR quantity IS NULL 
   OR list_price IS NULL 
   OR discount IS NULL
   OR discount_percentage IS NULL;
   
ALTER TABLE order_items DROP COLUMN discount;

-- Create the new column sale_price with two decimal places
ALTER TABLE order_items 
ADD COLUMN sale_price DECIMAL(10, 2) 
AS (TRUNCATE(list_price * (1 - discount_percentage / 100), 2)) STORED;

-- Check for NULL values in the orders table
SELECT * FROM orders
WHERE order_id IS NULL 
   OR customer_id IS NULL 
   OR order_status IS NULL 
   OR order_date IS NULL 
   OR required_date IS NULL 
   OR shipped_date IS NULL 
   OR store_id IS NULL 
   OR staff_id IS NULL;

-- Add a new column `status_description` based on the `order_status`
ALTER TABLE orders
ADD COLUMN status_description VARCHAR(50);

-- Update the `status_description` column with corresponding values
UPDATE orders
SET status_description = 
    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
        ELSE 'Unknown'
    END;

-- Set `shipped_date` to NULL if `order_status` is 3 (Rejected) and `shipped_date` is not already NULL
UPDATE orders
SET shipped_date = NULL
WHERE order_status = 3 AND shipped_date IS NOT NULL;

-- Add a new column `order_year` based on `order_date`
ALTER TABLE orders
ADD COLUMN order_year YEAR;

-- Update the `order_year` column with the year extracted from `order_date`
UPDATE orders
SET order_year = YEAR(order_date);

-- Add a new column `order_month` based on `order_date`
ALTER TABLE orders
ADD COLUMN order_month TINYINT;

-- Update the `order_month` column with the month extracted from `order_date`
UPDATE orders
SET order_month = MONTH(order_date);

-- Add a new column `on_time_status` to indicate whether the order is on-time or late
ALTER TABLE orders
ADD COLUMN on_time_status VARCHAR(10);

-- Update the `on_time_status` column based on the comparison of `shipped_date` and `required_date`
UPDATE orders
SET on_time_status = 
    CASE
        WHEN shipped_date > required_date THEN 'Late'
        WHEN shipped_date <= required_date OR shipped_date IS NULL THEN 'On-time'
        ELSE 'Unknown'
    END;


-- Check for NULL values in the products table
SELECT * FROM products
WHERE product_id IS NULL 
   OR product_name IS NULL 
   OR brand_id IS NULL 
   OR category_id IS NULL 
   OR model_year IS NULL 
   OR list_price IS NULL;


-- Check for NULL values in the staffs table
SELECT * FROM staffs
WHERE staff_id IS NULL 
   OR first_name IS NULL 
   OR last_name IS NULL 
   OR email IS NULL 
   OR phone IS NULL 
   OR active IS NULL 
   OR store_id IS NULL 
   OR manager_id IS NULL;

-- Check if first_name and last_name in the staffs table start with a capital letter
SELECT staff_id, first_name, last_name
FROM staffs
WHERE NOT first_name REGEXP '^[A-Z]'  -- first_name does not start with a capital letter
   OR NOT last_name REGEXP '^[A-Z]';  -- last_name does not start with a capital letter

-- Check for NULL values in the stocks table
SELECT * FROM stocks
WHERE store_id IS NULL 
   OR product_id IS NULL 
   OR quantity IS NULL;

-- Check for NULL values in the stores table
SELECT * FROM stores
WHERE store_id IS NULL 
   OR store_name IS NULL 
   OR phone IS NULL 
   OR email IS NULL 
   OR street IS NULL 
   OR city IS NULL 
   OR state IS NULL 
   OR zip_code IS NULL;
