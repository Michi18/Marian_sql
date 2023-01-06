WITH
Revs AS(
        SELECT *,
        ROW_NUMBER() OVER (PARTITION BY listing_id ORDER BY review_id DESC) AS rn
        FROM Reviews)
SELECT 
        listing_id,
        review_id,
        date,
        reviewer_id,
        review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value,
        rn
FROM Revs
WHERE rn = 2