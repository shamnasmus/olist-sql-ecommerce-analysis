SELECT c.customer_state,
       COUNT(DISTINCT o.order_id) AS num_orders,
       ROUND(AVG(TO_DATE(o.order_delivered_customer_date, 'YYYY-MM-DD HH24:MI:SS') - o.order_purchase_timestamp), 1) AS avg_actual_delivery_days,
       ROUND(AVG(o.order_estimated_delivery_date - o.order_purchase_timestamp), 1) AS avg_estimated_delivery_days,
       ROUND(AVG(TO_DATE(o.order_delivered_customer_date, 'YYYY-MM-DD HH24:MI:SS') - o.order_estimated_delivery_date), 1) AS avg_days_early_or_late
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_actual_delivery_days DESC;