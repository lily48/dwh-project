-- Create Dim_Date Table
IF OBJECT_ID('[dbo].[Dim_Date]') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[Dim_Date]
END

CREATE EXTERNAL TABLE [dbo].[Dim_Date] WITH(
    LOCATION = 'bikedb/Dim_Date',
    DATA_SOURCE = [dlthi3synfile_dlthi3synsa_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY Payment_Date) AS Date_Id,
        TRY_CONVERT(DATE, Payment_Date) as Date,
        DATEPART(DAY, TRY_CONVERT(DATE, Payment_Date)) AS DAY,
        DATEPART(MONTH, TRY_CONVERT(DATE, Payment_Date)) AS MONTH, 
        DATEPART(QUARTER, TRY_CONVERT(DATE, Payment_Date)) AS QUARTER,
        DATEPART(YEAR, TRY_CONVERT(DATE, Payment_Date)) AS  YEAR,
        DATEPART(DAYOFYEAR,TRY_CONVERT(DATE, Payment_Date)) AS DAY_OF_YEAR,
        DATEPART(WEEKDAY,TRY_CONVERT(DATE, Payment_Date)) AS DAY_OF_WEEK
    FROM
        [dbo].[staging_payment]
);

SELECT TOP 100 * FROM [dbo].[Dim_Date];