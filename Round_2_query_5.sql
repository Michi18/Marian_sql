WITH Revs AS(
    SELECT TOP 500 listing_id, category, rev
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
distinct l.city, count(l.room_type), ROUND(AVG(CAST(ISNULL(l.bedrooms, 1) AS FLOAT)), 2) AS avg_room, ROUND(AVG(CAST(l.accommodates AS FLOAT)), 2), ROUND(AVG(CAST(r.rev AS FLOAT)),2) AS avg_rev
FROM
Listings l INNER JOIN Revs r
ON l.listing_id = r.listing_id
WHERE l.room_type = 'Entire place'
GROUP BY l.city;

    