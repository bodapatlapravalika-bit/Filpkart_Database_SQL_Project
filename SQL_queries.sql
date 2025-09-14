/*QUESTIONS*/


/*1.Retrieve all products along with their total sales revenue from completed orders? */

SELECT p.product_id,p.product_name,SUM(s.quantity*s.price_per_unit) total_sales_revenue
FROM products p INNER JOIN sales s
ON p.product_id=s.product_id
INNER JOIN shippings shp
ON s.order_id=shp.order_id
WHERE shp.delivary_status='Delivered'
GROUP BY p.product_id,p.product_name;


/*2.List all customers and the products they have purchased, showing only those who have ordered more than two products? */

SELECT c.customer_id,c.customer_name,COUNT(DISTINCT p.product_id) AS total_products
FROM customers c INNER JOIN sales s
ON c.customer_id = s.customer_id
INNER JOIN products p
ON s.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.product_id) > 2;


/*3.Find the total amount spent by customers in 'Gujarat' who have ordered products priced greater than 10,000?*/

SELECT c.customer_id,SUM(s.quantity*s.price_per_unit) as total_spent
FROM customers c INNER JOIN sales s
ON c.customer_id=s.customer_id
INNER JOIN products p
ON s.product_id=p.product_id
WHERE c.state='Gujarat'
AND s.price_per_unit>10000
GROUP BY c.customer_id;


/*4.Retrieve the list of all orders that have not yet been shipped?*/

SELECT s.order_id,s.product_id
FROM sales s
WHERE s.order_id NOT IN(SELECT sp.order_id FROM shippings sp);


/*5.Find the average order value per customer for orders with a quantity of more than 5?*/

SELECT c.customer_id, c.customer_name,
AVG(s.quantity * s.price_per_unit) AS avg_order_value
FROM customers c
INNER JOIN sales s
ON c.customer_id = s.customer_id
WHERE s.quantity > 5
GROUP BY c.customer_id, c.customer_name;


/*6.Get the top 5 customers by total spending on 'Accessories'?*/

SELECT c.customer_id,c.customer_name,SUM(s.quantity*s.price_per_unit) total_spent
FROM customers c INNER JOIN sales s
ON c.customer_id=s.customer_id
INNER JOIN products p
ON s.product_id=p.product_id
WHERE p.category='Accessories'
GROUP BY c.customer_id,c.customer_name
ORDER BY SUM(s.quantity*s.price_per_unit) DESC
LIMIT 5;


/*7.Retrieve a list of customers who have not made any payment for their orders?*/

SELECT c.customer_id,c.customer_name
FROM customers c LEFT JOIN sales s
ON c.customer_id=s.customer_id
LEFT JOIN payments p
ON s.order_id=p.order_id
WHERE p.payment_id IS NULL;

(OR)

SELECT DISTINCT c.customer_id,c.customer_name
FROM customers c 
WHERE c.customer_id NOT IN(SELECT s.customer_id
FROM sales s LEFT JOIN payments p
ON s.order_id=p.order_id);



/*8.Find the most popular product based on total quantity sold in 2023?*/

SELECT p.product_id,p.product_name,SUM(s.quantity) popular_product
FROM products p INNER JOIN sales s
ON p.product_id=s.product_id
WHERE EXTRACT(YEAR FROM s.order_date)=2023
GROUP BY p.product_id,p.product_name
ORDER BY SUM(s.quantity) DESC
LIMIT 1;


/*9.List all orders that were cancelled and the reason for cancellation (if available)?*/

SELECT s.order_id,s.order_status
FROM sales s
WHERE s.order_status='Cancelled';


/*10.Retrieve the total quantity of products sold by category in 2023?*/

SELECT p.category,SUM(s.quantity) AS total_quantity
FROM products p INNER JOIN sales s
ON p.product_id=s.product_id
WHERE EXTRACT(YEAR FROM s.order_date)=2023
GROUP BY p.category;


/*11.Get the count of returned orders by shipping provider in 2023?*/

SELECT COUNT(*) AS returned_orders
FROM shippings sp
WHERE sp.delivary_status = 'Returned'
AND EXTRACT(YEAR FROM sp.shipping_date) = 2023
GROUP BY sp.delivary_status;

(OR)

SELECT COUNT(*) FROM shippings
WHERE delivary_status!='Delivered'
AND EXTRACT(YEAR FROM shipping_date) = 2023;


/*12.Show the total revenue generated per month for the year 2023?*/

SELECT EXTRACT(MONTH FROM s.order_date) AS MONTH, SUM(s.quantity * s.price_per_unit) as total_revenue
FROM sales s
WHERE EXTRACT(YEAR FROM s.order_date) = 2023
GROUP BY EXTRACT(MONTH FROM s.order_date)
ORDER BY MONTH;


/*13.Find the customers who have made the most purchases in a single month?*/

SELECT customer_id, MONTH, total_orders
FROM (
        SELECT s.customer_id,
        EXTRACT(MONTH FROM s.order_date) AS MONTH,
        COUNT(s.order_id) AS total_orders,
        RANK() OVER (PARTITION BY EXTRACT(MONTH FROM s.order_date) 
	ORDER BY COUNT(s.order_id) DESC) AS rank
        FROM sales s
        GROUP BY s.customer_id, EXTRACT(MONTH FROM s.order_date)) sub
WHERE RANK=1;


/*14.Retrieve the number of orders made per product category in 2023 and order by total quantity sold?*/

SELECT p.category,COUNT(DISTINCT s.order_id) AS total_orders ,SUM(s.quantity) AS total_quantity
FROM sales sinner INNER JOIN products p
ON s.product_id = p.product_id
WHERE EXTRACT(YEAR FROM s.order_date) = 2023
GROUP BY p.category
ORDER BY total_quantity DESC;


/*15.List the products that have never been ordered (use LEFT JOIN between products and sales)?*/

SELECT p.product_id, p.product_name
FROM products p LEFT JOIN sales s
ON p.product_id = s.product_id
WHERE s.product_id IS NULL;

