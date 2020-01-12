USE [team14_home_decor_clone]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCalcLineItemTotal]    Script Date: 6/6/2019 11:06:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		ASHWIN SRINIVAS
-- Create date: 3rd May 2019
-- Description:	Function to compute PriceExtended column in tblSALES_LINE_ITEM
-- =============================================
-- Computed Columns
ALTER FUNCTION [dbo].[fnCalcLineItemTotal] (@LineItemID INT)
RETURNS NUMERIC(10, 2)
AS
BEGIN
	DECLARE @Ret NUMERIC(10,2) = (SELECT P.Price * LI.Quant
								FROM tblPRODUCT P JOIN tblLINE_ITEM1 LI
								ON P.ProductID = LI.ProductID
								WHERE LI.SalesLineItemID = @LineItemID)
	RETURN @Ret
END

