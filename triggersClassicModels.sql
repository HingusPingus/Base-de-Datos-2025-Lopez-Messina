/*1*/
create table customers_audit 
(IdAudit int auto_increment not null primary key, 
operacion varchar(6),
user text,
last_date_modified date,
customer_number int,
customer_name varchar(50),
customer_phone varchar(50)
);

delimiter //
create trigger after_insert_customers after insert on customers for each row
begin
insert into customers_audit values(null,"Insert",current_user(),curdate(),new.customerNumber,new.customerName, new.phone);
end//

create trigger before_update_customers before update on customers for each row
begin
insert into customers_audit values(null,"Update",current_user(),curdate(),old.customerNumber,old.customerName, old.phone);
end//

create trigger before_delete_customers before delete on customers for each row
begin
insert into customers_audit values(null,"Delete",current_user(),curdate(),old.customerNumber,old.customerName, old.phone);
end//
delimiter ;

insert into customers values(484838,"Carlos","asasfas","asfsfasf","43534534","ffffefsef","asfsdfdsf","dsfdsdsgs","sdfsgdsg","asffdsdsf","sfdsfsfdsf",1002,6);
update customers set customerName="Carlitos" where customerNumber=484838; 
delete from customers where customerNumber=484838;
select * from customers_audit;

/*2*/
create table employee_audit(
IdAudit int auto_increment not null primary key, 
operacion varchar(6),
user text,
last_date_modified date,
employeeNumber int,
officeCode varchar(10),
reportsTo int
);

delimiter //
create trigger after_insert_employee after insert on employees
for each row
begin
	insert into employee_audit values(null,"Insert",current_user(),curdate(),new.employeeNumber,new.officeCode, new.reportsTo);
end//

create trigger before_update_employee before update on employees
for each row
begin
	insert into employee_audit values(null,"Update",current_user(),curdate(),old.employeeNumber,old.officeCode, old.reportsTo);
end//

create trigger before_delete_employee before delete on employees
for each row
begin
	insert into employee_audit values(null,"Delete",current_user(),curdate(),old.employeeNumber,old.officeCode, old.reportsTo);
end//
delimiter ;

insert into employees values(1234, "fbhgh", "bgjss vd", "aaaa", "afsaa", "4", 1056, "gnaubgduoa", "nigadn");
update employees set firstName="pepe" where employeeNumber=1002;
delete from employees where employeeNumber=1002;
select * from employee_audit;

/*3*/
delimiter //
create trigger before_delete_product before delete on products
for each row
begin
	declare v1 date;
	if(select orderDate into v1 from orderdetails join orders on orders.orderNumber=orderdetails.orderNumber where orderdetails.productCode=old.productCode and
		orderdetails.orderDate<current_date()-interval 2 Month) then
			SIGNAL SQLSTATE "45000" set message_text="Error de fecha.";
	end if;
end //
delimiter ;

delete