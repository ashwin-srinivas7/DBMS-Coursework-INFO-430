SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 20th May 2019
-- Description:	Stored Procedure to get ProductID from ProductName
-- =============================================
CREATE PROCEDURE spGetProdID
	-- Add the parameters for the stored procedure here
	@ProdName Varchar(50),
	@ProdId INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @ProdId = (	SELECT ProductID
					FROM dbo.tblPRODUCT 
					WHERE ProductName = @ProdName )
END
GO
