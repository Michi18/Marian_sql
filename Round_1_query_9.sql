WITH CTE_R
AS (
	SELECT TOP 1
		PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY price)
		OVER () as p25_rome
	FROM Listings
	WHERE 
		city = 'Rome' and 
		room_type = 'Entire place'),
CTE_NY
AS (
	SELECT TOP 1
		PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY price)
		OVER () as p25_newyork
	FROM Listings
	WHERE 
		city = 'New York' and 
		room_type = 'Entire place')
SELECT
CTE_R.p25_rome, CTE_NY.p25_newyork, ABS(CTE_R.p25_rome - CTE_NY.p25_newyork) as difference
FROM
CTE_R, CTE_NY
