SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 20th May 2019
-- Description:	Stopred Proc to get the CustomerID given the first, last name and DOB
-- =============================================
CREATE PROCEDURE spGetCustID 
	-- Add the parameters for the stored procedure here
	@CustFirstname varchar(50),
	@CustLastname varchar(50),
	@CustBirtDate Date,
	@CustomerID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @CustomerID = (SELECT CustID FROM dbo.tblCUSTOMER
						WHERE CustFName = @CustFirstname AND 
						CustLName = @CustLastname AND
						CustDOB = @CustBirtDate)
END
GO
