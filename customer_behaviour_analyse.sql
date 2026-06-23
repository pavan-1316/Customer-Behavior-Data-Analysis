SELECT * 
FROM customer;

SELECT gender,
       SUM("Purchased_Amount") AS revenue
FROM customer
GROUP BY gender;

SELECT customer_id,
       "Purchased_Amount"
FROM customer
WHERE discount_applied = 'Yes'
  AND "Purchased_Amount" >= (
      SELECT AVG("Purchased_Amount")
      FROM customer
  );

SELECT item_purchased,
       ROUND(AVG("review_rating_"::numeric), 3) AS "Average rating"
FROM customer
GROUP BY item_purchased
ORDER BY AVG("review_rating_"::numeric) DESC
LIMIT 5;

SELECT shipping_type,
       AVG("Purchased_Amount") AS avg_purchase
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

SELECT subscription_status,
       COUNT(customer_id) AS total_customer,
       AVG("Purchased_Amount") AS avg_spend,
       SUM("Purchased_Amount") AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC;

SELECT item_purchased,
       ROUND(
           SUM(CASE
                   WHEN discount_applied = 'Yes' THEN 1
                   ELSE 0
               END)::numeric * 100
           / COUNT(*),
           2
       ) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

WITH customer_type AS (
    SELECT customer_id,
           previous_purchases,
           CASE
               WHEN previous_purchases = 1 THEN 'New'
               WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
               ELSE 'Loyal'
           END AS customer_segment
    FROM customer
)
SELECT customer_segment,
       COUNT(*) AS "number of customers"
FROM customer_type
GROUP BY customer_segment;

WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (
               PARTITION BY category
               ORDER BY COUNT(customer_id) DESC
           ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT item_rank,
       category,
       item_purchased,
       total_orders
FROM item_counts
WHERE item_rank <= 3
ORDER BY category, item_rank;

SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

SELECT age_group,
       SUM("Purchased_Amount") AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;






