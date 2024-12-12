WITH city_passenger_totals AS (                                            -- cte for better readability            
    SELECT 
        dc.city_name,                                                      -- gives city name
        SUM(fp.new_passengers) AS total_new_passengers                     -- sum total new passengers for each city
    FROM 
        fact_passenger_summary fp                                    
    JOIN 
        dim_city dc ON fp.city_id = dc.city_id             
    GROUP BY 
        dc.city_name                                       
),                                                                         -- this table shows city and total new passengers

ranked_cities AS (
    SELECT 
        city_name,
        total_new_passengers,
        RANK() OVER (ORDER BY total_new_passengers DESC) AS rank_highest,  -- cities ranked in descending order : highest passengers
        RANK() OVER (ORDER BY total_new_passengers ASC) AS rank_lowest     -- cities ranked in ascending order : lowest passengers
    FROM 
        city_passenger_totals
),                                                                         -- this table add ranks to the new passengers 

categorized_cities AS (
    SELECT 
        city_name,
        total_new_passengers,
        CASE 
            WHEN rank_highest <= 3 THEN 'Top 3'                           -- gives top 3 cities based on the highest number of passengers
            WHEN rank_lowest <= 3 THEN 'Bottom 3'                         -- give bottom 3 cities based on the lowest number of passengers
            ELSE NULL                                                     -- other citites become null
        END AS city_category                                              
    FROM 
        ranked_cities
)


SELECT 
    city_name,
    total_new_passengers,
    city_category                                         
FROM 
    categorized_cities
WHERE 
    city_category IS NOT NULL                                             -- gives only the Top 3 and Bottom 3 cities
ORDER BY 
	total_new_passengers DESC;                            
