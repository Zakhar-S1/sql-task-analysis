WITH capital_analysis AS (
    SELECT 
        c.Code,
        c.Name AS Country,
        c.Population AS Country_Population,
        c.Capital AS Capital_ID,
        city.Name AS Capital_Name,
        city.Population AS Capital_Population,
        CASE 
            WHEN c.Population IS NULL OR c.Population = 0 THEN 'No Country Population Data'
            WHEN city.Population IS NULL THEN 'No Capital Population Data'  
            WHEN city.Population = 0 THEN 'Capital Population Zero'
            ELSE CONCAT(ROUND((city.Population / c.Population) * 100, 2), '%')
        END AS Capital_Percentage_Display,
        CASE 
            WHEN c.Population > 0 AND city.Population > 0 THEN 
                (city.Population / c.Population) * 100
            ELSE NULL
        END AS Capital_Percentage_Numeric
    FROM world.country c
    LEFT JOIN world.city city ON c.Capital = city.ID
)
SELECT 
    Country,
    Capital_Name,
    FORMAT(Country_Population, 0) AS Country_Population_Formatted,
    FORMAT(Capital_Population, 0) AS Capital_Population_Formatted,
    Capital_Percentage_Display AS Percentage
FROM capital_analysis
WHERE Capital_Percentage_Numeric IS NOT NULL
ORDER BY Capital_Percentage_Numeric ASC
LIMIT 10;