/*vistas*/

/*2*/
create view totalxorden as select sum(quantityOrdered)from orderdetails group by orderNumber;

select * from totalxorden;

/*3*/
create view mayoravg as select * from products where buyPrice>(select avg(buyPrice) from products);

select * from mayoravg;

/*6*/
create view nopaga as select * from customers where customerNumber not in (select customerNumber from payments);

select * from nopaga;

/*10*/
create view clientesv as select customerName,phone,addressLine1 from customers join orders on customers.customerNumber=orders.customerNumber join orderdetails on orders.orderNumber=orderdetails.orderNumber where shippedDate<curdate()-interval 2 year and (priceEach*quantityOrdered)>30000;
drop view clientesv;
select * from clientesv;

/*13*/
alter view clientestop as select customerNumber from orders group by customerNumber order by count(orderNumber) desc limit 1;

select * from clientestop;
