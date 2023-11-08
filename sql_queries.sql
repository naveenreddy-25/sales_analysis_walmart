CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(30) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_percentage FLOAT(11,9),
gross_income DECIMAL(12,4) NOT NULL,
rating FLOAT(2,1)
);

-- ---------------------------------- FEATURE ENGINEERING ------------------------------------------
-- -----------------------------------time_of_day --------------------------------------------------
SELECT 
time,
(CASE 
WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN time BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
ELSE "Evening" 
END
) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE 
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN time BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening" 
	END
);
-- day_name
SELECT
	date,
	DAYNAME(date)
 FROM sales;
 
 ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
 
 UPDATE sales
 SET day_name = DAYNAME(date);
 
 -- month_name
 SELECT
	date,
    MONTHNAME(date)
    FROM sales;
    
    ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
 
 UPDATE sales
 SET month_name = MONTHNAME(date);
 
 ALTER TABLE sales
 DROP COLUMN month_nmae;

-- ---------------------------------FEATURE ENGINEERING ----------------------------------------

-- -----------------------------Business Questions ---------------------------------------------
-- -----------------------------Generic---------------------------------------------------------
-- 1.How many unique cities does the data have?----------------
SELECT DISTINCT City
FROM sales;

-- 2.In which city is each branch?-----------------------------
SELECT Branch,City
FROM sales
GROUP BY Branch,City;

-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
-- ------------------------------------Product --------------------------------------------------
-- How many unique product lines does the data have? --------------------------------------------

SELECT COUNT(DISTINCT Product_line)
FROM sales;

-- What is the most common payment method? ------------------------------------------------------

SELECT payment_method,
COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC LIMIT 1;

-- --What is the most selling product line?----
SELECT product_line,
COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC LIMIT 1;

-- --What is the total revenue by month? -----------
SELECT
	month_name as month,
    SUM(Total) AS total
    FROM sales
    GROUP BY month_name;
    
-- ---What month had the largest COGS? ------------------

SELECT month_name AS month,
SUM(COGS) AS COGS
FROM sales
GROUP BY month;

-- --What product line had the largest revenue?

SELECT product_line,
SUM(total) AS revenue
FROM sales
GROUP BY product_line
ORDER BY revenue DESC LIMIT 1;

-- --What month had the largest COGS? ----

SELECT month_name,
SUM(Cogs) AS Cogs
FROM sales
GROUP BY month_name
ORDER BY Cogs DESC LIMIT 1;

-- --What is the city with the largest revenue? ---

SELECT City,
SUM(total) AS revenue
FROM sales
GROUP BY City
ORDER BY revenue DESC LIMIT 1;

-- What product line had the largest VAT? --

SELECT product_line,
AVG(VAT) AS vat
FROM sales
GROUP BY product_line
ORDER BY VAT DESC LIMIT 1;


-- -- Which branch sold more products than average product sold? --------------
SELECT branch,
SUM(quantity) AS products_sold
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- --What is the most common product line by gender?
SELECT 
	gender,
	product_line,
    COUNT(gender) AS total_cnt
    FROM sales
    GROUP BY gender,product_line
    ORDER BY total_cnt DESC;

-- -- What is the average rating of each product line? --
SELECT 
	product_line,
    AVG(rating) AS avg_rating
    FROM sales
    GROUP BY product_line;
    
-- ------------------------------------------------------------------------------------------------
-- -----------------------------------Sales--------------------------------------------------------
-- -- Number of sales made in each time of the day per weekday -----
SELECT time_of_day,
COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day;
	
-- --Which of the customer types brings the most revenue? --
SELECT customer_type,
SUM(total) AS revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC LIMIT 1;

-- --Which city has the largest tax percent/ VAT (**Value Added Tax**)?
SELECT City,
AVG(VAT) AS avg_vat
FROM sales
GROUP BY City
ORDER BY avg_vat DESC LIMIT 1;

-- Which customer type pays the most in VAT? --
SELECT customer_type,
AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC LIMIT 1;
