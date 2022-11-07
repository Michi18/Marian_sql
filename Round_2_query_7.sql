WITH AVG_REVS AS
    (WITH Revs AS
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
        SELECT listing_id, review_scores_value AS rev FROM Reviews)
    SELECT
    listing_id, ROUND(AVG(CAST(rev AS FLOAT),2) AS avg_rev
    FROM
    Revs),
Percentiles AS
    (SELECT r.listing_id,
    AVG((r.review_scores_cleanliness) OVER(PARTITION BY r.listing_id) AS AVG_clean,
    AVG((r.review_scores_value) OVER(PARTITION BY r.listing_id) AS AVG_value,
    AVG((r.review_scores_checkin) OVER(PARTITION BY r.listing_id) AS AVG_checkin,
    PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY r.review_scores_cleanliness) OVER () AS P80_clean,
    PERCENTILE_CONT(0.6) WITHIN GROUP (ORDER BY r.review_scores_value) OVER () AS P60_value,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY r.review_scores_checkin) OVER () AS P25_checkin,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY a.avg_rev) OVER() AS P75_avg_rank
    FROM Reviews r INNER JOIN AVG_REVS a
    ON r.listing_id = a.listing_id)
SELECT DISTINCT l.listing_id,
CASE
    WHEN p.AVG_clean > p.P80_clean THEN 'Super clean apartament'
    WHEN p.AVG_value > p.P60_value THEN 'Good quality/price relation'
    WHEN p.AVG_checkin < p.P25_checkin THEN 'Difficult checkin'
    ELSE 'Common listing'
END AS TAG
FROM Listings l LEFT JOIN Percentiles p
ON l.listing_id = p.listing_id
ORDER BY l.listing_id;
