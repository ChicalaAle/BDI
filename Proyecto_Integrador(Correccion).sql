-- Configuraci�n inicial
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go;

-- Creaci�n de �ndice agrupado en la tabla gasto
CREATE CLUSTERED INDEX IX_gasto_periodo ON gasto (periodo);
go;

-- Creaci�n de usuarios y asignaci�n de permisos
CREATE LOGIN UsuarioAdmin WITH PASSWORD = 'pwAdmin';
CREATE LOGIN UsuarioSoloLectura WITH PASSWORD = 'pwSoloLectura';

CREATE USER UsuarioAdmin FOR LOGIN UsuarioAdmin;
ALTER ROLE db_owner ADD MEMBER UsuarioAdmin;

CREATE USER UsuarioSoloLectura FOR LOGIN UsuarioSoloLectura;
ALTER ROLE db_datareader ADD MEMBER UsuarioSoloLectura;

-- Creaci�n de procedimiento almacenado y permisos
GRANT EXECUTE ON dbo.InsertarAdministrador TO UsuarioSoloLectura;

-- Inserciones con usuarios y prueba de permisos
EXECUTE AS LOGIN = 'UsuarioAdmin';
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Admin', 'S', '123456', 'M', GETDATE());
REVERT;

EXECUTE AS LOGIN = 'UsuarioSoloLectura';
-- La siguiente instrucci�n deber�a fallar debido a los permisos revocados
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Admin', 'S', '123456', 'M', GETDATE());
REVERT;

-- Ejecuci�n de procedimientos almacenados con diferentes usuarios
EXECUTE AS LOGIN = 'UsuarioAdmin'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
REVERT;

EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
REVERT;

-- Revocaci�n de permisos y prueba posterior
REVOKE EXECUTE ON dbo.InsertarAdministrador FROM UsuarioSoloLectura;

EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
-- La siguiente instrucci�n deber�a fallar debido al permiso revocado
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
REVERT;

-- Creaci�n de tabla y trigger para auditor�a
-- (Suponiendo que auditoria es una tabla v�lida)
-- (Crea la tabla antes de ejecutar este bloque)
-- (Crea el trigger antes de ejecutar este bloque)
-- ...

-- Ejecuci�n de operaciones con trigger
EXECUTE AS LOGIN = 'UsuarioAdmin'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
REVERT;

EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministrador 'RONCAGLIA ALFREDO ALEJANDRO', 'S', 3794244222, 'M', '19220828';
REVERT;

-- Creaci�n de usuario para vistas
CREATE LOGIN UsuarioVista WITH PASSWORD = 'pwVista';
CREATE USER UsuarioVista FOR LOGIN UsuarioVista;

-- Asignaci�n de permisos de select en la tabla administrador
GRANT SELECT ON dbo.administrador TO UsuarioVista;

-- Prueba de permisos con vista
EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * FROM dbo.VistaAdministrador; -- La vista deber�a mostrarse
REVERT;

-- Revocaci�n de permisos y prueba posterior
REVOKE SELECT ON dbo.administrador FROM UsuarioVista;

EXECUTE AS LOGIN = 'UsuarioVista'; 
-- La siguiente instrucci�n deber�a fallar debido al permiso revocado
SELECT * FROM dbo.VistaAdministrador;
REVERT;

-- Creaci�n de �ndices columnares
USE base_consorcio;

-- Creaci�n de �ndice columnar en la tabla gasto
CREATE CLUSTERED COLUMNSTORE INDEX IX_Columnares_gasto ON gasto;

-- Carga masiva de datos en la tabla gasto
-- (Suponiendo que gasto es una tabla v�lida)
-- ...

-- Eliminaci�n de �ndices anteriores y creaci�n de nuevos �ndices
DROP INDEX IX_gasto_periodo ON gasto;

CREATE CLUSTERED INDEX IX_Gasto_Periodo_FechaPago_idTipoGasto
ON gasto (periodo, fechapago, idtipogasto);

-- Ejecuci�n de consulta con nuevos �ndices
SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8;
