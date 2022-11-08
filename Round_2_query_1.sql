SELECT r.review_id ,r.listing_id
FROM Reviews r LEFT JOIN Listings l
ON r.listing_id = l.listing_id
WHERE l.listing_id IS NULL