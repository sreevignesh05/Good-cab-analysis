WITH monthly_city_revenue AS (											 -- cte for better readability
    SELECT 
        dc.city_name,                                                    
        dd.month_name,                                                   
        SUM(ft.fare_amount) AS monthly_revenue                           
    FROM 
        fact_trips ft                                                   
    JOIN 
        dim_city dc ON ft.city_id = dc.city_id         
    JOIN 
        dim_date dd ON ft.date = dd.date               
    GROUP BY 
        dc.city_name, dd.month_name                   
),                                                                      -- this table gives city , months and revenue


city_total_revenue AS (												     
    SELECT 
        city_name,
        SUM(monthly_revenue) AS total_city_revenue    
    FROM 
        monthly_city_revenue
    GROUP BY 
        city_name
),                                                                       -- this table give city and its monthly revenue


city_highest_revenue_month AS (                                          
    SELECT 
        mcr.city_name,
        mcr.month_name AS highest_revenue_month,      
        mcr.monthly_revenue AS revenue,               
        ROUND((mcr.monthly_revenue * 100.0 / ctr.total_city_revenue), 2) AS percentage_contribution  -- give % contribution
                                                     
    FROM 
        monthly_city_revenue mcr
    JOIN 
        city_total_revenue ctr ON mcr.city_name = ctr.city_name            -- joining to calculate percentage contribution
    WHERE 
        mcr.monthly_revenue = (                                           
            SELECT MAX(monthly_revenue)
            FROM monthly_city_revenue sub_mcr
            WHERE sub_mcr.city_name = mcr.city_name                        -- filters to get the highest revenue month for each city
        )
)

SELECT 
    city_name,                                                           
    highest_revenue_month,                                               
    revenue,                                                             
    percentage_contribution     
FROM 
    city_highest_revenue_month
ORDER BY 
    revenue DESC;                                                           
