/* Modify international names so that there is one last name,
one middle name and one first name. All other names are treated
as "OtherNames".

The LastName is the Last name written in full capitals.
The FirstName is the First name written in both lower and upper
case.
The middle name is either the second name written in lower and upper
case OR the first name written in full capitals. */

/* Create temporary table to transfer internation results to */
DROP TABLE #IntRes

CREATE TABLE #IntRes (
LastName NVARCHAR(255))

INSERT INTO #IntRes(LastName)
SELECT LastName 
FROM dbo.IntRank_Sept2017


/* This section separates names when there is only one name in capital
letters and one name with both lower and upper case letters */
UPDATE dbo.IntRank_Sept2017
SET FirstName = Name.FirstName,
LastName = Name.LN
FROM dbo.IntRank_Sept2017 AS IntRank
LEFT JOIN (SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FirstName,
		SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
		LastName
		FROM #IntRes
		WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 1) AS Name
ON IntRank.LastName = Name.LastName
WHERE (LEN(IntRank.LastName) -LEN(REPLACE(IntRank.LastName, ' ', ''))) = 1


/* This section separates the names where there are two names in 
full capitals */
UPDATE dbo.IntRank_Sept2017
SET LastName = Name.FrontName,
FirstName = Name.FirstName,
MidName = Name.LN
FROM dbo.IntRank_Sept2017 AS IntRank
LEFT JOIN (
SELECT Name.FrontName, Name.TotName, Name.LN, Name.FirstName
FROM (SELECT MainName.FN, MainName.LN, MainName.TotName,
		SUBSTRING(MainName.FN, 0, CHARINDEX(' ', MainName.FN)) AS FrontName,
		SUBSTRING(MainName.FN, CHARINDEX(' ', MainName.FN) + 1, LEN(MainName.FN)) AS FirstName
FROM (SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FN,
	SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
	LastName AS TotName
	FROM #IntRes
	WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 2) AS MainName) AS Name) AS Name
ON IntRank.LastName = Name.TotName
WHERE UPPER(Name.FrontName) = Name.FrontName COLLATE Latin1_General_CS_AI

/* This section splits up names where there are two names in upper and lower case
and a name in full capital letters */
UPDATE dbo.IntRank_Sept2017
SET LastName = Name.LN,
FirstName = Name.FrontName,
MidName = Name.FirstName
FROM dbo.IntRank_Sept2017 AS IntRank
LEFT JOIN (
SELECT Name.FrontName, Name.TotName, Name.LN, Name.FirstName
FROM (SELECT MainName.FN, MainName.LN, MainName.TotName,
		SUBSTRING(MainName.FN, 0, CHARINDEX(' ', MainName.FN)) AS FrontName,
		SUBSTRING(MainName.FN, CHARINDEX(' ', MainName.FN) + 1, LEN(MainName.FN)) AS FirstName
FROM (SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FN,
	SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
	LastName AS TotName
	FROM #IntRes
	WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 2) AS MainName) AS Name) AS Name
ON IntRank.LastName = Name.TotName
WHERE UPPER(Name.FrontName) != Name.FrontName COLLATE Latin1_General_CS_AI

/* This section splits up the name when there are two names with capitals letters and 
two names with a combination of lower and upper case letters */
UPDATE dbo.IntRank_Sept2017
SET LastName = Name.FrontName,
FirstName = Name.FirstName1,
MidName = Name.LN,
OtherNames = FirstName2
FROM dbo.IntRank_Sept2017 AS IntRank
LEFT JOIN (
SELECT Name.FrontName, Name.TotName, Name.LN,
		SUBSTRING(Name.FirstName, 0, CHARINDEX(' ', Name.FirstName)) AS FirstName1,
		SUBSTRING(Name.FirstName, CHARINDEX(' ', Name.FirstName) + 1, LEN(Name.FirstName)) AS FirstName2
FROM (SELECT MainName.FN, MainName.LN, MainName.TotName,
		SUBSTRING(MainName.FN, 0, CHARINDEX(' ', MainName.FN)) AS FrontName,
		SUBSTRING(MainName.FN, CHARINDEX(' ', MainName.FN) + 1, LEN(MainName.FN)) AS FirstName
FROM (SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FN,
	SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
	LastName AS TotName
	FROM #IntRes
	WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 3) AS MainName) AS Name) AS Name
ON IntRank.LastName = Name.TotName
WHERE UPPER(Name.FrontName) = Name.FrontName COLLATE Latin1_General_CS_AI

/* This section splits up the names where there is one name in all captal letters
and three names with a combination of lower and upper case letters */
UPDATE dbo.IntRank_Sept2017
SET LastName = Name.LN,
FirstName = Name.FrontName,
MidName = Name.FirstName2,
OtherNames = Name.FirstName1
FROM dbo.IntRank_Sept2017 AS IntRank
LEFT JOIN (
SELECT Name.FrontName, Name.TotName, Name.LN,
		SUBSTRING(Name.FirstName, 0, CHARINDEX(' ', Name.FirstName)) AS FirstName1,
		SUBSTRING(Name.FirstName, CHARINDEX(' ', Name.FirstName) + 1, LEN(Name.FirstName)) AS FirstName2
FROM (SELECT MainName.FN, MainName.LN, MainName.TotName,
		SUBSTRING(MainName.FN, 0, CHARINDEX(' ', MainName.FN)) AS FrontName,
		SUBSTRING(MainName.FN, CHARINDEX(' ', MainName.FN) + 1, LEN(MainName.FN)) AS FirstName
FROM (SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FN,
	SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
	LastName AS TotName
	FROM #IntRes
	WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 3) AS MainName) AS Name) AS Name
ON IntRank.LastName = Name.TotName
WHERE UPPER(Name.FrontName) != Name.FrontName COLLATE Latin1_General_CS_AI

/* This section splits up names where there is one name with capital letters and four names
with a combination of lower and upper case letters */
UPDATE dbo.IntRank_Sept2017
SET LastName = Name.LN,
FirstName = Name.FrontName,
MidName = Name.FirstName1,
OtherNames = Name.FirstName2
FROM dbo.IntRank_Sept2017 AS IntRank
LEFT JOIN (
SELECT Name.FrontName, Name.TotName, Name.LN,
		SUBSTRING(Name.FirstName, 0, CHARINDEX(' ', Name.FirstName)) AS FirstName1,
		SUBSTRING(Name.FirstName, CHARINDEX(' ', Name.FirstName) + 1, LEN(Name.FirstName)) AS FirstName2
FROM (SELECT MainName.FN, MainName.LN, MainName.TotName,
		SUBSTRING(MainName.FN, 0, CHARINDEX(' ', MainName.FN)) AS FrontName,
		SUBSTRING(MainName.FN, CHARINDEX(' ', MainName.FN) + 1, LEN(MainName.FN)) AS FirstName
FROM (SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FN,
	SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
	LastName AS TotName
	FROM #IntRes
	WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 4) AS MainName) AS Name) AS Name
ON IntRank.LastName = Name.TotName
WHERE UPPER(Name.FrontName) != Name.FrontName COLLATE Latin1_General_CS_AI

/* Add NIF values to fencers based on their world ranking
The NIF values associated with world rankings are:
20 : 1 - 20
12 : 21 - 40
6  : 41 - 100
3  : 101 - 200
1  : > 200 and have non zero FIE points */
UPDATE dbo.IntRank_Sept2017
SET NifVals = '20'
WHERE Rank < 21

UPDATE dbo.IntRank_Sept2017
SET NifVals = '12'
WHERE Rank > 20 AND Rank < 41

UPDATE dbo.IntRank_Sept2017
SET NifVals = '6'
WHERE Rank > 40 AND Rank < 101

UPDATE dbo.IntRank_Sept2017
SET NifVals = '3'
WHERE Rank > 100 AND Rank < 201
AND Points > 0

UPDATE dbo.IntRank_Sept2017
SET NifVals = '1'
WHERE Rank > 200 AND Points > 0

UPDATE dbo.IntRank_Sept2017
SET NifVals = '0'
WHERE Rank > 200 AND Points = 0