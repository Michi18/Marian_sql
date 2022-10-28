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
GROUP BY l.listing_id;




WITH
RA AS(
    Select listing_id,
    AVG(CAST(review_scores_accuracy AS FLOAT)) as AVG_1,
    AVG(CAST(review_scores_cleanliness AS FLOAT)) as AVG_2,
    AVG(CAST(review_scores_checkin AS FLOAT)) as AVG_3,
    AVG(CAST(review_scores_communication AS FLOAT)) as AVG_4,
    AVG(CAST(review_scores_location AS FLOAT)) as AVG_5,
    AVG(CAST(review_scores_value AS FLOAT)) as AVG_6
    FROM Reviews
    GROUP BY listing_id)
SELECT r.listing_id, r.AVG_1, r.AVG_2, r.AVG_3, r.AVG_4, r.AVG_5, r.AVG_6,
(r.AVG_1 + r.AVG_2 + r.AVG_3 + r.AVG_4 + r.AVG_5 + r.AVG_6)/6 AS AVG_ALL
FROM Listings l INNER JOIN RA r
ON r.listing_id = l.listing_id

