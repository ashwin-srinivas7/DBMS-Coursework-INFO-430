--------------- Create tables 
CREATE TABLE tblCUSTOMER (
    CustID int primary key identity(1,1),
    CustFName varchar(50) NOT NULL,
    CustLName varchar(50),
	CustDOB date
);

CREATE TABLE tblPRODUCT_TYPE (
    ProductTypeID int primary key identity(1,1),
    ProductTypeName varchar(100) not null,
    ProductTypeDesc varchar(100)
);

CREATE TABLE tblPRODUCT (
	ProductID int primary key identity(1,1),
	ProductName varchar(200) not null,
	Price float,
	ProdDescr varchar(200),
	ProductTypeID int,
	FOREIGN KEY (ProductTypeID) REFERENCES tblPRODUCT_TYPE(ProductTypeID)
);

CREATE TABLE tblORDER (
    OrderID int primary key identity(1,1),
    OrderDate date NOT NULL,
    CustID int,
	ProductID int,
	Quantity int,
	FOREIGN KEY (CustID) REFERENCES tblCUSTOMER(CustID),
	FOREIGN KEY (ProductID) REFERENCES tblPRODUCT(ProductID)
);

-------------------- Populate Tables
INSERT INTO tblCUSTOMER (CustFName, CustLName, CustDOB)
SELECT TOP 1000 CustomerFname, CustomerLName, DateOfBirth
FROM CUSTOMER_BUILD.dbo.tblCUSTOMER

INSERT INTO tblPRODUCT_TYPE (ProductTypeName, ProductTypeDesc)
VALUES ('Food', 'Anything people eat'), ('Clothing', 'Anything people wear'), ('Furniture', 'Anything people sit on in their house')

INSERT INTO tblPRODUCT (ProductName, ProductTypeID, Price)
VALUES ('Leather Sofa', 
(SELECT ProductTypeID 
FROM tblPRODUCT_TYPE 
WHERE ProductTypeName = 'Furniture'), 435.99),
('Blue Easy Chair', 
(SELECT ProductTypeID 
FROM tblPRODUCT_TYPE 
WHERE ProductTypeName = 'Furniture'), 135.99),
('Stand-Up 3-Bulb Lamp', 
(SELECT ProductTypeID 
FROM tblPRODUCT_TYPE 
WHERE ProductTypeName = 'Furniture'), 79.99),
('Leather Jacket', 
(SELECT ProductTypeID 
FROM tblPRODUCT_TYPE 
WHERE ProductTypeName = 'Clothing'), 685.99),
('Wool Socks', 
(SELECT ProductTypeID 
FROM tblPRODUCT_TYPE 
WHERE ProductTypeName = 'Clothing'), 5.99),
('Winter Ski Jacket', 
(SELECT ProductTypeID 
FROM tblPRODUCT_TYPE 
WHERE ProductTypeName = 'Clothing'), 185.99),
('Basketball Shoes', 
(SELECT ProductTypeID 
FROM tblPRODUCT_TYPE 
WHERE ProductTypeName = 'Clothing'), 88.99),
('Veggie Pizza', 
(SELECT ProductTypeID 
FROM tblPRODUCT_TYPE 
WHERE ProductTypeName = 'Food'), 15.99),
('Turkey Sandwich', 
(SELECT ProductTypeID 
FROM tblPRODUCT_TYPE 
WHERE ProductTypeName = 'Food'), 7.99),
('Ham Sandwich', 
(SELECT ProductTypeID 
FROM tblPRODUCT_TYPE 
WHERE ProductTypeName = 'Food'), 8.99)

