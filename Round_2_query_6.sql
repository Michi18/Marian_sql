WITH
year AS(
    SELECT
        host_id,
        CAST(COUNT(listing_id) AS FLOAT) AS listings_count,
        AVG(ABS(CAST(DATEDIFF(year, GETDATE(), host_since) AS FLOAT))) AS years_of_hosting
    FROM Listings
    GROUP BY host_id),
seven AS(
    SELECT
        host_id,
        CASE
            WHEN years_of_hosting > 7 THEN 'Eight or more years'
            WHEN years_of_hosting <= 7 THEN 'Seven or less years'
            ELSE NULL
        END AS exp_group
    FROM year)
SELECT
s.exp_group,
ROUND(AVG(y.listings_count), 2) as avg_listings,
ROUND(COUNT(y.listings_count), 2) as count_listings 
FROM year y INNER JOIN seven s
ON y.host_id = s.host_id
GROUP BY s.exp_group

-- hosts, who are shorter than 7 years on airbnb, have greater avg and sum of listings
