/* This query creates the rankings for the fencers based on
the top six domestic "all_results" table */

/* This command generate a basic ranking list for all fencers */
/* I believe this section is not needed - I have developed a better
method of taking into account the results and check the IDs of fencers */
/*SELECT BFA_ID, FirstName, LastName, SUM(BF_Points) AS TotalPoints, COUNT(FirstName) AS NumComp
FROM dbo.all_results AS AR
LEFT JOIN dbo.Comp AS C
ON AR.COMP_ID = C.Comp_ID
WHERE C.Date > DATEADD(year,-1,GETDATE())
GROUP BY BFA_ID, FirstName, LastName
ORDER BY TotalPoints DESC;

SELECT TOP(6) BFA_ID, FirstName, LastName
FROM dbo.all_results AS AR
LEFT JOIN dbo.Comp AS C
ON AR.COMP_ID = C.Comp_ID
WHERE C.Date > DATEADD(year,-1,GETDATE())
GROUP BY BFA_ID, FirstName, LastName; */

--SELECT * FROM dbo.all_results

/* This section starts to calculate the ranking list for
only national compeitions */
DROP TABLE #TempRes

CREATE TABLE #TempRes
(BFA_ID		INT,
COMP_ID		INT,
COMP_Rank	INT,
BF_Points	Float,
FirstName	NVARCHAR(255),
LastName	NVARCHAR(255),
Club		NVARCHAR(255)
)

/* Insert all results into temporary table so that the names and 
ID can be matched and modified without interfering with the original
results table */
INSERT INTO #TempRes
SELECT BFA_ID, COMP_ID, Comp_Rank, BF_Points, FirstName, LastName, Club
FROM dbo.all_results

/* Update #TempRes so that people with the same names but different BFA_Ids
are matched up and have the same BFA_ID */
UPDATE #TempRes
SET BFA_ID = TRtmp.BFA_ID 
FROM #TempRes AS TR
LEFT JOIN (
SELECT TR2.BFA_ID, TR2.LastName, TR2.FirstName
FROM #TempRes AS TR1
LEFT JOIN #TempRes AS TR2
ON (TR1.FirstName = TR2.FirstName
AND TR1.LastName = TR2.LastName)
LEFT JOIN dbo.Comp AS C
ON TR2.Comp_ID = C.Comp_ID
WHERE (TR2.BFA_ID IS NOT NULL AND TR1.BFA_ID IS NULL)
AND C.Date > DATEADD(year,-1,GETDATE())
GROUP BY TR1.BFA_ID, TR1.LastName, TR1.FirstName, TR2.BFA_ID, TR2.LastName, TR2.FirstName) AS TRtmp
ON TR.FirstName = TRtmp.FirstName AND TR.LastName = TRtmp.LastName
WHERE TR.BFA_ID IS NULL

/* Create table for the final ranking list */
--SELECT * FROM #TempRes
DROP TABLE #FinRes

CREATE TABLE #FinRes
(BFA_ID		INT,
LastName	NVARCHAR(255),
FirstName	NVARCHAR(255),
TotPoints	FLOAT,
NumComps	INT)

/* Chose the top six results for a fencer based on the ranking points
for each competition */
INSERT INTO #FinRes
SELECT RR.BFA_ID, RR.LastName, RR.FirstName, SUM(RR.BF_Points) AS TotPoints,  MAX(RR.rn) AS NumComps
FROM(
SELECT * 
FROM(
SELECT AR.BFA_ID, AR.LastName, AR.FirstName, AR.BF_Points, AR.COMP_ID, C.DomorInt,
       ROW_NUMBER() OVER (PARTITION BY BFA_ID, FirstName, LastName ORDER BY BF_Points DESC) AS rn
FROM #TempRes AS AR
LEFT JOIN dbo.Comp AS C
ON AR.COMP_ID = C.Comp_ID
WHERE C.Date > DATEADD(year,-1,GETDATE())) AS res
WHERE rn <= 6) AS RR
GROUP BY RR.BFA_ID, RR.LastName, RR.FirstName
ORDER BY TotPoints DESC;

/* Tidy up #FinRes to removes some "NULL" IDs */
UPDATE #FinRes
SET BFA_ID = ''
WHERE BFA_ID IS NULL

/* Make sure that the total points for a fencer is '0' instead of 'NULL' */
UPDATE #FinRes
SET TotPoints = '0'
WHERE TotPoints IS NULL

SELECT * FROM #FinRes
ORDER BY TotPoints DESC

/* Create a pivot table with a variable number of columns */

/* Create and fill variable that contains a long string
of all fo the Short Names for all of the competitions */
DECLARE @Cols NVARCHAR(MAX)

SET @Cols = STUFF((SELECT distinct ',' + QUOTENAME(ShortName)
                    from dbo.Comp
			FOR XML PATH(''), TYPE)
            .value('.', 'NVARCHAR(MAX)')
			,1,1, '')

/* This section creates the temporary table called #TmpComp. This
table is dynamically created to be able to have a variable number of
columns depending on the number of competitions in the "Short Name"
Column */

DROP TABLE #TmpComp

CREATE TABLE #TmpComp
(LastName NVARCHAR(255),
FirstName NVARCHAR(255),
BFA_ID	Float)

DECLARE @Comp INT = 0
DECLARE @TotComp INT
DECLARE @ModCols NVARCHAR(MAX)
DECLARE @TmpCols NVARCHAR(MAX)

SET @TotComp = LEN(@Cols) - LEN(REPLACE(@Cols, '[', ''))
SET @ModCols = @Cols

DECLARE @TblSQL NVARCHAR(MAX)

WHILE @Comp < @TotComp
BEGIN 
	PRINT @Comp
	IF @Comp = @TotComp - 1
		BEGIN
		PRINT @ModCols
		SET @TblSQL = 'ALTER TABLE #TmpComp
						ADD ' + @ModCols + ' NVARCHAR(50)'
		
		EXEC(@TblSQL)

		SET @Comp = @Comp + 1;
		END

	ELSE
		BEGIN
		SET @TmpCols = SUBSTRING(@ModCols, 1, 10)
		PRINT @TmpCols

		SET @TblSQL = 'ALTER TABLE #TmpComp
						ADD ' + @TmpCols + ' NVARCHAR(50)'
		
		EXEC(@TblSQL)

		SET @ModCols = SUBSTRING(@ModCols, 12, LEN(@ModCols) - 11)

		SET @Comp = @Comp + 1;
		END
END

/* This section creates a temporary table that joins the results
of fencers from different competitions with the competion name */
DROP TABLE #TmpRes

SELECT AR.LastName, AR.FirstName, AR.BFA_ID, AR.BF_Points, AR.Comp_Rank, AR.Comp_ID, C.ShortName
INTO #TmpRes
FROM #TempRes AS AR
LEFT JOIN dbo.Comp AS C
ON AR.Comp_ID = C.Comp_ID

/* This section uses are a string variable as a dynamic query to create
a pivot table with a variable number of columns. The number of columns
to determined by the number of entries in the @Cols string. This pivot table
is inserted into the table #TmpComp */
DECLARE @Query NVARCHAR(MAX)

SET @Query = 'SELECT LastName, FirstName, BFA_ID, ' + @Cols + '
			FROM
			(SELECT LastName, FirstName, BFA_ID, Comp_Rank, ShortName FROM #TmpRes) AS T

			PIVOT (MAX(T.Comp_Rank) for T.ShortName in (' + @Cols + ')) AS P'

INSERT INTO #TmpComp
EXECUTE(@Query)

/* This section removes the "NULL"s from the #TmpComp table
so that it is easier to read */
SET @Comp = 0
SET @TotComp = LEN(@Cols) - LEN(REPLACE(@Cols, '[', ''))
SET @ModCols = @Cols

WHILE @Comp < @TotComp
BEGIN 
	PRINT @Comp
	IF @Comp = @TotComp - 1
		BEGIN
		PRINT @ModCols
		SET @TblSQL = 'UPDATE #TmpComp
						SET ' + @ModCols + ' = CHAR(45)
						WHERE ' + @ModCols + ' IS NULL'
		
		EXEC(@TblSQL)

		SET @Comp = @Comp + 1;
		END

	ELSE
		BEGIN
		SET @TmpCols = SUBSTRING(@ModCols, 1, 10)
		PRINT @TmpCols

		SET @TblSQL = 'UPDATE #TmpComp
					SET ' + @TmpCols + ' = CHAR(45)
					WHERE ' + @TmpCols + ' IS NULL'
		
		EXEC(@TblSQL)

		SET @ModCols = SUBSTRING(@ModCols, 12, LEN(@ModCols) - 11)

		SET @Comp = @Comp + 1;
		END
END

SELECT * FROM #TmpComp


/* Creates Competition Table for website */
SELECT CompName AS [Competition Name],
		ShortName AS [Short Name],
		Date,
		TotalNumFencers AS [Fencers Entered],
		FencerCutOff AS [Points Cut off],
		TotNIF AS [Total NIF],
		DomOrInt AS [Domestic or International]
		 FROM Comp
WHERE Date > DATEADD(year,-1,GETDATE())