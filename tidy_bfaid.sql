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

SELECT BFA1.BFA_ID, BFA1.Surname, BFA1.FirstName, BFA1.Country, BFA1.Club, BFA1.NIF_Val 
FROM fencing_project.dbo.BFA_IDMar2017 AS BFA1
JOIN fencing_project.dbo.BFA_IDMar2017 AS BFA2
ON BFA1.Surname = BFA2.Surname AND BFA1.FirstName = BFA2.FirstName
WHERE BFA1.BFA_ID != BFA2.BFA_ID
ORDER BY BFA1.Surname;

UPDATE fencing_project.dbo.BFA_IDMar2017
SET Surname = 'Kuznetsov'
WHERE FirstName = 'Nikita'
AND UPPER(Surname) = 'KUZNETSKOV';

UPDATE fencing_project.dbo.BFA_IDMar2017
SET Club = 'None'
WHERE Club IS NULL

UPDATE fencing_project.dbo.BFA_IDMar2017
SET FirstName = 'Kieran'
WHERE FirstName = 'Keiran' AND Surname = 'Patrick';

UPDATE fencing_project.dbo.BFA_IDMar2017
SET FirstName = 'Jarred'
WHERE FirstName = 'Jared'
AND UPPER(Surname) = 'MITTELHOLZER';

UPDATE fencing_project.dbo.BFA_IDSept2016
SET Surname = 'Kuznetsov'
WHERE FirstName = 'Nikita'
AND UPPER(Surname) = 'KUZNETSKOV';

UPDATE fencing_project.dbo.BFA_IDSept2016
SET Club = 'None'
WHERE Club IS NULL

UPDATE fencing_project.dbo.BFA_IDSept2016
SET FirstName = 'Kieran'
WHERE FirstName = 'Keiran' AND Surname = 'Patrick';

UPDATE fencing_project.dbo.BFA_IDSept2016
SET FirstName = 'Jarred'
WHERE FirstName = 'Jared'
AND UPPER(Surname) = 'MITTELHOLZER';