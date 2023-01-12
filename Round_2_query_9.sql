WITH
Revs AS(
        SELECT *,
                ROW_NUMBER() OVER (PARTITION BY listing_id ORDER BY review_id DESC) AS rn
        FROM Reviews),
R_one AS(
        SELECT 
                listing_id,
                review_id,
                review_scores_value
        FROM Revs
        WHERE rn = 1),
R_two AS(
        SELECT 
                listing_id,
                review_id,
                review_scores_value
        FROM Revs
        WHERE rn = 2)
SELECT
        r1.listing_id,
        r1.review_id,
        r2.review_id,
        r1.review_scores_value AS last_review_scores_value,
        r2.review_scores_value AS preview_review_scores_value
FROM R_one r1 LEFT JOIN R_two r2
ON r1.listing_id = r2.listing_id;