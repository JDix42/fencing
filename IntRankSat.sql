/* This script determines the NIF value for a competition based 
firstly on the number of world ranked fencers in the competition
and secondly on the NIF values of UK fencers that have entered 
the competition */

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

/* Determine number of fencers in competition */
DECLARE @FenNum INT = (SELECT TotalNumFencers FROM dbo.Comp WHERE Comp_ID = @CompID )

/* Ensure that previous attemps to update BFA_ID and BF_points
have been removed and changed to NULL */
UPDATE dbo.TempComp
SET BFA_ID = NULL, BF_points = NULL

/* Determine fencers who have world rankings based on their first and Last names */
UPDATE dbo.TempComp
SET BF_points = IR.NifVals
FROM dbo.TempComp AS TC
LEFT JOIN #INT_RES AS IR
ON (TC.FirstName = IR.FirstName
AND TC.LastName = IR.LastName)

/* Change NIF values -satelites are different to national competitions with the
same fencers attending */
/* Change NIF = 20 -> NIF = 30 */
UPDATE dbo.TempComp
SET BF_points = '30'
FROM dbo.TempComp
WHERE BF_points = 20

/* Change NIF = 12 -> NIF = 15 */
UPDATE dbo.TempComp
SET BF_points = '15'
FROM dbo.TempComp
WHERE BF_points = 12

/* Change NIF = 6 -> NIF = 5 */
UPDATE dbo.TempComp
SET BF_points = '5'
FROM dbo.TempComp
WHERE BF_points = 6

/* Set BF_points where NULL to zero */
UPDATE dbo.TempComp
SET BF_points = '0'
FROM dbo.TempComp
WHERE BF_points IS NULL

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
ON REPLACE(RTRIM(LTRIM(UPPER(TC.Lastname))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(bfa.Surname))), NCHAR(160), '')
AND REPLACE(RTRIM(LTRIM(UPPER(TC.FirstName))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(bfa.FirstName))), NCHAR(160), '') ;

/* Update values for BFA_ID */
UPDATE dbo.TempComp
SET BFA_ID = BfaT.BFA_ID
FROM dbo.TempComp AS TC
LEFT JOIN #BTemp AS BfaT
ON (REPLACE(RTRIM(LTRIM(UPPER(TC.LastName))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(BfaT.LN))), NCHAR(160), '')
AND REPLACE(RTRIM(LTRIM(UPPER(TC.FirstName))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(BfaT.FN))), NCHAR(160), ''))

/* Update values for BF_points where they are larger than the 
ranking points from the international results*/
UPDATE dbo.TempComp
SET BF_points = BfaT.NifVals
FROM dbo.TempComp AS TC
LEFT JOIN #BTemp AS BfaT
ON (REPLACE(RTRIM(LTRIM(UPPER(TC.LastName))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(BfaT.LN))), NCHAR(160), '')
AND REPLACE(RTRIM(LTRIM(UPPER(TC.FirstName))), NCHAR(160), '') = REPLACE(RTRIM(LTRIM(UPPER(BfaT.FN))), NCHAR(160), ''))
WHERE TC.BF_points < BfaT.NifVals

/* Sum up NIF Values */
SELECT SUM(BF_points)
FROM dbo.TempComp

