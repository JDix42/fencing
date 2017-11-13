/* This query inserts BFA ID and NIF points 
to a competition table (ct) */
DROP VIEW BTemp
GO

/* Create temporary table to determine any duplicates */
CREATE VIEW BTemp (RankID, LN, FN, BFN, Bfa_ID, NifVals)
AS
(SELECT ct.Rank, ct.LastName, ct.Firstname, bfa.FirstName AS BfaName, bfa.BFA_ID, bfa.NIF_Val
FROM dbo.birm_res_new AS CT
LEFT JOIN dbo.BFA_ID as BFA
ON UPPER(ct.Lastname) = UPPER(bfa.Surname)
AND LTRIM(UPPER(ct.FirstName)) = LTRIM(UPPER(bfa.FirstName)))
GO

/* Determine which BFA ranking set to use.
New rankings sets with different NIF values.
The rankings are updated every September and 
March each year */
DROP TABLE #BFA_set

CREATE TABLE #BFA_set (
BFA_ID	FLOAT,
Surname		NVARCHAR(255),
FirstName	NVARCHAR(255),
Country		NVARCHAR(255),
Club		NVARCHAR(255),
NIF_Val		FLOAT,
MidName		NVARCHAR(255),
PosID		INT)

DECLARE @Comp_date datetime = (SELECT Date FROM dbo.Comp WHERE Comp_ID = 1)
DECLARE @date1 datetime = '2017-09-01 00:00:00.000'
DECLARE @date2 datetime = '2017-03-01 00:00:00.000'
DECLARE @date3 datetime = '2016-09-01 00:00:00.000'

IF @Comp_date >= @date1
	BEGIN
		PRINT 'Set1'
		INSERT INTO #BFA_set
		SELECT *
		FROM dbo.BFA_ID
	END
ELSE IF @Comp_date >= @date2
	BEGIN
		PRINT 'Set2'
		INSERT INTO #BFA_set
		SELECT *
		FROM dbo.BFA_IDMar2017
	END
ELSE
	BEGIN 
		PRINT 'Set3'
		INSERT INTO #BFA_set
		SELECT *
		FROM dbo.BFA_IDSept2016
	END ;		

/* Create CTE for BFA IDs and NIF values. */
WITH BfaTemp (RankID, LN, FN, BFN, Bfa_ID, NifVals)

AS
--(SELECT bfa.BFA_ID, bfa.NIF_Val
--FROM dbo.birm_res_new AS ct
--LEFT JOIN dbo.BFA_ID AS bfa
--ON UPPER(ct.LastName) = UPPER(bfa.Surname))
(SELECT ct.Rank, ct.LastName, ct.Firstname, bfa.FirstName AS BfaName, bfa.BFA_ID, bfa.NIF_Val
FROM dbo.birm_res_new AS CT
LEFT JOIN #BFA_set as BFA
ON UPPER(ct.Lastname) = UPPER(bfa.Surname)
AND LTRIM(UPPER(ct.FirstName)) = LTRIM(UPPER(bfa.FirstName))
WHERE BFA.BFA_ID NOT IN
(SELECT BFA.BFA_ID as DelID 
FROM dbo.BFA_ID AS BFA
LEFT JOIN 
(SELECT DupNames.FirstName, DupNames.LastName, MAX(BFA.PosID) AS DeleteID
FROM
/* Determine any names where that are duplicated in the table */
(SELECT BfaT.FN AS FirstName, BfaT.LN As LastName, COUNT(BfaT.LN) AS Replicas
FROM BTemp AS BfaT
GROUP BY BfaT.FN, BfaT.LN
HAVING COUNT(BfaT.LN) >= 2 AND COUNT(BfaT.FN) >= 2) AS DupNames
LEFT JOIN #BFA_set AS BFA
ON DupNames.LastName = BFA.Surname AND DupNames.FirstName = BFA.FirstName
GROUP BY DupNames.LastName, DupNames.FirstName) AS DelList
ON BFA.PosID = DelList.DeleteID
WHERE DelList.FirstName IS NOT NULL))

SELECT * FROM BfaTemp

/* Ensure that previous attemps to update BFA_ID and BF_points
have been removed and changed to NULL */
UPDATE dbo.birm_res_new
SET BFA_ID = NULL, BF_points = NULL

/* Update values for BFA_ID and BF_points */
MERGE INTO dbo.birm_res_new AS BRN
USING BfaTemp AS BfaT
ON (BRN.LastName = BfaT.LN
AND BRN.FirstName = BfaT.FN)
WHEN MATCHED THEN 
UPDATE SET
BRN.BFA_ID = BfaT.BFA_ID,
BRN.BF_points = BfaT.NifVals;

/* TEST for whether Surnames do still exist in BFA ID database
SELECT * FROM BFA_ID
JOIN (SELECT LN, FN 
FROM BfaTemp
WHERE BFA_ID IS NULL) AS LastNameTemp
ON BFA_ID.Surname = LastNameTemp.LN; */

/* TEST for whether FirstNames do still exist in BFA ID database 
with a plausable Surname
SELECT * FROM BFA_ID
JOIN (SELECT LN, FN 
FROM BfaTemp
WHERE BFA_ID IS NULL) AS LastNameTemp
ON BFA_ID.FirstName = LastNameTemp.FN
WHERE LEFT(BFA_ID.SurName, 1) = LEFT(LastNameTemp.LN, 1); */


SELECT * 
FROM BfaTemp
ORDER BY RankID;


INSERT INTO dbo.birm_res_new(BFA_ID, BF_points)
SELECT Bfa_ID, NifVals
FROM BfaTemp ;

SELECT * 
FROM dbo.birm_res_new;
