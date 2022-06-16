-- Query to analyze the efficiency of order dispatch, showcasing orders shipped on time
-- and order shipped with delay, calculating % of orders shipped with delay and the average
-- delay time per month
-- Query conditions:
-- 		> consider only orders wich status are delivered or shipped
-- 		> the data will be agregated based on the date delivered to the carrier

SELECT 
	extract(Year_Month FROM t.order_delivered_carrier_date) AS year_months,
	SUM(CASE WHEN t.Shipping_Status = 0 THEN 1 ELSE 0 END) AS Shipped_on_schedule,
    SUM(t.Shipping_Status) AS Shipped_with_delay,
    count(t.order_id) AS total_shipments,
    ROUND(SUM(t.Shipping_Status)/count(t.Shipping_Status)*100,2) AS Delay_Percentage,
    
    -- the negative values are from the orders shipped on schedule, so we filter only the positive values,
    -- using case without the ELSE condition results in NULL values for the negative delays, this form the
    -- null values are not considered on denominator of the average calculus
    AVG(CASE WHEN t.delay > 0 THEN t.delay END) AS Average_Delay,
    
    -- simple calculus to get the time between order purchase and shipment
    AVG(datediff(t.order_delivered_carrier_date, t.order_purchase_timestamp)) AS Average_Shipping_time
 
 -- using subquery on FROM helps filtering the necessary data, aliasing calculated columns and keeping
 -- the code clean
FROM(
	SELECT o.order_id, o.order_delivered_carrier_date, i.shipping_limit_date, o.order_purchase_timestamp,
    
    -- creating the shipping_status column to facilitate the count of orders with delay
		(CASE WHEN o.order_delivered_carrier_date <= i.shipping_limit_date THEN 0
			 WHEN o.order_delivered_carrier_date > i.shipping_limit_date THEN 1
             ELSE "Not shipped" END) AS Shipping_Status,
		datediff(o.order_delivered_carrier_date , i.shipping_limit_date) AS delay
		
	FROM olist_orders_dataset AS o
    
    LEFT  JOIN olist_order_items_dataset AS i
    ON o.order_id = i.order_id
    
    WHERE o.order_status = "delivered" OR o.order_status = "shipped"
    ) AS t
    
GROUP BY year_months
ORDER BY year_months;