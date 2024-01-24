/*-- ENCRIPTAR Y DESENCRIPTAR DATOS --

La importancia de proteger los datos es una actividad que no se debe descuidar, cuando se guarda 
informaci�n en las tablas, algunos datos no deben ser f�cilmente accesibles y si de alguna forma 
se pueden acceder a estos, deben en los posible presentarse de manera encriptada.

TIPO DE DATO BINARIOS
Los tipos de datos binarios permiten guardar datos en un formato que se muestra diferente al texto
plano, estos datos tienen una longitud fija (binary) y longitud variable (varbinary)

ENCRIPTANDO LOS DATOS
Existen varias formas de guardar los datos encriptador en las tablas, se pueden usar diversos algoritmos 
o se pueden crear y generar los propios. Por ejemplo, puede generar datos encriptados usando 
Visual Studio .Net y el algoritmo MD5.

Para este ejercicio utilizaremos las funciones de SQL Server para guardar los datos en formato binario, 
para ello se puede usar la funci�n EncryptByPassPhrase para encriptar y para desencriptar se utiliza 
la funci�n DecryptByPassPhrase.

Para poder mostrar los datos sin encriptar se utilizar� Cast para convertir el tipo de dato. 

FUNCI�N ENCRYPTBYPASSPHRASE
Permite encriptar datos asignando una clave de tipo texto.

SINTAXIS
ENCRYPTBYPASSPHRASE('fraseClave', 'Texto a encriptar')

DONDE: 
fraseClave: se utilizar� como clave sim�trico para poder desencriptar
texto a encriptar: texto plano a encriptar

FUNCI�N DECRYPTBYPASSPHRASE
Permite desencriptar datos, es encesario dar la clave sim�trica asignada al momento de encriptar

SINTAXIS
DECRYPTBYPASSPHRASE('fraseClave', 'Texto a desencriptar')

DONDE: 
fraseClave: es la clave sim�trica utilizada para encriptar
texto a desencriptar: texto a desencriptar

/*IMPORTANTE: Los campos donde se guardar�n los datos deben ser de tipo binarios(VARBINARY)*/
*/

USE Northwind
GO

--Crear una tabla para usuarios, donde se encriptar� tanto el nombre de usuario como su password
CREATE TABLE usuarios(
	codigo CHAR(4),
	nombre VARBINARY(200),
	password VARBINARY(200),
	CONSTRAINT pk_usuarios PRIMARY KEY(codigo)
)
GO

--Insertar los siguiente registros
INSERT INTO usuarios
VALUES('0102',	ENCRYPTBYPASSPHRASE('ClaveUsuarios', 'trainersql'), 
				ENCRYPTBYPASSPHRASE('ClaveUsuarios', 'Bum2020'))
GO

--Listar el registro para visualizar los datos encriptados
SELECT * FROM usuarios
GO

--Si desea listar los registros con los datos desencriptados
SELECT codigo, CAST(DECRYPTBYPASSPHRASE('ClaveUsuarios', nombre) AS VARCHAR(MAX)) AS 'Nombre',
			   CAST(DECRYPTBYPASSPHRASE('ClaveUsuarios', password) AS VARCHAR(200)) AS 'Password'
FROM usuarios
GO

--Si el texto usado como clave sim�trica no es el correcto, muestra NULL en los campos encriptados.
SELECT codigo, CAST(DECRYPTBYPASSPHRASE('NoEsLaClave', nombre) AS VARCHAR(MAX)) AS 'Nombre',
			   CAST(DECRYPTBYPASSPHRASE('NoEsLaClave', password) AS VARCHAR(200)) AS 'Password'
FROM usuarios
GO