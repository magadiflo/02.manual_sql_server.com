/*-- IDENTITY EN SQLSERVER - EJERCICIO --*/
/*
Identity es una propiedad que permite que un campo en una tabla incremente su valor de manera 
autom�tica al insertar los registros en ella. Para el uso de la propiedad Identity el tipo de 
dato debe ser entero Int. Es necesario definir un valor inicial y un valor de incremento.

Es importante anotar que Identity no asegura la unicidad de valor, esta �nicamente es posible con 
la restricciones Primary key, Unique o con el �ndice Unique. Solamente puede existir una columna 
por tabla con la propiedad Identidad.

Ejemplo

En el ejemplo, se crea una tabla con la propiedad Identity.
Se insertan registros, luego se eliminan, y si fuera
posible siempre se debe tener en cuenta el valor de Identity.
*/
USE bd_prueba_ties
GO

CREATE TABLE personas(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(200)
)
GO

--Insertando registros
INSERT INTO personas
VALUES('Mart�n D�az Flores'),
('Ra�l Dar�o D�az Flores'),
('Tinkler Ad�n D�az Flores')
GO

--Listar registros
SELECT * 
FROM personas
GO

--Para ver el valor del identity, Reporta NULL si no se ha ingresado registros con identity
SELECT @@IDENTITY
GO

--Insertamos dos m�s
INSERT INTO personas
VALUES('Alicia Flores Z��iga'),
('Gabrielito D�az Ardiles')
GO

--Si se eliminan f�sicamente los registros 4 y 5 quedar�an del 1 al 3, al insertar uno nuevo 
--el c�digo que se generar� ser� el siguiente del registro �ltimo que se creo, o sea 6
DELETE FROM personas WHERE id IN(4, 5)
GO

INSERT INTO personas
VALUES('Gabriel D�az Vilela')
GO


/*RESTAURAR SECUENCIA PARA EL IDENTITY */
--Eliminamos el �ltimo registro creado
DELETE FROM personas WHERE id IN(6)
GO

--Listar registros
SELECT * 
FROM personas
GO

--Si volvemos a crear, el siguiente id ser�a 7, pero como queremos que siga la secuencia usaremos
--DBCC CHECKIDENT(tabla, RESEED, valor)

--Para regresar el valor de IDENTITY a 3
DBCC CHECKIDENT(personas, RESEED, 3)
GO

--Ahora insertar el quinto registros
INSERT INTO personas
VALUES('Gahella D�az Ardiles')
GO

--Listar
SELECT * FROM personas
GO

--Si se borran todos los registros
DELETE personas
DBCC CHECKIDENT(personas, RESEED, 0)
GO

--Podr�amos usar tambi�n un TRUNCATE TABLE para eliminar todos 
--los registros y reiniciar el IDENTITY
TRUNCATE TABLE personas
GO