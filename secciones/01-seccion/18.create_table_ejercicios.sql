/*-- CREATE TABLE EJERCICIOS --*/
USE bd_olimpiadas
GO

SELECT * FROM SYS.filegroups
GO

SP_HELPDB bd_olimpiadas
GO
/*EJERCICIO 01. Tabla productos donde se especifique la clave primaria.
Reutilizaremos la bd_olimpiadas que fue creada en archivo 12.esquemas.sql
All� se defini� un filegroup VENTAS. 
Esta table productos, lo crearemos en dicho filegroup
*/
CREATE TABLE productos(
	codigo CHAR(10),
	descripcion VARCHAR(200),
	precio NUMERIC(9,2),
	stock NUMERIC(9,2),
	fecha_vencimiento DATE,
	origen CHAR(1),
	foto IMAGE,
	CONSTRAINT pk_productos PRIMARY KEY(codigo)
) ON VENTAS --Tenemos un filegroup llamado VENTAS
GO

SELECT * FROM productos
GO
/*para ver el grupo donde est� creado la tabla
select si.name, sf.fileid, sf.name, sfg.groupid, sfg.groupname
from sysindexes si inner join sysfiles sf on si.groupid = sf.groupid
inner join sysfilegroups sfg on sf.groupid = sfg.groupid
where si.id = object_id('niveles')
*/

/*EJERCICIO 02. Suponiendo una instituci�n de ense�anza de nivel escolar.
Las tablas para niveles que pueden ser Inicial(ni�os de 3 a 5 a�os),
Primaria y Secundaria Y Grados. La tabla de niveles tiene en el dise�o
las restricciones de tipo primary key, default, check y unique*/
CREATE TABLE niveles(
	codigo CHAR(10),
	descripcion VARCHAR(200) NOT NULL,
	explicacion VARCHAR(100) CONSTRAINT df_explicacion DEFAULT '',
	fecha_creacion DATE CONSTRAINT df_fecha_creacion DEFAULT GETDATE(),
	estado CHAR(1) NOT NULL,
	niveles CHAR(1) NOT NULL CONSTRAINT df_niveles DEFAULT 'N',
	CONSTRAINT pk_niveles PRIMARY KEY(codigo),
	CONSTRAINT ck_estado CHECK(estado = 'A' OR estado = 'E'),
	CONSTRAINT ck_niveles CHECK(niveles = 'S' OR niveles = 'N'),
	CONSTRAINT uq_descripcion UNIQUE(descripcion)
)
GO

-- Grados, tiene su clave primaria y clave for�nea a niveles
CREATE TABLE grados(
	codigo CHAR(10),
	nivele_codigo CHAR(10),
	descripcion VARCHAR(200) NOT NULL,
	fecha_creacion DATE,
	estado CHAR(1) NOT NULL,
	CONSTRAINT pk_grados PRIMARY KEY(codigo),
	CONSTRAINT fk_niveles_grados FOREIGN KEY(nivele_codigo) REFERENCES niveles(codigo)
)
GO
