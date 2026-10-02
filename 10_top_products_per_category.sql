WITH product_sales AS (
  SELECT ct.product_category_name_english AS category,
         oi.product_id,
         COUNT(DISTINCT oi.order_id) AS num_orders,
         ROUND(SUM(oi.price), 2) AS total_revenue
  FROM order_items oi
  JOIN orders o ON oi.order_id = o.order_id
  JOIN products p ON oi.product_id = p.product_id
  JOIN category_translation ct ON p.product_category_name = ct.product_category_name
  WHERE o.order_status = 'delivered'
  GROUP BY ct.product_category_name_english, oi.product_id
),
ranked AS (
  SELECT category,
         product_id,
         num_orders,
         total_revenue,
         DENSE_RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rank_in_category
  FROM product_sales
)
SELECT * FROM ranked
WHERE rank_in_category <= 3
AND category IN ('health_beauty', 'watches_gifts', 'bed_bath_table')
ORDER BY category, rank_in_category;