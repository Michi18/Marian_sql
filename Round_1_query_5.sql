WITH
CTE_ALL AS (
    SELECT
    COUNT(listing_id) AS all_places
    FROM Listings),
CTE_entire_place AS (
    SELECT
    COUNT(listing_id) AS entire_places
    FROM Listings
    WHERE room_type = 'Entire place'),
CTE_private_room AS (
    SELECT
    COUNT(listing_id) AS private_rooms
    FROM Listings
    WHERE room_type = 'Private room' OR room_type = 'Shared room' OR room_type = 'Hotel room')
SELECT
CTE_ALL.all_places,
CTE_entire_place.entire_places,
CTE_private_room.private_rooms,
ROUND(100 * CAST(CTE_entire_place.entire_places AS FLOAT) / CAST(CTE_ALL.all_places AS FLOAT), 2) AS percent_of_entire_places,
ROUND(100 * CAST(CTE_private_room.private_rooms AS FLOAT) / CAST(CTE_ALL.all_places AS FLOAT), 2) AS percent_of_private_rooms
FROM
CTE_ALL,
CTE_entire_place,
CTE_private_room
