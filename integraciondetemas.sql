---------------------------------------------------MANEJO DE PERMISOS-----------------------------------------------------------------


--------------------------------------------------------TRIGGERS----------------------------------------------------------------------
--crear registro de actividad, para ello es necesario una tabla llamada auditoria, esta tendra como funcion registrar
--operaciones que afecten al contenido de la base de datos, proporcionando así un
--registro de actividad
USE base_consorcio
go

CREATE TABLE auditoria (
    id_auditoria int identity primary key,
    tabla_afectada varchar(100),  
	columna_afectada varchar(100), 
    accion varchar(10),           
    fecha_hora datetime,          
    usuario varchar(50),        
    valor_anterior varchar(max),  
    valor_actual varchar(max),     
);

--- CREAR LOS TRIGGERS CON LOS SCRIPTS "conserjeTriggerUpdate" "conserjeTriggerDelete" "conserjeTriggerInsert" dentro de la carpeta triggers de la tabla conserje (click derecho---> insertar trigger)

---Probamos los triggers agregando registros
INSERT INTO conserje (apeynom, tel, fechnac, estciv)
VALUES ('Juan Pérez', '5551234567', '1985-03-15', 'S');

INSERT INTO conserje (apeynom, tel, fechnac, estciv)
VALUES ('María González', '5559876543', '1990-08-22', 'C');

INSERT INTO conserje (apeynom, tel, fechnac, estciv)
VALUES ('Carlos Rodríguez', '5555555555', '1982-12-10', 'D');

--probamos modicficando
UPDATE conserje
SET tel = '5551112222'
WHERE idconserje = 1;
UPDATE conserje
SET estciv = 'O'
WHERE idconserje = 2;

---probamos eliminando
DELETE FROM conserje
WHERE idconserje = 3;


--Estas acciones deben verse reflejadas en la tabla auditoria

------------------------------------------------------Backup y Backup en linea-----------------------------------------------------------


-- 1 Verificar el modo de recuperacion de la base de datos


SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'base_consorcio';


-- 2 cambiamos el modo de recuperacion

USE master; -- Asegúrate de estar en el contexto de la base de datos master
ALTER DATABASE base_consorcio
SET RECOVERY FULL;

-- 3 Realizamos backup de la base de datos

BACKUP DATABASE base_consorcio
TO DISK = 'C:\backup\consorcio_backup.bak'
WITH FORMAT, INIT;

-- Agregamos 10 registros

select * from gasto;

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (1,1,1,5,GETDATE(),5,1200);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (1,2,2,5,GETDATE(),2,1630);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (3,20,2,2,GETDATE(),4,500);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (5,3,1,3,GETDATE(),3,1520);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (5,12,3,4,GETDATE(),5,1120);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (6,45,2,4,GETDATE(),4,2000);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (14,36,2,2,GETDATE(),1,1740);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (18,3,1,2,GETDATE(),2,1520);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (2,48,1,5,GETDATE(),2,1500);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (13,10,2,1,GETDATE(),1,1420);


-- 4 Realizamos backup del log de la base de datos

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\LogBackup.trn'
WITH FORMAT, INIT;


-- Insertamos 10 registros mas

select * from gasto

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (1,1,1,5,GETDATE(),5,1200);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (2,48,1,5,GETDATE(),2,1500);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (3,16,1,2,GETDATE(),4,2300);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (4,21,1,3,GETDATE(),3,1000);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (5,3,1,2,GETDATE(),5,1500);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (6,45,2,4,GETDATE(),4,2000);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (8,17,2,2,GETDATE(),1,1300);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (9,14,1,3,GETDATE(),2,1700);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (12,7,4,2,GETDATE(),3,2100);

insert into gasto (idprovincia,idlocalidad,idconsorcio,periodo,fechapago,idtipogasto,importe) 
values (13,10,2,1,GETDATE(),1,1100);


--5 Realizamos backup del log en otra ubicacion

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\logs\LogBackup2.trn'
WITH FORMAT, INIT;

--6 Restauramos el backup de la base de datos

use master

RESTORE DATABASE base_consorcio
FROM DISK = 'C:\backup\consorcio_backup.bak'
WITH REPLACE, NORECOVERY;

RESTORE LOG base_consorcio
FROM DISK = 'C:\backup\LogBackup.trn'
WITH RECOVERY;

-- Segundo log

RESTORE LOG base_consorcio
FROM DISK = 'C:\backup\logs\LogBackup2.trn'
WITH RECOVERY;

select * from gasto

------------------------------------------------------- INDICES COLUMNARES--------------------------------------------------------------
use base_consorcio;



--select * from gasto;


--CARGA DE UN MILLON DE REGISTROS
--INSERCION POR LOTES

select * from gasto;

declare @tamanioLote int = 1000; -- Tama�o del lote
declare @cont int = 1;     -- Contador de lotes

-- Inicia un bucle para la inserci�n por lotes
while @cont <= 1000000 -- Cambia 1000 por el n�mero de lotes necesarios para un mill�n de registros
begin
    insert into gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    select top (@tamanioLote) idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
    from gasto
    --where idgasto not in (select idgasto from gasto); -- Evita duplicados

    set @cont = @cont + 1;
end;



-- Declarar el tama�o del lote y el contador
DECLARE @BatchSize INT = 1000; -- Tama�o del lote
DECLARE @Counter INT = 1;     -- Contador de lotes

-- Iniciar un bucle para la inserci�n por lotes
WHILE @Counter <= 1000000 -- Cambia 1000 al n�mero de lotes necesarios para un mill�n de registros
BEGIN
    -- Insertar registros desde gasto a gastoNew en lotes
    INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    SELECT TOP (@BatchSize) idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
    FROM gasto
    WHERE idgasto NOT IN (SELECT idgasto FROM gasto); -- Evitar duplicados

    SET @Counter = @Counter + 1;
END;

insert into gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
select idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
from gasto
order by idgasto
offset 0 rows
fetch next 1000000 rows only; -- Ajusta el tama�o del lote seg�n tus necesidades*/

INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
SELECT idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe
FROM (
    SELECT idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe,
           ROW_NUMBER() OVER (ORDER BY idgasto) AS RowNumber
    FROM gasto
) AS Subquery
WHERE RowNumber BETWEEN 1 AND 1000000; -- Ajusta el tama�o del lote seg�n tus necesidades
-----------------------------------------------------------------------------------------------------------------------------------------




----------------------------------------------Optimización de busqueda a travez de indices----------------------------------------------
--PRIMER EJECUCION DE CONSULTA 
--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go


--SEGUNDA EJECUCION DE CONSULTA ----------------------------------------------------------------------------

--SqlServer toma la PK de gasto como indice CLUSTERED, asique para crear el solicitado en periodo debemos primero eliminar el actual
ALTER TABLE gasto
DROP CONSTRAINT PK_gasto;
go

--Transformamos la PK en un indice NONCLUSTERED
ALTER TABLE gasto
ADD CONSTRAINT PK_gasto PRIMARY KEY NONCLUSTERED (idGasto);
go

--Creamos un nuevo indice CLUSTERED en periodo
CREATE CLUSTERED INDEX IX_gasto_periodo
ON gasto (periodo);
go
--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go


--TERCER EJECUCION DE CONSULTA------------------------------------------------------------------
-- Elimina el �ndice agrupado anterior
DROP INDEX IX_gasto_periodo ON gasto;
go

-- Crea un nuevo �ndice agrupado en periodo, fechapago e idtipogasto
CREATE CLUSTERED INDEX IX_Gasto_Periodo_FechaPago_idTipoGasto
ON gasto (periodo, fechapago, idtipogasto);
go

--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go

------------------------------------------------- Manejo de Transacciones y transacciones anidadas--------------------------------------

-- USE base_consorcio;

-- CREACION DE LAS TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (999, 1, 1, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- GENERAMOS UN ERROR INGRESANDO EL ID PROVINCIA 999 QUE NO EXISTE.
	
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH

-----------------------------------------------

--- CASO Transacción Terminada 
-- USE base_consorcio;

-- CREACION DE TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (1, 1, 3, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- AHORA INGRESAMOS EL CONSORCIO SIN INTENCION DE ERROR.
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH

-- LAS SIGUIENTES CONSULTAS VERIFICAN LOS RESULTADOS DE LAS PRUEBAS SOBRE TRANSACCIONES PLANAS 
-----------------------------------------------
 -- NOS MUESTRA CUAL FUE EL ULTIMO REGISTRO DE ADMINISTRADOR CARGADO
SELECT TOP 1 * FROM administrador ORDER BY idadmin DESC; 

 -- MUESTRA LOS DATOS DEL CONSORCIO CON LA DIRECCION EN CUESTION (EXITE O NO)
SELECT * FROM consorcio WHERE direccion = 'PARAGUAY N 999';

-- MUESTRA LOS ULTIMOS 3 REGISTROS DE GASTOS CARGADOS
SELECT TOP 3 * FROM gasto ORDER BY idgasto DESC; 
-----------------------------------------------


-----------------------------------------------
--- CASO Transacción Anidada fallida
-- USE base_consorcio;

-- CREACION DE TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito clavounclavito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (1, 1, 3, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- GENERAMOS UN ERROR INGRESANDO EL ID PROVINCIA 999 QUE NO EXISTE.

	-------------------------
	BEGIN TRAN -- COMENZAMOS UNA TRANSACCION ANIDADA
		UPDATE consorcio SET nombre = 'EDIFICIO-222'; -- ACTUALIZAMOS EL REGISTRO DE CONSORCIO QUE CARGAMOS ANTES
		INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) 
			VALUES (1,1,1,6,'20130616',20,608.97) -- INSERT A LA TABLA GASTO, DEBE DAR UN ERROR POR TIPO DE GASTO
	COMMIT TRAN -- FINALIZAMOS UNA TRANSACCION ANIDADA
	------------------------

	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH




-----------------------------------------------
--- CASO Transacción Anidada 
-- USE base_consorcio;

-- CREACION DE TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito clavounclavito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (1, 1, 3, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- GENERAMOS UN ERROR INGRESANDO EL ID PROVINCIA 999 QUE NO EXISTE.

	-------------------------
	BEGIN TRAN -- COMENZAMOS UNA TRANSACCION ANIDADA
		UPDATE consorcio SET nombre = 'EDIFICIO-222'; -- ACTUALIZAMOS EL REGISTRO DE CONSORCIO QUE CARGAMOS ANTES
		INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) 
			VALUES (1,1,1,6,'20130616',5,608.97) -- INSERT A LA TABLA GASTO, DEBE DAR UN ERROR POR TIPO DE GASTO
	COMMIT TRAN -- FINALIZAMOS UNA TRANSACCION ANIDADA
	------------------------

	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH

-----------------------------------------------
-----------------------------------------------
-- LAS SIGUIENTES CONSULTAS VERIFICAN LOS RESULTADOS DE LAS PRUEBAS SOBRE TRANSACCIONES ANIDADAS 
-----------------------------------------------
 -- NOS MUESTAR CUAL FUE EL ULTIMO REGISTRO DE ADMINISTRADOR CARGADO
SELECT TOP 1 * FROM administrador ORDER BY idadmin DESC; 

 -- MUESTRA LOS DATOS DEL CONSORCIO CON LA DIRECCION EN CUESTION (EXITE O NO)
SELECT * FROM consorcio WHERE direccion = 'PARAGUAY N 999';

-- MUESTAR LOS ULTIMOS 3 REGISTROS DE GASTOS CARGADOS
SELECT TOP 4 * FROM gasto ORDER BY idgasto DESC; 



-------------------------------------------------------------- Vistas y vistas Indexadas--------------------------------------------------

-- NOTA PRINCIPAL 
-- Al crear la base de datos, crearla con el campo "fechaPago" de la tabla "gasto" como campo único para que después al crear el índice para la vista indexada no se generen errores.



-- 2) Crear una vista sobre la tabla administrador que solo muestre los campos apynom, sexo  y fecha de nacimiento.
USE base_consorcio;

CREATE VIEW vistaAdministrador AS
SELECT apeynom, sexo, fechnac
FROM administrador;

SELECT * FROM vistaAdministrador;




-- 3) Realizar insert de un lote de datos sobre la vista recien creada. Verificar el resultado en la tabla administrador.
-- NOTA: Al realizar el insert a la vista, se agragan los campos insertados con normalidad y, los campos cuyos valores no se especificaron (ya que la vista solo trabaja con ciertos campos y no con todos) se cargan los valores que se asignan por defecto a la hora de crear un registro.
-- OBSERBACIÓN: Al cargar un registro sin especificar una "fechnac" este se crea sin inconvenientes. Tal vez se debería agregar una restricción para que éste campo sea cargado con una fecha válida obligatoriamente (NOT NULL). Y al insertarse un nuevo registro, este debe tener mas de uno o dos caracteres en su campo "apeynom", ya que es un dato que cualquier persona tiene.
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('BASUALDO DELMIRA', 'F', '19801009')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('SEGOVIA ALEJANDRO H.', 'M', '19740602')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('ROMERO ELEUTERIO', 'M', '19720819')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('NAHMIAS DE K. NIDIA', 'F', '19711128')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('CORREA DE M. MARIA G.', 'F', '19900116')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('NAHMIAS JOSE', 'M', '19740902')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('NAHMIAS DE R. REBECA J.', 'F', '19890307')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('LOVATO CERENTTINI ISABEL', 'F', '19731015')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('GOMEZ MATIAS GABRIEL', 'M', '19740320')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('CORREA HUGO E.', 'M', '19930811')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('MACHUCA CEFERINA', 'F', '19910916')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('CARDOZO MAXIMA', 'F', '19881107')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('', 'F', ''); -- Prueba en restricciones faltantes.

select * from vistaAdministrador ;



-- 4) Realizar update sobre algunos de los registros creados y volver a verificar el resultado en la tabla.
-- NOTA: Se actualiza el registro normalmente.
-- OBSERVACIÓN: Al actualizar un registro, éste debe tener un campo clave para poder acceder a el y asegurarnos de que es el único con dicho valor en ese campo clave. Tal vez deberíamos agregar a la vista el campo (índice) "idadmin" para solucionar este inconveniente. 
Update vistaAdministrador set fechnac = '19990916' where apeynom = 'CARDOZO PRUEBA';
select * from administrador order by idadmin desc;




-- 5) Borrar todos los registros insertados a través de la vista.
-- OBSERVACIÓN: Para eliminar los registros creados con la vista tuve que comparar en los registros de "administrador" el campo "tel" en donde éstos eran nulos, lo cual no es lo correcto ya que, si se había cargardo un registro con "tel" en null que no haya sido con la vista, éste se eliminaria también. Mi solución sería crear un índice en la vista el cual va ser de gran ayuda para realizar esta operación.
DELETE FROM administrador
WHERE tel is NULL;


-- 6) Crear una vista que muestre los datos de las columnas de las siguientes tablas: (Administrador->Apeynom, consorcio->Nombre, gasto->periodo, gasto->fechaPago, tipoGasto->descripcion) .
CREATE VIEW vistaGeneral 
WITH SCHEMABINDING
AS SELECT [dbo].[administrador].apeynom, [dbo].[consorcio].nombre, [dbo].[gasto].periodo, [dbo].[gasto].fechaPago, [dbo].[tipogasto].descripcion
FROM [dbo].[consorcio]
JOIN [dbo].[administrador] ON [dbo].[administrador].idadmin = [dbo].[consorcio].idadmin 
JOIN [dbo].[gasto] ON [dbo].[gasto].idconsorcio = [dbo].[consorcio].idconsorcio
JOIN [dbo].[tipogasto] ON [dbo].[tipogasto].idtipogasto = [dbo].[gasto].idtipogasto;

select * from vistaGeneral ;



-- 7) Crear un indice sobre la columna fechaPago sobre la vista  recien creada.
-- Coloco el campo "fechaPago" de la tabla "gasto" como unico ya nesesito que éste sea único para luego crear el índice correspondiente a la vista.
-- NOTA: Tuve que vaciar la base de datos para poder crear el indice ya que habian pagos con la misma fecha y la hora y segundo no estaban cargadas(si estas estaban cargadas todos serian únicos). 
ALTER TABLE [dbo].[gasto]
ADD CONSTRAINT unicoFechaPago UNIQUE (fechaPago);

-- Creo el índice para fechaPago
CREATE UNIQUE CLUSTERED INDEX IX_vistaGeneral_FechaPago
ON [dbo].[vistaGeneral] (fechaPago);
select * from vistaGeneral order by nombre asc ;


-----------------------------------------------------REPLICA DE BASE DE DATOS-----------------------------------------------------------
--Primero, es muy importante conocer cuál es el nombre de 
--nuestro equipo.

--También debemos crear una carpeta nueva en cualquier parte de nuestro equipo, la cual nos va 
--a servir para la distribución. Una vez creamos esta carpeta, entramos en ella y anotamos la 
--dirección de su ruta para usarla más adelante.

--NECESITAMOS 3 PERFILES 

--El “Publicador” será el servidor Instancia de SQL server que estará encargado de Publicar la Base 
--de Datos que es la que se va a Replicar a los demás servidores.

--El “Distribuidor” será el encargado de distribuir a los suscriptores la Base de Datos que ha 
--publicado el Publicador. Normalmente el Publicador y el Distribuidor se configuran en el mismo 
--Servidor.
--El “Suscriptor” será la Instancia que reciba la Réplica del Publicador.

--PUBLICADOR -------------------------------------------------------
--Activando servicios
--Es importante comprobar, en primer lugar, si tenemos activados los servicios de Windows 
--requeridos para seguir los pasos de esta sección.
--Apretamos el botón de Windows ---> Buscamos en la barra de búsqueda SQL --> Buscamos y seleccionamos el Administrador de configuración de SQL Server

-- De saer la promera vez debemos activar estos servicios para continuar con la configuración de replicación 
--En los servicios "SQL Server Browser" y "SQL Server Agent":
--Seleccionamos Propiedades. Se nos abrirá una nueva ventana, seleccionamos la pestaña Service. Se nos abrirá 
--una nueva ventana, seleccionamos en Disabled y marcamos la opción Automatic. Por último, 
--apretamos el botón Aceptar y cerramos las ventanas del servicio. Lo msimo con 


--DISTRIBUIDOR-------------------------------------------------------------
--Abrimos SQL Server. Debemos conectarnos al servidor que será el publicador.

---CLick derecho en la carpeta Replication y 
--seleccionar la opción Configure Distribution

--Apretaremos el botón Siguiente hasta llegar a la sección de 
--Snapshot Folder. La dirección que viene de forma predeterminada debemos cambiarla por la 
--ruta que anotamos anteriormente de la carpeta Distribución.

--apretamos el botón Next > hasta llegar al botón Finish, 
--presionamos el botón Finish.

--SUSCRIPTOR--------------------------------------------------------------------
--necesitamos tener instalado SQL Server 
--en otra computadora que esté conectada a nuestra red local o instalar una máquina virtual en 
--nuestra computadora.

--presionamos el botón Connect en el 
--manejador SQL y seleccionamos la opción Database Engine

--colocamos en Sever name el nombre del equipo suscriptor. Usamos la 
--autenticación SQL Server para conectarnos a la base de datos del equipo suscriptor.

--En la base de datos del equipo publicador, desplegamos la pestaña Replication, 
--hacemos clic derecho en Local Subscriptions y seleccionamos New Subscription


--Apretamos el botón Add Subscriber y seleccionamos la opción Add SQL Server 
--Subscriber… En la siguiente ventana, en Server name escribiremos el nombre del equipo 
--del servidor suscriptor.

--Desplegamos la pestaña de Subscription Database, y seleccionamos la base de datos donde los datos van a ser 
--replicados

--Seleccionamos los tres puntos

--Marcamos la opción Run under the SQL Sever Agent service Account

--Marcamos la opción Using the following SQL Server login. Luego, completamos las 
--credenciales de inicio de sesión del servidor suscriptor.

--presionamos el botón Next > hasta finalizar, manteniendo todas las opciones siguientes de forma predeterminada.

----INSERTAMOS REGISTROS
Insert into administrador(apeynom,viveahi,tel,sexo,fechnac) values ('SAUCEDO FAUSTINA', 'S', '3678235639', 'F', '19875523')
Insert into administrador(apeynom,viveahi,tel,sexo,fechnac) values ('GONZALEZ LIDIA ESTER', 'N', '3671232689', 'F', '19841555')
Insert into administrador(apeynom,viveahi,tel,sexo,fechnac) values ('ARAUJO GUILLERMO JOSE', 'S', '3672235689', 'M', '19551013')

---Estos registros deben verse reflejados en la base correspondiente al perfil suscriptor


---------------------------------------------- Manejo de Usuarios y Optimizacion -------------------------------------------------------

--PRIMER EJECUCION DE CONSULTA -----------------------------------------------------------------
--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;
--Consulta: Gastos del periodo 8 
--Creamos un nuevo indice CLUSTERED en periodo
CREATE CLUSTERED INDEX IX_gasto_periodo
ON gasto (periodo);
go;


-- Se necesita tener una instancia MIXTA para realizar esto
-- Crear dos usuarios de servidor SQL Server:
CREATE LOGIN UsuarioAdmin WITH PASSWORD = 'pwAdmin';
CREATE LOGIN UsuarioSoloLectura WITH PASSWORD = 'pwSoloLectura';

--Crea usuario dentro de la base consorcio
CREATE USER UsuarioAdmin FOR LOGIN UsuarioAdmin;
--Asignar permisos al usuario de administrador:
ALTER ROLE db_owner ADD MEMBER UsuarioAdmin;

--Crea usuario dentro de la base consorcio
CREATE USER UsuarioSoloLectura FOR LOGIN UsuarioSoloLectura;
--Asignar permisos al usuario de solo lectura:
ALTER ROLE db_datareader ADD MEMBER UsuarioSoloLectura;

--Creado previamente el procedimiento almacenado
--Damos acceso al usuario de solo lectura al procedimiento
GRANT EXECUTE ON dbo.InsertarAdministrador TO UsuarioSoloLectura;


-- Inserción con el usuario de administrador
EXECUTE AS LOGIN = 'UsuarioAdmin'; --Execute as login se usa para ejecutar usando permisos especiales
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Admin', 'S', '123456', 'M', GETDATE());
REVERT; --REVERT en SQL Server se utiliza para volver al contexto de seguridad original


-- Inserción con el usuario de solo lectura sin proceso almacenado
EXECUTE AS LOGIN = 'UsuarioSoloLectura';
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Admin', 'S', '123456', 'M', GETDATE()); -- NO PODRA HACERLO 
REVERT;


--Insercion con procedimiento Admin
EXECUTE AS LOGIN = 'UsuarioAdmin'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
REVERT; 

--insercion con procedimiento Solo lectura
EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828'; --si podra ejecutarlo
REVERT; 

-- Revocar permiso de ejecución del procedimiento almacenado
REVOKE EXECUTE ON dbo.InsertarAdministrador FROM UsuarioSoloLectura; 

--Insercion con procedimiento con el permiso revocado
EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828'; --ya no podra ejecutarlo porque le quitamos el permiso
REVERT; 

--Creamos la tabla AUDITORIA para la utilización de TRIGGER

--Creamos TRIGGER para administrador

--Probamos TRIGGER 

	--Insertamos registros con el administrador
	EXECUTE AS LOGIN = 'UsuarioAdmin'; 
	EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
	REVERT; 

	--Visualizamos resultados
	Select * from auditoria

	--Insertamos registros con el usuario de sólo lectura
	EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
	EXEC InsertarAdministrador 'RONCAGLIA ALFREDO ALEJANDRO', 'S', 3794244222, 'M', '19220828'; --si podra ejecutarlo
	REVERT; 

	--Visualizamos resultados
	Select * from auditoria



--///////////////////   EJEMPLO CON VISTAS  ////////////////////////---

--Creamos otro usuario para probar
CREATE LOGIN UsuarioVista WITH PASSWORD = 'pwVista';
CREATE USER UsuarioVista FOR LOGIN UsuarioVista;



--Otrogamos permiso de select en la tabla admin
GRANT SELECT ON dbo.administrador TO UsuarioVista;

EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * from administrador --comprobamos que puede usar select en administrador
REVERT;




--Revocamos los permisos directos de SELECT en la tabla administrador para evitar que el usuario acceda directamente a ella.
REVOKE SELECT ON dbo.administrador FROM UsuarioVista;

EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * from administrador --comprobamos que no puede usar select en administrador
REVERT;




-- Creamos una vista que permitira que solo se visualize las columnas especificadas
CREATE VIEW dbo.VistaAdministrador AS
SELECT idadmin, apeynom, tel, sexo, fechnac
FROM dbo.administrador;

--Otorgamos permisos SELECT al usuario en la vista creada, permitiéndole consultar datos a través de esta vista.
GRANT SELECT ON dbo.VistaAdministrador TO UsuarioVista;

--Probamos la vista
EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * FROM dbo.VistaAdministrador; --aparecera la vista que creamos antes
REVERT;

-- Elimina el �ndice agrupado anterior
DROP INDEX IX_gasto_periodo ON gasto;
go;
