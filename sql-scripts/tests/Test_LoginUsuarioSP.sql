
-- Inserción en tabla dbo.Usuario para prueba
INSERT INTO dbo.Usuario (Username, Password)
VALUES (N'juan.dev', N'Segura123!');

-- Ejecución de SP dbo.LoginUsuario Caso éxitoso
DECLARE @ResultCode INT;

EXEC dbo.LoginUsuario
    @inUsername = N'juan.dev',
    @inPassword = N'Segura123!',
    @inIP = N'192.168.1.100',
    @outResultCode = @ResultCode OUTPUT;

SELECT @ResultCode AS Resultado;

-- Ejecución de SP dbo.LoginUsuario Caso fallido (usuario no existe)
DECLARE @ResultCode INT;

EXEC dbo.LoginUsuario
    @inUsername = N'usuario.inexistente',
    @inPassword = N'CualquierClave',
    @inIP = N'192.168.1.100',
    @outResultCode = @ResultCode OUTPUT;

SELECT @ResultCode AS Resultado;
-- Esperado: 50001

-- Ejecución de SP dbo.LoginUsuario Caso fallido (contraseña errónea)
DECLARE @ResultCode INT;

EXEC dbo.LoginUsuario
    @inUsername = N'juan.dev',
    @inPassword = N'ClaveIncorrecta',
    @inIP = N'192.168.1.100',
    @outResultCode = @ResultCode OUTPUT;

SELECT @ResultCode AS Resultado;
-- Esperado: 50002

-- Ejecución de SP dbo.LoginUsuario Caso fallido (límite de intentos)
DECLARE @ResultCode INT;

-- Repetir este bloque 5 veces
EXEC dbo.LoginUsuario
    @inUsername = N'juan.dev',
    @inPassword = N'ClaveIncorrecta',
    @inIP = N'192.168.1.100',
    @outResultCode = @ResultCode OUTPUT;

-- Luego, ejecutar con la contraseña correcta
EXEC dbo.LoginUsuario
    @inUsername = N'juan.dev',
    @inPassword = N'Segura123!',
    @inIP = N'192.168.1.100',
    @outResultCode = @ResultCode OUTPUT;

SELECT @ResultCode AS Resultado;
-- Esperado: 50003

