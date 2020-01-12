SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 9th June 2019
-- Description:	Function to calculate total booking for each customer
-- =============================================
CREATE FUNCTION fnCalcTotalBookingsPerCustomer(@CustID int)
RETURNS INT
AS
BEGIN
	DECLARE @Ret INT = (SELECT count(BookingID) 
						FROM tblBOOKING
						WHERE CustomerID = @CustID
						GROUP BY CustomerID)
	RETURN @Ret 
END
GO


ALTER TABLE tblCUSTOMER
ADD TotalBookings AS dbo.fnCalcTotalBookingsPerCustomer(CustomerID)

