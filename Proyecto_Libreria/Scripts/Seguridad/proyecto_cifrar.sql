use libreria;

alter table clientes add column contraseña varbinary(255);

-- CIFRAR
insert into clientes (nombre, email, telefono, direccion, contrasena)
values (
    'Juan Pérez', 'juan@example.com', '1234567890', 'Calle Falsa 123',
    AES_ENCRYPT('contraseña', 'proyecto')
);

-- DESCIFRAR
select 
    id_cliente, 
    nombre, 
    email, 
    telefono, 
    direccion, 
    AES_DECRYPT(contrasena, 'proyecto') as contrasena_descifrada
from clientes
where id_cliente = 100;

alter table ventas add column detalle_pago varbinary(255);

insert into ventas (id_cliente, id_libro, fecha_venta, cantidad, total, detalles_pago)
values (
    100, 300, '2023-10-01', 2, 25.50,
    AES_ENCRYPT('{"tarjeta":"1234-5678-9012-3456","exp":"12/25"}', 'llave_secreta')
);

select 
    id_venta, 
    id_cliente, 
    id_libro, 
    fecha_venta, 
    cantidad, 
    total, 
    AES_DECRYPT(detalles_pago, 'llave_secreta') as detalles_pago_descifrados
from ventas
where id_venta = 400;



