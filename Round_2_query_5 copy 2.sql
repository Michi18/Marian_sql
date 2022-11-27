Select distinct l.city, count(l.room_type)
FROM
Listings l INNER JOIN Reviews r
ON l.listing_id = r.listing_id
WHERE l.room_type = 'Entire place'
GROUP BY l.city;