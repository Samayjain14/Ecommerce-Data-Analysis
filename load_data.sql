-- Inserting distinct values
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