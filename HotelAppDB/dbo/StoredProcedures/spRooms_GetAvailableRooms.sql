CREATE PROCEDURE [dbo].[spRooms_GetAvailableRooms]
	@startDate date,
	@endDate date,
	@roomTypeId int
AS
BEGIN

SET NOCOUNT ON;

SELECT r.*
	FROM dbo.Rooms r
	inner join dbo.RoomTypes t ON t.Id = r.RoomTypeId
	WHERE r.RoomTypeId = @roomTypeId 
	AND r.Id not in (
	SELECT b.RoomId
	FROM dbo.Bookings b
	WHERE (@startDate < b.StartDate and @endDate > b.EndDate) OR (b.StartDate <= @endDate and @endDate < b.EndDate ) OR (b.StartDate <= @startDate and @startDate < b.EndDate )
	)

END
