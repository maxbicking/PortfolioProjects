/* 
Data source: National UFO Reporting Center

The following query was written in T-SQL using Azure Visual Studio. 

Data was imported via CSV. 

To avoid unnecessary load times and various errors in Azure Data Studio, many numeric columns
were imported at nvarchar's. It was significantly easier to clean our data manually this way.

Visualization in Tableau: https://public.tableau.com/app/profile/max.bicking
*/

SELECT
    *
FROM ufos.dbo.ufo_sightings

SELECT 
    comments,
    COUNT(*)
FROM ufos.dbo.ufo_sightings
GROUP BY comments --Checking for obvious duplicates
ORDER BY 2 DESC


SELECT DISTINCT duration_seconds
FROM ufos.dbo.ufo_sightings
WHERE duration_seconds LIKE '%`%' --One of the conversion errors involved typos of this type on the duration_seconds column

UPDATE ufos.dbo.ufo_sightings
SET duration_seconds = TRIM('`' FROM duration_seconds) --Trimming the unecessary character off, and updating so we can cast later

SELECT
    CAST(duration_seconds AS FLOAT)
FROM ufos.dbo.ufo_sightings --Testing before diving in

SELECT
    CAST(latitude AS DECIMAL(12,9))
FROM ufos.dbo.ufo_sightings --Trying, will result in error


--33q.029380

SELECT
    TRY_CAST(TRIM('q' FROM latitude) AS DECIMAL(12,9)) --testing, '33q.%' was an error value during import
FROM ufos.dbo.ufo_sightings



--get day of week and hour of day

SELECT
    DATENAME(weekday, [datetime]) AS [weekday],
    COUNT(*)
FROM ufos.dbo.ufo_sightings
GROUP BY DATENAME(weekday, [datetime]) --Exploring distribution of sightings by day of week


SELECT
    DATEPART(hour, [datetime]) AS [hour],
    COUNT(*) AS hour_count
FROM ufos.dbo.ufo_sightings
GROUP BY DATEPART(hour, [datetime]) --Exploring distribution of sightings by time of day
ORDER BY 2 DESC --Unsurprisingly, most sightings occur in the evening


SELECT
    DATEPART(month, [datetime]) AS [month],
    COUNT(*) AS hour_count
FROM ufos.dbo.ufo_sightings
GROUP BY DATEPART(month, [datetime]) --Exploring distribution of sightings by month
ORDER BY 2 DESC --Majority of sightings occur between June and December/January




/*
Final output query below
*/

SELECT 
    [datetime],
    [city],
    [state],
    [country],
    [shape],
    CAST([duration_seconds] AS FLOAT) AS [duration_seconds],
    [comments],
    [date_posted],
    TRY_CAST(TRIM('q' FROM latitude) AS DECIMAL(12,9)) AS [latitude],
    CAST([longitude] AS DECIMAL(12,9)) AS [longitude]
FROM ufos.dbo.ufo_sightings

--This table was saved as a CSV and imported to Tableau