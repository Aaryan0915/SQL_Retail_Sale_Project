
-- SQL Retail Sales Analysis ( Project )

create database SQL_Retail_Project;

-- Create Table
create table Retail_Sales 
				(
					transactions_id INT Primary Key,	
					sale_date Date,	
					sale_time time,	
					customer_id INT,	
					gender Varchar(10),	
					age INT,
					category Varchar(15),	
					quantiy INT,	
					price_per_unit float,	
					cogs float,	
					total_sale float);
                    
select * from retail_sales limit 100;	
desc retail_sales;
select count(*) from retail_sales;

-- Data Cleaning

select * from retail_sales
where transactions_id is null or 
sale_date is null or 
sale_time is null or 
customer_id is null or 
gender is null or 
age is null or 
category is null or 
quantiy is null or 
price_per_unit is null or 
cogs is null or 
total_sale is null;

Delete from retail_sales
where transactions_id is null or 
sale_date is null or 
sale_time is null or 
customer_id is null or 
gender is null or 
age is null or 
category is null or 
quantiy is null or 
price_per_unit is null or 
cogs is null or 
total_sale is null;

SET SQL_SAFE_UPDATES =1;

-- Data Exploration

-- How many Unique customers are there ?
select count(distinct customer_id) from retail_sales; -- 155 customers

-- How many category are there?
select distinct category from retail_sales; -- 3 categories

-- Data analysis , Business Key Problems & their answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than equal & to 4 in the month of Mar-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

select * from retail_sales;

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than & equal to 4 in the month of Mar-2022

SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantiy >= 4
        AND sale_date BETWEEN '2022-03-01' AND '2022-03-31'
ORDER BY sale_date;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) and total orders for each category.

SELECT 
    category,
    SUM(total_sale) AS Total_Sales,
    COUNT(*) AS Total_orders
FROM
    retail_sales
GROUP BY Category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
    round(AVG(age)) as Avg_Age
FROM
    retail_sales
WHERE
    category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category, gender, COUNT(transactions_id) AS Total_Transaction
FROM
    retail_sales
GROUP BY category , gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select * from
(SELECT 
    year(sale_date)as Year,
    month(sale_date) as Month,
    ROUND(AVG(total_sale)) AS Avg_sale,
    RANK() OVER(PARTITION BY year(sale_date) ORDER BY AVG(total_sale) DESC) as ranks
FROM
    retail_sales
group by 1,2) as T1
where ranks=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category, COUNT(DISTINCT customer_id) Unique_customers
FROM
    retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly as(
select sale_time, 
	case
		when sale_time<='12:00:00' then 'Morning'
        when sale_time between '12:00:00' and '17:00:00' then 'Afternoon'
        else 'Evening'
	end as shift
from retail_sales)
select shift , count(*) as total_orders 
from hourly 
group by shift;

-- End --

