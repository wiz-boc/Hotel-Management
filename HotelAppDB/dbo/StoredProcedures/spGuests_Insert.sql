CREATE PROCEDURE [dbo].[spGuests_Insert]
	@firstName nvarchar(50),
	@lastName nvarchar(50)
AS
BEGIN
	set nocount on;

	IF not exists (SELECT 1 FROM dbo.Guests WHERE FirstName = @firstName AND LastName = @lastName)
	BEGIN
		INSERT INTO dbo.Guests(FirstName,LastName)
		VALUES(@firstName,@lastName)
	END

	SELECT top 1 [Id], [FirstName], [LastName]
	FROM dbo.Guests 
	WHERE FirstName = @firstName AND LastName = @lastName

END