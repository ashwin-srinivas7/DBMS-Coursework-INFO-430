-- Check the tables in schema
USE ashsrini_Lab3 --Get all the tables in the partiular schema
GO
SELECT * FROM INFORMATION_SCHEMA.TABLES


-------------------------------------------------------------------------------------------------------------------
--Import data from the excel file:
Select * from dbo.RAW_PetData
 --Here we can see that last few rows are NULL. So we will copy all the non null rows to another table

 --copy all non-numm rows to a new table
select * into tblNew_PetData
from RAW_PetData where PET_TYPE IS NOT NULL

--Next step is to add a primary key to the Pets table.
CREATE TABLE [dbo].[tblWorking_PetData](
	[PK_ID] int IDENTITY(1,1) Primary Key,
	[PETNAME] [nvarchar](255) NULL,
	[PET_TYPE] [nvarchar](255) NULL,
	[TEMPERAMENT] [nvarchar](255) NULL,
	[COUNTRY] [nvarchar](255) NULL,
	[DATE_BIRTH] [datetime] NULL,
	[GENDER] [nvarchar](255) NULL
)

--Populate the above table from the prev table
INSERT INTO [dbo].[tblWorking_PetData] ([PETNAME], [PET_TYPE], [TEMPERAMENT], [COUNTRY], [DATE_BIRTH], [GENDER])
SELECT [PETNAME], [PET_TYPE], [TEMPERAMENT], [COUNTRY], [DATE_BIRTH], [GENDER]
FROM tblNew_PetData

Select * from tblWorking_PetData

--------------------------------------------------------------------------------------------
-- 3) Create the tables:
--Create the PET Table

CREATE TABLE tblPET (
    PetID int NOT NULL IDENTITY(0001, 1),
    PetName varchar(255) NOT NULL,
    PetTypeID int,
    CountryID int,
	TempID int,
	DOB date,
	GenderID int,
    PRIMARY KEY (PetID)
)

--Create the PET_TYPE Table
CREATE TABLE tblPET_TYPE (
    PetTypeID int NOT NULL IDENTITY(0001, 1),
    PetTypeName varchar(50),
	PRIMARY KEY (PetTypeID)
)

--Create the COUNTRY Table
CREATE TABLE tblCOUNTRY (
	CountryID int NOT NULL IDENTITY(1,1),
	CountryName varchar(70),
	PRIMARY KEY (CountryID)
)

--Create the TEMPERAMANT Table
CREATE TABLE tblTEMPERAMENT (
	TempID int NOT NULL IDENTITY(1,1),
	TempName varchar(70),
	PRIMARY KEY (TempID)
)

--Create the GENDER Table

CREATE TABLE tblGENDER (
	GenderID int NOT NULL IDENTITY(1,1),
	GenderName varchar(40),
	PRIMARY KEY (GenderID)
)

--10) Populate the look-up tables
SELECT top 10 * from tblWorking_PetData

--Populate tblCOUNTRY 
SELECT top 10 * from tblCOUNTRY

INSERT INTO tblCOUNTRY (CountryName) SELECT Distinct(COUNTRY) FROM tblWorking_PetData

--Populate tblPET_TYPE
SELECT * FROM tblPET_TYPE
INSERT INTO tblPET_TYPE (PetTypeName) SELECT Distinct(PET_TYPE) FROM tblWorking_PetData

--Populate tblTEMPERAMENT
SELECT * FROM tblTEMPERAMENT
INSERT INTO tblTEMPERAMENT (TempName) SELECT DIstinct(TEMPERAMENT) FROM tblWorking_PetData

--Populate tblGender
SELECT * FROM tblPET_TYPE
INSERT INTO tblGENDER (GenderName) SELECT DISTINCT(GENDER) FROM tblWorking_PetData

SELECT * FROM tblWorking_PetData

---Get table structure for a given table
select *
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='tblPet'

-- 12) Populate the PET Table
DECLARE @RUN  INT
DECLARE @MIN_PK INT

SET @RUN = (SELECT COUNT(*) FROM tblWorking_PetData)

WHILE @RUN > 0
BEGIN 
SET @MIN_PK = (SELECT MIN(PK_ID) FROM tblWorking_PetData)

DECLARE @TypeName_WorkingData varchar (50), 
		@CountryName_WorkingData varchar(50), 
		@TempName_WorkingData varchar(50), 
		@GenderName_WorkingData varchar(50), 
		@PetName_WorkingData varchar(255),
		@DOB_WorkingData date

------------------- Get the values from the working Pets table and store it in variables. Will pass this into the outer SP
SET @TypeName_WorkingData = (SELECT PET_TYPE FROM tblWorking_PetData WHERE PK_ID = @MIN_PK)
SET @CountryName_WorkingData = (SELECT COUNTRY FROM tblWorking_PetData WHERE PK_ID = @MIN_PK)
SET @TempName_WorkingData = (SELECT TEMPERAMENT FROM tblWorking_PetData WHERE PK_ID = @MIN_PK)
SET @GenderName_WorkingData = (SELECT GENDER FROM tblWorking_PetData WHERE PK_ID = @MIN_PK)
SET @PetName_WorkingData = (SELECT PETNAME FROM tblWorking_PetData WHERE PK_ID = @MIN_PK)
SET @DOB_WorkingData = (SELECT DATE_BIRTH FROM tblWorking_PetData WHERE PK_ID = @MIN_PK)

--Call the OUTER STORED PROC
EXEC spPopulatePets
	@TypeName = @TypeName_WorkingData,
	@CountryName = @CountryName_WorkingData,
	@TempName = @TempName_WorkingData,
	@GenderName = @GenderName_WorkingData,
	@PetName = @PetName_WorkingData,
	@DOB = @DOB_WorkingData


DELETE FROM tblWorking_PetData WHERE PK_ID = @MIN_PK
SET @RUN = @RUN -1
END

----------------------------------END OF ASSIGNMENT--------------------------------------
SELECT * from tblPET
SELECT * FROM tblWorking_PetData


