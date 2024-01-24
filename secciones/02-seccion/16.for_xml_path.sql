/*-- USO DE FOR XML PATH EN SQL SERVER --

Una consulta Select (Ver Select) se puede mostrar en formato XML (Ver Campos XML), utilizando la opción 
FOR XML, la cual tiene varios modos, uno de estos es el modo PATH.

PRESENTANDO LOS REGISTROS USANDO FOR XML PATH
- Al usar esta opción se pueden extraer los datos de una consulta en formato XML, el que es muy necesario
  en muchas aplicaciones.
- Los nombres de campos o los alias de la consulta se van a convertir en etiquetas XML
- Proporciona una forma sencilla de mostrar los elementos de un campo de una tabla separados por un caracter
  que generalmente es la coma.
- El modo PATH de la opción For XML es una forma sencilla de introducir un anidamiento adicional para
  representar propiedades complejas.
*/

USE Northwind
GO

/*EJERCICIO 01. Listar los proveedores (Suppliers) en formato XML */
SELECT * 
FROM Suppliers
FOR XML PATH
GO
--Note que el resultado tiene formato XML
--Para cada registro de la tabla la opción FOR XML PATH incluye la etiqueta ROW

/*EJERCICIO 02. Mostrar las categorías*/
SELECT c.CategoryID AS 'codigo', c.CategoryName AS 'categoria', c.Description AS 'descripcion' 
FROM Categories AS c
FOR XML PATH
GO

--Note que se muestran las etiquetas XML de acuerdo a los alias utilizados en la consulta

/*EJERCICIO 03. Mostrar los empleados, para cada registro se ha especificado la etiqueta empleado, 
utilizando la cláusula PATH*/
SELECT e.EmployeeID AS 'codigo', e.LastName AS 'apellido', e.FirstName AS 'nombre', e.Country AS 'pais'
FROM Employees AS e
FOR XML PATH('empleado')
GO

/*Al pulsar clic en el enlace para abrir el archivo XML se muestran etiquetas XML de acuerdo a los alias
utilizados en la búsqueda, note que cada empleado tiene la etiqueta XML especificada en la cláusula Path.
Si dentro de los paréntesis en la cláusula Path se especifica una cadena de caracteres vacia Path(»), los
registros no se separan.
*/

/*EJERCICIO 04. Mostrar los productos, el código del producto se va a especificar como una propiedad de la
etiqueta Producto*/
SELECT p.ProductID AS '@codigo', -- <--- este campo será propiedad de la etiqueta producto por el @
	   p.ProductName AS 'descripcion',
	   p.UnitPrice AS 'precio',
	   p.UnitsInStock AS 'stock'
FROM Products AS p
FOR XML PATH('producto')
GO

/*En el listado anterior se puede incluir un nivel superior para agurpar los productos usando la cláusula
ROOT*/
SELECT p.ProductID AS '@codigo',
	   p.ProductName AS 'descripcion',
	   p.UnitPrice AS 'precio',
	   p.UnitsInStock AS 'stock'
FROM Products AS p
FOR XML PATH('producto'), ROOT('productos')
GO

/*EJERCICIO 05. Este ejercicio va a mostrar cómo usar la opción FOR XML PATH para generar un conjunto de
valores separados por coma con los datos de una columna. El diagrama siguiente muestra la programación
de cursos de capacitación de un sistema para un centro de certificación.*/
USE bd_prueba_ties -- <-- Reutilizaremos una bd cualquiera
GO

CREATE TABLE cursos(
	codigo CHAR(5),
	descripcion VARCHAR(50) NOT NULL,
	ambiente VARCHAR(50),
	hora_inicio TIME,
	cantidad_horas NUMERIC(9,2),
	dia_semana VARCHAR(10),
	CONSTRAINT pk_cursos PRIMARY KEY(codigo)
)
GO

--Insertar los cursos
INSERT INTO cursos VALUES
('SS005','SQL Server DBA','Aula DBA','8:00',4,'Lunes'),
('SS151','SQL Server DBA','Aula DBA','8:00',4,'Miércoles'),
('SS645','SQL Server DBA','Aula DBA','8:00',4,'Viernes'),
('SS890','SQL Server DBA','Aula DBA','8:00',4,'Sábado'),
('OE045','Experto MOS 2019','Aula Office','4:00',3,'Martes'),
('OE109','Experto MOS 2019','Aula Office','4:00',3,'Jueves'),
('OE456','Experto MOS 2019','Aula Office','4:00',3,'Sábado')
GO

--El listado de los cursos es como sigue
SELECT * FROM cursos
GO

/*Si desea mostrar las ofertas de los cursos y los días de la semana separados por coma.
Para esto se va a utsar una subconsulta de los días de la semana separados por coma. 
La función STUFF quita la coma al inicio del resultado
*/
SELECT STUFF((SELECT ',' + c.dia_semana 
			  FROM cursos AS c 
			  FOR XML PATH('')), 1, 1, ''
			 ) AS 'dias' 
GO

--Ahora vamos a listar los cursos con los días de la semana
SELECT DISTINCT c.descripcion, c.ambiente, c.hora_inicio, c.cantidad_horas,
	STUFF((SELECT ',' + d.dia_semana 
		   FROM cursos AS d
		   WHERE d.descripcion = c.descripcion
		   FOR XML PATH('')), 1, 1, ''
		  ) AS 'dias'
FROM cursos AS c
GO

/*EJERCICIO 06. Listar los empleados y las órdenes generadas*/
USE Northwind
GO

SELECT DISTINCT e.LastName AS 'apellido', e.FirstName AS 'nombre',
	   STUFF((SELECT ',' + TRIM(STR(ord.OrderID)) 
	    FROM Orders AS ord
		WHERE ord.EmployeeID = e.EmployeeID
		FOR XML PATH('')), 1, 1, '') AS 'ordenes'
FROM Employees AS e
	INNER JOIN Orders AS o ON(e.EmployeeID = o.EmployeeID)
GO

/*EJERCICIO 07. Listar los proveedores y los productos que provee*/
SELECT DISTINCT s.CompanyName AS 'proveedor', s.Country AS 'pais',
	   STUFF((SELECT ',' + pp.ProductName
			  FROM Products AS pp
			  WHERE pp.SupplierID = p.SupplierID
			  FOR XML PATH('')), 1, 1, '') AS 'productos'
FROM Suppliers AS s 
	INNER JOIN Products p ON(s.SupplierID = p.SupplierID)
ORDER BY s.CompanyName
GO

--Ésto se puede mostrar tambén usando la función STRING_AGG de SQL SERVER 2017
SELECT DISTINCT s.CompanyName AS 'proveedor', s.Country AS 'pais',
       STRING_AGG(p.ProductName, ',') 
	   WITHIN GROUP(ORDER BY p.ProductName ASC) AS 'productos'	   
FROM Suppliers AS s 
	INNER JOIN Products p ON(s.SupplierID = p.SupplierID)
GROUP BY s.CompanyName, s.Country
ORDER BY s.CompanyName
GO

--El resultado es idéntico al de la orden anterior.