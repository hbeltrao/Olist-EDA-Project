SELECT 
	EXTRACT(YEAR_MONTH FROM o.order_delivered_customer_date) as Months, 
    sum(r.five_stars) AS five_stars, 
    sum(r.tot_reviews) AS tot_reviews,
    ROUND(SUM(r.five_stars)/SUM(r.tot_reviews)*100, 2) AS percentage
FROM olist_orders_dataset AS o
LEFT JOIN (
	SELECT distinct order_id,
		   CASE WHEN review_score = 5 THEN 1 ELSE 0 END AS five_stars,
		   CASE WHEN review_score < 6 THEN 1 ELSE 0 END AS tot_reviews
	FROM olist_order_reviews_dataset) as r
ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date BETWEEN %s AND %s
	AND o.order_status = 'delivered'
GROUP BY EXTRACT(YEAR_MONTH FROM o.order_delivered_customer_date)
ORDER BY Months;

