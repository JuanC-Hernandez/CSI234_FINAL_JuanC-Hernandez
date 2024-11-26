--Stored Procedures

----------------------------------------------------------------------------------------
--BASIC: Get Players in a Team
CREATE PROCEDURE WAFFL.PlayerByTeam -- Creating Procedure
@TeamID INT --Parameter decleration
AS
BEGIN
	SELECT
		p.PlayerID,
		p.FirstName + p.LastName AS FullName,
		p.Age,
		p.Position
	FROM 
		WAFFL.Players p
	WHERE p.TeamID = @TeamID;
END
GO
--TEST
EXEC WAFFL.PlayerByTeam @TeamID = 1;
GO
----------------------------------------------------------------------------------------
---BASIC: Get Teams in a conference
CREATE PROCEDURE WAFFL.TeamByConference
@ConferenceID INT
AS
BEGIN
	SELECT
		t.TeamID,
		t.TeamName
	FROM 
		WAFFL.Teams t
	WHERE t.ConferenceID = @ConferenceID;
END
GO
--TEST
EXEC WAFFL.TeamByConference @ConferenceID = 1;
GO
----------------------------------------------------------------------------------------
--BASIC: Get Players by Position
CREATE PROCEDURE WAFFL.PlayersByPosition
@Position VARCHAR(25)
AS
BEGIN
	SELECT
		p.FirstName + p.LastName AS FullName,
		p.Age,
		p.Position,
		p.TeamID
	FROM 
		WAFFL.Players p
	WHERE p.Position = @Position;
END
GO
--TEST
EXEC WAFFL.PlayersByPosition @Position = 'Quarterback';
GO
----------------------------------------------------------------------------------------
--COMPLEX: Game Results
CREATE PROCEDURE WAFFL.GameResults
AS
BEGIN
	SELECT
		g.GameID,
		g.GameDate,
		tm1.TeamName AS Team1,
		tm2.TeamName AS Team2,
		r.Team1_Score,
		r.Team2_Score,
		win.TeamName AS Winner
	FROM
		WAFFL.Games g
	INNER JOIN WAFFL.Results r ON g.GameID = r.GameID
	INNER JOIN WAFFL.Teams tm1 ON g.TeamID_1 = tm1.TeamID
	INNER JOIN WAFFL.Teams tm2 ON g.TeamID_2 = tm2.TeamID
	INNER JOIN WAFFL.Teams win ON r.TeamID_Winner = win.TeamID;
END
GO
--TEST
EXEC WAFFL.GameResults;
GO
----------------------------------------------------------------------------------------
--COMPLEX:
CREATE PROCEDURE WAFFL.GameRefs
AS
BEGIN
	SELECT
		g.GameID,
		g.GameDate,
		g.TeamID_1,
		g.TeamID_2,
		r.FirstName + r.LastName AS RefereeName		
	FROM
		WAFFL.Games g
	LEFT JOIN WAFFL.Referees r ON g.RefereeID = r.RefereeID
	ORDER BY g.GameDate
END
GO
--TEST
EXEC WAFFL.GameRefs;
GO
----------------------------------------------------------------------------------------
--ADVANCED:
CREATE PROCEDURE WAFFL.GameRefsADV
AS
BEGIN
	SELECT
		g.GameDate,
		tm1.TeamName,
		tm2.TeamName,
		r.FirstName + r.LastName AS RefName
	FROM
		WAFFL.Games g
	LEFT JOIN WAFFL.Teams tm1 ON g.TeamID_1 = tm1.TeamID
	LEFT JOIN WAFFL.Teams tm2 ON g.TeamID_2 = tm2.TeamID
	LEFT JOIN WAFFL.Referees r ON g.RefereeID = r.RefereeID;
END
GO
--TEST
EXEC WAFFL.GameRefsADV;
GO
----------------------------------------------------------------------------------------
--ADVANCED:
