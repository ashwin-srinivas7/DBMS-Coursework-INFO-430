USE [team14_home_decor_clone]
GO
/****** Object:  StoredProcedure [dbo].[uspGetProductID]    Script Date: 6/6/2019 11:05:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 1st May 2019
-- Description:	Store Proc to get productID from ProductName
-- =============================================
ALTER PROCEDURE [dbo].[uspGetProductID] 
	@ProdName varchar(50),
	@ProdID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @ProdID = (SELECT ProductID FROM tblPRODUCT WHERE ProductName = @ProdName)
    
END
