UPDATE fencing_project.dbo.BFA_ID
SET FirstName = SUBSTRING(LTRIM(FirstName), 0, CHARINDEX(' ', LTRIM(FirstName))),
MidName = SUBSTRING(LTRIM(FirstName), CHARINDEX(' ', LTRIM(FirstName)), LEN(FirstName))
WHERE CHARINDEX(' ', LTRIM(FirstName)) > 0;

UPDATE fencing_project.dbo.BFA_ID
SET MidName = ' '
WHERE MidName IS NULL;

UPDATE fencing_project.dbo.BFA_ID
SET Club = 'None'
WHERE Club IS NULL

UPDATE fencing_project.dbo.BFA_ID
SET FirstName = 'Kieran'
WHERE FirstName = 'Keiran' AND Surname = 'Patrick';

UPDATE fencing_project.dbo.BFA_ID
SET FirstName = 'Jarred'
WHERE FirstName = 'Jared'
AND UPPER(Surname) = 'MITTELHOLZER';

UPDATE fencing_project.dbo.BFA_ID
SET Surname = 'Kuznetsov'
WHERE FirstName = 'Nikita'
AND UPPER(Surname) = 'KUZNETSKOV';

SELECT * FROM fencing_project.dbo.BFA_ID;

SELECT * FROM fencing_project.dbo.BFA_ID
WHERE FirstName = 'Lachlan';