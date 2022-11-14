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
    AVG(CAST(u.rev AS FLOAT)) OVER(PARTITION BY u.listing_id) as AVG_revs,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY r.review_scores_cleanliness) OVER () AS P25_clean,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY u.rev) OVER () AS P75_all
    FROM Reviews r INNER JOIN Union_revs u
    ON r.listing_id = u.listing_id) 
SELECT
COUNT(DISTINCT p.listing_id) AS all_listings,
COUNT(DISTINCT CASE
    WHEN p.AVG_revs > p.P75_all and p.AVG_clean < p.P25_clean
    THEN 1 END) AS good_unclean_listings,
ROUND(100*CAST(COUNT(DISTINCT CASE
    WHEN p.AVG_revs > p.P75_all and p.AVG_clean < p.P25_clean
    THEN 1 END) AS FLOAT)/
    CAST(COUNT(DISTINCT p.listing_id) AS FLOAT), 2) AS percent_of_good_unclean
FROM Percentiles p;