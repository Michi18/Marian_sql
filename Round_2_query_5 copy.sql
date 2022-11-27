SELECT r.review_id ,r.listing_id
FROM Reviews r LEFT JOIN Listings l
ON r.listing_id = l.listing_id
WHERE l.listing_id IS NULL;

SELECT r.listing_id
FROM Reviews r RIGHT JOIN Listings l
ON r.listing_id = l.listing_id
WHERE r.listing_id IS NULL;

WITH Revs AS(
    SELECT listing_id, ROUND(AVG(CAST(rev AS FLOAT)),2) AS avg_rev
    FROM 
        (SELECT listing_id,
        review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value
        FROM Reviews) r 
    UNPIVOT
        (rev FOR category IN
        (review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value)
        ) AS unpvt
    GROUP BY listing_id)
SELECT r.listing_id
FROM
Revs r RIGHT JOIN Listings l
ON l.listing_id = r.listing_id
WHERE r.listing_id IS NULL;

WITH Revs AS(
    SELECT listing_id, ROUND(AVG(CAST(rev AS FLOAT)),2) AS avg_rev
    FROM 
        (SELECT listing_id,
        review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value
        FROM Reviews) r 
    UNPIVOT
        (rev FOR category IN
        (review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value)
        ) AS unpvt
    GROUP BY listing_id)
SELECT r.listing_id
FROM
Revs r RIGHT JOIN Reviews l
ON l.listing_id = r.listing_id
WHERE r.listing_id IS NULL;