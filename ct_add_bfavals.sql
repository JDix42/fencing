/* This query inserts BFA ID and NIF points 
to a competition table (ct) */
DROP VIEW BfaTemp
GO

CREATE VIEW BfaTemp (RankID, LN, FN, BFN, Bfa_ID, NifVals)

AS
--(SELECT bfa.BFA_ID, bfa.NIF_Val
--FROM dbo.birm_res_new AS ct
--LEFT JOIN dbo.BFA_ID AS bfa
--ON UPPER(ct.LastName) = UPPER(bfa.Surname))
(SELECT ct.Rank, ct.LastName, ct.Firstname, bfa.FirstName AS BfaName, bfa.BFA_ID, bfa.NIF_Val
FROM dbo.birm_res_new AS CT
LEFT JOIN dbo.BFA_ID as BFA
ON UPPER(ct.Lastname) = UPPER(bfa.Surname)
AND LTRIM(UPPER(ct.FirstName)) = LTRIM(UPPER(bfa.FirstName)))

GO

DELETE FROM BfaTemp
WHERE BFA_ID in
/* Determine BFA ID and Position in ranking based on first and last names*/
(SELECT BFA.BFA_ID as DelID 
FROM dbo.BFA_ID AS BFA
LEFT JOIN 
(SELECT DupNames.FirstName, DupNames.LastName, MAX(BFA.PosID) AS DeleteID
FROM
/* Determine any names where that are duplicated in the table */
(SELECT BfaT.FN AS FirstName, BfaT.LN As LastName, COUNT(BfaT.LN) AS Replicas
FROM BfaTemp AS BfaT
GROUP BY BfaT.FN, BfaT.LN
HAVING COUNT(BfaT.LN) >= 2 AND COUNT(BfaT.FN) >= 2) AS DupNames
LEFT JOIN BFA_ID AS BFA
ON DupNames.LastName = BFA.Surname AND DupNames.FirstName = BFA.FirstName
GROUP BY DupNames.LastName, DupNames.FirstName) AS DelList
ON BFA.PosID = DelList.DeleteID
WHERE DelList.FirstName IS NOT NULL);
GO
/* TEST for whether Surnames do still exist in BFA ID database
SELECT * FROM BFA_ID
JOIN (SELECT LN, FN 
FROM BfaTemp
WHERE BFA_ID IS NULL) AS LastNameTemp
ON BFA_ID.Surname = LastNameTemp.LN; */

/* TEST for whether FirstNames do still exist in BFA ID database 
with a plausable Surname
SELECT * FROM BFA_ID
JOIN (SELECT LN, FN 
FROM BfaTemp
WHERE BFA_ID IS NULL) AS LastNameTemp
ON BFA_ID.FirstName = LastNameTemp.FN
WHERE LEFT(BFA_ID.SurName, 1) = LEFT(LastNameTemp.LN, 1); */


SELECT * 
FROM BfaTemp
ORDER BY RankID;


INSERT INTO dbo.birm_res_new(BFA_ID, BF_points)
SELECT Bfa_ID, NifVals
FROM BfaTemp ;

SELECT * 
FROM dbo.birm_res_new;
