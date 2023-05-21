/* TP4-T0 (Practica de Programación de Consultas SQL - Parte II)    */
--BY ALEX

------------------------------------------------------------------------------------------------------------------------
--------------------------------------------- REUNION NATURAL ----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
  GO

/*1) Listar los productos suministrados hasta la fecha, se debe mostrar: Código Producto, Nombre del Producto y Cantidad. 
  La lista debe estar ordenado por el Nombre del Producto. */
  GO
  select prod.cprd as CODIGO_PROD, prod.nomp as NOMBRE_PROD, sumi.cant as CANTIDAD
  from prod, sumi
  where prod.cprd = sumi.cprd
  order by prod.nomp;
  GO

/*2) Listar los productos suministrados a la ciudad de Santa Cruz, Cochabamba y Beni se debe mostrar: 
   Código Producto, Nombre del Producto, Cantidad, Fecha, Precio, Nombre del Almacén. 
   La lista debe estar ordenado por el Nombre del Almacen seguido por Nombre del Producto.*/
   GO
   select prod.cprd as CODIGO, 
		  prod.nomp as NOMBRE, 
		  sumi.cant as CANTIDAD, 
		  sumi.ftra as FECHA, 
		  sumi.prec as PRECIO, 
		  alma.noma as NOMBRE_ALMACEN
   from prod, sumi, alma
   where prod.cprd = sumi.cprd and sumi.calm = alma.calm
		and alma.ciud IN ('SC','CB','BE')
   order by alma.noma, prod.nomp;
   GO

/*3) Listar los productos suministrados por los proveedores de la ciudad de La Paz a la ciudad de Santa Cruz, 
   se debe mostrar: Código Producto, Nombre del Producto, Cantidad, Precio, Fecha, Nombre del Almacén, Nombre del Proveedor. 
   La lista debe estar ordenado por el Nombre del Proveedor, Nombre del Almacen y Nombre del Producto. */
   select  prod.cprd as CODIGO_PROD, 
		   prod.nomp as NOMBRE_PROD, 
		   sumi.cant as CANTIDAD, 
		   sumi.prec as PRECIO, 
		   sumi.ftra as FECHA, 
		   alma.noma as NOMBRE_ALMACEN, 
		   prov.nomb as NOMBRE_PROVEEDOR
   from prod, sumi, prov, alma
   where prod.cprd = sumi.cprd and sumi.cprv = prov.cprv and sumi.calm = alma.calm
		 and prov.ciud IN ('LP','SC')
   order by prov.nomb, alma.noma, prod.nomp;
   GO

/*4) Listar los productos suministrados por el proveedor  PRV2 cuyos importes superen a 10 Bs, se debe mostrar: 
   Código del Producto, Nombre del Producto, Fecha, Cantidad, Precio, Importe e Importe de Descuento. 
   El Importe de Descuento equivale al 10% del Importe por cada producto. 
   La lista debe estar ordenado por el Nombre del Proveedor, Nombre del Almacen y Nombre del Producto. */
   GO
   select prod.cprd as CODIGO_PROD,
		  prod.nomp as NOMBRE_PROD,
		  sumi.ftra as FECHA,
		  sumi.cant as CANTIDAD, 
		  sumi.prec as PRECIO,
		  sumi.impt as IMPORTE,
		  sumi.impt*0.10 as IMPORTE_DESCUENTO
   from prod, sumi, prov, alma
   where prod.cprd = sumi.cprd and sumi.cprv = prov.cprv and sumi.calm = alma.calm
		and prov.nomb = 'PROV2'
		and sumi.impt > 10
   order by prov.nomb, alma.noma, prod.nomp;
   --no hay nadaaaaa
   GO

------------------------------------------------------------------------------------------------------------------------
-------------------------------------USO DE LA CLAUSULA IN / EXISTS-----------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/*1) Listar los Productos Existentes en los almacenes de la ciudad de Santa Cruz. */
	GO
	select prod.*
	from prod, sumi, alma
	where prod.cprd = sumi.cprd and sumi.calm = alma.calm
		and alma.ciud = 'SC';
	GO

/*2) Listar los Proveedores que Suministraron algún Producto. */
	GO
	select *
	from prov
	where EXISTS (select * from sumi where prov.cprv = sumi.cprv);
	GO

/*3) Listar los Proveedores que todavía no suministraron productos. */
	GO
	select *
	from prov
	where NOT EXISTS (select * from sumi where prov.cprv = sumi.cprv);
	GO

/*4) Listar los Productos Suministrados por el Proveedor PRV3. */
	GO
	select prod.*
	from prod, sumi, prov
	where prod.cprd = sumi.cprd and sumi.cprv = prov.cprv
		and prov.nomb = 'PROV3';
	GO

/*5) Listar los nombres de los proveedores que suministraron algún producto color rojo. */
	GO
	select prov.*
	from prov, sumi, prod
	where prov.cprv = sumi.cprv and sumi.cprd = prod.cprd
		and prod.colo = 'ROJO';
	GO

/*6) Listar los Productos existente en el Almacén 1,que fueron suministrado por el Proveedor PRV1. */
	GO
	select prod.*
	from prod, alma, sumi, prov
	where prod.cprd = sumi.cprd and alma.calm = sumi.calm and prov.cprv = sumi.cprv
		and alma.noma = 'ALM1' and prov.nomb = 'PROV1';
	GO

/*7) Listar los Productos de color Amarillo suministrados por el Proveedor PRV2. */
	GO
	select prod.*
	from prod, sumi, prov
	where prod.cprd = sumi.cprd and sumi.cprv = prov.cprv
		and prod.colo = 'AMARILLO' and prov.nomb = 'PROV2';
	GO

/*8) Listar los nombres de proveedores que suministraron todos los productos. */
	GO
	select prov.cprv, prov.nomb, COUNT(DISTINCT prod.cprd) as CANTIDAD
	from prov, sumi, prod
	where prov.cprv = sumi.cprv and sumi.cprd = prod.cprd 
	group by prov.cprv, prov.nomb
	having COUNT(DISTINCT prod.cprd) = (select COUNT(cprd) from prod);
	--no hay prov que hayan suministrado todos los prod....
	GO

/*9) Listar los nombres de los proveedores que suministraron algún producto fuera de su ciudad. */
	GO --USANDO SUBCONSULTAS
	select * 
	from prov
	where prov.cprv IN (select prov.cprv 
						from prov, sumi, alma 
						where prov.cprv = sumi.cprv and sumi.calm = alma.calm and prov.ciud != alma.ciud);
	GO

	GO --USANDO GROUP BY
	select prov.cprv, prov.nomb
	from prov, sumi, alma 
	where prov.cprv = sumi.cprv and sumi.calm = alma.calm and prov.ciud != alma.ciud
	group by prov.cprv, prov.nomb
	GO

/*10) Listar los nombres de los proveedores que suministraron producto en todos los almacenes de la ciudad de Santa Cruz. */
	GO
	select prov.cprv, prov.nomb
	from prov, sumi, alma
	where prov.cprv = sumi.cprv and sumi.calm = alma.calm and alma.ciud = 'SC'
	group by prov.cprv, prov.nomb
	having COUNT(DISTINCT alma.calm) = (select COUNT(calm) from alma where alma.ciud = 'SC');
	GO

	--//sirve para comprobar el ejercicio
	/*
	select * from alma;
	insert into alma(calm, noma, ciud) values (5,'LA COLORADA','SC');
	insert into alma(calm, noma, ciud) values (6,'EL RANCHO','SC');
	insert into alma(calm, noma, ciud) values (7,'INDUSTRIAS PIL','SC');

	select * from sumi;
	insert into sumi(cprv,calm,cprd,ftra,cant,prec,impt) values (3,5,2,GETDATE(),20,5,100);
	insert into sumi(cprv,calm,cprd,ftra,cant,prec,impt) values (3,6,2,GETDATE(),20,5,100);
	insert into sumi(cprv,calm,cprd,ftra,cant,prec,impt) values (3,7,2,GETDATE(),20,5,100);
	*/
	GO

------------------------------------------------------------------------------------------------------------------------
----------------------------- USO DE FUNCIONES AGREGADAS SUM, AVG, COUNT, MAX y MIN ------------------------------------
------------------------------------------------------------------------------------------------------------------------
	GO

/* 1) Mostrar el Stock existente del producto PRD1 en la ciudad de Santa ruz. */
	select prod.cprd as CODIGO_PROD,
		   prod.nomp as NOMBRE_PROD,
		   SUM(sumi.cant) as STOCK
	from sumi, prod, alma
	where sumi.cprd = prod.cprd and sumi.calm = alma.calm
		and prod.nomp = 'PRD1' and alma.ciud = 'SC'
	group by prod.cprd, prod.nomp;
	GO

/* 2) Mostrar el Inventario Valorado del producto PRD2. */
	select prod.cprd, 
		   prod.nomp, 
		   SUM(sumi.impt) as INVENTARIO_VALORADO
	from prod, sumi
	where prod.cprd = sumi.cprd
		and prod.nomp = 'PRD2'
	group by  prod.cprd, prod.nomp;
	GO

/* 3) Mostrar la cantidad más alta suministrada del producto PRD1 en la ciudad de La Paz. */
	select MAX(sumi.cant) as CANT_MAS_ALTA
	from sumi, prod, alma
	where sumi.cprd = prod.cprd and sumi.calm = alma.calm
		and prod.nomp = 'PRD1';
	GO

/* 4) Mostrar la última fecha que se suministró el producto PRD1 por el proveedor PRV3. */
	select MAX(sumi.ftra) as ULTIMA_FECHA_SUMINISTRADA
	from prod, sumi
	where prod.cprd = sumi.cprd 
		and prod.nomp = 'PRD1';
	GO

/* 5) Mostrar en qué fecha por primera vez suministró algún producto de color Rojo el proveedor PRV1. */
	select MIN(sumi.ftra) as FECHA_PRIMER_PROD
	from sumi, prod, prov
	where sumi.cprd = prod.cprd and sumi.cprv = prov.cprv
		and prod.colo = 'ROJO' and prov.nomb = 'PROV1';
	GO

/* 6) Mostrar el importe promedio de productos suministrados por el proveedor PRV3. */
	select AVG(sumi.impt) as IMPORTE_PROMEDIO
	from sumi, prov
	where sumi.cprv = prov.cprv
		and prov.nomb = 'PROV3';
	GO

/* 7) Mostrar el Stock existente de cada producto existente en la ciudad de Santa Cruz. */
	select prod.cprd, prod.nomp, SUM(cant) as STOCK
	from sumi, prod, alma
	where sumi.cprd = prod.cprd and sumi.calm = alma.calm
		and alma.ciud = 'SC'
	group by prod.cprd, prod.nomp;
	GO

/* 8) Mostrar el Inventario Valorado existente por cada almacén. */
	select alma.calm, alma.noma, SUM(sumi.impt)
	from sumi, alma
	where sumi.calm = alma.calm
	group by alma.calm, alma.noma;
	GO
	--NOTA:hay 2 almacenes con el mismo nombre 'ALM3' que se encuentran en ciudades diferentes.

/* 9) Mostrar la cantidad más alta suministrada de cada producto en la ciudad de La Paz, siempre que la 
	  cantidad total de cada producto supere a 20. */
	select prod.cprd, prod.nomp, MAX(sumi.cant) as CANTIDAD_MAS_ALTA
	from sumi, prod, alma
	where sumi.cprd = prod.cprd and sumi.calm = alma.calm
		and alma.ciud = 'LP'
	group by prod.cprd, prod.nomp
	having MAX(sumi.cant) > 20;
	GO

/* 10) Mostrar la última fecha de cada producto suministrada por el proveedor PRV3. */
	select prod.cprd, prod.nomp, MAX(sumi.ftra) as ULTIMA_FECHA_SUMI
	from prod, sumi, prov
	where prod.cprd = sumi.cprd and sumi.cprv = prov.cprv
		and prov.nomb = 'PROV3'
	group by prod.cprd, prod.nomp
	GO

/* 11) Mostrar por cada proveedor cual fue la fecha que por primera vez suministró algún producto. */
	select prov.cprv, prov.nomb, MIN(sumi.ftra) as FECHA_PRIMER_SUM
	from prov, sumi
	where prov.cprv = sumi.cprv
	group by prov.cprv, prov.nomb
	GO

/* 12) Mostrar el importe promedio en cada almacén y por cada producto suministrado. */
	select alma.calm, alma.noma, CAST(AVG(sumi.impt) as decimal(12,2)) as IMPORTE_PROMEDIO, prod.nomp
	from sumi, alma, prod
	where sumi.calm = alma.calm and sumi.cprd = prod.cprd
	group by alma.calm, alma.noma, prod.nomp
	order by alma.noma, prod.nomp
