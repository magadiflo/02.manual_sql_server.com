/*-- TABLAS DATOS XML --*/
/*
Es posible incluir en un campo de una tabla, datos en formato XML (eXtensible Markup Language), 
el tipo de datos XML permite almacenar datos que dependan del registro en la misma tabla y 
posiblemente evitar diseñar un maestro – detalle.

EJEMPLO
En una clínica veterinaria se podría guardar los datos de las mascotas de un determinado 
propietario en una sola tabla, es decir, Propietarios y Mascotas en la misma tabla. 

En el siguiente código se muestra la inserción de registros de manera manual, 
es necesario de preferencia usar algún editor de archivos XML.
*/

USE bd_restricciones
GO

-- Tabla para propietarios
CREATE TABLE propietarios(
	codigo CHAR(10),
	nombre VARCHAR(200) NOT NULL,
	mascotas XML,
	telefono VARCHAR(30)
	CONSTRAINT pk_propietarios PRIMARY KEY(codigo)
)
GO

/*Al insertar los datos del propietario, se pueden insertar los datos de sus mascotas
en el campo mascotas de tipo XML*/
INSERT INTO propietarios(codigo, nombre, mascotas, telefono)
VALUES('85214', 'MARTÍN DÍAZ', '<Mascotas>
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
</Mascotas>', '943649626'),
('74965', 'GASPAR FLORES', '<Mascotas>
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
<Nombre>Romulo Alan</Nombre>
<FechaNacimiento>08/10/2005</FechaNacimiento>
</Mascota>
</Mascotas>', '943833208')
GO

SELECT * 
FROM propietarios
GO

/*Las tablas con campos de tipo XML se pueden listar incluyendo todos
los datos en un formato de salida XML*/
SELECT * 
FROM propietarios FOR XML AUTO
GO

SELECT * 
FROM propietarios FOR XML RAW
GO

SELECT * 
FROM propietarios
FOR XML PATH('tr'), TYPE
GO