create database libreria;
use libreria;

create table clientes(
	id_cliente int auto_increment primary key,
    nombre varchar (50) not null,
    email varchar (50) unique,
    telefono varchar (10),
    direccion text
)auto_increment = 100;

create table autores(
	id_autor int auto_increment primary key,
    nombre varchar (50) not null,
    nacionalidad varchar (15) not null,
    fecha_nacimiento date
)auto_increment = 200;

create table libros(
	id_libro int auto_increment primary key,
    titulo varchar (50) not null,
    genero varchar (50) not null,
    precio decimal (4,2) not null,
    id_autor int,
    stock int default 0,
    foreign key (id_autor) references autores (id_autor)
    on update cascade -- si se actualiza el autor se cambia sus libros
    on delete cascade -- si se elimina el autor se elminan sus libros
)auto_increment = 300;

create table ventas(
	id_venta int auto_increment primary key,
    id_cliente int,
    id_libro int,
    fecha_venta date not null,
    cantidad int not null,
    total decimal (5,2),
    foreign key (id_cliente) references clientes (id_cliente)
    on delete set null -- si un cliente se elimina se deja el valor en null en la tabla ventas
    on update cascade, -- si se cambia el cliente se actualiza en la tabla ventas
    foreign key (id_libro) references libros (id_libro)
    on delete restrict -- no se permite eliminar libros si tiene ventas asociadas
    on update cascade -- si se cambia el libro cambia en la tabla ventas tambien
) auto_increment = 400;

create table reservas (
    id_reserva int auto_increment primary key,
    id_cliente int,
    id_libro int,
    fecha_reserva date not null,
    cantidad int not null,
    estado enum('Pendiente', 'Confirmada', 'Cancelada') default 'Pendiente',
    foreign key (id_cliente) references clientes (id_cliente)
    on delete set null -- si un cliente es eliminado, dejar nulo el valor en la reserva
    on update cascade, -- si se actualiza el cliente, reflejarlo en la tabla reservas
    foreign key (id_libro) references libros (id_libro)
    on delete restrict -- no se puede eliminar el libro si tiene reservas asociadas
    on update cascade -- si se actualiza el libro, reflejarlo en la tabla reservas
) auto_increment = 500;

create table auditoria (
    id_auditoria int auto_increment primary key,
    nombre_tabla varchar(50) not null,
    tipo_accion varchar(10) not null, -- 'INSERT', 'UPDATE', 'DELETE'
    id_registro int not null,
    fecha_accion datetime not null,
    cambios text
);