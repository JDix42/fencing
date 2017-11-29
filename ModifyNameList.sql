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

UPDATE dbo.TempComp
SET FirstName = SUBSTRING(LastName, CHARINDEX(',', LastName) + 1, LEN(LastName)) 

UPDATE dbo.TempComp
SET LastName = SUBSTRING(LastName, 0, CHARINDEX(',', LastName)) 

UPDATE dbo.TempComp
SET LastName = REPLACE(LastName, '(V)', '')
WHERE LastName LIKE '%(V)'

SELECT REPLACE(LastName, '(C)', '') FROM dbo.TempComp
WHERE LastName LIKE '%(_)'

TRUNCATE TABLE dbo.TempComp

SELECT * FROM dbo.all_results
ORDER BY COMP_ID

UPDATE dbo.TempComp
SET Country = 'IRL'
WHERE REPLACE(RTRIM(LTRIM(Country)), NCHAR(160), '') = 'IR'

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

DELETE dbo.TempComp
WHERE FencerID = 74

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