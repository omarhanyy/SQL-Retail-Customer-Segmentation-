--We will use a CTE to easly deal with date colum 
with sales_data as (
select INVOICE,STOCKCODE, QUANTITY, INVOICEDATE, PRICE,CUSTOMER_ID, COUNTRY,
         TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI') as INVOICE_DATE,
         EXTRACT(YEAR FROM TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI')) AS year,
         TO_CHAR(TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI'), 'Q') as quarter,
         EXTRACT(month FROM TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI')) as month
from tableRetail
)

--select * from sales_data;

----lets validate completeness of data at first
--select year,count(distinct month) as month_count
--from sales_data
--group by year;



----sales by quarter ranked
--SELECT  'Q' ||quarter as quarter,
--       trunc(SUM(quantity * price) / 1000) || 'K' AS total_sales,
--       rank() over(order by SUM(quantity * price) desc) as best_sales_quarter
--FROM sales_data
--where year = 2011
--GROUP BY quarter;

----sales by month ranked
--SELECT  'Q' ||quarter as quarter ,month,
--       trunc(SUM(quantity * price) / 1000) || 'K' AS total_sales,
--       rank() over(order by SUM(quantity * price) desc) as  rankkk
--FROM sales_data
--where year = 2011
--GROUP BY quarter,month;

----how many days in December
--select max(invoice_date) as Days_in_Dec from sales_data;
--
----month over month change
--SELECT 'Q' || quarter as quarter , month,
--       --SUM(quantity * price) AS curr_month_sales,
--       --nvl(lag(SUM(quantity * price)) over(order by month),0) as last_mon_sales,
--       --nvl(SUM(quantity * price) - lag(SUM(quantity * price)) over(order by month),0) as diff,
--      nvl(trunc((100 * (sum(quantity*price) - lag(sum(quantity*price)) over(order by month)) / lag(sum(quantity*price)) over(order by month))),0)  || '%' as m_over_m
--FROM sales_data
--where  year= 2011
--GROUP BY quarter, month;


--How many customer for each month
select month,count(distinct customer_id) as paying_customers_count
from sales_data
where year = 2011
group by month
order by paying_customers_count desc;


select *
from sales_data
where month = 4 and year = 2011;




