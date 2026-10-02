SELECT * FROM (
  SELECT s.seller_id,
         s.seller_state,
         COUNT(DISTINCT oi.order_id) AS num_orders,
         ROUND(SUM(oi.price), 2) AS total_revenue,
         ROUND(AVG(r.review_score), 2) AS avg_review_score,
         ROUND(100 * SUM(CASE WHEN TO_DATE(o.order_delivered_customer_date, 'YYYY-MM-DD HH24:MI:SS') > o.order_estimated_delivery_date 
                               THEN 1 ELSE 0 END) / COUNT(DISTINCT o.order_id), 2) AS late_delivery_pct
  FROM sellers s
  JOIN order_items oi ON s.seller_id = oi.seller_id
  JOIN orders o ON oi.order_id = o.order_id
  LEFT JOIN order_reviews r ON o.order_id = r.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY s.seller_id, s.seller_state
  HAVING COUNT(DISTINCT oi.order_id) >= 20
  ORDER BY total_revenue DESC
)
WHERE ROWNUM <= 15;