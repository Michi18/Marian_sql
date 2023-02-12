DECLARE @MinDate DATE = '20180101';
DECLARE @MaxDate DATE = '20181231';

--First solution (with days)

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
        FROM CTE_Calendar c CROSS JOIN Listings l),
CTE_Without_All_Dates AS(
        SELECT
                l.listing_id,
                r.review_id,
                l.city,
                r.date,
                r.review_scores_checkin
        FROM Reviews r INNER JOIN Listings l
        ON r.listing_id = l.listing_id
        WHERE DATEPART(YY, r.date) = 2018),
CTE_All AS (
        SELECT
                w.listing_id,
                w.review_id,
                c.city,
                c.date,
                DATEPART(YEAR, c.date) AS year,
                DATEPART(MONTH, c.date) AS month,
                DATEPART(DAY, c.date) as day,
                w.review_scores_checkin
        FROM CTE_City_Date c LEFT JOIN CTE_Without_All_Dates w
        ON c.date = w.date and c.city = w.city),
CTE_Sum AS (
        SELECT 
                distinct date,
                day,
                month,
                year,
                city,
                COUNT(review_scores_checkin) OVER (PARTITION BY year, month, day, city) AS revs_count_day,
                SUM(review_scores_checkin) OVER (PARTITION  BY year, month, day, city) as revs_sum_day,
                COUNT(review_scores_checkin) OVER (PARTITION BY year, month, city) AS revs_count_month,
                SUM(review_scores_checkin) OVER (PARTITION  BY year, month, city) as revs_sum_month
        FROM CTE_All)
SELECT
        day,
        month,
        year,
        city,
        ROUND( CAST(SUM(revs_sum_day) OVER (PARTITION BY city ORDER BY year, month, day ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS FLOAT) / CAST(SUM(revs_count_day) OVER (PARTITION BY city ORDER BY year, month, day ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS FLOAT), 2) AS rolling_avg_seven_days,
        ROUND( CAST(SUM(revs_sum_day) OVER (PARTITION BY city ORDER BY year, month, day ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS FLOAT) / CAST(SUM(revs_count_day) OVER (PARTITION BY city ORDER BY year, month, day ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS FLOAT), 2) AS rolling_avg_thirty_days,
        ROUND( CAST(SUM(revs_sum_day) OVER (PARTITION BY city ORDER BY year, month, day ROWS BETWEEN 89 PRECEDING AND CURRENT ROW) AS FLOAT) / CAST(SUM(revs_count_day) OVER (PARTITION BY city ORDER BY year, month, day ROWS BETWEEN 89 PRECEDING AND CURRENT ROW) AS FLOAT), 2) AS rolling_avg_ninety_days,
        ROUND( CAST(SUM(revs_sum_day) OVER (PARTITION BY city ORDER BY year, month, day, day ROWS BETWEEN 364 PRECEDING AND CURRENT ROW) AS FLOAT) / CAST(SUM(revs_count_day) OVER (PARTITION BY city ORDER BY year, month, day ROWS BETWEEN 364 PRECEDING AND CURRENT ROW) AS FLOAT), 2) AS rolling_avg_three_hundred_sixty_five_days
FROM CTE_Sum
ORDER BY city
OPTION (MAXRECURSION 0);


-- Second solution (with months)

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
        FROM CTE_Calendar c CROSS JOIN Listings l),
CTE_Without_All_Dates AS(
        SELECT
                l.listing_id,
                r.review_id,
                l.city,
                r.date,
                r.review_scores_checkin
        FROM Reviews r INNER JOIN Listings l
        ON r.listing_id = l.listing_id
        WHERE DATEPART(YY, r.date) = 2018),
CTE_All AS (
        SELECT
                w.listing_id,
                w.review_id,
                c.city,
                c.date,
                DATEPART(YEAR, c.date) AS year,
                DATEPART(MONTH, c.date) AS month,
                DATEPART(DAY, c.date) as day,
                w.review_scores_checkin
        FROM CTE_City_Date c LEFT JOIN CTE_Without_All_Dates w
        ON c.date = w.date and c.city = w.city),
CTE_Sum_Day AS (
        SELECT 
                distinct date,
                day,
                month,
                year,
                city,
                COUNT(review_scores_checkin) OVER (PARTITION BY day, month, year, city) AS revs_count_day,
                SUM(review_scores_checkin) OVER (PARTITION  BY day, month, year, city) as revs_sum_day
        FROM CTE_All),
CTE_Sum_Month AS (
        SELECT 
                distinct month,
                year,
                city,
                COUNT(review_scores_checkin) OVER (PARTITION BY month, year, city) AS revs_count_month,
                SUM(review_scores_checkin) OVER (PARTITION  BY month, year, city) as revs_sum_month
        FROM CTE_All),
CTE_Roll_Avg_Month AS (
        SELECT
                month,
                year,
                city,
                revs_sum_month,
                revs_count_month,
                ROUND( CAST(SUM(revs_sum_month) OVER (PARTITION BY year, month, city ORDER BY year, month) AS float) / CAST(SUM(revs_count_month) OVER (PARTITION BY year, month, city ORDER BY year, month) AS float), 2) AS rolling_avg_one_month,
                ROUND( CAST(SUM(revs_sum_month) OVER (PARTITION BY city ORDER BY year, month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS float) / CAST(SUM(revs_count_month) OVER (PARTITION BY city ORDER BY year, month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS float), 2) AS rolling_avg_three_months,
                ROUND( CAST(SUM(revs_sum_month) OVER (PARTITION BY city ORDER BY year, month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS float) / CAST(SUM(revs_count_month) OVER (PARTITION BY city ORDER BY year, month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS float), 2) AS rolling_avg_twelve_months
        FROM CTE_Sum_Month),
CTE_Roll_Avg_Day AS (
        SELECT
            day,
            month,
            year,
            city,
            revs_sum_day,
            revs_count_day,
            ROUND( CAST(SUM(revs_sum_day) OVER (PARTITION BY city ORDER BY year, month, day ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS FLOAT) / CAST(SUM(revs_count_day) OVER (PARTITION BY city ORDER BY year, month, day ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS FLOAT), 2) AS rolling_avg_seven_days
        FROM CTE_Sum_Day)
SELECT
    d.day,
    d.month,
    d.year,
    d.city,
    d.rolling_avg_seven_days,
    m.rolling_avg_one_month,
    m.rolling_avg_three_months,
    m.rolling_avg_twelve_months
FROM CTE_Roll_Avg_Day d INNER JOIN CTE_Roll_Avg_Month m 
ON d.city = m.city AND d.month = m.month AND d.year = m.year 
ORDER BY d.city
OPTION (MAXRECURSION 0);


