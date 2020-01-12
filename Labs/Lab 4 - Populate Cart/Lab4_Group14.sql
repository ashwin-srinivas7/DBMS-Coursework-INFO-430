--Creating and connecting to DB

CREATE DATABASE shreyamk_Lab4
USE shreyamk_Lab4

--Creation of tables

CREATE TABLE tblPRODUCT(
	ProductID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ProductName VARCHAR(50) NOT NULL,
	ProductDescr VARCHAR(50) NOT NULL)
	
CREATE TABLE tblCUSTOMER(
	CustID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Fname VARCHAR (50) NOT NULL,
	Lname VARCHAR(50) NOT NULL,
	BirthDate DATE NOT NULL,
	StreetAddress VARCHAR(50) NOT NULL,
	City VARCHAR(25) NOT NULL,
	[State] VARCHAR(25) NOT NULL,
	Zip INT NOT NULL)

CREATE TABLE tblCART (
	CartID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	CustID INT FOREIGN KEY REFERENCES tblCustomer (CustID) NOT NULL,
	ProductID INT FOREIGN KEY REFERENCES tblProduct (ProductID) NOT NULL,
	Quantity INT NOT NULL)

CREATE TABLE tblORDER(
	OrderID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	OrderDate DATE NULL,
	CustID INT FOREIGN KEY REFERENCES tblCustomer (CustID) NOT NULL,
	OrderTotal FLOAT NULL)

CREATE TABLE tblLINE_ITEM(
	OrderProductID INT PRIMARY KEY (OrderID, ProductID) NOT NULL,
	OrderID INT FOREIGN KEY REFERENCES tblOrder(OrderID) NOT NULL,
	ProductID INT FOREIGN KEY REFERENCES tblProduct(ProductID) NOT NULL,
	Qty INT NOT NULL,
	PriceExtended FLOAT NOT NULL
	)

ALTER TABLE tblCART
ADD CartDate Date NOT NULL

ALTER TABLE tblPRODUCT
ADD Price FLOAT NULL

--Inserting sample values into Customer and Product tables

INSERT INTO tblCUSTOMER (Fname, Lname, BirthDate, StreetAddress, City, [State], Zip) VALUES ('Philip', 'James', '01-02-1980', '10 Stewart Street', 'Seattle', 'Washington', 98101)
INSERT INTO tblPRODUCT (ProductName, ProductDescr, Price) VALUES ('Basketball', '7 inch diameter',10.0)
INSERT INTO tblPRODUCT (ProductName, ProductDescr, Price) VALUES ('Badminton', 'Racquet sport',20.0)

GO

--Stored procedure for getting customer ID

CREATE PROC uspGetCustID
	@Cust_FN VARCHAR(50),
	@Cust_LN VARCHAR(50),
	@Cust_BD DATE,
	@Cust_ID INT OUTPUT
AS
BEGIN
	SET @Cust_ID= (SELECT CustID FROM tblCUSTOMER WHERE Fname=@Cust_FN AND Lname=@Cust_LN AND BirthDate=@Cust_BD)
END 
GO

--Stored procedure for getting product ID

CREATE PROC uspGetProdID
	@Prod_Name VARCHAR (50),
	@Prod_ID INT OUTPUT

AS
BEGIN
	SET @Prod_ID = (SELECT ProductID FROM tblPRODUCT WHERE ProductName=@Prod_Name)
END
GO

--Stored procedure to populate tblCart

CREATE PROC uspPopulateCart
	@CT_Cust_FN VARCHAR(50),
	@CT_Cust_LN VARCHAR(50),
	@CT_Cust_BD DATE,
	@CT_Prod_Name VARCHAR (50),
	@CT_Quantity INT,
	@CT_Date DATE

AS
BEGIN
	DECLARE @CT_Cust_ID INT
	DECLARE @CT_Prod_ID INT

	EXEC uspGetCustID
	@Cust_FN=@CT_Cust_FN,
	@Cust_LN=@CT_Cust_LN,
	@Cust_BD=@CT_Cust_BD,
	@Cust_ID = @CT_Cust_ID OUTPUT

--Checking for null Customer ID

	IF @CT_Cust_ID IS NULL
	BEGIN
	PRINT 'Customer not found'
	RAISERROR ('Cust_ID cannot be NULL', 11,1)
	RETURN
	END

	EXEC uspGetProdID
	@Prod_Name=@CT_Prod_Name,
	@Prod_ID=@CT_Prod_ID OUTPUT

--Checking for null Product ID

	IF @CT_Prod_ID IS NULL
	BEGIN
	PRINT 'Product not found'
	RAISERROR ('CT_Prod_ID cannot be null',11,1)
	RETURN
	END

-- Error handling 
	
BEGIN TRAN G1
INSERT INTO tblCART (CustID, ProductID, Quantity, CartDate)
VALUES (@CT_Cust_ID, @CT_Prod_ID, @CT_Quantity, @CT_Date)

IF @@ERROR <> 0
ROLLBACK TRAN G1
ELSE
COMMIT TRAN G1
	
END
GO

--Passing values to populate cart

EXEC uspPopulateCart
	@CT_Cust_FN='Philip', 
	@CT_Cust_LN='James', 
	@CT_Cust_BD='1980-01-02', 
	@CT_Prod_Name='Basketball', 
	@CT_Quantity= 3, 
	@CT_Date='01-02-2019'

GO

EXEC uspPopulateCart
	@CT_Cust_FN='Philip', 
	@CT_Cust_LN='James', 
	@CT_Cust_BD='1980-01-02', 
	@CT_Prod_Name='Badminton', 
	@CT_Quantity= 2, 
	@CT_Date='01-02-2019'

GO

--Stored procedure to Process Cart

ALTER PROC uspProcessCart
	@C_FN VARCHAR(50),
	@C_LN VARCHAR(50),
	@C_BD DATE

AS
BEGIN
DECLARE @C_ID INT
	
EXEC uspGetCustID
@Cust_FN=@C_FN,
@Cust_LN=@C_LN,
@Cust_BD=@C_BD,
@Cust_ID=@C_ID OUTPUT
	
IF @C_ID IS NULL
BEGIN
PRINT 'Customer not found'
RAISERROR ('C_ID cannot be NULL',11,1)
RETURN
END

--Creation of temporary cart

DECLARE @CART TABLE (
TempCartID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
ProdID INT NOT NULL,
Qty INT NOT NULL)

INSERT INTO @CART (ProdID,Qty)
SELECT ProductID, SUM(Quantity) FROM tblCART 
WHERE CustID=@C_ID GROUP BY ProductID

DECLARE @MINPK INT

DECLARE @INDEX INT
SET @INDEX = (SELECT(COUNT (TempCartID)) FROM @CART)

--While loop for temporary cart

WHILE @INDEX>0
BEGIN
SET @MINPK=(SELECT (MIN(TempCartID)) FROM @CART)

--Populating Order table

INSERT INTO tblORDER(OrderID,CustID)
VALUES (SCOPE_IDENTITY(), @C_ID)

--Populating Line item table

INSERT INTO tblLINE_ITEM(OrderID,ProductID,Qty)
VALUES (SCOPE_IDENTITY(),
(SELECT ProdID FROM @CART WHERE @INDEX=TempCartID), 
(SELECT Qty FROM @CART WHERE @INDEX=TempCartID))
DELETE FROM @CART WHERE TempCartID=@MinPK
SET @INDEX=@INDEX-1
END 

--Calculating total order cost from Product Price

INSERT INTO tblLINE_ITEM (PriceExtended) (Select (l.Qty*p.Price)
from tblLINE_ITEM l INNER JOIN tblPRODUCT p ON l.ProductID=p.ProductID)

INSERT INTO tblORDER (OrderTotal) (Select SUM(l.PriceExtended)
from tblORDER o INNER JOIN tblLINE_ITEM l ON o.OrderID=l.OrderID)

END

--Executing stored procedure for processing cart

EXEC uspProcessCart
	@C_FN='Philip', 
	@C_LN='James', 
	@C_BD='1980-01-02'

--Clearing cart to save storage space

DELETE FROM tblCART