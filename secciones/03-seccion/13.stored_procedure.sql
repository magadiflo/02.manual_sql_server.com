/*-- PROCEDIMIENTOS ALMACENADOS SQL SERVER --

Un procedimiento almacenado son instrucciones T-SQL almacenadas con un nombre en la base de datos.
Los procedimientos almacenados se pueden utilizar para: 

-Devolver un conjunto de resultados, se puede incluir parámetros de entrada para especificar el filtro 
 del conjunto resultado.
- Ejecutar instrucciones de programación
- Devolver valores numéricos que permiten realizar acciones cuando un grupo de instrucciones se realizó 
  con éxito o no.

Ventajas del uso de procedimientos almacenados
- Reutilización de código
  El encapsulamiento en un procedimiento es óptimo para reutilizar su código. Se elimina la necesidad de 
  escribir el mismo código, se reducen  inconsistencias en el código y permite que cualquier usuario ejecute 
  el código aún sin tener acceso a los  objetos que hace referencia.

- Mayor seguridad
  Se pueden ejecutar SP con instrucciones que hacen referencia a objetos que los usuarios no tienen permisos. 
  El procedimiento realiza la ejecución del código y todas las instrucciones y controla el acceso a los  
  objetos a los que hace referencia. Esto hace mas sencillo la asignación de permisos. Se puede implementar 
  la suplantación de usuarios usando Exexute As. Existe un nivel fuerte de encapsulamiento.

- Tráfico de red reducido
  Un SP se ejecuta en un único lote de código. Esto reduce el tráfico de red cliente servidor porque 
  únicamente se envía a través de la red la llamada que ejecuta el SP. La encapsulación del código del 
  SP permite que viaje a través de la red como un solo bloque.

- Mantenimiento más sencillo
  Se puede trabajar en los aplicativos en base a capas, cualquier cambio en la Base de datos, hace sencillo 
  los cambios en los procedimientos que hacen uso de los objetos cambiados en la BD.

- Rendimiento mejorado
  Los procedimientos almacenados se compila la primera vez que se ejecutan y crean un plan de ejecución que 
  vuelve a usarse en posteriores ejecuciones.

TIPOS DE PROCEDIMIENTOS
- Definidos por el usuario
  Se crea por el usuario en las bases de datos definidas por el usuario o en las de sistema 
  (Master, Tempdb, Model y MSDB)

- Procedimientos almacenados temporales
  Los procedimientos temporales son procedimientos definidos por el usuario, estos se almacenan en tempdb.  
  Existen dos tipos de procedimientos temporales: locales (primer caracter es #) y globales 
  (primer caracter ##).  Se diferencian entre sí por los nombres, la visibilidad y la disponibilidad.
  Los procedimientos temporales locales tienen como primer carácter de sus nombres un solo signo de número(#)
  solo son visibles en la conexión actual del usuario y se eliminan cuando se cierra la conexión.  
  Los procedimientos temporales globales presentan dos signos de número (##) antes del nombre;  
  o pueden usar todos los usuarios conectados, se eliminan cuando se desconectan todos los usuarios.

- Procedimientos almacenados del sistema
  Los procedimientos del sistema son propios de SQL Server. Los caracteres iniciales de estos procedimientos
  son sp_ la cual no se recomienda para los procedimoentos almacenados definodos por le usuario.

- Extendidos definidos por el usuario
  Los procedimoentos extendidos tienen instrucciones externas en un lenguaje de programación como puede ser C.
  Estos procedimoentos almacenados son DDL que uns instancia de SQL Server puede cargar y ejecutar
  dinámicamente

Sintaxis
Para crear un procedimiento almacenado se utiliza
Create procedure NombreProcedimiento(@PrimerParametro TipoDato, @SegundoParametro TipoDato,…)
As
Instrucciones del SP
go

Para modificar un SP
Alter procedure NombreProcedimiento(@PrimerParametro TipoDato, @SegundoParametro TipoDato,… cambios)
As
Instrucciones del SP con cambios
go

Eliminar un SP
Drop procedure NombreProcedimiento
go

Para listar los SP
select * from sys.procedures
go
*/
USE Northwind
GO

--Procedimiento para listar los productos
CREATE PROCEDURE sp_lista_productos
AS
	BEGIN
		SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock
		FROM Products AS p
	END
GO

--Ejecuta el sp cread
EXECUTE sp_lista_productos
GO

--Procedimiento para insertar un registro en la tabla Shippers
--La instrucción para insertar un Shipper es: 
CREATE PROCEDURE sp_shippers_inserta(@companyName VARCHAR(40), @phone VARCHAR(24))
AS
	BEGIN
		INSERT INTO Shippers(CompanyName, Phone)
		VALUES(@companyName,@phone)
	END
GO

--Ejecuta el SP, se puede ejecutar de las siguientes formas: 
--PRIMERA FORMA
EXECUTE sp_shippers_inserta 'Chasqui', '87545852'
GO

--SEGUNDA FORMA
EXECUTE sp_shippers_inserta @phone = '8569556', 
							@companyName = 'Ford'
GO

EXECUTE sp_shippers_inserta @companyName = 'Turbo XD',
							@phone = '345435645'
GO
							
--Procedimiento para el listado de productos de una determinada categoría
CREATE PROCEDURE sp_productos_listado_por_cateogria(@categoria_id INT)
AS
	BEGIN
		SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, p.UnitsOnOrder 
		FROM Products AS p
		WHERE p.CategoryID = @categoria_id
	END
GO

--Ejecuta el SP
EXECUTE sp_productos_listado_por_cateogria 6
GO

--Modificar el procedimiento del listado de productos que muestre ordenados por precio descendente
ALTER PROCEDURE sp_productos_listado_por_cateogria(@categoria_id INT)
AS
	BEGIN
		SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, p.UnitsOnOrder 
		FROM Products AS p
		WHERE p.CategoryID = @categoria_id
		ORDER BY p.UnitPrice DESC
	END
GO

--Procedimiento para crear una tabla con los productos de una determinada categoría
CREATE PROCEDURE sp_crear_tabla_productos_categoria(@categoriaid INT)
AS
	BEGIN
		DECLARE @nombre_tabla VARCHAR(40), 
				@drop_tabla_tsql VARCHAR(100),
				@crear_tabla_tsql VARCHAR(100),
				@categoria_id VARCHAR(10)
		
		SET @categoria_id = LTRIM(STR(@categoriaid))
		SET @nombre_tabla = 'productos_de_categoria_' + @categoria_id
		SET @drop_tabla_tsql = 'DROP TABLE ' + @nombre_tabla
		SET @crear_tabla_tsql = 'SELECT * INTO ' + @nombre_tabla + ' FROM Products WHERE CategoryID = ' + @categoria_id

		IF EXISTS(SELECT * FROM SYS.TABLES WHERE NAME = @nombre_tabla)
			BEGIN
				EXECUTE(@drop_tabla_tsql)
			END

		EXECUTE(@crear_tabla_tsql)
	END
GO

--Ejecutar para la categoría 3
EXECUTE sp_crear_tabla_productos_categoria 3
GO

--Ver los registros
SELECT * FROM productos_de_categoria_3
GO