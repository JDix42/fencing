SELECT SUBSTRING(LastName, CHARINDEX(' ', LastName), LEN(LastName)) AS FirstName,
		SUBSTRING(LastName, 0, CHARINDEX(' ', LastName) - 1) AS LastName
FROM dbo.TempComp

SELECT * FROM dbo.TempComp

UPDATE dbo.TempComp
SET FirstName = SUBSTRING(LastName, CHARINDEX(' ', LastName), LEN(LastName)) 

UPDATE dbo.TempComp
SET LastName = SUBSTRING(LastName, 0, CHARINDEX(' ', LastName) - 1) 

TRUNCATE TABLE dbo.TempComp

SELECT * FROM dbo.all_results