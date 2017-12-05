/* Automatically choose highest comp_ID */
DECLARE @CompID Int = (SELECT MAX(Comp_ID)
					FROM dbo.Comp);

/* Manually Choose Comp_ID */
--DECLARE @CompID Int = 5

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

DECLARE @Comp_date datetime = (SELECT Date FROM dbo.Comp WHERE Comp_ID = @CompID)
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
	
/* Create table for international results. The date from the BFA set will
determine which set of international results are chosen */
DROP TABLE #INT_RES

CREATE TABLE #INT_RES(
LastName		NVARCHAR(255),
FirstName		NVARCHAR(255),
Country			NVARCHAR(255),
NifVals			Int)


/* Determine which set of international rankings need to be used for the results.
The international seasion is being assumed to run from August to August. */
DECLARE @date_int1 datetime = '2016-08-01 00:00:00.000'
DECLARE @date_int2 datetime = '2017-08-01 00:00:00.000'

IF @Comp_date > @date_int2
	BEGIN
		INSERT INTO #INT_RES
		SELECT LastName, FirstName, Country, NifVals
		FROM dbo.IntRank_Sept2017
	END
ELSE
	BEGIN
		INSERT INTO #INT_RES
		SELECT LastName, FirstName, Country, NifVals
		FROM dbo.IntRank_Sept2016
	END

/* This temporary table contains all of the Names and country for fencers from all
the internation results. These are used as a reference to determine the nationality
of different fencers */
DROP TABLE #Int_IDs

CREATE TABLE #INT_IDs(
LastName		NVARCHAR(255),
FirstName		NVARCHAR(255),
Country			NVARCHAR(255))

INSERT INTO #INT_IDs
SELECT DISTINCT Comb.LastName, Comb.FirstName, Comb.Country
FROM (
SELECT LastName, FirstName, Country
FROM dbo.IntRank_Sept2017
UNION ALL 
SELECT LastName, FirstName, Country
FROM dbo.IntRank_Sept2016) AS Comb

/* Tidy up competition table */
EXEC fencing_project.dbo.uspname_modify;

/* Determine number of fencers in competition */
DECLARE @FenNum INT = (SELECT TotalNumFencers FROM dbo.Comp WHERE Comp_ID = @CompID )

/* Create temporary table to determine any duplicates */
DROP TABLE #BTemp2

CREATE TABLE #BTemp2 
(RankID		FLOAT, 
LN			nvarchar(255), 
FN			nvarchar(255),
BFN			nvarchar(255), 
Bfa_ID		float, 
NifVals		float,
Country     nvarchar(255))

INSERT INTO #BTemp2
SELECT TC.Rank, TC.LastName, TC.Firstname, bfa.FirstName AS BfaName, bfa.BFA_ID, bfa.NIF_Val, bfa.Country
FROM dbo.TempComp AS TC
LEFT JOIN #BFA_set AS BFA
ON TC.BFA_ID = BFA.BFA_ID;

/* Ensure that previous attemps to update BFA_ID and BF_points
have been removed and changed to NULL */
UPDATE dbo.TempComp
SET BF_points = NULL;

/* Check where there is more than one entry for the same BFA_ID */
UPDATE #BTemp2
SET BFN = NULL,
BFA_ID = NULL,
NifVals = NULL,
Country = NULL
WHERE(BFA_ID) = (
SELECT B1.BFA_ID
FROM #BTemp2 AS B1
LEFT JOIN #BTemp2 AS B2
ON B1.BFA_ID = B2.BFA_ID
GROUP BY B1.BFA_ID
HAVING COUNT(B1.BFA_ID) >=2)

/* Update values for BFA_ID and BF_points */
MERGE INTO dbo.TempComp AS TC
USING #BTemp2 AS BfaT
ON (TC.BFA_ID = BfaT.BFA_ID)
WHEN MATCHED THEN 
UPDATE SET
TC.BF_points = BfaT.NifVals;

/* Check Nationalities of fencers */
UPDATE dbo.TempComp
SET Country = BFA.Country
FROM dbo.TempComp AS TC
LEFT JOIN #BTemp2 AS BFA
ON TC.BFA_ID = BFA.BFA_ID
WHERE TC.Country IS NULL;

/* Determine BFA ID for any one where the the BFA ID from 
the raw results does not match anyone in the #BFA_set
table */

/* Create temporary table to determine any duplicates */
DROP TABLE #BTemp

CREATE TABLE #BTemp 
(RankID		FLOAT, 
LN			nvarchar(255), 
FN			nvarchar(255),
BFN			nvarchar(255), 
Bfa_ID		float, 
NifVals		float,
Country     nvarchar(255))

INSERT INTO #BTemp
SELECT TC.Rank, TC.LastName, TC.Firstname, bfa.FirstName AS BfaName, bfa.BFA_ID, bfa.NIF_Val, bfa.Country
FROM dbo.TempComp AS TC
LEFT JOIN (SELECT BFA_int.FirstName, BFA_int.Surname, BFA_int.BFA_ID, BFA_int.NIF_Val, BFA_int.Country 
FROM #BFA_set AS BFA_int
LEFT JOIN (SELECT BFA1.FirstName, BFA1.Surname, MIN(BFA1.PosID) AS RowID
FROM #BFA_set AS BFA1
LEFT JOIN #BFA_set AS BFA2
ON BFA1.FirstName = BFA2.FirstName
AND BFA1.Surname = BFA2.Surname
GROUP BY BFA1.FirstName, BFA1.Surname) AS RowName
ON BFA_int.PosID = RowName.RowID
WHERE RowName.FirstName IS NOT NULL) as BFA
ON REPLACE(RTRIM(LTRIM(UPPER(TC.Lastname))), NCHAR(160), '')= REPLACE(RTRIM(LTRIM(UPPER(bfa.Surname))), NCHAR(160), '')
AND REPLACE(RTRIM(LTRIM(UPPER(TC.FirstName))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(bfa.FirstName))), NCHAR(160), '')
WHERE TC.BF_points IS NULL
AND ((TC.BFA_ID IS NULL) OR LEN(TC.BFA_ID) < 5 OR LEN(TC.BFA_ID) > 6);

/* Update BFA_ID based on name  */
MERGE INTO dbo.TempComp AS TC
USING #BTemp AS BfaT
ON (REPLACE(RTRIM(LTRIM(UPPER(TC.LastName))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(BfaT.LN))), NCHAR(160), '')
AND REPLACE(RTRIM(LTRIM(UPPER(TC.FirstName))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(BfaT.FN))), NCHAR(160), ''))
WHEN MATCHED THEN 
UPDATE SET
TC.BFA_ID = BfaT.BFA_ID,
TC.BF_points = BfaT.NifVals;

 
/* Create table to obtain values when a BFA_ID does not return
NIF values - potential typo in the BFA_ID */
DROP TABLE #BTemp3

CREATE TABLE #BTemp3 
(RankID		FLOAT, 
LN			nvarchar(255), 
FN			nvarchar(255),
BFN			nvarchar(255), 
Bfa_ID		float, 
NifVals		float,
Country     nvarchar(255))

INSERT INTO #BTemp3
SELECT TC.Rank, TC.LastName, TC.Firstname, bfa.FirstName AS BfaName, bfa.BFA_ID, bfa.NIF_Val, bfa.Country
FROM dbo.TempComp AS TC
LEFT JOIN (SELECT BFA_int.FirstName, BFA_int.Surname, BFA_int.BFA_ID, BFA_int.NIF_Val, BFA_int.Country 
FROM #BFA_set AS BFA_int
LEFT JOIN (SELECT BFA1.FirstName, BFA1.Surname, MIN(BFA1.PosID) AS RowID
FROM #BFA_set AS BFA1
LEFT JOIN #BFA_set AS BFA2
ON BFA1.FirstName = BFA2.FirstName
AND BFA1.Surname = BFA2.Surname
GROUP BY BFA1.FirstName, BFA1.Surname) AS RowName
ON BFA_int.PosID = RowName.RowID
WHERE RowName.FirstName IS NOT NULL) as BFA
ON REPLACE(RTRIM(LTRIM(UPPER(TC.Lastname))), NCHAR(160), '')= REPLACE(RTRIM(LTRIM(UPPER(bfa.Surname))), NCHAR(160), '')
AND REPLACE(RTRIM(LTRIM(UPPER(TC.FirstName))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(bfa.FirstName))), NCHAR(160), '')
WHERE TC.BF_points IS NULL
AND (TC.BFA_ID IS NOT NULL)
AND bfa.NIF_Val IS NOT NULL;



/* Update BFA_ID based on name when the BFA_ID does not exist on the database */
MERGE INTO dbo.TempComp AS TC
USING #BTemp3 AS BfaT
ON (REPLACE(RTRIM(LTRIM(UPPER(TC.LastName))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(BfaT.LN))), NCHAR(160), '')
AND REPLACE(RTRIM(LTRIM(UPPER(TC.FirstName))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(BfaT.FN))), NCHAR(160), ''))
WHEN MATCHED THEN 
UPDATE SET
TC.BFA_ID = BfaT.BFA_ID,
TC.BF_points = BfaT.NifVals; 

-- This will be useful in the future, for now left out as it was more complicated than I thought.
/* Check previous results to see if it is possible to get the fencer ID */
/*MERGE INTO dbo.TempComp AS TC
USING dbo.all_results AS AR
ON (RTRIM(LTRIM(UPPER(AR.FirstName))) = RTRIM(LTRIM(UPPER(TC.FirstName)))
AND RTRIM(LTRIM(UPPER(AR.LastName))) = RTRIM(LTRIM(UPPER(TC.LastName)))
AND Comp_ID != @CompID)
WHEN MATCHED THEN
UPDATE SET
TC.BFA_ID = AR.BFA_ID; */

/* Check Nationalities of fencers */
UPDATE dbo.TempComp
SET Country = BFA.Country
FROM dbo.TempComp AS TC
LEFT JOIN #BTemp AS BFA
ON TC.BFA_ID = BFA.BFA_ID
WHERE TC.Country IS NULL;

/* Check Nationalities of fencers */
UPDATE dbo.TempComp
SET Country = BFA.Country
FROM dbo.TempComp AS TC
LEFT JOIN #BTemp2 AS BFA
ON TC.BFA_ID = BFA.BFA_ID
WHERE TC.Country IS NULL;

/* Check for international fencers */
UPDATE dbo.TempComp
SET Country = Int_ID.Country
FROM dbo.TempComp AS TC
LEFT JOIN #INT_IDs AS Int_ID
ON REPLACE(LTRIM(RTRIM(TC.LastName)), CHAR(160), '') = REPLACE(LTRIM(RTRIM(Int_ID.LastName)), CHAR(160), '')
AND REPLACE(LTRIM(RTRIM(TC.FirstName)), CHAR(160), '') = REPLACE(LTRIM(RTRIM(Int_ID.FirstName)), CHAR(160), '')
WHERE TC.Country IS NULL;

SELECT * FROM TempComp
WHERE Country IS NULL;

/* Set any unknown country to "GBR" - This could be inaccurate */
UPDATE dbo.TempComp
SET Country = 'GBR'
WHERE Country IS NULL

/* Check whether any GBR fencers are not on the BFA List */
SELECT * 
FROM dbo.TempComp AS TC
WHERE BFA_ID IS NULL;

/* Set "NULL" BF_points to zero to create a running total */
UPDATE dbo.TempComp
SET BF_points = 0
WHERE BF_points IS NULL;

/* Create temporary table with country, BFA_ID and running total of the BF
NIF points. If the country is not "GBR" and the running total is >5 then the
fencer is an overseas fencer that has additional NIF points. This table
allows us to track which fencer fit this criteria */

DROP TABLE #BFtotal

CREATE TABLE #BFtotal (
Rank		Float,
LastName	nvarchar(255),
FirstName	nvarchar(255),
Country		nchar(3),
BFA_ID		Int,
BF_points	Float,
BF_runtot	Float)

INSERT INTO #BFtotal
SELECT TC1.Rank, TC1.LastName, TC1.FirstName, TC1.Country, TC1.BFA_ID, TC1.BF_points, (SELECT SUM(TC2.BF_points) AS BF_runtot
FROM dbo.TempComp AS TC2
WHERE TC2.Rank >= TC1.Rank) AS BF_runtot
FROM dbo.TempComp AS TC1;

/* Remove extra results that were for more fencers than attened */
DELETE FROM dbo.TempComp
WHERE FencerID > @FenNum;

/* Update NIF (BF_points) for the overseas fencers.
The BF_points are:
+6  when BF_runtot >= 24
+3  when 23 >= BF_runtot >= 16 
+1  when 15 >= BF_runtot >= 6
0   when 5 >= BF_runtot   

Added addition check that the LastName has to match between the 
#BFtotal and dob.TempComp data bases. This means that there
is a unique solution for each fencer when there are two or more 
people wit the same result.*/

UPDATE dbo.TempComp 
SET BF_points = (
CASE 
	/* runtot >= 24 */
	WHEN (SELECT BF_runtot
	FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.TempComp.Rank = BFT.Rank
	AND dbo.TempComp.LastName = BFT.LastName
	AND dbo.TempComp.FencerID <= @FenNum) >= 24
	THEN '6'

	/* 23 >= runtot >= 16 */
	WHEN 23 >= (SELECT BF_runtot FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.TempComp.Rank = BFT.Rank
	AND dbo.TempComp.LastName = BFT.LastName
	AND dbo.TempComp.FencerID <= @FenNum)
	AND (SELECT BF_runtot FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.TempComp.Rank = BFT.Rank
	AND dbo.TempComp.LastName = BFT.LastName
	AND dbo.TempComp.FencerID <= @FenNum) >= 16
	THEN '3'
	
	/* 15 >= runtot >= 6 */
	WHEN (SELECT BF_runtot FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.TempComp.Rank = BFT.Rank	
	AND dbo.TempComp.LastName = BFT.LastName
	AND dbo.TempComp.FencerID <= @FenNum) <= 15
	AND (SELECT BF_runtot FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.TempComp.Rank = BFT.Rank
	AND dbo.TempComp.LastName = BFT.LastName
	AND dbo.TempComp.FencerID <= @FenNum) >= 6
	THEN  '1'

	/* 5 >= runtot */
	WHEN (SELECT BF_runtot FROM #BFtotal AS BFT
	WHERE Country != 'GBR' AND BFA_ID IS NULL
	AND dbo.TempComp.Rank = BFT.Rank
	AND dbo.TempComp.LastName = BFT.LastName
	AND dbo.TempComp.FencerID <= @FenNum) <= 5
	THEN '0'
	
	/* Otherwise there is no need to change the values */
	ELSE BF_points
	END
	)
WHERE Country != 'GBR' AND BFA_ID IS NULL;

/* Change NIF values if it is larger due to the international ranking of the fencer */
UPDATE dbo.TempComp
SET BF_points = IR.NifVals
FROM dbo.TempComp AS TC
LEFT JOIN #INT_RES AS IR
ON REPLACE(LTRIM(RTRIM(TC.LastName)), CHAR(160), '') = REPLACE(LTRIM(RTRIM(IR.LastName)), CHAR(160), '')
AND REPLACE(LTRIM(RTRIM(TC.FirstName)), CHAR(160), '') = REPLACE(LTRIM(RTRIM(IR.FirstName)), CHAR(160), '')
WHERE TC.Country NOT IN ('GBR', 'SCO', 'WAL', 'NIR', 'ENG')
AND IR.NifVals > TC.BF_points;

/* This section shows what fencers have had their NIF (BF_points)
modified due to not have a ranking, and by being international fencers,
and based on who that have beaten as mentioned above */
SELECT TC.FencerID, TC.Rank, TC.LastName, TC.FirstName, 
TC.Country, TC.Club, TC.BF_Points, BFT.BF_runtot FROM dbo.TempComp AS TC
LEFT JOIN #BFtotal AS BFT
ON TC.Rank = BFT.Rank
WHERE TC.Country != 'GBR' AND TC.BFA_ID IS NULL
AND TC.LastName = BFT.LastName;

--SELECT SUM(BF_points) FROM dbo.TempComp;
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

/* Create variable that contains the total NIF (BF_Points)
for the competition based on BFA rankings */
DECLARE @TotNIF_BFA INT = (
SELECT SUM(BF_points) FROM dbo.TempComp
WHERE FencerID <= @FenNum);

/* NIF value based on the number of fencers that entered
the competition. */
DECLARE @TotNIF_Num INT = (FLOOR( 0.25 * @FenNum))

/* Determine the actual value of NIF for a competition */
DECLARE @TotNIF INT =(
CASE 
	WHEN @TotNIF_BFA > @TotNIF_Num
	AND (SELECT ShortName FROM dbo.Comp
		WHERE Comp_ID = @CompID) = 'NatChamp'
	THEN @TotNIF_BFA * 1.2

	WHEN @TotNIF_BFA < @TotNIF_Num
	AND (SELECT ShortName FROM dbo.Comp
		WHERE Comp_ID = @CompID) = 'NatChamp'
	THEN @TotNIF_Num * 1.2

	WHEN @TotNIF_BFA > @TotNIF_Num
	AND (SELECT ShortName FROM dbo.Comp
		WHERE Comp_ID = @CompID) != 'NatChamp'
	THEN @TotNIF_BFA

	ELSE
	@TotNIF_Num
END
)


/* Update dbo.Comp with the total NIF points for the competition */
UPDATE dbo.Comp
SET TotNIF = @TotNIF
WHERE Comp_ID = @CompID;

/* Creats variable for the cut-off points for ranking points*/
DECLARE @CutOff INT = (
SELECT FencerCutOFF
FROM dbo.Comp
WHERE Comp_ID = @CompID);

/* Adds NIF values for ranking points to all fencers */
UPDATE dbo.TempComp
SET RankingPoints = @TotNif * NIF.Multiplier
FROM dbo.TempComp AS TC
LEFT JOIN dbo.nif_mult AS NIF
ON TC.Rank = NIF.Place;

/* Removes ranking points from any fencers above the cut-off */
UPDATE dbo.TempComp
SET RankingPoints = '0'
WHERE Rank > @CutOff;

/* Removes all previous results for this competition */
DELETE FROM dbo.all_results
WHERE COMP_ID = @CompID;

/* Adds new results to all results competition table */
INSERT INTO dbo.all_results
SELECT TC.BFA_ID, @CompID, TC.Rank, TC.RankingPoints, REPLACE(RTRIM(LTRIM(UPPER(TC.FirstName))), NCHAR(160), ''),
	REPLACE(RTRIM(LTRIM(UPPER(TC.LastName))), NCHAR(160), ''), TC.Club
FROM dbo.TempComp AS TC