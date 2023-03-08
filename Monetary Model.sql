with cust_val as 
(
select customer_id,
          trunc((select max(TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI')) from tableRetail) -  max(TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI'))) as recency,
          count(distinct invoice)as  frequency,
          sum(quantity*price) as monetary
from tableRetail
group by customer_id
),

cust_score as 
(
select customer_id,
         ntile (5) over(order by recency desc) r_score,
         ntile (5) over(order by frequency) f_score,
         ntile (5) over(order by monetary) m_score,
         round((ntile (5) over(order by frequency) + ntile (5) over(order by monetary)) /2) as fm_socre
from cust_val
)

select v.customer_id,recency,frequency,monetary,r_score,fm_socre,
case 
    when (r_score = 5 and fm_socre = 5) or (r_score = 5 and fm_socre = 4) or (r_score = 4 and fm_socre = 5)  then 'Champions'
    when (r_score = 5 and fm_socre = 2) or (r_score = 4 and fm_socre = 2) or (r_score = 3 and fm_socre = 3) or (r_score = 4 and fm_socre = 3) then 'Potentioal loyalist'
    when (r_score = 5 and fm_socre = 3) or (r_score = 4 and fm_socre = 4) or (r_score = 3 and fm_socre = 5) or (r_score = 3 and fm_socre = 4) then 'Loyal Customers'
    when (r_score = 5 and fm_socre = 1)  then 'Recent Customers'
    when (r_score = 4 and fm_socre = 1) or (r_score = 3 and fm_socre = 1) then 'Promising'
    when (r_score = 3 and fm_socre = 2) or (r_score = 2 and fm_socre = 3) or (r_score = 2 and fm_socre = 2)  then 'Customers Need Attention'
    when (r_score = 2 and fm_socre = 5) or (r_score = 2 and fm_socre = 4) or (r_score = 1 and fm_socre = 3)  then 'At Risk'
    when (r_score = 1 and fm_socre = 5) or (r_score = 1 and fm_socre = 4) then 'Cant lose them'
    when (r_score = 1 and fm_socre = 2)  then 'Hibernating'
    when (r_score = 1 and fm_socre = 1)  then 'Lost'
    else 'At Risk'
    end as cust_segment
from cust_score s, cust_val v
where s.customer_id = v.customer_id ;

