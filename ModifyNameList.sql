SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName), LEN(LastName)) AS FirstName,
		SUBSTRING(LastName, 0, CHARINDEX(' ', LastName) - 1) AS LastName
FROM dbo.TempComp

SELECT * FROM dbo.TempComp

SELECT * FROM dbo.Comp

UPDATE dbo.TempComp
SET FirstName = SUBSTRING(LastName, CHARINDEX(',', LastName) + 1, LEN(LastName)) 

UPDATE dbo.TempComp
SET LastName = SUBSTRING(LastName, 0, CHARINDEX(',', LastName)) 

TRUNCATE TABLE dbo.TempComp

SELECT * FROM dbo.all_results
ORDER BY COMP_ID

UPDATE dbo.TempComp
SET Country = 'ITA'
WHERE REPLACE(RTRIM(LTRIM(Country)), NCHAR(160), '') = 'IT'

SELECT * FROM dbo.BFA_IDMar2017
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'CHRIS'

SELECT REPLACE(UPPER(LastName), NCHAR(160), '')
FROM dbo.TempComp
WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ROBERT'
AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'WILLIAMS'

SELECT * FROM BFA_IDMar2017

UPDATE dbo.BFA_IDMar2017
SET FirstName = SUBSTRING(LTRIM(FirstName), 0, CHARINDEX(' ', LTRIM(FirstName))),
MidName = SUBSTRING(LTRIM(FirstName), CHARINDEX(' ', LTRIM(FirstName)), LEN(FirstName))
WHERE CHARINDEX(' ', LTRIM(FirstName)) > 0;

DELETE dbo.TempComp
WHERE FencerID = 16
