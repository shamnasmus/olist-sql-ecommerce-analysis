WITH monthly AS (
  SELECT TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
         ROUND(SUM(oi.price), 2) AS revenue
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
)
SELECT month,
       revenue,
       ROUND(SUM(revenue) OVER (ORDER BY month), 2) AS cumulative_revenue,
       ROUND(AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3mo
FROM monthly
ORDER BY month;