/* Note - this is a set of commands to make debugging/checking 
that the database is correct easier. DO NOT run the whole script */

SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName), LEN(LastName)) AS FirstName,
		SUBSTRING(LastName, 0, CHARINDEX(' ', LastName) - 1) AS LastName
FROM dbo.TempComp

TRUNCATE TABLE dbo.TempComp

SELECT * FROM dbo.TempComp

TRUNCATE TABLE dbo.TempOneCol
SELECT * FROM dbo.TempOneCol

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
SET Country = 'IRL'
WHERE REPLACE(RTRIM(LTRIM(Country)), NCHAR(160), '') = 'IR'

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
WHERE FencerID = 80
/* */

UPDATE dbo.Comp
SET Category = 'SMF';

SELECT * FROM dbo.Comp

SELECT * FROM dbo.all_results;

UPDATE dbo.BFA_IDSept2016
SET BFA_ID = '95955'
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'DANIEL'
AND REPLACE(RTRIM(LTRIM(UPPER(Surname))), NCHAR(160), '') = 'ELLIKER' 

UPDATE dbo.TempComp
SET Country = 'GER'
WHERE FencerID = 29

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
SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
LastName
FROM dbo.IntRank_Sept2016
WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 1

SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FN,
SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
LastName
FROM dbo.IntRank_Sept2016
WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 3

SELECT * FROM dbo.IntRank_Sept2017

SELECT * FROM dbo.IntRank_Sept2016 AS IR
RIGHT JOIN dbo.TempComp AS TC
ON REPLACE(LTRIM(RTRIM(TC.LastName)), CHAR(160), '') = REPLACE(LTRIM(RTRIM(IR.LastName)), CHAR(160), '')
AND REPLACE(LTRIM(RTRIM(TC.FirstName)), CHAR(160), '') = REPLACE(LTRIM(RTRIM(IR.FirstName)), CHAR(160), '')
WHERE IR.Country != 'GBR'

SELECT DISTINCT Comb.LastName, Comb.FirstName, Comb.Country
FROM (
SELECT LastName, FirstName, Country
FROM dbo.IntRank_Sept2017
UNION ALL 
SELECT LastName, FirstName, Country
FROM dbo.IntRank_Sept2016) AS Comb

SELECT * FROM dbo.IntRank_Sept

SELECT * FROM dbo.TempComp

UPDATE dbo.Comp
SET ShortName = 'AmstrSat'
WHERE Comp_ID = 47
