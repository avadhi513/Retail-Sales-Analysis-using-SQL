CREATE DATABASE p1_retail_db;

CREATE TABLE IF NOT EXISTS retail_sales
(
	transaction_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	cust_id INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(35),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sales FLOAT
);

SELECT COUNT(*) FROM retail_sales;

SELECT COUNT(DISTINCT cust_id) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE
	sale_date IS NULL 
	OR sale_time IS NULL 
	OR cust_id IS NULL 
	OR gender IS NULL 
	OR age IS NULL 
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL 
	OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
	sale_date IS NULL 
	OR sale_time IS NULL 
	OR cust_id IS NULL 
	OR gender IS NULL 
	OR age IS NULL 
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL 
	OR cogs IS NULL;


SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

SELECT *
FROM retail_sales
WHERE 
category = 'Clothing'
AND 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND 
quantity >= 4;

SELECT 
	category,
	SUM(total_sales) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

SELECT 
ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

select * from retail_sales
where total_sales > 1000;

select 
	category,
	gender,
	count(*) as total_trans
from retail_sales
group by 
	category,
	gender
order by 1;

select 
	year,
	month,
	avg_sale
from 
(
	select 
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sales) as avg_sale,
		rank() over(partition by extract(year from sale_date)
		order by avg(total_sales) desc) as rank

	from retail_sales
	group by 1, 2
) as t1
where rank = 1;

select 
	cust_id,
	sum(total_sales) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

select 
	category,
	count(distinct cust_id) as cnt_unique_cs
from retail_sales
group by category;

with hourly_sale
as
(
	select *,
		case 
			when extract(hour from sale_time) < 12 
				then 'Morning'
			when extract(hour from sale_time) between 12 and 17
				then 'Afternoon'
			else 'Evening'
		end as shift
	from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sale
group by shift;


