/*-- MANEJANDO FECHAS EN SQL SERVER --

Las funciones de fecha y hora de SQL Server permiten manejar y hacer los cálculos usando campos
de tipo Fecha y de tipo Hora. Es posible que para efectos de algún proceso se tengan que 
calcular la cantidad de años, meses o días que existen entre dos fechas determinadas. En este
artículo se explica cómo manejar los datos de tipo fecha para realizar estos cálculos.
*/

USE Northwind
GO

/*EJERCICIO 01. Calculando edades, la cantidad de años, meses y días de un empleado. 

Note que para la cantidad de años se ha calculado la diferencia de días desde la fecha de 
nacimiento hasta la fecha actual dividido entre 365.25 (cantidad exacta de días en el año).
*/
SELECT	FirstName + SPACE(1) + LastName AS empleado, 
		FORMAT(BirthDate, 'dd/MM/yyyy') AS nacimiento,
		FORMAT(GETDATE(), 'dd/MM/yyyy') AS 'fecha actual',
		FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))) AS 'años',
		FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))*12) -
		FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))) * 12 AS 'meses',
		FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE()) AS NUMERIC(9,2)) - 
		DATEDIFF(DAY,BirthDate,DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))),BirthDate)) - 
		DATEDIFF(DAY,DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))),BirthDate),DATEADD(MONTH,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))*12) - 
		FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))) * 12, DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))),BirthDate)))) As 'dias'
FROM Employees
GO

/*EJERCICIO 02. Mostrar el cumpleaños del año actual*/
SELECT	FirstName + SPACE(1) + LastName AS empleado, 
		FORMAT(BirthDate, 'dd/MM/yyyy') AS nacimiento,
		FORMAT(GETDATE(), 'dd/MM/yyyy') AS 'fecha actual',
		FORMAT(DATEADD(YEAR, FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))), BirthDate), 'dd/MM/yyyy') AS 'Cumpleaños año actual'
FROM Employees
GO

/*EJERCICIO 03. En este ejercicio se muestra la fecha de nacimiento, el día de cumpleaños del año actual, los meses
transcurridos después del cumpleaños del año actual, la fecha del último mes cumplido y los días transcurridos desde 
el último més cumplido*/
SELECT	FirstName + SPACE(1) + LastName AS empleado, 
		FORMAT(BirthDate, 'dd/MM/yyyy') AS nacimiento,
		FORMAT(GETDATE(), 'dd/MM/yyyy') AS 'fecha actual',
		FORMAT(DATEADD(YEAR, FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))), BirthDate), 'dd/MM/yyyy') AS 'Cumple año actual',
		FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))*12) - 
		FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE())/365.25 AS NUMERIC(9,2)))*12 AS 'meses transcurridos',
		FORMAT(DATEADD(MONTH, FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))*12) - 
		FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))) *12, DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))),BirthDate)),'dd/MM/yyyy') As 'Último mes cumplido',
		DATEDIFF(DAY,DATEADD(MONTH,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))*12) - 
		FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2)))*12, DATEADD(YEAR, FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))),BirthDate)),GETDATE()) AS 'Días desde el último mes cumplido'

FROM Employees
GO

/*EJERCICIO 04. Mostrar la cantidad de años, meses y días en el trabajo*/
SELECT	FirstName + SPACE(1) + LastName AS empleado, 
		FORMAT(HireDate, 'dd/MM/yyyy') AS 'Fecha de contrato',
		FORMAT(GETDATE(), 'dd/MM/yyyy') AS 'fecha actual',
		FLOOR(CAST(DATEDIFF(DAY, HireDate, GETDATE()) / 365.25 AS NUMERIC(9,2))) AS 'años',
		FLOOR(CAST(DATEDIFF(DAY, HireDate, GETDATE()) / 365.25 AS NUMERIC(9,2))*12) -
		FLOOR(CAST(DATEDIFF(DAY, HireDate, GETDATE()) / 365.25 AS NUMERIC(9,2))) * 12 AS 'meses',
		FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE()) AS NUMERIC(9,2)) - 
		DATEDIFF(DAY,HireDate,DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE())/365.25 AS NUMERIC(9,2))),HireDate)) - 
		DATEDIFF(DAY,DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE())/365.25 AS NUMERIC(9,2))),HireDate),DATEADD(MONTH,FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE())/365.25 AS NUMERIC(9,2))*12) - 
		FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE())/365.25 AS NUMERIC(9,2))) * 12, DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE())/365.25 AS NUMERIC(9,2))),HireDate)))) As 'dias'
FROM Employees
GO

/*EJERCICIO 05. Mostrar las órdenes y la cantidad de días en ser atendidas*/
SELECT o.OrderID as [N° Orden], c.CompanyName AS [Cliente], 
	   FORMAT(o.OrderDate, 'dd/MM/yyyy') AS [Fecha Registro], 
	   FORMAT(o.ShippedDate, 'dd/MM/yyyy') AS [Fecha atención],
	   DATEDIFF(DAY, o.OrderDate, o.ShippedDate) AS [Dias de demora]
FROM Orders AS o 
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
WHERE o.ShippedDate IS NOT NULL
ORDER BY [Dias de demora] DESC
GO

/*EJERCICIO 06. Listado de cumpleaños del mes*/
SELECT  e.FirstName + SPACE(1) + e.LastName AS 'empleado', 
	    FORMAT(e.BirthDate, 'dd/MM/yyyy') AS 'fecha nacimiento', 
	    DAY(e.BirthDate) AS 'dia'
FROM Employees AS e
WHERE MONTH(e.BirthDate) = MONTH(GETDATE())
GO

/*EJERCICIO 07. Años de los empleados, ordenados de menor a mayor*/
SELECT e.FirstName + SPACE(1) + e.LastName AS 'empleado',
	   FORMAT(e.BirthDate, 'dd/MM/yyyy') AS 'fecha de nacimiento',
	   FLOOR(CAST(DATEDIFF(DAY, e.BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))) AS 'años'
FROM Employees AS e
ORDER BY años ASC
GO

/* FUNCIÓN GetUTCDate

La función GetUTCDate muestra la hora de acuerdo al meridiano de Greenwich, que es el
meridiano a partir del cual se miden las longitudes. El equipo donde se ha ejecutado 
las instrucciones se encuentra ubicado en la zona horario (UTC-05:00) Bogotá, Lima, 
Quito, Rio Branco.

La instrucción siguiente muestra la fecha actual usando GetDate, el resultado de 
GetUTCDate y la fecha actual sumándole las 5 horas de diferencia según la zona horario
de Perú, que es la configuración del equipo desde donde se publican los artículos
de esta página.
*/

SELECT  GETDATE() AS 'fecha actual',
		GETUTCDATE() AS 'fecha UTC',
		DATEADD(HOUR, 5, GETDATE()) AS 'fecha actual más 5 horas'
GO