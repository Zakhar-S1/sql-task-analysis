WITH daily_changes AS (
    SELECT 
        CurrencyRateDate,
        EndOfDayRate,
        LAG(EndOfDayRate) OVER (ORDER BY CurrencyRateDate) AS PreviousDayRate,
        ABS(EndOfDayRate - LAG(EndOfDayRate) OVER (ORDER BY CurrencyRateDate)) AS RateChange
    FROM currencyrate 
    WHERE FromCurrencyCode = 'USD' 
        AND ToCurrencyCode = 'CAD'
),
ranked_changes AS (
    SELECT *,
        RANK() OVER (ORDER BY RateChange DESC) as rnk
    FROM daily_changes
    WHERE RateChange IS NOT NULL
)
SELECT 
    CurrencyRateDate,
    EndOfDayRate,
    PreviousDayRate,
    RateChange
FROM ranked_changes
WHERE rnk = 1;