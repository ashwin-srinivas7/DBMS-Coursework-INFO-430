SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 6th June 2019
-- Description:	Stored proc to populate tblFLIGHT_MAINTENANCE
-- =============================================
CREATE PROCEDURE uspPopulateFlightMaintenance
	-- Add the parameters for the stored procedure here
	@FlName varchar(30),
	@MName varchar(30),
	@BeginTime time,
	@EndTime time
AS
	DECLARE @FlID int, @MID int
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC uspGetFlightID
	@FltName = @FlName,
	@FltID = @FlID OUTPUT

	IF(@FlID IS NULL)
	BEGIN 
		PRINT 'Flight details incorrect. Please enter valid flight name.'
		RAISERROR('FlightID Null error',11,1)
		RETURN
	END

	EXEC uspGetMaintenanceID
	@MainName = @MName,
	@MainID = @MID OUTPUT

	IF(@MID IS NULL)
	BEGIN 
		PRINT 'Maintenance details incorrect. Please enter valid maintenance name.'
		RAISERROR('MaintenanceID Null error',11,1)
		RETURN
	END

	BEGIN TRAN G1
	INSERT INTO tblFLIGHT_MAINTENANCE(FlightID, MaintenanceID, FlightMainBeginTime, FlightMainEndTIme)
	VALUES (@FlID, @MID, @BeginTime, @EndTime)


END
GO
