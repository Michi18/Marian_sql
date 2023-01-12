SELECT
    l.listing_id,
    r.review_id,
    l.city,
    date,
    r.review_scores_checkin
FROM Reviews r INNER JOIN Listings l
ON r.listing_id = l.listing_id
WHERE DATEPART(YY, r.date) = 2018
ORDER BY l.city, date DESC

CREATE VIEW [Dates] AS
DECLARE @MinDate DATE = '20180101',
        @MaxDate DATE = '20181231';

SELECT  TOP (DATEDIFF(DAY, @MinDate, @MaxDate) + 1)
        Date = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, @MinDate)
FROM    sys.all_objects a
        CROSS JOIN sys.all_objects b;