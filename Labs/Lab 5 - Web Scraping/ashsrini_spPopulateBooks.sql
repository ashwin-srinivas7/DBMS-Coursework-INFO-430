SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ashwin Srinivas
-- Create date: 10th May 2019
-- Description:	Stored procedure to populate tblBook and tblGenre
-- =============================================
CREATE PROCEDURE spPopulateBooks2 
	-- Add the parameters for the stored procedure here
	@bookTitle VARCHAR(256),
	@bookPrice SMALLMONEY,
	@bookDesc VARCHAR(4096),
	@genreName VARCHAR(256)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--Check for errors in the inputs
	IF @bookTitle IS NULL
	BEGIN
	PRINT 'BookTitle is NULL and the following transaction will fail'
	RAISERROR ('@bookTitle cannot be NULL', 11, 1)
	RETURN
	END 

	IF @bookPrice IS NULL
	BEGIN
	PRINT '@bookPrice is NULL and the following transaction will fail'
	RAISERROR ('@bookPrice cannot be NULL', 11, 1)
	RETURN
	END

	IF @bookDesc IS NULL
	BEGIN
	PRINT '@bookDesc is NULL and the following transaction will fail'
	RAISERROR ('@bookDesc cannot be NULL', 11, 1)
	RETURN
	END

	IF @genreName IS NULL
	BEGIN
	PRINT '@genreName is NULL and the following transaction will fail'
	RAISERROR ('@genreName cannot be NULL', 11, 1)
	RETURN
	END

	--If new genre name is inputted, add it to the genre table and return the ID of that row
	DECLARE @genreID int
	IF NOT EXISTS (select 1 from dbo.tblGenre where genreName = @genreName)
	BEGIN
		insert into tblGenre(genreName) values (@genreName)
		set @genreID = (SELECT SCOPE_IDENTITY())
	END
	--Else get genreID from tblGenre
	ELSE
	BEGIN
		set @genreID = (Select genreID from tblGenre where genreName = @genreName)
	END

	IF @genreID IS NULL
	BEGIN
	PRINT '@genreID is NULL and the following transaction will fail'
	RAISERROR ('The @genreID returned by the stored procedure was NULL. Transaction Failed!', 11, 1)
	RETURN
	END

	--Insert the final value into tblBook
	BEGIN TRAN G1
		Insert into tblBook(bookTitle,bookPrice,bookDesc,genreID)
		values (@bookTitle,@bookPrice,@bookDesc,@genreID)
		IF @@ERROR <>0
			ROLLBACK TRAN G1
		ELSE
			COMMIT TRAN G1
END