-- Query to extract the total orders reviewed per year-month of the delivery date and showcase
-- the % of 5 star reviews.
-- the query conditions were:
-- 			> The date used to agregate the values is the date of order purchase
-- 			> count only orders that were delivered to customer

SELECT 
	EXTRACT(YEAR_MONTH FROM o.order_purchase_timestamp) as Months, 
    sum(r.five_stars) AS five_stars, 
    sum(r.tot_reviews) AS total_orders_reviewed,
    
    -- count only the orders that are not present on the order review table
    SUM(case WHEN r.order_id IS NULL THEN 1 ELSE 0 END) AS orders_not_reviewed,
    
    -- calculating the percentage based on total orders and not total reviews, to include the
    -- orders without review on the calculation
    ROUND(SUM(r.five_stars)/SUM(oo.total_rows)*100, 2) AS five_star_percentage
    
FROM olist_orders_dataset AS o

LEFT JOIN (
	SELECT order_id,
		   CASE WHEN review_score = 5 THEN 1 ELSE 0 END AS five_stars,
		   CASE WHEN review_score < 6 THEN 1 ELSE 0 END AS tot_reviews
	FROM olist_order_reviews_dataset
    ) AS r
ON o.order_id = r.order_id

-- using self join to create a support column to calculate the total number of orders without 
-- having the influence of the grouping operations
LEFT JOIN (
	SELECT order_id, (CASE WHEN order_id IS NOT NULL THEN 1 ELSE 0 END) AS total_rows 
    FROM olist_orders_dataset
    ) AS oo
ON o.order_id = oo.order_id

-- the between clause is to select the period of data and the %s indicates that the values
-- will be inputed by the python function when the query is called
WHERE o.order_purchase_timestamp BETWEEN %s AND %s
	AND o.order_status = 'delivered'
    
GROUP BY Months
ORDER BY Months;

