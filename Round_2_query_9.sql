WITH
Revs AS(
        SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY listing_id ORDER BY review_id DESC) AS rn
        FROM Reviews),
Prev_revs AS(
        SELECT 
                listing_id,
                review_id,
                rn,
                review_scores_value AS last_review_scores_value,
                LAG(review_scores_value, 1) OVER (PARTITION BY listing_id ORDER BY rn DESC) AS preview_review_scores_value
        FROM Revs
        WHERE rn = 1 or rn = 2)
SELECT
        listing_id,
        review_id,
        last_review_scores_value,
        preview_review_scores_value
FROM Prev_revs
WHERE rn = 1