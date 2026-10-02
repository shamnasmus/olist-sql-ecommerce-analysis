-- Revenue by state
SELECT c.customer_state,
       COUNT(DISTINCT o.order_id) AS num_orders,
       ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- Top 10 cities
SELECT * FROM (
  SELECT c.customer_city,
         c.customer_state,
         COUNT(DISTINCT o.order_id) AS num_orders,
         ROUND(SUM(oi.price), 2) AS total_revenue
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  JOIN order_items oi ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_city, c.customer_state
  ORDER BY total_revenue DESC
)
WHERE ROWNUM <= 10;