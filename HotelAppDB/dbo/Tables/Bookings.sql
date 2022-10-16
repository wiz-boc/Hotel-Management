CREATE TABLE [dbo].[Bookings]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [RoomId] INT NOT NULL, 
    [GuestId] INT NOT NULL, 
    [StartDate] DATETIME NOT NULL, 
    [EndDate] DATETIME NOT NULL, 
    [CheckIn] BIT NOT NULL DEFAULT 0, 
    [TotalCost] MONEY NOT NULL, 
    CONSTRAINT [FK_Bookings_Rooms] FOREIGN KEY ([RoomId]) REFERENCES [Rooms]([Id]),
    CONSTRAINT [FK_Bookings_Guests] FOREIGN KEY ([GuestId]) REFERENCES [Guests]([Id])
)
