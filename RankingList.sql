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

INSERT INTO #TempRes
SELECT BFA_ID, COMP_ID, Comp_Rank, BF_Points, FirstName, LastName, Club
FROM dbo.all_results

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

--SELECT * FROM #TempRes
DROP TABLE #FinRes

CREATE TABLE #FinRes
(BFA_ID		INT,
LastName	NVARCHAR(255),
FirstName	NVARCHAR(255),
TotPoints	FLOAT,
NumComps	INT)

INSERT INTO #FinRes
SELECT RR.BFA_ID, RR.LastName, RR.FirstName, SUM(RR.BF_Points) AS TotPoints, MAX(RR.rn) AS NumComps
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

UPDATE #FinRes
SET BFA_ID = ''
WHERE BFA_ID IS NULL

UPDATE #FinRes
SET TotPoints = '0'
WHERE TotPoints IS NULL

SELECT * FROM #FinRes
ORDER BY TotPoints DESC

