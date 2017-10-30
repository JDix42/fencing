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
ON LEFT(UPPER(ct.Lastname), 5) = LEFT(UPPER(bfa.Surname), 5)
AND LEFT(LTRIM(UPPER(ct.FirstName)), 3) = LEFT( LTRIM(UPPER(bfa.FirstName)), 3)
ORDER BY ct.Rank)

SELECT * 
FROM BfaTemp
ORDER BY RankID

INSERT INTO dbo.birm_res_new(BFA_ID, BF_points)
SELECT Bfa_ID, NifVals
FROM BfaTemp ;

SELECT * 
FROM dbo.birm_res_new;
