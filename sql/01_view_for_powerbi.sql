
create or replace view sales_data_pb as

select 
o.orderDate,
o.orderNumber,
c.customerName,
c.country as customerCountry,
t.country as officeCountry,
p.productName,
p.productLine,
quantityOrdered,
buyPrice,
priceEach,
quantityOrdered * buyPrice as cost_of_sales,
quantityordered * priceEach as sales

from orders o
join orderdetails od
on o.orderNumber = od.orderNumber
join customers c
on c.customerNumber = o.customerNumber
join products p 
on p.productCode = od.productCode
join employees e
on e.employeeNumber = c.salesRepEmployeeNumber
join offices t
on t.officeCode = e.officeCode