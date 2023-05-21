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

/* 8. Hacer un programa T SQL,que lea todos los datos de la tabla almacen y los muestre en pantalla ordenado por 
	  el nombre del almacen,  al final de la lista muestre la cantidad de almacenes existentes. */
	Declare @cod_alma int
	Declare @nomb_alma varchar(10)
	Declare @ciud_alma varchar(10)
	Declare @cantidad int = 0

	-- Declaramos el cursor
	DECLARE miCursor CURSOR
		FOR (select calm, noma, ciud from alma)
	-- Abrimos el cursor y navegamos
	OPEN miCursor
	FETCH NEXT FROM miCursor INTO @cod_alma, @nomb_alma, @ciud_alma;
	
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
		print CAST(@cod_alma as varchar) + ' | ' + @nomb_alma + ' | ' + @ciud_alma;
		set @cantidad = @cantidad + 1
		FETCH NEXT FROM miCursor INTO @cod_alma, @nomb_alma, @ciud_alma;
		END
	print 'La cantidad de almacenes es: ' + CAST(@cantidad as varchar)
	-- Cerramos el cursor
	CLOSE miCursor
	-- Limpiamos de la memoria al cursor
	DEALLOCATE miCursor

	--select * from alma
	GO

/* 9. Hacer un programa T SQL,que lea los datos de la tabla sumi y muestre en pantalla solamente los productos 
	  suministrado por el proveedor PROV3, al finalizar la lista debe mostrar el importe total suministrado. */
	Declare @cod_prod int, 
			@nomb_prod varchar(10),
			@importe float,
			@importeTotal float = 0

	Declare Cursor2 cursor
		for (select prod.cprd, prod.nomp, sumi.impt from sumi, prod, prov 
			 where sumi.cprd = prod.cprd and sumi.cprv = prov.cprv and prov.nomb = 'PROV3')

	open Cursor2

	FETCH NEXT FROM Cursor2 INTO @cod_prod, @nomb_prod, @importe
	WHILE ( @@FETCH_STATUS = 0 )
		BEGIN
			print CAST(@cod_prod as varchar) + ' | ' + @nomb_prod + ' | ' + CAST(@importe as varchar)
			set @importeTotal = @importeTotal + @importe
			FETCH NEXT FROM Cursor2 INTO @cod_prod, @nomb_prod, @importe
		END
	print 'El importe Total es: ' + CAST(@importeTotal as varchar)
	-- cerramos el cursor
	close Cursor2
	-- liberamos de la memoria el cursor
	deallocate Cursor2
	GO

/* 10. Hacer un programa T SQL,que lea los datos de la tabla sumi y muestre en pantalla solamente los 
	   productos suministrado en los almacenes de SC, al finalizar la lista debe mostrar el promedio de 
	   los importes suministrado. */
	Declare @nombre_prod varchar(10),
			@importe float = 0,
			@cant_prod int = 0, 
			@suma_importe float = 0,
			@promedio_importe float

	Declare Cursor3 cursor
		for (select prod.nomp, sumi.impt from prod, sumi, alma where prod.cprd = sumi.cprd and sumi.calm = alma.calm 
			 and alma.ciud = 'SC')

	open Cursor3

	FETCH NEXT FROM Cursor3 INTO @nombre_prod, @importe
	WHILE ( @@FETCH_STATUS = 0 )
		BEGIN
			print @nombre_prod + ' | ' + CAST(@importe as varchar)
			set @cant_prod = @cant_prod + 1
			set @suma_importe = @suma_importe + @importe
			FETCH NEXT FROM Cursor3 INTO @nombre_prod, @importe
		END
	set @promedio_importe = @suma_importe / @cant_prod
	print 'El promedio de los importes suministrados es: ' + CAST(@promedio_importe as varchar)

	close Cursor3
	deallocate Cursor3
	GO

/* 11. Hacer un programa T SQL,que lea los datos de la tabla sumi y muestre en pantalla solamente los productos 
	   suministrado de color ROJO,  al finalizar la lista debe mostrar la fecha del ultimo producto suministrado. */
	Declare @nomb_prod varchar(10),
			@fecha_ult_prod date = (select MAX(ftra) from prod, sumi where prod.cprd = sumi.cprd and prod.colo = 'ROJO')

	Declare Cursor4 cursor
		for (select prod.nomp from prod, sumi where prod.cprd = sumi.cprd and prod.colo = 'ROJO')

	open Cursor4

	FETCH NEXT FROM Cursor4 INTO @nomb_prod

	WHILE (@@FETCH_STATUS = 0)
		BEGIN 
			print @nomb_prod
			FETCH NEXT FROM Cursor4 INTO @nomb_prod
		END
	print 'Fecha del ultimo producto suministrado: ' + CAST(@fecha_ult_prod as varchar)

	close Cursor4
	deallocate Cursor4
	GO