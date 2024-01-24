/*-- USO DE SNIPPETS EN SQL SERVER --

Desde SQL Server 2012 los fragmentos de c�digo se incluyen bas�ndose en el shell de Visual Studio 2010, caracter�stica 
que es muy familiar a los programadores que usan Visual Studio, los fragmentos de c�digo o Snippets fueron creados 
teniendo en cuenta el uso repetido de sentencias T-SQL, como por ejemplo la creaci�n de procedimientos almacenados, 
la creaci�n de Triggers o la creaci�n de Vistas.

Los Snippets hacen mucho m�s eficiente acceder a un bloque de c�digo que contiene los elementos de c�digo comunes, como 
crear un procedimiento almacenado o crear una funci�n para ayudar al desarrollador a construir en la parte superior del 
bloque de c�digo.


Los fragmentos de c�digo o Snippets son bloques de construcci�n de c�digo que el desarrollador puede usar como punto de 
partida al ecribir los scripts T-SQL. Esta caracter�stica puede ayudar a la productividad del desarrollador mientras 
aumenta la reutilizaci�n y estandarizaci�n al permitir al equipo de desarrollo utilizar plantillas existentes o crear y 
personalizar una n ueva.

Los fragmentos de c�digo ayudan a proporcionar una mejor experiencia de edici�n del c�digo T-SQL, pero, adem�s, el 
fragmento es una Plantilla XML que se puede utilizar para el desarrollo para garantizar la coherencia en todo el equipo 
de desarrollo.

Los fragmentos de c�digo pueden caer en cualquiera de estas tres categor�as:

Fragmentos de expansi�n
Fragmentos de sonido envolvente y
Fragmentos personalizados.

Los fragmentos de expansi�n enumeran el esquema com�n de los comandos T-SQL, como Seleccionar, Insertar o Crear Tabla de 
declaraciones.
Los fragmentos de sonido envolvente permiten construcciones como while, if else o begin end.
Los fragmentos personalizados con plantillas personalizadas que se pueden invocar a trav�s del men� de fragmentos de 
c�digo. Puede crear un fragmento personalizado y agregue al servidor importando el fragmento utilizando el Administrador 
de fragmentos de c�digo.
La categor�a de fragmentos personalizados aparecer� en el Administrador de fragmentos de c�digo.

Como usar los fragmentos de c�digo o Snippets
En este art�culo se mostrar� como usar los fragmentos de c�digo existentes,
en otro art�culo se va a mostrar como administrar los mismos.


Agregar un Snippet
Para agregar un Snippet o fragmento de c�digo se procede de la siguiente forma:

1. Pulsar clic en la opci�n Editar (Edit) del men� principal
2. Seleccionar �IntelliSense�
3. Luego �Insertar fragmento de c�digo��
4. Luego Seleccionar el fragmento de c�digo a Insertar
5. Para finalizar, seleccionar la opci�n adecuada del fragmento a insertar, existen fragmentos que c�digo que tienen una 
sola opci�n, obviamente para los que tienen mas de una opci�n se debe seleccionar la adecuada.

TIP: se puede pulsar la combinaci�n de las teclas Ctrl+K y en seguida Ctrl+X para mostrar la lista de snippets disponibles. 
Esto reemplaza a los pasos 1, 2 y 3 descritos anteriormente.
*/

/*Ejercicio 01. Para insertar un snippet para crear un procedimiento almacenado b�sico*/
CREATE PROCEDURE dbo.Sample_Procedure 
    @param1 int = 0,
    @param2 int  
AS
    SELECT @param1,@param2 
RETURN 0
/*
Note que se ha insertado un fragmento de c�digo donde se define un SP con nombre Sample_Procedure, 
tiene dos par�metros y tiene un Select, el usuario debe cambiar y editar el SP de acuerdo a sus requerimientos.
*/

/*Ejercicio 02. Para insertar un Snippet para crear una funci�n definida por el usuario que retorna una tabla.
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
/*Note que se ha insertado un fragmento de c�digo donde se define una funci�n de tabla insertada que por defecto
se llama FunctionName, tiene dos par�metros y tiene un SELECT, el usuario debe cambiar y editar de acuerdo a sus
requerimientos.
*/

/*Ejercicio 03. Para insertar un Snippet para crear un trigger.
El resultado ser�a el siguiente:*/
CREATE TRIGGER TriggerName
ON [dbo].[TableName]
FOR DELETE, INSERT, UPDATE
AS
    BEGIN
		SET NOCOUNT ON
    END

/*Ejercicio 04. Para insertar un Snippet para crear una vista .
El resultado ser�a el siguiente: */
CREATE VIEW dbo.Sample_View
AS
    Select * from dbo.Sample_Table


