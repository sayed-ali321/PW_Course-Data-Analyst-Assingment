
-- (Question 1). Create a table called employees with the following structure?
-- : emp_id (integer, should not be NULL and should be a primary key)Q
-- : emp_name (text, should not be NULL)Q
-- : age (integer, should have a check constraint to ensure the age is at least 18)Q
-- : email (text, should be unique for each employee)Q
-- : salary (decimal, with a default value of 30,000).
CREATE TABLE employees (
    emp_id INT NOT NULL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 18),
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10, 2) DEFAULT 30000.00
);


-- (Question 2). Explain the purpose of constraints and how they help maintain data integrity in a database. Provide
-- examples of common types of constraints.

-- Constraints are rules applied to table columns in a database to control the type of data that can be stored in them.
-- They help ensure that the data entered into the database is correct, valid, and consistent.

-- Constraints are used to:

-- Maintain Data Integrity (no incorrect or invalid values)
-- Prevent Duplicate or Missing Data
-- Ensure Relationships Between Tables Stay Valid
-- Enforce Business Rules Automatically

-- (Question 3).Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify
-- your answer.

-- The NOT NULL constraint is applied to a column to ensure that the column always contains a valid (non-empty) value. It is used when a particular field is essential for the integrity of the data and should never be left blank during record insertion or update.
-- Applying NOT NULL helps prevent incomplete or invalid data from being stored in the database.
-- For example, if the emp_name column in an employees table is marked as NOT NULL, then it ensures that every employee must have a name.

-- Can a Primary Key contain NULL values?
-- No, a PRIMARY KEY can never contain NULL val.

-- Justification:
-- A PRIMARY KEY is used to uniquely identify each row in a table. By definition, it combines two constraints:
-- UNIQUE – to ensure no two rows have the same value
-- NOT NULL – to ensure the value is always present
-- Since NULL represents an unknown or missing value, allowing NULL in a primary key would make it impossible to guarantee uniqueness. That’s why every primary key is automatically NOT NULL, and any attempt to insert a NULL value into a primary key column will result in an error.

-- Question 4. Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an
-- example for both adding and removing a constraint.

-- Adding a Constraint
ALTER TABLE employees
ADD CONSTRAINT chk_salary CHECK (salary >= 10000);

-- Removing a Constraint
ALTER TABLE employees
DROP CHECK chk_salary;

-- (Question )5. Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints.
-- Provide an example of an error message that might occur when violating a constraint.

-- inserting (NOT NULL Violation)
INSERT INTO employees (emp_id, emp_name, age, email)
VALUES (10, NULL, 25, 'test@example.com');
-- Error Code: 1048. Column 'emp_name' cannot be null

-- UNIQUE Violation
INSERT INTO employees (emp_id, emp_name, age, email, salary)
VALUES (11, 'Geeta', 27, 'anita@example.com', 32000);
-- not error because emp_id is primary key and sallery is above 30k 

-- CHECK Violation
INSERT INTO employees (emp_id, emp_name, age, email, salary)
VALUES (12, 'Sunil', 23, 'sunil@example.com', 8000);
-- Error Code: 1062. Duplicate entry '12' for key 'employees.PRIMARY'

-- PRIMARY KEY Violation
INSERT INTO employees (emp_id, emp_name, age, email, salary)
VALUES (1, 'Duplicate', 30, 'dup@example.com', 30000);

-- Constraints like NOT NULL, UNIQUE, CHECK, and PRIMARY KEY guard against incorrect data entering your database


-- (Question 6) . You created a products table without constraints as follows:

-- CREATE TABLE products (

    -- product_id INT,

   --  product_name VARCHAR(50),

   --  price DECIMAL(10, 2));
-- Now, you realise that?
-- : The product_id should be a primary keyQ
-- : The price should have a default value of 50.00


DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50),
    price DECIMAL(10, 2)
);

-- Add Primary Key
ALTER TABLE products
ADD PRIMARY KEY (product_id);

-- Set Default Price
ALTER TABLE products
MODIFY price DECIMAL(10, 2) DEFAULT 50.00;

INSERT INTO products (product_id, product_name)
VALUES (101, 'Notebook');


-- Question 7 
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    student_id INT,
    student_name VARCHAR(50),
    class_id INT
);

INSERT INTO students VALUES
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 101);

DROP TABLE IF EXISTS classes;
CREATE TABLE classes (
    class_id INT,
    class_name VARCHAR(50)
);
  
INSERT INTO classes VALUES
(101, 'Math'),
(102, 'Science'),
(103, 'History');

SELECT 
    s.student_name,
    c.class_name
FROM 
    Students s
INNER JOIN 
    Classes c
ON 
    s.class_id = c.class_id;
    
    
-- Question 8

-- Step 1: Drop tables in correct order (foreign key dependents first)
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

-- Step 2: Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

-- Step 3: Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Step 4: Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Insert into Customers
INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob');

-- Insert into Orders
INSERT INTO Orders (order_id, order_date, customer_id) VALUES
(1, '2025-07-01', 1),
(2, '2025-07-02', 2);

-- Insert into Products
INSERT INTO Products (product_id, product_name, order_id) VALUES
(101, 'Laptop', 1),
(102, 'Tablet', 2),
(103, 'Phone', NULL);  -- Not linked to any order

SELECT 
    o.order_id,
    c.customer_name,
    p.product_name
FROM 
    Products p
LEFT JOIN Orders o ON p.order_id = o.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;


-- QUESTION 9

-- Step 1: Drop old tables if they exist (optional but safe)
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Products;

-- Step 2: Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);

-- Step 3: Insert data into Products
INSERT INTO Products (product_id, product_name) VALUES
(101, 'Laptop'),
(102, 'Phone');

-- Step 4: Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    amount INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Step 5: Insert data into Sales
INSERT INTO Sales (sale_id, product_id, amount) VALUES
(1, 101, 500),
(2, 102, 300),
(3, 101, 700);

-- Step 6: Final Query - Total Sales for Each Product
SELECT 
    p.product_name,
    SUM(s.amount) AS total_sales
FROM 
    Sales s
INNER JOIN 
    Products p ON s.product_id = p.product_id
GROUP BY 
    p.product_name;
    
    
-- QUESTION NO 10 

-- Step 1: Drop old tables if exist (safe to avoid errors)
DROP TABLE IF EXISTS Order_Details;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

-- Step 2: Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

-- Step 3: Insert data into Customers
INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob');

-- Step 4: Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Step 5: Insert data into Orders
INSERT INTO Orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-02', 1),
(2, '2024-01-05', 2);

-- Step 6: Create Order_Details table
CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Step 7: Insert data into Order_Details
INSERT INTO Order_Details (order_id, product_id, quantity) VALUES
(1, 101, 2),
(1, 102, 1),
(2, 101, 3);

-- Step 8: Final Query (INNER JOIN on 3 tables)
SELECT 
    o.order_id,
    c.customer_name,
    od.quantity
FROM 
    Orders o
INNER JOIN 
    Customers c ON o.customer_id = c.customer_id
INNER JOIN 
    Order_Details od ON o.order_id = od.order_id;
    







-- SQL COMMANDS


use mavenmovies;
-- 1-Identify the primary keys and foreign keys in maven movies db. Discuss the differences
-- Primary keys list
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'mavenmovies' AND CONSTRAINT_NAME = 'PRIMARY';

-- Foreign keys list
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'mavenmovies' AND REFERENCED_TABLE_NAME IS NOT NULL;

-- 2- List all details of actors
SELECT * FROM actor;

-- 3 -List all customer information from DB.
SELECT * FROM customer;

-- 4 -List different countries.
SELECT DISTINCT country FROM country;

-- 5 -Display all active customers
SELECT * FROM customer
WHERE active = 1;

-- 6 -List of all rental IDs for customer with ID 1.
SELECT rental_id 
FROM rental 
WHERE customer_id = 1;

-- 7 - Display all the films whose rental duration is greater than 5 .
SELECT * 
FROM film 
WHERE rental_duration > 5;

-- 8 - List the total number of films whose replacement cost is greater than $15 and less than $20.
SELECT COUNT(*) AS total_films
FROM film
WHERE replacement_cost > 15 AND replacement_cost < 20;

-- 9 - Display the count of unique first names of actors.
SELECT COUNT(DISTINCT first_name) AS unique_first_names
FROM actor;

-- 10- Display the first 10 records from the customer table .
SELECT * 
FROM customer
LIMIT 10;

-- 11 - Display the first 3 records from the customer table whose first name starts with ‘b’.
SELECT * 
FROM customer
WHERE first_name LIKE 'B%'
LIMIT 3;

-- 12 -Display the names of the first 5 movies which are rated as ‘G’.
SELECT title 
FROM film 
WHERE rating = 'G' 
LIMIT 5;

-- 13-Find all customers whose first name starts with "a".
SELECT * 
FROM customer 
WHERE first_name LIKE 'A%';

-- 14- Find all customers whose first name ends with "a".
SELECT * 
FROM customer 
WHERE first_name LIKE '%a';

-- 15- Display the list of first 4 cities which start and end with ‘a’ .
SELECT city 
FROM city 
WHERE city LIKE 'A%a'
LIMIT 4;

-- 16- Find all customers whose first name have "NI" in any position.
SELECT * 
FROM customer 
WHERE first_name LIKE '%NI%';

-- 17- Find all customers whose first name have "r" in the second position .
SELECT * 
FROM customer 
WHERE first_name LIKE '_r%';

-- 18 - Find all customers whose first name starts with "a" and are at least 5 characters in length.
SELECT * 
FROM customer 
WHERE first_name LIKE 'A%' AND LENGTH(first_name) >= 5;

-- 19- Find all customers whose first name starts with "a" and ends with "o".
SELECT * 
FROM customer 
WHERE first_name LIKE 'A%o';

-- 20 - Get the films with pg and pg-13 rating using IN operator.
SELECT * 
FROM film 
WHERE rating IN ('PG', 'PG-13');

-- 21 - Get the films with length between 50 to 100 using between operator.
SELECT * 
FROM film 
WHERE length BETWEEN 50 AND 100;

-- 22 - Get the top 50 actors using limit operator.
SELECT * 
FROM actor 
LIMIT 50;

-- 23 - Get the distinct film ids from inventory table.
SELECT DISTINCT film_id 
FROM inventory;

-- FUNCTIONS. 
-- Basic Aggregate Functions:

-- Question 1:

-- Retrieve the total number of rentals made in the Sakila database.
-- Hint: Use the COUNT() function.
SELECT COUNT(*) AS total_rentals
FROM rental;


-- Question 2:

-- Find the average rental duration (in days) of movies rented from the Sakila database.
-- Hint: Utilize the AVG() function.
SELECT AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration
FROM rental
WHERE return_date IS NOT NULL;

-- String Functions:

-- Question 3:

-- Display the first name and last name of customers in uppercase.
-- Hint: Use the UPPER () function.
SELECT 
    UPPER(first_name) AS first_name_upper,
    UPPER(last_name) AS last_name_upper
FROM customer;


-- Question 4:

-- Extract the month from the rental date and display it alongside the rental ID.
-- Hint: Employ the MONTH() function.
SELECT 
    rental_id,
    MONTH(rental_date) AS rental_month
FROM rental;

-- GROUP BY:


-- Question 5:

-- Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
-- Hint: Use COUNT () in conjunction with GROUP BY.
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;


-- Question 6:

-- Find the total revenue generated by each store.
-- Hint: Combine SUM() and GROUP BY.
SELECT store_id, SUM(amount) AS total_revenue
FROM payment
GROUP BY store_id;


-- Question 7:

-- Determine the total number of rentals for each category of movies.
-- Hint: JOIN film_category, film, and rental tables, then use cOUNT () and GROUP BY.
SELECT c.name AS category, COUNT(*) AS total_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;


-- Question 8:

-- Find the average rental rate of movies in each language.
-- Hint: JOIN film and language tables, then use AVG () and GROUP BY.
SELECT l.name AS language, AVG(f.rental_rate) AS avg_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

-- Joins
-- Questions 9 -

-- Display the title of the movie, customer s first name, and last name who rented it.
-- Hint: Use JOIN between the film, inventory, rental, and customer tables.
SELECT 
    f.title,
    c.first_name,
    c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;



-- Question 10:

-- Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
-- Hint: Use JOIN between the film actor, film, and actor tables.
SELECT c.store_id, SUM(p.amount) AS total_revenue
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
GROUP BY c.store_id;


-- Question 11:

-- Retrieve the customer names along with the total amount they've spent on rentals.
-- Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY.
SELECT 
    c.first_name,
    c.last_name,
    f.title,
    p.amount
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN payment p ON r.rental_id = p.rental_id;



-- Question 12:

-- List the titles of movies rented by each customer in a particular city (e.g., 'London').
-- Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY.
SELECT 
    f.title,
    c.name AS category,
    f.rental_rate
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;

-- Advanced Joins and GROUP BY:

-- Question 13:

-- Display the top 5 rented movies along with the number of times they've been rented.
-- Hint: JOIN film, inventory, and rental tables, then use COUNT () and GROUP BY, and limit the results.
SELECT 
    f.title,
    COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;

-- Question 14:

-- Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
-- Hint: Use JOINS with rental, inventory, and customer tables and consider COUNT() and GROUP BY
SELECT customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY customer_id
HAVING COUNT(DISTINCT i.store_id) = 2;


-- Windows Function:

-- 1. Rank the customers based on the total amount they've spent on rentals.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS spending_rank
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

-- 2. Calculate the cumulative revenue generated by each film over time.
SELECT 
    f.film_id,
    f.title,
    p.payment_date,
    SUM(p.amount) OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id;

-- 3. Determine the average rental duration for each film, considering films with similar lengths.
SELECT 
    f.length,
    f.film_id,
    f.title,
    AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_days
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY f.length, f.film_id;

-- 4. Identify the top 3 films in each category based on their rental counts.
SELECT *
FROM (
    SELECT 
        c.name AS category,
        f.title,
        COUNT(r.rental_id) AS rental_count,
        RANK() OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id) DESC) AS category_rank
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name, f.title
) ranked
WHERE category_rank <= 3;

-- 5. Calculate the difference in rental counts between each customer's total rentals and the average rentals
-- across all customers.
SELECT 
    customer_id,
    COUNT(*) AS customer_rentals,
    ROUND(COUNT(*) - AVG(COUNT(*)) OVER (), 2) AS rental_difference
FROM rental
GROUP BY customer_id;

-- 6. Find the monthly revenue trend for the entire rental store over time.
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(amount) AS monthly_revenue
FROM payment
GROUP BY month
ORDER BY month;

-- 7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.
SELECT customer_id, total_spent
FROM (
    SELECT 
        customer_id,
        SUM(amount) AS total_spent,
        NTILE(5) OVER (ORDER BY SUM(amount) DESC) AS spending_tile
    FROM payment
    GROUP BY customer_id
) ranked
WHERE spending_tile = 1;

-- 8. Calculate the running total of rentals per category, ordered by rental count.
SELECT 
    category,
    rental_count,
    SUM(rental_count) OVER (ORDER BY rental_count DESC) AS running_total
FROM (
    SELECT 
        c.name AS category,
        COUNT(r.rental_id) AS rental_count
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name
) AS category_rentals;

-- 9. Find the films that have been rented less than the average rental count for their respective categories.
SELECT *
FROM (
    SELECT 
        c.name AS category,
        f.title,
        COUNT(r.rental_id) AS rental_count,
        AVG(COUNT(r.rental_id)) OVER (PARTITION BY c.name) AS category_avg
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name, f.title
) AS stats
WHERE rental_count < category_avg;

-- 10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(amount) AS revenue
FROM payment
GROUP BY month
ORDER BY revenue DESC
LIMIT 5;

-- Normalisation & CTE

-- 1. First Normal Form (1NF):
--  a. Identify a table in the Sakila database that violates 1NF. Explain how you
-- would normalize it to achieve 1NF.


--  Step 1: Create table that violates 1NF
CREATE TABLE customer_contacts (
    customer_id INT,
    customer_name VARCHAR(100),
    phone_numbers VARCHAR(255) -- Multiple phone numbers in one column
);

--  Step 2: Insert non-atomic data
INSERT INTO customer_contacts VALUES (1, 'Akash', '9876543210,9123456789');
INSERT INTO customer_contacts VALUES (2, 'Ravi', '9999999999');

-- Step 3: Create normalized table (1NF)
DROP TABLE IF EXISTS customer_contact_normalized;
CREATE TABLE customer_contact_normalized (
    customer_id INT,
    customer_name VARCHAR(100),
    phone_number VARCHAR(20)
);

-- Step 4: Insert atomic values (1 row = 1 value)
INSERT INTO customer_contact_normalized VALUES (1, 'Akash', '9876543210');
INSERT INTO customer_contact_normalized VALUES (1, 'Akash', '9123456789');
INSERT INTO customer_contact_normalized VALUES (2, 'Ravi', '9999999999');
SELECT * FROM customer_contact_normalized;


-- 2. Second Normal Form (2NF):
-- a. Choose a table in Sakila and describe how you would determine whether it is in 2NF. 
-- If it violates 2NF, explain the steps to normalize it.

CREATE TABLE film_actor_demo (
    film_id INT,
    actor_id INT,
    actor_name VARCHAR(100),  --  partial dependency
    PRIMARY KEY (film_id, actor_id)
);
INSERT INTO film_actor_demo VALUES (1, 101, 'Tom Hanks');
INSERT INTO film_actor_demo VALUES (2, 101, 'Tom Hanks');
INSERT INTO film_actor_demo VALUES (3, 102, 'Will Smith');

DROP TABLE IF EXISTS actor_demo;
CREATE TABLE actor_demo (
    actor_id INT PRIMARY KEY,
    actor_name VARCHAR(100)
);

CREATE TABLE film_actor_clean (
    film_id INT,
    actor_id INT,
    PRIMARY KEY (film_id, actor_id)
);


INSERT INTO actor_demo VALUES (101, 'Tom Hanks');
INSERT INTO actor_demo VALUES (102, 'Will Smith');

INSERT INTO film_actor_clean VALUES (1, 101);
INSERT INTO film_actor_clean VALUES (2, 101);
INSERT INTO film_actor_clean VALUES (3, 102);

SELECT f.film_id, a.actor_name
FROM film_actor_clean f
JOIN actor_demo a ON f.actor_id = a.actor_id;



-- 3. Third Normal Form (3NF):
-- a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies 
-- present and outline the steps to normalize the table to 3NF.

-- Create the table that violates 3NF
CREATE TABLE customer_demo (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    address_id INT,
    city VARCHAR(100),
    country VARCHAR(100)
);

INSERT INTO customer_demo VALUES (1, 'Akash', 101, 'Patna', 'India');
INSERT INTO customer_demo VALUES (2, 'Ravi', 102, 'Mumbai', 'India');
INSERT INTO customer_demo VALUES (3, 'John', 103, 'London', 'UK');

-- A. customer_clean table:
CREATE TABLE customer_clean (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    address_id INT
);

-- C. city_clean table:
CREATE TABLE city_clean (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(100),
    country_id INT
);


-- D. country_clean table:
CREATE TABLE country_clean (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100)
);

-- Country
INSERT INTO country_clean VALUES (1, 'India'), (2, 'UK');

-- City
INSERT INTO city_clean VALUES (1, 'Patna', 1), (2, 'Mumbai', 1), (3, 'London', 2);

INSERT INTO address_clean VALUES (101, 1), (102, 2), (103, 3);


-- Customer
INSERT INTO customer_clean VALUES (1, 'Akash', 101), (2, 'Ravi', 102), (3, 'John', 103);

SELECT * FROM country_clean;
SELECT * FROM city_clean;
SELECT * FROM  address_clean;
SELECT * FROM customer_clean;

CREATE TABLE address_clean (
    address_id INT PRIMARY KEY,
    city_id INT
);


-- Final SELECT with JOIN to view result
SELECT 
    c.customer_id,
    c.customer_name,
    ci.city_name,
    co.country_name
FROM customer_clean c
JOIN address_clean a ON c.address_id = a.address_id
JOIN city_clean ci ON a.city_id = ci.city_id
JOIN country_clean co ON ci.country_id = co.country_id;


--  NORMALIZATION PROCESS
 -- a. Take a specific table in Sakila and guide through the process of normalizing it from the initial 
--  unnormalized form up to at least 2NF.

CREATE TABLE customer_orders_demo (
    customer_id INT,
    customer_name VARCHAR(100),
    order_ids VARCHAR(100),       -- '1,2,3'
    order_dates VARCHAR(100),     -- '2024-01-01,2024-01-02,2024-01-05'
    total_amounts VARCHAR(100)    -- '200,150,300'
);
INSERT INTO customer_orders_demo VALUES 
(1, 'Akash', '1,2,3', '2024-01-01,2024-01-02,2024-01-05', '200,150,300');
SELECT * FROM customer_orders_demo;

CREATE TABLE customer_order_1nf (
    customer_id INT,
    customer_name VARCHAR(100),
    order_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO customer_order_1nf VALUES 
(1, 'Akash', 1, '2024-01-01', 200),
(1, 'Akash', 2, '2024-01-02', 150),
(1, 'Akash', 3, '2024-01-05', 300);
 SELECT * FROM customer_order_1nf;
 
 
DROP TABLE IF EXISTS customer_demo;
CREATE TABLE customer_demo (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

INSERT INTO customer_demo VALUES (1, 'Akash');
SELECT * FROM customer_demo;


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO orders VALUES 
(1, 1, '2024-01-01', 200),
(2, 1, '2024-01-02', 150),
(3, 1, '2024-01-05', 300);
SELECT * FROM orders;

SELECT o.order_id, c.customer_name, o.order_date, o.total_amount
FROM orders o
JOIN customer_demo c ON o.customer_id = c.customer_id;

-- 5. CTE Basics:

 -- a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they 
-- have acted in the form the actor and film_actoe table.

WITH actor_film_count AS (
    SELECT 
        a.actor_id,
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
        COUNT(fa.film_id) AS film_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT * FROM actor_film_count
ORDER BY film_count DESC;

--  CTE with Joins

 -- a. Create a CTE that combines information from the film and language tables to display the film title, 
--  language name, and rental rate

WITH film_language_info AS (
    SELECT 
        f.title AS film_title,
        l.name AS language_name,
        f.rental_rate
    FROM film f
    JOIN language l ON f.language_id = l.language_id
)
SELECT * FROM film_language_info
ORDER BY film_title;

-- CTE for Aggregation:

 -- a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) 
--  from the customer and payment tables.

WITH customer_revenue AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(p.amount) AS total_revenue
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT * FROM customer_revenue
ORDER BY total_revenue DESC;



 -- CTE with Window Functions:
 -- a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.
 
 WITH film_ranking AS (
    SELECT 
        film_id,
        title,
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) AS duration_rank
    FROM film
)
SELECT * FROM film_ranking
ORDER BY duration_rank;

-- CTE and Filtering:
-- a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the 
-- customer table to retrieve additional customer details.

WITH frequent_customers AS (
    SELECT 
        customer_id,
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(rental_id) > 2
)

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    f.total_rentals
FROM frequent_customers f
JOIN customer c ON f.customer_id = c.customer_id
ORDER BY f.total_rentals DESC;

-- cte for Date Calculations:

 -- a. Write a query using a CTE to find the total number of rentals made each month, considering the 
-- rental_date from the rental table

WITH monthly_rentals AS (
    SELECT 
        MONTH(rental_date) AS rental_month,
        YEAR(rental_date) AS rental_year,
        COUNT(*) AS total_rentals
    FROM rental
    GROUP BY YEAR(rental_date), MONTH(rental_date)
)

SELECT * FROM monthly_rentals
ORDER BY rental_year, rental_month;


 -- CTE and Self-Join:

--  a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film 
-- together, using the film_actor table.

WITH actor_pairs AS (
    SELECT 
        fa1.film_id,
        fa1.actor_id AS actor1_id,
        fa2.actor_id AS actor2_id
    FROM film_actor fa1
    JOIN film_actor fa2 
        ON fa1.film_id = fa2.film_id 
        AND fa1.actor_id < fa2.actor_id  -- avoid duplicate & self-pairs
)
SELECT 
    ap.film_id,
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor_1,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor_2
FROM actor_pairs ap
JOIN actor a1 ON ap.actor1_id = a1.actor_id
JOIN actor a2 ON ap.actor2_id = a2.actor_id
ORDER BY ap.film_id, actor_1, actor_2;


-- CTE for Recursive Search:
 -- a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, 
-- considering the reports_to column

WITH actor_pairs AS (
    SELECT 
        fa1.film_id,
        fa1.actor_id AS actor1_id,
        fa2.actor_id AS actor2_id
    FROM film_actor fa1
    JOIN film_actor fa2 
        ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
)
SELECT 
    ap.film_id,
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor1_name,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor2_name
FROM actor_pairs ap
JOIN actor a1 ON ap.actor1_id = a1.actor_id
JOIN actor a2 ON ap.actor2_id = a2.actor_id
ORDER BY ap.film_id, actor1_name, actor2_name;