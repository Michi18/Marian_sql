WITH
CTE_ALL AS (
    SELECT
    COUNT(listing_id) AS all_places
    FROM Listings),
CTE_entire_place AS (
    SELECT
    COUNT(listing_id) AS entire_place
    FROM Listings
    WHERE room_type = 'Entire place'),
CTE_private_room AS (
    SELECT
    COUNT(listing_id) AS private_room
    FROM Listings
    WHERE room_type = 'Private room')
SELECT
CTE_ALL.all_places,
CTE_entire_place.entire_place,
CTE_private_room.private_room,
ROUND(100 * CAST(CTE_entire_place.entire_place AS FLOAT) / CAST(CTE_ALL.all_places AS FLOAT), 2) AS percent_of_entire_places,
ROUND(100 * CAST(CTE_private_room.private_room AS FLOAT) / CAST(CTE_ALL.all_places AS FLOAT), 2) AS percent_of_private_rooms
FROM
CTE_ALL,
CTE_entire_place,
CTE_private_room
