# Retail Customer Segmentation (RFM) & Sales Analysis Using SQL
Monetary model for Retail &amp; Financial analysis using SQL window functions 

In this case study using the OnlineRetail dataset, I explored the dataset and summarized the it using different analytical SQL queries to get these Insights:

 
- **Sales In 2010 VS 2011**
- **Qarter Sales In 2011**
- **Monthly Sales Rank In 2011**
- **Month-over-Month Sales**
- **Sales Decline root cause analysis**


 #### Can we compare the sales of 2010 to 2011?
  
![image](https://user-images.githubusercontent.com/59100642/236642482-ce3e6690-1f0a-478d-b7fc-8ee22cd991ef.png)

  #### Insight:
  By validating the completeness of data first, we have only the data of ‘December’ for year 2010, So we
  will not compare sales numbers of 2011 to 2010.
  
  #### Which quarter in 2011 had the highest sales?
  ```
  SELECT 'Q' ||quarter as quarter,
        trunc(SUM(quantity * price) / 1000) || 'K' AS total_sales,
        rank() over(order by SUM(quantity * price) desc) as best_sales_quarter
        FROM sales_data
        where year = 2011
        GROUP BY quarter;
  ```
![image](https://user-images.githubusercontent.com/59100642/236644211-4c2566d0-8d79-4107-9ed2-641eba1ebf4b.png)

  #### Insight:
  Quarter 3 and Quarter 4 have the highest sales and Quarter 1 have the least sales.
  
  #### Which months in 2011 had the highest and lowest sales?
  ```
  SELECT 'Q' ||quarter as quarter ,month,
trunc(SUM(quantity * price) / 1000) || 'K' AS total_sales,
rank() over(order by SUM(quantity * price) desc) as rankkk
FROM sales_data
where year = 2011
GROUP BY quarter,month;
```
![image](https://user-images.githubusercontent.com/59100642/236642582-e1585466-cdf0-4dc4-bfa4-f7fc46e54b20.png)

#### Insight:
The highest month in sales is ‘November’ with 45K sales and the least is ‘January’ with 9K.
So clearly there was a **problem in Q1 sales.**

 #### How is the month-over-month sales looks like?
  
  ![image](https://user-images.githubusercontent.com/59100642/236642642-ddd7100a-74e8-411d-b1e4-949611348ff4.png)

  ```
SELECT 'Q' || quarter as quarter , month,
nvl(trunc((100 * (sum(quantity*price) - lag(sum(quantity*price)) over(order by month)) /
lag(sum(quantity*price)) over(order by month))),0) || '%' as m_over_m
FROM sales_data
where year= 2011
GROUP BY quarter, month;
  ```

  ```
select max(invoice_date) as Days_in_Dec from sales_data;
  ```


#### Insight:


The biggest two spikes were in August and November.

There’s drawbacks in April, June, September, October and December
Although September and October actually performed great sales looking at the previous question.

And because we only have records of the first 9 days of **December it cannot be compared with others**

![image](https://user-images.githubusercontent.com/59100642/236642678-01031757-2743-49f5-854a-0789c8c58bd3.png)

So we can conclude that April is the month with the highest decline.


  #### Investigate more the decline in April?
  ![image](https://user-images.githubusercontent.com/59100642/236642826-aab7f5f1-16b5-4f2e-a7ab-11d591d89d9e.png)

```  
select month,count(distinct customer_id) as paying_customers_count
from sales_data
where year = 2011
group by month
order by paying_customers_count desc;
```

#### Insight:
The highest month with paying customer was November with 45 customer.
And as we can see that April had only 15 customer and that explains the decline in sales.


# Customer Segmentation & Monetary Model  

After exploring the data I implemented a Monetary model for
customers behavior for product purchasing and segment each customer based on the below
groups:
Champions - Loyal Customers - Potential Loyalists – Recent Customers – Promising -
Customers Needing Attention - At Risk - Cant Lose Them – Hibernating – Lost

```
#Code can be found in the .sql script file
```
![image](https://user-images.githubusercontent.com/59100642/236643853-6f1393b0-a7c2-4153-895b-241cfa7d1062.png)

- Recency : how recent the last transaction is (The difference between the most recent invoice date and the recent invoice date for each customer)
- Frequency : how many times the customer has bought from our store (The count of invoices for each customer)
- Monetary : how much each customer has paid for our products (Total payment the customer made)
- R_Score : NTILE(5), grouping the recency by 5 groups 1,2,3,4,5
- fm_score : Average of NTILE(5) for each F_Score and M_Score NTILE(5), grouping the average by 5 groups 1,2,3,4,5
- Cust_Segment : Based on the given table each customer is labeled with the calculated segment
