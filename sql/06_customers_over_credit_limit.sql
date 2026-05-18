with main as 
(select *, lead(orderdate) over(partition by customernumber order by orderdate) as next_order
from
	(select orderdate,t1.orderNumber,t1.customernumber,customername,creditlimit,
	sum(quantityordered*priceeach) as sales
	from orders t1
	join orderdetails t2
	on t1.orderNumber = t2.orderNumber
	join customers t3 
	on t1.customerNumber=t3.customerNumber
	group by orderdate,t1.customernumber,customername,creditlimit,orderNumber)sb
),

payment_cte as (
	select * 
	from payments
	),


final_cte as
(select t1.*, amount,
sum(sales) over(partition by t1.customernumber order by orderdate) as running_total_sales
,sum(amount) over(partition by t1.customerNumber order by orderdate) as running_total_payments
from main t1
left join payment_cte t2
on t1.customernumber=t2.customernumber 
and paymentdate between orderdate and case when next_order is null then current_date else next_order end
)
select * from 
(select *,running_total_sales-running_total_payments as money_owed
,creditlimit-(running_total_sales-running_total_payments) as diff
from final_cte)sb2




