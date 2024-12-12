SELECT
    dc.city_name,                                                                                 -- Gives the city names
    COUNT(ft.trip_id) AS total_trips,                                                             -- while it counts total number of trips in the table 
    ROUND(AVG(ft.fare_amount / NULLIF(ft.distance_travelled_km, 0)), 2) AS avg_fare_per_km,       -- By doing AVG of fare_amount / distance_travelled_km we get avg fare per KM , NULLIF is used for safe division
    ROUND(AVG(ft.fare_amount), 2) AS avg_fare_per_trip,                                           -- to Find avg amount we do AVG of fare amount
    CONCAT(                                            											  -- Concat funtion for adding " % " at the end to better understanding
        ROUND(
            (COUNT(ft.trip_id) * 100.0 / SUM(COUNT(ft.trip_id)) OVER()), 						  -- counting each tripid and dividing by total tripid will give percentage contribution for each cities as we have grouping function at the end of the query
            2
        ), '%'
    ) AS contribution_to_total_trips_pct                                                          
FROM
    fact_trips ft														
JOIN 
    dim_city dc ON ft.city_id = dc.city_id														 -- Joined on city_id	
GROUP BY
    dc.city_name																				 -- I used GROUP function to get the result in city wise
ORDER BY
    total_trips DESC;                                                                            -- Order to see the result to see from highest to lowest based on total trips

