CREATE PROCEDURE dbo.ActualizarEmpleado
    @inValorDocumentoIdentidad NVARCHAR(100),
    @inNuevoDocumento NVARCHAR(100),
    @inNuevoNombre NVARCHAR(150),
    @inNuevoPuesto NVARCHAR(100),
    @inUserName NVARCHAR(150),
    @inIP NVARCHAR(45),
    @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdEmpleado INT;
    DECLARE @IdUsuario INT;
    DECLARE @IdNuevoPuesto INT;
    DECLARE @Descripcion NVARCHAR(1000) = '';
    DECLARE @EsValido BIT = 1;

    SET @outResultCode = 0;

    BEGIN TRY
        -- Validar usuario
        SELECT @IdUsuario = U.Id FROM dbo.Usuario U WHERE U.Username = @inUserName;
        IF @IdUsuario IS NULL
        BEGIN
            SET @outResultCode = 50001;
            SET @EsValido = 0;
        END;

        -- Validar empleado
        IF @EsValido = 1
        BEGIN
            SELECT @IdEmpleado = E.Id FROM dbo.Empleado E WHERE E.ValorDocumentoIdentidad = @inValorDocumentoIdentidad;
            IF @IdEmpleado IS NULL
            BEGIN
                SET @outResultCode = 50004;
                SET @EsValido = 0;
            END;
        END;

        -- Validar puesto
        IF @EsValido = 1
        BEGIN
            SELECT @IdNuevoPuesto = P.Id FROM dbo.Puesto P WHERE P.Nombre = @inNuevoPuesto;
            IF @IdNuevoPuesto IS NULL
            BEGIN
                SET @outResultCode = 50008;
                SET @EsValido = 0;
            END;
        END;

        -- Validar duplicados
        IF @EsValido = 1 AND EXISTS (
            SELECT 1 FROM dbo.Empleado E WHERE E.ValorDocumentoIdentidad = @inNuevoDocumento AND E.Id <> @IdEmpleado)
        BEGIN
            SET @outResultCode = 50006;
            SET @EsValido = 0;
        END;

        IF @EsValido = 1 AND EXISTS (
            SELECT 1 FROM dbo.Empleado E WHERE E.Nombre = @inNuevoNombre AND E.Id <> @IdEmpleado)
        BEGIN
            SET @outResultCode = 50007;
            SET @EsValido = 0;
        END;

        -- Iniciar transacción solo si hay modificación
        BEGIN TRANSACTION tUpdateEmpleado;

        IF @EsValido = 1
        BEGIN
            UPDATE dbo.Empleado
            SET ValorDocumentoIdentidad = @inNuevoDocumento,
                Nombre = @inNuevoNombre,
                IdPuesto = @IdNuevoPuesto
            WHERE Id = @IdEmpleado;

            SET @Descripcion = 'Update exitoso: antes=' + @inValorDocumentoIdentidad
                            + ', después=' + @inNuevoDocumento
                            + ', Nombre=' + @inNuevoNombre
                            + ', Puesto=' + @inNuevoPuesto;

            INSERT INTO dbo.BitacoraEvento (
                IdTipoEvento, Descripcion, IdPostByUser, PostIP, PostTime)
            VALUES (
                8, @Descripcion, @IdUsuario, @inIP, SYSUTCDATETIME());

            SET @outResultCode = 0;
        END
        ELSE
        BEGIN
            SELECT @Descripcion = Descripcion
            FROM dbo.Error
            WHERE Codigo = CAST(@outResultCode AS NVARCHAR);

            IF @Descripcion IS NULL
                SET @Descripcion = 'Error no registrado | Código=' + CAST(@outResultCode AS NVARCHAR);

            SET @Descripcion = @Descripcion
                + ' | Documento=' + @inNuevoDocumento
                + ', Nombre=' + @inNuevoNombre
                + ', Puesto=' + @inNuevoPuesto;

            INSERT INTO dbo.BitacoraEvento (
                IdTipoEvento, Descripcion, IdPostByUser, PostIP, PostTime)
            VALUES (
                7, @Descripcion, @IdUsuario, @inIP, SYSUTCDATETIME());
        END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        INSERT INTO dbo.DBError (
            UserName, Number, State, Severity, Line, ProcedureName, Message, PostTime)
        VALUES (
            SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(),
            ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), SYSUTCDATETIME());

        SET @outResultCode = 50008;
    END CATCH

    SET NOCOUNT OFF;
END
