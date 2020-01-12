USE [team14_home_decor_clone]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCalculateOrderTotal]    Script Date: 6/6/2019 11:06:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		ASHWIN SRINIVAS
-- Create date: 3rd May 2019
-- Description:	Function to calculate SalesOrderTotal column in tblSALES_ORDER
-- =============================================
ALTER FUNCTION [dbo].[fnCalculateOrderTotal](@OrderID INT)
RETURNS DECIMAL
AS
BEGIN
	DECLARE @Ret DECIMAL = (SELECT SUM(L.PriceExtended)
								FROM tblSALES_ORDER O JOIN tblLINE_ITEM1 L
								ON O.SalesOrderID = L.SalesOrderID
								WHERE L.SalesOrderID = @OrderID
								GROUP BY O.SalesOrderID)
	RETURN @Ret
END

