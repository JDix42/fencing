/* This script transfers a set of results where each
line contains all of the result informatoin into individual
entries where the names, rank and country are split into
separate columns.

The input data has the form:
Rank | FIE points | Names | Country | DoB | */

/* Clear temporary results table */
TRUNCATE TABLE dbo.TempComp 

/* Insert new results into results table. This section
Adds the Rank, Country and all the names as "LastName"

The names will be subsequently split up into individual 
names, likes with the international rankings list */
INSERT INTO dbo.TempComp(LastName, Country, Rank)
/* This step removes extra spaces at the start of the Names section */
SELECT SUBSTRING(Set1.Names, CHARINDEX(' ',Set1.Names) + 1, LEN(Set1.Names)) As LastNames,
			Set1.Country,
			Set1.Rank
		/* This determines the names and the countries of the fencers */
FROM (SELECT SUBSTRING(Set0.Temp, CHARINDEX(' ', Set0.Temp) + 1, LEN(Set0.Temp) - 4 ) AS Names,
			REPLACE(LTRIM(RTRIM(SUBSTRING(Set0.Temp, LEN(Set0.Temp) - 3, LEN(Set0.Temp)))), NCHAR(160), '') AS Country,
			Set0.Rank

/* This SELECT removes the DOB by changing the numbers and "." into
nothing */
FROM (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
			Temp, '.', ''), '1', ''), '2', ''), '3', ''), '4', ''), '5', ''), '6', ''), '7', '')
			, '8', ''), '9', ''), '0', '') AS Temp,
			/* This splits out the rank of the fencer */
			SUBSTRING(dbo.TempOneCol.Temp, 0, CHARINDEX(' ', dbo.TempOneCol.Temp) + 1) AS Rank
FROM dbo.TempOneCol) AS Set0 ) AS Set1

/* Splits of names where there is one name in all capitals and 
one name in upper and lower case */
UPDATE dbo.TempComp
SET LastName = Name.LN,
	FirstName= Name.FirstName
FROM dbo.TempComp AS TC1
LEFT JOIN (SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FirstName,
		SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
		LastName
		FROM dbo.TempComp AS TC2
		WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 1) AS Name
ON TC1.LastName = Name.LastName
WHERE (LEN(TC1.LastName) -LEN(REPLACE(TC1.LastName, ' ', ''))) = 1

/* This section separate the names when there are two names in full capitals */
UPDATE dbo.TempComp
SET LastName = Name.FrontName,
FirstName = Name.FirstName,
MidName = Name.LN
FROM dbo.TempComp AS TC1
LEFT JOIN (
SELECT Name.FrontName, Name.TotName, Name.LN, Name.FirstName
FROM (SELECT MainName.FN, MainName.LN, MainName.TotName,
		SUBSTRING(MainName.FN, 0, CHARINDEX(' ', MainName.FN)) AS FrontName,
		SUBSTRING(MainName.FN, CHARINDEX(' ', MainName.FN) + 1, LEN(MainName.FN)) AS FirstName
FROM (SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FN,
	SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
	LastName AS TotName
	FROM dbo.TempComp AS TC2
	WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 2) AS MainName) AS Name) AS Name
ON TC1.LastName = Name.TotName
WHERE UPPER(Name.FrontName) = Name.FrontName COLLATE Latin1_General_CS_AI

/* This section splits up names where there are two names in upper and lower case
and a name in full capital letters */
UPDATE dbo.TempComp
SET LastName = Name.LN,
FirstName = Name.FrontName,
MidName = Name.FirstName
FROM dbo.TempComp AS TC1
LEFT JOIN (
SELECT Name.FrontName, Name.TotName, Name.LN, Name.FirstName
FROM (SELECT MainName.FN, MainName.LN, MainName.TotName,
		SUBSTRING(MainName.FN, 0, CHARINDEX(' ', MainName.FN)) AS FrontName,
		SUBSTRING(MainName.FN, CHARINDEX(' ', MainName.FN) + 1, LEN(MainName.FN)) AS FirstName
FROM (SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName) + 1, LEN(LastName)) AS FN,
	SUBSTRING(LastName, 0, CHARINDEX(' ', LastName)) AS LN,
	LastName AS TotName
	FROM dbo.TempComp AS TC2
	WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 2) AS MainName) AS Name) AS Name
ON TC1.LastName = Name.TotName
WHERE UPPER(Name.FrontName) != Name.FrontName COLLATE Latin1_General_CS_AI

/* This section splits up the name when there are two names with capitals letters and 
two names with a combination of lower and upper case letters */
UPDATE dbo.TempComp
SET LastName = Name.FrontName,
FirstName = Name.FirstName1,
MidName = FirstName2 + ' ' + Name.LN
FROM dbo.TempComp AS TC1
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
	FROM TempComp
	WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 3) AS MainName) AS Name) AS Name
ON TC1.LastName = Name.TotName
WHERE UPPER(Name.FrontName) = Name.FrontName COLLATE Latin1_General_CS_AI

/* This section splits up the names where there is one name in all captal letters
and three names with a combination of lower and upper case letters */
UPDATE dbo.TempComp
SET LastName = Name.LN,
FirstName = Name.FrontName,
MidName = Name.FirstName1 + ' ' + Name.FirstName2
FROM dbo.TempComp AS TC1
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
	FROM dbo.TempComp
	WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 3) AS MainName) AS Name) AS Name
ON TC1.LastName = Name.TotName
WHERE UPPER(Name.FrontName) != Name.FrontName COLLATE Latin1_General_CS_AI

/* This section splits up names where there is one name with capital letters and four names
with a combination of lower and upper case letters */
UPDATE dbo.TempComp
SET LastName = Name.LN,
FirstName = Name.FrontName,
MidName = Name.FirstName1 + ' ' + Name.FirstName2
FROM dbo.TempComp AS TC1
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
	FROM dbo.TempComp
	WHERE (LEN(LastName) - LEN(REPLACE(LastName, ' ', ''))) = 4) AS MainName) AS Name) AS Name
ON TC1.LastName = Name.TotName
WHERE UPPER(Name.FrontName) != Name.FrontName COLLATE Latin1_General_CS_AI