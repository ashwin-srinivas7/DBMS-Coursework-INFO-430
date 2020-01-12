SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 9th June 2019
-- Description:	Function to enforce Business rule: "No employee younger than 21 may be scheduled on a flight as crew chief"
-- =============================================
CREATE FUNCTION fnCheckFlightCrewChiefAge()
RETURNS INT
AS
BEGIN
	DECLARE @Ret INT = 0

	IF EXISTS(	SELECT * 
				FROM tblFLIGHT_EMPLOYEE FE
				JOIN tblEMPLOYEE E ON E.EmployeeID = FE.EmployeeID
				JOIN tblROLE R ON R.RoleID = FE.RoleID
				WHERE FE.RoleName = 'Crew Chief'
				AND E.EmployeeDOB < 365.25 *21)
	BEGIN
		SET @Ret = 1
	END
	SET @Ret = 0
	RETURN @Ret

END
GO

ALTER TABLE tblFLIGHT_EMPLOYEE 
ADD CONSTRAINT ck_NoUnderAgeCrewChief
CHECK (fnCheckFlightCrewChiefAge() = 0)