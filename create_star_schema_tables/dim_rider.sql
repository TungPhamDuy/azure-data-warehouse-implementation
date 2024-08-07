-- Ensure any existing external table is dropped
IF OBJECT_ID('dbo.dim_rider') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[dim_rider]
END

GO;

-- Create the dimension external table using CETAS
CREATE EXTERNAL TABLE [dbo].[dim_rider]
WITH (
    LOCATION = 'StarSchema/dim_rider',
    DATA_SOURCE = [AZURESTORAGE],
    FILE_FORMAT = [TEXTFILEFORMAT]
)
AS
SELECT
    [RIDER_ID] AS [account_number],
    [FIRSTNAME] AS [first_name],
    [LASTNAME] AS [last_name],
    [ADDRESS] AS [address],
    CONVERT(DATE, [BIRTHDAY]) AS [birthday],
    CONVERT(DATE, [ACCOUNT_START_DATE]) AS [account_start_date],
    CONVERT(DATE, [ACCOUNT_END_DATE]) AS [account_end_date],
    [IS_MEMBER] AS [is_member]
FROM [dbo].[RIDER]
GO;

-- Query the dimension external table
SELECT TOP 100 * FROM [dbo].[dim_rider];
