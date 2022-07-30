----------------CREACION DE LA TABLA PROVEEDOR----------------
--Supociciones:
--2-EL GMAIL ES DE TIPO UNIQUE, NO PUEDEN HABER CORREOS REPETIDOS

CREATE TABLE Proveedor(
    IdProveedor    NVARCHAR2(10) NOT NULL,
    NombreEmpresa  NVARCHAR2(40) NOT NULL,
    Encargado      VARCHAR2(25) NOT NULL,
    Gmail          NVARCHAR2(30) UNIQUE,
    Direccion      NVARCHAR2(100) NOT NULL,
    Telefono1      NVARCHAR2(20) NOT NULL UNIQUE,
    Telefono2      NVARCHAR2(20),
    
    CONSTRAINT PK_Proveedor PRIMARY KEY (IdProveedor)
);

DESCRIBE Proveedor;

SELECT * FROM Proveedor;

----------------CREACION DE LA TABLA PRODUCTO----------------
--Supociciones:
--1-El idProducto tendra la estructura 'PDX', donde X = (100 en adelante)
--2-CHECK: el PrecioCompra y PrecioVenta no pueden ser menos que cero (0)
--3-CHECK: El precioVenta tiene que ser >= a PrecioCompra
--Los tipos de Productos: Accesorios, jugetes, medicamento, Alimentos
CREATE TABLE Producto
(
    IdProducto       NVARCHAR2(10) NOT NULL,
    NombreProducto   NVARCHAR2(60) NOT NULL,
    Tipo             VARCHAR2(30) NOT NULL,
    PrecioCompra     NUMBER(10,2) NOT NULL,
    PrecioVenta      NUMBER(10,2) NOT NULL,
    FechaVencimiento DATE,
    
    CONSTRAINT PK_Producto PRIMARY KEY (IdProducto),
    CONSTRAINT CHK_Producto1 CHECK (PrecioVenta > 0),
    CONSTRAINT CHK_Producto2 CHECK (PrecioCompra > 0),
    CONSTRAINT CHK_Producto3 CHECK (PrecioVenta >= PrecioCompra),
    CONSTRAINT CHK_Producto4 CHECK (Tipo IN ('Accesorio', 'Juguete', 'Medicamento', 'Alimento'))
);

DESCRIBE Producto;

SELECT * FROM Producto ORDER BY IdProducto ASC;

----------------CREACION DE LA TABLA EMPLEADO----------------
--Supociciones:
--Tipo de Empleado: Gerente, Veterinario, Vendedor
--El sueldo no puede ser null y menor de 0
CREATE TABLE Empleado(
    DniEmpleado     NVARCHAR2(15) NOT NULL,
    PrimerNombre    VARCHAR2(25) NOT NULL,
    PrimerApellido  VARCHAR2(25) NOT NULL,
    Sueldo          NUMBER(10, 2) NOT NULL,
    Direccion       NVARCHAR2(100) NOT NULL,
    Gmail           NVARCHAR2(30) NOT NULL UNIQUE,
    FechaNacimiento DATE NOT NULL,
    Telefono        NVARCHAR2(20) NOT NULL,
    TipoEmpleado    VARCHAR2(25) NOT NULL,
    
    CONSTRAINT PK_Empleado PRIMARY KEY (DniEmpleado),
    CONSTRAINT CHK_Empleado CHECK (Sueldo > 0)
)

DESCRIBE Empleado;

SELECT * FROM Empleado;

----------------CREACION DE LA TABLA VETERINARIO----------------
--Supociciones:
--1-Tiene una relacion con Tabla Empleado
--2-Titulo: es la especialidad de cada veterinario
CREATE TABLE Veterinario(
    DniVeterinario NVARCHAR2(15) NOT NULL,
    Titulo         NVARCHAR2(50) NOT NULL,
    
    CONSTRAINT FK_Veterinario FOREIGN KEY (DniVeterinario) REFERENCES Empleado(DniEmpleado),
    CONSTRAINT PK_Veterinario PRIMARY KEY (DniVeterinario)
);

DESCRIBE Veterinario;

SELECT * FROM Veterinario;

----------------CREACION DE LA TABLA Compra----------------
--Supociciones:
--1-Tiene una relacion con Tabla Proveedor
--2-Tiene una relacion con Tabla Empleado
--3-Las compras solo pueden ser gestionadas por el Gerente
CREATE TABLE Compra(
    IdCompra    NVARCHAR2(10) NOT NULL,
    IdProveedor NVARCHAR2(10) NOT NULL,
    DniEmpleado NVARCHAR2(15) NOT NULL,
    FechaCompra DATE NOT NULL,
    
    CONSTRAINT PK_Compra PRIMARY KEY (IdCompra),
    CONSTRAINT FK_Compra FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor),
    CONSTRAINT FK_Compra1 FOREIGN KEY (DniEmpleado) REFERENCES Empleado(DniEmpleado)  
);

SELECT * FROM Compra;

----------------CREACION DE LA TABLA Prod_C----------------
--Supociciones:
--1-Tiene una relacion con Tabla Proveedor
--2-Tiene una relacion con Tabla Compra
--3-Tiene un CHECK que la cantidad no puede ser menor a 0
CREATE TABLE Prod_C(
    --n            INT NOT NULL,
    IdCompra     NVARCHAR2(10) NOT NULL,
    IdProducto   NVARCHAR2(10) NOT NULL,
    Cantidad     INT NOT NULL,
    
    --CONSTRAINT PK_Prod_C PRIMARY KEY (n),
    CONSTRAINT FK_Prod_C FOREIGN KEY (IdCompra)REFERENCES Compra(IdCompra),
    CONSTRAINT FK_Prod_C1 FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto),
    CONSTRAINT CHK_Prod_C1 CHECK (Cantidad > 0)
);

SELECT * FROM Prod_C;

----------------CREACION DE LA TABLA Cliente----------------
--Suposicion:
--1-S registra tanto los clientes que comprar productos y los que realizan una consuta
CREATE TABLE Cliente(
    DniCliente   NVARCHAR2(15) NOT NULL,
    PrimerNombre NVARCHAR2(30) NOT NULL,
    Apellido     NVARCHAR2(30) NOT NULL,
    Telefono     NVARCHAR2(20) NOT NULL,
    TipoCliente  NVARCHAR2(30) NOT NULL,
    
    CONSTRAINT PK_Cliente PRIMARY KEY(DniCliente)
);

SELECT * FROM Cliente;

----------------CREACION DE LA TABLA Transaccion----------------
--Supociciones:
--1-Tiene una relacion con Tabla Empleado
--2-Tiene una relacion con Tabla Cliente
CREATE TABLE Transaccion(
    IdVenta     NVARCHAR2(10) NOT NULL,
    DniCliente  NVARCHAR2(15) NOT NULL,
    DniEmpleado NVARCHAR2(30) NOT NULL,
    FechaVenta  DATE NOT NULL,
    ISV         NUMBER(10,2) NOT NULL,
    Descuento   NUMBER(10,2) NOT NULL,
    SubTotal    NUMBER(10,2) NOT NULL,
    Total       NUMBER(10,2) NOT NULL,
    
    CONSTRAINT PK_Transaccion PRIMARY KEY (IdVenta),
    CONSTRAINT FK_Transaccion FOREIGN KEY (DniCliente) REFERENCES Cliente(DniCliente),
    CONSTRAINT FK_Transaccion1 FOREIGN KEY (DniEmpleado) REFERENCES Empleado(DniEmpleado)
);
SELECT * FROM Transaccion;

----------------CREACION DE LA TABLA Detalle_Transaccion----------------
--Supociciones:
--1-Tiene una relacion con Tabla Producto
--2-Tiene una relacion con Tabla Transaccion
CREATE TABLE Detalle_Transaccion(
        --n INT NOT NULL,
        IdVenta    NVARCHAR2(10) NOT NULL,
        IdProducto NVARCHAR2(10) NOT NULL,
        Cantidad   INT NOT NULL,
        
        --CONSTRAINT PK_DT PRIMARY KEY (n),
        CONSTRAINT FK_DT FOREIGN KEY (IdVenta) REFERENCES Transaccion(IdVenta),
        CONSTRAINT FK_DT1 FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);
SELECT * FROM Detalle_Transaccion;

----------------CREACION DE LA TABLA Cliente_VIP----------------
--Supociciones:
--1-Tiene una relacion con Tabla Cliente
--2-Tiene un atributo UNICO que es el email, es único para cada persona 
--3-El atributo mensualidad:es un valor entero entre los valores de  50, 100,150 y 200 

CREATE TABLE Cliente_VIP(
		 DniCliente    NVARCHAR2(15) NOT NULL,
		 Email         NVARCHAR2(30) UNIQUE,
		 Mensualidad   INT NOT NULL,
		 Fecha_Inscrip DATE NOT NULL,
		 Direccion     NVARCHAR2(100) NOT NULL,

         CONSTRAINT PK_CVip PRIMARY KEY (DniCliente),
		 CONSTRAINT FK_CVip FOREIGN KEY (DniCliente) REFERENCES Cliente(DniCliente),
		 CONSTRAINT CHK_CVip CHECK (Mensualidad =50 or Mensualidad=100 or Mensualidad=150 or Mensualidad=200)
);

SELECT * FROM Cliente_VIP;

----------------CREACION DE LA TABLA Mascota----------------
--Supociciones:
--1-Su llave primaria es compuesta
--2-Tiene una relacion con Cliente
--3-El atributo raza tiene un valor defecto de 'Desconocida'
CREATE TABLE Mascota(
		 IdMascota        NVARCHAR2(10) NOT NULL,
		 DniCliente       NVARCHAR2(15) NOT NULL,
		 NombreMascota    NVARCHAR2(15) NOT NULL,
		 Fecha_Nacimiento DATE,
		 Raza             NVARCHAR2(25) DEFAULT 'Desconocida',
		 Peso             NUMBER(10,2),
		 TipoMascota      NVARCHAR2(20) NOT NULL,


         CONSTRAINT PK_Mascota PRIMARY KEY (IdMascota,DniCliente),
		 CONSTRAINT FK_Mascota FOREIGN KEY (DniCliente) REFERENCES Cliente(DniCliente)
);
SELECT * FROM Mascota;

----------------CREACION DE LA TABLA Color_Mascota----------------
--Supociciones:
--1-Su llave primaria es compuesta
--2-Tiene una relacion con la tabla Mascota

CREATE TABLE Color_Mascota(
		 IdMascota  NVARCHAR2(10) NOT NULL,
		 DniCliente NVARCHAR2(15) NOT NULL,
		 Color      NVARCHAR2 (15) NOT NULL,

         CONSTRAINT PK_ColorMascota PRIMARY KEY (IdMascota,DniCliente, Color),
		 CONSTRAINT FK_ColorMascota FOREIGN KEY (IdMascota,DniCliente) REFERENCES Mascota(IdMascota,DniCliente)
);
SELECT * FROM Color_Mascota;

----------------CREACION DE LA TABLA Consulta----------------
--Supociciones:
--1-Tiene relacion con las tablas Mascota y Empleado
--2-Tiene una llave foránea que es compuesta
--3-El atributo ValorConsulta es un valor fijo de 150

CREATE TABLE Consulta(
		 IdConsulta     NVARCHAR2(10) NOT NULL,
		 DniVeterinario NVARCHAR2(15) NOT NULL,
		 IdMascota      NVARCHAR2(10) NOT NULL,
		 DniCliente     NVARCHAR2(15) NOT NULL,
		 Sintoma        NVARCHAR2(70) NOT NULL,
         Diagnostico    NVARCHAR2(50) NOT NULL,
         Fecha          DATE NOT NULL,
         Hora           NVARCHAR2(6),
         ValorConsulta  INT DEFAULT 150,
    
         CONSTRAINT PK_Consulta PRIMARY KEY (IdConsulta),
         CONSTRAINT FK_Consulta1 FOREIGN KEY (DniVeterinario) REFERENCES Empleado(DniEmpleado),
         CONSTRAINT FK_Consulta2 FOREIGN KEY (IdMascota, DniCliente) REFERENCES Mascota(IdMascota, DniCliente),
         CONSTRAINT CHK_Consulta CHECK (ValorConsulta=150)
);
--ALTER TABLE Consulta modify Hora NVARCHAR2(10);
SELECT * FROM Consulta;

----------------CREACION DE LA TABLA Detalle_Consulta----------------
--Supociciones:
--1-Tiene relacion con las tablas Consulta y Transaccion

CREATE TABLE Detalle_Consulta(
		 IdVenta  NVARCHAR2(10) NOT NULL,
		 IdConsulta  NVARCHAR2(10) NOT NULL,

		 CONSTRAINT FK_DConsulta1 FOREIGN KEY (IdVenta) REFERENCES Transaccion(IdVenta),
		 CONSTRAINT FK_DConsulta2 FOREIGN KEY (IdConsulta) REFERENCES Consulta(IdConsulta)
);

SELECT * FROM Detalle_Consulta;


