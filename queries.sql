-- Top 10 revenue products
SELECT p.product_id, 
       p.product_importance, 
       SUM(p.cost_of_the_product) AS total_revenue
FROM Orders o
JOIN Product p ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_importance
ORDER BY total_revenue DESC
LIMIT 10;

-- Total orders and customers

SELECT COUNT(*) AS total_orders,
       COUNT(DISTINCT customer_id) AS total_customers
FROM Orders;

-- Revenue overview

SELECT 
    SUM(p.cost_of_the_product - o.discount_offered) AS total_revenue,
    ROUND(AVG(p.cost_of_the_product - o.discount_offered), 2) AS avg_order_value
FROM Orders o
JOIN Product p ON o.product_id = p.product_id;

-- Top 10 products by revenue

SELECT 
    p.product_id,
    SUM(p.cost_of_the_product - o.discount_offered) AS total_revenue,
    COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Product p ON o.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_revenue DESC
LIMIT 10;


-- Revenue by product importance

SELECT 
	p.product_importance,
	SUM(p.cost_of_the_product - o.discount_offered) AS total_revenue,
	COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Product p ON o.product_id = p.product_id
GROUP BY p.product_importance
ORDER BY total_revenue DESC;


-- Shipment Mode Importance
SELECT 
    s.mode_of_shipment,
    COUNT(*) AS total_orders,
    ROUND(AVG(o.reached_on_time)::numeric * 100, 2) AS on_time_percentage
FROM Orders o
JOIN Shipment s ON o.shipment_id = s.shipment_id
GROUP BY s.mode_of_shipment
ORDER BY total_orders DESC;


-- Total orders in each warehouse

SELECT 
    w.warehouse_block,
    COUNT(o.order_id) AS total_orders
FROM Orders o
JOIN Warehouse w ON o.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_block
ORDER BY total_orders DESC;

-- Discount Effect on Timely Delivery
SELECT 
    CASE 
        WHEN o.discount_offered > 20 THEN 'High Discount'
        WHEN o.discount_offered BETWEEN 5 AND 20 THEN 'Medium Discount'
        ELSE 'Low Discount'
    END AS discount_category,
    ROUND(AVG(o.reached_on_time)::numeric * 100, 2) AS on_time_delivery_rate
FROM Orders o
GROUP BY discount_category
ORDER BY on_time_delivery_rate DESC;

-- Most Engaged Customers (Top 100)

SELECT 
    c.customer_id,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(c.customer_rating),2) AS avg_rating
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_orders DESC
LIMIT 100;

-- Orders by genders

SELECT c.gender, COUNT(o.order_id) AS total_orders
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
GROUP BY c.gender;



-- Prior purchases vs On time delivery
SELECT 
    c.prior_purchases,
    ROUND(AVG(o.reached_on_time)::numeric * 100, 2) AS on_time_delivery_rate
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
GROUP BY c.prior_purchases
ORDER BY c.prior_purchases DESC;