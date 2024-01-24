/*-- INSERTAR DOCUMENTOS EN FORMATO PDF EN UNA TABLA

En algunos escenarios y sistemas es necesario guardar documentos ya sean en formato de procesador 
de texto como en formato PDF. Es posible que se pueda guardar el documento en una carpeta y luego 
en un sistema trabajar con estos.

En este artículo se explica brevemente como guardar archivos en formato PDF en una tabla dentro de
una base de datos desde Microsoft SQL Server Management Studio. La forma de como guardarlo desde 
cualquier aplicación es usando un Store Procedure, el documento 
será incluido como una parámetro de tipo Image guardado en un campo Image.

EJERCICIO
*/
CREATE DATABASE bd_tramite_documentario
GO

USE bd_tramite_documentario
GO

-- Crear la tabla para guardar los documentos
CREATE TABLE documentos(
	codigo CHAR(3),
	pdf IMAGE	
)	
GO

/*Al usar Microsoft SQL Server Managament Studio se debe guardar previamente el documento
en una carpeta, en este ejercicio se tiene el documento llamado "Manual-TypeScript.pdf"
en la unidad D:\PROGRAMACION\LIBROS\TYPESCRIPT, la instrucción para guardar el documento en
la tabla documentos es similar al guardar imágenes

INSERTAR EL DOCUMENTO EN LA TABLA DOCUMENTOS
*/
INSERT INTO documentos(codigo, pdf)
SELECT 'G04', *
FROM OPENROWSET(BULK 'D:\PROGRAMACION\LIBROS\TYPESCRIPT\Manual-TypeScript.pdf', SINGLE_BLOB) AS documento
GO

--Ver los registros de la tabla
SELECT * FROM documentos
GO