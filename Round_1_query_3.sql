SELECT DISTINCT
	AVG(price) OVER (PARTITION BY host_id) as avg_price,
	MIN(price) OVER (PARTITION BY host_id) as min_price,
	MAX(price) OVER (PARTITION BY host_id) as max_price,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) OVER (PARTITION BY host_id) as median
FROM Listings
WHERE host_id IN (
					SELECT TOP 1 host_id
					FROM Listings
					GROUP BY host_id
					ORDER BY COUNT(*) DESC)

