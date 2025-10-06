-- Paso 1: Crear credencial (solo se hace una vez por base de datos)
CREATE DATABASE SCOPED CREDENTIAL AzureBlobCredential
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = 'sp=racwdyti&st=2025-10-20T18:53:08Z&se=2025-10-21T21:08:08Z&spr=https&sv=2024-11-04&sr=b&sig=Ax8fmqz4QiV%2F%2Bwhdol3XmJ2GzTqMeA%2B9MF5n%2BuVCVUY%3D';

-- Paso 2: Crear fuente de datos externa (solo se hace una vez)
CREATE EXTERNAL DATA SOURCE AzureBlobDataSource
WITH (
    TYPE = BLOB_STORAGE
    , LOCATION = 'https://filesxmlsqlserver.blob.core.windows.net/xmlfiles'
    , CREDENTIAL = AzureBlobCredential
);

-- Paso 3: Leer el archivo XML desde Azure Blob Storage
DECLARE @XML XML;

SELECT @XML = CAST(BulkColumn AS XML)
FROM OPENROWSET(
    BULK 'DatosOrdenados_corregido.xml'
    , DATA_SOURCE = 'AzureBlobDataSource'
    , SINGLE_BLOB
) AS Archivo;

-- Paso 4: Ejecutar el SP con el XML cargado
DECLARE @ResultCode INT;

EXEC dbo.CargarDatosDesdeXML
    @inXML = @XML
    , @outResultCode = @ResultCode OUTPUT;

-- Paso 5: Mostrar resultado
SELECT @ResultCode AS CodigoResultado;
