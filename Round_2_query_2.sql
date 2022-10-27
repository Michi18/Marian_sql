WITH
RA AS (
    SELECT listing_id,
    ROUND(CAST(review_scores_accuracy +
    review_scores_cleanliness +
    review_scores_checkin +
    review_scores_communication +
    review_scores_location +
    review_scores_value AS FLOAT)/6,2) as avg_value
    FROM Reviews)
SELECT 
l.listing_id,
SUM(r.avg_value)/COUNT(r.avg_value) AS avg_all_values
FROM Listings l INNER JOIN RA r
ON l.listing_id = r.listing_id
GROUP BY l.listing_id

