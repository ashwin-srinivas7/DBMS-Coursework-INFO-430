
-- Check the tables in schema
USE INFO430_Lab2_ashsri --Get all the tables in the partiular schema
GO
SELECT * FROM INFORMATION_SCHEMA.TABLES


--------------------Write the SQL code to create the following tables with an emphasis on proper data types, nullability and PK/FK:
--4 a) create the customer table
CREATE TABLE tblCUSTOMER (
    CustID int NOT NULL IDENTITY(0001, 1),
    CustFname varchar(255) NOT NULL,
    CustLname varchar(255),
    CustDOB date,
    PRIMARY KEY (CustID)
)

--4 b) create the product type table
CREATE TABLE tblPRODUCT_TYPE (
    ProdTypeID int NOT NULL,
    ProdTypeName varchar(255) NOT NULL,
    ProdTypeDescr varchar(255),
    PRIMARY KEY (ProdTypeID)
)

--4 c) create the product type
CREATE TABLE tblPRODUCT (
    ProdID int NOT NULL IDENTITY(0001, 1),
	ProdName varchar(255) NOT NULL,
	ProdTypeID int NOT NULL,
	Price int NOT NULL,
    ProdDescr varchar(255),
    PRIMARY KEY (ProdID)
)

--4 d) create Employee Table
CREATE TABLE tblEMPLOYEE (
    EmpID int NOT NULL IDENTITY(0001, 1),
    EmpFname varchar(255) NOT NULL,
    EmpLname varchar(255),
	EmpDOB date,
    PRIMARY KEY (EmpID)
)

--4 e) Create the order table
CREATE TABLE tblORDER (
    OrderID int NOT NULL IDENTITY(0001, 1),
	OrderDate date,
	CustID int NOT NULL,
	ProductID int NOT NULL,
	EmpID int NOT NULL,
	Quantity int NOT NULL,
    PRIMARY KEY (OrderID)
)

--Write the SQL code to populate each look-up table with three rows using INSERT statements.

--Populate the Customer Table
INSERT INTO tblCUSTOMER(CustFname, CustLname, CustDOB)
VALUES ('Ashwin', 'Srinivas', '1994-10-07');

INSERT INTO tblCUSTOMER(CustFname, CustLname, CustDOB)
VALUES ('Smrithi', 'Kumar', '1994-07-20');

INSERT INTO tblCUSTOMER(CustFname, CustLname, CustDOB)
VALUES ('Rahul', 'Zende', '1994-03-24');

--Populate the employee
INSERT INTO tblEMPLOYEE(EmpFname, EmpLname, EmpDOB)
VALUES ('Shreyas', 'Shyamsundar', '1994-08-15');

INSERT INTO tblEMPLOYEE(EmpFname, EmpLname, EmpDOB)
VALUES ('Anjali', 'Singh', '1993-09-01');

INSERT INTO tblEMPLOYEE(EmpFname, EmpLname, EmpDOB)
VALUES ('Mark', 'Ronson', '1972-06-01');

--populate the product type table
INSERT INTO tblPRODUCT_TYPE(ProdTypeID,ProdTypeName,ProdTypeDescr)
VALUES (1,'Guitar','Acoustic and Electric Guitars')


INSERT INTO tblPRODUCT_TYPE(ProdTypeID,ProdTypeName,ProdTypeDescr)
VALUES (2,'Drums','Drum kits')

INSERT INTO tblPRODUCT_TYPE(ProdTypeID,ProdTypeName,ProdTypeDescr)
VALUES (3,'Electric Bass','Bass Guitar')

INSERT INTO tblPRODUCT_TYPE(ProdTypeID,ProdTypeName,ProdTypeDescr)
VALUES (4,'Piano','Acoustic Pianos')


--Populate the product table
select * from tblPRODUCT

INSERT INTO tblPRODUCT(ProdName,ProdTypeID,Price,ProdDescr)
VALUES ('Fender Strat',1,300,'Fender Stratocaster 1970 made') 

INSERT INTO tblPRODUCT(ProdName,ProdTypeID,Price,ProdDescr)
VALUES ('Vic Firth - John Bonham Sepcial',2,1900,'Vic Firth Deluxe Drum Set signed by John Bonham') 

INSERT INTO tblPRODUCT(ProdName,ProdTypeID,Price,ProdDescr)
VALUES ('Cort VA5',3,450,'Core 5 Stringed Electric Bass') 

INSERT INTO tblPRODUCT(ProdName,ProdTypeID,Price,ProdDescr)
VALUES ('Yamaha U1',4,3000,'Yamaha Upright Acoustic Piano') 

-- Call the stored procedure
select * from tblCUSTOMER
select * from tblPRODUCT
select * from tblEMPLOYEE


EXEC spPopulateOrders
	@CustFname = 'Ashwin' ,
	@CustLname ='Srinivas',
	@ProdName ='Cort VA5',
	@EmpFname ='Anjali',
	@EmpLname ='Singh',
	@Quantity = 5


Select * from tblORDER