WITH population_density AS (
    SELECT 
        CASE 
            WHEN SurfaceArea > 0 THEN Population / SurfaceArea
            ELSE NULL 
        END AS density
    FROM world.country
    WHERE Population > 0 AND SurfaceArea > 0
),
ranked_density AS (
    SELECT 
        density,
        ROW_NUMBER() OVER (ORDER BY density) AS row_num,
        COUNT(*) OVER () AS total_count
    FROM population_density
    WHERE density IS NOT NULL
),
stats AS (
    SELECT 
        (SELECT MIN(density) FROM population_density WHERE density IS NOT NULL) AS min_val,
        (SELECT MAX(density) FROM population_density WHERE density IS NOT NULL) AS max_val,
        (SELECT AVG(density) 
         FROM ranked_density 
         WHERE row_num IN (
            FLOOR((SELECT COUNT(*) FROM ranked_density) / 2.0) + 1,
            CEIL((SELECT COUNT(*) FROM ranked_density) / 2.0) + 1
         )) AS median_val
)
SELECT 'Minimum' AS Metric, CAST(ROUND(min_val, 2) AS CHAR) AS Value FROM stats
UNION ALL
SELECT 'Maximum' AS Metric, CAST(ROUND(max_val, 2) AS CHAR) AS Value FROM stats  
UNION ALL
SELECT 'Median' AS Metric, CAST(ROUND(median_val, 2) AS CHAR) AS Value FROM stats;