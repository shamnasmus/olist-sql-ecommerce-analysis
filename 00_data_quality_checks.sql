-- Check 1: Verify date format
SELECT order_purchase_timestamp, 
       TO_CHAR(order_purchase_timestamp, 'YYYY-MM-DD HH24:MI:SS') AS full_format
FROM orders 
WHERE ROWNUM <= 5;

-- Check 2: Orders with missing delivery dates
SELECT COUNT(*) FROM orders WHERE order_delivered_customer_date IS NULL;

-- Check 3: Duplicate order IDs
SELECT order_id, COUNT(*) 
FROM orders 
GROUP BY order_id 
HAVING COUNT(*) > 1;

-- Check 4: Order status breakdown
SELECT order_status, COUNT(*) 
FROM orders 
GROUP BY order_status 
ORDER BY COUNT(*) DESC;