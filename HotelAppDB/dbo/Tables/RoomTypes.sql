CREATE TABLE [dbo].[RoomTypes]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY,
	[Title] varchar(50) NOT NULL,
	[Description] varchar(200) NOT NULL,
	[Price] money NOT NULL,
)
