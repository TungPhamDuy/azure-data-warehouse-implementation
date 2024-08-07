-- Ensure any existing external table is dropped
IF OBJECT_ID('dbo.dim_station', 'E') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[dim_station]
END

GO;

-- Create the dimension external table using CETAS
CREATE EXTERNAL TABLE [dbo].[dim_station]
WITH (
    LOCATION = 'StarSchema/dim_station',
    DATA_SOURCE = [AZURESTORAGE],
    FILE_FORMAT = [TEXTFILEFORMAT]
)
AS
SELECT
    [STATION_ID] AS [station_id],
    [NAME] AS [station_name],
    [LATITUDE] AS [station_latitude],
    [LONGITUDE] AS [station_longitude]
FROM [dbo].[STATION]
GO;

-- Query the dimension external table
SELECT TOP 100 * FROM [dbo].[dim_station];
