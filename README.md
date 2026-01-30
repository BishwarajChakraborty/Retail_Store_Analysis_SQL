**Retail Store Database System**
A comprehensive SQL-based relational database system designed to manage core retail operations, including customer profiles, product inventories, orders, and payment processing.

**📌 Project Overview**
This project provides a complete database schema and a robust set of sample data to simulate a real-world retail environment. It is designed to demonstrate relational database design, data integrity, and complex SQL querying.

**🛠 Database Schema**
The system consists of the following primary tables:
-Customers: Stores personal details such as names, unique email addresses, and contact information.
-Products: Manages inventory with details on categories, pricing, and stock levels.
-Orders: Tracks customer purchases, transaction dates, and delivery statuses (e.g., Pending, Shipped, Delivered).
-Order Items: Provides a granular breakdown of products and quantities for every order.
-Payments: Records transaction amounts and payment methods like Credit Card, UPI, and Net Banking.
-Product_Reviews: Captures customer feedback and ratings for specific items.

**🚀 Getting Started**
-Prerequisites: Ensure you have a SQL database engine installed (e.g., MySQL or PostgreSQL).
-Schema Setup: Execute the retail_store_db.sql file to create the database and define all tables and relationships.
-Data Population: Run the DataInsertionQueries.sql script to populate the tables with over 400 sample records, including 50 products and 30 unique customers.

**🔍 Sample Queries Included**
The project includes predefined scripts to perform various analyses:
-Revenue Analysis: Identifying the highest value orders per customer.
-Inventory Management: Finding products that have never been ordered to optimize stock.
-Customer Engagement: Listing active customers who have both placed orders and written reviews.
-Sales Insights: Comparing individual order totals against a customer’s average purchase value.

**📂 File Structure**
-retail_store_db.sql: Database creation and schema definition script.
-DataInsertionQueries.sql: Comprehensive dataset for testing and demonstration.
-retail_store_db_EERdiagram.mwb: MySQL Workbench model file for visualizing the database architecture.
