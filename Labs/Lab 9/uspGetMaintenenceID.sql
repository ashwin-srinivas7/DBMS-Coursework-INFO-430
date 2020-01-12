SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 5th June 2019
-- Description:	Stored Procedure to get MaintenanceID from MaintenanceName
-- =============================================
CREATE PROCEDURE uspGetMaintenanceID
	-- Add the parameters for the stored procedure here
	@MainName varchar(30),
	@MainID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @MainID = (SELECT MaintenanceID FROM tblMAINTENANCE WHERE MaintenanceName = @MainName)
END
GO
