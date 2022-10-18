CREATE PROCEDURE [dbo].[spRoomTypes_GetAvailableTypes]
	@startDate date,
	@endDate date
AS
begin
	set nocount on;

	SELECT t.Id, t.Title,t.Description,t.Price
	FROM dbo.Rooms r
	inner join dbo.RoomTypes t ON t.Id = r.RoomTypeId
	WHERE r.Id not in (
	SELECT b.RoomId
	FROM dbo.Bookings b
	WHERE (@startDate < b.StartDate and @endDate > b.EndDate) OR (b.StartDate <= @endDate and @endDate < b.EndDate ) OR (b.StartDate <= @startDate and @startDate < b.EndDate )
	)
	GROUP BY t.Id, t.Title,t.Description,t.Price

end
