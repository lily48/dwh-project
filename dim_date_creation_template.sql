IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dates')
    CREATE TABLE [dates] (
        [datetime] datetime,
        [day_of_week] varchar(10),
        [hour_of_day] int,
        [year] int,
        [month] int,
        [day] int,
        [quarter] int
    )
    -- The queries below get the range of dates between:
    -- 1. The oldest date possible, which should be the sign-up
    --    date of the very first rider i.e. the oldest stage_riders.start_date.
    -- 2. The latest date + 30 years. The latest date should be the the latest
    --    date in the database, that is, the latest end trip date i.e. the newest
    --    stage_trips.end_date.

    -- Get the latest date by creating a table that selects the latest trip and payment dates.
    -- START
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'temp_latest_dates')
        DROP TABLE [temp_latest_dates]
    GO

    CREATE TABLE [temp_latest_dates] (
        [date] datetime
    );

    WITH latest_trip AS (
        SELECT TOP 1 CONVERT(Datetime, SUBSTRING([ended_at], 1, 19),120) AS date FROM [dbo].[stage_trips] ORDER BY date DESC
    ), latest_payment AS (
        SELECT TOP 1 CONVERT(Datetime, SUBSTRING([date], 1, 19),120) AS date FROM [dbo].[stage_payments] ORDER BY date DESC
    )
    INSERT INTO [temp_latest_dates](date)
    SELECT date from latest_trip UNION ALL SELECT date FROM latest_payment;

    DECLARE @start_date DATETIME = (SELECT TOP 1 CONVERT(Datetime, SUBSTRING([start_date], 1, 19),120)
        FROM [dbo].[stage_riders] ORDER BY [start_date]);
    DECLARE @num_years INT = 30;
    DECLARE @cutoff_date DATETIME = (SELECT TOP 1 DATEADD(YEAR, @num_years, [date]) FROM
            [temp_latest_dates] ORDER BY [date] DESC);
    -- END

    INSERT [dates]([datetime])
    SELECT d
    FROM
    (
      SELECT d = DATEADD(HOUR, rn - 1, @start_date)
      FROM
      (
        SELECT TOP (DATEDIFF(HOUR, @start_date, @cutoff_date))
          rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
        FROM sys.all_objects AS s1
        CROSS JOIN sys.all_objects AS s2
        ORDER BY s1.[object_id]
      ) AS x
    ) AS y;


    UPDATE [dates]
    set
      [day_of_week]  = DATEPART(WEEKDAY,  [datetime]),
      [hour_of_day]  = DATEPART(HOUR,     [datetime]),
      [year]         = DATEPART(YEAR,     [datetime]),
      [month]        = DATEPART(MONTH,    [datetime]),
      [day]          = DATEPART(DAY,      [datetime]),
      [quarter]      = DATEPART(QUARTER,  [datetime])
    ;
GO