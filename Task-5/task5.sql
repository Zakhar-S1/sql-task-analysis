SELECT 
    d.Name AS DepartmentName,
    COUNT(DISTINCT edh.EmployeeID) AS EmployeeCount
FROM employeedepartmenthistory edh
INNER JOIN department d ON edh.DepartmentID = d.DepartmentID
WHERE edh.StartDate <= '1999-05-01'
    AND (edh.EndDate >= '1999-05-01' OR edh.EndDate IS NULL)
GROUP BY d.DepartmentID, d.Name
ORDER BY EmployeeCount DESC;