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
/*10*/
delimiter //
create function cuantosevendiomenos (codigo varchar(45)) returns float deterministic
begin
	declare MRSP_v float default 0;
    declare precio_menor int default 0;
    declare precio_encima int default 0;
    select MSRP into MRSP_v from products where productCode=codigo;
    select count(*) into precio_menor from orderdetails where productCode=codigo and priceEach<MRSP_v;
    select count(*) into precio_encima from orderdetails where productCode=codigo;
    return 100*(precio_menor/precio_encima);
end//
delimiter ;
select cuantosevendiomenos("S18_1749");


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

select intervalo("2000-5-6", current_date());

/*17*/

delimiter //
create function inter_mimami () returns int deterministic
begin
declare cant_dias int;
declare cance int;
select count(*) into cance from orders where intervalo(shippedDate, orderDate)>10;
update orders set status="Cancelled" where intervalo(shippedDate, orderDate)>10;
return cance;
end //
delimiter ;
select inter_mimami();

/*18*/
delimiter //
create function baneado_por_bobina(codigoP varchar(45), codigoO int) returns int deterministic
begin
declare cantidad int;
select sum(quantityOrdered) into cantidad from orderdetails where productCode=codigoP and orderNumber=codigoO;
delete from orderdetails where productCode=codigoP and orderNumber=codigoO;
return cantidad;
end//
delimiter ;
drop function baneado_por_bobina;
select baneado_por_bobina("S18_1749",10100);

/*19*/
delimiter //
create function estoc(codiguillo varchar(15)) returns varchar(20) deterministic
begin
declare estoque int;
select quantityInStock into estoque from products where products.productCode=codiguillo;
if estoque>=5000 then
return "Sobrestock";
else if estoque>=1000 and estoque<5000 then
return "Stock Adecuado";
else
return "Bajo Stock";
end if;
end if;
end//
delimiter ;

select estoc("S10_1678");

/*20*/
delimiter //
create function topacio(ano year) returns varchar(100) deterministic
begin
declare top1 varchar(45);
declare top2 varchar(45);
declare top3 varchar(45);
select productName into top1 from products join orderdetails on orderdetails.productCode=products.productCode join orders on orderdetails.orderNumber=orders.orderNumber where year(orderDate)=ano group by orderdetails.productCode order by count(orderdetails.productCode) desc limit 1;
select productName into top2 from products join orderdetails on orderdetails.productCode=products.productCode join orders on orderdetails.orderNumber=orders.orderNumber where year(orderDate)=ano group by orderdetails.productCode order by count(orderdetails.productCode) desc limit 1 offset 1;
select productName into top3 from products join orderdetails on orderdetails.productCode=products.productCode join orders on orderdetails.orderNumber=orders.orderNumber where year(orderDate)=ano group by orderdetails.productCode order by count(orderdetails.productCode) desc limit 1 offset 2;
return concat(top1,', ',top2,', ',top3);
end//
delimiter ;

select topacio (2003);

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

/*9*/
delimiter //
create procedure getCiudadesOffices(out cities varchar(4000))
	begin
		declare hayFilas boolean default 1;
		declare ciudad varchar(50);
		declare cities_cursor cursor for select distinct(city) from offices;
		declare continue handler for not found set hayFilas = 0;
		set cities="";
		open cities_cursor;
		cities_loop:loop
			fetch cities_cursor into ciudad;
			if hayFilas =0 then
				leave cities_loop;
			end if;
			set cities= concat(ciudad, ", ", cities);
		end loop cities_loop;
		close cities_cursor;
	end//
delimiter ;
call getCiudadesOffices(@tuma);
select @tuma;
/*10*/
delimiter //
create procedure insertCancelledOrders (out ordenesca varchar(4000))
	begin
		declare nome int;
        declare estao varchar(40)default "";
        declare pinga bool default 1;
        declare cursed cursor for select orderNumber, status from orders;
        declare continue handler for not found set pinga=0;
        set ordenesca="";
        open cursed;
        lopez:loop
			fetch cursed into nome, estao;
            if pinga=0
				then leave lopez;
			end if;
            if estao="Cancelled"
				then set ordenesca= concat(nome,", ",ordenesca);
			end if;
        end loop lopez;
        close cursed;
	end//
delimiter ;

call insertCancelledOrders(@ordenescan);
select @ordenescan;

/*11*/
delimiter //
create procedure alterCommentOrder(in cust_num int)
begin
	declare hayFilas boolean default 1;
    declare ord_num int;
    declare comm varchar(50);
    declare total int;
    declare orde cursor for select orderNumber, comments, sum(priceEach*quantityOrdered) from orders 
    join orderDetails on orders.orderNumber=orderdetails.orderNumber 
    where orders.customerNumber=cust_num;
    declare continue handler for not found set hayFilas = 0;
    open orde;
    bucle:loop;
		fetch orde into ord_num, comm, total;
		if hayFilas=0 then
			leave bucle;
		end if;
		if comm is null then
			update orders set comments="El total de la orden es ", total where customerNumber=cust_num;
		end if;
	end loop bucle;
    close orde;
end//
delimiter ;
/*12*/
delimiter //
create procedure nocompran(out tels text)
begin
	declare sino bool default 1;
	declare tel varchar(45)default "";
    declare estado varchar(100);
    declare numero int;
    declare fecha date;
    declare cliente int;
    declare cursedcli cursor for select customers.customerNumber, phone, max(orderDate) from customers join orders on orders.customerNumber=customers.customerNumber group by customers.customerNumber;
    declare continue handler for not found set sino=0;
	open cursedcli;
    set tels="";
    lopacio:loop
		if sino=0
        then leave lopacio;
        end if;
		fetch cursedcli into numero, tel, fecha;
		select status into estado from orders where customerNumber=numero and orderDate=fecha;
        if estado="Cancelled"
			then set tels=concat(tel,", ",tels);
		end if;
    end loop lopacio;
	close cursedcli;
end//
delimiter ;
drop procedure nocompran;
call nocompran(@telefonos);
select @telefonos;
/*13*/
alter table employees add comission varchar(8);
delimiter //
create procedure actualizarComision()
begin
    declare hayFilas boolean default 1;
    declare ventas float;
    declare emp int;
    declare vnet cursor for 
    select sum(priceEach*quantityOrdered), salesRepEmployeeNumber 
    from orderdetails 
    join orders on orderdetails.orderNumber=orders.orderNumber 
    join customers on orders.customerNumber=customers.customerNumber 
    group by salesRepEmployeeNumber;
    declare continue handler for not found set hayFilas = 0;
    open vnet;
    bucle:loop
		fetch vnet into ventas, emp;
        if hayFilas=0 then
			leave bucle;
		end if;
        if ventas>=100000 then
			update employees set comission="5%" where employeeNumber=emp;
		else if ventas<100000 and ventas>50000 then
			update employees set comission="3%" where employeeNumber=emp;
		else if ventas<=50000 then
			update employees set comission="0%" where employeeNumber=emp;
		end if;
        end if;
        end if;
	end loop bucle;
    close vnet;
end//
delimiter ;
/*14*/ no terminado
delimiter //
create procedure asignarEmpleados()
begin
	declare empnum int;
    declare num int;
    declare salnum int;
	declare sino bool default 1;
    declare curs cursor for select customerNumber, salesRepEmployeeNumber from customers;
    declare continue handler for not found set sino=0;
    open curs;
    lop:loop
		if sino=0
			then leave lop;
        end if;
        fetch curs into num, salnum;
		select employeeNumber into empnum from employees join customers on salesRepEmployeeNumber=employeeNumber group by employeeNumber order by count(customerNumber) asc LIMIT 1;
        if isnull(salnum)
        then update customers set salesRepEmployeeNumber=empnum where customerNumber=num;
        end if;
    end loop lop;
    close curs;
end//
delimiter ;