CREATE PROCEDURE dbo.ConsultarEmpleado
    @inValorDocumentoIdentidad NVARCHAR(100),
    @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT 
            E.ValorDocumentoIdentidad,
            E.Nombre,
            P.Nombre AS NombrePuesto,
            E.SaldoVacaciones,
            E.EsActivo
        FROM dbo.Empleado E
        INNER JOIN dbo.Puesto P ON P.Id = E.IdPuesto
        WHERE E.ValorDocumentoIdentidad = @inValorDocumentoIdentidad;

        SET @outResultCode = 0;
    END TRY
    BEGIN CATCH
        SET @outResultCode = 50008;
    END CATCH

    SET NOCOUNT OFF;
END
