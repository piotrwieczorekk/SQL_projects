SELECT * FROM[production].[brands];
SELECT * FROM[production].[categories];
SELECT * FROM[production].[products];
SELECT * FROM[production].[stocks];
SELECT * FROM[sales].[customers];
SELECT * FROM[sales].[order_items];
SELECT * FROM[sales].[orders];
SELECT * FROM[sales].[staffs];
SELECT * FROM[sales].[stores];

--- calculate avg list price by brand and category, inner join data about brand and category name

SELECT t5.* 
FROM (
SELECT t2.brand_id,
t2.category_id,
t2.avg_list_price,
t3.brand_name,
t4.category_name
FROM (
SELECT t1.brand_id, 
t1.category_id, 
CAST(AVG(t1.list_price) AS DECIMAL(8,2)) AS avg_list_price
FROM [production].[products] t1
GROUP BY t1.brand_id, t1.category_id) t2
INNER JOIN [production].[brands] t3
ON t2.brand_id = t3.brand_id
INNER JOIN [production].[categories] t4
ON t4.category_id = t2.category_id) t5
ORDER BY t5.brand_id ASC;

--- calculate avg list price by brand and category over the table, inner join data about brand and category name

SELECT t5.product_id,
t5.brand_id,
t5.category_id,
t5.product_name,
t5.model_year,
t5.brand_name,
t5.category_name,
t5.list_price,
t5.avg_list_price_by_brand,
t5.avg_list_price_by_category 
FROM (
SELECT t2.*, 
t3.brand_name,
t4.category_name
FROM (
SELECT t1.product_id,
t1.product_name,
t1.model_year,
t1.brand_id, 
t1.category_id, 
t1.list_price,
CAST(AVG(list_price) OVER(PARTITION BY category_id) AS DECIMAL(8,2)) AS avg_list_price_by_category,
CAST(AVG(list_price) OVER(PARTITION BY brand_id) AS DECIMAL(8,2)) AS avg_list_price_by_brand
FROM [production].[products] t1) t2
INNER JOIN [production].[brands] t3
ON t2.brand_id = t3.brand_id
INNER JOIN [production].[categories] t4
ON t4.category_id = t2.category_id ) t5
ORDER BY t5.brand_id ASC;

---calculate discount amount and final price (after discount), add additional column to check if the discount is present

SELECT t5.order_id,
t5.item_id,
t5.product_id,
t5.quantity,
t5.list_price,
t5.is_discount,
t5.discount,
t5.list_price_per_order,
CAST(t5.total_discount_per_order AS DECIMAL(8,2)) AS total_discount_per_order,
CAST(t5.total_price_per_order AS DECIMAL(8,2)) AS total_price_per_order
FROM (
SELECT t4.*,
CASE WHEN t4.discount > 0 THEN 'Yes' ELSE 'No' END AS is_discount 
FROM (
SELECT t3.*, t3.list_price_per_order - t3.total_discount_per_order AS total_price_per_order
FROM (
SELECT t2.*, t2.list_price_per_order * discount AS total_discount_per_order 
FROM (
SELECT t1.*,
t1.list_price * t1.quantity AS list_price_per_order
FROM[sales].[order_items] t1) t2) t3) t4) t5
ORDER BY t5.order_id ASC;



--- calculate total amount of sold products and sum of total list price after discount for each product

SELECT t13.* 
FROM (
SELECT t11.product_id,
t12.product_name,
t11.sum_total_list_price_after_discount,
t11.sum_total_quantitiy_sold_per_product
FROM (
SELECT t10.product_id, 
SUM(t10.total_list_price_after_discount) AS sum_total_list_price_after_discount,
SUM(t10.total_quantity_sold_per_product) AS sum_total_quantitiy_sold_per_product
FROM (
SELECT DISTINCT t9.* 
FROM (
SELECT t8.product_id,
t8.total_quantity_sold_per_product,
t8.list_price_per_product,
t8.total_list_price,
t8.discount,
CAST(t8.total_discount AS DECIMAL(8,2)) AS total_discount,
CAST(t8.total_list_price_after_discount AS DECIMAL(8,2)) AS total_list_price_after_discount
FROM (
SELECT t7.*, 
t7.total_list_price - t7.total_discount AS total_list_price_after_discount
FROM (
SELECT t6.*, 
t6.total_list_price * t6.discount AS total_discount
FROM (
SELECT t5.*, 
t5.list_price_per_product * t5.total_quantity_sold_per_product AS total_list_price
FROM (
SELECT t2.*, 
t3.list_price AS list_price_per_product,
t4.discount
FROM (
SELECT t1.product_id, COUNT(t1.quantity) AS total_quantity_sold_per_product
FROM [sales].[order_items] t1
GROUP BY t1.product_id) t2
INNER JOIN [production].[products] t3
ON t2.product_id = t3.product_id
INNER JOIN [sales].[order_items] t4
ON t2.product_id = t4.product_id) t5) t6) t7) t8 ) t9) t10
GROUP BY t10.product_id) t11
INNER JOIN [production].[products] t12
ON t11.product_id = t12.product_id) t13
ORDER BY t13.sum_total_list_price_after_discount DESC;