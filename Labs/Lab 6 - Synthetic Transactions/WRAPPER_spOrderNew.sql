SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 20th May 2019
-- Description:	Wrapper Stored Proc for synthetic transaction to populate the order table
-- =============================================
CREATE PROCEDURE ashsrini_WRAPPER_spOrderNew
	-- Add the parameters for the stored procedure here
	@RUN int
AS
	DECLARE @F varchar(50)
	DECLARE @L varchar(50)
	DECLARE @BD Date
	DECLARE @P varchar(50)
	DECLARE @OD Date = (SELECT GetDate())
	DECLARE @Q INT

	DECLARE @CustPK INT = (SELECT COUNT(*) FROM dbo.tblCUSTOMER)
	DECLARE @ProdPK INT = (SELECT COUNT(*) FROM dbo.tblPRODUCT)

	DECLARE @Rand INT
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WHILE @RUN>0
	BEGIN
		SET @CustPK = (SELECT @CustPK * RAND())
		SET @ProdPK = (SELECT @ProdPK * RAND())
		IF @ProdPK < 1
		BEGIN
			SET @ProdPK = 2
		END
		SET @F = (SELECT CustFName FROM dbo.tblCUSTOMER WHERE CustID = @CustPK)
		SET @L = (SELECT CustLName FROM dbo.tblCUSTOMER WHERE CustID = @CustPK)
		SET @BD = (SELECT CustDOB FROM dbo.tblCUSTOMER WHERE CustID = @CustPK)

		SET @P = (SELECT ProductName from dbo.tblPRODUCT WHERE ProductID = @ProdPK)

		SET @Q = (SELECT 77 * RAND())

		EXEC dbo.spNewOrder
		@OrderDate = @OD,
		@CustFname = @F,
		@CustLname = @L,
		@CustDOB = @BD,
		@ProductName = @P,
		@Quant = @Q

		SET @RUN = @RUN -1
	END
END
GO
