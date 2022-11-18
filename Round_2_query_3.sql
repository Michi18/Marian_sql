WITH
Unpivot_revs AS
        (SELECT listing_id, category, rev
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
        ) AS unpvt),
All_reviews AS
        (SELECT listing_id,
        AVG(CAST(rev AS FLOAT)) OVER (PARTITION BY listing_id) AS AVG_revs,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rev) OVER (PARTITION BY listing_id) AS P50_all
        FROM Unpivot_revs),
Clean_reviews AS
        (SELECT listing_id,
        AVG(CAST(rev AS FLOAT)) OVER (PARTITION BY listing_id) AS AVG_clean,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rev) OVER (PARTITION BY listing_id) AS P50_clean
        FROM Unpivot_revs
        WHERE category = 'review_scores_cleanliness')
SELECT COUNT(DISTINCT a.listing_id) AS All_listings,
        COUNT(DISTINCT (CASE WHEN a.AVG_revs > a.P50_all and c.AVG_clean < c.P50_clean
        THEN a.listing_id END)) AS good_unclean_listings,
ROUND(100*
        CAST(COUNT(DISTINCT (CASE WHEN a.AVG_revs > a.P50_all and c.AVG_clean < c.P50_clean
        THEN a.listing_id END)) AS FLOAT)/
        CAST(COUNT(DISTINCT a.listing_id) AS FLOAT), 2) AS percent_good_unclean
FROM Clean_reviews c RIGHT JOIN All_reviews a
ON c.listing_id = a.listing_id
    