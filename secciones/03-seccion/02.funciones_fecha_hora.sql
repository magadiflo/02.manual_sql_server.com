/*-- FUNCIONES DE FECHA Y HORA --

Permiten el manejo de datos tipo fecha y hora.

Fecha y Hora del sistema
---------------------------
SYSDATETIME — Fecha y Hora del Servidor
GETDATE — Obtiene la fecha y hora del Servidor

Para el manejo de una fecha en partes
-------------------------------------
DateName — Nombre de parte de la fecha determinada
DataPart — Parte de la fecha
Day — El número de día del mes
Month — El número del mes
Year — El año de una fecha

Añadir y obtener lapsos entre fechas.
-------------------------------------
DateDiff — Diferencia entre dos fechas
DATEADD — Añade partes de fecha a una fecha determinada

Obtener si el dato es fecha o no
--------------------------------
IsDate — Verdadero si es dato es de tipo fecha

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

--Mostrar el año, nombre del mes y nombre del día
SELECT	DATENAME(YEAR, GETDATE()) AS año, 
		DATENAME(MONTH, GETDATE()) AS mes,
		DATENAME(DW, GETDATE()) AS dia
GO

--Mostrar el día del mes y día del año (hasta 365)
SELECT DATENAME(DAY, GETDATE()) AS 'día del mes',
		DATENAME(DY, GETDATE()) AS 'día del año'
GO

--Mostrar la semana del año (de 1 a 52) y número de día de la semana
SELECT	DATEPART(WK, '1996-11-16') AS 'semana',
		DATEPART(DW, '2000-10-01') AS dia	
GO

USE Northwind
GO

--Órdenes del año 1998
SELECT *
FROM Orders AS o
WHERE YEAR(o.OrderDate) = 1998
GO

--Órdenes de Abril, Mayo y Junio de 1997
SELECT *
FROM Orders AS o
WHERE	YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) IN (4, 5, 6)
GO

--Listado de las órdenes, su ID o número, la fecha de la orden, la fecha de 
--atención y la cantidad de días en que fue atendida.
SELECT	OrderID, FORMAT(OrderDate, 'dd/MM/yy') AS 'fecha emisión',
		FORMAT(ShippedDate, 'dd/MM/yy') AS 'fecha de atención',
		DATEDIFF(DAY, OrderDate, ShippedDate) AS 'días en atender'
FROM Orders
GO

--Agregando 60 días a la fecha actual
PRINT DATEADD(DAY, 60, GETDATE())
GO