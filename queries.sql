


-- Taking Union of all tables and making a new table named cyclistic_data 

Select 
	*
INTO cyclistic_data
FROM
(
SELECT 
	*
FROM
	cyclistic..['2021-01-divvy-tripdata$']
UNION ALL
SELECT
	*
FROM
	cyclistic..['2021-02-divvy-tripdata$']	
UNION ALL
SELECT 
	*
FROM
	cyclistic..['2021-03-divvy-tripdata$']
UNION ALL
SELECT	
	*
FROM
	cyclistic..['2021-04-divvy-tripdata$']
UNION ALL
SELECT
	*
FROM
	cyclistic..['2021-05-divvy-tripdata$']
UNION ALL
SELECT 
	*
FROM
	cyclistic..['2021-06-divvy-tripdata$']
UNION ALL
SELECT	
	*
FROM
	cyclistic..['2021-07-divvy-tripdata$']
UNION ALL
SELECT
	*
FROM
	cyclistic..['2021-08-divvy-tripdata$']
UNION ALL
SELECT
	*
FROM
	cyclistic..['2021-09-divvy-tripdata$']
UNION ALL
SELECT
	*
FROM
	cyclistic..['2021-10-divvy-tripdata$']
UNION ALL
SELECT 
	*
FROM
	cyclistic..['2021-11-divvy-tripdata$']
UNION ALL
SELECT 
	*
FROM
	cyclistic..['2021-12-divvy-tripdata$']
) cyc




-- 1 checking total members after cleaning

SELECT 
 COUNT(*)
FROM
	cyclistic..cyclistic_data
WHERE
	start_station_id is not null
and
	end_station_id is not null



 -- 2 checking what percentage of total members make

 WITH member_counts AS (
    SELECT
        member_casual,
        COUNT(*) AS tot_member
    FROM
        cyclistic..cyclistic_data
	WHERE
		start_station_id is not null
	and
		end_station_id is not null
    GROUP BY
        member_casual
)
SELECT
    member_casual,
    (tot_member * 100.0) / (SELECT SUM(tot_member) FROM member_counts) AS percentage
FROM
    member_counts;


-- 3 total rides of members per month


SELECT 
	DATENAME(MONTH, started_at) AS month,
	count(ride_id) as ride_count,
	member_casual
FROM	
	cyclistic..cyclistic_data
WHERE
	start_station_id is not null
and
	end_station_id is not null
GROUP BY
	DATENAME(MONTH, started_at),
	member_casual
ORDER BY 
	CASE DATENAME(MONTH, started_at)
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
    END;


 -- 4 most rideable bike among member_casual and their percentage


 WITH ride_data AS (
    SELECT
        rideable_type,
		member_casual,
        COUNT(*) AS count_of_times_bike_used
    FROM
        cyclistic..cyclistic_data
	WHERE
		start_station_id is not null
	and
		end_station_id is not null
    GROUP BY
        rideable_type,
		member_casual
)
SELECT
    rideable_type,
	member_casual,
	count_of_times_bike_used,
    (count_of_times_bike_used * 100.0) / (SELECT SUM(count_of_times_bike_used) FROM ride_data) AS percentage
FROM
    ride_data

-- 5 popular bike


 WITH ride_data AS (
    SELECT
        rideable_type,
        COUNT(*) AS count_of_times_bike_used
    FROM
        cyclistic..cyclistic_data
	WHERE
		start_station_id is not null
	and
		end_station_id is not null
    GROUP BY
        rideable_type
	
)
SELECT top (1)
    rideable_type,
	count_of_times_bike_used,
    (count_of_times_bike_used * 100.0) / (SELECT SUM(count_of_times_bike_used) FROM ride_data) AS percentage
FROM
    ride_data
order by 2 desc



-- 6 busiest day of the week

SELECT top (1)
	CASE day_of_week
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
        ELSE 'Invalid Day Number'
    END AS busiest_day,
	Avg(ride_count) as Avg_total_rides_per_day
FROM
	(
		SELECT 
			COUNT(*) as ride_count,
			day_of_week
		FROM
			cyclistic..cyclistic_data
		WHERE
			start_station_id is not null
		and
			end_station_id is not null
		GROUP BY
			day_of_week
	) as subquery
GROUP BY 
	day_of_week
ORDER BY 
	1 DESC

	
 -- 7 avg ride_length per member 
	
SELECT top (1)
	CASE day_of_week
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
        ELSE 'Invalid Day Number'
    END AS day_of_week,
	   AVG(CAST(DATEDIFF(SECOND, '00:00:00', CONVERT(TIME, ride_length)) AS FLOAT)) / 60  AS avg_ride_length
FROM
	cyclistic..cyclistic_data
WHERE
	start_station_id is not null
and
	end_station_id is not null
and
	member_casual = 'member'
GROUP BY 
	day_of_week
order by 2 desc


SELECT top (1)
	CASE day_of_week
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
        ELSE 'Invalid Day Number'
    END AS day_of_week,
	   AVG(CAST(DATEDIFF(SECOND, '00:00:00', CONVERT(TIME, ride_length)) AS FLOAT)) / 60  AS avg_ride_length_seconds
FROM
	cyclistic..cyclistic_data
WHERE
	start_station_id is not null
and
	end_station_id is not null
and
	member_casual = 'casual'
GROUP BY 
	day_of_week
order by 2 desc



-- 8 avg ride_length per day

SELECT
	CASE day_of_week
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
        ELSE 'Invalid Day Number'
    END AS day_of_week,
	   AVG(CAST(DATEDIFF(SECOND, '00:00:00', CONVERT(TIME, ride_length)) AS FLOAT)) / 60  AS avg_ride_length_seconds,
	   member_casual
FROM
	cyclistic..cyclistic_data
WHERE
	start_station_id is not null
and
	end_station_id is not null

GROUP BY 
	day_of_week,
	member_casual
order by 2 desc

-- 9 Top 5 stations per member

SELECT top (5)
	start_station_name,
	COUNT(start_station_name) as no_of_rides,
	member_casual
FROM
	cyclistic..cyclistic_data
WHERE
	start_station_id is not null
and
	end_station_id is not null
and 
	member_casual = 'member'
GROUP BY 
	start_station_name,
	member_casual
ORDER BY
	2 DESC



SELECT top (5)
	start_station_name,
	COUNT(start_station_name) as no_of_rides,
	member_casual
FROM
	cyclistic..cyclistic_data
WHERE
	start_station_id is not null
and
	end_station_id is not null
and 
	member_casual = 'casual'
GROUP BY 
	start_station_name,
	member_casual
ORDER BY
	2 DESC





-- checking ride per hour by member(it have highest avg. of rides)

WITH HourFormatted AS (
    SELECT
        FORMAT(started_at, 'h tt') AS hours,
        COUNT(*) AS ride_count
		member_casual
    FROM
        cyclistic..cyclistic_data
	WHERE
		start_station_id is not null
	and
		end_station_id is not null
    GROUP BY
        FORMAT(started_at, 'h tt')
		member_casual
)
SELECT 
    hours,
    COUNT(*) AS ride_count,
    AVG(1.0 * ride_count) AS average_rides
	member_casual
FROM
    HourFormatted
GROUP BY
    hours
	member_casual
ORDER BY
    2 DESC