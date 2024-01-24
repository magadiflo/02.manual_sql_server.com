/*-- PARTICIONAR HORIZONTALMENTE UNA TABLA EXISTENTE --*/
/*
La partición de las tablas es una práctica que permite aumentar la 
eficiencia en el almacenamiento de la información cuando se trata de 
tablas grandes, si la tabla grande tiene muchos campos y algunos de 
estos ocupan mas espacio como los de imágenes, lo que se recomienda 
una partición vertical , por otro lado si la tabla tie nemuchos registros 
se recomienda una partición horizontal.

En este artículo se explica como particionar de manera horizontal una 
tabla ya creada para lo que vamos a crear una tabla de clientes y copiar 
los existentes en la tabla Customers de la base de datos Northwind. 
Al crear las tablas se puede particionar de manera horizontal 
(Ver partición Horizontal de tablas) o de manera Vertical 
(Ver partición vertical de tablas).
*/

/* PARTICIONANDO UNA TABLA EXISTENTE */
/*Primero crear una base de datos con más de un grupo de archivos, 
se recomienda el uso de varios discos.
Para este ejemplo se ha trabajado solamente en la unidad C:*/
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\DATOS'
GO

CREATE DATABASE bd_particionando
ON PRIMARY
(NAME='Parte01', FILENAME='C:\BD_SQL_SERVER\DATOS\Parte01.mdf'),
FILEGROUP COMERCIAL
(NAME='Comercial01', FILENAME='C:\BD_SQL_SERVER\DATOS\Comercial01.ndf'),
FILEGROUP RECURSOS
(NAME='Recu01', FILENAME='C:\BD_SQL_SERVER\DATOS\Recu01.ndf'),
FILEGROUP CONTABLE
(NAME='Contab01', FILENAME='C:\BD_SQL_SERVER\DATOS\Contab01.ndf')
LOG ON
(NAME='Log101', FILENAME='C:\BD_SQL_SERVER\DATOS\Log101.ldf')
GO

USE bd_particionando
GO

--Crear la tabla clientes sin particionar
CREATE TABLE clientes(
	codigo CHAR(5),
	razon_social VARCHAR(100) NOT NULL,
	direccion VARCHAR(100),
	pais VARCHAR(50),
	contacto VARCHAR(100),
	fecha_registro DATE,
	telefono VARCHAR(30),
	CONSTRAINT pk_clientes PRIMARY KEY(codigo)
)
GO

--Insertar los registros de la tabla Customers de Northwind
INSERT INTO clientes
SELECT c.CustomerID, c.CompanyName, c.Address, c.Country, 
	   c.ContactName, GETDATE(), c.Phone
FROM Northwind.dbo.Customers AS c
GO

--Listar los datos de los clientes
SELECT * FROM clientes
GO

--En las propiedades de la tabla opción almacenamiento(storage) 
--notar que no está particionada. Debería decir: 
--Table is partitioned	False

/*Para particionar la tabla se necesita crear una función de partición,
un esquema de partición y luego eliminar el índice principal o 
Primary Key y luego crear el índice particionado.
*/

--Crear la función de partición
CREATE PARTITION FUNCTION fp_clientes(CHAR(5))
AS RANGE FOR VALUES('E', 'J', 'P', 'U')
GO

--Crear el esquema de partición
CREATE PARTITION SCHEME schp_clientes
AS PARTITION fp_clientes
TO([Primary], CONTABLE, RECURSOS, RECURSOS, COMERCIAL)
GO

/*Para particionar la tabla existente se debe eliminar el índice de la PK,
para esto se debe eliminar la restricción de tipo Primary Key y
crear un índice particonado
*/
--Eliminado el índice de la pk de clientes
ALTER TABLE clientes
DROP CONSTRAINT pk_clientes
GO

--Creando el índice particionado en base al esquema schp_clientes
CREATE CLUSTERED INDEX pk_clientes
ON clientes(codigo)
ON schp_clientes(codigo)
GO

--En las propiedades de la tabla se puede notar que ahora sí está particionada

/*Ver los clientes y la distribución de los mismos en las particiones
NOTA: La función $PARTITION muestra la partición a la que pertenece
cada cliente
*/
SELECT c.codigo, c.razon_social, 
	   $PARTITION.fp_clientes(c.codigo) AS 'Partición'
FROM clientes AS c
GO

/*VER LA DISTRIBUCIÓN EN LAS PARTICIONES*/
--El script siguiente muestra la distribución de los registros en las diferentes
--particiones
SELECT t.name AS 'Tabla', i.name AS 'Índice', 
	   p.partition_number AS 'N° Partición', 
	   r.value AS 'Límite', p.rows AS 'Cantidad de registros'
FROM SYS.TABLES AS t
	--Relación de tablas con índices
	INNER JOIN SYS.INDEXES AS i ON(t.object_id = i.object_id)
	--Relación entre particiones e índices
	INNER JOIN SYS.PARTITIONS AS p ON(i.object_id = p.object_id AND i.index_id = p.index_id)
	--Relación entre esquemas de partición e índices
	INNER JOIN SYS.PARTITION_SCHEMES AS s ON(i.data_space_id = s.data_space_id)
	--Felación entre funciones de partición y esquemas de partición
	INNER JOIN SYS.partition_functions AS f ON(s.function_id = f.function_id)
	--Relación rangos de particiones con funciones de partición
	LEFT JOIN SYS.PARTITION_RANGE_VALUES AS r ON(f.function_id = r.function_id AND r.boundary_id = p.partition_number)
	WHERE t.name = 'clientes' AND i.type <= 1
	ORDER BY p.partition_number
GO


/*IMPORTANTE: 
Las particiones de la tabla deberían estar en diferentes discos para 
optimizar las consultas. 
En los grupos de archivos donde se han direccionado las particiones 
deberían tener más de un archivo. 
Los tamaños de los archivos donde se almacenan los datos de las tablas
particionadas deberían ser grandes.
*/