CREATE VIEW SingleReviews AS
SELECT r.* from 
Reviews r INNER JOIN (select review_id from Reviews GROUP BY review_id HAVING COUNT(review_id) =1) as r2
ON r.review_id = r2.review_id;

SELECT r2.listing_id,
        r2.last_review,
        r.date,
        r.review_scores_accuracy,
        r.review_scores_cleanliness,
        r.review_scores_checkin,
        r.review_scores_communication,
        r.review_scores_location,
        r.review_scores_value,
        r2.avg_last_rev
FROM (SELECT
                distinct listing_id,
                review_id,
                MAX(review_id) OVER(PARTITION BY listing_id) as last_review,
                AVG(rev) OVER(PARTITION BY review_id) AS avg_last_rev
        FROM 
        (SELECT TOP 100 listing_id,
        review_id,
        review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value
        FROM SingleReviews) r 
    UNPIVOT
        (rev FOR category IN
        (review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value)
        ) AS unpvt) as r2
INNER JOIN Reviews r ON
r.listing_id = r2.listing_id
WHERE r2.review_id = r2.last_review;



