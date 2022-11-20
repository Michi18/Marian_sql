import pyodbc
import matplotlib.pyplot as plt
import pandas as pd

conn = pyodbc.connect(
    'Trusted_Connection=yes;'
    'Driver={SQL Server};'
    'Server=LAPTOP-U58U7DVF\SQLEXPRESS;'
    'Database=Marian;')
cursor = conn.cursor()

query = """
WITH Revs AS(
    SELECT listing_id, category, rev
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
        ) AS unpvt)
SELECT
l.listing_id, AVG(l.price) AS price, ROUND(AVG(CAST(r.rev AS FLOAT)),2) AS avg_rev
FROM
Listings l INNER JOIN Revs r
ON l.listing_id = r.listing_id
GROUP BY l.listing_id;
"""
df_MS = pd.read_sql(query, conn)
def upper_limit(df, column):
    return df[column].mean() + 2*df[column].std()
def lower_limit(df, column):
    return df[column].mean() - 2*df[column].std()
upper_limit_price = upper_limit(df_MS, 'price')
lower_limit_price = lower_limit(df_MS, 'price')
upper_limit_rev = upper_limit(df_MS, 'avg_rev')
lower_limit_rev = lower_limit(df_MS, 'avg_rev')
print(upper_limit_price, lower_limit_price, upper_limit_rev, lower_limit_rev)
df_no_outlier = df_MS[(df_MS.price<upper_limit_price) & (df_MS.price>lower_limit_price)
& (df_MS.avg_rev<upper_limit_rev) & (df_MS.avg_rev>lower_limit_rev)]
print(df_no_outlier.describe())
print(df_MS.describe())
print(df_MS.count()-df_no_outlier.count())
def scatter(df, x_values, y_values):
    plt.scatter(x = df[x_values], y = df[y_values], c = 'blue')
    plt.xlabel(x_values)
    plt.ylabel(y_values)
    plt.show()
scatter(df_no_outlier, 'price', 'avg_rev')
plt.show()
