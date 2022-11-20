WITH Revs AS(
    SELECT listing_id, category, rev
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
        ) AS unpvt)
SELECT
l.listing_id, AVG(l.price) AS price, ROUND(AVG(CAST(r.rev AS FLOAT)),2) AS avg_rev
FROM
Listings l INNER JOIN Revs r
ON l.listing_id = r.listing_id
GROUP BY l.listing_id;
    