-- Query to verify the data of 2017-09 and investigate the abnormal delivery delay result
-- fetching all date columns to identify irregularities like shipping date being older than delivery date

select order_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date,
	order_delivered_customer_date, order_estimated_delivery_date,
	(timestampdiff(minute, `order_estimated_delivery_date`, `order_delivered_customer_date`)/1440) AS delay
from `olist_orders_dataset`
where order_status LIKE 'delivered'
and order_delivered_customer_date BETWEEN '2017-09-01 00:00:00' AND '2017-09-30 23:59:59'
having delay > 0
order by delay DESC;