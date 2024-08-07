CREATE EXTERNAL TABLE STATION (
    [STATION_ID] NVARCHAR(1000),
    [NAME] NVARCHAR(1000),
    [LATITUDE] FLOAT,
    [LONGITUDE] FLOAT
)
WITH (
    LOCATION = 'Source/publicstation.csv',
    DATA_SOURCE = [AZURESTORAGE],
    FILE_FORMAT = [TEXTFILEFORMAT]
)
GO

SELECT TOP 100 * FROM DBO.STATION
GO