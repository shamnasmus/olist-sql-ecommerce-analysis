SELECT TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS month,
       COUNT(DISTINCT o.order_id) AS total_orders,
       ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY TO_CHAR(order_purchase_timestamp, 'YYYY-MM')
ORDER BY month;