/*stored procedures*/

/*1*/
delimiter //
create procedure show_prices(out cant int)
begin
set cant =(select count(*) from products where buyPrice>(select avg(buyPrice) from products));
select * from products where buyPrice>(select avg(buyPrice) from products);
end //
delimiter ;

call show_prices(@a);
select @a;

/*2*/
delimiter //
create procedure borrarOrden (in orden int)
begin
select count(*) from orderdetails where orderNumber=orden;
delete from orderdetails where orderNumber=orden;
delete from orders where orderNumber=orden;
end//
delimiter ;

call borrarOrden(10101);

/*3*/
delimiter //
create procedure delete_line(in code_line varchar(20))
begin
	set var =(select stock(code_line));
    if var=0 then
		delete from productlines where code_line=productLine;
        select "La línea de productos fue borrada";
	else
		select "La línea de productos no pudo borrarse porque contiene productos asociados";
	end if;
end //
delimiter ;

/*4*/
delimiter //
create procedure ordenxestado ()
begin
select count(*) from orders group by status;
end//
delimiter ;

call ordenxestado();

/*5*/
delimiter //
create procedure falopa(in emp_num int)
begin
select reportsTo, count(*) from employees group by (reportsTo);
end//
delimiter ;

/*6*/
delimiter //
create procedure ordenxprecio ()
begin
select orderNumber, sum(quantityOrdered*priceEach) from orderdetails group by orderNumber;
end//
delimiter ;

call ordenxprecio();

/*7*/
delimiter //
create procedure client_things()
begin
select customers.customerNumber, customerName, orders.orderNumber, sum(priceEach*quantityOrdered) from customers join orders on orders.customerNumber=customers.customerNumber join orderdetails on orders.orderNumber=orderdetails.orderNumber group by customerName, orderNumber;
end//
delimiter ;
drop procedure client_things;
call client_things();

/*8*/
delimiter //
create procedure clientecomenta(in numerazo int, in comentazo varchar(200),out sino int)
begin
declare comprobacion varchar(100);
select comments into comprobacion from orders where orderNumber=numerazo;
if isnull(comprobacion)
then set sino=0;
else update orders set comments=comentazo where orderNumber=numerazo;
set sino=1;
end if;
end//
delimiter ;
drop procedure clientecomenta;
call clientecomenta(10107,"hola como va",@sino);
select @sino;
