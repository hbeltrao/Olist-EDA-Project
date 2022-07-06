-- Query to fetch shipping delay and calculate the percentage of orders shipped late segregated by seller category and agregated by year-month
-- of shipping date

SELECT EXTRACT(year_month FROM t.order_delivered_carrier_date) AS year_months,
	t.seller_id AS seller,
	t.seller_state AS seller_state,
    t.seller_classification,
	SUM(t.delay_flag) AS orders_delayed, 
	COUNT(t.delay_flag) AS total_orders,
    ROUND(SUM(t.delay_flag)/COUNT(t.delay_flag)*100, 2) AS delay_percentage,
	AVG(CASE WHEN t.Delay > 0 THEN t.Delay END) AS average_delay
    
FROM (
	SELECT i.seller_id, o.order_id, i.shipping_limit_date, o.order_delivered_carrier_date, s.seller_state,

    -- Using timestampdiff() to have more precision and correctly calculate when the delay is less than an hour
    ROUND(timestampdiff(MINUTE, i.shipping_limit_date, o.order_delivered_carrier_date)/1440, 3) as Delay,

    -- Creating a flag to help count and aggregate the total orders shipped late
    (CASE WHEN timestampdiff(MINUTE, i.shipping_limit_date, o.order_delivered_carrier_date) > 0 THEN 1 ELSE 0 END) AS delay_flag,
    
    -- Create the column seller_classification based on total sales per seller
    (CASE WHEN (count(i.order_item_id) OVER(Partition by i.seller_id)) < 5 THEN 'Small Seller'
		  WHEN (count(i.order_item_id) OVER(Partition by i.seller_id)) BETWEEN 5 AND 500 THEN 'Medium Seller'
		  WHEN (count(i.order_item_id) OVER(Partition by i.seller_id)) > 500 THEN 'Big Seller' END) AS seller_classification
    
    FROM `olist_order_items_dataset` AS i
    
    LEFT JOIN `olist_orders_dataset` AS o
    ON o.order_id = i.order_id
    
    LEFT JOIN `olist_sellers_dataset` as s
    ON i.seller_id = s.seller_id
    
    WHERE o.order_delivered_carrier_date BETWEEN %s AND %s

    ) AS t

GROUP BY year_months, t.seller_id, t.seller_state, t.seller_classification
ORDER BY year_months;



    
    