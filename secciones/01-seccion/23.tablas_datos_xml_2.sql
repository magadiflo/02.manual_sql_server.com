/*-- TABLAS CON CAMPOS XML EJEMPLO --*/
/*
Los tipos de campo XML permiten guardar información estructurada que dependa del mismo 
registro. El uso de los tipos de datos XML es muy efectivo para elementos dependientes 
que no tengan muchos datos.
*/

/*EJEMPLO: ASEGURADO Y LOS DEPENDIENTES
En este ejemplo el tipo de campo XML almacenará los datos de los
dependientes de un asegurado.

La tabla asegurados tiene un campo llamado dependientes de tipo XML.
Para insertar de manera manual los registros se recomienda un editor de archivo XML.
*/

USE bd_restricciones
GO

CREATE TABLE asegurados(
	codigo CHAR(6),
	nombre_completo VARCHAR(200),
	dependientes XML,
	fecha_nacimiento DATE,
	CONSTRAINT pk_asegurados PRIMARY KEY(codigo)
)
GO

--Insertar datos
SET DATEFORMAT dmy
INSERT INTO asegurados(codigo, nombre_completo, dependientes, fecha_nacimiento)
VALUES('852369', 'PEDRO CASTRO NIEVES', '<Dependientes>
<Dependiente>
<Codigo>7852</Codigo>
<Nombre>Vilma</Nombre>
<Paterno>Gonzales</Paterno>
<Materno>Plasencia</Materno>
<Parentesco>Esposa</Parentesco>
</Dependiente>
<Dependiente>
<Codigo>9615</Codigo>
<Nombre>Jose</Nombre>
<Paterno>Gonzales</Paterno>
<Materno>Gonzales</Materno>
<Parentesco>Hijo</Parentesco>
</Dependiente>
<Dependiente>
<Codigo>3578</Codigo>
<Nombre>Paola</Nombre>
<Paterno>Gonzales</Paterno>
<Materno>Gonzales</Materno>
<Parentesco>Hija</Parentesco>
</Dependiente>
</Dependientes>', '15/09/1990'),
('259716', 'CARMEN ZEGARRA LOPEZ', '<Dependientes>
<Dependiente>
<Codigo>7821</Codigo>
<Nombre>Carlos</Nombre>
<Paterno>Mendoza</Paterno>
<Materno>Segura</Materno>
<Parentesco>Esposo</Parentesco>
</Dependiente>
<Dependiente>
<Codigo>2589</Codigo>
<Nombre>Manuelita</Nombre>
<Paterno>Mendoza</Paterno>
<Materno>Zegarra</Materno>
<Parentesco>Hija</Parentesco>
</Dependiente>
</Dependientes>', '04-04-1994'),
('975281', 'ANTONIO MENDEZ VILLA', '<Dependientes>
<Dependiente>
<Codigo>8855</Codigo>
<Nombre>Carlos</Nombre>
<Paterno>Mendez</Paterno>
<Materno>Polo</Materno>
<Parentesco>Papá</Parentesco>
</Dependiente>
</Dependientes>', '06.06.1966')
GO
--Notar que como definimos SET DATEFORMA dmy, podremos ingresar las fechas
--según dia, mes y año, en cualquier formato: 04/04/1990, 04.04.1990, 04-04-1990

--Al listar los registros de la tabla se muestra el campo XML con las etiquetas escritas
SELECT * FROM asegurados
GO

--Se pueden listar datos de una tabla con XML de dos maneras:

--PRIMERA FORMA
SELECT * 
FROM asegurados 
FOR XML AUTO
GO

--SEGUNDA FORMA
SELECT * 
FROM asegurados 
FOR XML RAW
GO

SELECT *
FROM asegurados 
FOR XML PATH
GO

SELECT *
FROM asegurados
FOR XML PATH('tr')
GO

SELECT nombre_completo
FROM asegurados 
FOR XML PATH('')
GO

SELECT ', ' + nombre_completo
FROM asegurados 
FOR XML PATH('')
GO