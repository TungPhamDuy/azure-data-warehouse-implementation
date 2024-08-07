-- Drop the existing external table if it exists
IF OBJECT_ID('dbo.dim_time', 'E') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[dim_time]
END
GO

-- Create the time dimension external table using CETAS
CREATE EXTERNAL TABLE [dbo].[dim_time]
WITH (
    LOCATION = 'StarSchema/dim_time',
    DATA_SOURCE = [AZURESTORAGE],
    FILE_FORMAT = [TEXTFILEFORMAT]
)
AS
SELECT DISTINCT
    p.[date] AS [datetime],
    DATENAME(WEEKDAY, p.[date]) AS [dayOfWeek],
    DATEPART(DAY, p.[date]) AS [day],
    SUBSTRING(DATENAME(MONTH, p.[date]), 1, 3) AS [month],
    DATEPART(QUARTER, p.[date]) AS [quater],
    DATEPART(YEAR, p.[date]) AS [year],
    DATEPART(HOUR, p.[date]) AS [hourOfDay],
    DATEPART(MINUTE, p.[date]) AS [minutes],
    DATEPART(SECOND, p.[date]) AS [seconds],
    CASE WHEN DATEPART(WEEKDAY, p.[date]) IN (6, 7) THEN 'TRUE' ELSE 'FALSE' END AS [isWeekend]
FROM [dbo].[payment] p
GO

-- Query the external table
SELECT TOP 100 * FROM [dbo].[dim_time];
GO
