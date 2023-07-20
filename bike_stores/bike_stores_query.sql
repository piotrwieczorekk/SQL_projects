USE BikeStores;

SELECT * FROM production.brands;
SELECT * FROM production.categories;
SELECT * FROM production.products;
SELECT * FROM production.stocks;
SELECT * FROM sales.customers;
SELECT * FROM sales.order_items;
SELECT * FROM sales.orders;
SELECT * FROM sales.staffs;
SELECT * FROM sales.stores;


--- Get average price by brand_id and category_id, create a rank of the average prices and inner join production.categories and production.brand
--- to get the names of the brands and categories

SELECT t2.*,
t3.category_name,
t4.brand_name
FROM (
SELECT t1.*, DENSE_RANK() OVER(ORDER BY t1.avg_price DESC) AS price_rank 
FROM (
SELECT brand_id,
category_id,
CAST(ROUND(AVG(list_price),2) AS DECIMAL(8,2)) AS avg_price 
FROM production.products
GROUP BY brand_id,category_id) t1) t2
INNER JOIN production.categories t3 ON t3.category_id = t2.category_id
INNER JOIN production.brands t4 ON t4.brand_id = t2.brand_id;

--- 


--- Adding total_list_price_without_discount, discount and total_list_price_after_discount columns to the sales.oder_items table
--- Next, joining data about customer's city
--- Next, group by order_id and calculate the sum of total_list_price_after_discount. It will be the total price that the customer pays in each order
--- Next, calculate the average of total_list_price_after_discount_sum (groupped by order_id) 
--- Next, examine whether or not a particular order_id exhibits total price higher than the average
SELECT t6.*, CASE WHEN t6.total_list_price_after_discount_sum > t6.avg_total_price THEN 'Above average' ELSE 'Below average' END AS total_price_category 
FROM (
SELECT t5.*,  AVG(t5.total_list_price_after_discount_sum) OVER() AS avg_total_price
FROM (
SELECT t4.order_id, SUM(t4.total_list_price_after_discount) AS total_list_price_after_discount_sum, t4.city
FROM (
SELECT t1.*, t2.customer_id,t3.city
FROM (
SELECT order_id,
item_id,
product_id,
quantity,
list_price,
discount,
quantity * list_price AS total_list_price_without_discount,
discount * quantity * list_price AS discount_amount,
quantity * list_price - (discount * quantity * list_price) AS total_list_price_after_discount
FROM sales.order_items) t1
INNER JOIN sales.orders t2 ON t1.order_id = t2.order_id
INNER JOIN sales.customers t3 ON t2.customer_id = t3.customer_id) t4
GROUP BY t4.order_id, t4.city) t5) t6;














