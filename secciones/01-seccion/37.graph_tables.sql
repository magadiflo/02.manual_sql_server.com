/*-- GRAPH TABLES EN SQLSERVER --*/
/*
Una base de datos gr�fica es una colecci�n de nodos (o v�rtices) y bordes (o relaciones). 
Un nodo representa una entidad (por ejemplo, una persona o una organizaci�n) y un borde 
representa una relaci�n entre los dos nodos que conecta (por ejemplo, grupos o amigos). 
Tanto los nodos como los bordes pueden tener propiedades asociadas a ellos.

CARACTER�STICAS DE LOS GRAPH TABLES
- Los bordes o las relaciones son entidades de primera clase en una base de datos gr�fica y 
  pueden tener atributos o propiedades asociadas.
- Un solo borde puede conectar de forma flexible varios nodos en una base de datos de gr�ficos.
- Puede expresar la coincidencia de patrones y las consultas de navegaci�n de m�ltiples saltos
  f�cilmente.
- Puede expresar cierre transitivo y consultas polim�rficas f�cilmente.

CU�NDO USAR UNA BASE DE DATOS GR�FICA
No hay nada que una base de datos gr�fica pueda lograr, lo que no se puede lograr utilizando 
una base de datos relacional. Sin embargo, una base de datos gr�fica puede hacer que sea m�s 
f�cil expresar cierto tipo de consultas. Adem�s, con optimizaciones espec�ficas, ciertas 
consultas pueden tener un mejor desempe�o.

FACTORES PARA DECIDIR USAR UNA BASE DE DATOS GR�FICA
- Su aplicaci�n tiene datos jer�rquicos. El tipo de datos HierarchyID se puede usar para 
  implementar jerarqu�as, pero tiene algunas limitaciones. Por ejemplo, no le permite almacenar 
  varios padres para un nodo.
- Su aplicaci�n tiene relaciones complejas de muchos a muchos; A medida que la aplicaci�n 
  evoluciona, se agregan nuevas relaciones.
- Necesitas analizar datos y relaciones interconectadas.

- TABLA NODE -
Una tabla Node representa una entidad en un esquema gr�fico. Cada vez que se crea una tabla Node,
junto con las columnas definidas por el usuario, se crea una columna impl�cita llamada $node_id, 
que identifica de forma exclusiva un nodo dado en la base de datos.

Los valores en $node_id se generan autom�ticamente y son una combinaci�n de object_id de esa 
tabla de nodos y un valor bigint generado internamente. Sin embargo, cuando se selecciona la 
columna $node_id, se muestra un valor calculado en forma de una cadena JSON. Adem�s, $node_id 
es una pseudo columna, que se asigna a un nombre interno con una cadena hexadecimal.

Cuando selecciona $node_id de la tabla, el nombre de la columna aparecer� como 
$node_id_ <Cadena_Hexadecimal>. El uso de nombres de pseudocolumnas en las consultas es la forma 
recomendada de consultar la columna interna $node_id y se debe evitar el uso del nombre 
interno con una cadena hexadecimal.

Se recomienda que los usuarios creen una restricci�n o �ndice �nico en la columna $node_id en el 
momento de la creaci�n de la tabla Node, pero si no se crea una, se crea autom�ticamente un 
�ndice �nico no agrupado predeterminado. Sin embargo, cualquier �ndice en una pseudo columna 
de gr�fico se crea en las columnas internas subyacentes. Es decir, un �ndice creado en la 
columna $node_id, aparecer� en la columna interna graph_id_<Cadena_Hexadecimal>.

- TABLA EDGE -
Una tabla Edge representa una relaci�n en un gr�fico. Los Edge siempre se dirigen y conectan 
dos nodos. Una tabla Edge permite a los usuarios modelar relaciones de muchos a muchos en el 
gr�fico. Una tabla Edge puede tener o no atributos definidos por el usuario. Cada vez que se 
crea una tabla Erge, junto con los atributos definidos por el usuario, se crean tres columnas 
impl�citas en la tabla Edge: 

$edge_id
Identifica de forma exclusiva un Edge dado en la base de datos. Es una columna generada y 
el valor es una combinaci�n de object_id de la tabla de borde y un valor bigint generado 
internamente. Sin embargo, cuando se selecciona la columna $edge_id, se muestra un valor 
calculado en forma de una cadena JSON. $edge_id es una pseudo-columna, que se asigna a un
nombre interno con una cadena hexadecimal.
Cuando selecciona $edge_id de la tabla, el nombre de la columna aparecer� 
como $edge_id_ \ <cadena_Hexadecimal>. El uso de nombres de pseudocolumnas en las consultas 
es la forma recomendada de consultar la columna interna $edge_id y se debe evitar el uso del 
nombre interno con una cadena hexadecimal.

$from_id
Almacena el $ node_id del Node, desde donde se origina el borde.

$to_id
Almacena el $ node_id del Node, en el que termina el borde.

Columnas en la tabla Edge
Los nodos que puede conectar un borde determinado se rigen por los datos insertados en las 
columnas $ from_id y $ to_id. En la primera versi�n, no es posible definir restricciones en 
la tabla de borde, para restringir la conexi�n de dos tipos de nodos. Es decir, un borde puede 
conectar dos nodos en el gr�fico, independientemente de sus tipos.

Similar a la columna $node_id, se recomienda que los usuarios creen un �ndice o restricci�n 
�nicos en la columna $edge_id en el momento de la creaci�n de la tabla de borde, pero si no 
se crea uno, se crea autom�ticamente un �ndice �nico no agrupado predeterminado en esta columna 
Sin embargo, cualquier �ndice en una pseudo columna de gr�fico se crea en las columnas internas 
subyacentes. Es decir, un �ndice creado en la columna $ edge_id, aparecer� en la columna 
interna graph_id_<Cadena_Hexadecimal> .
Tambi�n se recomienda, para escenarios OLTP, que los usuarios creen un �ndice en 
columnas ($ from_id, $ to_id), para b�squedas m�s r�pidas en la direcci�n del borde.

RESTRICCIONES EDGE
Una restricci�n de Edge se define en una tabla Edge de gr�fico y es un par de tablas Node 
que un tipo de Edge determinado puede conectar. Esto le da a los usuarios un mejor control 
sobre su esquema gr�fico.
Con la ayuda de restricciones Edge, los usuarios pueden restringir el tipo de nodos a 
los que se permite conectar un borde determinado.

CL�USULAS DE RESTRICCI�N EDGE
- Cada restricci�n Edge consta de una o m�s cl�usulas de restricci�n Edge.
- Una cl�usula de restricci�n Edge es el par de nodos FROM y TO que el Edge 
  dado podr�a conectar.
- Tenga en cuenta que tiene nodos de Producto y Cliente en su gr�fico y que 
  utiliza la restricci�n Venta Edge para conectar estos nodos.
- La cl�usula de restricci�n Edge especifica el par de nodos FROM y TO y la direcci�n del borde. 
  En este caso, la cl�usula de restricci�n de borde ser� Cliente A Producto. 
  Es decir, se permitir� la inserci�n de un Venta que va de un Cliente a un Producto.
- Los intentos de insertar un borde que va del Producto al Cliente fallan.
- Una cl�usula de restricci�n Edge contiene un par de tablas de nodo FROM y TO en las que 
  se aplica la restricci�n de borde.
- Si se crean m�ltiples restricciones de borde en una sola tabla de borde, los bordes deben 
  satisfacer TODAS las restricciones para ser permitidos.

LIMITACIONES EN EL USO DE GRAPH TABLES
- Las tablas temporales locales o globales no pueden ser tablas de nodo o borde.
- Los tipos de tabla y las variables de tabla no se pueden declarar como una tabla de 
  nodo o borde.
- Las tablas de nodo y borde no se pueden crear como tablas temporales con versi�n del sistema.
- Las tablas de nodo y borde no pueden ser tablas de memoria optimizada.
- Los usuarios no pueden actualizar las columnas $ from_id y $ to_id de un borde utilizando 
  la instrucci�n UPDATE.
- Para actualizar los nodos que conecta un borde, los usuarios deber�n insertar el nuevo 
  borde que apunta a nuevos nodos y eliminar el anterior.
- No se admiten consultas cruzadas de base de datos en objetos de gr�ficos.

CREANDO GRAHP TABLES
Usando la base de datos Northwind, se va a crear dos Graph Tables, una para Personas, 
que va a ser el Nodo, y otra para Grupos, que ser� el Edge (V�rtice) que tendr� las relaciones 
entre las personas.
*/

USE Northwind
GO

--Tablas tipo gr�fico para relaciones muchos a muchos
--Crear una tabla Node para Personas
CREATE TABLE dbo.personas(
	id INT,
	codigo CHAR(3), 
	paterno VARCHAR(100),
	materno VARCHAR(100),
	nombre VARCHAR(100),
	fecha_nacimiento DATE,
	CONSTRAINT pk_personas PRIMARY KEY(id)
) AS NODE
GO

--Insertar registros en la tabla personas, note
--que se ha especificado un campo c�digo adicional a la PK
INSERT INTO personas
VALUES(1, '059', 'Luque', 'S�nchez', 'Fernando', '1966-07-23'),
(2, '105', 'D�az', 'Flores', 'Mart�n', '1989-05-14'),
(3, '078', 'D�az', 'Ardiles', 'Gabrielito', '2018-07-16'),
(4, '450', 'Alicia', 'Flores', 'Z��iga', '1970-01-30')
GO

--El resultado se muestra ejecutando el siguiente select
SELECT * FROM personas
GO
/*Se obtendr� el siguiente resultado:
$node_id_F17805816C2646078A1D2901F6022CAE					id	codigo	paterno	materno	nombre	fecha_nacimiento
{"type":"node","schema":"dbo","table":"personas","id":0}	1	059		Luque	S�nchez	Fernando	1966-07-23
{"type":"node","schema":"dbo","table":"personas","id":1}	2	105		D�az	Flores	Mart�n		1989-05-14
{"type":"node","schema":"dbo","table":"personas","id":2}	3	078		D�az	Ardiles	Gabrielito	2018-07-16
{"type":"node","schema":"dbo","table":"personas","id":3}	4	450		Alicia	Flores	Z��iga		1970-01-30
Donde: 
La primera columna pertenece al ID del nodo
Las columnas restantes son las Propiedades del codo. Campos de la tabla
*/

--Crear una tabla EDGE para las relaciones entre personas
CREATE TABLE grupos(
	formacion DATE
) AS EDGE
GO

/*Insertar relaciones en la Graph Table Personas y la tabla Edge Grupos

La relaci�n entre personas se forman con dos instrucciones select que 
represetan las partes From y To de la relaci�n. En cada instrucci�n se debe
extraer el dato que representa al nodo usando la funci�n $node_id

Relaci�n entre las personas con c�digo 105, D�az Flores Mart�n y la que 
tiene el c�digo 078, D�az Ardiles Gabrielito. Note que estas relaciones para 
este ejercicio definen la formaci�n de un grupo y se ha incluido un campo adicional 
en el Edge que es la fecha de creaci�n del grupo.
*/
INSERT INTO grupos 
VALUES((SELECT $node_id FROM personas WHERE codigo = '105'),
(SELECT  $node_id FROM personas WHERE codigo = '078'), '2021-05-05')
GO

--Insertar m�s relaciones entre personas
INSERT INTO grupos
VALUES((SELECT $node_id FROM personas WHERE codigo = '078'),
(SELECT $node_id FROM personas WHERE codigo = '450'), '2021-05-01')
GO

INSERT INTO grupos
VALUES((SELECT $node_id FROM personas WHERE codigo = '059'),
(SELECT $node_id FROM personas WHERE codigo = '105'), '2019-01-13')
GO

INSERT INTO grupos
VALUES((SELECT $node_id FROM personas WHERE codigo = '105'),
(SELECT $node_id FROM personas WHERE codigo = '059'), '2018-11-23')
GO

--Ver el contenido de la tabla Edge Groups
SELECT * FROM grupos
GO

/*Se observa el siguiente resultado
$edge_id_F9D7D571DDDB4CAA9934A45BC1EF394F				$from_id_4BA9F2BDC16B4BA282535CCAD51E15BE					$to_id_4DD1DB0AFEE84917807D1CE270E84CF8						formacion
{"type":"edge","schema":"dbo","table":"grupos","id":0}	{"type":"node","schema":"dbo","table":"personas","id":1}	{"type":"node","schema":"dbo","table":"personas","id":2}	2021-05-05
{"type":"edge","schema":"dbo","table":"grupos","id":1}	{"type":"node","schema":"dbo","table":"personas","id":2}	{"type":"node","schema":"dbo","table":"personas","id":3}	2021-05-01
{"type":"edge","schema":"dbo","table":"grupos","id":2}	{"type":"node","schema":"dbo","table":"personas","id":0}	{"type":"node","schema":"dbo","table":"personas","id":1}	2019-01-13
{"type":"edge","schema":"dbo","table":"grupos","id":3}	{"type":"node","schema":"dbo","table":"personas","id":1}	{"type":"node","schema":"dbo","table":"personas","id":0}	2018-11-23

Para visualizar las relaciones de D�az Flores Mart�n (c�d. 105)
*/
SELECT p2.paterno, p2.materno, p2.nombre, g.formacion
FROM personas AS p1, grupos AS g, personas AS p2
WHERE MATCH(p1-(g)->p2) AND p1.codigo = '105'
GO

/*Cl�usula Match del select
Especifica una condici�n de b�squeda para un gr�fico. Math solo se puede usar con el nodo gr�fico
y las tablas Edge, en la instrucci�n SELECT como parte de la c�usula WHERE
*/