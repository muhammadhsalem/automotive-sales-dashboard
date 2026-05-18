select t1.ordernumber,t3.customerNumber,sum(quantityOrdered*priceEach) as sales,creditlimit,
case when creditLimit <75000 then 'a:less than $75k'
when creditLimit between 75000 and 100000 then 'b:$75k - 100k'
when creditLimit between 100000 and 150000 then 'c:$100k - 150k'
when creditlimit > 150000 then 'd: more than $150k'
else 'other'
end as creditlimit_group 
from orderdetails t1
join orders t2 
on t1.orderNumber = t2.orderNumber
join customers t3
on t3.customerNumber=t2.customerNumber
group by orderNumber,customernumber
