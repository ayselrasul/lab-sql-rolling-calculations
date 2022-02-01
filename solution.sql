                   -- Lab | SQL Rolling calculations
				   
-- In this lab, you will be using the Sakila database of movie rentals
   
   use sakila;

-- Get number of monthly active customers

CREATE OR REPLACE VIEW monthly_active_customer_count AS
    SELECT 
        COUNT(DISTINCT customer_id) AS number_of_active_customers,
        CONVERT( DATE_FORMAT(CONVERT( rental_date , DATE), '%Y-%m-01') , DATE) activity_month  -- I want to show month-year combination as one column
    FROM
        sakila.rental
    GROUP BY activity_month;
   
SELECT 
    *
FROM
    monthly_active_customer_count;  -- check the records
   

   
-- Active users in the previous month

with last_months_active_customers as
  (select  activity_month, number_of_active_customers,
           lag(number_of_active_customers,1) over (order by activity_month)
           as number_of_last_months_active_customers
   from monthly_active_customer_count
  )
   select * from last_months_active_customers
   where number_of_last_months_active_customers is not null;
   

-- Percentage change in the number of active customers

with activity_percentage_change as (
	select activity_month,number_of_active_customers, lag(number_of_active_customers,1) over (order by activity_month)
  as number_of_last_months_active_customers
	from monthly_active_customer_count
)
select *, (((number_of_active_customers-number_of_last_months_active_customers)*100)
		   /number_of_last_months_active_customers) as '% activity percentage change' from activity_percentage_change
where number_of_last_months_active_customers is not null;




-- Retained customers every month

CREATE OR REPLACE VIEW monthly_active_customers AS     -- -- Customers from previous months considered as retained customers
    SELECT DISTINCT
        customer_id,
        CONVERT( DATE_FORMAT(CONVERT( rental_date , DATE), '%Y-%m-01') , DATE) activity_month
    FROM
        sakila.rental;

SELECT 
    d1.activity_month,
    COUNT(DISTINCT d2.customer_id) AS retained_customers
FROM
    monthly_active_clients d1
        LEFT JOIN
    monthly_active_clients d2 ON (d1.customer_id = d2.customer_id
        AND d1.activity_month > d2.activity_month)
GROUP BY d1.Activity_Month
ORDER BY d1.Activity_Month;









