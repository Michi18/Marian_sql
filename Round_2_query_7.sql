WITH
Percentiles AS
    (SELECT listing_id,
    AVG(CAST(review_scores_cleanliness AS FLOAT)) OVER(PARTITION BY listing_id) AS AVG_clean,
    AVG(CAST(review_scores_value AS FLOAT)) OVER(PARTITION BY listing_id) AS AVG_value,
    AVG(CAST(review_scores_checkin AS FLOAT)) OVER(PARTITION BY listing_id) AS AVG_checkin,
    PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY review_scores_cleanliness) OVER () AS P80_clean,
    PERCENTILE_CONT(0.6) WITHIN GROUP (ORDER BY review_scores_value) OVER () AS P60_value,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY review_scores_checkin) OVER () AS P25_checkin
    FROM Reviews)
SELECT DISTINCT l.listing_id,
CASE
    WHEN p.AVG_clean > p.P80_clean THEN 'Super clean apartament'
    WHEN p.AVG_value > p.P60_value THEN 'Good quality/price relation'
    WHEN p.AVG_checkin < p.P25_checkin THEN 'Difficult checkin'
    ELSE 'Common listing'
END AS TAG
FROM Listings l LEFT JOIN Percentiles p
ON l.listing_id = p.listing_id
ORDER BY l.listing_id

