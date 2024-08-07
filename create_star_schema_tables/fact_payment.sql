-- Ensure any existing external table is dropped
IF OBJECT_ID('dbo.fact_payment') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[fact_payment]
END

GO;

-- Create the external table using CETAS
CREATE EXTERNAL TABLE [dbo].[fact_payment]
WITH (
    LOCATION = 'StarSchema/fact_payment',
    DATA_SOURCE = [AZURESTORAGE],
    FILE_FORMAT = [TEXTFILEFORMAT]
)
AS
SELECT
    [RIDER_ID] AS [account_number],
    [PAYMENT_ID] AS [payment_id],
    CONVERT(datetime2, [DATE]) AS [date],
    [AMOUNT] AS [amount]
FROM [dbo].[PAYMENT]
GO;

-- Query the external table
SELECT TOP 100 * FROM [dbo].[fact_payment];

