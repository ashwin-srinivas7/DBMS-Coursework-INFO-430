-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 19th Apr 2019
-- Description:	Stored Procedures to populate the PET table with ID values (FKs)
-- =============================================
CREATE PROCEDURE spGetTypeID   --Define the GetID SP for Pet Type ID
	@Tname varchar(50),
	@T_ID INT OUTPUT
AS
BEGIN
	SET @T_ID = (SELECT PetTypeID from tblPET_TYPE where PetTypeName = @Tname)
END
GO

CREATE PROCEDURE spGetCountryID  --Define the GetID SP for Country ID
	@CName varchar(50),
	@C_ID INT OUTPUT
AS
BEGIN
	SET @C_ID = (SELECT CountryID from tblCOUNTRY WHERE CountryName = @CName)
END 
GO

CREATE PROC spGetTempID --Define the getID SP for Temperament ID
	@TName varchar(50),
	@Temp_ID INT OUTPUT
AS
BEGIN
	SET @Temp_ID = (SELECT TempID from tblTEMPERAMENT WHERE TempName = @TName)
END
GO

CREATE PROC spGetGenderID --Define the GetID SP for Gender ID
	@GName varchar(50),
	@G_ID INT OUTPUT
AS
BEGIN
	SET @G_ID = (SELECT GenderID from tblGENDER WHERE GenderName = @GName)
END
GO

-----------------OUTER STORED PROCEDURE DEFINITION ---------------------------
CREATE PROCEDURE spPopulatePets 
	-- Add the parameters for the stored procedure here. These are all the names that are being passed in from the modified table
	@TypeName varchar(50),
	@CountryName varchar(50),
	@TempName varchar(50),
	@GenderName varchar(50),
	@PetName varchar(255),
	@DOB date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--Initialize all corrosponding IDs. These IDs will be fetched from names passed in above
	DECLARE @PetTypeID INT
	DECLARE @CountryID INT
	DECLARE @TempID INT
	DECLARE @GenderID INT
	
	--SP for getting the Pet Type ID
	EXEC spGetTypeID 
	@Tname = @TypeName,  --Input
	@T_ID = @PetTypeID OUTPUT
	
	IF @PetTypeID IS NULL
	BEGIN
	PRINT '@PetType is NULL and the following transaction will fail'
	RAISERROR ('@PetTypeID cannot be NULL', 11, 1)
	RETURN
	END

	--SP for getting the Country ID
	EXEC spGetCountryID
	@CName = @CountryName,
	@C_ID = @CountryID OUTPUT

	IF @CountryID IS NULL
	BEGIN
	PRINT '@CountryID is NULL and the following transaction will fail'
	RAISERROR ('@CountryID cannot be NULL', 11, 1)
	RETURN
	END

	--SP for getting Temperament ID
	EXEC spGetTempID
	@TName = @TempName,
	@Temp_ID = @TempID OUTPUT

	IF @TempID IS NULL
	BEGIN
	PRINT '@TempID is NULL and the following transaction will fail'
	RAISERROR ('@TempID cannot be NULL', 11, 1)
	RETURN
	END


	--SP for getting Gender ID
	EXEC spGetGenderID
	@GName = @GenderName,
	@G_ID = @GenderID OUTPUT

	IF @GenderID IS NULL
	BEGIN
	PRINT '@GenderID is NULL and the following transaction will fail'
	RAISERROR ('@GenderID cannot be NULL', 11, 1)
	RETURN
	END

	--------------------- Once we get all ID's, its time to insert them into the new table

	BEGIN TRAN G1
	INSERT INTO tblPET(PetName, PetTypeID, CountryID, TempID, DOB, GenderID)
	VALUES (@PetName,@PetTypeID,@CountryID,@TempID,@DOB,@GenderID)
	-- check if there is a train-wreck ahead --> 
	IF @@ERROR <> 0 
	ROLLBACK TRAN G1
	ELSE 
	COMMIT TRAN G1
    
END
GO
