select t1.orderdate,t1.ordernumber,quantityOrdered,priceEach,productName,productLine,buyPrice,city,country
from orders t1
inner join orderdetails t2
on t1.orderNumber=t2.orderNumber
inner join products t3
on t3.productCode=t2.productCode
inner join customers t4
on t4.customerNumber=t1.customerNumber