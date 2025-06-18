-- Simple way
-- Average life expectancy by simply averaging all countries per language

SELECT 
    cl.Language,
    COUNT(*) AS Countries_Count,
    ROUND(AVG(c.LifeExpectancy), 2) AS Simple_Average_Life_Expectancy
FROM world.countrylanguage cl
JOIN world.country c ON cl.CountryCode = c.Code
WHERE c.LifeExpectancy IS NOT NULL
GROUP BY cl.Language
HAVING COUNT(*) >= 2  -- Only show languages spoken in multiple countries
ORDER BY Simple_Average_Life_Expectancy DESC
LIMIT 20;

-- More corrective way -- weighted by speakers
-- Weight by actual number of speakers in each country

WITH language_speakers AS (
    SELECT 
        cl.Language,
        cl.CountryCode,
        c.Name AS Country,
        c.LifeExpectancy,
        c.Population,
        cl.Percentage,
        -- Calculate number of speakers in each country
        ROUND(c.Population * cl.Percentage / 100) AS Speakers_Count
    FROM world.countrylanguage cl
    JOIN world.country c ON cl.CountryCode = c.Code
    WHERE c.LifeExpectancy IS NOT NULL 
        AND c.Population > 0 
        AND cl.Percentage > 0
)
SELECT 
    Language,
    COUNT(*) AS Countries_Count,
    SUM(Speakers_Count) AS Total_Speakers,
    ROUND(
        SUM(LifeExpectancy * Speakers_Count) / SUM(Speakers_Count), 
        2
    ) AS Weighted_Average_Life_Expectancy,
    ROUND(AVG(LifeExpectancy), 2) AS Simple_Average_Life_Expectancy,
    ROUND(
        (SUM(LifeExpectancy * Speakers_Count) / SUM(Speakers_Count)) - AVG(LifeExpectancy),
        2
    ) AS Difference_Weighted_vs_Simple
FROM language_speakers
GROUP BY Language
HAVING COUNT(*) >= 2 AND SUM(Speakers_Count) >= 1000000
ORDER BY Weighted_Average_Life_Expectancy DESC
LIMIT 20;

-- Official vs non-official
-- Consider whether language is official or not

WITH detailed_language_analysis AS (
    SELECT 
        cl.Language,
        cl.CountryCode,
        c.Name AS Country,
        c.LifeExpectancy,
        c.Population,
        cl.Percentage,
        cl.IsOfficial,
        ROUND(c.Population * cl.Percentage / 100) AS Speakers_Count,
        CASE 
            WHEN cl.IsOfficial = 'T' THEN c.Population * cl.Percentage / 100 * 1.5
            ELSE c.Population * cl.Percentage / 100
        END AS Weighted_Speakers
    FROM world.countrylanguage cl
    JOIN world.country c ON cl.CountryCode = c.Code
    WHERE c.LifeExpectancy IS NOT NULL 
        AND c.Population > 0 
        AND cl.Percentage > 0
)
SELECT 
    Language,
    COUNT(*) AS Countries_Count,
    COUNT(CASE WHEN IsOfficial = 'T' THEN 1 END) AS Official_Countries,
    SUM(Speakers_Count) AS Total_Speakers,
    ROUND(
        SUM(LifeExpectancy * Speakers_Count) / SUM(Speakers_Count), 
        2
    ) AS Population_Weighted_Average,
    ROUND(
        SUM(LifeExpectancy * Weighted_Speakers) / SUM(Weighted_Speakers), 
        2
    ) AS Official_Status_Weighted_Average
FROM detailed_language_analysis
GROUP BY Language
HAVING COUNT(*) >= 2 AND SUM(Speakers_Count) >= 1000000
ORDER BY Population_Weighted_Average DESC
LIMIT 15;

-- Simple vs Weighted
-- Show the biggest differences between methods

WITH simple_averages AS (
    SELECT 
        cl.Language,
        ROUND(AVG(c.LifeExpectancy), 2) AS Simple_Average
    FROM world.countrylanguage cl
    JOIN world.country c ON cl.CountryCode = c.Code
    WHERE c.LifeExpectancy IS NOT NULL
    GROUP BY cl.Language
    HAVING COUNT(*) >= 2
),
weighted_averages AS (
    SELECT 
        cl.Language,
        ROUND(
            SUM(c.LifeExpectancy * c.Population * cl.Percentage / 100) / 
            SUM(c.Population * cl.Percentage / 100), 
            2
        ) AS Weighted_Average,
        SUM(c.Population * cl.Percentage / 100) AS Total_Speakers
    FROM world.countrylanguage cl
    JOIN world.country c ON cl.CountryCode = c.Code
    WHERE c.LifeExpectancy IS NOT NULL 
        AND c.Population > 0 
        AND cl.Percentage > 0
    GROUP BY cl.Language
    HAVING SUM(c.Population * cl.Percentage / 100) >= 1000000
)
SELECT 
    s.Language,
    s.Simple_Average,
    w.Weighted_Average,
    ROUND(w.Weighted_Average - s.Simple_Average, 2) AS Difference,
    ROUND(w.Total_Speakers / 1000000, 1) AS Total_Speakers_Millions
FROM simple_averages s
JOIN weighted_averages w ON s.Language = w.Language
ORDER BY ABS(w.Weighted_Average - s.Simple_Average) DESC
LIMIT 15;

-- Language families analysis

WITH language_analysis AS (
    SELECT 
        CASE 
            WHEN cl.Language IN ('English') THEN 'English'
            WHEN cl.Language IN ('Spanish', 'Portuguese', 'French', 'Italian', 'Romanian') THEN 'Romance Languages'
            WHEN cl.Language IN ('German', 'Dutch', 'Swedish', 'Norwegian', 'Danish') THEN 'Germanic Languages'
            WHEN cl.Language IN ('Russian', 'Polish', 'Czech', 'Slovak', 'Bulgarian') THEN 'Slavic Languages'
            WHEN cl.Language IN ('Chinese', 'Mandarin', 'Cantonese') THEN 'Chinese Languages'
            WHEN cl.Language IN ('Arabic') THEN 'Arabic'
            WHEN cl.Language IN ('Hindi', 'Bengali', 'Urdu', 'Punjabi') THEN 'Indo-Aryan Languages'
            ELSE 'Other Languages'
        END AS Language_Family,
        c.LifeExpectancy,
        c.Population * cl.Percentage / 100 AS Speakers_Count
    FROM world.countrylanguage cl
    JOIN world.country c ON cl.CountryCode = c.Code
    WHERE c.LifeExpectancy IS NOT NULL 
        AND c.Population > 0 
        AND cl.Percentage > 0
)
SELECT 
    Language_Family,
    COUNT(*) AS Data_Points,
    ROUND(SUM(Speakers_Count) / 1000000, 1) AS Total_Speakers_Millions,
    ROUND(
        SUM(LifeExpectancy * Speakers_Count) / SUM(Speakers_Count), 
        2
    ) AS Weighted_Average_Life_Expectancy
FROM language_analysis
WHERE Language_Family != 'Other Languages'
GROUP BY Language_Family
ORDER BY Weighted_Average_Life_Expectancy DESC;





