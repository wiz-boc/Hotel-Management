/*
Deployment script for HotelAppDB

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "HotelAppDB"
:setvar DefaultFilePrefix "HotelAppDB"
:setvar DefaultDataPath "C:\Users\kenroyg\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"
:setvar DefaultLogPath "C:\Users\kenroyg\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Creating Procedure [dbo].[spBookings_CheckIn]...';


GO
CREATE PROCEDURE [dbo].[spBookings_CheckIn]
	@Id int
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.Bookings 
	SET CheckIn = 1 
	WHERE Id = @Id 
END
GO
PRINT N'Creating Procedure [dbo].[spBookings_Insert]...';


GO
CREATE PROCEDURE [dbo].[spBookings_Insert]
	@roomId int,
	@guestId int,
	@startDate date,
	@endDate date,
	@totalCost money
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.Bookings(RoomId, GuestId, StartDate, EndDate, TotalCost)
	VALUES(@roomId,@guestId,@startDate,@endDate,@totalCost)
END
GO
PRINT N'Creating Procedure [dbo].[spBookings_Search]...';


GO
CREATE PROCEDURE [dbo].[spBookings_Search]
	@lastName nvarchar(50),
	@startDate date
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT [b].[Id], [b].[RoomId], [b].[GuestId], [b].[StartDate], [b].[EndDate], [b].[CheckIn], [b].[TotalCost], 
		[g].[FirstName], [g].[LastName], 
		[r].[RoomNumber], [r].[RoomTypeId], 
		[rt].[Title], [rt].[Description], [rt].[Price]
	FROM dbo.Bookings b
	INNER JOIN dbo.Guests g ON b.GuestId = g.Id
	INNER JOIN dbo.Rooms r on b.RoomId = r.Id
	INNER JOIN dbo.RoomTypes rt on rt.Id = r.RoomTypeId
	WHERE b.StartDate = @startDate AND g.LastName = @lastName

END
GO
PRINT N'Creating Procedure [dbo].[spGuests_Insert]...';


GO
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
GO
PRINT N'Creating Procedure [dbo].[spRooms_GetAvailableRooms]...';


GO
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
GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

if not exists(select 1 from dbo.RoomTypes)
begin
    insert into dbo.RoomTypes(Title, Description, Price)
    values('King Size Bed','A room with a king-size bed and a window.',100),
    ('Two Queen Size Beds','A room with two queen-size beds and a window.',115),
    ('Executive Suite','Two rooms, each with a king size bed and a window.',205)
end


if not exists(select 1 from dbo.Rooms)
begin

declare @roomId1 int;
declare @roomId2 int;
declare @roomId3 int;

select @roomId1 = Id from dbo.RoomTypes where Title = 'King Size Bed'
select @roomId2 = Id from dbo.RoomTypes where Title = 'Two Queen Size Beds'
select @roomId3 = Id from dbo.RoomTypes where Title = 'Executive Suite'

insert into dbo.Rooms(RoomNumber,RoomTypeId)
values('001',@roomId1),
('002',@roomId2),
('003',@roomId2),
('004',@roomId3),
('101',@roomId3),
('102',@roomId3),
('204',@roomId1)
end
GO

GO
PRINT N'Update complete.';


GO
