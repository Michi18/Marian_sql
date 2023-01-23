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
        SELECT DISTINCT 
                l.city, 
                c.[date]
        FROM CTE_Calendar c CROSS JOIN Listings l
        OPTION (MAXRECURSION 0)),
CTE_Without_All_Dates AS(
        SELECT
                TOP 100 l.listing_id,
                r.review_id,
                l.city,
                r.date,
                r.review_scores_checkin
        FROM Reviews r INNER JOIN Listings l
        ON r.listing_id = l.listing_id
        WHERE DATEPART(YY, r.date) = 2018
        ORDER BY l.city, date DESC),
CTE_All AS (
        SELECT
                w.l.listing_id,
                w.review_id,
                city,
                date,
                w.review_scores_checkin
        FROM CTE_City_Date c LEFT JOIN CTE_Withous_All_Dates w
        ON c.date = w.date)
SELECT *
FROM CTE_All;



DECLARE @MinDate DATE = '20180101';
DECLARE @MaxDate DATE = '20181231';

WITH
CTE_Calendar AS(
        SELECT @MinDate as [date]
        UNION ALL
        SELECT DATEADD (dd, 1, [date])
        FROM CTE_Calendar
        WHERE DATEADD(dd, 1, [date]) <= @MaxDate)
SELECT DISTINCT 
        l.city, 
        c.[date]
FROM CTE_Calendar c CROSS JOIN Listings l 
OPTION (MAXRECURSION 0)