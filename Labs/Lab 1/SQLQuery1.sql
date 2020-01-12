--What is the shortest movie?
select top 1 movieOriginalTitle,movieRuntime
from dbo.tblMovie
where movieRuntime is not null
order by movieRuntime

--What is the movie with the most number of votes?
select top 1 movieOriginalTitle, movieVoteCount
from dbo.tblMovie
where movieVoteCount is not null
order by movieVoteCount DESC

--Which movie made the most net profit?
select top 1 movieOriginalTitle, (movieRevenue-movieBudget) as NetProfit
from dbo.tblMovie
order by NetProfit DESC

--Which movie lost the most money?
select top 1 movieOriginalTitle, (movieRevenue-movieBudget) as NetProfit
from dbo.tblMovie
order by NetProfit ASC

--How many movies were made in the 80’s?
select count(*)
from dbo.tblMovie
where movieReleaseDate between '1980-01-01' and '1989-12-31'

--What is the most popular movie released in the year 1980?
select top 1 movieOriginalTitle, moviePopularity
from dbo.tblMovie
where movieReleaseDate between '1980-01-01' and '1980-12-31'
order by moviePopularity DESC

--How long was the longest movie made before 1900?
select top 1 movieOriginalTitle, movieRuntime
from dbo.tblMovie
where movieReleaseDate < '1899-12-31'
order by movieRuntime DESC

--Which language has the shortest movie?
select top 1 l.languageName, m.movieOriginalTitle, m.movieRuntime from dbo.tblLanguage l
left outer join dbo.tblMovie m
on l.languageID = m.languageID
order by m.movieRuntime DESC

--Which collection has the highest total popularity?
select top 1 c.collectionID, c.collectionName,  sum(m.moviePopularity) as Popularity from dbo.tblCollection c
left outer join dbo.tblMovie m
on m.collectionID = c.collectionID
group by c.collectionID, c.collectionName
order by Popularity DESC

--Which language has the most movies in production or post-production?
select top 1 l.languageCode, l.languageName, count(m.movieID) as movieCount from dbo.tblLanguage l
left outer join dbo.tblMovie m
on l.languageID=m.languageID
left outer join dbo.tblStatus s
on m.statusID = s.statusID
where s.statusID=3 or s.statusID=6
group by l.languageCode, l.languageName
order by movieCount DESC


--What was the most expensive movie that ended up getting canceled?
select top 1 m.movieOriginalTitle, m.movieBudget, s.statusName
from dbo.tblMovie m, dbo.tblStatus s
where m.statusID = s.statusID and s.statusName ='Canceled'
order by m.movieBudget DESC


--How many collections have movies that are in production for the language French (FR)
select count(distinct c.collectionID) from dbo.tblMovie m
	join dbo.tblCollection c
	on m.collectionID = c.collectionID
	join dbo.tblStatus s
	on m.statusID = s.statusID
	join dbo.tblLanguage l
	on m.languageID=l.languageID
where s.statusID=3 and l.languageCode='fr'

--List the top ten rated movies that have received more than 5000 votes
select top 10 m.movieOriginalTitle, m.movieVoteCount from dbo.tblMovie m
where m.movieVoteCount >= 5000
order by m.movieVoteCount DESC


--Which collection has the most movies associated with it?
select top 1 c.collectionID, c.collectionName, count(m.movieID) as numMovies from dbo.tblCollection c
left outer join dbo.tblMovie m
on c.collectionID=m.collectionID
group by c.collectionID, c.collectionName
order by numMovies DESC

--What is the collection with the longest total duration?
select top 1 c.collectionID, c.collectionName, sum(m.movieRuntime) as TotalRunTime from dbo.tblCollection c
left outer join dbo.tblMovie m
on c.collectionID = m.collectionID
group by c.collectionID, c.collectionName
order by TotalRunTime DESC

--Which collection has made the most net profit?
select top 1 c.collectionID, c.collectionName, sum(m.movieRevenue-m.movieBudget) as netProfit from dbo.tblCollection c
left outer join dbo.tblMovie m
on c.collectionID=m.collectionID
group by c.collectionID, c.collectionName
order by netProfit DESC

--List the top 100 movies by their duration from longest to shortest
select top 100 m.movieOriginalTitle, m.movieRuntime from dbo.tblMovie m
order by m.movieRuntime DESC

--Which languages have more than 25,000 movies associated with them?
select top 1 m.languageID, l.languageName, count(m.movieID) numOfMovies from dbo.tblMovie m
inner join dbo.tblLanguage l
on m.languageID=l.languageID
group by m.languageID, l.languageName
having count(m.movieID) > 25000

--Which collections had all their movies made in the 80’s?
select c.collectionID, c.collectionName from dbo.tblCollection c
left outer join dbo.tblMovie m
on c.collectionID=m.collectionID
EXCEPT
select c.collectionID, c.collectionName from dbo.tblCollection c
left outer join dbo.tblMovie m
on c.collectionID=m.collectionID
where m.movieReleaseDate < '1980-01-01' or m.movieReleaseDate > '1989-12-31'

    --vertify this:
	select m.movieID, m.movieOriginalTitle, m.movieReleaseDate from tblMovie m where m.collectionID=650


--In the language that has the most number of movies in the database, how many movies start with “The”?
--(You may not hard-code a language)

select top 30 count(m.movieID) as 'Number of Movies' from dbo.tblMovie m
where (m.movieOriginalTitle like 'The%' or m.movieOriginalTitle like 'the%') and m.languageID like
(
	select top 1 l.languageID from dbo.tblLanguage l
	left outer join dbo.tblMovie m
	on l.languageID=m.languageID
	group by l.languageID, l.languageCode
	order by count(m.movieID) DESC
)