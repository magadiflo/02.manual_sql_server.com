/*-- MANEJANDO FECHAS EN SQL SERVER --

Las funciones de fecha y hora de SQL Server permiten manejar y hacer los c�lculos usando campos
de tipo Fecha y de tipo Hora. Es posible que para efectos de alg�n proceso se tengan que 
calcular la cantidad de a�os, meses o d�as que existen entre dos fechas determinadas. En este
art�culo se explica c�mo manejar los datos de tipo fecha para realizar estos c�lculos.
*/

USE Northwind
GO

/*EJERCICIO 01. Calculando edades, la cantidad de a�os, meses y d�as de un empleado. 

Note que para la cantidad de a�os se ha calculado la diferencia de d�as desde la fecha de 
nacimiento hasta la fecha actual dividido entre 365.25 (cantidad exacta de d�as en el a�o).
*/
SELECT	FirstName + SPACE(1) + LastName AS empleado, 
		FORMAT(BirthDate, 'dd/MM/yyyy') AS nacimiento,
		FORMAT(GETDATE(), 'dd/MM/yyyy') AS 'fecha actual',
		FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))) AS 'a�os',
		FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))*12) -
		FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))) * 12 AS 'meses',
		FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE()) AS NUMERIC(9,2)) - 
		DATEDIFF(DAY,BirthDate,DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))),BirthDate)) - 
		DATEDIFF(DAY,DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))),BirthDate),DATEADD(MONTH,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))*12) - 
		FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))) * 12, DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))),BirthDate)))) As 'dias'
FROM Employees
GO

/*EJERCICIO 02. Mostrar el cumplea�os del a�o actual*/
SELECT	FirstName + SPACE(1) + LastName AS empleado, 
		FORMAT(BirthDate, 'dd/MM/yyyy') AS nacimiento,
		FORMAT(GETDATE(), 'dd/MM/yyyy') AS 'fecha actual',
		FORMAT(DATEADD(YEAR, FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))), BirthDate), 'dd/MM/yyyy') AS 'Cumplea�os a�o actual'
FROM Employees
GO

/*EJERCICIO 03. En este ejercicio se muestra la fecha de nacimiento, el d�a de cumplea�os del a�o actual, los meses
transcurridos despu�s del cumplea�os del a�o actual, la fecha del �ltimo mes cumplido y los d�as transcurridos desde 
el �ltimo m�s cumplido*/
SELECT	FirstName + SPACE(1) + LastName AS empleado, 
		FORMAT(BirthDate, 'dd/MM/yyyy') AS nacimiento,
		FORMAT(GETDATE(), 'dd/MM/yyyy') AS 'fecha actual',
		FORMAT(DATEADD(YEAR, FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))), BirthDate), 'dd/MM/yyyy') AS 'Cumple a�o actual',
		FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))*12) - 
		FLOOR(CAST(DATEDIFF(DAY, BirthDate, GETDATE())/365.25 AS NUMERIC(9,2)))*12 AS 'meses transcurridos',
		FORMAT(DATEADD(MONTH, FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))*12) - 
		FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))) *12, DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))),BirthDate)),'dd/MM/yyyy') As '�ltimo mes cumplido',
		DATEDIFF(DAY,DATEADD(MONTH,FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))*12) - 
		FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2)))*12, DATEADD(YEAR, FLOOR(CAST(DATEDIFF(DAY,BirthDate, GETDATE())/365.25 AS NUMERIC(9,2))),BirthDate)),GETDATE()) AS 'D�as desde el �ltimo mes cumplido'

FROM Employees
GO

/*EJERCICIO 04. Mostrar la cantidad de a�os, meses y d�as en el trabajo*/
SELECT	FirstName + SPACE(1) + LastName AS empleado, 
		FORMAT(HireDate, 'dd/MM/yyyy') AS 'Fecha de contrato',
		FORMAT(GETDATE(), 'dd/MM/yyyy') AS 'fecha actual',
		FLOOR(CAST(DATEDIFF(DAY, HireDate, GETDATE()) / 365.25 AS NUMERIC(9,2))) AS 'a�os',
		FLOOR(CAST(DATEDIFF(DAY, HireDate, GETDATE()) / 365.25 AS NUMERIC(9,2))*12) -
		FLOOR(CAST(DATEDIFF(DAY, HireDate, GETDATE()) / 365.25 AS NUMERIC(9,2))) * 12 AS 'meses',
		FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE()) AS NUMERIC(9,2)) - 
		DATEDIFF(DAY,HireDate,DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE())/365.25 AS NUMERIC(9,2))),HireDate)) - 
		DATEDIFF(DAY,DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE())/365.25 AS NUMERIC(9,2))),HireDate),DATEADD(MONTH,FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE())/365.25 AS NUMERIC(9,2))*12) - 
		FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE())/365.25 AS NUMERIC(9,2))) * 12, DATEADD(YEAR,FLOOR(CAST(DATEDIFF(DAY,HireDate, GETDATE())/365.25 AS NUMERIC(9,2))),HireDate)))) As 'dias'
FROM Employees
GO

/*EJERCICIO 05. Mostrar las �rdenes y la cantidad de d�as en ser atendidas*/
SELECT o.OrderID as [N� Orden], c.CompanyName AS [Cliente], 
	   FORMAT(o.OrderDate, 'dd/MM/yyyy') AS [Fecha Registro], 
	   FORMAT(o.ShippedDate, 'dd/MM/yyyy') AS [Fecha atenci�n],
	   DATEDIFF(DAY, o.OrderDate, o.ShippedDate) AS [Dias de demora]
FROM Orders AS o 
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
WHERE o.ShippedDate IS NOT NULL
ORDER BY [Dias de demora] DESC
GO

/*EJERCICIO 06. Listado de cumplea�os del mes*/
SELECT  e.FirstName + SPACE(1) + e.LastName AS 'empleado', 
	    FORMAT(e.BirthDate, 'dd/MM/yyyy') AS 'fecha nacimiento', 
	    DAY(e.BirthDate) AS 'dia'
FROM Employees AS e
WHERE MONTH(e.BirthDate) = MONTH(GETDATE())
GO

/*EJERCICIO 07. A�os de los empleados, ordenados de menor a mayor*/
SELECT e.FirstName + SPACE(1) + e.LastName AS 'empleado',
	   FORMAT(e.BirthDate, 'dd/MM/yyyy') AS 'fecha de nacimiento',
	   FLOOR(CAST(DATEDIFF(DAY, e.BirthDate, GETDATE()) / 365.25 AS NUMERIC(9,2))) AS 'a�os'
FROM Employees AS e
ORDER BY a�os ASC
GO

/* FUNCI�N GetUTCDate

La funci�n GetUTCDate muestra la hora de acuerdo al meridiano de Greenwich, que es el
meridiano a partir del cual se miden las longitudes. El equipo donde se ha ejecutado 
las instrucciones se encuentra ubicado en la zona horario (UTC-05:00) Bogot�, Lima, 
Quito, Rio Branco.

La instrucci�n siguiente muestra la fecha actual usando GetDate, el resultado de 
GetUTCDate y la fecha actual sum�ndole las 5 horas de diferencia seg�n la zona horario
de Per�, que es la configuraci�n del equipo desde donde se publican los art�culos
de esta p�gina.
*/

SELECT  GETDATE() AS 'fecha actual',
		GETUTCDATE() AS 'fecha UTC',
		DATEADD(HOUR, 5, GETDATE()) AS 'fecha actual m�s 5 horas'
GO