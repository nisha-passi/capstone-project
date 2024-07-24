Create Database amazon_sales_data;

Use amazon_sales_data;

CREATE TABLE amazon (
     invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
     branch VARCHAR(5) NOT NULL, 
     city VARCHAR(30) NOT NULL,
     customer_type VARCHAR(30) NOT NULL,
     gender VARCHAR(10) NOT NULL,
     product_line VARCHAR(100) NOT NULL, 
     unit_price DECIMAL(10, 2) NOT NULL,
     quantity INT NOT NULL, 
     vat FLOAT(6, 4) NOT NULL,
     total DECIMAL(10, 2) NOT NULL,
     date date NOT NULL, 
     time time NOT NULL, 
     payment_method VARCHAR(15) NOT NULL, 
     cogs DECIMAL(10, 2) NOT NULL, 
     gross_margin_percentage FLOAT NOT NULL, 
     gross_income DECIMAL(10, 2) NOT NULL, 
     rating float
);

Select * from amazon;

alter table amazon 
add column timeofday varchar(10);

select timeofday from amazon;

UPDATE amazon
SET timeofday = 
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '17:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END;
    
SET SQL_SAFE_UPDATES = 0;
update amazon set dayname = dayname(date);

select dayname from amazon;

SET SQL_SAFE_UPDATES = 0;
update amazon
set monthname = monthname(date);
select * from amazon;

#1 What is the count of distinct cities in the dataset?
select count(distinct City) as city_count from amazon;

#2 For each branch, what is the corresponding city?
select branch, city from amazon
group by branch, city
order by branch;

#3 What is the count of distinct product lines in the dataset?
select count(distinct product_line ) as product_line_count from amazon;

#4 Which payment method occurs most frequently?
SELECT payment_method, COUNT(*) AS most_Frequent_payment_method
FROM amazon
GROUP BY payment_method
ORDER BY most_Frequent_payment_method DESC
LIMIT 1;

#5 Which product line has the highest sales?
SELECT product_line, sum(quantity) AS highest_product_sales
FROM amazon
GROUP BY product_line
ORDER BY highest_product_sales DESC
LIMIT 1;

#6 How much revenue is generated each month?
Select sum(total) as Total_Revenue , monthname
From amazon
Group By monthname
order by Total_Revenue desc;

#7 In which month did the cost of goods sold reach its peak?
Select monthname, sum(cogs) as total_cogs
From amazon
Group By monthname
ORDER BY total_cogs DESC;

#8 Which product line generated the highest revenue?
Select product_line, sum(total) as product_line_highest_revenue
from amazon
group by product_line
order by product_line_highest_revenue Desc
limit 1;

#9 In which city was the highest revenue recorded?
Select city, sum(total) as highest_revenue_city
from amazon
group by city
order by highest_revenue_city Desc
limit 1;

#10 Which product line incurred the highest Value Added Tax?
Select product_line, sum(vat) as Highest_Value_Added_Tax
from amazon
group by product_line
order by Highest_Value_Added_Tax Desc
limit 1;

#11 For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
ALTER TABLE amazon
ADD COLUMN sales_performance VARCHAR(10);
SET SQL_SAFE_UPDATES = 0;
UPDATE amazon
SET sales_performance = (
    SELECT CASE
        WHEN AVG(total) OVER (PARTITION BY product_line) > (select tot from (SELECT AVG(total) as tot FROM amazon) as average)
        THEN 'Good'
        ELSE 'Bad'
    END
);

select  product_line, sales_performance from amazon;

#12 Identify the branch that exceeded the average number of products sold.
SELECT branch, SUM(quantity) AS total_quantity
FROM amazon
GROUP BY branch
HAVING total_quantity > (SELECT AVG(quantity) FROM amazon);

#13 Which product line is most frequently associated with each gender?
select gender, product_line, count(*) as freguency from amazon 
group by gender, product_line
order by gender, freguency desc;

#14 Calculate the average rating for each product line.
SELECT product_line, ROUND(AVG(rating),1) AS avg_rating
FROM amazon
GROUP BY product_line
ORDER BY avg_rating DESC;

#15 Count the sales occurrences for each time of day on every weekday.
SELECT timeofday, dayname, count(*) AS sales_occurrences
FROM amazon
GROUP BY timeofday, dayname
ORDER BY sales_occurrences DESC;

#16 Identify the customer type contributing the highest revenue.
SELECT customer_type, sum(total) AS highest_revenue
FROM amazon
GROUP BY customer_type
ORDER BY highest_revenue DESC
LIMIT 1;

#17 Determine the city with the highest VAT percentage.
SELECT city, sum(vat) / SUM(cogs) * 100 AS highest_VAT_percentage
FROM amazon
GROUP BY city
ORDER BY highest_VAT_percentage DESC
LIMIT 1;

#18 Identify the customer type with the highest VAT payments.
SELECT customer_type, SUM(vat) AS highest_VAT
FROM amazon
GROUP BY customer_type
ORDER BY highest_VAT DESC
LIMIT 1;

#19 What is the count of distinct customer types in the dataset?
Select distinct customer_type as distinct_customer_type 
from amazon;

#20 What is the count of distinct payment methods in the dataset?
Select count(distinct payment_method) as count_distinct_payment_method 
from amazon;

#21 Which customer type occurs most frequently?
SELECT customer_type, COUNT(*) AS most_Frequent_customer_type
FROM amazon
GROUP BY customer_type
ORDER BY most_Frequent_customer_type DESC
LIMIT 1;

#22 Identify the customer type with the highest purchase frequency.
SELECT customer_type, COUNT(*) AS customer_highest_purchase_frequency
FROM amazon
GROUP BY customer_type
ORDER BY customer_highest_purchase_frequency DESC
LIMIT 1;

#23 Determine the predominant gender among customers.
SELECT gender, count(*) AS predominant_gender FROM amazon
GROUP BY gender
ORDER BY predominant_gender DESC
LIMIT 1;

#24 Examine the distribution of genders within each branch.
SELECT branch, gender, count(*) AS gender_count FROM amazon
GROUP BY branch, gender
ORDER BY branch DESC;

#25 Identify the time of day when customers provide the most ratings.
SELECT timeofday, count(rating) as count_rating FROM amazon
GROUP BY timeofday
ORDER BY count_rating DESC
LIMIT 1;

#26 Determine the time of day with the highest customer ratings for each branch.
SELECT branch , timeofday, ROUND(AVG(rating), 1) AS avg_rating FROM amazon
GROUP BY branch, timeofday, rating
ORDER BY avg_rating DESC;

#27 Identify the day of the week with the highest average ratings.
SELECT dayname, ROUND(AVG(rating), 1) AS avg_rating FROM amazon
GROUP BY dayname
ORDER BY avg_rating DESC
LIMIT 1;

#28 Determine the day of the week with the highest average ratings for each branch.
SELECT branch, dayname, ROUND(AVG(rating), 1) AS avg_rating
FROM amazon
GROUP BY branch, dayname
ORDER BY avg_rating DESC







