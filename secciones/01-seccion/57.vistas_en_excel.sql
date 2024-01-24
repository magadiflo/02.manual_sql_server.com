/*-- MOSTRAR VISTAS EN EXCEL --

Una de las mejores soluciones para los usuarios de la organización que requieran de información de la base de 
datos es crearles una vista y luego presentar esta en Excel. 
No es necesario posiblemente crear un sistema para una consulta, basta con crear un inicio de sesión, luego 
crearle un usuario de base de datos y asignar el permiso de lectura de la vista.

La vista en Excel va a mantener una conexión con la base de datos, de esta manera el usuario cuando abra 
el archivo con la vista presente en la base de datos de SQL Server podrá tener la información en tiempo 
real y actualizada.

El usuario para que pueda mostrar los datos reales de la base de datos debe actualiza la vista, para ello 
puede pulsar botón derecho en cualquier celda de la vista y seleccionar Actualizar.

En este artículo se enseñará a visualizar en Excel una vista creada en SQL Server.
*/

USE Northwind
GO

--Crear una vista con los productos, su categoría y proveedor
CREATE VIEW v_productos_cateogria_proveedor
AS
	SELECT p.ProductID AS 'Cód. Producto', p.ProductName AS 'Descripción', p.UnitPrice AS 'Precio',
	       p.UnitsInStock AS 'Stock', c.CategoryName AS 'Categoría', s.CompanyName AS 'Proveedor'
	FROM Products as p
		INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
		INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
GO

/*Para visualizar en Microsoft Excel esta vista, se debería crear un inicio de sesión y un usuario
al cual se le debe dar el acceso para visualizar la vista, y poder conectarse a SQL Server.

El procedimiento apra mostrar la vista en Excel es el siguiente:

1. Abrir Microsoft Excel, ir a  la opción Datos del menú, en el grupo "Obtener datos externos", 
desplegar el botón "de otras fuentes" y seleccionar desde SQL Server

2. Aparece la ventana para autenticarse, se debe escribir el nombre del servidor y la instancia 
a la que se va a conectar, especificar también las credenciales de conexión, puede ser Windows o 
de manera correcta y mas segura, especificar el Nombre de usuario y Contraseña de un Inicio de 
Sesión de SQL Server. Luego pulsar Siguiente.

3. Una vez conectado al servidor se debe seleccionar la base de datos y seleccionar la vista
que se desea mostrar en Excel. Pulsar Siguiente.

4. Luego escribir una descripción adecuada para la conexión creada entre Excel y la vista 
seleccionada. Pulsar Finalizar.

5. Aparece la ventana para especificar la forma de como se presentará la vista de SQL Server en Excel. 
Se recomienda que sea incluida como tabla. Además seleccionar la celda de la esquina superior izquierda
desde donde se mostrará el contenido de la vista. Pulsar Aceptar para mostrar los datos.

6. La apariencia final de la vista podría ser como la imagen siguiente. Note que se ha asignado una
etiqueta a la hoja además de asignar un título a la vista. Además se ha desactivado el filtro automático.

Al actualizar los datos con los de la base de datos desde Excel, se debe pulsar botón derecho en cualquier
celda de la lista y luego elegir la opción Actualizar.


NOTAS ADICIONALES
- No cree más de una consulta en una hoja de Excel, es preferible una consulta en cada hoja.
- Puede administrar las conexiones de las diferentes vistas mostradas en Excel usando el botón
  Conexiones de la opción Datos del menú de Excel.
- El archivo de Excel puede transportarse a otro equipo, al abrirlo perderá la conexión con el origen de datos.
*/