SELECT 
	extract(Year_Month FROM t.order_delivered_carrier_date) AS year_months,
	SUM(CASE WHEN t.Shipping_Status = 0 THEN 1 ELSE 0 END) AS Shipped_on_schedule,
    SUM(t.Shipping_Status) AS Shipped_with_delay,
    count(t.order_id) AS total_shipments,
    ROUND(SUM(t.Shipping_Status)/count(t.Shipping_Status)*100,2) AS Delay_Percentage,
    AVG(CASE WHEN t.delay > 0 THEN t.delay END) AS Average_Delay,
    AVG(datediff(t.order_delivered_carrier_date, t.order_purchase_timestamp)) AS Average_Shipping_time
    
FROM(
	SELECT o.order_id, o.order_delivered_carrier_date, i.shipping_limit_date, o.order_purchase_timestamp,
		CASE WHEN o.order_delivered_carrier_date <= i.shipping_limit_date THEN 0
			 WHEN o.order_delivered_carrier_date > i.shipping_limit_date THEN 1
             ELSE "Not shipped" END AS Shipping_Status,
		datediff(o.order_delivered_carrier_date , i.shipping_limit_date) AS delay
		
	FROM olist_orders_dataset AS o
    LEFT  JOIN olist_order_items_dataset AS i
    ON o.order_id = i.order_id
    WHERE o.order_status = "delivered" OR o.order_status = "shipped"
    ) AS t
GROUP BY year_months
ORDER BY year_months;