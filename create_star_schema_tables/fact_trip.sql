-- Ensure any existing external table is dropped
IF OBJECT_ID('dbo.fact_trip', 'E') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[fact_trip]
END

GO;

-- Create the fact external table using CETAS
CREATE EXTERNAL TABLE [dbo].[fact_trip]
WITH (
    LOCATION = 'StarSchema/fact_trip',
    DATA_SOURCE = [AZURESTORAGE],
    FILE_FORMAT = [TEXTFILEFORMAT]
)
AS
SELECT
    tr.[TRIP_ID] AS [trip_id],
    CONVERT(DATETIME2, tr.[START_AT], 120) AS [trip_start_at],
    CONVERT(DATETIME2, tr.[END_AT], 120) AS [trip_end_at],
    tr.[RIDEABLE_TYPE] AS [rideable_type],
    tr.[START_STATION_ID] AS [start_station_id],
    tr.[END_STATION_ID] AS [end_station_id],
    (DATEDIFF(YEAR, r.[BIRTHDAY], CONVERT(DATETIME, SUBSTRING(tr.[START_AT], 1, 19), 120)) - 
        (CASE WHEN MONTH(r.[BIRTHDAY]) > MONTH(CONVERT(DATETIME, SUBSTRING(tr.[START_AT], 1, 19), 120)) 
            OR (MONTH(r.[BIRTHDAY]) = MONTH(CONVERT(DATETIME, SUBSTRING(tr.[START_AT], 1, 19), 120)) 
            AND DAY(r.[BIRTHDAY]) > DAY(CONVERT(DATETIME, SUBSTRING(tr.[START_AT], 1, 19), 120))) 
            THEN 1 ELSE 0 END)) AS [rider_age_at_trip_start],
    DATEDIFF(SECOND, tr.[START_AT], tr.[END_AT]) AS [trip_duration_in_second],
    r.[RIDER_ID] AS [account_number]
FROM [dbo].[TRIP] tr
FULL JOIN [dbo].[RIDER] r ON tr.[RIDER_ID] = r.[RIDER_ID]
GO;

-- Query the fact external table
SELECT TOP 100 * FROM [dbo].[fact_trip];
