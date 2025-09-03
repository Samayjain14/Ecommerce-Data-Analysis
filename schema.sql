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
