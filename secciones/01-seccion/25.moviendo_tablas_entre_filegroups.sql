/*-- MOVIENDO TABLAS ENTRE FILEGROUPS --*/
/*
Una base de datos en SQL Server se puede crear con varios archivos donde se guarda la 
información de las tablas, estos archivos se agrupan en Grupos de archivos llamados Filegroups, 
cada grupo de archivos puede tener archivos ubicados en diferentes discos y en diferentes carpetas, 
el objetivo es que la información de las tablas se almacene en archivos diferentes lo que puede 
optimizar la distribución de la información guardada en la base de datos.
*/

/*
En este artículo se va a crear una base de datos y las tablas en determinados grupos,
luego se va a mover las tablas a grupos diferentes.
*/

/*EJERCICIO 01. Crear la base de datos bd_ferreteria, esta se va a crear en las unidades: C y D,
y al momento de crearla se va a crear adicional al grupo de archivos Primary, 
dos grupos: COMERCIAL y LOGISTICA.*/
XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\BASES'
GO

XP_CREATE_SUBDIR 'D:\BD_SQL_SERVER\BASES'
GO

DROP DATABASE IF EXISTS bd_ferreteria
GO

CREATE DATABASE bd_ferreteria
ON PRIMARY
(NAME='F01',FILENAME='C:\BD_SQL_SERVER\BASES\F01.mdf'),
FILEGROUP COMERCIAL
(NAME='bd_ferreteria_comercial_01', FILENAME='D:\BD_SQL_SERVER\BASES\bd_ferreteria_comercial_01.ndf'),
FILEGROUP LOGISTICA
(NAME='F04', FILENAME='D:\BD_SQL_SERVER\BASES\F04.ndf'),
(NAME='F05', FILENAME='D:\BD_SQL_SERVER\BASES\F05.ndf')
LOG ON
(NAME='bd_ferreteria_log_01', FILENAME='D:\BD_SQL_SERVER\BASES\bd_ferreteria_log_01.ldf')
GO
--Luego de crearse la BD, verificar que los archivos se hayan creado en las rutas especificadas

USE bd_ferreteria
GO

/*EJERCICIO 02. Crear la tabla categorias en el filegroup COMERCIAL, pero esta tabla
debe estar ubicado en el esquema ventas*/

-- PRIMERO: creamos el esquema ventas
--Se puede crear de esta forma el esquema, aquí preguntando previamente si no existe
/*
IF NOT EXISTS(SELECT * FROM SYS.SCHEMAS WHERE name = 'ventas')
	EXECUTE('CREATE SCHEMA ventas')
GO
*/
--O, se puede crear sin preguntar
CREATE SCHEMA ventas
GO

-- SEGUNDO: creamos la tabla asociándolo al esquema ventas y colocándolo en grupo COMERCIAL
CREATE TABLE ventas.categorias(
	codigo CHAR(7),
	descripcion VARCHAR(100) NOT NULL,
	fecha_creacion DATE CONSTRAINT df_fecha_creacion_cat DEFAULT GETDATE(),
	estado CHAR(1) CONSTRAINT df_estado_cat DEFAULT 'A',
	CONSTRAINT pk_categorias PRIMARY KEY(codigo),
	CONSTRAINT uq_descripcion_cat UNIQUE(descripcion),
	CONSTRAINT ck_fecha_creacion_cat CHECK(fecha_creacion <= GETDATE()),
	CONSTRAINT ck_estado_cat CHECK(estado = 'A' OR estado = 'E')
) ON COMERCIAL
GO

/*EJERCICIO 03. Crear la tabla productos en el filegroup COMERCIAL y en el esquema ventas.
Note que al final de la definición de la tabla se incluye ON COMERCIAL*/

CREATE TABLE ventas.productos(
	codigo CHAR(10),
	categoria_codigo CHAR(7),
	descripcion VARCHAR(80) NOT NULL,
	fecha_creacion DATE CONSTRAINT df_fecha_creacion_prod DEFAULT GETDATE(),
	estado CHAR(1) CONSTRAINT df_estado_prod DEFAULT 'A',
	stock NUMERIC(9,2) CONSTRAINT df_stock_prod DEFAULT 0,
	precio NUMERIC(9,2) CONSTRAINT df_precio_prod DEFAULT 0,
	CONSTRAINT pk_productos PRIMARY KEY(codigo),
	CONSTRAINT fk_categorias_productos FOREIGN KEY(categoria_codigo) REFERENCES ventas.categorias(codigo),
	CONSTRAINT uq_descripcion_prod UNIQUE(descripcion),
	CONSTRAINT ck_fecha_creacion_prod CHECK(fecha_creacion <= GETDATE()),
	CONSTRAINT ck_estado_prod CHECK(estado IN('A', 'E', 'D')),
	CONSTRAINT ck_stock_prod CHECK(stock >= 0),
	CONSTRAINT ck_precio_prod CHECK(precio >= 0)
) ON COMERCIAL
GO

/*EJERCICIO 04. Crear la tabla cliente, esta se va a crear en el grupo PRIMARY, note que 
al final de la definición de la tabla no se ha especificado un grupo, por lo que 
se crea en PRIMARY
*/
CREATE TABLE clientes(
	codigo CHAR(7),
	razon_social VARCHAR(100) NOT NULL,
	fecha_registro DATE CONSTRAINT df_fecha_registro_cli DEFAULT GETDATE(),
	ruc CHAR(11),
	estado CHAR(1) CONSTRAINT df_estado_cli DEFAULT 'A',
	CONSTRAINT pk_clientes PRIMARY KEY(codigo),
	CONSTRAINT uq_ruc_cli UNIQUE(ruc),
	CONSTRAINT uq_razon_social_cli UNIQUE(razon_social)
)
GO

/*EJERCICIO 05. Crear la tabla facturas en el grupo PRIMARY, note que al final
de la definición de la tabla no se ha especificado un grupo, por lo que se creará
en PRIMARY
*/
CREATE TABLE facturas(
	serie CHAR(3),
	numero CHAR(7),
	fecha DATETIME,
	subtotal NUMERIC(9,2),
	valor_porcentaje_igv NUMERIC(9,4),
	monto_igv AS (subtotal * valor_porcentaje_igv),
	total AS (subtotal + subtotal * valor_porcentaje_igv),
	cliente_codigo CHAR(7),
	razon_social VARCHAR(100) NOT NULL,
	ruc CHAR(11),
	CONSTRAINT pk_facturas PRIMARY KEY(serie, numero),
	CONSTRAINT fk_clientes_facturas FOREIGN KEY(cliente_codigo) REFERENCES clientes(codigo)
)
GO

/*EJERCICIO 06. Crear la tabla detalle_facturas en el filegroup LOGISTICA. Note que al final
de la definición de la tabla se incluye ON LOGISTICA. 
Esta tabla se va a usar como ejemplo para mover al otro grupo. 
*/
CREATE TABLE detalle_facturas(
	factura_serie CHAR(3),
	factura_numero CHAR(7),
	producto_codigo CHAR(10),
	descripcion VARCHAR(80) NOT NULL,
	cantidad NUMERIC(19,2),
	precio_venta NUMERIC(9,2),
	importe AS (cantidad * precio_venta),
	CONSTRAINT pk_detalle_facturas PRIMARY KEY(factura_serie, factura_numero, producto_codigo),
	CONSTRAINT fk_facturas_detalle_facturas FOREIGN KEY(factura_serie, factura_numero) REFERENCES facturas(serie, numero),
	CONSTRAINT fk_productos_detalle_facturas FOREIGN KEY(producto_codigo) REFERENCES ventas.productos(codigo)
)ON LOGISTICA
GO

/* GRUPOS Y TABLAS
Para visualizar los grupos de archivos y sus tablas se va a consultar las vistas del 
sistema SYS.TABLES que contienen las tablas de la base de datos. SYS.INDEXES contiene los
índices de la base de datos y SYS.FILEGROUPS contiene los grupos de archivos de la base de datos
*/
SELECT * FROM SYS.TABLES
SELECT * FROM SYS.INDEXES
SELECT * FROM SYS.FILEGROUPS
GO

-- Para la lista de tablas y grupos a las que pertenecen
SELECT t.name AS tabla, g.name AS [grupo de archivos]
FROM SYS.TABLES AS t
	INNER JOIN SYS.INDEXES AS i ON(i.object_id = t.object_id) AND i.index_id <= 1 --1 indica PK
	LEFT JOIN SYS.FILEGROUPS AS g ON(g.data_space_id = i.data_space_id)
WHERE t.lob_data_space_id = 0 --Para las tablas que almacenan datos
--ORDER BY [Grupo de archivos], tabla
GO

/* Mover la tabla detalle_facturas del grupo LOGISTICA al grupo COMERCIAL 

Para mover una tabla de un grupo de archivos a otro, se puede proceder de dos formas:
PRIMERA FORMA. Se debe cambiar el índice agrupado, se elimina la restricción de tipo PK 
   moviéndola al nuevo grupo, luego se crea la PK nuevamente.
SEGUNDA FORMA. Crear el índice agrupado (Clustered), sobreescribiendo el actual 
   y direccionándolo al nuevo grupo.

NOTA:
Antes de mover la tabla de un grupo a otro, la ventana de propiedades/Storage de la tabla
detalle_facturas permite mostrar el grupo de archivos donde se encuentra la 
información de la tabla.

Es así que, pulsando botón derecho en la tabla detalle_facturas y luego seleccionar 
propiedades, en la página Storage se puede visualizar que pertenece a LOGISTICA. 
*/

--Se puede visualizar también usando la siguiente instrucción
SP_HELP detalle_facturas
GO

/* MOVIENDO LA TABLA AL GRUPO DE ARCHIVOS COMERCIAL */

/*PRIMERA FORMA: Moviendo la PK*/
--PASO 1: Eliminando la PK y moverla a comercial
ALTER TABLE detalle_facturas
DROP CONSTRAINT pk_detalle_facturas
WITH(MOVE TO COMERCIAL)
GO
--Note que se ha usdo la opción MOVE TO para mover los datos al nuevo grupo

-- PASO 2: Crear nuevamente la PK
ALTER TABLE detalle_facturas
ADD CONSTRAINT pk_detalle_facturas PRIMARY KEY(factura_serie, factura_numero, producto_codigo)
GO

--El listado de las tablas y sus grupos se muestra con el resultado
SELECT t.name AS tabla, g.name AS [grupo de archivos]
FROM SYS.TABLES AS t
	INNER JOIN SYS.INDEXES AS i ON(i.object_id = t.object_id) AND i.index_id <= 1 --1 indica PK
	LEFT JOIN SYS.FILEGROUPS AS g ON(g.data_space_id = i.data_space_id)
WHERE t.lob_data_space_id = 0
GO

/*SEGUNDA FORMA: Creando y sobreescribiendo el índice agrupado

Otra forma de pasar la tabla a otro grupo de archivos es redefinir el índice agrupado
usando la opción On NombreGrupo al final de la instrucción.
*/

/* PARA PASAR LA TABLA DETALLE_FACTURAS AL GRUPO PRIMARY */
CREATE UNIQUE CLUSTERED INDEX pk_detalle_facturas ON detalle_facturas(factura_serie, factura_numero, producto_codigo)
WITH(DROP_EXISTING = ON, ONLINE = ON)
ON [PRIMARY]
GO

/*
Comoestamos usando una versión EXPRESS de SQL Server no nos permitirá de esta forma.
Las operaciones de índice en línea solo se pueden realizar en la edición Enterprise 
de SQL Server.
*/

/* TABLA PARTICIONADA 

Al crear una tabla particionada la información de esta se distribuye en los grupos de
acuerdo al esquema de partición. Se va a crear una tabla para Pedidos particionada para 
ver como se muestra en el listado.
*/

--Función de partición
CREATE PARTITION FUNCTION  fp_particion_pedidos(CHAR(15))
AS RANGE LEFT FOR VALUES('D', 'L', 'Q', 'V')
GO

--Esquema de partición
CREATE PARTITION SCHEME ep_particion_pedidos
AS PARTITION fp_particion_pedidos
TO (COMERCIAL, LOGISTICA, [PRIMARY], [PRIMARY], COMERCIAL)
GO

CREATE TABLE pedidos(
	codigo CHAR(15),
	cliente_codigo CHAR(7),
	fecha DATE,
	CONSTRAINT pk_pedidos PRIMARY KEY(codigo),
	CONSTRAINT fk_clientes_pedidos FOREIGN KEY(cliente_codigo) REFERENCES clientes(codigo)
) ON ep_particion_pedidos(codigo)
GO

/*Listamos las tablas y los grupos a la que pertenecen
Veremos que la tabla pedidos muestra en el grupo de archivos el valor de NULL,
esto por que es una tabla particionada*/

--Se puede incluir la función IIF para mostrar el mensaje "Tabla particionada"
SELECT t.name AS tabla, IIF(G.TYPE = 'FG', g.name, 'Tabla Particionada') AS [grupo de archivos]
FROM SYS.TABLES AS t
	INNER JOIN SYS.INDEXES AS i ON(i.object_id = t.object_id) AND i.index_id <= 1 --1 indica PK
	LEFT JOIN SYS.FILEGROUPS AS g ON(g.data_space_id = i.data_space_id)
WHERE t.lob_data_space_id = 0
GO


/* BORRAR EL GRUPO DE ARCHIVOS LOGÍSTICA 

Al crear la base de datos, al grupo LOGISTICA se le incluyó dos archivos, 
las siguientes instrucciones eliminan esos archivos. Estos archivos no contienen 
tablas porque ninguna de ellas ha sido direccionada a este grupo.
*/

ALTER DATABASE bd_ferreteria REMOVE FILE F04
ALTER DATABASE bd_ferreteria REMOVE FILE F05
GO

--Ahora se va a intentar borrar el grupo LOGISTICA
ALTER DATABASE bd_ferreteria REMOVE FILEGROUP LOGISTICA
GO

/*
No se puede eliminar el grupo de archivos porque el esquema de partición de la 
tabla Pedidos direcciona una de las particiones al grupo LOGISTICA. El esquema 
de partición llamado ep_particion_pedidos en el que se asignó una de las 
particiones al grupo LOGISTICA.

Para poder eliminar el grupo, debemos reconstruir el índice de la tabla pedidos,
cambiar el índice y mover el contenido a un grupo. 
Para esto utilizaremos la PRIMERA FORMA de la sección MOVIENDO LA TABLA AL GRUPO DE ARCHIVOS 
*/
--PASO 1: Eliminando la PK y moverla a comercial
ALTER TABLE pedidos
DROP CONSTRAINT pk_pedidos
WITH(MOVE TO [PRIMARY])
GO

-- PASO 2: Crear nuevamente la PK
ALTER TABLE pedidos
ADD CONSTRAINT pk_pedidos PRIMARY KEY(codigo)
GO

--Eliminar luego el esquema de partición
DROP PARTITION SCHEME ep_particion_pedidos
GO

-- Ahora sí es posible eliminar el grupo de archivos
ALTER DATABASE bd_ferreteria REMOVE FILEGROUP LOGISTICA
GO

--Si verificamos las propiedades de la bd opción filegroups, veremos
--que ya no está el grupo LOGISTICA

/* REESTABLECER EL GRUPO DE ARCHIVOS Y LOS ARCHIVOS ELIMINADOS

Se debe realizar una copia de seguridad de Log de la base de datos, 
previamente se debe crear un DEVICE para el BACKUP
*/

--La siguiente instrucción crea un DEVICE en el disco llamado bd_ferreteria_bk_log
EXECUTE SP_ADDUMPDEVICE 'DISK', 'bd_ferreteria_bk_log', 'C:\BD_SQL_SERVER\BASES\bd_ferreteria_log.bak'
GO

--Obtener el backup del Log
BACKUP DATABASE bd_ferreteria TO bd_ferreteria_bk_log
GO

--Ahora se puede volver a agregar el grupo y los archivos
ALTER DATABASE bd_ferreteria
ADD FILEGROUP LOGISTICA
GO

ALTER DATABASE bd_ferreteria
ADD FILE
(NAME='F04', FILENAME='D:\BD_SQL_SERVER\BASES\F04.ndf'),
(NAME='F05', FILENAME='D:\BD_SQL_SERVER\BASES\F05.ndf')
TO FILEGROUP LOGISTICA
GO

--Si vamos a las propiedades de la BD opción FILEGROUPS veremos
--el grupo LOGISTICA junto con sus 2 archivos