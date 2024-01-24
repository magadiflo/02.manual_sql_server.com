/*-- USO DE SNIPPETS EN SQL SERVER --

Desde SQL Server 2012 los fragmentos de código se incluyen basándose en el shell de Visual Studio 2010, característica 
que es muy familiar a los programadores que usan Visual Studio, los fragmentos de código o Snippets fueron creados 
teniendo en cuenta el uso repetido de sentencias T-SQL, como por ejemplo la creación de procedimientos almacenados, 
la creación de Triggers o la creación de Vistas.

Los Snippets hacen mucho más eficiente acceder a un bloque de código que contiene los elementos de código comunes, como 
crear un procedimiento almacenado o crear una función para ayudar al desarrollador a construir en la parte superior del 
bloque de código.


Los fragmentos de código o Snippets son bloques de construcción de código que el desarrollador puede usar como punto de 
partida al ecribir los scripts T-SQL. Esta característica puede ayudar a la productividad del desarrollador mientras 
aumenta la reutilización y estandarización al permitir al equipo de desarrollo utilizar plantillas existentes o crear y 
personalizar una n ueva.

Los fragmentos de código ayudan a proporcionar una mejor experiencia de edición del código T-SQL, pero, además, el 
fragmento es una Plantilla XML que se puede utilizar para el desarrollo para garantizar la coherencia en todo el equipo 
de desarrollo.

Los fragmentos de código pueden caer en cualquiera de estas tres categorías:

Fragmentos de expansión
Fragmentos de sonido envolvente y
Fragmentos personalizados.

Los fragmentos de expansión enumeran el esquema común de los comandos T-SQL, como Seleccionar, Insertar o Crear Tabla de 
declaraciones.
Los fragmentos de sonido envolvente permiten construcciones como while, if else o begin end.
Los fragmentos personalizados con plantillas personalizadas que se pueden invocar a través del menú de fragmentos de 
código. Puede crear un fragmento personalizado y agregue al servidor importando el fragmento utilizando el Administrador 
de fragmentos de código.
La categoría de fragmentos personalizados aparecerá en el Administrador de fragmentos de código.

Como usar los fragmentos de código o Snippets
En este artículo se mostrará como usar los fragmentos de código existentes,
en otro artículo se va a mostrar como administrar los mismos.


Agregar un Snippet
Para agregar un Snippet o fragmento de código se procede de la siguiente forma:

1. Pulsar clic en la opción Editar (Edit) del menú principal
2. Seleccionar «IntelliSense»
3. Luego «Insertar fragmento de código…»
4. Luego Seleccionar el fragmento de código a Insertar
5. Para finalizar, seleccionar la opción adecuada del fragmento a insertar, existen fragmentos que código que tienen una 
sola opción, obviamente para los que tienen mas de una opción se debe seleccionar la adecuada.

TIP: se puede pulsar la combinación de las teclas Ctrl+K y en seguida Ctrl+X para mostrar la lista de snippets disponibles. 
Esto reemplaza a los pasos 1, 2 y 3 descritos anteriormente.
*/

/*Ejercicio 01. Para insertar un snippet para crear un procedimiento almacenado básico*/
CREATE PROCEDURE dbo.Sample_Procedure 
    @param1 int = 0,
    @param2 int  
AS
    SELECT @param1,@param2 
RETURN 0
/*
Note que se ha insertado un fragmento de código donde se define un SP con nombre Sample_Procedure, 
tiene dos parámetros y tiene un Select, el usuario debe cambiar y editar el SP de acuerdo a sus requerimientos.
*/

/*Ejercicio 02. Para insertar un Snippet para crear una función definida por el usuario que retorna una tabla.
El resultado es el siguiente: */
CREATE FUNCTION [dbo].[FunctionName]
(
    @param1 int,
    @param2 char(5)
)
RETURNS TABLE 
AS 
	RETURN
	(SELECT @param1 AS c1,
	       @param2 AS c2)
/*Note que se ha insertado un fragmento de código donde se define una función de tabla insertada que por defecto
se llama FunctionName, tiene dos parámetros y tiene un SELECT, el usuario debe cambiar y editar de acuerdo a sus
requerimientos.
*/

/*Ejercicio 03. Para insertar un Snippet para crear un trigger.
El resultado sería el siguiente:*/
CREATE TRIGGER TriggerName
ON [dbo].[TableName]
FOR DELETE, INSERT, UPDATE
AS
    BEGIN
		SET NOCOUNT ON
    END

/*Ejercicio 04. Para insertar un Snippet para crear una vista .
El resultado sería el siguiente: */
CREATE VIEW dbo.Sample_View
AS
    Select * from dbo.Sample_Table


