/*-- IDENTITY - CASO PR�CTICO --*/
/*
La propiedad Identity puede ser asignada a un solo campo en la tabla, generalmente 
se usa para saber la cantidad de registros insertados, o para ayudar a construir un c�digo.

No es recomendable usarla como columna de c�digo ya que los c�digos generalmente son 
datos de tipo caracter.

Se recomienda usar para los c�digos de las tablas campos de tipo nchar.

En este ejemplo se muestra como trabajar con la propiedad Identity y al borrar los �ltimos 
registros resetear la propiedad para que los siguientes registros insertados tengan el valor 
correcto correlativo.
*/
USE bd_sistemas
GO

--Tabla con campo IDENTITY
CREATE TABLE datos(
	id INT IDENTITY(1,1) PRIMARY KEY,
	descripcion VARCHAR(50),
	precio NUMERIC(9,2)
)
GO

--INSERTAR REGISTROS
INSERT INTO datos(descripcion, precio)
VALUES('casaca', 180),
('pantal�n', 800),
('sombrero', 250)
GO

--Listar datos
SELECT * FROM datos
GO

--El campo identity no se especifica ni se le inserta un valor. SQL Server lo hace en autom�tico

--Insertamos dos registros m�s
INSERT INTO datos(descripcion, precio)
VALUES('Zapatos', 390),
('Correo', 120)
GO

--Los nuevos registros toman el id de 4 y 5
SELECT * FROM datos
GO

--Borrar f�sicamente los registros 3, 4 y 5
DELETE FROM datos WHERE id IN(3,4,5)
GO

/*Quedaron solamente los registros 1 y 2, si se inserta un nuevo registro deber�a
tomar el n�mero 3, el valor de la identidad qued� en 5
*/
SELECT @@IDENTITY
GO

--Restauramos el valor del identity al valor que deber�a continuar, es decir 3
--Pero antes, insertamos un registro sin la modificaci�n
INSERT INTO datos(descripcion, precio)
VALUES('Zapatillas', 390)
GO

--Nos mostrar� el registro con un id = 6

--Ahora lo reiniciamos al valor que deber�a seguir. Eliminamos el �ltimo registro insertado
DELETE FROM datos WHERE id = 6
GO

--Actualizamos el IDENTITY al valor que debe�a seguir, o sea igual a 3. Por eso
--en la siguiente funci�n le indicamos que el �ltimo id fue el 2
DBCC CHECKIDENT(datos, RESEED, 2)
GO

--Volvemos a insertar
INSERT INTO datos(descripcion, precio)
VALUES('Zapatillas', 390)
GO

--Listamos y vemos que ya el id es igual a 3
SELECT * FROM datos
GO


/* USO DE IDENTITY CON VALORES INICIALES E INCREMENTO DIFERENTE DE 1*/
CREATE TABLE apuestas(
	id INT IDENTITY(10,20) PRIMARY KEY,
	descripcion VARCHAR(50),
	precio NUMERIC(9,2)
)
GO

INSERT INTO apuestas
VALUES('Ganador Premio', 1500),
('Empate', 500),
('Perdedor', -60)
GO

--Listar tabla
SELECT * FROM apuestas
GO