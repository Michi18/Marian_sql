WITH
CTE_ALL AS (
    SELECT
    COUNT(listing_id) AS all_listings
    FROM Listings),
CTE_Listings_with_words AS (
    SELECT
    COUNT(listing_id) AS listings_with_words
    FROM Listings
    WHERE name like '%nice%'
    or name like '%charming%'
    or name like '%lovely%'
    or name like '%elegant%'
    or name like '%stylish%'
    or name like '%great%')
SELECT
CTE_Listings_with_words.listings_with_words,
CTE_ALL.all_listings,
ROUND(100 * CAST(CTE_Listings_with_words.listings_with_words AS FLOAT) / CAST(CTE_ALL.all_listings AS FLOAT),2) AS percent_of_listings_with_words
FROM
CTE_ALL,
CTE_Listings_with_words
