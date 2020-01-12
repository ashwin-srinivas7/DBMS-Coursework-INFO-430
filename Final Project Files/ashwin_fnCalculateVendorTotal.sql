USE [team14_home_decor_clone]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCalculateVendorAmountTotal]    Script Date: 6/6/2019 11:05:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
ALTER FUNCTION [dbo].[fnCalculateVendorAmountTotal] (@InvoiceID INT)
RETURNS NUMERIC(10, 2)
AS
BEGIN
	DECLARE @Ret NUMERIC(10,2) = (SELECT P.Price * I.Quantity
								FROM tblPRODUCT P JOIN tblINVOICE I
								ON P.ProductID = I.ProductID
								WHERE I.InvoiceID = @InvoiceID)
	RETURN @Ret
END

