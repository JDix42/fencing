/* Note - this is a set of commands to make debugging/checking 
that the database is correct easier. DO NOT run the whole script */

SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName), LEN(LastName)) AS FirstName,
		SUBSTRING(LastName, 0, CHARINDEX(' ', LastName) - 1) AS LastName
FROM dbo.TempComp

SELECT * FROM dbo.TempComp

SELECT * FROM dbo.Comp
ORDER BY Date;

UPDATE dbo.TempComp
SET BF_Points = NULL
WHERE BF_Points = '0'

/* Split names where LastName is first separated by ', ' */
UPDATE dbo.TempComp
SET FirstName = SUBSTRING(LastName, CHARINDEX(',', LastName) + 1, LEN(LastName)) 

UPDATE dbo.TempComp
SET LastName = SUBSTRING(LastName, 0, CHARINDEX(',', LastName)) 

/* Split names where FirstName is first separated by ' ' */
UPDATE dbo.TempComp
SET LastName = SUBSTRING(FirstName, CHARINDEX(' ', FirstName) + 1, LEN(FirstName)) 

UPDATE dbo.TempComp
SET FirstName = SUBSTRING(FirstName, 0, CHARINDEX(' ', FirstName)) 

/* Removing vetren's and caddet's symbols from results */
UPDATE dbo.TempComp
SET LastName = REPLACE(LastName, '[V]', '')
WHERE LastName LIKE '%[V]%'

UPDATE dbo.TempComp
SET LastName = REPLACE(LastName, '[C]', '') FROM dbo.TempComp
WHERE LastName LIKE '%[C]%'


/* Removing results in TempComp table */
TRUNCATE TABLE dbo.TempComp

/* */
SELECT * FROM dbo.all_results
ORDER BY COMP_ID

/* Change countries where only the first two letters have imported */
UPDATE dbo.TempComp
SET Country = 'GBR'
WHERE REPLACE(RTRIM(LTRIM(Country)), NCHAR(160), '') = 'GB'

/* */
SELECT * FROM dbo.BFA_IDMar2017
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'CHRIS'

SELECT REPLACE(UPPER(FirstName), NCHAR(160), '')
FROM dbo.TempComp
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ROSS'
AND REPLACE(RTRIM(LTRIM(UPPER(LastName))),NCHAR(160), '') = 'HENDERSONNBSP;'

SELECT * FROM BFA_IDMar2017

UPDATE dbo.BFA_IDMar2017
SET FirstName = SUBSTRING(LTRIM(FirstName), 0, CHARINDEX(' ', LTRIM(FirstName))),
MidName = SUBSTRING(LTRIM(FirstName), CHARINDEX(' ', LTRIM(FirstName)), LEN(FirstName))
WHERE CHARINDEX(' ', LTRIM(FirstName)) > 0;

/* Remove individual lines based on the fencer ID */
DELETE dbo.TempComp
WHERE FencerID = 28
/* */

UPDATE dbo.BFA_IDSept2016
SET BFA_ID = '95955'
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'DANIEL'
AND REPLACE(RTRIM(LTRIM(UPPER(Surname))), NCHAR(160), '') = 'ELLIKER' 

UPDATE dbo.TempComp
SET BFA_ID = NULL
WHERE BFA_ID = '133155'

SELECT * FROM dbo.BFA_IDSept2016
WHERE BFA_ID = '131069'

SELECT * FROM dbo.BFA_IDSept2016
WHERE REPLACE(RTRIM(LTRIM(UPPER(Surname))), NCHAR(160), '') = 'LIM'

SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FirstName,
SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LastName,
SUBSTRING(FirstName, CHARINDEX(' ', FirstName) + 1, LEN(FirstName)) AS SecName,
SUBSTRING(FirstName, 0, CHARINDEX(' ', FirstName)) AS MidName 
FROM dbo.IntRank_Sept2016

SELECT SUBSTRING(FN.FirstName, 0, CHARINDEX(' ', FN.FirstName)) AS Name
FROM (SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FirstName
FROM dbo.IntRank_Sept2016) AS FN;

SELECT LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))
FROM dbo.IntRank_Sept2016

SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FirstName,
SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN
FROM dbo.IntRank_Sept2016
WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 1

SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FN,
SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
FROM dbo.IntRank_Sept2016
WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 2

SELECT Name.FrontName, IR.LastName
FROM (SELECT MainName.FN, MainName.LN, MainName.TotName,
		SUBSTRING(MainName.FN, 0, CHARINDEX(' ', MainName.FN)) AS FrontName
FROM (SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FN,
	SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
	LastName AS TotName
	FROM dbo.IntRank_Sept2016
	WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 2) AS MainName) AS Name
LEFT JOIN dbo.IntRank_Sept2016 AS IR
ON Name.TotName = IR.LastName
WHERE UPPER(Name.FrontName) = Name.FrontName COLLATE Latin1_General_CS_AI


SELECT LastName 
FROM 