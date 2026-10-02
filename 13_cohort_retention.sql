WITH first_purchase AS (
  SELECT c.customer_unique_id,
         MIN(TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')) AS cohort_month
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
),
customer_orders AS (
  SELECT c.customer_unique_id,
         TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS order_month
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  WHERE o.order_status = 'delivered'
),
cohort_activity AS (
  SELECT fp.cohort_month,
         co.order_month,
         MONTHS_BETWEEN(TO_DATE(co.order_month, 'YYYY-MM'), TO_DATE(fp.cohort_month, 'YYYY-MM')) AS months_since_first,
         COUNT(DISTINCT fp.customer_unique_id) AS num_customers
  FROM first_purchase fp
  JOIN customer_orders co ON fp.customer_unique_id = co.customer_unique_id
  GROUP BY fp.cohort_month, co.order_month
)
SELECT cohort_month,
       months_since_first,
       num_customers
FROM cohort_activity
WHERE cohort_month IN ('2017-01', '2017-06', '2018-01')
ORDER BY cohort_month, months_since_first;