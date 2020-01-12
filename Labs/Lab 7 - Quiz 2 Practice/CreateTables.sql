-- CREATE ALL TABLES

CREATE TABLE tblStudent
(	StudentID int identity(1,1) primary key,
	StudentFName varchar(50) not null,
	StudentLName varchar(50) not null,
	StudentDOB date not null,
)

CREATE TABLE tblBuilding
(
	BuildingID int identity(1,1) primary key,
	BuildingName varchar(50) not null,
	BuildingDate date
)

CREATE TABLE tblUnit
(
	UnitID int identity(1,1) primary key,
	UnitName varchar(50) not null,
	BuildingID int foreign key references tblBuilding(BuildingID)
)

CREATE TABLE tblLease
(
	LeaseID int identity(1,1) primary key,
	StudentID int foreign key references tblStudent(StudentID),
	UnitID int foreign key references tblUnit(UnitID),
	BeginDate date not null,
	EndDate date,
	MonthlyRent numeric (8,1) not null
)

-- INSERT VALUES INTO LOOK UP TABLES

INSERT INTO tblStudent(StudentFName, StudentLName, StudentDOB)
VALUES ('Ashwin','Srinivas','October 7, 1994'), ('Rahul','Zende','March 5, 1993'), ('Smrithi','Kumar','July 20, 1994')

INSERT INTO tblStudent(StudentFName, StudentLName, StudentDOB)
VALUES ('Mac','Miller','October 7, 2006')



INSERT INTO tblBuilding(BuildingName, BuildingDate)
VALUES ('Fosters Dorm','May 6, 1900'), ('Mary Gates','Feb 6, 1924'), ('Vermont Hall','Dec 15, 2000')

SELECT * FROM tblBuilding

SELECT * from tblUnit

SELECT * FROM tblStudent

SELECT * FROM tblLease

EXECUTE spAddNewLease
@F = 'Ashwin',
@L = 'Srinivas',
@B = 'Oct 7, 1994',
@Uname = 'A002',
@StartDate = 'May 24, 2019',
@EndDate = 'June 25, 2020',
@Rent = 1250

SELECT * FROM tblLease