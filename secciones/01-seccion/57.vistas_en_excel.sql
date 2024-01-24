/*-- MOSTRAR VISTAS EN EXCEL --

Una de las mejores soluciones para los usuarios de la organizaci�n que requieran de informaci�n de la base de 
datos es crearles una vista y luego presentar esta en Excel. 
No es necesario posiblemente crear un sistema para una consulta, basta con crear un inicio de sesi�n, luego 
crearle un usuario de base de datos y asignar el permiso de lectura de la vista.

La vista en Excel va a mantener una conexi�n con la base de datos, de esta manera el usuario cuando abra 
el archivo con la vista presente en la base de datos de SQL Server podr� tener la informaci�n en tiempo 
real y actualizada.

El usuario para que pueda mostrar los datos reales de la base de datos debe actualiza la vista, para ello 
puede pulsar bot�n derecho en cualquier celda de la vista y seleccionar Actualizar.

En este art�culo se ense�ar� a visualizar en Excel una vista creada en SQL Server.
*/

USE Northwind
GO

--Crear una vista con los productos, su categor�a y proveedor
CREATE VIEW v_productos_cateogria_proveedor
AS
	SELECT p.ProductID AS 'C�d. Producto', p.ProductName AS 'Descripci�n', p.UnitPrice AS 'Precio',
	       p.UnitsInStock AS 'Stock', c.CategoryName AS 'Categor�a', s.CompanyName AS 'Proveedor'
	FROM Products as p
		INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
		INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
GO

/*Para visualizar en Microsoft Excel esta vista, se deber�a crear un inicio de sesi�n y un usuario
al cual se le debe dar el acceso para visualizar la vista, y poder conectarse a SQL Server.

El procedimiento apra mostrar la vista en Excel es el siguiente:

1. Abrir Microsoft Excel, ir a  la opci�n Datos del men�, en el grupo "Obtener datos externos", 
desplegar el bot�n "de otras fuentes" y seleccionar desde SQL Server

2. Aparece la ventana para autenticarse, se debe escribir el nombre del servidor y la instancia 
a la que se va a conectar, especificar tambi�n las credenciales de conexi�n, puede ser Windows o 
de manera correcta y mas segura, especificar el Nombre de usuario y Contrase�a de un Inicio de 
Sesi�n de SQL Server. Luego pulsar Siguiente.

3. Una vez conectado al servidor se debe seleccionar la base de datos y seleccionar la vista
que se desea mostrar en Excel. Pulsar Siguiente.

4. Luego escribir una descripci�n adecuada para la conexi�n creada entre Excel y la vista 
seleccionada. Pulsar Finalizar.

5. Aparece la ventana para especificar la forma de como se presentar� la vista de SQL Server en Excel. 
Se recomienda que sea incluida como tabla. Adem�s seleccionar la celda de la esquina superior izquierda
desde donde se mostrar� el contenido de la vista. Pulsar Aceptar para mostrar los datos.

6. La apariencia final de la vista podr�a ser como la imagen siguiente. Note que se ha asignado una
etiqueta a la hoja adem�s de asignar un t�tulo a la vista. Adem�s se ha desactivado el filtro autom�tico.

Al actualizar los datos con los de la base de datos desde Excel, se debe pulsar bot�n derecho en cualquier
celda de la lista y luego elegir la opci�n Actualizar.


NOTAS ADICIONALES
- No cree m�s de una consulta en una hoja de Excel, es preferible una consulta en cada hoja.
- Puede administrar las conexiones de las diferentes vistas mostradas en Excel usando el bot�n
  Conexiones de la opci�n Datos del men� de Excel.
- El archivo de Excel puede transportarse a otro equipo, al abrirlo perder� la conexi�n con el origen de datos.
*/