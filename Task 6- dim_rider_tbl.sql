--CREATE Dim_Rider TABLE
IF OBJECT_ID('[dbo].[Dim_Rider]') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[Dim_Rider]
END

CREATE EXTERNAL TABLE [dbo].[Dim_Rider] 
WITH(
    LOCATION = 'bikedb/Dim_Rider',
    DATA_SOURCE = [dlthi3synfile_dlthi3synsa_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS (
    SELECT
        Rider_Id,
        REPLACE(First_Name,'"','') AS First_Name,
	    REPLACE(Last_Name,'"','') AS Last_Name,
        REPLACE(Address,'"','') AS Address,
	    CAST(Birthday AS DATE) AS Birthday,
	    CAST(Account_Start_Date AS DATE) AS Account_Start_Date,
        CAST(Account_End_Date AS DATE) AS Account_End_Date,
        Is_Member
FROM 
	[dbo].[staging_rider]
);

SELECT TOP 100 * FROM dbo.Dim_Rider;