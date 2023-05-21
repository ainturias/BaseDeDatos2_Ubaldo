/*          TP6-T0 (Practica de Programacion Transact SQL)       */
use Demo;
-- Crear la Base de Datos usando el siguiente esquema de la Base de Datos "demo".
-- Elaborar los programas TRANSACT SQL correspondiente  para cada uno de los siguientes requerimientos 
-- a la Base de Datos "demo".
	GO

/* 1. Hacer un programa T SQL, que muestre en pantalla la palabra "Hola Mundo". */
	print 'Hola Mundo';
	GO

/* 2. Hacer un programa T SQL, donde declare variables de tipo Fecha, Entero, Real y Cadena, inicializarlas 
	  y mostrar su valor. */
	-- Declaramos las variables
	Declare @fecha date
	Declare @entero int
	Declare @real real
	Declare @cadena varchar(100)
	-- Asignamos valores a las variables
	set @fecha = GETDATE()
	set @entero = 400
	set @real = 15.3
	set @cadena = 'hola soy la cadena'
	-- Imprimimos las variables
	print @fecha
	print @entero
	print @real
	print @cadena
	GO

/* 3. Hacer un programa T SQL,que asigne en una variable codigo del proveedor, luego obtenga el nombre del 
	  prooveedor en otra variable y muestre finalmene el nombre en la pantalla. */
	Declare @codigo_prov int
	Declare @nombre_prov varchar(100)

	set @codigo_prov = 1
	set @nombre_prov = (select nomb from prov where cprv = @codigo_prov)

	print @nombre_prov
	GO

/* 4. Hacer un programa T SQL,que asigne a diferentes variables todos los datos de un producto dado y los 
	  muestre en pantalla. */
	Declare @cod_prod int
	Declare @nombre_prod varchar(50)
	Declare @color varchar(20)

	set @cod_prod = 1

	select @nombre_prod=nomp, @color=colo from prod where cprd = @cod_prod

	print 'Codigo: ' + CAST(@cod_prod as varchar)
	print 'Nombre: ' + @nombre_prod
	print 'Color: ' + @color
	GO

/* 5. Hacer un programa que muestre en pantalla un mensaje "Proveedor ha sumistrado producto" si el Proveedor 
	  con codigo 1 ha sumistrado algun producto, de lo contrario que muestre el mensaje "Proveedor no ha 
	  sumistrado producto". */
	if ( (select COUNT(*) from sumi where cprv=1)>=1 )
		print 'Proveedor ha suministrado producto'
	else
		print 'proveedor no ha suministrado producto'
	GO

/* 6. Programa T SQL, para clasificar a un proveedor dado su codigo, en base al importe de sus productos 
	  suministrado bajo las siguientes condiciones.
-- Si el importe suministrado es mayor a 0 y menor o igual a 50 se debe mostrar un mensaje 'Proveedor Minorista'.
-- Si el importe suministrado es mayor a 51 y menor o igual a 200 se debe mostrar un mensaje 'Proveedor Intermedio'.
-- Si el importe suministrado es mayor a 200 se debe mostrar un mensaje 'Proveedor Mayorista'.
-- Si no se da ninguna de las anteriore opciones, se debe mostrar un mensaje 'Proveedor sin Clasificar'. */
	
	-- Intento #1 usando el CASE

	Declare @cod_prov as int
	Declare @res varchar(50)
	Declare @importe float

	set @cod_prov = 1
	set @importe = (select ISNULL(SUM(impt),0) from sumi where cprv = @cod_prov)
	set @res = (CASE 
					WHEN (@importe>=0 and @importe<=50) THEN 'Proveedor Minorista'
					WHEN (@importe>=51 and @importe<=200) THEN 'Proveedor Intermedio'
					WHEN (@importe>=200) THEN 'Proveedor Mayorista'
					ELSE 'Proveedor sin Clasificar'
				END
				)
	print 'El Importe del proveedor ' + CAST(@cod_prov as char(2)) + ' es: ' + CAST(@importe as varchar(20))
	print @res
	GO
	
/* 7. Programa T SQL, para calcular la comision a pagara a un proveedor dado su codigo, en base al importe de 
	  sus productos suministrado bajo las siguientes condiciones. 
-- Si el importe suministrado es mayor a 0 y menor o igual a 50, le corresponde de commision el 10% sobre 
   el importe total suministrado.
-- Si el importe suministrado es mayor a 51 y menor o igual a 200, le corresponde de commision el 20% sobre 
   el importe total suministrado.
-- Si el importe suministrado es mayor a 200, le corresponde de commision el 30% sobre el importe total suministrado.
-- Si no se da ninguna de las anteriore opciones, no le corresponde commision. */
	Declare @cod_prov int
	Declare @importe float 
	Declare @comision float

	set @cod_prov = 3
	set @importe = (select ISNULL(SUM(impt),0) from sumi where sumi.cprv = @cod_prov)
	--select @importe = ISNULL(SUM(impt),0) from sumi where sumi.cprv = @cod_prov
	set @comision = (CASE
						WHEN (@importe>0 and @importe<=50) THEN @importe * 0.10
						WHEN (@importe>51 and @importe<=200) THEN @importe * 0.20
						WHEN (@importe>200) THEN @importe * 0.30
						ELSE @importe
					 END)

	print 'El importe del proveedor ' + CAST(@cod_prov as varchar(5)) + ' es de ' + CAST(@importe as varchar(10))
	print 'su comisión es de ' + CAST(@comision as varchar)
	GO

-- 8. Hacer un programa T SQL,que lea todos los datos de la tabla almacen y los muestre en pantalla ordenado por el nombre del almacen,  al final de la lista muestre la cantidad de almacenes existentes.

-- 9. Hacer un programa T SQL,que lea los datos de la tabla sumi y muestre en pantalla solamente los productos suministrado por el proveedor PROV3, al finalizar la lista debe mostrar el importe total suministrado

-- 10. Hacer un programa T SQL,que lea los datos de la tabla sumi y muestre en pantalla solamente los productos suministrado en los almacenes de SC, al finalizar la lista debe mostrar el promedio de los importes suministrado 

-- 11. Hacer un programa T SQL,que lea los datos de la tabla sumi y muestre en pantalla solamente los productos suministrado de color ROJO,  al finalizar la lista debe mostrar la fecha del ultimo producto suministrado 











