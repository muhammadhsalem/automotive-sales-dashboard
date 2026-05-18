with main_cte as 
(select * ,
row_number() over(partition by customername order by orderdate) as rn,
lag(sales) over(partition by customername order by orderdate)  as previous_sale
from (
select t1.ordernumber,orderdate,t1.customernumber, customername,sum(quantityOrdered*priceEach) as sales
from orders t1
join orderdetails t2
on t1.orderNumber=t2.orderNumber
join customers t3
on t1.customerNumber = t3.customerNumber
group by orderNumber
) sb)

select * ,sales-previous_sale as sales_diff from
main_cte
where previous_sale is not null
