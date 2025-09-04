# Ecommerce-Data-Analysis (PostgreSQL)

## Project Overview
Conducted E-commerce data analysis using PostgreSQL by designing a relational database, structuring raw data and running SQL queries to generate insights on revenue trends, customer behavior, shipment performance and discount effectiveness for business decision making.
The goal was to demonstrate how SQL can transform raw business data into clear insights that support better decision-making for marketing, logistics, and customer engagement.  

---

## Tools & Technologies
- PostgreSQL  
- SQL  
- pgAdmin / psql  

---

## Project Structure
- **schema.sql** → Defines database schema and relationships.  
- **load_data.sql** → Loads and transforms raw data from staging into final tables.  
- **queries.sql** → Contains analysis queries to generate business insights.  
- **cleanup.sql** → Optional script to reset the database.  

---

## How to Run
1. Create a new database in PostgreSQL:  
   ```sql
   CREATE DATABASE ecommerce_shipping;
   \c ecommerce_shipping;
   
2. Run the schema file to create tables:
   ```sql
   \i schema.sql
   
3. Load and transform data:
   ```sql
   \i load_data.sql

4. Execute analysis queries:
   ```sql
   \i queries.sql

6. Clean the database:
   ```sql
   \i cleanup.sql


