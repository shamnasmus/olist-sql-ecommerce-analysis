SELECT payment_type,
       COUNT(*) AS num_payments,
       ROUND(SUM(payment_value), 2) AS total_value,
       ROUND(AVG(payment_installments), 1) AS avg_installments
FROM order_payments
GROUP BY payment_type
ORDER BY total_value DESC;