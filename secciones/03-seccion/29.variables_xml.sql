/*-- VARIABLES XML EN SQL SERVER --

Los campos de tipo XML son muy efectivos para guardar información relacionada con un 
diseño Maestro – Detalle, los datos XML son soportados por todos los lenguajes de 
programación por lo que su uso es muy efectivo.

Como guardar los datos en formato XML
En el artículo de Campos XML en tablas se explica la creación de tablas con campos XML, 
ahora se va a crear una base de datos para una clínica veterinaria y una tabla de 
Propietarios con sus mascotas en un campo XML. (Ver Campos XML)

Crear la base de datos y la tabla para Propietarios.
*/
CREATE DATABASE bd_clinica_veterinaria
GO

USE bd_clinica_veterinaria
GO

CREATE TABLE propietarios(
	codigo CHAR(10) NOT NULL,
	nombre VARCHAR(200) NOT NULL,
	mascotas XML,
	telefono VARCHAR(30),
	CONSTRAINT pk_propietarios PRIMARY KEY(codigo)
)
GO

/*Insertar registros en la tabla propietarios*/
INSERT INTO propietarios(codigo, nombre, mascotas, telefono)
VALUES('CM00085214', 'CARLOS MONTENEGRO', 
'<Mascotas>
    <Mascota>
        <Codigo>1285</Codigo>
        <Descripcion>Gato</Descripcion>
        <Nombre>Garfield</Nombre>
        <FechaNacimiento>15/07/2015</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>89658</Codigo>
        <Descripcion>Perro</Descripcion>
        <Nombre>Cody</Nombre>
        <FechaNacimiento>18/09/2005</FechaNacimiento>
    </Mascota>
</Mascotas>', '948635251'),
('LV00074965', 'LUIS VILLANUEVA', 
'<Mascotas>
    <Mascota>
        <Codigo>9625</Codigo>
        <Descripcion>Gallo</Descripcion>
        <Nombre>Aristides</Nombre>
        <FechaNacimiento>05/04/1992</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>89345</Codigo>
        <Descripcion>Loro</Descripcion>
        <Nombre>Betito</Nombre>
        <FechaNacimiento>18/09/2005</FechaNacimiento>
    </Mascota>
	<Mascota>
        <Codigo>4545</Codigo>
        <Descripcion>Rata</Descripcion>
        <Nombre>Rómulo Alan</Nombre>
        <FechaNacimiento>08/10/2005</FechaNacimiento>
    </Mascota>
</Mascotas>', '01-252858')
GO

/*Al listar los registros se muestran como sigue:*/
SELECT * 
FROM propietarios
GO

/*
Como crear variables de tipo XML en SQL Server
Para la creación de variables de tipo XML se utiliza la instrucción DECLARE como cualquier otra variable.
*/
DECLARE @mascotas XML
SET @mascotas = 
'<Mascotas>
    <Mascota>
        <Codigo>1478</Codigo>
        <Descripcion>Obeja</Descripcion>
        <Nombre>Pana</Nombre>
        <FechaNacimiento>05/10/2005</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>3574</Codigo>
        <Descripcion>Sapo</Descripcion>
        <Nombre>Kanko</Nombre>
        <FechaNacimiento>21/09/2008</FechaNacimiento>
    </Mascota>
	<Mascota>
        <Codigo>7958</Codigo>
        <Descripcion>Gato</Descripcion>
        <Nombre>Cat Sillas</Nombre>
        <FechaNacimiento>10/01/2015</FechaNacimiento>
    </Mascota>
</Mascotas>'

SELECT @mascotas
GO

/*
Como insertar registros con campo XML
Para insertar registros que contienen campos de tipo XML se puede proceder de la forma como se 
presenta líneas arriba, pero lo recomendable es guardar los datos en una variable de tipo XML 
y luego usar esa variable en la instrucción Insert.

Teniendo los datos en la variable @Mascotas, luego usar la instrucción Insert
*/
DECLARE @mascotas XML
SET @mascotas = 
'<Mascotas>
    <Mascota>
        <Codigo>1478</Codigo>
        <Descripcion>Obeja</Descripcion>
        <Nombre>Pana</Nombre>
        <FechaNacimiento>05/10/2005</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>3574</Codigo>
        <Descripcion>Sapo</Descripcion>
        <Nombre>Kanko</Nombre>
        <FechaNacimiento>21/09/2008</FechaNacimiento>
    </Mascota>
	<Mascota>
        <Codigo>7958</Codigo>
        <Descripcion>Gato</Descripcion>
        <Nombre>Cat Sillas</Nombre>
        <FechaNacimiento>10/01/2015</FechaNacimiento>
    </Mascota>
</Mascotas>'
INSERT INTO propietarios(codigo, nombre, mascotas, telefono)
VALUES('IG00074125', 'INGRID GÁLVEZ', @mascotas, '986532143')
GO

SELECT * 
FROM propietarios
GO

/*
Cómo leer los datos de una variable XML
Para leer los datos de una variable de tipo XML en SQL Server se utiliza el 
método QUERY para la variable de tipo XML
*/
DECLARE @mascotas XML
SET @mascotas = 
'<Mascotas>
    <Mascota>
        <Codigo>1478</Codigo>
        <Descripcion>Obeja</Descripcion>
        <Nombre>Pana</Nombre>
        <FechaNacimiento>05/10/2005</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>3574</Codigo>
        <Descripcion>Sapo</Descripcion>
        <Nombre>Kanko</Nombre>
        <FechaNacimiento>21/09/2008</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>7958</Codigo>
        <Descripcion>Gato</Descripcion>
        <Nombre>Cat Sillas</Nombre>
        <FechaNacimiento>10/01/2015</FechaNacimiento>
    </Mascota>
</Mascotas>'
SELECT @mascotas.query('/Mascotas/Mascota/Codigo')
GO

/*Para mostrar los datos de las mascotas*/
DECLARE @mascotas XML
SET @mascotas = 
'<Mascotas>
    <Mascota>
        <Codigo>1478</Codigo>
        <Descripcion>Obeja</Descripcion>
        <Nombre>Pana</Nombre>
        <FechaNacimiento>05/10/2005</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>3574</Codigo>
        <Descripcion>Sapo</Descripcion>
        <Nombre>Kanko</Nombre>
        <FechaNacimiento>21/09/2008</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>7958</Codigo>
        <Descripcion>Gato</Descripcion>
        <Nombre>Cat Sillas</Nombre>
        <FechaNacimiento>10/01/2015</FechaNacimiento>
    </Mascota>
</Mascotas>'
SELECT @mascotas.query('/Mascotas/Mascota')
GO

/*Para leer los datos de la tercera mascota*/
DECLARE @mascotas XML
SET @mascotas = 
'<Mascotas>
    <Mascota>
        <Codigo>1478</Codigo>
        <Descripcion>Obeja</Descripcion>
        <Nombre>Pana</Nombre>
        <FechaNacimiento>05/10/2005</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>3574</Codigo>
        <Descripcion>Sapo</Descripcion>
        <Nombre>Kanko</Nombre>
        <FechaNacimiento>21/09/2008</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>7958</Codigo>
        <Descripcion>Gato</Descripcion>
        <Nombre>Cat Sillas</Nombre>
        <FechaNacimiento>10/01/2015</FechaNacimiento>
    </Mascota>
</Mascotas>'
SELECT @mascotas.query('(/Mascotas/Mascota)[3]')
GO

/*
Cómo usar el XML.VALUE en SQLServer
Para poder leer los datos en un campo XML en detalle se puede usar el método value del XML

Para leer el nombre de la mascota
*/
DECLARE @mascotas XML
SET @mascotas = 
'<Mascotas>
    <Mascota>
        <Codigo>1478</Codigo>
        <Descripcion>Obeja</Descripcion>
        <Nombre>Pana</Nombre>
        <FechaNacimiento>05/10/2005</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>3574</Codigo>
        <Descripcion>Sapo</Descripcion>
        <Nombre>Kanko</Nombre>
        <FechaNacimiento>21/09/2008</FechaNacimiento>
    </Mascota>
    <Mascota>
        <Codigo>7958</Codigo>
        <Descripcion>Gato</Descripcion>
        <Nombre>Cat Sillas</Nombre>
        <FechaNacimiento>10/01/2015</FechaNacimiento>
    </Mascota>
</Mascotas>'
DECLARE @nombreMascota VARCHAR(100)
SET @nombreMascota = @mascotas.value('(/Mascotas/Mascota/Nombre)[2]', 'VARCHAR(100)')
SELECT @nombreMascota
GO
--El resultado nos devuelve el nombre de la segunda mascota Kanko