USE [team14_home_decor_clone]
GO
/****** Object:  StoredProcedure [dbo].[uspGetShipmentID]    Script Date: 6/6/2019 11:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[uspGetShipmentID]
	@ShipID INT OUTPUT,
	@ShipDate DATE,
	@CarrID INT
AS
BEGIN
SET @ShipID = (SELECT ShipmentID FROM tblSHIPMENT WHERE CarrierID=@CarrID AND ShipmentDate=@ShipDate)
END