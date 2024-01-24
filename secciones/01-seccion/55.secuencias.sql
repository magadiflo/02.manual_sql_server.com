/*-- SECUENCIAS EN SQL SERVER --

Se puede definir una secuencia como un conjunto de valores que parten de un valor inicial, tienen un incremento
o decremento, lo que significa que la secuencia puede ser ascendente o descendente y pueden tener un valor final. 
Además se poder crear secuencias cíclicas, es decir, secuencias que al llegar a su valor final se reinician a 
su valor inicial.

SQL Server permite la creación de secuencias que pueden ser utilizadas para la generación de códigos en las tablas. 
Lo más importante de las secuencias es que no están ligadas a ningún campo en una tabla.

TIPOS DE DATOS PERMITIDOS EN SECUENCIAS
El tipo de dato de la secuencia es un dato Entero, los tipos de datos permitidos son

tinyint – Rango 0 to 255
smallint – Rango -32,768 to 32,767
int – Rango -2,147,483,648 to 2,147,483,647
bigint – Rango -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 Este es el tipo de dato por defecto.
decimal y numeric con una escala de CERO.
Un tipo de dato definido por el usuario creado en base a los tipos anteriores.

LA PROPIEDAD IDENTITY
- Identity es una propiedad que permite que un campo de tipo int en una tabla incremente su valor de manera automática
  al insertar los registros en ella.
- Para el uso de la propiedad Identity el tipo de dato debe ser entero Int.
- Es necesario definir un valor inicial y un valor de incremento.
- Es importante anotar que Identity no asegura la unicidad de valor, esta únicamente es posible con la restricciones
  Primary key, Unique o con el índice Unique.
- Solamente puede existir una columna por tabla con la propiedad Identidad. 

SECUENCIA VS. IDENTITY
En SQL Server se debe usar una secuencia en lugar de la propiedad Identity en los siguientes casos:

- La aplicación requiere obtener el valor antes de insertar el registro.
- La aplicación requiere compartir series de números entre multiples tablas o multiples columnas en las tablas.
- La aplicación requiere reiniciar el valor de la serie con un valor especíifico. Por ejemplo, reiniciar una
  secuencia que fue creada desde 1 hasta 100 con los mismos valores.
- La aplicación requiere valores que son ordenados por otro campo.
- La instrucción «NEXT VALUE FOR function» puede aplicarse la cláusula Over en la función de llamada.
- Una aplicación requiere multiples valores asignados al mismo tiempo. Por ejemplo, una aplicación necesita 
  obtener tres números seguidos al mismo tiempo.

CREACIÓN DE UNA SECUENCIA

CREATE SEQUENCE [Esquema.]NombreDeSecuencia
[AS [TipoEntero | TipoEnteroDefinidoPorElUsuario]]
[START WITH]
[INCREMENT BY]
[{MINVALUE[]} | {NO MINVALUE}]
[{MAXVALUE[]} | {NO MAXVALUE}]
[CYCLE | {NO CYCLE}]

Donde
NombreDeSecuencia: es el nombre de la secuencia a crear.
TipoEntero: Tipo de dato entero de SQL Server. La tabla está definida líneas arriba.
TipoEnteroDefinidoPorElUsuario: Tipo de dato definido por el usuario en base a los números enteros de SQL Server. 
Start With: define el valor inicial
Increment by: Define el incremento o decremento.
MinValue: Especifica el valor mínimo, por defecto es CERO para el tipo tinyint y un valor negativo 
          para el resto de tipos.
MaxValue: Especifica el valor máximo. El valor por defecto está definido de acuerdo al valor máximo 
          del tipo de dato entero.
Cycle: Permite que la secuencia se reinice cuando llega a su valor mínimo o máximo, dependiendo si 
          es ascendente o descendente.
*/
USE Northwind
GO

/*EJERCICIO 01. Crear una secuencia con valores por defecto*/
CREATE SEQUENCE valores_por_defecto
GO

--Para visualizar los datos de la secuencia
SELECT name, start_value, increment, maximum_value, minimum_value, is_cycling, type, system_type_id, current_value
FROM SYS.SEQUENCES 
WHERE name = 'valores_por_defecto'
GO

--Note que el ID dewl tipo de dato es 127, para visualizar el tipo de dato
SELECT * 
FROM SYS.TYPES 
WHERE system_type_id = 127
GO

--Para obtener el valor inicial de acuerdo al tipo de dato bigint. Tenga en cuenta que al ejecutar
--la siguiente instrucción, el valor de la secuencia se va incrementando en 1
SELECT NEXT VALUE FOR valores_por_defecto
GO

/*EJERCICIO 02. Crear una secuencia llamada equipo_basquet que inicia en 1 y termina en 12*/
CREATE SEQUENCE equipo_basquet
AS INT
START WITH 1 
INCREMENT BY 1
MINVALUE 1
MAXVALUE 12
CYCLE
GO

/*Visualizar los valores, ejecute más de 12 veces la siguiente instrucción.
Note que al llegar al valor máximo, se reinicia el valor mínimo por la especificación de la cláusula CYCLE*/
SELECT NEXT VALUE FOR equipo_basquet
GO

--Eliminar la secuencia
DROP SEQUENCE equipo_basquet
GO

/*EJERCICIO 03. Crear una secuencia que permita especificar el código para los departamentos en una empresa*/
CREATE SEQUENCE sec_departamentos
AS TINYINT
START WITH 1
INCREMENT BY 1
GO

--Crear la tabla departamentos
CREATE TABLE departamentos(
	codigo TINYINT, 
	descripcion VARCHAR(150),
	CONSTRAINT pk_departamentos PRIMARY KEY(codigo)
)
GO

--Usar la secuencia para obtener el valor para el código usando NEXT VALUE FOR ... 
INSERT INTO departamentos(codigo, descripcion)
VALUES(NEXT VALUE FOR sec_departamentos, 'Gerencia General')
GO

INSERT INTO departamentos(codigo, descripcion)
VALUES(NEXT VALUE FOR sec_departamentos, 'Producción')
GO

INSERT INTO departamentos(codigo, descripcion)
VALUES(NEXT VALUE FOR sec_departamentos, 'Contabilidad')
GO

--Consultando la tabla departamentos
SELECT * FROM departamentos
GO

/*MODIFICACIÓN DE UNA SECUENCIA

Modifica los argumentos de una secuencia existente
IMPORTANTE: Para cambiar el tipo de dato numérico de la secuencia, esta debe eliminar y luego volver a
crear con el nuevo tipo

Sintaxis:
ALTER SEQUENCE [Esquema. ] NombreDeSecuencia
[ RESTART [ WITH ] ]
[ INCREMENT BY ]
[ { MINVALUE } | { NO MINVALUE } ]
[ { MAXVALUE } | { NO MAXVALUE } ]
[ CYCLE | { NO CYCLE } ]
Donde:
NombreDeSecuencia: es el nombre de la secuencia a modificar.
Restart With: define el valor en el que reiniciará la secuencia.
Increment by: Define el incremento o decremento.
MinValue: Especifica el valor mínimo, por defecto es CERO para el tipo tinyint y un valor negativo para 
el resto de tipos.
MaxValue: Especifica el valor máximo. El valor por defecto está definido de acuerdo al valor máximo del tipo 
de dato entero. 
Cycle: Permite que la secuencia se reinice cuando llega a su valor mínimo o máximo, dependiendo si es ascendente 
o descendente.

EJERCICIO 04. Crear una secuencia con valores por defecto y luego modificarla para que su valor inicial
sea 10 y se incremente de 5 en 5
*/
CREATE SEQUENCE sec_prueba_cambio
GO

ALTER SEQUENCE sec_prueba_cambio
RESTART WITH 10
INCREMENT BY 5
GO


--Visualiza los valores de la secuencia
SELECT name, start_value, increment, maximum_value, minimum_value, is_cycling, type, system_type_id, current_value
FROM SYS.SEQUENCES 
WHERE name = 'sec_prueba_cambio'
GO


/*ELIMINAR UNA SECUENCIA

Instrucción Drop Sequence
Elimina una secuencia de la base de datos
Sintaxis:
Drop sequence [Esquema.]NombreSecuencia
Donde:
Esquema: es el nombre del esquema donde se encuentra la secuencia. (Ver esquemas)
NombreSecuencia: nombre de la secuencia a eliminar.
*/
DROP SEQUENCE sec_prueba_cambio
GO