SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spGetStudentID
	-- Add the parameters for the stored procedure here
	@StudentFname varchar(50),
	@StudentLname varchar(50),
	@StudentDOB date,
	@StudentID int OUTPUT
AS
BEGIN
	SET @StudentID = (SELECT StudentID FROM tblStudent 
						WHERE StudentFName = @StudentFname AND
						StudentLName = @StudentLname AND
						StudentDOB = @StudentDOB)
END
GO
