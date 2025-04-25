delimiter //
/*1*/
create trigger after_insert_products after insert on pedido_producto for each row
begin
update ingresostock_producto set cantidad=cantidad-new.cantidad where Producto_codProducto=new.producto_codProducto;
end//
/*2*/
create trigger before_delete_ingresostock before delete on ingresostock for each row
begin
delete from ingresostock_producto where ingresoStock_idIngreso=old.idIngreso;
end//
delimiter ;

insert into pedido_producto values(5,10,3.00,1,3);
delete from ingresostock where idIngreso=1;

/*3*/
delimiter //
create trigger after_insert_pedido after insert on pedido
for each row
begin
	declare v1 int;
	select sum(pedido_producto.cantidad*pedido_producto.precioUnitario) into v1 from pedido_producto 
    join pedido on Pedido_idPedido=idPedido where Cliente_codCliente=new.Cliente_codCliente 
    and fecha< current_date()-interval 2 year;
    if v1<=50000 then
		/*update bronce*/
	if v1>50000 and v1<=100000 then
		/*update plata*/
	if v1>100000 then
		/*update oro*/
	end if;
    end if;
    end if;
end //
delimiter ;

/*4*/
delimiter //
	create trigger after_insert_ingresostock_producto after insert on ingresostock_producto
    for each row
    begin
		update producto set stock=stock+new.cantidad where Producto_codProducto=codProducto;
	end //
delimiter ;

/*5*/
delimiter //
create trigger before_delete_producto before delete on producto for each row
begin
	delete from producto_proveedor where Producto_codProducto=old.codProducto;
    delete from pedido_producto where Producto_codProducto=old.codProducto;
    delete from ingresostock_producto where Producto_codProducto=old.codProducto;
    delete from producto_ubicacion where Producto_codProducto=old.codProducto;
end//
delimiter ;
delete from producto;