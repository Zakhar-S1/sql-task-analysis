I need to calculate population density (population per square mile) for each country, then extract statistical measures (minimum, maximum, median) using CTE approach. The final challenge is formatting the output into exactly two columns ("Metric" and "Value") with three specific rows using UNION operations.

## The Logic Flow
Calculate population density with proper error handling for division by zero
Rank all density values for median calculation (since MySQL doesn't have PERCENTILE_CONT)
Extract MIN, MAX, and manually calculated MEDIAN into a stats CTE
Format results using UNION ALL to create the required two-column, three-row output

Start with safe division: CASE WHEN SurfaceArea > 0 THEN Population / SurfaceArea ELSE NULL END
Filter out invalid data: WHERE Population > 0 AND SurfaceArea > 0
Use ROW_NUMBER() to rank densities for median calculation
Calculate median by finding middle position(s): for odd count take middle value, for even count average the two middle values
Combine all statistics in one CTE, then format with literal strings using UNION ALL

By breaking the problem into logical stages, I can ensure data quality at each step, handle MySQL's median calculation limitations elegantly, and produce exactly the required output format.

## Answer

Metric Value
Minimum 0.03
Maximum 26277.78
Median 71.28