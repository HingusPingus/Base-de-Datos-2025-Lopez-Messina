
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
    where orders.customerNumber=cust_num group by orders.orderNumber;
    declare continue handler for not found set hayFilas = 0;
    open orde;
    bucle:loop;
		fetch orde into ord_num, comm, total;
		if hayFilas=0 then
			leave bucle;
		end if;
		if comm is null then
			update orders set comments=concat("El total de la orden es ", total) where ord_num=cust_num;
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
/*14*/
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
call asignarEmpleados();
