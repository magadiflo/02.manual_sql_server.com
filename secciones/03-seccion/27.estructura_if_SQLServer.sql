/*-- ESTRUCTURA IF EN SQL SERVER --

Al igual que los lenguajes de programación la estructura If permitirá evaluar una o mas condiciones y 
si el resultado final es verdadero se ejecutan un bloque de instrucciones, si el resultado final es 
falso se pueden ejecutar de manera opcional otro bloque de instrucciones.

Sintaxis

If
Bloque de instrucciones cuando la
expresión es verdadera
[
Else
Bloque de instrucciones cuando la
expresión es Falsa
]

Notas importantes

- Es conveniente definir el bloque de instrucciones de cualquiera de los resultados de la expresión 
  lógica entre las instrucciones Begin y End.
- Se puede usar la estructura IF de varias formas, simple, doble e inclusive If anidados. 
  La sintaxis para estos casos puede cambiar.

If Simple
-----------------------------

If
	Begin
		Bloque de instrucciones cuando la
		expresión es verdadera
	End

Doble
-----------------------------

If
	Begin
		Bloque de instrucciones cuando la
		expresión es verdadera
	End
Else
	Begin
		Bloque de instrucciones cuando la
		expresión es Falsa
	End


Anidados, una estructura If dentro de otra
------------------------------------------
If
	Begin
		Bloque de instrucciones cuando la
		expresión es verdadera
	End
Else
	Begin
		If
			Begin
				Bloque de instrucciones cuando la
				expresión es verdadera
			End
		Else
			Begin
				Bloque de instrucciones cuando la
				expresión es Falsa
			End
	End

*/

/*EJERCICIO 01. Suponiendo que se trabaja de lunes a viernes, la siguiente estructura obtiene el número de 
dia de la semana, si es del 2 al 6 imprime el mensaje «Dia Laborable» del lo contrario «Fin de semana». 
Para el ejercicio usaremos DatePart. */

IF DATEPART(DW, GETDATE()) IN (2,3,4,5,6)
	BEGIN
		PRINT 'Día laborable'
	END
ELSE
	BEGIN
		PRINT 'Fin de semana'
	END

/*EJERCICIO 02. Crear un script para reportar las estaciones, suponer que los meses de 
Enero, Febrero y Marzo son Verano, 
Abril, Mayo y Junio es Otoño, 
Julio, Agosto y Setiembre es Invierno y 
Octubre, Noviembre y Diciembre es Primavera*/
DECLARE @quarterEstacion INTEGER
SET @quarterEstacion = DATEPART(QUARTER, GETDATE())
IF @quarterEstacion IN(1)
	BEGIN
		PRINT 'Verano'
	END
ELSE
	BEGIN
		IF @quarterEstacion IN(2)
			BEGIN
				PRINT 'Otoño'
			END
		ELSE
			BEGIN
				IF @quarterEstacion IN(3)
					BEGIN
						PRINT 'Invierno'
					END
				ELSE
					BEGIN
						PRINT 'Primavera'
					END
			END
	END
GO
/*
Para crear objetos se pueden usar las vistas de sistema para comprobar si el objeto existe, 
por ejemplo, listar los índices de la vista Indexes del esquema sys.
*/

/*EJERCICIO 03. Usando la base de datos Northwind, crear un índice (Ver índices) para la tabla 
Categories en el campo ategoryname, asignar el nombre del índice CategoriasNombreIDXa, si existe 
sobre escribirlo.*/
USE Northwind
GO

IF NOT EXISTS(SELECT * FROM SYS.INDEXES WHERE NAME = 'CategoriasNombreIDXa')
	BEGIN
		CREATE INDEX CategoriasNombreIDXa
		ON Categories(CategoryName)
		WITH FILLFACTOR = 70
	END
ELSE
	BEGIN
		CREATE INDEX CategoriasNombreIDXa
		ON Categories(CategoryName)
		WITH(FILLFACTOR = 70, DROP_EXISTING = ON)
	END
GO


/*EJERCICIO 04. Crear una vista para los clientes (tabla Customers) llamada VistaClientes, 
si la vista existe, primero se debe eliminar. */
IF EXISTS(SELECT * FROM SYS.VIEWS WHERE NAME = 'VistaClientes')
	BEGIN
		EXECUTE('DROP VIEW VistaClientes')
	END

EXECUTE('CREATE VIEW VistaClientes
AS 
	SELECT c.customerID AS codigo, c.CompanyName AS cliente, c.address AS direccion 
	FROM Customers AS c')
GO

SELECT * 
FROM VistaClientes
GO