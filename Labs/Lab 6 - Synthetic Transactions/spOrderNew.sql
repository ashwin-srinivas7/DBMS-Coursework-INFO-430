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
-- Create date: 20th May 2019
-- Description:	Stored procedure to populate tblORDER
-- =============================================
CREATE PROCEDURE spNewOrder 
	-- Add the parameters for the stored procedure here
	@OrderDate date,
	@CustFname varchar(50),
	@CustLname varchar(50),
	@CustDOB date,
	@ProductName varchar(200),
	@Quant int
AS
DECLARE @CustID int,
		@ProductID int
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--First get CustID
	EXEC dbo.spGetCustID
	@CustFirstname = @CustFname,
	@CustLastname = @CustLname,
	@CustBirtDate = @CustDOB,
	@CustomerID = @CustID OUTPUT
	
	-- Exception handling for CustomerID
	IF @CustID IS NULL
	BEGIN
		RAISERROR('CustomerID returned was null. Please enter valid Customer details. Transaction Failed!',11,1)
		RETURN
	END

	--Next get ProdID
	EXEC dbo.spGetProdID
	@ProdName = @ProductName,
	@ProdId = @ProductID OUTPUT

	-- Exception handling for CustomerID
	IF @ProductID IS NULL
	BEGIN
		RAISERROR('ProductID returned was null. Please enter valid Product details. Transaction Failed!',11,1)
		RETURN
	END

	-- Execute Transaction
	BEGIN TRAN G1
		INSERT INTO dbo.tblORDER(OrderDate, CustID, ProductID, Quantity)
		VALUES(@OrderDate, @CustID, @ProductID, @Quant)

		IF @@ERROR <> 0
			ROLLBACK TRAN G1
		ELSE 
			COMMIT TRAN G1


END
GO
