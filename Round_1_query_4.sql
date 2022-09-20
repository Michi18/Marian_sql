SELECT
COUNT(host_id)
FROM Listings
WHERE host_id in(
                SELECT
                host_id
                FROM Listings
                GROUP BY host_id
                HAVING COUNT(neighbourhood) > 1)
