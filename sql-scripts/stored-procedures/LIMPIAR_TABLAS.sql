-- Desactivar restricciones temporales
ALTER TABLE dbo.Movimiento NOCHECK CONSTRAINT ALL;
ALTER TABLE dbo.BitacoraEvento NOCHECK CONSTRAINT ALL;

-- Eliminar datos en orden seguro
DELETE FROM dbo.Movimiento;
DELETE FROM dbo.BitacoraEvento;
DELETE FROM dbo.Empleado;
DELETE FROM dbo.Usuario;
DELETE FROM dbo.Puesto;
DELETE FROM dbo.TipoMovimiento;
DELETE FROM dbo.TipoEvento;
DELETE FROM dbo.Error;
DELETE FROM dbo.DBError;

-- Reactivar restricciones
ALTER TABLE dbo.Movimiento CHECK CONSTRAINT ALL;
ALTER TABLE dbo.BitacoraEvento CHECK CONSTRAINT ALL;

-- Reiniciar IDs
DBCC CHECKIDENT ('dbo.Movimiento', RESEED, 0);
DBCC CHECKIDENT ('dbo.BitacoraEvento', RESEED, 0);
DBCC CHECKIDENT ('dbo.Empleado', RESEED, 0);
DBCC CHECKIDENT ('dbo.Usuario', RESEED, 0);
DBCC CHECKIDENT ('dbo.Puesto', RESEED, 0);
DBCC CHECKIDENT ('dbo.TipoMovimiento', RESEED, 0);
DBCC CHECKIDENT ('dbo.TipoEvento', RESEED, 0);
DBCC CHECKIDENT ('dbo.Error', RESEED, 0);
DBCC CHECKIDENT ('dbo.DBError', RESEED, 0);
