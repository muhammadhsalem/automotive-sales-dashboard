with prod_sales as 
(
select orderNumber,t2.productCode,productName,productLine
from orderdetails t1
inner join products t2
on t1.productCode=t2.productCode
order by orderNumber
)
select distinct t1.ordernumber,t1.productline as prod_1,t2.productline as prod_2
from prod_couples t1
inner join prod_couples t2
on t1.ordernumber=t2.ordernumber and t1.productline != t2.productline
order by ordernumber;
