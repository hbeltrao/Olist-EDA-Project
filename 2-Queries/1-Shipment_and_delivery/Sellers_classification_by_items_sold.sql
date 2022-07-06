-- Query to fetch sellers data, create a column to classificate each seller into Big, Medium or Small seller based on total sales by seller
-- and aggregate all information using this categories created to assess shipment statistics and sales representation.

SELECT t.seller_classification,
	   count(distinct t.seller_id) AS total_sellers,
       ROUND(count(distinct t.seller_id)/(sum(count(distinct t.seller_id)) OVER())*100, 2) AS 'seller_representation (%)',
	   count(t.order_item_id) AS total_sales,
       ROUND(count(t.order_item_id)/(sum(count(t.order_item_id)) OVER())*100, 2) AS 'sales_representation (%)',
       SUM(t.delay_flag) AS 'sales with shipping delay',
       ROUND(SUM(t.delay_flag)/COUNT(t.delay_flag)*100, 2) AS delay_percentage,
       ROUND(AVG(CASE WHEN t.Delay > 0 THEN t.Delay END), 2) AS 'Average shipping delay'
    
FROM (
	SELECT i.seller_id, o.order_id, i.shipping_limit_date, o.order_delivered_carrier_date, s.seller_state, i.order_item_id,
    
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
    
    ) AS t

-- period filter, the %s are replaced by values parsed o the script call
WHERE t.order_delivered_carrier_date BETWEEN '2017-01-01 00:00:00' AND '2018-08-31  23:59:59'    
    
GROUP BY seller_classification;
