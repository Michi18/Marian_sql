WITH
YEAR AS(
    SELECT
        host_id,
        CAST(COUNT(listing_id) AS FLOAT) AS listings_count,
        AVG(ABS(DATEDIFF(year, GETDATE(), host_since))) AS years_of_hosting
    FROM Listings
    GROUP BY host_id)
SELECT
ROUND(AVG(CASE WHEN years_of_hosting > 7 THEN listings_count END), 2) AS avg_over_7,
ROUND(AVG(CASE WHEN years_of_hosting <= 7 THEN listings_count END), 2) AS avg_under_7,
SUM(CASE WHEN years_of_hosting > 7 THEN listings_count END) AS sum_over_7,
SUM(CASE WHEN years_of_hosting <= 7 THEN listings_count END) AS sum_under_7,
ROUND(100*CAST(COUNT(years_of_hosting) AS FLOAT)/CAST(COUNT(*) AS FLOAT), 2) AS percent_with_start_date
FROM YEAR

-- hosts, who are shorter than 7 years on airbnb, have greater avg and sum of listings
