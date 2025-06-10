-- Query 1: We calculate the total payment value for orders that were not delivered. This is done by joining the orders and order_payments tables using order_id. We filter out the delivered orders and sum up the payment_value for the rest.
select sum(op.payment_value) as total_for_incomplete_orders
from orders o join order_payments op
on o.order_id = op.order_id
where o.order_status != 'delivered';

--Query 2: We calculate the total payment value for all delivered (completed) orders. We join the orders and order_payments tables using order_id, then filter to include only orders where the status is 'delivered'.
select sum(op.payment_value) as total_for_completed_orders
from orders o join order_payments op
on o.order_id = op.order_id
where o.order_status = 'delivered';

--Query 3: We calculate the total sales value from all orders, regardless of their status. This is done by joining orders with order_payments using order_id, and summing up the payment_value from all matched records.
select sum(op.payment_value) as total_sales
from orders o join order_payments op
on o.order_id = op.order_id;

--Query 4: Just another way to calculate the total_sales and make sure all the orders are paid for,
select sum(payment_value) as total_sales
from order_payments;

-- Since the query 3 and 4 values of sum are the same, it can also be noted that no order_id's are missing from the orders_payments table that are present in orders table and vice versa.

--Query 5: Let's find the Average Order Value (AOV). Since we have the payment information in the order_payments table, we can use it to achieve the required result.
select avg(payment_value) as "Average Order Value"
from order_payments;

--Query 6: Here let us find out how many products we are selling per category. We are going to combine 3 different tables order_items, products and  product_category_name, since the columns we require to get the desired output are spanned over these 3 tables. We can just condider the first two tables, since i cannot read spanish, a conversion to english was necessary.
select distinct(pcn.product_category_name_english),
count(p.product_id) over(partition by p.product_category_name) as Number_of_Items_Sold
from order_items oi 
join products p on oi.product_id = p.product_id 
join product_category_name pcn
on p.product_category_name = pcn.product_category_name
order by Number_of_Items_Sold desc;

--Query 7: Highest purchase for a single order. We can achieve this by just using the order_payments table, if only the Highest Order Value (HOV) was needed. But here let us also find the customer and also the order ID assosiated with it. To get all the required information, we would need to use two tables, which are orders and order_payments along with a simple use of Common Table Expression (CTE).
with max_order_val as (
    select order_id, payment_value as maxVal
    from order_payments
    order by payment_value desc
    limit 1
)
select o.customer_id as customer, o.order_id as "Order", maxVal as "Highest Single Order Value"
from orders o 
join max_order_val mov
on o.order_id = mov.order_id;

--Query 8: This query can also be used to attain the Highest Order Value, but without using a CTE like query 7.
select o.customer_id as customer, o.order_id as "Order", op.payment_value as "Highest Single Order Value"
FROM orders o
join order_payments op on o.order_id = op.order_id
order by op.payment_value desc
limit 1;

--Query 9: We find the top 5 customers by total purchase value. We join orders with order_payments using order_id, then use a window function to sum payment_value per customer_id and sort the results to show the top spenders.
select o.customer_id as customer, 
sum(op.payment_value) over(partition by o.customer_id) as Total_Purchase_Value
from orders o
join order_payments op
on o.order_id = op.order_id
order by Total_Purchase_Value desc
limit 5;

--Query 10: Top 5 customers by the frequency of their orders. The same query can be used as above with two minor tweaks, one being 'distinct' to be used for customer as they repeat and also instead of the sum function we will be using count as we need the number of time the customer has purchased.
select distinct(o.customer_id) as customer, 
count(op.payment_value) over(partition by o.customer_id) as Order_Frequency
from orders o
join order_payments op
on o.order_id = op.order_id
order by Order_Frequency desc
limit 5;


--Query 11: Let us find customer who have ordered atleast 5 times with us. First, we join orders and order_payments, then count orders per customer using a window function. Finally, we filter and count how many customers have an order frequency greater than 4.
with customer_frequency as (
    select distinct(o.customer_id) as customer, 
    count(op.payment_value) over(partition by o.customer_id) as Order_Frequency
    from orders o
    join order_payments op
    on o.order_id = op.order_id
    order by Order_Frequency desc
)
select count(Order_Frequency) as "Frequent Customers"
from customer_frequency
where Order_Frequency > 4;


--Query 12: Let us find the average days for delivery for each review rating. We can achieve this by using two table one being orders and the other being order_reviews. We are just going to join the two tables and use 'datediff' function to calculate the gap. We have to exclude null values, since we have the information of the orders that are still in progress. We finally have to group by the rating and order by it if required.
select ore.review_score as Rating_Given, 
avg(datediff(day, o.order_approved_at, o.order_delivered_customer_date)) as AVG_Time_To_Deliver_in_Days
from order_reviews ore
join orders o
on ore.order_id = o.order_id
where order_delivered_customer_date is not null
group by Rating_Given
order by Rating_Given desc;


--Query 13: We want to find the top 5 sellers by total amount sold. We join order_payments with order_items using order_id, then group by seller_id and sum the payment_value to get total sales per seller.
select oi.seller_id as seller, sum(op.payment_value) as Amount_Sold
from order_payments op
join order_items oi
on op.order_id = oi.order_id
group by seller
order by Amount_Sold desc
limit 5;


--Query 14: Top 5 sellers by the number of orders recieved. We can just tweak the 13th query by replacing the payment_value with the order_id and sum with count function.
select oi.seller_id as seller, count(op.order_id) as Amount_Sold
from order_payments op
join order_items oi
on op.order_id = oi.order_id
group by seller
order by Amount_Sold desc
limit 5;

--Query 15: Average delivery time taken for sellers. Here we had to connect 2 tables, in order to get both the delivery timestamps and individual seller_id's. Used the datediff function in combination with the average function and also an adjustable parameter where only sellers with atleast n orders are considered.
select oi.seller_id as seller,
avg(datediff(day, o.order_approved_at, o.order_delivered_customer_date)) as AVG_Time_To_Deliver_in_Days, 
count(o.order_id) as Orders_Delivered
from orders o
join order_items oi
on o.order_id = oi.order_id
where o.order_delivered_customer_date is not null
group by seller
having count(o.order_id) >= 1000
order by AVG_Time_To_Deliver_in_Days;

--Query 16: We count the number of orders placed each month. Using the orders table, we extract the month from the order_purchase_timestamp, group the data by month, and count the total orders per month.
select extract(month from order_purchase_timestamp) as order_month,
count(order_id) as number_of_orders
from orders
group by order_month
order by order_month;

-- Query 17: We count the number of orders placed each month by truncating the purchase date to the month level. From the orders table, we group by the truncated month date and count orders per month. Results are ordered chronologically by month.
select date_trunc('month', order_purchase_timestamp)::date as order_month,
count(order_id) as number_of_orders
from orders
group by order_month
order by order_month;

--Query 18: We calculate the total monthly revenue from all orders. By joining orders and order_payments on order_id, we sum payment_value grouped by the purchase month. The results are ordered by month to show revenue trends over time.
select date_trunc('month', o.order_purchase_timestamp)::date as order_month,
sum(op.payment_value) as total_revenue
from orders o
join order_payments op
on o.order_id = op.order_id
group by order_month
order by order_month;

--Query 19: We calculate the total yearly revenue from all orders. By joining orders and order_payments on order_id, we sum payment_value grouped by the purchase year. Results are ordered by year to show revenue trends annually.
select date_trunc('year', o.order_purchase_timestamp)::date as order_year,
sum(op.payment_value) as total_revenue
from orders o
join order_payments op
on o.order_id = op.order_id
group by order_year
order by order_year;

--Query 20: We find the total sales and number of orders for each product category. By joining order_payments, order_items, products, and product_category_name, we sum payment values and count distinct orders grouped by product category, sorted by sales.
select pcn.product_category_name_english as category,
sum(op.payment_value) as total_sales,
count(distinct oi.order_id) as total_orders
from order_payments op
join order_items oi
on op.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
join product_category_name pcn
on p.product_category_name = pcn.product_category_name
group by category
order by total_sales desc;

--Query 21: We count the number of orders per product category for each month. By joining orders, order_items, products, and product_category_name, we use conditional sums to tally orders by month and group results by category, ordered alphabetically.
select product_category_name_english as category,
sum(case when extract(month from order_purchase_timestamp) = 1 then 1 else 0 end) as January,
sum(case when extract(month from order_purchase_timestamp) = 2 then 1 else 0 end) as February,
sum(case when extract(month from order_purchase_timestamp) = 3 then 1 else 0 end) as March,
sum(case when extract(month from order_purchase_timestamp) = 4 then 1 else 0 end) as April,
sum(case when extract(month from order_purchase_timestamp) = 5 then 1 else 0 end) as May,
sum(case when extract(month from order_purchase_timestamp) = 6 then 1 else 0 end) as June,
sum(case when extract(month from order_purchase_timestamp) = 7 then 1 else 0 end) as July,
sum(case when extract(month from order_purchase_timestamp) = 8 then 1 else 0 end) as August,
sum(case when extract(month from order_purchase_timestamp) = 9 then 1 else 0 end) as September,
sum(case when extract(month from order_purchase_timestamp) = 10 then 1 else 0 end) as October,
sum(case when extract(month from order_purchase_timestamp) = 11 then 1 else 0 end) as November,
sum(case when extract(month from order_purchase_timestamp) = 12 then 1 else 0 end) as December,
from orders o
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
join product_category_name pcn
on p.product_category_name = pcn.product_category_name
group by category
order by category;

--Query 22: We calculate the monthly sales revenue for each product category. By joining order_payments, orders, order_items, products, and product_category_name, we sum payment_value conditionally for each month and group the results by category.
select product_category_name_english as category,
sum(case when extract(month from o.order_purchase_timestamp) = 1 then payment_value else 0 end) as January,
sum(case when extract(month from order_purchase_timestamp) = 2 then payment_value else 0 end) as February,
sum(case when extract(month from order_purchase_timestamp) = 3 then payment_value else 0 end) as March,
sum(case when extract(month from order_purchase_timestamp) = 4 then payment_value else 0 end) as April,
sum(case when extract(month from order_purchase_timestamp) = 5 then payment_value else 0 end) as May,
sum(case when extract(month from order_purchase_timestamp) = 6 then payment_value else 0 end) as June,
sum(case when extract(month from order_purchase_timestamp) = 7 then payment_value else 0 end) as July,
sum(case when extract(month from order_purchase_timestamp) = 8 then payment_value else 0 end) as August,
sum(case when extract(month from order_purchase_timestamp) = 9 then payment_value else 0 end) as September,
sum(case when extract(month from order_purchase_timestamp) = 10 then payment_value else 0 end) as October,
sum(case when extract(month from order_purchase_timestamp) = 11 then payment_value else 0 end) as November,
sum(case when extract(month from order_purchase_timestamp) = 12 then payment_value else 0 end) as December,
from order_payments op
join orders o
on op.order_id = o.order_id
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
join product_category_name pcn
on p.product_category_name = pcn.product_category_name
group by category
order by category;


--Query 23: We analyze total orders and sales by state. First, we deduplicate zip codes and states from geolocation, and aggregate payments per order. Then, by joining orders, customers, geolocation data, and payment totals, we count unique orders and sum sales grouped by each state, ordered by highest sales.
with geo_dedup as (
    select distinct geolocation_zip_code_prefix, geolocation_state
    from geolocation
),
order_payments_agg as (
    select order_id, SUM(payment_value) as total_payment
    from order_payments
    group by order_id
)
select
    g.geolocation_state as region,
    COUNT(distinct o.order_id) as total_orders,
    SUM(p.total_payment) as total_sales
from orders o
join customers c on o.customer_id = c.customer_id
join geo_dedup g on c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
join order_payments_agg p on o.order_id = p.order_id
group by g.geolocation_state
order by total_sales desc;

-- Query 24: We track how many customers made orders in each month based on their first purchase date. First, we find each customer's earliest order date. Then, we join back to orders to count how many customers placed orders in each month, grouped by month.
with first_customer_order as (
select customer_id,
min(order_purchase_timestamp) as first_order
from orders
group by customer_id
)
select date_trunc('month', o.order_purchase_timestamp)::date as order_month,
count(first_order)
from first_customer_order fco
join orders o
on fco.customer_id = o.customer_id
group by order_month
order by order_month;

-- Query 21: Number of unique customers ordered in last 6 months. We count the customer_id and use distinct to make sure there are no repeated customers. The make sure the purchase timestamp is within the 6 months range.
SELECT COUNT(DISTINCT customer_id) AS active_customers_last_6_months
FROM orders 
WHERE order_purchase_timestamp BETWEEN '2018-03-01' AND '2018-08-31';

-- Query 25: We find the average review rating for sellers with at least 50 orders. By joining orders, order_items, and order_reviews, we group by seller_id, calculate the average rating, and filter to only include sellers with 50+ orders, sorted by rating.
select seller_id as seller,
avg(review_score) as average_rating
from orders o
join order_items oi
on o.order_id = oi.order_id
join order_reviews ore
on o.order_id = ore.order_id
group by seller
having count(o.order_id) >= 50
order by average_rating desc;

--Query 26: We analyze monthly sales and their month-over-month differences between Sept 2016 and Aug 2018. First, we sum payments per month within the date range. Then, using window functions, we compare each month’s sales to the previous month’s, showing the difference.
with tot_sales as (
select date_trunc('month', o.order_purchase_timestamp)::date as sales_month,
sum(payment_value) as monthly_sales
from orders o
join order_payments op
on o.order_id = op.order_id
where o.order_purchase_timestamp between '2016-09-01' AND '2018-08-31'
group by sales_month
)
select sales_month,
lag(monthly_sales) over(order by sales_month) as previous_month_sales,
monthly_sales as this_month_sales,
(monthly_sales - lag(monthly_sales) over(order by sales_month)) as sales_difference
from tot_sales
order by sales_month;

--Query 27: We calculate the average delivery delay in days for sellers with 1000+ orders. By joining orders and order_items, we compute the difference between actual and estimated delivery dates, group results by seller, filter for sellers with at least 1000 orders, and order by average delay.
select seller_id as seller, 
avg(datediff(day,o.order_delivered_customer_date, o.order_estimated_delivery_date)) as AVG_Deliver_time_delay_in_Days
from orders o
join order_items oi
on o.order_id = oi.order_id
where order_delivered_customer_date is not null
group by seller
having count(o.order_id) >= 1000
order by AVG_Deliver_time_delay_in_Days;

--Query 28:We calculate the average delivery delay and total orders for each product category. By joining orders, order_items, products, and product_category_name, we compute the delivery delay in days for delivered orders, group by category, and sort by order count.
select product_category_name_english as category, 
avg(datediff(day,o.order_delivered_customer_date, o.order_estimated_delivery_date)) as AVG_Deliver_time_delay_in_Days,
count(distinct o.order_id) as order_count
from orders o
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
join product_category_name pcn
on p.product_category_name = pcn.product_category_name
where order_delivered_customer_date is not null
group by category
order by order_count desc;
