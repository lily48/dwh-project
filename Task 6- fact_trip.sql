-- CREATE Fact_Trip TABLE
IF OBJECT_ID('[dbo].[Fact_Trip]') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[Fact_Trip]
END

CREATE EXTERNAL TABLE [dbo].[Fact_Trip] 
WITH(
    LOCATION = 'bikedb/Fact_Trip',
    DATA_SOURCE = [dlthi3synfile_dlthi3synsa_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS (
    SELECT
        REPLACE(t.Trip_Id,'"','') AS Trip_Id,
	    t.Rider_Id,
        DATEDIFF(year, r.birthday, TRY_CONVERT(datetime2, t.Start_At)) AS Rider_Age,
        REPLACE(t.Rideable_Type,'"','') AS Rideable_Type,
        TRY_CONVERT(datetime2, t.Start_At) AS Start_At,
        TRY_CONVERT(datetime2, t.End_At) AS End_At,
        REPLACE(t.Start_Station_Id,'"','') AS Start_Station_Id,
        REPLACE(t.End_Station_Id,'"','') AS End_Station_Id,
        DATEDIFF(SECOND, TRY_CONVERT(datetime2, t.Start_At), TRY_CONVERT(datetime2, t.End_At)) AS Duration_In_Second
FROM 
	[dbo].[staging_trip] t 
    JOIN [dbo].[staging_rider] r ON t.Rider_Id = r.Rider_Id 
);

SELECT TOP 100 * FROM dbo.Fact_Trip;