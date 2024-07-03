-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
select * from sales;
alter table sales add column time_of_day varchar(10);
select time ,( 
case 
WHEN "time" between "00;00;00" and "12;00;00" Then "Morning"
WHEN  "time" between "12;01;00" and "4;00;00" Then "Afternoon"
else "Evening"
End )AS Time_of_daTE from sales;

update sales set time_of_day =  ( case 
WHEN "time" between "00;00;00" and "12;00;00" Then "Morning"
WHEN  "time" between "12;01;00" and "4;00;00" Then "Afternoon"
else "Evening"
End );
select * from sales;
alter table sales add column day_name varchar(10);
update sales set  day_name=dayname(date);
alter table sales add column month_name varchar(10);
update sales set month_name = monthname(date);

select * from sales;
-- -------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?

select 	distinct city from sales;

-- In which city is each branch?

select distinct city, branch from sales;

-- How many unique product lines does the data have?

select distinct (product_line) from sales;

-- What is the most selling product line

select 
	sum(quantity) as qty,
    product_line 
    from sales 
    group by product_line
    order by qty desc;

-- What is the total revenue by month

select 
	month_name as month,
    sum(total) as total_revenue
    from sales
    group by month_name 
    order by total_revenue;
    
-- What month had the largest COGS?

SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs; 

-- What product line had the largest revenue?

select
	 product_line,
     sum(total) as total_revenue
     from sales 
     group by product_line
     order by revenue desc;

-- What is the city with the largest revenue?
select 
	city,
    branch,
    sum(total) as total_revenue
    from sales 
    group by city,branch
    order by total_revenue desc;
    
-- What product line had the largest VAT?
select 
	product_line,
	tax_pct as VAT
    from sales
    order by tax_pct desc;
    select * from sales;
    
    -- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

select 
avg(quantity) as qty
from sales;
select  product_line ,(case
		when avg(quantity) > 6 then " good"
        else "bad"
        end ) as remark from sales
        group by product_line;
-- Which branch sold more products than average product sold?
select 
	branch,
    avg(quantity) as qty
    from sales 
    group by branch
    having sum(quantity) > (select avg(quantity) from sales);
    
-- What is the most common product line by gender

select product_line,
		count(gender) as total_cnt
        from sales
        group by gender ,product_line
        order by total_cnt desc;
        
-- What is the average rating of each product line

select round(avg(rating),2) as  avg_rating    ,
	product_line
    from sales
    group by product_line
    order by avg_rating;

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
select * from sales;
select distinct(customer_type) from sales;

-- How many unique payment methods does the data have?

select distinct(payment) as payment_method from sales;

-- What is the most common customer type?

select 
	customer_type,
    count(*) as count
    from sales
    group by customer_type
    order by count desc;
select  customer_type,
		count(customer_type) as customer
        from sales
        group by customer_type;
        
-- What is the gender of most of the customers?

 select gender,
 count(gender) as count
 from sales
 group by gender;
 
 -- What is the gender distribution per branch?

select  gender,
		branch,
	count(gender) as count
    from sales
    GROUP by branch , gender
    order by count desc;
    
    SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?

SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?
select * from sales;
select day_name ,
	avg(rating) as avg_rating
    from sales
    group by day_name
    order by avg_rating desc;

-- Which day of the week has the best average ratings per branch?

SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;


-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;
