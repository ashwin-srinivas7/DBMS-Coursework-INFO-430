----- 1. Write the SQL to determine the 300 students with the lowest GPA (all students/classes) during years 1975 -1981 partitioned by StudentPermState.
--a) Using CTE---

--Define the CTE and populate it with the required tables
WITH CTE_1 (StudentID, StudentFname, StudentLname, GPA)
AS
(	SELECT S.StudentID, S.StudentFname, StudentLname, (SUM(Cr.Credits * CL.Grade) / SUM(Cr.Credits)) GPA
	FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL on CL.StudentID=S.StudentID
	JOIN tblCLASS C on C.ClassID=CL.ClassID
	JOIN tblCOURSE Cr on Cr.CourseID=C.CourseID
	WHERE C.[YEAR]>=1975 AND C.[YEAR]<=1981
	GROUP BY  S.StudentID, S.StudentFname, StudentLname 
)
-- Write the select statement that should be returned
	SELECT TOP 300 C.StudentID, C.StudentFname, C.StudentLname, C.GPA, S.StudentPermState, 
	RANK() OVER (PARTITION BY S.StudentPermState ORDER BY C.GPA) AS RANK FROM CTE_1 C
	JOIN tblSTUDENT S ON C.StudentID=S.StudentID

--b) Using Table Variable
--Declare the table
DECLARE @Table_Var TABLE
(	
	StudentID INT NOT NULL,
	StudentFname VARCHAR(25) NOT NULL,
	StudentLname VARCHAR(25) NOT NULL,
	GPA Numeric(5,2) NULL
)

--Populate it with the required data
INSERT INTO @Table_Var(StudentID, StudentFname, StudentLname, GPA)
SELECT S.StudentID, S.StudentFname, S.StudentLname, (SUM(Cr.Credits * CL.Grade) / SUM(Cr.Credits))
		FROM tblSTUDENT S
		JOIN tblCLASS_LIST CL on CL.StudentID=S.StudentID
		JOIN tblCLASS C on C.ClassID=CL.ClassID
		JOIN tblCOURSE Cr on Cr.CourseID=C.CourseID
		WHERE C.[YEAR]>=1975 AND C.[YEAR]<=1981
		GROUP BY  S.StudentID, S.StudentFname, StudentLname 

--Retrieve the rows and ranks as specified in the question
SELECT top 300 TV.StudentID, TV.StudentFname, TV.StudentLname, TV.GPA, S.StudentPermState,
RANK() OVER (PARTITION BY S.StudentPermState ORDER BY TV.GPA) AS RANK
FROM @Table_Var TV
JOIN tblSTUDENT S on TV.StudentID=S.StudentID
-----Took almost 3 seconds to execute!

--c) Using Temp Table
SELECT S.StudentID, S.StudentFname AS StudFname, S.StudentLname AS StudLname, SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits)) AS GPA
INTO #TempTable1 
FROM tblSTUDENT S
JOIN tblCLASS_LIST CL on CL.StudentID=S.StudentID
JOIN tblCLASS C on C.ClassID=CL.ClassID
JOIN tblCOURSE Cr on Cr.CourseID=C.CourseID
WHERE C.[YEAR]>=1975 AND C.[YEAR]<=1981
GROUP BY  S.StudentID, S.StudentFname, StudentLname 

SELECT top 300 TT1.StudentID, TT1.StudFname, TT1.StudLname, TT1.GPA, S.StudentPermState,
RANK() OVER (PARTITION BY S.StudentPermState ORDER BY TT1.GPA) AS RANK
FROM #TempTable1 TT1
JOIN tblSTUDENT S on TT1.StudentID=S.StudentID



------ 2.Write the SQL to determine the 26th highest GPA during the 1970's for all business classes
--a) Using CTE

WITH CTE_2(StudentID, StudentFname, StudentLname, GPA, DRank)
AS
(
	SELECT S.StudentID, S.StudentFname, S.StudentLname, SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits)),
	DENSE_RANK() OVER (ORDER BY (SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits))))
	FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL on CL.StudentID=S.StudentID
	JOIN tblCLASS C on C.ClassID=CL.ClassID
	JOIN tblCOURSE Cr on Cr.CourseID=C.CourseID
	JOIN tblDEPARTMENT D on D.DeptID = Cr.DeptID
	WHERE D.DeptName LIKE 'Business%' 
	AND C.[YEAR] BETWEEN 1970 AND 1979
	GROUP BY S.StudentID, S.StudentFname, S.StudentLname
)
SELECT * FROM CTE_2 WHERE DRank = 26

--b) Using Table Variable

DECLARE @Tab_Var2 TABLE (
	StudentID INT NOT NULL, 
	StudentFname VARCHAR(25) NOT NULL,
	StudentLname VARCHAR(25) NOT NULL, 
	GPA NUMERIC(5,2), 
	DRank INT
)
INSERT INTO @Tab_Var2 (StudentID, StudentFname, StudentLname, GPA, DRank)
SELECT S.StudentID, S.StudentFname, S.StudentLname, SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits)),
	DENSE_RANK() OVER (ORDER BY (SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits))))
	FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL on CL.StudentID=S.StudentID
	JOIN tblCLASS C on C.ClassID=CL.ClassID
	JOIN tblCOURSE Cr on Cr.CourseID=C.CourseID
	JOIN tblDEPARTMENT D on D.DeptID = Cr.DeptID
	WHERE D.DeptName LIKE 'Business%' 
	AND C.[YEAR] BETWEEN 1970 AND 1979
	GROUP BY S.StudentID, S.StudentFname, S.StudentLname

SELECT * FROM @Tab_Var2 WHERE DRank=26

--c) Using Temp Tables
SELECT S.StudentID StudID, S.StudentFname StudFname, S.StudentLname StudLname, SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits)) StudGPA,
DENSE_RANK() OVER (ORDER BY (SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits)))) AS DRank
INTO #TempTable2
FROM tblSTUDENT S
JOIN tblCLASS_LIST CL on CL.StudentID=S.StudentID
JOIN tblCLASS C on C.ClassID=CL.ClassID
JOIN tblCOURSE Cr on Cr.CourseID=C.CourseID
JOIN tblDEPARTMENT D on D.DeptID = Cr.DeptID
WHERE D.DeptName LIKE 'Business%' 
AND C.[YEAR] BETWEEN 1970 AND 1979
GROUP BY S.StudentID, S.StudentFname, S.StudentLname

SELECT * FROM #TempTable2 WHERE DRank = 26

---------3. Write the SQL to divide ALL students into 100 groups based on GPA for Arts & Sciences classes during 1980's
--a) Using CTE
WITH  CTE_3(StudentID, StudentFname, StudentLname, GPA, Quartile)
AS
(
	SELECT S.StudentID, S.StudentFname, S.StudentLname, SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits)),
	NTILE(100) OVER (ORDER BY (SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits))))
	FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL on CL.StudentID=S.StudentID
	JOIN tblCLASS C on C.ClassID=CL.ClassID
	JOIN tblCOURSE Cr on Cr.CourseID=C.CourseID
	JOIN tblDEPARTMENT D on D.DeptID = Cr.DeptID
	WHERE D.DeptName LIKE 'Arts%' OR  D.DeptName LIKE 'Science%'
	AND C.[YEAR] BETWEEN 1980 AND 1989
	GROUP BY S.StudentID, S.StudentFname, S.StudentLname
)
SELECT * FROM CTE_3

--b) Using Table Variable

DECLARE @Table_Var3 TABLE (
	StudentID INT NOT NULL, 
	StudentFname VARCHAR(25) NOT NULL,
	StudentLname VARCHAR(25) NOT NULL, 
	GPA NUMERIC(5,2), 
	Quartile INT
)

INSERT INTO @Table_Var3(StudentID, StudentFname, StudentLname, GPA, Quartile)
SELECT S.StudentID, S.StudentFname, S.StudentLname, SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits)),
	NTILE(100) OVER (ORDER BY (SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits))))
	FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL on CL.StudentID=S.StudentID
	JOIN tblCLASS C on C.ClassID=CL.ClassID
	JOIN tblCOURSE Cr on Cr.CourseID=C.CourseID
	JOIN tblDEPARTMENT D on D.DeptID = Cr.DeptID
	WHERE D.DeptName LIKE 'Arts%' OR  D.DeptName LIKE 'Science%'
	AND C.[YEAR] BETWEEN 1980 AND 1989
	GROUP BY S.StudentID, S.StudentFname, S.StudentLname

SELECT * FROM @Table_Var3

--c) Using Temp Table
SELECT S.StudentID as StID, S.StudentFname as StFname, S.StudentLname as StLname, SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits)) as GPA,
	NTILE(100) OVER (ORDER BY (SUM(Cr.Credits * CL.Grade)/(SUM(Cr.Credits)))) as Quartile
INTO #TempTable3
FROM tblSTUDENT S
	JOIN tblCLASS_LIST CL on CL.StudentID=S.StudentID
	JOIN tblCLASS C on C.ClassID=CL.ClassID
	JOIN tblCOURSE Cr on Cr.CourseID=C.CourseID
	JOIN tblDEPARTMENT D on D.DeptID = Cr.DeptID
	WHERE D.DeptName LIKE 'Arts%' OR  D.DeptName LIKE 'Science%'
	AND C.[YEAR] BETWEEN 1980 AND 1989
	GROUP BY S.StudentID, S.StudentFname, S.StudentLname

SELECT * FROM #TempTable3