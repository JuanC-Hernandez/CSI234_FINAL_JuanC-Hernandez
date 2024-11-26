--Triggers and Transactions
----------------------------------------------------------------------------------------
--HISTORY TABLE
DROP TABLE IF EXISTS WAFFL.History;
CREATE TABLE WAFFL.History(
	HistoryID  INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	UserName VARCHAR(100) NOT NULL,
	TableName VARCHAR(25) NOT NULL,
	ChangeDate DATETIME NOT NULL
);
GO
----------------------------------------------------------------------------------------
DROP TRIGGER WAFFL.tr_Teams_RecordAfterUpdate;
GO
--AFTER UPDATE
CREATE OR ALTER TRIGGER WAFFL.tr_Teams_RecordAfterUpdate
ON WAFFL.Teams
AFTER UPDATE
AS
BEGIN
	-- Prevents Trigger Recursion
	--https://learn.microsoft.com/en-us/sql/t-sql/functions/trigger-nestlevel-transact-sql?view=sql-server-ver16
	IF(TRIGGER_NESTLEVEL('WAFFL.tr_Teams_RecordAfterUpdate')>1)
	BEGIN
		RETURN;
	END
	--Error Handling: cant decrease in wins or loses
	IF EXISTS(
		SELECT 1 
		FROM INSERTED AS I 
		JOIN DELETED AS D
		ON I.TeamID = D.TeamID
		WHERE I.Wins < D.Wins OR I.Loses < D.Loses)
	BEGIN
		Print 'Insert Rejected';
		RAISERROR('CAN NOT Decrease Wins or Loses', 16, 1);
		ROLLBACK TRANSACTION;
		RETURN;
	END
	--Update History Table
	--https://learn.microsoft.com/en-us/sql/t-sql/functions/system-user-transact-sql?view=sql-server-ver16
	INSERT INTO WAFFL.History(UserName, TableName, ChangeDate)
		VALUES
		(SYSTEM_USER, 'WAFFL.Teams', GETDATE()); 

	SELECT 
		I.TeamID,
		I.TeamName,
		D.Wins +'-'+D.Loses AS OldRecord,
		I.Wins +'-'+I.Loses AS NewRecord
	FROM INSERTED AS I
	JOIN DELETED AS D
	ON I.TeamID = D.TeamID
	WHERE I.Wins <> D.Wins OR I.Loses <> D.Loses;
	SELECT * FROM WAFFL.History;
END;
GO
--TEST
UPDATE WAFFL.Teams
SET Wins = 1
WHERE TeamID = 1;
GO
----------------------------------------------------------------------------------------
DROP TRIGGER WAFFL.tr_Players_AfterDelete;
GO
--AFTER DELETE
CREATE OR ALTER TRIGGER WAFFL.tr_Players_AfterDelete
ON WAFFL.Players
AFTER DELETE
AS
BEGIN
	-- Prevents Trigger Recursion
	--https://learn.microsoft.com/en-us/sql/t-sql/functions/trigger-nestlevel-transact-sql?view=sql-server-ver16
	IF(TRIGGER_NESTLEVEL('WAFFL.tr_Players_AfterDelete')>1)
	BEGIN
		RETURN;
	END
	--Error Handling: if players doesnt exist
	IF NOT EXISTS(SELECT 1 
		FROM INSERTED AS I 
		JOIN DELETED AS D
		ON I.TeamID = D.TeamID
		WHERE I.PlayerID = D.PlayerID)
	BEGIN
		PRINT 'Player Does NOT Exist'
		ROLLBACK TRANSACTION;
		RETURN;
	END
		--Update History Table
	--https://learn.microsoft.com/en-us/sql/t-sql/functions/system-user-transact-sql?view=sql-server-ver16
	INSERT INTO WAFFL.History(UserName, TableName, ChangeDate)
		VALUES
		(SYSTEM_USER, 'WAFFL.Teams', GETDATE()); 

	PRINT 'Player has been removed'
	SELECT * FROM WAFFL.Players;
	SELECT * FROM WAFFL.History;
END;
GO
--TEST
SELECT * FROM WAFFL.Players;
DELETE FROM WAFFL.Players WHERE PlayerID = 1;
GO
----------------------------------------------------------------------------------------
--Transaction
