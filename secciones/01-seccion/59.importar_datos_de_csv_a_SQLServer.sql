/*-- IMPORTAR DATOS DE ARCHIVO CSV --

En muchas organizaciones se tienen los datos en archivos de Microsoft Excel, estos datos son necesarios 
cargarlos en las bases de datos creadas en SQL Server. En este artículo se explica como importar los 
datos de un archivo de Microsoft Excel guardado en formato CSV (Comma Separated Value) a una tabla en 
una base de datos de SQL Server.

GUARDAR LOS DATOS EN FORMATO CSV EN MICROSOFT EXCEL

Los datos guardados en un archivo de Microsoft Excel se pueden importar a una tabla en una base de datos 
de SQL Server, para guardar el archivo en formato CSV debe seleccionar Guardar como y en la lista de 
formatos seleccionar «CSV (delimitados por comas)(*.csv)«.

La imagen muestra el archivo de Microsoft Excel a utilizar para este artículo
codigo	prenombre	apellido	nombre	direccion	pais	ciudad	cargo
1	Ms.	Davolio	Nancy	507 - 20th Ave. E. Pt. 2A	USA	Seattle	Sales Reresentative
2	Dr.	Fuller	Andrew	908 W. Capital Way	USA	Tacoma	Vice President, Sales
3	Ms.	Leverling	Janet	722 Moss Bay Bld.	USA	Kirkland	Sales Reresentative
4	Mrs.	Peacock	Margaret	4110 Old Readmond Rd.	USA	Redmond	Sales Reresentative
5	Mr.	Buchan	Steven	14 Garredtt Hill	UK	London	Sales Reresentative
6	Mr.	Suyama	Michael	Covenry House Miner Rd.	UK	London	Sales Manager
7	Ms.	King	Robert	Edgeham Hollow Winchester Way	UK	London	Sales Manager
8	Ms.	Callahan	Laura	4726 - 11th Ave. N.E.	USA	Seattle	Sales Reresentative
9	Ms.	Dodwhorth	Anne	7 Houndstooth Rd.	UK	London	Inside Sales Coordinator


Luego pulsar Archivo, Guardar Como, el tipo debe ser el mostrado en la imagen
(formato CSV debe seleccionar Guardar como y en la lista de formatos seleccionar 
"CSV (delimitados por comas)(*.csv)")

Al guardar el archivo, el ícono se muestra como la figura siguiente (con una letra a)

ASISTENTE PAR AIMPORTAR ARCHIVOS CVS A SQLSERVER

Paso 1: Para importar los datos de un archivo guardado en formato CSV, seleccionar la 
base de datos que para el ejemplo es Northwind y luego pulsar botón derecho, seleccionar 
Tasks y luego Import Flat File. La imagen muestra la opción a seleccionar.

Aparece la pantalla con los pasos del asistente. Pulsar Next.

Paso 2: Seleccionar el archivo con formato CSV, use el botón Browse para seleccionarlo, 
escribir el nombre de la nueva tabla, por defecto aparece el nombre del archivo y el 
esquema donde se va a incluir. Para el ejemplo el archivo se llama EmpleadosCSV.csv 
ubicado en la carpeta E:\DatosCSV. Pulsar Next.

Aparece una ventana de vista previa. Pulsar Next.

Paso 3: Modificar las columnas de acuerdo a las necesidades. Pulsar Next.

Paso 4: Aparece un resumen, pulsar Finish.

Aparece el resultado, debería aparecer el mensaje de operación completada. Pulsar Close.
*/
USE Northwind
GO

SELECT * FROM EmpleadosCSV
GO