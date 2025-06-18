-- Basic request with age calculation and current rates
WITH current_rates AS (
    SELECT 
        eph.EmployeeID,
        eph.Rate,
        eph.PayFrequency,
        ROW_NUMBER() OVER (PARTITION BY eph.EmployeeID ORDER BY eph.RateChangeDate DESC) as rn
    FROM employeepayhistory eph
)
SELECT 
    e.EmployeeID,
    e.Gender,
    e.MaritalStatus,
    e.Title,
    YEAR(CURDATE()) - YEAR(e.BirthDate) - 
    (DATE_FORMAT(CURDATE(), '%m%d') < DATE_FORMAT(e.BirthDate, '%m%d')) AS Age,
    cr.Rate AS CurrentHourlyRate,
    cr.PayFrequency,
    cr.Rate * 
    CASE cr.PayFrequency 
        WHEN 1 THEN 2080
        WHEN 2 THEN 1040 
        ELSE cr.Rate 
    END AS EstimatedAnnualSalary
FROM employee e
INNER JOIN current_rates cr ON e.EmployeeID = cr.EmployeeID AND cr.rn = 1
WHERE e.CurrentFlag = 1
ORDER BY cr.Rate DESC;

-- Analysis of salaries by gender
WITH current_rates AS (
    SELECT 
        eph.EmployeeID,
        eph.Rate,
        ROW_NUMBER() OVER (PARTITION BY eph.EmployeeID ORDER BY eph.RateChangeDate DESC) as rn
    FROM employeepayhistory eph
)
SELECT 
    e.Gender,
    COUNT(*) AS EmployeeCount,
    AVG(cr.Rate) AS AvgHourlyRate,
    MIN(cr.Rate) AS MinHourlyRate,
    MAX(cr.Rate) AS MaxHourlyRate,
    STDDEV(cr.Rate) AS StdDevRate
FROM employee e
INNER JOIN current_rates cr ON e.EmployeeID = cr.EmployeeID AND cr.rn = 1
WHERE e.CurrentFlag = 1
GROUP BY e.Gender
ORDER BY AvgHourlyRate DESC;

-- Analysis of salaries by marital status
WITH current_rates AS (
    SELECT 
        eph.EmployeeID,
        eph.Rate,
        ROW_NUMBER() OVER (PARTITION BY eph.EmployeeID ORDER BY eph.RateChangeDate DESC) as rn
    FROM employeepayhistory eph
)
SELECT 
    e.MaritalStatus,
    COUNT(*) AS EmployeeCount,
    AVG(cr.Rate) AS AvgHourlyRate,
    MIN(cr.Rate) AS MinHourlyRate,
    MAX(cr.Rate) AS MaxHourlyRate
FROM employee e
INNER JOIN current_rates cr ON e.EmployeeID = cr.EmployeeID AND cr.rn = 1
WHERE e.CurrentFlag = 1
GROUP BY e.MaritalStatus
ORDER BY AvgHourlyRate DESC;

-- Analysis of salaries by age group
WITH current_rates AS (
    SELECT 
        eph.EmployeeID,
        eph.Rate,
        ROW_NUMBER() OVER (PARTITION BY eph.EmployeeID ORDER BY eph.RateChangeDate DESC) as rn
    FROM employeepayhistory eph
)
SELECT 
    CASE 
        WHEN (YEAR(CURDATE()) - YEAR(e.BirthDate)) < 30 THEN 'Under 30'
        WHEN (YEAR(CURDATE()) - YEAR(e.BirthDate)) BETWEEN 30 AND 39 THEN '30-39'
        WHEN (YEAR(CURDATE()) - YEAR(e.BirthDate)) BETWEEN 40 AND 49 THEN '40-49'
        WHEN (YEAR(CURDATE()) - YEAR(e.BirthDate)) BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS AgeGroup,
    COUNT(*) AS EmployeeCount,
    AVG(cr.Rate) AS AvgHourlyRate,
    MIN(cr.Rate) AS MinHourlyRate,
    MAX(cr.Rate) AS MaxHourlyRate
FROM employee e
INNER JOIN current_rates cr ON e.EmployeeID = cr.EmployeeID AND cr.rn = 1
WHERE e.CurrentFlag = 1
GROUP BY AgeGroup
ORDER BY AvgHourlyRate DESC;

-- Detailed analysis of demographic factors intersections
WITH current_rates AS (
    SELECT 
        eph.EmployeeID,
        eph.Rate,
        ROW_NUMBER() OVER (PARTITION BY eph.EmployeeID ORDER BY eph.RateChangeDate DESC) as rn
    FROM employeepayhistory eph
)
SELECT 
    e.Gender,
    e.MaritalStatus,
    CASE 
        WHEN (YEAR(CURDATE()) - YEAR(e.BirthDate)) < 40 THEN 'Under 40'
        ELSE '40+'
    END AS AgeCategory,
    COUNT(*) AS EmployeeCount,
    AVG(cr.Rate) AS AvgHourlyRate,
    MIN(cr.Rate) AS MinRate,
    MAX(cr.Rate) AS MaxRate
FROM employee e
INNER JOIN current_rates cr ON e.EmployeeID = cr.EmployeeID AND cr.rn = 1
WHERE e.CurrentFlag = 1
GROUP BY e.Gender, e.MaritalStatus, AgeCategory
HAVING COUNT(*) >= 2
ORDER BY AvgHourlyRate DESC;