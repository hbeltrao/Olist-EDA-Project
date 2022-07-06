-- Query to analyze the combination of delay on shipping and delivery to assess the impact of shipping delay on delivery delay

SELECT 
	extract(Year_Month FROM t.order_delivered_customer_date) AS year_months,

   sum(case when (delivery_delay_status= 0 and shipping_delay_status = 0) then 1 else 0 END)/count(t.order_id)*100 as Ship_ok_Delivery_ok,
   
   sum(case when (delivery_delay_status= 0 and shipping_delay_status = 1) then 1 else 0 END)/count(t.order_id)*100 as Ship_Late_Delivery_ok,
   
   sum(case when (delivery_delay_status= 1 and shipping_delay_status = 0) then 1 else 0 END)/count(t.order_id)*100 as Ship_ok_Delivery_Late,
   
   sum(case when (delivery_delay_status= 1 and shipping_delay_status = 1) then 1 else 0 END)/count(t.order_id)*100 as Ship_Late_Delivery_Late,
    
   count(t.order_id) As tot_delivered
    
	
 -- using subquery on FROM helps filtering the necessary data, aliasing calculated columns and keeping
 -- the code clean
FROM(
	SELECT o.order_id, o.order_delivered_carrier_date, o.order_purchase_timestamp, o.order_estimated_delivery_date, 
    o.order_delivered_customer_date,
    
    -- creating the delivery_delay_status column to facilitate the count of orders with delay
		(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 0
			 WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1
             ELSE "Not delivered" END) AS delivery_delay_status,
             
	-- creating the shipping_delay_status column to facilitate the count of orders with delay
		(CASE WHEN o.order_delivered_carrier_date <= i.shipping_limit_date THEN 0
			 WHEN o.order_delivered_carrier_date > i.shipping_limit_date THEN 1
             ELSE "Not shipped" END) AS shipping_delay_status,
		
	-- create a column to help calculate the percentage of orders shipped and delivered off schedule
		(CASE WHEN (o.order_delivered_carrier_date > i.shipping_limit_date AND o.order_delivered_customer_date > o.order_estimated_delivery_date)
			THEN 1 ELSE 0 END) AS shiping_delayed_delivery_delayed,
             
	-- create a column to help calculate the percentage of orders shipped on date but delivered off schedule
		(CASE WHEN (o.order_delivered_carrier_date <= i.shipping_limit_date AND o.order_delivered_customer_date > o.order_estimated_delivery_date)
			THEN 1 ELSE 0 END) AS shiping_ok_delivery_delayed,
             
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