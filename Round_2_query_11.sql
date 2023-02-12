WITH
CTE_Row_Number AS(
        SELECT
            *,
            ROW_NUMBER() OVER(PARTITION BY host_id ORDER BY price DESC) AS rn
        FROM Listings),
CTE_Second_Price AS(
        SELECT
            host_id,
            listing_id,
            name,
            price,
            rn
        FROM CTE_Row_Number
        WHERE rn = 2)
SELECT 
    ROUND(AVG(price), 2) AS Avg_Second_Listing_Price
FROM CTE_Second_Price;
