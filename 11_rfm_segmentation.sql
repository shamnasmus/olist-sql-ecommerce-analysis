WITH customer_data AS (
  SELECT c.customer_unique_id,
         MAX(o.order_purchase_timestamp) AS last_purchase_date,
         COUNT(DISTINCT o.order_id) AS frequency,
         ROUND(SUM(oi.price), 2) AS monetary
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  JOIN order_items oi ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
),
rfm_scores AS (
  SELECT customer_unique_id,
         last_purchase_date,
         frequency,
         monetary,
         NTILE(4) OVER (ORDER BY last_purchase_date ASC) AS recency_score,
         NTILE(4) OVER (ORDER BY frequency ASC) AS frequency_score,
         NTILE(4) OVER (ORDER BY monetary ASC) AS monetary_score
  FROM customer_data
)
SELECT 
  recency_score,
  frequency_score,
  monetary_score,
  COUNT(*) AS num_customers,
  ROUND(AVG(monetary), 2) AS avg_spend
FROM rfm_scores
GROUP BY recency_score, frequency_score, monetary_score
ORDER BY recency_score DESC, frequency_score DESC, monetary_score DESC;

#simplified version 
WITH customer_data AS (
  SELECT c.customer_unique_id,
         MAX(o.order_purchase_timestamp) AS last_purchase_date,
         COUNT(DISTINCT o.order_id) AS frequency,
         ROUND(SUM(oi.price), 2) AS monetary
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  JOIN order_items oi ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
),
rfm_scores AS (
  SELECT customer_unique_id,
         last_purchase_date,
         frequency,
         monetary,
         NTILE(4) OVER (ORDER BY last_purchase_date ASC) AS recency_score,
         NTILE(4) OVER (ORDER BY frequency ASC) AS frequency_score,
         NTILE(4) OVER (ORDER BY monetary ASC) AS monetary_score
  FROM customer_data
)
SELECT 
  CASE WHEN recency_score = 4 AND frequency_score = 4 AND monetary_score = 4 THEN 'Best customers (4-4-4)'
       WHEN recency_score = 1 AND frequency_score = 1 AND monetary_score = 1 THEN 'Worst/lost customers (1-1-1)'
       ELSE 'Other'
  END AS segment,
  COUNT(*) AS num_customers,
  ROUND(AVG(monetary), 2) AS avg_spend,
  ROUND(AVG(frequency), 2) AS avg_orders
FROM rfm_scores
GROUP BY CASE WHEN recency_score = 4 AND frequency_score = 4 AND monetary_score = 4 THEN 'Best customers (4-4-4)'
              WHEN recency_score = 1 AND frequency_score = 1 AND monetary_score = 1 THEN 'Worst/lost customers (1-1-1)'
              ELSE 'Other'
         END
ORDER BY avg_spend DESC;