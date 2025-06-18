WITH RECURSIVE subordination_chains AS (
    SELECT 
        EmployeeID,
        ManagerID,
        CAST(EmployeeID AS CHAR(1000)) AS chain,
        0 AS level
    FROM employee 
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    SELECT 
        e.EmployeeID,
        e.ManagerID,
        CAST(CONCAT(sc.chain, ' -> ', e.EmployeeID) AS CHAR(1000)) AS chain,
        sc.level + 1 AS level
    FROM employee e
    INNER JOIN subordination_chains sc ON e.ManagerID = sc.EmployeeID
)

SELECT 
    chain AS subordination_chain,
    level AS chain_depth
FROM subordination_chains
ORDER BY level DESC, chain;