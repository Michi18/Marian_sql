SELECT TOP 1
	PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY price)
		OVER () as p25_rome
FROM Listings
WHERE 
	city = 'Rome' and 
	property_type = 'Entire apartment'
