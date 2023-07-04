USE classicmodels;

SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM offices;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM payments;
SELECT * FROM productlines;
SELECT * FROM products;

## -- Check costumer's city frequency
SELECT city, COUNT(city) AS city_freq, country FROM customers
GROUP BY city
ORDER BY city_freq DESC;

## -- Get total revenue per product
SELECT t3.productCode,t3.productName, SUM(t3.quantityOrdered) AS total_quantity_ordered,SUM(t3.product_revenue) AS total_revenue_per_product
FROM(
SELECT t1.orderNumber, t1.productCode,t1.quantityOrdered,
t1.priceEach,t1.quantityOrdered * t1.priceEach AS product_revenue,
t2.productName
FROM orderdetails t1
LEFT JOIN products t2 ON t1.productCode = t2.productCode) t3
GROUP BY t3.productCode	
ORDER BY total_revenue_per_product DESC;

## -- Get total quantity ordered, total revenue per product, total cost per product and total
## -- profit per product
SELECT t4.productCode,productName,t4.total_quantity_ordered,
t4.total_revenue_per_product,t4.total_cost_per_product,
t4.total_revenue_per_product - t4.total_cost_per_product AS total_profit_per_product
FROM (
SELECT t3.productCode,t3.productName, SUM(t3.quantityOrdered) AS total_quantity_ordered,
SUM(t3.product_revenue) AS total_revenue_per_product,
SUM(t3.product_cost) AS total_cost_per_product
FROM(
SELECT t1.orderNumber, t1.productCode,t1.quantityOrdered,
t1.priceEach,t1.quantityOrdered * t1.priceEach AS product_revenue,
t2.productName, t2.buyPrice * t1.quantityOrdered AS product_cost
FROM orderdetails t1
LEFT JOIN products t2 ON t1.productCode = t2.productCode) t3
GROUP BY t3.productCode
ORDER BY total_revenue_per_product DESC) t4
ORDER BY total_profit_per_product DESC;

## -- Get total total revenue per productLine, total cost per productLine and total
## -- profit per productLine

SELECT t4.*, t4.total_revenue_per_product_line - t4.total_cost_per_product_line AS total_profit_per_product_line 
FROM (
SELECT t3.productLine,SUM(t3.quantityOrdered) AS total_quantity_ordered_per_product_line, SUM(t3.product_revenue) AS total_revenue_per_product_line,
SUM(t3.product_cost) AS total_cost_per_product_line
FROM(
SELECT t1.productCode,t1.quantityOrdered,t1.priceEach, t1.quantityOrdered * t1.priceEach AS product_revenue, t2.productLine, t2.buyPrice * t1.quantityOrdered AS product_cost
FROM
orderdetails t1
LEFT JOIN products t2 ON t1.productCode = t2.productCode) t3
GROUP BY t3.productLine) t4
ORDER BY total_profit_per_product_line DESC;

