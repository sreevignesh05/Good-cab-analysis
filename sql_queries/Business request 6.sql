WITH aggregated_table AS (
    SELECT 
        dc.city_name, 
        dd.month_name,
        fps.city_id, 
        SUM(fps.total_passengers) AS total_passengers, 
        SUM(fps.repeat_passengers) AS repeat_passengers
    FROM 
        fact_passenger_summary fps
    JOIN 
        dim_city dc ON fps.city_id = dc.city_id
    JOIN 
        dim_date dd ON fps.month = dd.start_of_month
    GROUP BY 
        dc.city_name, dd.month_name, fps.city_id
)                                                                                        -- this ia a aggregated table give over all data for further calculations
SELECT 
    ad.city_name,
    ad.month_name,
    ad.total_passengers,
    ad.repeat_passengers,
    ROUND(
        COALESCE(ad.repeat_passengers * 100.0 / ad.total_passengers, 0), 2               -- to get monthly repeat passengers rate
    ) AS monthly_repeat_passenger_rate,                                
    ROUND(
        COALESCE(
            SUM(ad.repeat_passengers) OVER (PARTITION BY ad.city_name) * 100.0 / 
            SUM(ad.total_passengers) OVER (PARTITION BY ad.city_name),                   -- to get city wise repeat passenger rate
            0
        ), 2
    ) AS city_repeat_passenger_rate
FROM 
    aggregated_table ad
ORDER BY 
    ad.city_name, ad.month_name;
