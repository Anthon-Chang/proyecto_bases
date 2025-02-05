create role administrador;
create role usuario;
create role auditor;

grant all privileges on libreria.* to administrador;

grant select on libreria.* to usuario;
grant insert on libreria.ventas to usuario;

grant select on libreria.* to auditor;

create user 'administrador_libreria'@'%' identified by '123';
create user 'usuario_libreria'@'%' identified by '456';
create user 'auditor_libreria'@'%' identified by '789';

grant administrador to 'administrador_libreria'@'%';
grant usuario to 'usuario_libreria'@'%';
grant auditor to 'auditor_libreria'@'%';

set default role administrador  to 'administrador_libreria'@'%';
set default role usuario to 'usuario_libreria'@'%';
set default role auditor to 'auditor_libreria'@'%';

set role administrador;
set role usuario;
set role auditor;
