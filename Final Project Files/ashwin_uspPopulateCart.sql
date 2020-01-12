USE [team14_home_decor_clone]
GO
/****** Object:  StoredProcedure [dbo].[uspPopulateCart]    Script Date: 6/6/2019 10:29:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		AS
-- Create date: <Create Date,,>
-- Description:	Stored Procedure to populate cart
-- =============================================
ALTER PROCEDURE [dbo].[uspPopulateCart] 
	-- Add the parameters for the stored procedure here
	@CT_Cust_FN VARCHAR(50),
	@CT_Cust_LN VARCHAR(50),
	@CT_Cust_BD DATE,
	@CT_Prod_Name VARCHAR (50),
	@CT_Quantity INT,
	@CT_Date DATE
AS
	DECLARE @CT_Cust_ID INT
	DECLARE @CT_Prod_ID INT

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXECUTE uspGetCustID
	@CustFname = @CT_Cust_FN,
	@CustLname = @CT_Cust_LN,
	@CustDOB = @CT_Cust_BD,
	@CustID = @CT_Cust_ID OUTPUT

	IF @CT_Cust_ID IS NULL
	BEGIN
		PRINT 'Customer not found. Please enter valid Customer Details.'
		RAISERROR ('Cust_ID cannot be NULL', 11,1)
		RETURN
	END


	EXECUTE uspGetProductID
	@ProdName = @CT_Prod_Name,
	@ProdID = @CT_Prod_ID OUTPUT

	IF @CT_Prod_ID IS NULL
	BEGIN
		PRINT 'Product not found. Enter valid product details.'
		RAISERROR ('Prod_ID cannot be null',11,1)
		RETURN
	END

------------------ INSERT VALUE INTO tblCART --------------------------

	BEGIN TRAN G1
		INSERT INTO tblCART (CustID, ProductID, Quantity, CartDate)
		VALUES (@CT_Cust_ID, @CT_Prod_ID, @CT_Quantity, @CT_Date)

	IF @@ERROR <> 0
		ROLLBACK TRAN G1
	ELSE
		COMMIT TRAN G1
	
END

