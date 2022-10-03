WITH
CTE_1 AS (
    SELECT DISTINCT
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price) OVER () as p75,
	PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY price) OVER () as p95
    FROM Listings
    WHERE room_type = 'Entire place'),
CTE_2 AS(
    SELECT SUBSTRING(amenities, 2, LEN(amenities) - 2) as modified_list
    FROM Listings, CTE_1
    WHERE price >= CTE_1.p75 and price <= CTE_1.p95)
SELECT TOP 5 value as amenity, COUNT(value) AS count_of_amenities
FROM CTE_2
CROSS APPLY string_split(CTE_2.modified_list, ',')
GROUP BY value
ORDER BY COUNT(value) DESC