I need to calculate what percentage of each country's population lives in its capital city, then identify the 10 countries where this percentage is the smallest. This requires joining two tables (country and city) and performing percentage calculations while handling potential data quality issues.

This is fundamentally a JOIN problem with statistical analysis. My strategy is to connect countries with their capitals through the foreign key relationship, calculate the population ratio, and then find the countries where capitals represent the smallest proportion of total population.

Instead of using LEFT JOIN and dealing with NULL values extensively, I chose INNER JOIN because we specifically need countries that have identifiable capitals with population data. It naturally filters out problematic records (missing capitals, NULL populations) and cleaner logic flow without excessive NULL handling with more reliable percentage calculations.

## The Logic Flow

1. Join country table with city table using the Capital-ID relationship;
2. Filter out invalid data (zero populations, missing data);
3. Calculate percentage: (capital_population / country_population) * 100;
4. Add sanity check: capital population shouldn't exceed country population;
5. Sort by percentage ascending to get smallest percentages first;
6. Limit to top 10 results;

Start with the relationship: country.Capital = city.ID links countries to their capital cities. Then apply data quality filters: WHERE c.Population > 0 AND city.Population > 0. The next step is adding logical constraint -- city.Population <= c.Population prevents data anomalies. Then calculationg percentage with proper rounding: ROUND((city.Population / c.Population) * 100, 2). As a final main step, sorting ascending because we want the SMALLEST percentages + using LIMIT 10 to get exactly the requested number of results.