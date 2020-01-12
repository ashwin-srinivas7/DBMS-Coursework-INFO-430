USE [team14_home_decor_clone]
GO
/****** Object:  StoredProcedure [dbo].[uspPopulateInvoice]    Script Date: 6/6/2019 10:16:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		ASHWIN SRINIVAS
-- Create date: 3rd May 2019
-- Description:	 Stored proc to populate the invoice table
-- =============================================
ALTER PROCEDURE [dbo].[uspPopulateInvoice]
	@VName varchar(50),
	@PName varchar(50),
	@Qty int
AS
	DECLARE @V_ID int
	DECLARE @P_ID int
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	---- Check constraint for quantity ------------
	PRINT 'Checking if the quantity > 100..'
	IF @Qty<100
	BEGIN
		PRINT 'Quantity must be greater than 100'
		RAISERROR ('Quantity Constraint Failed',11,1)
		RETURN
	END

	PRINT 'Quantity VALID'
	EXEC uspGetVendorID
	@VendorName = @VName,
	@VendorID = @V_ID output

	IF @V_ID IS NULL
	BEGIN
		PRINT 'VendorID was returned as NULL. Please enter valid vendor details'
		RAISERROR ('VendorID cannot be NULL',11,1)
		RETURN
	END

	EXEC uspGetProductID
	@ProdName = @PName,
	@ProdID = @P_ID Output

	IF @P_ID IS NULL
	BEGIN
		PRINT 'ProductID was returned as NULL. Please enter valid product details'
		RAISERROR ('ProductID cannot be NULL',11,1)
		RETURN
	END

	BEGIN TRAN G1
	INSERT INTO tblINVOICE(VendorID, ProductID, Quantity)
	VALUES (@V_ID,@P_ID,@Qty)

	IF @@ERROR <> 0
		ROLLBACK TRAN G1
	ELSE 
		COMMIT TRAN G1
END