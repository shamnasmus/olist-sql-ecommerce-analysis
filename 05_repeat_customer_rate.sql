SELECT 
  CASE WHEN order_count = 1 THEN 'One-time customer'
       ELSE 'Repeat customer'
  END AS customer_type,
  COUNT(*) AS num_customers,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_customers
FROM (
  SELECT c.customer_unique_id,
         COUNT(DISTINCT o.order_id) AS order_count
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
)
GROUP BY CASE WHEN order_count = 1 THEN 'One-time customer' ELSE 'Repeat customer' END;