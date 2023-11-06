-- CREATE Dim_Station TABLE
IF OBJECT_ID('[dbo].[Dim_Station]') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[Dim_Station]
END

CREATE EXTERNAL TABLE [dbo].[Dim_Station] 
WITH(
    LOCATION = 'bikedb/Dim_Station',
    DATA_SOURCE = [dlthi3synfile_dlthi3synsa_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS (
    SELECT
        REPLACE(Station_Id,'"','') AS Station_Id,
	    REPLACE(Station_Name,'"','') AS Station_Name,
	    Latitude,
	    Longitude
FROM 
	[dbo].[staging_station]
);

SELECT TOP 100 * FROM dbo.Dim_Station;