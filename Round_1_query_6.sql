WITH CTE_1
AS (SELECT
COUNT(listing_id) as wifi_listings
FROM Listings
WHERE amenities like '%wifi%'),
CTE_2
AS (SELECT
COUNT(listing_id) as not_wifi_listings
FROM Listings)
SELECT
ROUND(100 * CAST(CTE_1.wifi_listings AS FLOAT) / CAST(CTE_2.not_wifi_listings AS FLOAT),2) AS percent_of_wifi_locations,
CTE_1.wifi_listings,
CTE_2.not_wifi_listings
FROM CTE_1, CTE_2
