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
Select minimum_nights, maximum_nights, price, city from Listings;
"""
df_MS = pd.read_sql(query, conn)
def upper_limit(df, column):
    return df[column].mean() + 3*df[column].std()
def lower_limit(df, column):
    return df[column].mean() - 3*df[column].std()
upper_limit_price = upper_limit(df_MS, 'price')
lower_limit_price = lower_limit(df_MS, 'price')
upper_limit_min = upper_limit(df_MS, 'minimum_nights')
lower_limit_min = lower_limit(df_MS, 'minimum_nights')
upper_limit_max = upper_limit(df_MS, 'maximum_nights')
lower_limit_max = lower_limit(df_MS, 'maximum_nights')
print(upper_limit_price, lower_limit_price, upper_limit_min, lower_limit_min, upper_limit_max, lower_limit_max)
df_no_outlier = df_MS[(df_MS.price<upper_limit_price) & (df_MS.price>lower_limit_price)
& (df_MS.minimum_nights<upper_limit_min) & (df_MS.minimum_nights>lower_limit_min)
& (df_MS.maximum_nights<upper_limit_max) & (df_MS.maximum_nights>lower_limit_max)]
print(df_no_outlier.describe())
print(df_MS.describe())
print(df_MS.count()-df_no_outlier.count())
def scatter(df, x_values, y_values):
    plt.scatter(x = df[x_values], y = df[y_values], c = 'blue')
    plt.xlabel(x_values)
    plt.ylabel(y_values)
    plt.show()
scatter(df_no_outlier, 'price', 'minimum_nights')
scatter(df_no_outlier, 'price', 'maximum_nights')
scatter(df_no_outlier, 'city', 'minimum_nights')
scatter(df_no_outlier, 'city', 'maximum_nights')

