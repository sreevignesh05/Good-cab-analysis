WITH total_repeat_passengers AS (                                                             -- cte for better readability
    SELECT
        f.city_id,
        f.month,
        SUM(f.repeat_passengers) AS total_repeat_passengers
    FROM fact_passenger_summary f
    GROUP BY f.city_id, f.month                                                               -- this gives total of repeat passengers
),
repeat_trip_counts AS (
    SELECT                                                                                    -- calculates Trip wise. eg;( 2 trips = 1000 , 3 trips = 2000) 
        d.city_id,
        d.month,
        SUM(CASE WHEN d.trip_count = '2-Trips' THEN d.repeat_passenger_count ELSE 0 END) AS `2-Trips`,
        SUM(CASE WHEN d.trip_count = '3-Trips' THEN d.repeat_passenger_count ELSE 0 END) AS `3-Trips`,
        SUM(CASE WHEN d.trip_count = '4-Trips' THEN d.repeat_passenger_count ELSE 0 END) AS `4-Trips`,
        SUM(CASE WHEN d.trip_count = '5-Trips' THEN d.repeat_passenger_count ELSE 0 END) AS `5-Trips`,
        SUM(CASE WHEN d.trip_count = '6-Trips' THEN d.repeat_passenger_count ELSE 0 END) AS `6-Trips`,
        SUM(CASE WHEN d.trip_count = '7-Trips' THEN d.repeat_passenger_count ELSE 0 END) AS `7-Trips`,
        SUM(CASE WHEN d.trip_count = '8-Trips' THEN d.repeat_passenger_count ELSE 0 END) AS `8-Trips`,
        SUM(CASE WHEN d.trip_count = '9-Trips' THEN d.repeat_passenger_count ELSE 0 END) AS `9-Trips`,
        SUM(CASE WHEN d.trip_count = '10-Trips' THEN d.repeat_passenger_count ELSE 0 END) AS `10-Trips`
    FROM dim_repeat_trip_distribution d
    GROUP BY d.city_id, d.month
)
SELECT
    c.city_name,                                                                               -- by dividing each trips by total we get the % contribution
    ROUND((SUM(r.`2-Trips`) / SUM(t.total_repeat_passengers)) * 100, 2) AS `2-Trips (%)`,
    ROUND((SUM(r.`3-Trips`) / SUM(t.total_repeat_passengers)) * 100, 2) AS `3-Trips (%)`,
    ROUND((SUM(r.`4-Trips`) / SUM(t.total_repeat_passengers)) * 100, 2) AS `4-Trips (%)`,
    ROUND((SUM(r.`5-Trips`) / SUM(t.total_repeat_passengers)) * 100, 2) AS `5-Trips (%)`,
    ROUND((SUM(r.`6-Trips`) / SUM(t.total_repeat_passengers)) * 100, 2) AS `6-Trips (%)`,
    ROUND((SUM(r.`7-Trips`) / SUM(t.total_repeat_passengers)) * 100, 2) AS `7-Trips (%)`,
    ROUND((SUM(r.`8-Trips`) / SUM(t.total_repeat_passengers)) * 100, 2) AS `8-Trips (%)`,
    ROUND((SUM(r.`9-Trips`) / SUM(t.total_repeat_passengers)) * 100, 2) AS `9-Trips (%)`,
    ROUND((SUM(r.`10-Trips`) / SUM(t.total_repeat_passengers)) * 100, 2) AS `10-Trips (%)`
FROM total_repeat_passengers t
JOIN repeat_trip_counts r ON t.city_id = r.city_id AND t.month = r.month                      -- joining 1st and 2nd cte
JOIN dim_city c ON r.city_id = c.city_id													  -- joining city table to get city names
GROUP BY c.city_name
ORDER BY c.city_name;
