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
       LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY month)) 
             / LAG(revenue) OVER (ORDER BY month), 2) AS mom_growth_pct
FROM monthly
ORDER BY month;