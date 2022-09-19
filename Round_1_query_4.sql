SELECT
host_id,
COUNT(neighbourhood) as count_neighbourhood
FROM Listings
GROUP BY host_id
HAVING COUNT(neighbourhood) > 1
