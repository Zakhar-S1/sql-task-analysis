-- Basic aggregation of transaction amounts by supplier
SELECT 
    v.VendorID,
    v.Name AS VendorName,
    v.CreditRating,
    COUNT(poh.PurchaseOrderID) AS TotalOrders,
    COALESCE(SUM(poh.TotalDue), 0) AS TotalTransactionAmount,
    COALESCE(AVG(poh.TotalDue), 0) AS AvgOrderAmount
FROM vendor v
LEFT JOIN purchaseorderheader poh ON v.VendorID = poh.VendorID
WHERE v.ActiveFlag = 1
GROUP BY v.VendorID, v.Name, v.CreditRating
ORDER BY v.CreditRating DESC, TotalTransactionAmount DESC;

-- Grouping by credit rating for pattern analysis
SELECT 
    v.CreditRating,
    COUNT(DISTINCT v.VendorID) AS VendorCount,
    COUNT(poh.PurchaseOrderID) AS TotalOrders,
    COALESCE(SUM(poh.TotalDue), 0) AS TotalAmount,
    COALESCE(AVG(poh.TotalDue), 0) AS AvgOrderAmount,
    COALESCE(SUM(poh.TotalDue) / COUNT(DISTINCT v.VendorID), 0) AS AvgAmountPerVendor
FROM vendor v
LEFT JOIN purchaseorderheader poh ON v.VendorID = poh.VendorID
WHERE v.ActiveFlag = 1
GROUP BY v.CreditRating
ORDER BY v.CreditRating DESC;

-- Top suppliers in each credit rating group
WITH vendor_totals AS (
    SELECT 
        v.VendorID,
        v.Name,
        v.CreditRating,
        COALESCE(SUM(poh.TotalDue), 0) AS TotalAmount,
        ROW_NUMBER() OVER (PARTITION BY v.CreditRating ORDER BY SUM(poh.TotalDue) DESC) as rnk
    FROM vendor v
    LEFT JOIN purchaseorderheader poh ON v.VendorID = poh.VendorID
    WHERE v.ActiveFlag = 1
    GROUP BY v.VendorID, v.Name, v.CreditRating
)
SELECT 
    CreditRating,
    Name AS VendorName,
    TotalAmount
FROM vendor_totals
WHERE rnk <= 3
ORDER BY CreditRating DESC, TotalAmount DESC;

-- Medians and quartiles for deeper analysis
SELECT 
    v.CreditRating,
    MIN(vendor_amounts.TotalAmount) AS MinAmount,
    MAX(vendor_amounts.TotalAmount) AS MaxAmount,
    AVG(vendor_amounts.TotalAmount) AS AvgAmount,
    COUNT(*) AS VendorCount
FROM vendor v
INNER JOIN (
    SELECT 
        v2.VendorID,
        COALESCE(SUM(poh2.TotalDue), 0) AS TotalAmount
    FROM vendor v2
    LEFT JOIN purchaseorderheader poh2 ON v2.VendorID = poh2.VendorID
    WHERE v2.ActiveFlag = 1
    GROUP BY v2.VendorID
) vendor_amounts ON v.VendorID = vendor_amounts.VendorID
WHERE v.ActiveFlag = 1
GROUP BY v.CreditRating
ORDER BY v.CreditRating DESC;
