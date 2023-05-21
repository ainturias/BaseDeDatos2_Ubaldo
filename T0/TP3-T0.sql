/*  TP3-T0  */
-- Elaborar la consulta SQL correspondiente  para cada uno de los siguientes requerimientos a la Base de Datos "demo"
use Demo;

-- 1. Listar todos los proveedores
select * from prov;

-- 2. Listar todos los alamcenes
select * from alma;

-- 3. Listar todos los productos
select * from prod;

-- 4. Listar toda la informacion existente en la tabla sumi
select * from sumi;

-- 5. Listar todos los productos de color amarillo
select * from prod where colo = 'AMARILLO';

-- 6. Listar el codigo del producto, nombre del producto y fecha de los productos suministrados por el PROV1
-- Usando la Reunion Natural (JOIN)
	
-- Usando la clausula IN (sub consultas)
	select prod.cprd, prod.nomp, sumi.ftra
	from prod, sumi
	where prod.cprd = sumi.cprd and sumi.cprv IN (select prov.cprv from prov where prov.nomb = 'PROV1');

-- Usando la clausula EXISTS
	select prod.cprd, prod.nomp, sumi.ftra
	from prod, sumi
	where EXISTS (select * from prov where prod.cprd = sumi.cprd and sumi.cprv = prov.cprv and prov.nomb = 'PROV1');
	
-- Usando subconsulta y el operador COUNT()
	select prod.cprd, prod.nomp, sumi.ftra, COUNT(prod.cprd) as CANTIDAD
	from prod, sumi
	where prod.cprd = sumi.cprd and sumi.cprv IN (select prov.cprv from prov where prov.nomb = 'PROV1')
	group by prod.cprd, prod.nomp, sumi.ftra;

-- 7. Listar los proveedores que suministraron algun producto
-- Usando la clausula IN
	select *
	from prov
	where prov.cprv IN (select sumi.cprv from sumi);

-- Usando la clausula EXISTS
	select *
	from prov
	where EXISTS (select * from sumi where prov.cprv = sumi.cprv);

-- Usando COUNT()
	select prov.cprv, prov.nomb, COUNT(prov.cprv) as CANT_PROD_SUM
	from prov, sumi
	where prov.cprv = sumi.cprv
	group by prov.cprv, prov.nomb;

-- Usando JOIN

-- 8. Listar los proveedores que no suministraron producto
-- Usando la clausula IN
	select *
	from prov
	where prov.cprv NOT IN (select sumi.cprv from sumi);

-- Usando la clausula EXISTS
	select *
	from prov
	where NOT EXISTS (select * from sumi where prov.cprv = sumi.cprv);

-- Usando COUNT()
	select prov.cprv, prov.nomb, COUNT(prov.cprv) as CANT_PROV_NO_SUMINISTRARON
	from prov
	where prov.cprv NOT IN (select sumi.cprv from sumi)
	group by prov.cprv, prov.nomb

-- Usando JOIN
	--no se usar join

-- Es posble hacer con JOIN???????
	--creo que no

-- 9. Listar los proveedores que suministraron productos de color rojo
-- hacer JOIN, EXISTS y COUNT

-- JOIN

-- EXISTS
	select * 
	from prov
	where EXISTS (select * from sumi, prod where prov.cprv = sumi.cprv and sumi.cprd = prod.cprd and prod.colo = 'ROJO');
	
-- COUNT
	select prov.cprv, prov.nomb, COUNT(prov.cprv) as CANTIDAD
	from prov, sumi, prod
	where prov.cprv = sumi.cprv and sumi.cprd = prod.cprd
	and prod.colo = 'ROJO'
	group by prov.cprv, prov.nomb

	--select *
	--from prov, sumi, prod
	--where prov.cprv = sumi.cprv and sumi.cprd = prod.cprd
	--and prod.colo = 'ROJO'
	--group by prov.cprv, prov.nomb


