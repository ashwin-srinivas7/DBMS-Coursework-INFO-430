USE [team14_home_decor_clone]
GO
/****** Object:  StoredProcedure [dbo].[uspGetCustID]    Script Date: 6/6/2019 11:04:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 1st May 2019
-- Description:	stored procedure to get Customer ID from customer details
-- =============================================
ALTER PROCEDURE [dbo].[uspGetCustID] 
	@CustFname varchar(50),
	@CustLname varchar(50),
	@CustDOB date,
	@CustID int output

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @CustID = (SELECT CustID FROM tblCUSTOMER WHERE CustFname=@CustFname AND CustLname = @CustLname AND CustDOB = @CustDOB)
END
