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
 

/* Create temporary table to determine any duplicates */
DROP TABLE #BTemp

CREATE TABLE #BTemp 
(RankID		FLOAT, 
LN			nvarchar(255), 
FN			nvarchar(255),
BFN			nvarchar(255), 
Bfa_ID		float, 
NifVals		float)

INSERT INTO #BTemp
SELECT ct.Rank, ct.LastName, ct.Firstname, bfa.FirstName AS BfaName, bfa.BFA_ID, bfa.NIF_Val
FROM dbo.birm_res_new AS CT
LEFT JOIN (SELECT BFA_int.FirstName, BFA_int.Surname, BFA_int.BFA_ID, BFA_int.NIF_Val 
FROM #BFA_set AS BFA_int
LEFT JOIN (SELECT BFA1.FirstName, BFA1.Surname, MIN(BFA1.PosID) AS RowID
FROM #BFA_set AS BFA1
LEFT JOIN #BFA_set AS BFA2
ON BFA1.FirstName = BFA2.FirstName
AND BFA1.Surname = BFA2.Surname
GROUP BY BFA1.FirstName, BFA1.Surname) AS RowName
ON BFA_int.PosID = RowName.RowID
WHERE RowName.FirstName IS NOT NULL) as BFA
ON UPPER(ct.Lastname) = UPPER(bfa.Surname)
AND LTRIM(UPPER(ct.FirstName)) = LTRIM(UPPER(bfa.FirstName));


/* Ensure that previous attemps to update BFA_ID and BF_points
have been removed and changed to NULL */
UPDATE dbo.birm_res_new
SET BFA_ID = NULL, BF_points = NULL

/* Update values for BFA_ID and BF_points */
MERGE INTO dbo.birm_res_new AS BRN
USING #BTemp AS BfaT
ON (BRN.LastName = BfaT.LN
AND BRN.FirstName = BfaT.FN)
WHEN MATCHED THEN 
UPDATE SET
BRN.BFA_ID = BfaT.BFA_ID,
BRN.BF_points = BfaT.NifVals;

/* Set "NULL" BF_points to zero to create a running total */
UPDATE dbo.birm_res_new
SET BF_points = 0
WHERE BF_points IS NULL;

/* Create temporary table with country, BFA_ID and running total of the BF
NIF points. If the country is not "GBR" and the running total is >5 then the
fencer is an overseas fencer that has additional NIF points. This table
allows us to track which fencer fit this criteria */

DROP TABLE #BFtotal

CREATE TABLE #BFtotal (
Rank		Float,
Country		nchar(3),
BFA_ID		Int,
BF_points	Float,
BF_runtot	Float)

INSERT INTO #BFtotal
SELECT BRN1.Rank, BRN1.Country, BRN1.BFA_ID, BRN1.BF_points, (SELECT SUM(BRN2.BF_points) AS BF_runtot
FROM dbo.birm_res_new AS BRN2
WHERE BRN2.Rank >= BRN1.Rank) AS BF_runtot
FROM dbo.birm_res_new AS BRN1;

/* Update NIF (BF_points) for the overseas fencers.
The BF_points are:
+6  when BF_runtot >= 24
+3  when 23 >= BF_runtot >= 16 
+1  when 15 >= BF_runtot >= 6
0   when 5 >= BF_runtot   */

UPDATE dbo.birm_res_new 
SET BF_points = (
CASE 
	/* runtot >= 24 */
	WHEN (SELECT BF_runtot
	FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.birm_res_new.Rank = BFT.Rank) >= 24
	THEN '6'

	/* 23 >= runtot >= 16 */
	WHEN 23 >= (SELECT BF_runtot FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.birm_res_new.Rank = BFT.Rank)
	AND (SELECT BF_runtot FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.birm_res_new.Rank = BFT.Rank) >= 16
	THEN '3'
	
	/* 15 >= runtot >= 6 */
	WHEN (SELECT BF_runtot FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.birm_res_new.Rank = BFT.Rank) <= 15
	AND (SELECT BF_runtot FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.birm_res_new.Rank = BFT.Rank) >= 6
	THEN  '1'

	/* 5 >= runtot */
	WHEN (SELECT BF_runtot FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.birm_res_new.Rank = BFT.Rank) <= 5
	THEN '0'
	
	/* Otherwise there is no need to change the values */
	ELSE BF_points
	END
	)
WHERE Country != 'GBR' AND BFA_ID IS NULL;


SELECT *, BFT.BF_runtot FROM dbo.birm_res_new AS BRN
LEFT JOIN #BFtotal AS BFT
ON BRN.Rank = BFT.Rank
WHERE BRN.Country != 'GBR' AND BRN.BFA_ID IS NULL;

SELECT SUM(BF_points) FROM dbo.birm_res_new;
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
