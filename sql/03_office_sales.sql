select 
t1.ordernumber,
t3.customerNumber,
t3.city as cust_city,
t3.country as cust_country,
t6.productLine,
t5.city as office_city,
t5.country as office_country,
sum(quantityOrdered*priceEach) as sales
from orders t1
join orderdetails t2
on t1.orderNumber = t2.orderNumber
join customers t3
on t3.customerNumber=t1.customerNumber
join employees t4
on t4.employeeNumber = t3.salesRepEmployeeNumber
join offices t5
on t5.officeCode = t4.officeCode
join products t6 
on t2.productCode=t6.productCode
group by 
t1.ordernumber,
t3.customerNumber,
cust_city,
cust_country,
office_city,
office_country,
productLine
