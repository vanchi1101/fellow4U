IF DB_ID('fellow_db') IS NULL
BEGIN
    CREATE DATABASE fellow_db;
END
GO

USE fellow_db;
GO

IF OBJECT_ID('dbo.Notifications', 'U') IS NOT NULL DROP TABLE dbo.Notifications;
IF OBJECT_ID('dbo.Chats', 'U') IS NOT NULL DROP TABLE dbo.Chats;
IF OBJECT_ID('dbo.Trips', 'U') IS NOT NULL DROP TABLE dbo.Trips;
IF OBJECT_ID('dbo.FeaturedTours', 'U') IS NOT NULL DROP TABLE dbo.FeaturedTours;
IF OBJECT_ID('dbo.Experiences', 'U') IS NOT NULL DROP TABLE dbo.Experiences;
IF OBJECT_ID('dbo.Guides', 'U') IS NOT NULL DROP TABLE dbo.Guides;
IF OBJECT_ID('dbo.Journeys', 'U') IS NOT NULL DROP TABLE dbo.Journeys;
IF OBJECT_ID('dbo.ProfilePhotos', 'U') IS NOT NULL DROP TABLE dbo.ProfilePhotos;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
GO

CREATE TABLE dbo.Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    [Password] NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('traveller', 'guide')),
    Country NVARCHAR(100) NOT NULL DEFAULT 'Vietnam',
    AvatarImage NVARCHAR(255) NOT NULL DEFAULT 'assets/profile/profile2.png',
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE dbo.ProfilePhotos (
    PhotoId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES dbo.Users(UserId) ON DELETE CASCADE,
    ImagePath NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE dbo.Journeys (
    JourneyId INT IDENTITY(1,1) PRIMARY KEY,
    JourneyLocation NVARCHAR(150) NOT NULL,
    JourneyImage NVARCHAR(255) NOT NULL,
    JourneySetoffDate DATE NOT NULL,
    JourneyWithin NVARCHAR(50) NOT NULL,
    JourneyPrice INT NOT NULL
);
GO

CREATE TABLE dbo.Guides (
    GuideId INT IDENTITY(1,1) PRIMARY KEY,
    NameGuide NVARCHAR(150) NOT NULL,
    ImageGuide NVARCHAR(255) NOT NULL,
    LocationGuide NVARCHAR(150) NOT NULL,
    Rating DECIMAL(3,1) NOT NULL,
    Reviews INT NOT NULL
);
GO

CREATE TABLE dbo.Experiences (
    ExperienceId INT IDENTITY(1,1) PRIMARY KEY,
    ExperienceDescription NVARCHAR(255) NOT NULL,
    ExperienceImage NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE dbo.FeaturedTours (
    TourId INT IDENTITY(1,1) PRIMARY KEY,
    TourName NVARCHAR(150) NOT NULL,
    TourImage NVARCHAR(255) NOT NULL,
    TourSetoffDate DATE NOT NULL,
    TourWithin INT NOT NULL,
    TourRating DECIMAL(3,1) NOT NULL,
    TourLikes INT NOT NULL,
    TourPrice INT NOT NULL
);
GO

CREATE TABLE dbo.Trips (
    TripId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES dbo.Users(UserId) ON DELETE CASCADE,
    NameGuide NVARCHAR(150) NOT NULL,
    [Location] NVARCHAR(150) NOT NULL,
    TripDate DATE NOT NULL,
    Duration NVARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    ImagePath NVARCHAR(255) NOT NULL,
    Category NVARCHAR(20) NOT NULL CHECK (Category IN ('current', 'next', 'past', 'wishlist'))
);
GO

CREATE TABLE dbo.Chats (
    ChatId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES dbo.Users(UserId) ON DELETE CASCADE,
    [Name] NVARCHAR(150) NOT NULL,
    LastMessage NVARCHAR(255) NOT NULL,
    TimeLabel NVARCHAR(50) NOT NULL,
    AvatarImage NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE dbo.Notifications (
    NotificationId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES dbo.Users(UserId) ON DELETE CASCADE,
    Title NVARCHAR(255) NOT NULL,
    DaySent DATETIME2 NOT NULL,
    AvatarImage NVARCHAR(255) NOT NULL,
    ActionIcon NVARCHAR(20) NOT NULL CHECK (ActionIcon IN ('location', 'notes', 'edit'))
);
GO

INSERT INTO dbo.Users (FirstName, LastName, Email, [Password], Role, Country, AvatarImage)
VALUES
('Yoo', 'Jin', 'test@gmail.com', '123456', 'traveller', 'Vietnam', 'assets/profile/profile2.png'),
('Tuan', 'Tran', 'guide1@gmail.com', '123456', 'guide', 'Vietnam', 'assets/explore/guide1.png'),
('Emmy', 'Nguyen', 'guide2@gmail.com', '123456', 'guide', 'Vietnam', 'assets/explore/guide2.png');
GO

INSERT INTO dbo.ProfilePhotos (UserId, ImagePath)
VALUES
(1, 'assets/profile/myphoto1.png'),
(1, 'assets/profile/myphoto2.png'),
(1, 'assets/profile/myphoto3.png'),
(1, 'assets/profile/myphoto4.png'),
(2, 'assets/profile/myphoto1.png'),
(2, 'assets/profile/myphoto2.png'),
(3, 'assets/profile/myphoto3.png'),
(3, 'assets/profile/myphoto4.png');
GO

INSERT INTO dbo.Journeys (JourneyLocation, JourneyImage, JourneySetoffDate, JourneyWithin, JourneyPrice)
VALUES
('Da Nang - Ba Na', 'assets/explore/journey1.png', '2026-07-15', '7 days', 1200),
('Bangkok, Thailand', 'assets/explore/journey2.png', '2026-08-01', '5 days', 1500),
('Hoi An - My Son', 'assets/explore/journey3.png', '2026-09-10', '6 days', 1800);
GO

INSERT INTO dbo.Guides (NameGuide, ImageGuide, LocationGuide, Rating, Reviews)
VALUES
('Tuan Tran', 'assets/explore/guide1.png', 'Da Nang, Vietnam', 4.5, 1230),
('Emmy', 'assets/explore/guide2.png', 'Hanoi, Vietnam', 4.4, 1020),
('Linh Hana', 'assets/explore/guide3.png', 'Da Nang, Vietnam', 5.0, 1520),
('Khai Ho', 'assets/explore/guide4.png', 'Ho Chi Minh, Vietnam', 4.3, 1020);
GO

INSERT INTO dbo.Experiences (ExperienceDescription, ExperienceImage)
VALUES
('2 Hour Bicycle Tour exploring Hoi An', 'assets/explore/experience1.png'),
('1 day at Bana Hill', 'assets/explore/experience2.png');
GO

INSERT INTO dbo.FeaturedTours (TourName, TourImage, TourSetoffDate, TourWithin, TourRating, TourLikes, TourPrice)
VALUES
('Da Nang - Ba Na', 'assets/explore/featured1.png', '2026-07-15', 7, 4.5, 1234, 1300),
('Bangkok, Thailand', 'assets/explore/featured2.png', '2026-08-01', 5, 4.4, 999, 1230),
('Singapore City Tour', 'assets/explore/featured3.png', '2026-09-12', 4, 4.6, 869, 1420);
GO

INSERT INTO dbo.Trips (UserId, NameGuide, [Location], TripDate, Duration, Price, ImagePath, Category)
VALUES
(1, 'Tuan Tran', 'Da Nang - Ba Na', '2026-07-15', '7 days', 1200, 'assets/mytrip/currenttrip1.png', 'current'),
(1, 'Jane Smith', 'Bangkok, Thailand', '2026-08-01', '5 days', 1500, 'assets/mytrip/nexttrip1.png', 'next'),
(1, 'Alice Johnson', 'Hoi An - My Son', '2026-09-10', '6 days', 1800, 'assets/mytrip/nexttrip2.png', 'next'),
(1, 'Bob Brown', 'Da Nang - Ba Na', '2026-10-12', '7 days', 1200, 'assets/mytrip/nexttrip3.png', 'next'),
(1, 'Emily Davis', 'Quoc Tu Giam Temple', '2026-06-01', '4 days', 1000, 'assets/mytrip/pasttrip1.png', 'past'),
(1, 'Michael Wilson', 'Dinh Doc Lap', '2026-05-20', '5 days', 1100, 'assets/mytrip/pasttrip2.png', 'past'),
(1, 'Sarah Lee', 'Melbourne - Sydney', '2026-11-05', '7 days', 2000, 'assets/mytrip/wishtrip1.png', 'wishlist'),
(1, 'David Kim', 'Hanoi - Ha Long Bay', '2026-12-15', '7 days', 1200, 'assets/mytrip/wishtrip2.png', 'wishlist');
GO

INSERT INTO dbo.Chats (UserId, [Name], LastMessage, TimeLabel, AvatarImage)
VALUES
(1, 'Donald Trump', 'Hey, how are you?', '2:30 PM', 'assets/explore/guide1.png'),
(1, 'Kylian Mbappe', 'See you tomorrow!', '1:45 PM', 'assets/explore/guide2.png'),
(1, 'Lionel Messi', 'See you tomorrow!', '1:15 PM', 'assets/explore/guide3.png');
GO

INSERT INTO dbo.Notifications (UserId, Title, DaySent, AvatarImage, ActionIcon)
VALUES
(1, 'Tuan Tran accepted your request for the trip in Danang, Vietnam on Jan 20, 2026', DATEADD(MINUTE, -5, SYSDATETIME()), 'assets/explore/guide1.png', 'location'),
(1, 'Emmy sent you an offer for the trip in Ho Chi Minh, Vietnam on Feb 12, 2026', DATEADD(HOUR, -1, SYSDATETIME()), 'assets/explore/guide2.png', 'notes'),
(1, 'New message from Lionel Messi', DATEADD(HOUR, -2, SYSDATETIME()), 'assets/explore/guide3.png', 'edit');
GO
