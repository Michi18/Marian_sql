WITH
Union_revs AS
    (SELECT listing_id, review_scores_accuracy AS rev FROM Reviews
    UNION ALL
    SELECT listing_id, review_scores_cleanliness AS rev FROM Reviews
    UNION ALL
    SELECT listing_id, review_scores_checkin AS rev FROM Reviews
    UNION ALL
    SELECT listing_id, review_scores_communication AS rev FROM Reviews
    UNION ALL
    SELECT listing_id, review_scores_location AS rev FROM Reviews
    UNION ALL
    SELECT listing_id, review_scores_value AS rev FROM Reviews),
Percentiles AS
    (SELECT r.listing_id,
    AVG(CAST(r.review_scores_cleanliness AS FLOAT)) OVER(PARTITION BY r.listing_id) AS AVG_clean,
    AVG(CAST(r.review_scores_value AS FLOAT)) OVER(PARTITION BY r.listing_id) AS AVG_value,
    AVG(CAST(r.review_scores_checkin AS FLOAT)) OVER(PARTITION BY r.listing_id) AS AVG_checkin,
    AVG(CAST(u.rev AS FLOAT)) OVER(PARTITION BY u.listing_id) as AVG_revs,
    PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY r.review_scores_cleanliness) OVER () AS P80_clean,
    PERCENTILE_CONT(0.6) WITHIN GROUP (ORDER BY r.review_scores_value) OVER () AS P60_value,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY r.review_scores_checkin) OVER () AS P25_checkin,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY u.rev) OVER () AS P70_all
    FROM Reviews r INNER JOIN Union_revs u
    ON r.listing_id = u.listing_id) 
SELECT DISTINCT p.listing_id, p.AVG_clean, p.AVG_value, p.AVG_checkin, p.AVG_revs
FROM Percentiles p;