SELECT * FROM (
  SELECT ct.product_category_name_english AS category,
         COUNT(DISTINCT oi.order_id) AS num_orders,
         ROUND(SUM(oi.price), 2) AS total_revenue
  FROM order_items oi
  JOIN orders o ON oi.order_id = o.order_id
  JOIN products p ON oi.product_id = p.product_id
  JOIN category_translation ct ON p.product_category_name = ct.product_category_name
  WHERE o.order_status = 'delivered'
  GROUP BY ct.product_category_name_english
  ORDER BY total_revenue DESC
)
WHERE ROWNUM <= 10;