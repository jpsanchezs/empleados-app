CREATE PROCEDURE dbo.ListarMovimientosPorEmpleado
    @inValorDocumentoIdentidad NVARCHAR(100)
    , @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Mostrar encabezado: nombre y saldo actual
        SELECT 
            E.ValorDocumentoIdentidad
            , E.Nombre
            , E.SaldoVacaciones
        FROM dbo.Empleado E
        WHERE E.ValorDocumentoIdentidad = @inValorDocumentoIdentidad;

        -- Mostrar lista de movimientos
        SELECT 
            M.Fecha
            , TM.Nombre AS TipoMovimiento
            , M.Monto
            , M.NuevoSaldo
            , U.Username AS RegistradoPor
            , M.PostIP
            , M.PostTime
        FROM dbo.Movimiento M
        INNER JOIN dbo.Empleado E ON E.Id = M.IdEmpleado
        INNER JOIN dbo.TipoMovimiento TM ON TM.Id = M.IdTipoMovimiento
        INNER JOIN dbo.Usuario U ON U.Id = M.IdPostByUser
        WHERE E.ValorDocumentoIdentidad = @inValorDocumentoIdentidad
        ORDER BY M.Fecha DESC;

        SET @outResultCode = 0;
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DBError (
            UserName
            , Number
            , State
            , Severity
            , Line
            , ProcedureName
            , Message
            , PostTime)
        VALUES (
            SUSER_SNAME()
            , ERROR_NUMBER()
            , ERROR_STATE()
            , ERROR_SEVERITY()
            , ERROR_LINE()
            , ERROR_PROCEDURE()
            , ERROR_MESSAGE()
            , SYSUTCDATETIME());

        SET @outResultCode = 50008;
    END CATCH

    SET NOCOUNT OFF;
END
