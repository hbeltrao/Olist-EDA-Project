-- Fetching freight information agregated by state

select t.customer_state AS customer_state, AVG(t.average_freight) AS avg_freight, count(t.order_item_id) as tot_orders

from (select i.order_id, i.order_item_id, s.seller_state, c.customer_state, avg(i.freight_value) as average_freight
	from `olist_order_items_dataset` as i
    
    left join `olist_sellers_dataset` as s
    on i.seller_id = s.seller_id
    
    left join `olist_orders_dataset` as o
    on i.order_id = o.order_id
    
    left join `olist_customers_dataset` as c
    on o.customer_id = c.customer_id
    
    where o.order_delivered_carrier_date between %s and %s
    
    group by i.order_id ,i.order_item_id, s.seller_state, c.customer_state
    ) as t

group by t.customer_state
order by avg_freight DESC;