WITH RECURSIVE alphabet AS (
    SELECT 65 AS ascii_code, CHAR(65) AS letter  -- Start with 'A'
    UNION ALL
    SELECT ascii_code + 1, CHAR(ascii_code + 1)
    FROM alphabet
    WHERE ascii_code < 90  -- End with 'Z'
),
country_letters AS (
    SELECT 
        SUBSTRING(Code, 1, 1) AS pos1,
        SUBSTRING(Code, 2, 1) AS pos2, 
        SUBSTRING(Code, 3, 1) AS pos3
    FROM world.country
)
SELECT 
    a.letter,
    CASE WHEN p1.pos1 IS NULL THEN 'MISSING' ELSE 'present' END AS position_1,
    CASE WHEN p2.pos2 IS NULL THEN 'MISSING' ELSE 'present' END AS position_2,
    CASE WHEN p3.pos3 IS NULL THEN 'MISSING' ELSE 'present' END AS position_3
FROM alphabet a
LEFT JOIN (SELECT DISTINCT pos1 FROM country_letters) p1 ON a.letter = p1.pos1
LEFT JOIN (SELECT DISTINCT pos2 FROM country_letters) p2 ON a.letter = p2.pos2  
LEFT JOIN (SELECT DISTINCT pos3 FROM country_letters) p3 ON a.letter = p3.pos3
WHERE p1.pos1 IS NULL OR p2.pos2 IS NULL OR p3.pos3 IS NULL
ORDER BY a.letter;