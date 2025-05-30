delimiter //
/*1*/
create event updatePedidos on schedule every 1 day starts now() do
begin
	update orders set status="Delayed" where current_date()>shippedDate and status="In Process";
end //
/*2*/
create event deletePagos on schedule every 1 month starts now() do
begin
delete from payments where paymentDate<curdate()-interval 5 year;
end//
/*3*/
create procedure extraC()
begin
	update customers 
    set creditLimit=creditLimit+(creditLimit*0.10) 
    where (select count(*) from orders where orderDate>current_date()-interval 1 year)>10;
end //
create event extraCredit on schedule every 1 month starts now() do
begin
	call extraC();
end//
/*4*/


create event checkPagos on schedule every 1 week starts "2025-05-24 7:20:00" do
begin
update orders set status = "Shipped" where status="Pending" and requiredDate<curdate()-interval 7 day;
end//
delimiter ;
/*5*/
create table reports(
	id_report int primary key auto_increment,
    date_report date,
    all_purchases int
);
delimiter //

create event rep on schedule every 1 day starts "2025-05-23 23:59:00" ends current_date()+interval 3 month do
begin
	insert into reports 
    value(null, 
    (select orderDate from orders where orderDate=current_date()), 
    (select count(*) from orderdetails 
    join orders on orders.orderNumber=orderdetails.orderNumber 
    where orderDate=current_date())
    );
end //
/*6*/


create event bajarPreciosRec on schedule every 6 month starts "2025-07-1 00:00:00" do
begin
update products join or derdetails on products.productcode=orderdetails.productcode set buyPrice=buyprice*1.05 where orderdetails not in(select orderdetails from orders where requiredDate<curdate()-interval 1 month);
end//
delimiter ;