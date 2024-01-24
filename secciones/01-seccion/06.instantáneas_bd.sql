/*-- Instant�neas de base de datos SQL Server --*/
/*
Una instant�nea de base de datos en SQL Server es 
una vista est�tica de s�lo lectura de una base de 
datos denominada base de datos de origen. 
Las instant�neas de base de datos siempre reside 
en la misma instancia de servidor que la base de 
datos de origen. Pueden existir varias instant�neas 
de una base de datos.

Ventajas de las instant�neas
----------------------------
- Se pueden usar para informes
- Contienen datos hist�ricos para informes
- Regresar a un determinado punto la base de datos para 
  corregir errores adminsitrativos
- Se pueden usar para efectos de auditoria, dar acceso
  al contenido de la base de datos en un momento
  determinado pero en modo solo lectura
*/

/*EJERCICIO 01. Para crear una instant�nea de bd_empresa
del EJERCICIO 01 PASO 01 del archivo 05.adjuntar_base_datos.sql*/
USE bd_empresa
GO

XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\Instantanea'
GO

CREATE DATABASE bd_empresa_instantanea
ON PRIMARY(
	NAME='bd_empresa_instantanea_pri',
	FILENAME='C:\BD_SQL_SERVER\Instantanea\bd_empresa_pri.ss'
)
AS SNAPSHOT OF bd_empresa
GO

/*EJERCICIO 02. Usando Northwind, crear una instant�nea. 
Se crear� bd_fotos en la carpeta respaldo de la unidad C:*/
USE Northwind
GO

XP_CREATE_SUBDIR 'C:\BD_SQL_SERVER\Respaldo'
GO

CREATE DATABASE bd_fotos
ON
(NAME='Northwind', FILENAME='C:\BD_SQL_SERVER\Respaldo\bd_fotos.mdf')
AS SNAPSHOT OF Northwind
GO

--Note que en ambos ejercicios se ha utilizado la cl�usula AS SNAPSHOT OF