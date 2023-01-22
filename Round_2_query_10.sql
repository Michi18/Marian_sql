DECLARE @MinDate DATE = '20180101';
DECLARE @MaxDate DATE = '20181231';

WITH
CTE_Calendar AS(
        SELECT @MinDate as [date]
        UNION ALL
        SELECT DATEADD (dd, 1, [date])
        FROM CTE_Calendar
        WHERE DATEADD(dd, 1, [date]) <= @MaxDate),
CTE_City_Date AS(
        SELECT DISTINCT l.city, c.[date]
        FROM CTE_Calendar c CROSS JOIN Listings l 
        OPTION (MAXRECURSION 0)),
CTE_Whole_Year AS (

SELECT
    l.listing_id,
    r.review_id,
    l.city,
    date,
    r.review_scores_checkin
FROM Reviews r INNER JOIN Listings l
ON r.listing_id = l.listing_id
WHERE DATEPART(YY, r.date) = 2018
ORDER BY l.city, date DESC;