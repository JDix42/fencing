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

UPDATE dbo.TempComp
SET Country = 'GBR'
WHERE REPLACE(RTRIM(LTRIM(Country)), NCHAR(160), '') = 'UK'

SELECT REPLACE(UPPER(LastName), NCHAR(160), '')
FROM dbo.TempComp
WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'VAN-AARSE'
AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'GEERT'