-- CREATE Fact_Payment TABLE
IF OBJECT_ID('[dbo].[Fact_Payment]') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[Fact_Payment]
END

CREATE EXTERNAL TABLE [dbo].[Fact_Payment] 
WITH(
    LOCATION = 'bikedb/Fact_Payment',
    DATA_SOURCE = [dlthi3synfile_dlthi3synsa_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS (
    SELECT
        Payment_Id,
	    Payment_Date,
	    Amount,
        Rider_Id
FROM 
	[dbo].[staging_payment]
);

SELECT TOP 100 * FROM dbo.Fact_Payment;