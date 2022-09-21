SELECT
100/(COUNT(listing_id))*
(SELECT
COUNT(listing_id)
FROM Listings
WHERE amenities like '%wifi%') as percent_of_wifi
FROM Listings