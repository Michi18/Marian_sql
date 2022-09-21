SELECT
COUNT(host_id)
FROM Listings
WHERE host_id in(
                SELECT
                host_id
                FROM Listings
                GROUP BY host_id
                HAVING COUNT(longitude) > 1 or COUNT(latitude) > 1)
GROUP BY host_id