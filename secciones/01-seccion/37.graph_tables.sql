/*-- GRAPH TABLES EN SQLSERVER --*/
/*
Una base de datos gráfica es una colección de nodos (o vértices) y bordes (o relaciones). 
Un nodo representa una entidad (por ejemplo, una persona o una organización) y un borde 
representa una relación entre los dos nodos que conecta (por ejemplo, grupos o amigos). 
Tanto los nodos como los bordes pueden tener propiedades asociadas a ellos.

CARACTERÍSTICAS DE LOS GRAPH TABLES
- Los bordes o las relaciones son entidades de primera clase en una base de datos gráfica y 
  pueden tener atributos o propiedades asociadas.
- Un solo borde puede conectar de forma flexible varios nodos en una base de datos de gráficos.
- Puede expresar la coincidencia de patrones y las consultas de navegación de múltiples saltos
  fácilmente.
- Puede expresar cierre transitivo y consultas polimórficas fácilmente.

CUÁNDO USAR UNA BASE DE DATOS GRÁFICA
No hay nada que una base de datos gráfica pueda lograr, lo que no se puede lograr utilizando 
una base de datos relacional. Sin embargo, una base de datos gráfica puede hacer que sea más 
fácil expresar cierto tipo de consultas. Además, con optimizaciones específicas, ciertas 
consultas pueden tener un mejor desempeño.

FACTORES PARA DECIDIR USAR UNA BASE DE DATOS GRÁFICA
- Su aplicación tiene datos jerárquicos. El tipo de datos HierarchyID se puede usar para 
  implementar jerarquías, pero tiene algunas limitaciones. Por ejemplo, no le permite almacenar 
  varios padres para un nodo.
- Su aplicación tiene relaciones complejas de muchos a muchos; A medida que la aplicación 
  evoluciona, se agregan nuevas relaciones.
- Necesitas analizar datos y relaciones interconectadas.

- TABLA NODE -
Una tabla Node representa una entidad en un esquema gráfico. Cada vez que se crea una tabla Node,
junto con las columnas definidas por el usuario, se crea una columna implícita llamada $node_id, 
que identifica de forma exclusiva un nodo dado en la base de datos.

Los valores en $node_id se generan automáticamente y son una combinación de object_id de esa 
tabla de nodos y un valor bigint generado internamente. Sin embargo, cuando se selecciona la 
columna $node_id, se muestra un valor calculado en forma de una cadena JSON. Además, $node_id 
es una pseudo columna, que se asigna a un nombre interno con una cadena hexadecimal.

Cuando selecciona $node_id de la tabla, el nombre de la columna aparecerá como 
$node_id_ <Cadena_Hexadecimal>. El uso de nombres de pseudocolumnas en las consultas es la forma 
recomendada de consultar la columna interna $node_id y se debe evitar el uso del nombre 
interno con una cadena hexadecimal.

Se recomienda que los usuarios creen una restricción o índice único en la columna $node_id en el 
momento de la creación de la tabla Node, pero si no se crea una, se crea automáticamente un 
índice único no agrupado predeterminado. Sin embargo, cualquier índice en una pseudo columna 
de gráfico se crea en las columnas internas subyacentes. Es decir, un índice creado en la 
columna $node_id, aparecerá en la columna interna graph_id_<Cadena_Hexadecimal>.

- TABLA EDGE -
Una tabla Edge representa una relación en un gráfico. Los Edge siempre se dirigen y conectan 
dos nodos. Una tabla Edge permite a los usuarios modelar relaciones de muchos a muchos en el 
gráfico. Una tabla Edge puede tener o no atributos definidos por el usuario. Cada vez que se 
crea una tabla Erge, junto con los atributos definidos por el usuario, se crean tres columnas 
implícitas en la tabla Edge: 

$edge_id
Identifica de forma exclusiva un Edge dado en la base de datos. Es una columna generada y 
el valor es una combinación de object_id de la tabla de borde y un valor bigint generado 
internamente. Sin embargo, cuando se selecciona la columna $edge_id, se muestra un valor 
calculado en forma de una cadena JSON. $edge_id es una pseudo-columna, que se asigna a un
nombre interno con una cadena hexadecimal.
Cuando selecciona $edge_id de la tabla, el nombre de la columna aparecerá 
como $edge_id_ \ <cadena_Hexadecimal>. El uso de nombres de pseudocolumnas en las consultas 
es la forma recomendada de consultar la columna interna $edge_id y se debe evitar el uso del 
nombre interno con una cadena hexadecimal.

$from_id
Almacena el $ node_id del Node, desde donde se origina el borde.

$to_id
Almacena el $ node_id del Node, en el que termina el borde.

Columnas en la tabla Edge
Los nodos que puede conectar un borde determinado se rigen por los datos insertados en las 
columnas $ from_id y $ to_id. En la primera versión, no es posible definir restricciones en 
la tabla de borde, para restringir la conexión de dos tipos de nodos. Es decir, un borde puede 
conectar dos nodos en el gráfico, independientemente de sus tipos.

Similar a la columna $node_id, se recomienda que los usuarios creen un índice o restricción 
únicos en la columna $edge_id en el momento de la creación de la tabla de borde, pero si no 
se crea uno, se crea automáticamente un índice único no agrupado predeterminado en esta columna 
Sin embargo, cualquier índice en una pseudo columna de gráfico se crea en las columnas internas 
subyacentes. Es decir, un índice creado en la columna $ edge_id, aparecerá en la columna 
interna graph_id_<Cadena_Hexadecimal> .
También se recomienda, para escenarios OLTP, que los usuarios creen un índice en 
columnas ($ from_id, $ to_id), para búsquedas más rápidas en la dirección del borde.

RESTRICCIONES EDGE
Una restricción de Edge se define en una tabla Edge de gráfico y es un par de tablas Node 
que un tipo de Edge determinado puede conectar. Esto le da a los usuarios un mejor control 
sobre su esquema gráfico.
Con la ayuda de restricciones Edge, los usuarios pueden restringir el tipo de nodos a 
los que se permite conectar un borde determinado.

CLÁUSULAS DE RESTRICCIÓN EDGE
- Cada restricción Edge consta de una o más cláusulas de restricción Edge.
- Una cláusula de restricción Edge es el par de nodos FROM y TO que el Edge 
  dado podría conectar.
- Tenga en cuenta que tiene nodos de Producto y Cliente en su gráfico y que 
  utiliza la restricción Venta Edge para conectar estos nodos.
- La cláusula de restricción Edge especifica el par de nodos FROM y TO y la dirección del borde. 
  En este caso, la cláusula de restricción de borde será Cliente A Producto. 
  Es decir, se permitirá la inserción de un Venta que va de un Cliente a un Producto.
- Los intentos de insertar un borde que va del Producto al Cliente fallan.
- Una cláusula de restricción Edge contiene un par de tablas de nodo FROM y TO en las que 
  se aplica la restricción de borde.
- Si se crean múltiples restricciones de borde en una sola tabla de borde, los bordes deben 
  satisfacer TODAS las restricciones para ser permitidos.

LIMITACIONES EN EL USO DE GRAPH TABLES
- Las tablas temporales locales o globales no pueden ser tablas de nodo o borde.
- Los tipos de tabla y las variables de tabla no se pueden declarar como una tabla de 
  nodo o borde.
- Las tablas de nodo y borde no se pueden crear como tablas temporales con versión del sistema.
- Las tablas de nodo y borde no pueden ser tablas de memoria optimizada.
- Los usuarios no pueden actualizar las columnas $ from_id y $ to_id de un borde utilizando 
  la instrucción UPDATE.
- Para actualizar los nodos que conecta un borde, los usuarios deberán insertar el nuevo 
  borde que apunta a nuevos nodos y eliminar el anterior.
- No se admiten consultas cruzadas de base de datos en objetos de gráficos.

CREANDO GRAHP TABLES
Usando la base de datos Northwind, se va a crear dos Graph Tables, una para Personas, 
que va a ser el Nodo, y otra para Grupos, que será el Edge (Vértice) que tendrá las relaciones 
entre las personas.
*/

USE Northwind
GO

--Tablas tipo gráfico para relaciones muchos a muchos
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
--que se ha especificado un campo código adicional a la PK
INSERT INTO personas
VALUES(1, '059', 'Luque', 'Sánchez', 'Fernando', '1966-07-23'),
(2, '105', 'Díaz', 'Flores', 'Martín', '1989-05-14'),
(3, '078', 'Díaz', 'Ardiles', 'Gabrielito', '2018-07-16'),
(4, '450', 'Alicia', 'Flores', 'Zúñiga', '1970-01-30')
GO

--El resultado se muestra ejecutando el siguiente select
SELECT * FROM personas
GO
/*Se obtendrá el siguiente resultado:
$node_id_F17805816C2646078A1D2901F6022CAE					id	codigo	paterno	materno	nombre	fecha_nacimiento
{"type":"node","schema":"dbo","table":"personas","id":0}	1	059		Luque	Sánchez	Fernando	1966-07-23
{"type":"node","schema":"dbo","table":"personas","id":1}	2	105		Díaz	Flores	Martín		1989-05-14
{"type":"node","schema":"dbo","table":"personas","id":2}	3	078		Díaz	Ardiles	Gabrielito	2018-07-16
{"type":"node","schema":"dbo","table":"personas","id":3}	4	450		Alicia	Flores	Zúñiga		1970-01-30
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

La relación entre personas se forman con dos instrucciones select que 
represetan las partes From y To de la relación. En cada instrucción se debe
extraer el dato que representa al nodo usando la función $node_id

Relación entre las personas con código 105, Díaz Flores Martín y la que 
tiene el código 078, Díaz Ardiles Gabrielito. Note que estas relaciones para 
este ejercicio definen la formación de un grupo y se ha incluido un campo adicional 
en el Edge que es la fecha de creación del grupo.
*/
INSERT INTO grupos 
VALUES((SELECT $node_id FROM personas WHERE codigo = '105'),
(SELECT  $node_id FROM personas WHERE codigo = '078'), '2021-05-05')
GO

--Insertar más relaciones entre personas
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

Para visualizar las relaciones de Díaz Flores Martín (cód. 105)
*/
SELECT p2.paterno, p2.materno, p2.nombre, g.formacion
FROM personas AS p1, grupos AS g, personas AS p2
WHERE MATCH(p1-(g)->p2) AND p1.codigo = '105'
GO

/*Cláusula Match del select
Especifica una condición de búsqueda para un gráfico. Math solo se puede usar con el nodo gráfico
y las tablas Edge, en la instrucción SELECT como parte de la cáusula WHERE
*/