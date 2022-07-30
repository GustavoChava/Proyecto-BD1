--Creamos el usuario para trabajar la conexion de la BD Veterinaria
CREATE USER c##Veterinaria IDENTIFIED BY 123
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users

--Le asignamos una seccion para poder crear la conexion despues
GRANT CREATE SESSION TO c##Veterinaria;

--Concedemos los permisos de crear, editar y elimanr tablas al usuario
GRANT CREATE ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE TO c##Veterinaria;