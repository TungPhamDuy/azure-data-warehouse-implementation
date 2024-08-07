CREATE DATABASE tungpham
USE tungpham

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Tung09022001'

CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential   
WITH 
    IDENTITY = 'SHARED ACCESS SIGNATURE',
    SECRET = 'sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupyx&se=2024-08-07T19:29:00Z&st=2024-08-07T11:29:00Z&spr=https,http&sig=J52pw%2BgjkHauQ%2FJV2NP6588UtumdJbmutE%2FYtEELR2w%3D';

CREATE USER Test FOR LOGIN admin_tung
GRANT REFERENCES ON DATABASE SCOPED CREDENTIAL::AzureStorageCredential TO Test

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'AzureStorage')
CREATE EXTERNAL DATA SOURCE AzureStorage WITH (
    LOCATION = 'wasbs://tungpham@tungpham.blob.core.windows.net',
    CREDENTIAL = AzureStorageCredential
);
GO

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseParquetFormat')
CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat]
WITH (FORMAT_TYPE = Parquet)
GO

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'TextFileFormat')
CREATE EXTERNAL FILE FORMAT TextFileFormat
WITH (FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '"',
        USE_TYPE_DEFAULT = FALSE
    ))
GO