import pandas as pd
import pyodbc
from unidecode import unidecode
pd.set_option('display.max_columns',100)
#print(pyodbc.drivers())

conn = pyodbc.connect('Trusted_Connection=yes;''Driver={SQL Server};''Server=LAPTOP-U58U7DVF\SQLEXPRESS;''Database=Marian;')

cursor = conn.cursor()


#help(pd.read_csv)


data = pd.read_csv(r'C:\Users\micsi\Desktop\MarianSQL\AirbnbModded\Listings.csv',encoding='latin1')

df = pd.DataFrame(data)



df = df.fillna("")

df=df.drop(columns=['Unnamed: 0'])
# print(df.columns)

headers = ['listing_id', 'name', 'host_id', 'host_since', 'host_location',
       'host_response_time', 'host_response_rate', 'host_acceptance_rate',
       'host_is_superhost', 'host_total_listings_count',
       'host_has_profile_pic', 'host_identity_verified', 'neighbourhood',
       'district', 'city', 'latitude', 'longitude', 'property_type',
       'room_type', 'accommodates', 'bedrooms', 'amenities', 'price',
       'minimum_nights', 'maximum_nights', 'instant_bookable']
for header in headers:
    df.loc[df[header] == 'f', header]= False
for header in headers:
    df.loc[df[header] == 't', header]= True
for header in headers:
    df.loc[df[header]=='',header] = None



# df=df.head(1000)
# print(df.loc[:,'name'])
for n in range(0,len(df.index)):
    if df.loc[n,'name'] != None:
        df.loc[n,'name'] = str(unidecode(df.loc[n,'name']))
    if df.loc[n, 'latitude'] != None:
        df.loc[n, 'latitude'] = float(df.loc[n, 'latitude'])
    if df.loc[n, 'longitude'] != None:
        df.loc[n, 'longitude'] = float(df.loc[n, 'longitude'])
print(df.iloc[28119:28130])

# print(len(df.index))
# print(df.loc[:,'name'])
df.to_csv('Listings_formatted.csv')


# cursor.execute('''create table Listings (
# listing_id int primary key,
# name nvarchar(MAX),
# host_id int,
# host_since datetime,
# host_location nvarchar(500),
# host_response_time nvarchar(500),
# host_response_rate int,
# host_acceptance_rate int,
# host_is_superhost bit,
# host_total_listings_count int,
# host_has_profile_pic bit,
# host_identity_verified bit,
# neighbourhood nvarchar(500),
# district nvarchar(500),
# city nvarchar(500),
# latitude float,
# longitude float,
# property_type nvarchar(500),
# room_type nvarchar(500),
# accommodates int,
# bedrooms float,
# amenities nvarchar(MAX),
# price float,
# minimum_nights int,
# maximum_nights int,
# instant_bookable bit);''')
#
# for index, row in df.iterrows():
#     cursor.execute("INSERT INTO Listings values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",row.listing_id, row.name, row.host_id, row.host_since, row.host_location, row.host_response_time, row.host_response_rate, row.host_acceptance_rate, row.host_is_superhost, row.host_total_listings_count, row.host_has_profile_pic, row.host_identity_verified, row.neighbourhood, row.district, row.city, row.latitude, row.longitude, row.property_type, row.room_type, row.accommodates, row.bedrooms, row.amenities, row.price, row.minimum_nights, row.maximum_nights, row.instant_bookable)
# conn.commit()
# cursor.close()
