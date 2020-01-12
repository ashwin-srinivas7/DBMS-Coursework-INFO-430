# Import all libraries
import pyodbc
import requests as r
from bs4 import BeautifulSoup as bs

domain='http://books.toscrape.com/'

frontpage=r.get(domain)
totalpages=50

i=1
links=[]
title=[]


# ---------- Get the links of each book from all the 50 pages in the website ------------ #
for pageurl in [domain+'catalogue/page-'+str(i)+'.html']:
    for i in range(1,totalpages+1):
        page=r.get(pageurl)
        pagescrape=bs(page.content,'html.parser')      
        container=pagescrape.select('h3 a')
        links.extend([domain+'catalogue/'+i['href'] for i in container]) # get all URLs for all 1000 books




# ---------- get the titles, price, description and genre name for each book for each link  ------------ #

title=[] 
price=[] 
descr=[]
genre=[]

for link in links:
    page_book=r.get(link)
    page_book_scrape=bs(page_book.content,'html.parser')
    title.append(page_book_scrape.find('title').text)
    price.append(page_book_scrape.find('p', {"class" : "price_color"}).text)
    descr.append(page_book_scrape.find('p').find_next('p').find_next('p').find_next('p').text)
    genreList =[]
    genreList = page_book_scrape.find('ul',{"class" : "breadcrumb"}).find_all('li')
    genreText = []
    genreText = [i.text for i in genreList]
    genre.append(genreText[2])


genre_list = [] # to remove the leading and trailing \n from list - genre
for i in genre:
    genre_list.append(i[1:-1])
    
title_list = [i.strip() for i in title] # strip leading and trailing spaces for titles

zipped = list(zip(title_list,price,descr,genre_list)) # create list of tuples to pass into the stored procedure

# --------- Connecting to the database and calling the stored Procedure ---------------- #

# Connect to database using ODBC
cnxn = pyodbc.connect('DRIVER={ODBC Driver 13 for SQL Server};SERVER=IS-HAY04.ischool.uw.edu;DATABASE=ashsrini_BookDB;UID=info430;PWD=GoHuskies!;autocommit=True')
cursor = cnxn.cursor()

# Call stored procedure
InsertQuery = """\
SET NOCOUNT ON;
EXECUTE [dbo].[spPopulateBooks2]
    @bookTitle = ?,
    @bookPrice = ?,
    @bookDesc = ?,
    @genreName = ?
"""
# Execute the stored procedure with the arguments passed in
for record in zipped:
    cursor.execute(InsertQuery, record)
cnxn.commit()
