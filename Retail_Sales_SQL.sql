-- Create Table

Create table Retail_sales( 
					transactions_id INT PRIMARY KEY,
					sale_date DATE,
					sale_time TIME,
					customer_id INT,
					gender VARCHAR(15),
					age INT, 
					category VARCHAR(15),
					quantiy INT,
					price_per_unit FLOAT,
					cogs FLOAT,
					total_sale FLOAT										
					);

SELECT * FROM Retail_sales;

SELECT 
	count(*)
	FROM Retail_sales;
	
-- Data cleaning

SELECT * FROM Retail_sales
Where
	Transactions_id is null
	OR 
	sale_date is null
	OR 
	sale_time is null
	OR 
	customer_id is null
	OR
	gender	is null
	OR 
	age is null
	OR 
	category is null
	OR 
	quantiy is null
	OR 
	price_per_unit is null
	OR 
	cogs is null
	OR 
	total_sale is null;

Delete from Retail_sales
Where quantiy is null;

update Retail_sales
set age = 10
where age is Null;

-- Data exploration

-- How many sales do we have?

select count(*) as total_sales
from Retail_sales;

-- How many customers do we have?

select count(distinct customer_id) as total_customers
from Retail_sales;

-- How many categories do we have?

select distinct (category)
from Retail_sales;

-- Data analysis & business key problems. 

 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from Retail_sales
where sale_date = '2022-11-05';

ALTER TABLE Retail_sales
RENAME COLUMN quantiy TO quantity;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select *
from Retail_sales 
where category = 'Clothing'
	and
	to_char(sale_date, 'YYYY-MM') = '2022-11'
	and 
	quantity >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
	category,
	sum(total_sale) as net_sale,
	count (*) as total_orders
from Retail_sales 
group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select
	round(avg (age), 2) as Avg_age
	from Retail_sales 
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select count(transactions_id) as total_transaction
from Retail_sales
where total_sale > '1000'

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.


select 
	category,
	gender,
	count(*) as total_trans
from retail_sales
	group by 
	category,
	gender
order by total_trans desc;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year


SELECT 
	year,
	month,
	avg_sale
FROM 
(
SELECT 
    extract(year from sale_date) AS year,
    extract(month from sale_date) AS month,
    AVG(total_sale) AS avg_sale,
    RANK() OVER (
        PARTITION BY extract(year from sale_date)
        ORDER BY AVG(total_sale) DESC
    ) as rank
FROM retail_sales
GROUP BY 1,2
) as t1
where rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
	category,
	count(distinct customer_id) as cnt_unique_cs
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *, 
	CASE 
		WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM Sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift 
FROM retail_sales
)
SELECT
	shift,
	count(*) total_orders
	FROM hourly_sale
group by shift;
