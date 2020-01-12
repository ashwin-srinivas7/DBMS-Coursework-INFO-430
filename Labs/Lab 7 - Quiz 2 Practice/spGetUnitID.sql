SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spGetUnitID 
	-- Add the parameters for the stored procedure here
	@UnitName varchar(50),
	@UnitID int OUTPUT
AS
BEGIN
	SET @UnitID = (SELECT UnitID FROM tblUnit WHERE UnitName = @UnitName)
END
GO
