USE [team14_home_decor_clone]
GO
/****** Object:  StoredProcedure [dbo].[uspProcessCart]    Script Date: 6/6/2019 10:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 1st May 2019
-- Description:	Stored Proc to push data from cart into Order and Line Item tables
-- =============================================
ALTER PROCEDURE [dbo].[uspProcessCart]
	@C_FN VARCHAR(50),
	@C_LN VARCHAR(50),
	@C_BD DATE,
	@Carr_Name varchar(50)
AS
	DECLARE @C_ID INT
	DECLARE @Carr_ID int
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC uspGetCustID
	@CustFname=@C_FN,
	@CustLname=@C_LN,
	@CustDOB=@C_BD,
	@CustID=@C_ID OUTPUT

	IF @C_ID IS NULL
	BEGIN
		PRINT 'Customer not found. Enter valid customer details'
		RAISERROR ('C_ID cannot be NULL',11,1)
		RETURN
	END

	EXEC uspGetCarrierID
	@CarrID = @Carr_ID OUTPUT,
	@CarrName = 'Fedex'

	IF @Carr_ID IS NULL
	BEGIN
		PRINT 'Carrier not found. Enter valid Carrier details'
		RAISERROR ('Carr_ID cannot be NULL',11,1)
		RETURN
	END

    ---------------------- Create temporary cart for aggregating quantities of each product ------------------------------------

	DECLARE @CART TABLE (
		TempCartID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
		ProdID INT NOT NULL,
		Qty INT NOT NULL)

	INSERT INTO @CART (ProdID,Qty)
	SELECT ProductID, SUM(Quantity) FROM tblCART --Sum up the quantity for each product if the product has been selected twice
	WHERE CustID=@C_ID GROUP BY ProductID --Will ensure that quants of repeated products are aggregated


	------------ Move items from @CART to tblSALES_ORDER -------------
	DECLARE @MinPK INT
	DECLARE @Count INT
	DECLARE @OrderID INT
	DECLARE @LineItemID INT

	SET @Count = (SELECT(COUNT (TempCartID)) FROM @CART)

	--Insert CustID into tblSALES_ORDER
	INSERT INTO tblSALES_ORDER(CustID, SalesOrderDate, SalesOrderTotal)
		VALUES (@C_ID, GETDATE(), 0)

	SET @OrderID = SCOPE_IDENTITY() --Get OrderID that was just inserted 

	--Iterate through @CART table to insert into line item
	WHILE @Count>0
	BEGIN
		SET @MINPK= (SELECT(MIN(TempCartID)) FROM @CART)

		--Insert the orderID into line_item table
		INSERT INTO tblLINE_ITEM1(SalesOrderID,ProductID,Quant)
		VALUES (@OrderID, (SELECT ProdID FROM @CART WHERE TempCartID=@MINPK), 
		(SELECT Qty FROM @CART WHERE TempCartID = @MINPK))

		SET @LineItemID = SCOPE_IDENTITY()

		--Create new shipment for that line item
		INSERT INTO tblSHIPMENT(CarrierID, SalesLineItemID)
		VALUES(@Carr_ID, @LineItemID)


		DELETE FROM @CART WHERE TempCartID=@MinPK
		SET @Count = @Count - 1
	END
	UPDATE tblSALES_ORDER SET SalesOrderTotal = (dbo.fnCalculateOrderTotal(SalesOrderID)) 
END

