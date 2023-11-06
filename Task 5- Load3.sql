IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 STRING_DELIMITER = '"',
			 USE_TYPE_DEFAULT = TRUE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'dlthi3synfile_dlthi3synsa_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [dlthi3synfile_dlthi3synsa_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://dlthi3synfile@dlthi3synsa.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE dbo.staging_station (
	[Station_Id] nvarchar(4000),
	[Station_Name] nvarchar(4000),
	[Latitude] float,
	[Longitude] float
	)
	WITH (
	LOCATION = 'publicstation.csv',
	DATA_SOURCE = [dlthi3synfile_dlthi3synsa_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_station
GO