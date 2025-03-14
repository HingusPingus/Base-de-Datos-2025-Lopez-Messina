/*1*/
delimiter //
create function ordenes (fecha_inicio date, fecha_fin date, estado varchar(15)) returns int deterministic
begin
declare cant_ord int;
select count(*) into cant_ord from orders where status=estado and orderDate between fecha_inicio and fecha_fin;
return cant_ord;
end //
delimiter ;

select ordenes("2000-5-6", current_date(), "Cancelled");

/*2*/
delimiter //
create function entregadas (fecha_inicio date, fecha_fin date) returns int deterministic
begin
declare cant_ord int;
select count(*) into cant_ord from orders where status="Shipped" and shippedDate between fecha_inicio and fecha_fin;
return cant_ord;
end //
delimiter ;

select entregadas("2000-5-6", current_date());

/*3*/
delimiter //
create function empl_city (client_num int) returns varchar (50) deterministic
begin
declare emp_city varchar(50);
select offices.city into emp_city from offices join employees on employees.officeCode=offices.officeCode 
join customers on customers.salesRepEmployeeNumber=employees.employeeNumber 
where client_num=customerNumber;
return emp_city;
end //
delimiter ;
drop function empl_city;
select empl_city(112);

/*4*/
delimiter //
create function stock (linea_producto varchar(25)) returns int deterministic
begin
declare cant_stock int;
select sum(quantityInStock) into cant_stock from products where productLine=linea_producto group by productLine;
return cant_stock;
end //
delimiter ;


select stock("Trucks and Buses");

/*5*/
delimiter //
create function cant_client (offiCode int) returns int deterministic
begin
declare cant_cli int;
select count(*) into cant_cli from offices 
join employees on employees.officeCode=offices.officeCode 
join customers on customers.salesRepEmployeeNumber=employees.employeeNumber 
where offiCode=offices.officeCode;
return cant_cli;
end //
delimiter ;
 select cant_client(2);
 
/*6*/
delimiter //
create function cant_order (offiCode int) returns int deterministic
begin
declare cant_orders int;
select count(orderNumber) into cant_orders from offices 
join employees on employees.officeCode=offices.officeCode 
join customers on customers.salesRepEmployeeNumber=employees.employeeNumber 
join orders on orders.customerNumber=customers.customerNumber
where offiCode=offices.officeCode;
return cant_orders;
end //
delimiter ;

select cant_order(2);

/*7*/
delimiter //
create function profit(order_num int, product_num varchar(15)) returns float deterministic
begin
declare prof float;
select buyPrice-priceEach into prof from products 
join orderdetails on orderdetails.productCode=products.productCode 
where products.productCode=product_num and orderdetails.orderNumber=order_num;
return prof;
end //
delimiter ;

select profit(10100, "S10_1678");

/*8*/

delimiter //
create function ordenesc (numero int) returns int deterministic
begin
declare estado varchar(45);
select orders.status into estado from orders where orderNumber=numero;
	if estado="Cancelled" then return-1;
    else return 0;
	end if;

end //
delimiter ;

select ordenesc(10168);

/*9*/
delimiter //
create function fecha_pri (cliente int) returns date deterministic
begin
	declare fecha date;
    set fecha = (select min(orderDate) from orders where customerNumber=cliente);
    return fecha;
end//
delimiter ;

select fecha_pri(103);

/*11*/
delimiter //
create function last_ord (producto varchar(45)) returns date deterministic
begin
	declare fecha date;
    set fecha= (select max(orderDate) from orders join orderdetails on orderdetails.orderNumber=orders.orderNumber where productCode=producto);
    return fecha;
end//
delimiter ;

select last_ord("S12_1666");

/*12*/
delimiter //
create function precioxd (fecha_inicio date, fecha_fin date, numero varchar(45)) returns float deterministic
begin
declare precio float default 0;
select maxprecio into precio from (select max(priceEach) as maxprecio from orderdetails join orders on orderdetails.orderNumber=orders.ordernumber where productCode=numero and orderDate between fecha_inicio and fecha_fin)as ñonga;
return precio;
end //
delimiter ;

select precioxd("2000-5-6", current_date(), "S10_4757");

select max(priceEach) as maxprecio from orderdetails join orders on orderdetails.orderNumber=orders.ordernumber where productCode="S10_4757" and orderDate between "2000-05-06" and curdate();
/*13*/
delimiter //
create function cant_clie (empleado int) returns int deterministic
begin
	declare cantidad int default 0;
    set cantidad = (select count(*) from customers join employees on employeeNumber=salesRepEmployeeNumber where employeeNumber=empleado);
    return cantidad;
end//
delimiter ;

select cant_clie(1370);	

/*14*/
delimiter //
create function apellido (empleado int) returns varchar(45) deterministic
begin
	declare ap varchar(45) default 0;
    set ap = (select lastName from employees where employeeNumber=empleado);
    return ap;
end//
delimiter ;

select apellido(1370);	


/*15*/
delimiter //
create function boss (emp_num int) returns varchar(20) deterministic
begin
declare emp_num int;
select count(*) into emp_num from employees 
join customers on salesRepEmployeeNumber=employeeNumber
where reportsTo=emp_num;
if emp_num>=20 then
return "Nivel 3";
else if emp_num>=10 and emp_num<20 then
return "Nivel 2";
else
return "Nivel 1";
end if;
end if;
end //
delimiter ;

select boss(1002);

/*16*/
delimiter //
create function intervalo (fecha_inicio date, fecha_fin date) returns int deterministic
begin
declare cant_dias int;
select datediff(fecha_fin,fecha_inicio) into cant_dias;
return cant_dias;
end //
delimiter ;
drop function intervalo;
select intervalo("2000-5-6", current_date());

/*17*/

delimiter //
create function inter_mimami (fecha_inicio date, fecha_fin date) returns int deterministic
begin
declare cant_dias int;
declare cance int;
select datediff(fecha_fin,fecha_inicio) into cant_dias;
if cant_dias>10 then
select count(*) into cance from orders where orderDate between fecha_inicio and fecha_fin;
update orders set status="Cancelled";
return cance;
else
return 0;
end if;
end //
delimiter ;

select inter_mimami("2000-5-6", current_date());
