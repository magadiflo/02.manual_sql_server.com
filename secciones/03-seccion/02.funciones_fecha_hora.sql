/*-- FUNCIONES DE FECHA Y HORA --

Permiten el manejo de datos tipo fecha y hora.

Fecha y Hora del sistema
---------------------------
SYSDATETIME � Fecha y Hora del Servidor
GETDATE � Obtiene la fecha y hora del Servidor

Para el manejo de una fecha en partes
-------------------------------------
DateName � Nombre de parte de la fecha determinada
DataPart � Parte de la fecha
Day � El n�mero de d�a del mes
Month � El n�mero del mes
Year � El a�o de una fecha

A�adir y obtener lapsos entre fechas.
-------------------------------------
DateDiff � Diferencia entre dos fechas
DATEADD � A�ade partes de fecha a una fecha determinada

Obtener si el dato es fecha o no
--------------------------------
IsDate � Verdadero si es dato es de tipo fecha

Partes de fecha

Las partes de la fecha son abreviaturas que permiten especificar que parte de la fecha u hora
se desea trabajar u obtener.

Significado		Abreviatura
----------------------------
year			yy , yyyy
quarter			qq , q
month			mm , m
dayofyear		dy , y
day				dd , d
week			wk , ww
weekday			dw
hour			hh
minute			mi, n
second			ss , s
*/
--Mostrar la fecha y hora del sistema
SELECT GETDATE() AS 'fecha actual', SYSDATETIME() AS 'fecha sistema'
GO

--Mostrar el a�o, nombre del mes y nombre del d�a
SELECT	DATENAME(YEAR, GETDATE()) AS a�o, 
		DATENAME(MONTH, GETDATE()) AS mes,
		DATENAME(DW, GETDATE()) AS dia
GO

--Mostrar el d�a del mes y d�a del a�o (hasta 365)
SELECT DATENAME(DAY, GETDATE()) AS 'd�a del mes',
		DATENAME(DY, GETDATE()) AS 'd�a del a�o'
GO

--Mostrar la semana del a�o (de 1 a 52) y n�mero de d�a de la semana
SELECT	DATEPART(WK, '1996-11-16') AS 'semana',
		DATEPART(DW, '2000-10-01') AS dia	
GO

USE Northwind
GO

--�rdenes del a�o 1998
SELECT *
FROM Orders AS o
WHERE YEAR(o.OrderDate) = 1998
GO

--�rdenes de Abril, Mayo y Junio de 1997
SELECT *
FROM Orders AS o
WHERE	YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) IN (4, 5, 6)
GO

--Listado de las �rdenes, su ID o n�mero, la fecha de la orden, la fecha de 
--atenci�n y la cantidad de d�as en que fue atendida.
SELECT	OrderID, FORMAT(OrderDate, 'dd/MM/yy') AS 'fecha emisi�n',
		FORMAT(ShippedDate, 'dd/MM/yy') AS 'fecha de atenci�n',
		DATEDIFF(DAY, OrderDate, ShippedDate) AS 'd�as en atender'
FROM Orders
GO

--Agregando 60 d�as a la fecha actual
PRINT DATEADD(DAY, 60, GETDATE())
GO