-- Query to analyze the efficiency of order delivery, showcasing orders delivered on time
-- and order delivered with delay, calculating % of orders delivered with delay and the average
-- delay time per month
-- Query conditions:
-- 		> consider only orders wich status are delivered or shipped
-- 		> the data will be agregated based on the date delivered to the customer

SELECT 
	extract(Year_Month FROM t.order_delivered_customer_date) AS year_months,
	SUM(CASE WHEN t.delivery_delay_status = 0 THEN 1 ELSE 0 END) AS delivered_on_schedule,
    SUM(t.delivery_delay_status) AS delivered_with_delay,
    count(t.order_id) AS total_deliveries,
    ROUND(SUM(t.delivery_delay_status)/count(t.delivery_delay_status)*100,2) AS delay_percentage,
    
    -- the negative values are from the orders delivered on schedule, so we filter only the positive values,
    -- using case without the ELSE condition results in NULL values for the negative delays, this form the
    -- null values are not considered on denominator of the average calculus.
    -- dividing by 1440 is to convert the values from minutes to days
    ROUND(AVG(CASE WHEN t.delay > 0 THEN t.delay/1440 END),3) AS Average_Delay,
    
    -- simple calculus to get the time between order purchase and delivery (average order lifetime)
    ROUND(AVG(timestampdiff(minute, t.order_purchase_timestamp, t.order_delivered_customer_date))/1440,3) AS average_order_lifetime,
    
    -- Calculate the average delivery duration
    ROUND(AVG(timestampdiff(minute, t.order_delivered_carrier_date, t.order_delivered_customer_date))/1440,3) AS average_delivery_duration
 
 -- using subquery on FROM helps filtering the necessary data, aliasing calculated columns and keeping
 -- the code clean and organized
FROM(
	SELECT o.order_id, o.order_delivered_carrier_date, o.order_purchase_timestamp, o.order_estimated_delivery_date, 
    o.order_delivered_customer_date,
    
    -- creating the delivery_delay_status column to facilitate the count of orders with delay
		(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 0
			 WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1
             ELSE "Not delivered" END) AS delivery_delay_status,
             
		-- Using timestampdiff() instead of datediff to make the calculations on minute level and
        -- properly account the delays below one day (even less than one hour delays)
		timestampdiff(minute, o.order_estimated_delivery_date, o.order_delivered_customer_date) AS delay
		
	FROM olist_orders_dataset AS o
    
    LEFT  JOIN olist_order_items_dataset AS i
    ON o.order_id = i.order_id
    
    WHERE o.order_status LIKE 'delivered'
    ) AS t

WHERE order_delivered_customer_date BETWEEN %s AND %s
    
GROUP BY year_months
ORDER BY year_months;