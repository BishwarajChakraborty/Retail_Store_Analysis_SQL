create database retail_store_db;

-- customers table
CREATE TABLE customers (
customer_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
phone VARCHAR(15),
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- Products table
CREATE TABLE products (
product_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
category VARCHAR(50) NOT NULL,
price DECIMAL(10,2) NOT NULL,
stock_quantity INT NOT NULL DEFAULT 0,
added_on DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- Orders table
CREATE TABLE orders (
order_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT,
order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
status VARCHAR(20) DEFAULT 'Pending',
total_amount DECIMAL(10,2),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
-- Order_Items table
CREATE TABLE order_items (
order_item_id INT PRIMARY KEY AUTO_INCREMENT,
order_id INT,
product_id INT,
quantity INT NOT NULL CHECK (quantity > 0),
item_price DECIMAL(10,2) NOT NULL,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);
-- Payments table
CREATE TABLE payments (
payment_id INT PRIMARY KEY AUTO_INCREMENT,
order_id INT,
payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
amount_paid DECIMAL(10,2) NOT NULL CHECK (amount_paid > 0),
method VARCHAR(20) NOT NULL,
FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
-- Product_Reviews table
CREATE TABLE product_reviews (
review_id INT PRIMARY KEY AUTO_INCREMENT,
product_id INT,
customer_id INT,
rating INT NOT NULL,
review_text TEXT,
review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (product_id) REFERENCES products(product_id),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

select * from customers;
select * from order_items;
select * from orders;
select * from payments;
select * from product_reviews;
select * from products;

-- Level 1: Basics

-- 1. Retrieve customers name and emails for email marketing
select name, email from customers;

-- 2. View complete product catalog with all available details
select * from products;

-- 3. List all unique product categories
select distinct(category) from products;

-- 4. Show all products priced above 1000
select category, product_id, name, price 
from products
where price>1000
order by category;

-- 5. Display products within a mid-range price bracket (2000-5000)
select category, product_id, name, price 
from products
where price between 2000 and 5000
order by category, price desc;

-- 6. Fetch date for specific customer_ids
select * from customers
where customer_id in ('1', '2');

-- 7. Identify customers whose name start with the letter 'A'
select name from customers
where name like 'A%';

-- 8. List electronics products priced under 3000
select category, product_id, name, price from products
where category= 'Electronics' and price<3000
order by price desc;

-- 9. Display product names and prices in descending order of price
select name, price from products
order by price desc;

-- 10. Display product names and prices, sorted by price and then by name
select name, price from products
order by price desc, name asc;

-- Level 2: Filtering and Formatting

-- 1. Retrieve order where customer information is missing (possibly due to data migration or data deletion)
select * from orders
where customer_id is null;

-- 2. Display customer names and emails using column aliases for frontend readibility
select cust.name, cust.email from customers cust;

-- 3. Calculate total value per item ordered by multiplying quantity and item price
select order_item_id, sum(quantity * item_price) as total_value_per_item from order_items
group by order_item_id
order by sum(quantity * item_price) desc;

-- 4. Combine customer name and phone number in a single column
select concat(name, phone) as combine_name_phone from customers;

-- 5. Extract only the date part from order timestamps for date-wise reporting
select date(order_date) as date, order_id, customer_id, status, total_amount from orders;

-- 6. List products that do not have any stock left
select * from products
where stock_quantity=0;


-- Level 3: Aggregations

-- 1. Count the total number of orders placed
select count(*) as total_number_orders from orders;

-- 2. Calcualte the total revenue collected from all orders
select sum(total_amount) as total_revenue from orders;

-- 3. Calculate the average order value
select round(avg(total_amount),2) as average_order_value from orders;

-- 4. Count the number of customers who have placed at least one order
select count(distinct customer_id) as customers_count from orders;

-- 5. Find the number of orders placed by each customer
select customer_id, count(*) as order_counts from orders
group by customer_id
order by count(*) desc;

-- 6. Find total sales amount made by each customer
select customer_id, sum(total_amount) as total_sales from orders
group by customer_id
order by sum(total_amount) desc;

-- 7. List the number of products sold per category
select category, count(*) as product_count from products
group by category
order by count(*) desc;

-- 8. Find the average item price per category
select category, round(avg(price), 2) from products
group by category
order by avg(price) desc;

-- 9. Show number of orders placed per day
select date(order_date) as order_date, count(*) as orders_count from orders
group by date(order_date)
order by count(*) desc;

-- 10. List total payments received per payment method
select method, sum(amount_paid) as total_payments from payments
group by method
order by sum(amount_paid) desc;


-- Level 4: Multi-Table Queries (Joins)

-- 1. Retrieve order details along with the customer name 
select o.*,c.name
from orders o
inner join customers c
on o.customer_id=c.customer_id;

-- 2. Get list of products that have been sold
select o.product_id, p.name
from order_items o 
inner join products p 
on o.product_id=p.product_id
group by product_id;

-- 3. List all orders with their payment method
select o.*,p.method
from orders o 
inner join payments p 
on o.order_id=p.order_id;

-- 4. Get list of customers and their orders
select c.customer_id, c.name, o.order_id
from customers c 
left join orders o 
on c.customer_id=o.customer_id;

-- 5. List all products along with order item quantity
select p.*, sum(ord.quantity) as order_quantity
from products p 
left join order_items ord 
on p.product_id=ord.product_id
group by p.product_id
order by sum(ord.quantity) desc;

-- 6. List all payments including those with no matching orders
select p.*, o.order_id
from payments p 
right join orders o 
on p.order_id=o.order_id;

-- 7. Combine data from three tables: customers, orders and payments
select c.*,o.*, p.*
from customers c 
inner join orders o 
on c.customer_id=o.customer_id
inner join payments p 
on o.order_id=p.order_id;


-- Level 5: Subqueries (Inner Queries)

-- 1. List all products priced above the average product price
select product_id, name, price
from products
where price>(select avg(price) from products)
order by price desc;

-- 2. Find customers who have placed at least one order
select distinct customer_id from orders;

-- 3. Show orders whose total amount is above the average for that customer
select o1.* from orders o1 
where o1.total_amount>
(select avg(o2.total_amount)
from orders o2
where o2.customer_id=o1.customer_id);

-- 4. Display customers who haven't placed any order
select * from customers
where customer_id not in (
select customer_id from orders);

-- 5. Show products that were never ordered
select * from products
where product_id not in (
select product_id from order_items);

-- 6. Show highest value order per customer
select customer_id , max(total_amount) as highest_value
from orders
group by customer_id;

-- 7. Show highest value order per customer (including names)
select o.customer_id ,c.name, max(o.total_amount) as highest_value
from orders o
inner join customers c
on o.customer_id=c.customer_id
group by o.customer_id, c.name;


-- Level 6: Set Operations	

-- 1. List all customers who have either placed an order or written a product review
select customer_id 
from orders 
union
select customer_id 
from product_reviews; 

-- 2. List all customers who have placed an order as well as reviewed a product 
-- Using INNER JOIN
select distinct o.customer_id
from orders o 
inner join product_reviews pr 
on o.customer_id=pr.customer_id;

-- OR using IN 
select customer_id from orders
where customer_id in (
select customer_id from product_reviews)
group by customer_id;












