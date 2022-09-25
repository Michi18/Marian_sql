SELECT
COUNT(DISTINCT host_id)
FROM Listings
WHERE host_id in(
                SELECT
                host_id
                FROM Listings
                GROUP BY host_id
                HAVING COUNT(longitude) > 1 or COUNT(latitude) > 1);

--

SELECT
COUNT(host_id)
FROM (
        SELECT host_id
        FROM Listings
        GROUP BY host_id
        HAVING COUNT(longitude) > 1 or COUNT(latitude) > 1) as l;

--

WITH CTE_1
AS(SELECT host_id
        FROM Listings
        GROUP BY host_id
        HAVING COUNT(longitude) > 1 or COUNT(latitude) > 1)
SELECT COUNT(host_id)
FROM CTE_1

