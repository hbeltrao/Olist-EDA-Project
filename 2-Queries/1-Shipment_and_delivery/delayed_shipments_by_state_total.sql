-- Query to analyze the efficiency of order dispatch by state, showcasing orders shipped on time
-- and order shipped with delay, calculating % of orders shipped with delay and the average
-- delay time
-- Query conditions:
-- 		> consider only orders wich have order_delivered_carrier_date not null or blank
--    > data will be aggregated by state of order origin

SELECT 
	t.customer_state AS state,
	SUM(CASE WHEN t.Shipping_Status = 0 THEN 1 ELSE 0 END) AS Shipped_on_schedule,
    SUM(t.Shipping_Status) AS Shipped_with_delay,
    count(t.order_id) AS total_shipments,
    ROUND(SUM(t.Shipping_Status)/count(t.Shipping_Status)*100,2) AS Delay_Percentage,
    
    -- The negative values are from the orders shipped on schedule, so we filter only the positive values,
    -- using case without the ELSE condition results in NULL values for the negative delays, this form the
    -- null values are not considered on denominator of the average calculus.
    -- Also, since the delay was calculated in minutes, the division by 1440 is to convert the delay to days
    -- and round the value to 3 decimals
    (CASE WHEN AVG(CASE WHEN t.delay > 0 THEN t.delay END) IS NOT NULL 
		  THEN ROUND(AVG(CASE WHEN t.delay > 0 THEN (t.delay / 1440) END), 3) ELSE 0 END) AS Average_Delay,
    
    -- simple calculus to get the time between order purchase and shipment
    ROUND(AVG(timestampdiff(minute, t.order_purchase_timestamp, t.order_delivered_carrier_date))/1440,3) AS Average_Shipping_time,
    
    -- Calculate the average shipping estimate
    ROUND(AVG(timestampdiff(minute, t.order_purchase_timestamp, t.shipping_limit_date))/1440,3) AS Average_Shipping_estimate
 
 -- using subquery on FROM helps filtering the necessary data, aliasing calculated columns and keeping
 -- the code clean
FROM(
	SELECT o.order_id, o.order_delivered_carrier_date, i.shipping_limit_date, o.order_purchase_timestamp,
		c.customer_state,
    
    -- creating the shipping_status column to facilitate the count of orders with delay
		(CASE WHEN o.order_delivered_carrier_date <= i.shipping_limit_date THEN 0
			 WHEN o.order_delivered_carrier_date > i.shipping_limit_date THEN 1
             ELSE "Not shipped" END) AS Shipping_Status,
        
        -- Using timestampdiff() to have more precision and correctly calculate when the delay is less than an hour
		timestampdiff(MINUTE, i.shipping_limit_date, o.order_delivered_carrier_date) AS delay
		
	FROM olist_orders_dataset AS o
    
    LEFT  JOIN olist_order_items_dataset AS i
    ON o.order_id = i.order_id
    
    LEFT JOIN olist_customers_dataset as c
    ON o.customer_id = c.customer_id
    
    WHERE o.order_delivered_carrier_date NOT LIKE ''
    ) AS t

WHERE order_delivered_carrier_date BETWEEN %s AND %s
    
GROUP BY t.customer_state
ORDER BY Delay_Percentage DESC;