CREATE PROCEDURE [dbo].[spRoomtypes_GetById]
	@id int
AS
BEGIN
set nocount on;

SELECT [Id], [Title], [Description], [Price] 
FROM dbo.RoomTypes
WHERE ID =  @id

END
