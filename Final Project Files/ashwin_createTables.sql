CREATE TABLE tblCUSTOMER (
  [CustID] Int identity(1,1) primary key ,
  [CustFname] VarChar(50) not null,
  [CustLname] VarChar(50) not null,
  [CustDOB] Date not null,
  [StreetAddress] VarChar(255),
  [City] VarChar(50),
  [State] VarChar(50),
  [CustPostalCode] VarChar(15)
);

CREATE TABLE tblSALES_ORDER (
	SalesOrderID int identity(1,1) primary key,
	SalesOrderDate date not null,
	CustID int foreign key references tblCUSTOMER(CustID),
	SalesOrderTotal decimal not null
	)
USE team14_home_decor
CREATE TABLE tblSALES_LINE_ITEM (
	SalesLineItemID int identity(1,1) primary key,
	SalesOrderID int foreign key references tblSALES_ORDER(SalesOrderID),
	ProductID int foreign key references tblPRODUCT(ProductID),
	Quant int not null,
	PriceExtended as ([dbo].[fnCalculateLineItemTotal]([SalesLineItemID])
)
)

CREATE TABLE tblLINE_ITEM1 (
	SalesLineItemID int identity(1,1) primary key,
	SalesOrderID int foreign key references tblSALES_ORDER(SalesOrderID),
	ProductID int foreign key references tblPRODUCT(ProductID),
	Quant int not null,
	PriceExtended as ([dbo].[fnCalcLineItemTotal]([SalesLineItemID]))
)

CREATE TABLE tblPRODUCT_TYPE (
  [ProdTypeID] Int identity(1,1) primary key,
  [ProdTypeName] VarChar(50) not null,
  [ProductTypeDescr] varchar(500) null
);

CREATE TABLE tblSHIPMENT (
  [ShipmentID] Int identity(1,1) primary key,
  [CarrierID] int foreign key references tblCARRIER(CarrierID) not null,
  SalesLineItemID int foreign key references tblLINE_ITEM(SalesLineItemID)
);

CREATE TABLE [tblPRODUCT] (
  [ProductID] Int identity(1,1) primary key,
  [ProductName] varchar(50) not null,
  [ProductDesc] varchar(255) null,
  [Price] decimal not null,
  [ProdTypeID] int foreign key references tblPRODUCT_TYPE(ProdTypeID)
);

CREATE TABLE tblPRODUCT_PRICE_HISTORY (
  [PriceHistID] Int identity(1,1) primary key,
  [BeginDate] Date not null,
  [EndDate] Date,
  [ProdID] Int foreign key references tblPRODUCT(ProductID)
);

CREATE TABLE [tblSALES_ORDER] (
  [SalesOrderID] Int primary key,
  [TotalAmount] decimal not null,
  [CustID] Int foreign key references tblCUSTOMER(CustID)
);


CREATE TABLE [tblSALES_LINE_ITEM] (
  [LineItemID] Int identity(1,1) primary key,
  [Quantity] Int not null,
  [ProductID] Int foreign key references tblPRODUCT(ProductID),
  [SalesOrderID] Int foreign key references tblSALES_ORDER(SalesOrderID)
);

CREATE TABLE tblCART (
	CartID int identity(1,1) primary key,
	CustID int foreign key references tblCUSTOMER(CustID),
	ProductID int foreign key references tblPRODUCT(ProductID),
	CartDate date not null,
	Quantity int not null
	) 
-------------------- populate tblCUSTOMER --------------------------------------
INSERT INTO tblCUSTOMER (CustFName, CustLName, CustDOB, StreetAddress, City, State, CustPostalCode)
SELECT TOP 1000 CustomerFname, CustomerLName, DateOfBirth, CustomerAddress, CustomerCity, CustomerState, CustomerZIP
FROM CUSTOMER_BUILD.dbo.tblCUSTOMER

-------------------- populate tblPRODUCT_TYPE ----------------------------------
INSERT INTO tblPRODUCT_TYPE (ProdTypeName, ProductTypeDescr)
VALUES ('Decorative Accessories','Accessories used to decorate a given space..')

INSERT INTO tblPRODUCT_TYPE (ProdTypeName, ProductTypeDescr)
VALUES ('Lighting','Light up your space')

INSERT INTO tblPRODUCT_TYPE (ProdTypeName, ProductTypeDescr)
VALUES ('Window Treatments','Add beauty to windows')

INSERT INTO tblPRODUCT_TYPE (ProdTypeName, ProductTypeDescr)
VALUES ('Wall Decor','Make ugly walls beautiful')

INSERT INTO tblPRODUCT_TYPE (ProdTypeName, ProductTypeDescr)
VALUES ('Mirrors','Look at yourself')

INSERT INTO tblPRODUCT_TYPE (ProdTypeName, ProductTypeDescr)
VALUES ('Curtains and Drapes','Elegantly protect your privacy')

INSERT INTO tblPRODUCT_TYPE (ProdTypeName, ProductTypeDescr)
VALUES ('Fireplaces','Make your fireplace from ugly to cozy')

INSERT INTO tblPRODUCT_TYPE (ProdTypeName, ProductTypeDescr)
VALUES ('Rugs','Turn ugly looking floors into art')

-------------------- populate tblPRODUCT ----------------------------------
INSERT INTO tblPRODUCT (ProductName, Price, ProdTypeID)
VALUES ('The Gray Barn Jartop Square Wall Clock', 60, (SELECT ProdTypeID from tblPRODUCT_TYPE WHERE ProdTypeName = 'Decorative Accessories'))

INSERT INTO tblPRODUCT (ProductName, Price, ProdTypeID)
VALUES ('Danya B. Three Industrial Pipe Wall Shelf', 126, (SELECT ProdTypeID from tblPRODUCT_TYPE WHERE ProdTypeName = 'Decorative Accessories'))

INSERT INTO tblPRODUCT (ProductName, Price, ProdTypeID)
VALUES ('Veneer Corner Wall Mount Shelf', 115, (SELECT ProdTypeID from tblPRODUCT_TYPE WHERE ProdTypeName = 'Decorative Accessories'))


INSERT INTO tblPRODUCT (ProductName, Price, ProdTypeID)
VALUES ('White Stained Glass Floral Art', 199, (SELECT ProdTypeID from tblPRODUCT_TYPE WHERE ProdTypeName = 'Decorative Accessories'))

INSERT INTO tblPRODUCT (ProductName, Price, ProdTypeID)
VALUES (' Waters Edge II - Gallery Wrapped Canvas', 99, (SELECT ProdTypeID from tblPRODUCT_TYPE WHERE ProdTypeName = 'Decorative Accessories'))

INSERT INTO tblPRODUCT (ProductName, Price, ProdTypeID)
VALUES ('LED Table Lamp clip on', 69, (SELECT ProdTypeID from tblPRODUCT_TYPE WHERE ProdTypeName = 'Lighting'))

INSERT INTO tblPRODUCT (ProductName, Price, ProdTypeID)
VALUES ('White Plastic Shade', 248, (SELECT ProdTypeID from tblPRODUCT_TYPE WHERE ProdTypeName = 'Window Treatments'))


SELECT * FROM tblPRODUCT

