-- Query to show total of purchase orders per year and month.
-- Query conditions:
-- 		> excluding cancelled and unavailable orders

SELECT 
	MONTH(`order_purchase_timestamp`) AS Months,
    SUM(CASE WHEN YEAR(`order_purchase_timestamp`) = 2016 THEN 1 ELSE 0 END) AS "2016_sales",
    SUM(CASE WHEN YEAR(`order_purchase_timestamp`) = 2017 THEN 1 ELSE 0 END) AS "2017_sales",
    SUM(CASE WHEN YEAR(`order_purchase_timestamp`) = 2018 THEN 1 ELSE 0 END) AS "2018_sales"
    
FROM olist_orders_dataset

WHERE 
	order_status <> 'cancelled' 
    AND order_status <> 'unavailable'
    
GROUP BY Months
ORDER BY Months;