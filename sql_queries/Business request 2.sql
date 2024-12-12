SELECT 
    dc.city_name,                                                                        -- to retrive city name
    dd.month_name,                                                                       -- to get month name
    COUNT(ft.trip_id) AS actual_trips,                                                   -- to count actual total tips
    tmt.total_target_trips AS target_trips,                                              -- to get targets for each city and months
    CASE
        WHEN COUNT(ft.trip_id) > tmt.total_target_trips THEN 'Above Target'              -- condition for above target
        ELSE 'Below Target'                                                              -- condition for below target
    END AS performance_status,                                                           
    CONCAT( 																			 -- using cancat function to show "%" at the end
    ROUND(
        ((COUNT(ft.trip_id) - tmt.total_target_trips) * 100.0 / tmt.total_target_trips), 
        2),
        "%"
    ) AS pct_difference                                                                 -- percentage difference between actual and target trips
FROM
    fact_trips ft                                                                        -- this is fact table containing trip data
JOIN
    dim_city dc ON ft.city_id = dc.city_id                                               -- joining to get city names
JOIN
    dim_date dd ON ft.date = dd.date                                                     -- joining to get month names
JOIN
    targets_db.monthly_target_trips tmt 												 -- i used (targets_db.monthly_target_trips) to define a different database
    ON dc.city_id = tmt.city_id                                                          -- joining to get target trips data for each city
    AND dd.start_of_month = tmt.month                                                    -- also joining month to get month name
GROUP BY 
    dc.city_name,                                                                        -- group by city name
    dd.month_name,                                                                       -- group by month name
    tmt.total_target_trips,                                                              -- group by target trips for the city and month
    dd.start_of_month                                                                    -- group by start of the month for sorting
ORDER BY 
    dc.city_name,                                                                        -- order by city name first
    MONTH(dd.start_of_month);                                                            -- then order by the calender value of the month (jan = 1, feb = 2,....)
