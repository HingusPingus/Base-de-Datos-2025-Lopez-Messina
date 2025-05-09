delimiter //
create procedure ingresarStock ()
begin
	declare hayFilas boolean default 1;
    declare cant int;
    declare cod int;
    declare stockCursor cursor for select sum(cantidad), Producto_codProducto from ingresostock_producto 
    join ingresostock on IngresoStock_idIngreso=idIngreso where fecha >curdate() - interval 1 week
    group by Producto_codProducto;
    declare continue handler for not found set hayFilas = 0;
	open stockCursor;
    loop1:loop
		fetch stockCursor into cant, cod;
        if hayFilas=0 then
			leave loop1;
        end if;
        update producto set stock=stock+cant where codProducto=cod;
        
	end loop loop1;
	close stockCursor;
end//
delimiter ;

call ingresarStock();

/*2*/
delimiter //
create procedure bajarPrecio ()
begin
	declare hayFilas boolean default 1;
    declare pre int;
    declare cod int;
    declare stockCursor cursor for select precio*0.1, codProducto from ingresostock_producto 
    join ingresostock on IngresoStock_idIngreso=idIngreso join producto on Producto_codProducto=codProducto 
    where fecha >curdate() - interval 1 week and (select sum(cantidad) from producto group by codProducto)<100
    group by codProducto;
    declare continue handler for not found set hayFilas = 0;
	open stockCursor;
    loop1:loop
		fetch stockCursor into pre, cod;
        if hayFilas=0 then
			leave loop1;
        end if;
        update producto set precio=precio-pre where codProducto=cod;
        
	end loop loop1;
	close stockCursor;
end//
delimiter ;
drop procedure bajarPrecio;
call bajarPrecio()

/*3*/
delimiter //
create procedure subirPrecio ()
begin
	declare hayFilas boolean default 1;
    declare cod int;
    declare pre1 int;
    
    declare stockCursor cursor for 
    select Producto_codProducto, max(producto_proveedor.precio) 	
    from producto_proveedor group by Producto_codProducto;
    
    declare continue handler for not found set hayFilas = 0;
	open stockCursor;
    loop1:loop
		fetch stockCursor into cod, pre1;
        if hayFilas=0 then
			leave loop1;
        end if;
        update producto set precio=pre1+pre1*0.1 where codProducto=cod;
        
	end loop loop1;
	close stockCursor;
end//
delimiter ;

call subirPrecio();

/*4*/
delimiter //
create procedure nivelado ()
begin
	declare hayFilas boolean default 1;
    declare cod int;
    declare cant int;
    
    declare stockCursor cursor for 
    select Proveedor_idProveedor, sum(cantidad)
    from ingresostock_producto join ingresostock on IngresoStock_idIngreso=idIngreso
    where fecha>curdate()- interval 2 month
    group by Proveedor_idProveedor;
    declare continue handler for not found set hayFilas = 0;
	open stockCursor;
    loop1:loop
		fetch stockCursor into cod, cant;
        if hayFilas=0 then
			leave loop1;
        end if;
		if cant<=50
			then update proveedor set nivel="Bronce" where idProveedor=cod;
		else if cant>50 and cant<=100
			then update proveedor set nivel="Plata" where idProveedor=cod;
		else if cant>100
			then update proveedor set nivel="Oro" where idProveedor=cod;
		end if; end if; end if;
	end loop loop1;
	close stockCursor;
end//
delimiter ;
drop procedure nivelado;
call nivelado();

/*5*/
delimiter //
create procedure subirPrecio ()
begin
	declare hayFilas boolean default 1;
    declare cod int;
    declare pre int;
    declare est int;
    
    declare stockCursor cursor for 
    select Producto_codProducto, producto.precio, Estado_idEstado
    from producto join pedido_producto on Producto_codProducto=codProducto 
    join pedido on idPedido=Pedido_idPedido;
    
    declare continue handler for not found set hayFilas = 0;
	open stockCursor;
    loop1:loop
		fetch stockCursor into cod, pre, est;
        if hayFilas=0 then
			leave loop1;
        end if;
        if est=2 then
        update pedido_producto set precioUnitario=pre where Producto_codProducto=cod;
        end if;
        
	end loop loop1;
	close stockCursor;
end//
delimiter ;