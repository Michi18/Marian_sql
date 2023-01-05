WITH
Revs AS
    (SELECT listing_id,
    review_scores_accuracy,
    review_scores_cleanliness,
    review_scores_checkin,
    review_scores_communication,
    review_scores_location,
    review_scores_value
    FROM Reviews),
Unpvt_revs AS(
    SELECT listing_id, rev
    FROM 
        Revs
    UNPIVOT
        (rev FOR category IN
        (review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value)
        ) AS unpvt),
Percentiles AS(
    SELECT r.listing_id,
    AVG(CAST(r.review_scores_cleanliness AS FLOAT)) OVER(PARTITION BY r.listing_id) AS AVG_clean,
    AVG(CAST(r.review_scores_value AS FLOAT)) OVER(PARTITION BY r.listing_id) AS AVG_value,
    AVG(CAST(r.review_scores_checkin AS FLOAT)) OVER(PARTITION BY r.listing_id) AS AVG_checkin,
    AVG(CAST(u.rev AS FLOAT)) OVER(PARTITION BY u.listing_id) AS AVG_revs,
    PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY r.review_scores_cleanliness) OVER () AS P80_clean,
    PERCENTILE_CONT(0.6) WITHIN GROUP (ORDER BY r.review_scores_value) OVER () AS P60_value,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY r.review_scores_checkin) OVER () AS P25_checkin,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY u.rev) OVER () AS P75_avg
    FROM Reviews r INNER JOIN Unpvt_revs u
    ON r.listing_id = u.listing_id),
Tag AS(
    SELECT listing_id,
    CASE WHEN AVG_clean > P80_clean THEN 'Super clean apartment' END AS Clean,
    CASE WHEN AVG_value > P60_value THEN 'Good value/price ratio' END AS Ratio,
    CASE WHEN AVG_checkin < P25_checkin THEN 'Difficult checkin' END AS Checkin,
    CASE WHEN AVG_revs > P75_avg THEN 'Excellent listing' END AS Excellent
    FROM Percentiles)
SELECT DISTINCT listing_id,
    CASE WHEN Clean IS NULL AND Ratio IS NULL AND Checkin IS NULL AND Excellent IS NULL THEN 'Ordinary listing'
    ELSE CONCAT_WS(', ', Clean, Ratio, Checkin, Excellent)
    END AS Tags
FROM Tag
