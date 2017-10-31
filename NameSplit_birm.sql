UPDATE fencing_project.dbo.birm_res_new
SET FirstName = SUBSTRING(LTRIM(FirstName), 0, CHARINDEX(' ', LTRIM(FirstName))),
MidName = SUBSTRING(LTRIM(FirstName), CHARINDEX(' ', LTRIM(FirstName)), LEN(FirstName))
WHERE CHARINDEX(' ', LTRIM(FirstName)) > 0;

UPDATE fencing_project.dbo.birm_res_new
SET FirstName = LTRIM(FirstName);

UPDATE fencing_project.dbo.birm_res_new
SET FirstName = 'Nicholas'
WHERE FirstName = 'Nick'
AND (UPPER(LastName) = 'MORT' OR UPPER(LastName) = 'DOOTSON');

UPDATE fencing_project.dbo.birm_res_new
SET FirstName = 'Joshua'
WHERE FirstName = 'Josh'
AND (UPPER(LastName) = 'BURN');

UPDATE fencing_project.dbo.birm_res_new
SET FirstName = 'Daniel'
WHERE FirstName = 'Dan'
AND (UPPER(LastName) = 'ELLIKER');

UPDATE fencing_project.dbo.birm_res_new
SET FirstName = 'Kevin'
WHERE FirstName = 'Kev'
AND (UPPER(LastName) = 'MILNE');

UPDATE fencing_project.dbo.birm_res_new
SET LastName = 'DE LANGE'
WHERE UPPER(LastName) = 'DE LANG'
AND (UPPER(FirstName) = 'KIERAN')

SELECT * FROM fencing_project.dbo.birm_res_new;