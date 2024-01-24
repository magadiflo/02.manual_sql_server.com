/*-- Operadores en SQL Server --

Se puede definir un operador como una caracter o caracteres para comparar 
dos datos del mismo tipo, se utilizan en las cl�usulas Where o Having del 
Select o de otras instrucciones que requieran de filtros y comprobaci�n 
de condiciones.

Tipos de Operadores
- Aritm�ticos
- Comparaci�n
- L�gicos
- Negaci�n

Aritm�ticos
Suponiendo que la variable a tiene un valor de 8 y la variable b 
tiene un valor de 10

Operador	Descripci�n						Ejemplo
+			Suma							a + b resultado 18
�			Resta							a � b resultado -2
*			Multiplica						a * b resultado 80
/			Divide							b / a resultado 1.25
%			Modulo, resto de la divisi�n	b % a resultado 2

Comparaci�n
Suponiendo que la variable a tiene un valor de 5 y la 
variable b tiene un valor de 10

Operador	Descripci�n					Ejemplo
=			Compara dos valores			(a = b) es falso.
!=			Compara si son diferentes	(a != b) es verdadero.
<>			Diferente a					(a <> b) es verdadero
>			Mayor que					(a > b) es falso.
<			Menor que					(a < b) es verdadero.
>=			Mayor o igual que			(a >= b) es falso.
<=			Menor o igual que			(a <= b) es verdadero.
!<			No es menor que				(a !< b) es falso.
!>			No es mayor que				(a !> b) es verdadero.

L�gicos
Los Operadores l�gicos en SQL Server son los siguientes:

Operador	Descripci�n
AND			Usado para m�ltiples en expresiones l�gicas con mas de una 
			condici�n, para que el resultado final sea verdadero, todas 
			las condiciones deben de ser verdaderas.
BETWEEN		Compara un dato en un rango de valores
EXISTS		Comprueba si existe un dato en un select
IN			Comprueba si un valor est� en un conjunto de datos.
LIKE		Permite comparar datos de tipo caracter no exactos.
NOT			Niega el resultado de una o mas condiciones.
OR			Usado para m�ltiples condiciones en la cl�usula Where, para 
			que el resultado final sea verdadero, basta que una de las 
			condiciones sea verdadera.
IS NULL		Compara si el valor del campo es Null
UNIQUE		Lista valores sin incluir duplicados

*/