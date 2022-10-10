WITH CTE
AS (
	SELECT DISTINCT
		city,
		PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY price)
		OVER (PARTITION BY city) AS p25
	FROM Listings
	WHERE property_type = 'Entire apartment')

SELECT
MAX(CTE.p25) AS max_p25, MIN(CTE.p25) AS min_p25, MAX(CTE.p25) - MIN(CTE.p25) AS difference_p25
FROM
CTE
