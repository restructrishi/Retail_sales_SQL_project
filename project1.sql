-- SQL Retails Sales Project

-- create table

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
	transactions_id	 INT PRIMARY KEY ,
	sale_date	DATE ,
	sale_time	TIME ,
	customer_id	INT ,
	gender	VARCHAR(15) ,
	age	INT ,
	category VARCHAR (20),	
	quantity INT,
	price_per_unit	FLOAT,
	cogs	FLOAT ,
    total_sale FLOAT
);


SELECT * FROM retail_sales
LIMIT 10

SELECT 
	COUNT(*) 
FROM retail_sales;

-- Data Cleaning

SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL


--

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL


-- Data Exploration

-- How many sales we have 

SELECT COUNT(*) AS total_sale FROM retail_sales

-- How many UNIQUE customers we have
	
SELECT COUNT( DISTINCT customer_id) AS total_sale FROM retail_sales

SELECT DISTINCT CATEGORY AS total_sale FROM retail_sales


	
-- DATA ANALYSIS & BUSINESS KEY PROBLEMS

-- Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05'

-- Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022:

SELECT 
	* 
FROM retail_sales
WHERE 
	category = 'Clothing' 
	AND
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND
	quantity >= 4


-- Q3 Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT category , SUM(total_sale) FROM retail_sales
GROUP BY 1

-- if we wnat total order so the query will be
	
SELECT category , SUM(total_sale),
	COUNT (*) total_orders
	FROM retail_sales
GROUP BY 1


-- Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT category , AVG(age) FROM retail_sales
where category = 'Beauty'
GROUP BY 1


-- for rounding the age 
SELECT category , ROUND(AVG(age) , 2) FROM retail_sales
where category = 'Beauty'
GROUP BY 1

-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM RETAIL_SALES
WHERE total_sale>1000


-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT category , gender ,
	COUNT(*) as total_transaction
	FROM retail_sales
GROUP BY gender , category
ORDER BY 1

-- another mehod

SELECT category , gender ,
	COUNT(*) as total_trans
	FROM retail_sales
GROUP BY 1 , 2
ORDER BY 1

-- Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT year , month , avg_sale
	FROM
	(
SELECT 
	EXTRACT (YEAR FROM sale_date) as year ,
	EXTRACT (MONTH FROM sale_date) as month ,
	AVG(total_sale) as avg_sale ,
	RANK() OVER(
	PARTITION BY EXTRACT (YEAR FROM sale_date)
	ORDER BY AVG(total_sale) DESC ) as rank
	
	FROM retail_sales

GROUP BY 1 , 2
) as t1
WHERE rank = 1
-- if we use mysql so for 
-- this query EXTRACT (YEAR FROM sale_date) as year 
-- we write YEAR(sale_date)


-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- Query for maximum amount from a single transaction for each customer
SELECT customer_id ,
	MAX(total_sale) 
	FROM retail_sales
GROUP BY 1 
ORDER BY 2
limit 5

-- Q9 Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT 
	category ,
	COUNT(DISTINCT customer_id ) as cnt_unique_cs
	FROM retail_sales
GROUP BY category

-- Q 10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
	
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift













