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
-- Create date: 12th Apr 2019
-- Description: Stored Procedure to populate the Order table
-- =============================================
CREATE PROCEDURE spPopulateOrders 
	-- Add the parameters for the stored procedure here
	@CustFname varchar(255),
	@CustLname varchar(255),
	@ProdName varchar(255),
	@EmpFname varchar(255),
	@EmpLname varchar(255),
	@Quantity int

-- Declare all local variables to get IDs
AS
DECLARE @CustID int
DECLARE @ProdID int
DECLARE @EmpID int

-- Get ID from the entered Name
SET @CustID = (SELECT CustID from tblCUSTOMER WHERE CustFname = @CustFname AND CustLname = @CustLname)
-- Check if valid ID was returned
IF @CustID IS NULL
BEGIN
	PRINT 'Customer not found in DB. Customer ID Null was returned';
	RAISERROR ('Cannot process order without real customer', 11, 1)   --Level 1, state 1. System error message
	RETURN
END

-- Get ID from the entered Name
SET @ProdID = (SELECT ProdID from tblPRODUCT WHERE ProdName = @ProdName)
-- Check if valid ID was returned
IF @ProdID IS NULL
BEGIN
	PRINT 'Product not found in DB. Product ID NULL was returned';
	RAISERROR ('Cannot process order without real product', 11, 1)   --Level 1, state 1. System error message
	RETURN
END

-- Get ID from the entered Name
SET @EmpID = (SELECT EmpID from tblEMPLOYEE WHERE EmpFname = @EmpFname AND EmpLname = @EmpLname)
-- Check if valid ID was returned
IF @EmpID IS NULL
BEGIN
	PRINT 'Employee not found in DB. Employee ID NULL was returned';
	RAISERROR ('Cannot process order without real Employee', 11, 1)   --Level 1, state 1. System error message
	RETURN
END

-- Insert the values
BEGIN TRAN G1
	INSERT INTO tblOrder (OrderDate, CustID, ProductID, EmpID, Quantity)
	VALUES (GETDATE(), @CustID, @ProdID, @EmpID, @Quantity)
	IF @@ERROR <>0
		ROLLBACK TRAN G1
	ELSE
		COMMIT TRAN G1