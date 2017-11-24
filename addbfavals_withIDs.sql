/* Automatically choose highest comp_ID */
DECLARE @CompID Int = (SELECT MAX(Comp_ID)
					FROM dbo.Comp);

/* Manually Choose Comp_ID */
--DECLARE @CompID Int = ##

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

/* Tidy up competition table */
UPDATE dbo.TempComp
SET FirstName = SUBSTRING(LTRIM(FirstName), 0, CHARINDEX(' ', LTRIM(FirstName))),
MidName = SUBSTRING(LTRIM(FirstName), CHARINDEX(' ', LTRIM(FirstName)), LEN(FirstName))
WHERE CHARINDEX(' ', LTRIM(FirstName)) > 0;

UPDATE dbo.TempComp
SET FirstName = LTRIM(FirstName);

UPDATE dbo.TempComp
SET FirstName = 'Nicholas'
WHERE FirstName = 'Nick'
AND (UPPER(LastName) = 'MORT' OR UPPER(LastName) = 'DOOTSON');

UPDATE dbo.TempComp
SET FirstName = 'Joshua'
WHERE FirstName = 'Josh'
AND (UPPER(LastName) = 'BURN');

UPDATE dbo.TempComp
SET FirstName = 'Daniel'
WHERE FirstName = 'Dan'
AND (UPPER(LastName) = 'ELLIKER');

UPDATE dbo.TempComp
SET FirstName = 'Kevin'
WHERE FirstName = 'Kev'
AND (UPPER(LastName) = 'MILNE');

UPDATE dbo.TempComp
SET LastName = 'DE LANGE'
WHERE UPPER(LastName) = 'DE LANG'
AND (UPPER(FirstName) = 'KIERAN')

UPDATE dbo.TempComp
SET LastName = 'WOOLLARD'
WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'WOOLARD'
AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'JONATHAN'

UPDATE dbo.TempComp
SET LastName = 'MARROQUÍN'
WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '')  = 'MARROQUIN'
AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'DIEGO'

UPDATE dbo.TempComp
SET LastName = 'MACCHIAROLA',
FirstName = 'ALESSANDRO'
WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '')  = 'MACHIAROLA'
AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ALLESSANDRO'

UPDATE dbo.TempComp
SET FirstName = 'Dominic'
WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'DE ALMEIDA'
AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'DOMINC'

UPDATE dbo.TempComp
SET LastName ='VAN AARSEN'
WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'VAN-AARSE'
AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'GEERT'

UPDATE dbo.TempComp
SET FirstName ='Tony'
WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'BARTLETT'
AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ANTHONY'

UPDATE dbo.TempComp
SET FirstName = 'James'
WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'DAVIS'
AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'JAMES-ANDREW'

UPDATE dbo.TempComp
SET FirstName = 'Ben'
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'BENJAMIN'
AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'PEGGS'

UPDATE dbo.TempComp
SET FirstName = 'Rafael', MidName = 'Rhys', LastName = 'Pollitt'
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'RAFAEL'
AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'RHYS POLLITT'

UPDATE dbo.TempComp
SET FirstName = 'Rafael', MidName = 'Rhys', LastName = 'Pollitt'
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') LIKE 'POLLITT%'
AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'RHY'

UPDATE dbo.TempComp
SET FirstName = 'Rob'
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ROBERT'
AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'WILLIAMS'

UPDATE dbo.TempComp
SET FirstName = 'Alex'
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ALEXANDRE'
AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'SCHLINDWEIN'

UPDATE dbo.TempComp
SET FirstName = 'Matthew'
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'MATT'
AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'POWELL'

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
ON REPLACE(RTRIM(LTRIM(UPPER(TC.Lastname))), NCHAR(160), '')= RTRIM(LTRIM(UPPER(bfa.Surname)))
AND REPLACE(RTRIM(LTRIM(UPPER(TC.FirstName))), NCHAR(160), '') = RTRIM(LTRIM(UPPER(bfa.FirstName)))
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