/*-- Tipos de datos en SQL Server --*/
/*
NUM�RICOS EXACTOS
------------------
BIGINT		De -9223372036854775808 a 9223372036854775807	8 bytes
INT			De -2147483648 a 2147483647						4 bytes
SMALLINT	De -32768 a 32767								2 bytes
TINYINT		De 0 a 255										1 byte
BIT			Acepta valores 1, 0, � NULL						2 byte

DECIMAL, NUMERIC, DECIMAL(p,s)

p (precisi�n): el n�mero de d�gitos decimales que se puede almacenar, 
tanto a la izquierda como a la derecha del separador decimal. 
La precisi�n debe ser un valor comprendido entre 1 y la precisi�n 
m�xima de 38. La precisi�n predeterminada es 18. 
s (escala): el n�mero m�ximo de d�gitos decimales que se puede 
almacenar a la derecha del separador decimal. 
La escala debe ser un valor comprendido entre 0 y p. S�lo es 
posible especificar la escala si se ha especificado la precisi�n. 
La escala predeterminada es 0. Con precisi�n m�xima 1038 +1 y 1038 � 1
EJEMPLO:
DECIMAL(8,2), Lo que significa que el n�mero que tenga este tipo
va a tener en total 8 digitos, es decir, como m�ximo 6 para la parte
entera y 2 para la parte decimal.
123456.55  [correcto]
1234567.00 [incorrecto]

MONEY		Desde -922337203685,4775808 a 922337203685,4775807	8 bytes
SMALLMONEY	Desde � 214,7483648 a 214,7483647					4 bytes

NUM�RICOS NO EXACTOS
--------------------
FLOAT
REAL

FECHA Y HORA
--------------------
DATE			De 01/01/01 al 21/12/9999 Almacena fechas			3 bytes
DATETIME		De 01/01/01 al 21/12/9999 Almacena fechas y horas	8 bytes
DATETIME2		De 01/01/01 al 21/12/9999 Almacena fechas y horas 
				con mayor precisi�n.
SMALLDATETIME	De 1 de enero de 1900 hasta el 6 de junio de 2079	4 bytes
TIME			De 00:00:00.0000000 hasta 23:59:59.9999999			5 bytes

CADENAS DE CARACTERES
----------------------
CHAR(n)		Caracteres NO UNICODE de longitud fija, con una longitud
			de n bytes. n debe ser un valor entre 1 y 8000				n bytes
VARCHAR(n)	Caracteres NO UNICODE de longitud variable. n indica que
			el tama�o de almacenamiento m�ximo es de 231-1 bytes		n bytes(aprox)
TEXT		En desuso, sustituido por varchar. Datos NO UNICODE de
			longitud variable con una longitud m�xima de 231-1
			(2147483647) caracteres										max bytes(aprox)

NCHAR(n)	Datos de car�cter UNICODE de longitud fija, con n
			caracteres. n debe estar comprendido entre 1 y 4000			2*n bytes
NVARCHAR(n)	Datos de car�cted UNICODE de longitud variable.
			n indica que el tama�o m�ximo de almacenamiento es de
			231-1bytes													2*n bytes + 2bytes
NTEXT(n)	En desuso, sustituido por NVARCHAR. Datos UNICODE de 
			longitud variable con una longitud m�ximo de
			1073741823 caracteres										2*n bytes
BINARY(n)	Datos binarios de longitud fija con una longitud
			de n bytes. n oscila entre 1 y 8000							n bytes
VARBINARY(n)Datos binarios de longitd variable. n indica que el 
			tama�o de almacenamiento m�ximo es de 231-1 bytes			n bytes
IMAGE		Datos binarios de longitud variable desde 0 hasta 
			231-1 (2147483647) bytes
*/
/*
DIFERENCIAS ENTRE VARCHAR Y NVARCHAR
-------------------------------------
Primero, los NVARCHAR son UNICODE y los VARCHAR no. 
Esto quiere decir que en una columna NVARCHAR, puedo insertar 
sin importar el idioma de la base, por ejemplo, caracteres 
chinos o cir�licos (del idioma Ruso o Ucraniano) 
�Entonces por qu� usar�a VARCHAR en vez de NVARCHAR 
si el segundo es mucho m�s amplio? La respuesta es la segunda diferencia.

Segundo, cada car�cter en los NVARCHAR pesa 2 byte y en 
los VARCHAR pesa 1 byte. Este es el momento en un donde 
un desarrollador dice algo como �Pero no es mucha diferencia� 
y no sabe qu� tan equivocado esta. El problema en general con 
algunos desarrolladores, es que piensan que la base de datos es 
como los sitios web o programas que desarrollan. Asumen que declarar 
una columna NVARCHAR no les va a producir diferencia en performance as� 
como declarar una variable como INT en vez de LONG no les producir�a 
diferencia en Java o .Net.
*/

/*
OTROS TIPOS DE DATOS
----------------------------
CURSOR			Tipo de datos para las variables o para los par�metros 
				de resultado de los procedimientos almacenados que 
				contiene una referencia a un cursor. Las variables creadas 
				con el tipo de datos cursor aceptan NULL
TIMESTAMP		Tipo de dato que expone n�meros binarios �nicos generados
				autom�ticamente en una base de datos. El tipo de datos timestamp
				es simplemente un n�mero que se incrementa y no conserva una
				fecha o una hora
SQL_VARIANT		Tipo de dato que almacena valores de varios tipos de datos
				aceptados en SQL Server, excepto TEXT, NTEXT, IMAGE, 
				TIMESTAMP y SQL_VARIANT
UNIQUEIDENTIFIED Es un GUID (Globally Unique Identifier)
TABLE			Es un tipo de dato especial que se puede utilizar para
				almacenar un conjunto de resultados para su procesamiento
				posterior. TABLE se utiliza principalmente para el 
				almacenamiento temporal de un conjunto de filas 
				devuelto como el conjunto de resultados de una funci�n 
				con valores de tabla
XML				Almacena datos de XML. Puede almacenar instancias de 
				xml en una columna o una variable de tipo xml
*/