CREATE DATABASE ecommerce_shipping;

-- 1) Customer Table
CREATE TABLE Customer (
    customer_id SERIAL PRIMARY KEY,
    gender VARCHAR(1) CHECK (gender IN ('M','F')),
    prior_purchases INT,
    customer_rating INT CHECK (customer_rating BETWEEN 1 AND 5),
    customer_care_calls INT
);

-- 2) Warehouse Table
CREATE TABLE Warehouse (
    warehouse_id SERIAL PRIMARY KEY,
    warehouse_block CHAR(1) CHECK (warehouse_block IN ('A','B','C','D','F'))
);

-- 3) Shipment Table
CREATE TABLE Shipment (
    shipment_id SERIAL PRIMARY KEY,
    mode_of_shipment VARCHAR(10) CHECK (mode_of_shipment IN ('Flight','Ship','Road'))
);

-- 4) Product Table
CREATE TABLE Product (
    product_id SERIAL PRIMARY KEY,
    cost_of_the_product DECIMAL(10,2),
    product_importance VARCHAR(10) CHECK (product_importance IN ('low','medium','high')),
    weight_in_gms INT
);

-- 5) Orders Table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    warehouse_id INT,
    shipment_id INT,
    discount_offered DECIMAL(10,2),
    reached_on_time INT, 

    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (shipment_id) REFERENCES Shipment(shipment_id)
);



-- Staging table

CREATE TABLE staging (
    id INT,
    warehouse_block CHAR(1),
    mode_of_shipment VARCHAR(20),
    customer_care_calls INT,
    customer_rating INT,
    cost_of_the_product DECIMAL(10,2),
    prior_purchases INT,
    product_importance VARCHAR(10),
    gender VARCHAR(1),
    discount_offered DECIMAL(10,2),
    weight_in_gms INT,
    reached_on_time INT
);


-- Insert distinct values (ignore duplicates)
-- Warehouse
INSERT INTO Warehouse (warehouse_block)
SELECT DISTINCT warehouse_block FROM Staging
ON CONFLICT DO NOTHING;

-- Shipment
INSERT INTO Shipment (mode_of_shipment)
SELECT DISTINCT mode_of_shipment FROM Staging
ON CONFLICT DO NOTHING;

-- Product
INSERT INTO Product (cost_of_the_product, product_importance, weight_in_gms)
SELECT DISTINCT cost_of_the_product, product_importance, weight_in_gms FROM Staging
ON CONFLICT DO NOTHING;

-- Customer
INSERT INTO Customer (gender, prior_purchases, customer_rating, customer_care_calls)
SELECT DISTINCT gender, prior_purchases, customer_rating, customer_care_calls FROM Staging
ON CONFLICT DO NOTHING;

-- Insert into Orders by joining
INSERT INTO Orders (customer_id, product_id, warehouse_id, shipment_id, discount_offered, reached_on_time)
SELECT 
    c.customer_id,
    p.product_id,
    w.warehouse_id,
    sh.shipment_id,
    st.discount_offered,
    st.reached_on_time
FROM Staging st
JOIN Customer c 
    ON st.gender = c.gender
   AND st.prior_purchases = c.prior_purchases
   AND st.customer_rating = c.customer_rating
   AND st.customer_care_calls = c.customer_care_calls
JOIN Product p 
    ON st.cost_of_the_product = p.cost_of_the_product
   AND st.product_importance = p.product_importance
   AND st.weight_in_gms = p.weight_in_gms
JOIN Shipment sh 
    ON st.mode_of_shipment = sh.mode_of_shipment
JOIN Warehouse w 
    ON st.warehouse_block = w.warehouse_block;


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




SELECT * FROM customer;
SELECT * FROM orders;
SELECT * FROM product;
SELECT * FROM shipment;
SELECT * FROM warehouse;
SELECT * FROM staging;

DROP TABLE customer;
DROP TABLE orders;
DROP TABLE product;
DROP TABLE shipment;
DROP TABLE warehouse;
DROP TABLE staging;