/* This query inserts BFA ID and NIF points 
to a competition table (ct) */

WITH BfaTemp (RankID, LN, FN, BFN, Bfa_ID, NifVals)

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
