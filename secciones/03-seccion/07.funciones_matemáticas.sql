/*-- FUNCIONES MATEMÁTICAS --
Las funciones matemáticas realizan cálculos basados en valores de entrada y reportan un valor numérico.
Las funciones matemáticas son: 

Función						Descripción
----------------------------------------------------------------------------------------
ABS(Exp. Numérica)			Reporta el valor absoluto de una expresión numérica
DEGREES(Exp. Numérica)		Reporta el valor del ángulo en grados de uno expresado en radianes.
RAND()						Reporta un número aleatorio entre 0 y 1
ACOS(Exp. Numérica)			Reporta el ángulo en radianes llamado Arco Coseno.
EXP(Exp. Numérica)			Reporta el valor exponencial de la expresión numérica.
ROUND(Exp. Numérica, n)		Reporta una expresión numperica redondeada en n decimales.
ASIN(Exp. Numérica)			Reporta el ángulo en radianes llamado Arco seno.
FLOOR(Exp. Numérica)		Reporta el entero menor o igual que la expresión numérica especificada.
SIGN(Exp. Numérica)			Reporta el signo de la expresión numérica
ATAN(Exp. Numérica)			Reporta el ángulo en radianes llamado Arco Tangente.
LOG(Exp. Numérica [,base])	Reporta el logaritmo natural de una expresión numérica
SIN(Exp. Numérica)			Reporta el seno de un ángulo expresado en radianes.
ATN2(Exp. Num1, Exp. Num2)	Devuelve el ángulo, en radianes, entre el eje x positivo y el rayo desde el 
							origen hasta el punto (y, x), donde x e y son los valores de las dos 
							expresiones flotantes especificadas.
LOG10(Exp. Numérica)		Reporta el logaritmo en base 10 de la expresión numérica.
SQRT(Exp. Numérica)			Reporta la raíz cuadrada de la expresión numérica
CEILING(Exp. Numérica)		Reporta el entero más pequeño mayor o igual que la expresión numérica 
							especificada.
PI()						Reporta el valor de Pi.
SQUARE(Exp. Numérica)		Reporta el cuadrado de la expresión numérica
COS(Exp. Numérica)			Reporta el ángulo en radianes llamado Coseno.
POWER(Exp. Numérica, n)		Reporta la expresión numérica elevada a la n potencia.
TAN(Exp. Numérica)			Reporta el ángulo en radianes llamado Tangente.
COT(Exp. Numérica)			Reporta el ángulo en radianes llamado Cotangente.
RADIANS(Exp. Numérica)		Reporta el valor en radianes de un ángulo especificado.
*/

/*EJERCICIO 01. Calcular el valor en radianes de 2PI*/
SELECT 'El valor de PI*2 en radianes es: ' + CONVERT(VARCHAR, DEGREES(PI()*2))
GO

/*EJERCICIO 02. Calcular el valor del arco coseno de -1*/
SELECT 'El arco coseno de -1 es: ' + CONVERT(VARCHAR, ACOS(-1))
GO

/*EJERCICIO 03. Hallar el valor exponencial de 2. La constante e (2,718281…) es la base de 
los logaritmos naturales.*/
SELECT 'El valor de e elevado al cuadrado es: ' + CONVERT(VARCHAR, EXP(2))
GO

/*EJERCICIO 04. Redondear los valores 345.6763 en 3 decimales y 2348.56983 en 2 decimales*/
SELECT ROUND(345.6763, 3), ROUND(2348.56983, 2)
GO

/*EJERCICIO 05. Calcular el valor del arco seno de -1*/
SELECT 'El ASIN de 1 es: ' + CONVERT(VARCHAR, ASIN(1))
GO

/*EJERCICIO 06. Reportar el mayor entero de 25.86, -45.96 y $12.02*/
SELECT FLOOR(25.86), FLOOR(-45.96), FLOOR($12.02)
GO

/*EJERCICIO 07. Mostrar los signos de los números desde -2 hasta 2*/
DECLARE @valor REAL
SET @valor = -2
WHILE @valor <= 2
	BEGIN
		PRINT SIGN(@valor)
		SELECT @valor = @valor + 1
	END
GO

/*EJERCICIO 08. Calcular el arco tangente de -50 y -100*/
SELECT 'El atan de -50 es: ' + CONVERT(VARCHAR, ATAN(-50))
SELECT 'El atan de -100 es: ' + CONVERT(VARCHAR, ATAN(-100))
GO

/*EJERCICIO 09. Calcular el valor de logaritmo de 10*/
SELECT 'El logaritmo de 10 es: ' + CONVERT(VARCHAR, LOG(10))
GO

/*EJERCICIO 10. Calcular el seno de 50*/
SELECT 'El seno de 50 es: ' + CONVERT(VARCHAR, SIN(50))
GO

/*EJERCICIO 11. Calcular el arco tangente de 35.5 y 130*/
SELECT 'El arco tangente del ángulo es: ' + CONVERT(VARCHAR, ATN2(35.5, 130))
GO

/*EJERCICIO 12. Calcular el logaritmo en base 10 de 50*/
SELECT 'El logaritmo en base 10 de 50 es: ' + CONVERT(VARCHAR, LOG10(50))
GO

/*EJERCICIO 13. Hallar la raíz cuadrada de 50*/
SELECT SQRT(50)
GO

/*EJERCICIO 14. Reportar el menor entero de 25.86, -45.96 y $12.02*/
SELECT CEILING(25.86), CEILING(-45.96), CEILING($12.02)
GO

/*EJERCICIO 15. Hallar el coseno de 89*/
SELECT CONVERT(VARCHAR, COS(89))
GO

/*EJERCICIO 16. Hallar el valor de 25 elevado a la cuarta*/
SELECT POWER(25, 4)
GO

/*EJERCICIO 17. Halar a tangente de PI entre 6*/
SELECT TAN(PI()/6)
GO

/*EJERCICIO 18. Hallar la cotangente de 150*/
SELECT CONVERT(VARCHAR, COT(150))
GO

/*EJERCICIO 19. Hallar el valor en radianes de 90*/
SELECT CONVERT(VARCHAR, RADIANS(90))
GO