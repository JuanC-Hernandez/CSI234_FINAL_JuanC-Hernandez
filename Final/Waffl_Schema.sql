--Creating Schema
CREATE SCHEMA WAFFL;
GO

--Drops tables if already exist
DROP TABLE IF EXISTS WAFFL.Conferences;
DROP TABLE IF EXISTS WAFFL.Teams;
DROP TABLE IF EXISTS WAFFL.Players;
DROP TABLE IF EXISTS WAFFL.Referees;
DROP TABLE IF EXISTS WAFFL.Locations;
DROP TABLE IF EXISTS WAFFL.Results;
DROP TABLE IF EXISTS WAFFL.Games;
GO
----------------------------------------------------------------------------------------
-- Creating Tables or Re-Create

--NOT NULL, Ensures column cant be NULL
--UNIQUE, Ensures values are unique
--CHECK, checks satisfies a specific condition

--Conference TABLE
CREATE TABLE WAFFL.Conferences(
	ConferenceID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ConferenceName VARCHAR(25) NOT NULL UNIQUE --Cant duplicate conference name
);
--Teams TABLE
CREATE TABLE WAFFL.Teams(
	TeamID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TeamName VARCHAR(50) NOT NULL UNIQUE, --Cant duplicate team name
	ConferenceID INT NOT NULL,
	Wins INT NOT NULL CHECK(Wins >= 0), --Cant be negative wins
	Loses INT NOT NULL CHECK(Loses >= 0), --Cant be negative loses
	FOREIGN KEY(ConferenceID) REFERENCES WAFFL.Conferences(ConferenceID)
		ON DELETE CASCADE --Deletes all dependent records when deleted
		ON UPDATE CASCADE --Updates all dependent records wehn updated
);
--Players TABLE
CREATE TABLE WAFFL.Players(
	PlayerID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Age INT NOT NULL CHECK(Age >= 13 AND Age <= 17), --This is a youth league
	Position VARCHAR(25),
	TeamID INT NOT NULL,
	FOREIGN KEY(TeamID) REFERENCES WAFFL.Teams(TeamID)
		ON DELETE CASCADE --Deletes all dependent records when deleted
		ON UPDATE CASCADE --Updates all dependent records wehn updated
);
--Referees TABLE
CREATE TABLE WAFFL.Referees(
	RefereeID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL
);
--Locations TABLE
CREATE TABLE WAFFL.Locations(
	LocationID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ParkName VARCHAR(50) NOT NULL,
	LocationAddress VARCHAR(100) NOT NULL
);
--Games TABLE, This is the bridge Table
--b/c each team can be in many games, and each game has two teams, this is a many to many.
CREATE TABLE WAFFL.Games(
	GameID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	GameDate DATE NOT NULL,
	LocationID INT NOT NULL,
	TeamID_1 INT NOT NULL,
	TeamID_2 INT NOT NULL,
	RefereeID INT NOT NULL, 
	FOREIGN KEY(LocationID) REFERENCES WAFFL.Locations(LocationID),
	FOREIGN KEY(TeamID_1) REFERENCES WAFFL.Teams(TeamID),
	FOREIGN KEY(TeamID_2) REFERENCES WAFFL.Teams(TeamID),
	FOREIGN KEY(RefereeID) REFERENCES WAFFL.Referees(RefereeID)
);
--Results TABLE
CREATE TABLE WAFFL.Results(
	ResultID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	GameID INT NOT NULL,
	Team1_Score INT NOT NULL CHECK(Team1_Score >= 0), --Cant be negative Score
	Team2_Score INT NOT NULL CHECK(Team2_Score >= 0), --Cant be negative Score
	TeamID_Winner INT NOT NULL,
	FOREIGN KEY(GameID) REFERENCES WAFFL.Games(GameID),
	FOREIGN KEY(TeamID_Winner) REFERENCES WAFFL.Teams(TeamID)
);
----------------------------------------------------------------------------------------
---Populate tables

--Conference TABLE
INSERT INTO WAFFL.Conferences(ConferenceName)
	VALUES
	('WEST'),
	('EAST');
--Teams TABLE
INSERT INTO WAFFL.Teams(TeamName, ConferenceID, Wins, Loses)
	VALUES
	('Federal Way Eagles',1,0,0),
	('Spokane BullFrogs',2,0,0);
--Players TABLE
INSERT INTO WAFFL.Players(FirstName, LastName, Age, Position, TeamID)
	VALUES
	('Juan', 'Hernandez', 16, 'Quarterback',1),
	('Jayden', 'Hargrove', 14, 'Quarterback',1),
	('Gloria', 'Lara', 15, 'Wide Receiver',1),
	('John', 'Whitson', 17, 'Wide Receiver',1),
	('Zion', 'Read',15,'Wide Receiver',1),
	('Emeri', 'Foster', 17, 'Wide Receiver',1),
	('Braxton', 'Sanchez', 16, 'Center',1),
	('Sebastian', 'Nair', 13, 'Center',1),
	('Ruthie', 'Echols', 16, 'Defensive Back',1),
	('Axton', 'Johnson', 17, 'Defensive Back',1),
	('Lincoln', 'Lockhart', 15, 'Defensive Back',1),
	('Hayley', 'Vasquez', 16, 'Rusher',1),
	('Chase', 'Shultz', 16, 'Rusher',1),
	('Philip', 'Hiatt', 17, 'Safety',1),
	('Jonathan', 'Shepard', 17, 'Safety',1),
	('James', 'Bray', 14, 'Safety',1),
	('Rafael', 'Guerrero', 16, 'Quarterback',2),
	('Maverick', 'Cervantes', 14, 'Quarterback',2),
	('Leo', 'Perez', 15, 'Wide Receiver',2),
	('Starr', 'Williams', 17, 'Wide Receiver',2),
	('Ayla', 'Meadows',15,'Wide Receiver',2),
	('Jonah', 'Bartels', 17, 'Wide Receiver',2),
	('Benjamin', 'Lopez', 16, 'Center',2),
	('Kane', 'Cabrera', 13, 'Center',2),
	('Michael', 'Flores', 16, 'Defensive Back',2),
	('David', 'Weaver', 17, 'Defensive Back',2),
	('Eden', 'Hurtado', 15, 'Defensive Back',2),
	('Julio', 'Valdez', 16, 'Rusher',2),
	('Grayson', 'Bently', 16, 'Rusher',2),
	('Milo', 'Bently', 17, 'Safety',2),
	('Brian', 'Boehm', 17, 'Safety',2),
	('Jack', 'Boehm', 14, 'Safety',2);
--Referees TABLE
INSERT INTO WAFFL.Referees(FirstName, LastName)
	VALUES
	('Gerson', 'Miller'),
	('Luna', 'Larson'),
	('Adrian', 'Seal'),
	('Francisco', 'Metz');
--Locations TABLE
INSERT INTO WAFFL.Locations(ParkName, LocationAddress)
	VALUES
	('Steel Lake Park', '2410 s 312th st, Federal Way WA 98003'),
	('Dwight Merkel Sports Complex', '5701 n Assembly st, Spokane WA 99205');
--Games TABLE
INSERT INTO WAFFL.Games(GameDate, LocationID, TeamID_1, TeamID_2, RefereeID)
	VALUES
	('2024-11-15', 2, 2, 1, 4),
	('2024-11-22', 1, 1, 2, 1);
--Results TABLE
INSERT INTO WAFFL.Results(GameID, Team1_Score, Team2_Score, TeamID_Winner)
	VALUES
	(1, 7, 24, 1),
	(2, 31, 21, 1);
----------------------------------------------------------------------------------------
SELECT * FROM WAFFL.Conferences;
SELECT * FROM WAFFL.Teams;
SELECT * FROM WAFFL.Games;
SELECT * FROM WAFFL.Locations;
SELECT * FROM WAFFL.Players;
SELECT * FROM WAFFL.Referees;
SELECT * FROM WAFFL.Results;
