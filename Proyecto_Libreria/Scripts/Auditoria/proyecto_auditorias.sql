 -- Procedimientos Almacenados, Vistas y Triggers
delimiter $$

create procedure calcular_precio_venta (
    IN p_id_venta int,         -- ID de la venta
    IN p_descuento decimal(5,2), -- Porcentaje de descuento (ej. 10.00 para 10%)
    IN p_cargo decimal(5,2)     -- Porcentaje de cargo adicional (ej. 5.00 para 5%)
)
begin
    declare precio_libro decimal(4,2);  -- Precio del libro asociado a la venta
    declare cantidad int;               -- Cantidad de libros en la venta
    declare subtotal decimal(10,2);     -- Subtotal sin descuentos ni cargos
    declare precio_total decimal(10,2); -- Precio total calculado

    -- Obtener el precio del libro y la cantidad vendida
    select l.precio, v.cantidad
    into precio_libro, cantidad
    from ventas v
    join libros l on v.id_libro = l.id_libro
    where v.id_venta = p_id_venta;

    -- Calcular el subtotal
    set subtotal = precio_libro * cantidad;

    -- Calcular el precio total aplicando descuento y cargo adicional
    set precio_total = subtotal - (subtotal * p_descuento / 100) + (subtotal * p_cargo / 100);

    -- Actualizar el precio total en la tabla de ventas
    update ventas
    set total = precio_total
    where id_venta = p_id_venta;

end $$

delimiter ;
call calcular_precio_venta(410, 10.00, 5.00);
select * from ventas;

--  combina las tablas ventas, clientes y libros
create view vista_ventas_clientes_libros as
select
    v.id_venta,
    c.nombre as cliente,
    l.titulo as libro,
    v.cantidad,
    v.total,
    v.fecha_venta
from ventas v
join clientes c on v.id_cliente = c.id_cliente
join libros l on v.id_libro = l.id_libro;

select * from vista_ventas_clientes_libros;

-- tiggers para las tablas reservas y ventas
delimiter $$

create trigger auditoria_update_reservas
after update on reservas
for each row
begin
    insert into auditoria (nombre_tabla, tipo_accion, id_registro, fecha_accion, cambios)
    values ('reservas', 'UPDATE', old.id_reserva, now(), 
        concat('Fecha antigua: ', old.fecha_reserva, ', Fecha nueva: ', new.fecha_reserva, 
               ', Cliente antiguo: ', old.id_cliente, ', Cliente nuevo: ', new.id_cliente));
end $$

delimiter ;
delimiter $$

create trigger auditoria_delete_reservas
after delete on reservas
for each row
begin
    insert into auditoria (nombre_tabla, tipo_accion, id_registro, fecha_accion, cambios)
    values ('reservas', 'DELETE', old.id_reserva, now(), 
        concat('Fecha: ', old.fecha_reserva, ', Cliente: ', old.id_cliente));
end $$

delimiter ;
delimiter $$

create trigger auditoria_update_ventas
after update on ventas
for each row
begin
    insert into auditoria (nombre_tabla, tipo_accion, id_registro, fecha_accion, cambios)
    values ('ventas', 'UPDATE', old.id_venta, now(), 
        concat('Cantidad antigua: ', old.cantidad, ', Cantidad nueva: ', new.cantidad, 
               ', Total antiguo: ', old.total, ', Total nuevo: ', new.total));
end $$

delimiter ;
delimiter $$

create trigger auditoria_delete_ventas
after delete on ventas
for each row
begin
    insert into auditoria (nombre_tabla, tipo_accion, id_registro, fecha_accion, cambios)
    values ('ventas', 'DELETE', old.id_venta, now(), 
        concat('Cantidad: ', old.cantidad, ', Total: ', old.total));
end $$

delimiter ;

UPDATE reservas
SET 
    fecha_reserva = '2025-02-01', 
    id_cliente = 102
WHERE id_reserva = 502;

select * from auditoria ;