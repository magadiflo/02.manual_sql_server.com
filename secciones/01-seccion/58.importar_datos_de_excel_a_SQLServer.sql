/*-- IMPORTAR DATOS DESDE EXCEL A SQLSERVER --

En organizaciones que no tienen sistemas inform�ticos para el manejo de informaci�n es frecuente el uso de 
Microsoft Excel para tratar de guardar y manejar la informaci�n.

En este art�culo se describe como importar los datos desde Microsoft Excel a SQL Server, recomendando siempre 
que los datos desde Excel se encuentren lo mas normalizados posibles, ordenados y con el formato adecuado para 
poder ser importados.

ORDENAR LOS DATOS EN EXCEL

Para poder importar los datos de manera adecuada, en Microsoft Excel se recomienda lo siguiente:

- Cada dato debe estar en una columna, por ejemplo, los nombres de las personas separarlos en 
  apellido paterno, materno y nombres cada uno en una columna.
- Los t�tulos de las columnas deben ser de una sola fila y de preferencia contener una sola palabra.
- El rango de datos no dede tener columnas en blanco.
- Asignar un nombre adecuado al rango donde se encuentran los datos a importar, este ser� (si no se 
  cambia) el nombre de la tabla temporal de importaci�n en la base de datos de SQL Server.
- Guardar los datos con formato Microsoft Excel 97 � 2003

ASISTENTE PARA IMPORTAR DATOS DE EXCEL A SLQ SERVER
Para este ejercicio tenemos una hoja de Excel con dos rangos de datos como se muestran en la figura,
uno de productos y otro de clientes.

Productos		
codigo	descripcion	precio
A45GT	Escritorio	180
RT45J	Celular		850
YT7SD	Mouse		60

Clientes		
codigo	nombre				fono
2349873	Mart�n D�az			943469626
3564568	Fernando Mendieta	985624174
3564678	Cecilia Oliva		943852589
5345457	Jorge Castro		947748596
4534356	Teresa Polo			943859623

En la ventana del explorador de SQL Server pulsar click drecho en la bd de Northwind, ir a la opci�n 
de task y luego seleccionar import data

Aparece la ventana de inicio del �Asistente de importaci�n/exportaci�n de SQL Server�, pulsar Siguiente.

Seleccionar el origen de datos, �Microsoft Excel�, seleccionar el archivo y la versi�n de Excel 
�Microsoft Excel 97 � 2003�, si el rango tiene los nombres de campo, dejar activada la casilla de 
verificaci�n �La primera fila tiene nombres de columna�. Pulsar Siguiente.

Seleccionar el destino, obviamente �SQL Server Native Cliente xx.x� donde las Xs dependen de la 
versi�n de SQL que se est� utilizando. Tambi�n el modo de autenticaci�n y la base de datos.

Especificar si es copia de tabla o consulta, seleccionar �Copiar los datos de una o varias 
tablas o vistas� y pulsar Siguiente.

Seleccionar las hojas y rangos definidos en Microsoft Excel, seleccionar los nombres de rangos 
definidos para importar. Para este ejercicio se han seleccionados los rangos de Productos y Clientes. 
Si desea puede pulsar el bot�n Editar asignaciones para hacer cambios en las tablas destinos. 
Pulsar Siguiente.

Seleccionar la opci�n �Ejecutar inmediatamente�, note que puede guardar el proceso en un paquete 
de Microsoft SQL Server Integration Services.

Luego aparece el resumen de las opciones de importaci�n. Pulsar Finalizar.

Deber�a aparecer el mensaje de confirmaci�n con todas las opciones en Correcto. Pulsar Cerrar

Al listar las tablas, se pueden ver los datos que estaban en Microsoft Excel y ahora han sido
importados a SQL Server.
*/
USE Northwind
GO


SELECT * FROM productos
GO

SELECT * FROM clientes
GO
