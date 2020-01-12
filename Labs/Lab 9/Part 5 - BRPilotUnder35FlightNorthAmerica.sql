SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 9th June 2019
-- Description:	Function to enforce Business rule :
	/* Pilots under 35 years old cannot fly into North American airports more than 21 times in any given year." */
-- =============================================
CREATE FUNCTION fnCheckTotalNorthAmericaFlightsPilotsUnder35()
RETURNS INT
AS
BEGIN
	DECLARE @Ret INT = 0

	IF EXISTS(	SELECT COUNT(FE.FlightID) 
				FROM tblFLIGHT_EMPLOYEE FE
					JOIN tblEMPLOYEE E ON E.EmployeeID = FE.EmployeeID
					JOIN tblROLE R ON R.RoleID = FE.RoleID
					JOIN tblFLIGHT F ON F.FlightID = FE.FlightID
					JOIN tblAIRPORT A ON A.AirportID = F.ArrivalAirportID
					JOIN tblCITY C ON C.CityID = A.CityID
					JOIN tblCOUNTRY CNT ON CNT.CountryID = C.CountryID
					JOIN tblREGION R ON R.RegionID = CNT.RegionID
				WHERE R.RegionName = 'North America'
				AND R.RoleName = 'Pilot'
				AND E.EmployeeDOB > 365.26 * 35
				GROUP BY FE.EmployeeID
				HAVING COUNT(FE.FlightID) <= 21
			)
	BEGIN
		SET @Ret = 1
	END
	SET @Ret = 0

	RETURN @Ret
END
GO

ALTER TABLE tblFLIGHT_EMPLOYEE 
ADD CONSTRAINT ck_NoPilotAbove35FlyIntoNA
CHECK (fnCheckTotalNorthAmericaFlightsPilotsUnder35() = 0)

