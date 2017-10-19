INSERT INTO fencing_project.dbo.birm_res_new(Rank, LastName, FirstName, Country, Club)
SELECT F1, F4, F5, F8, F11
FROM fencing_project.dbo.birm_2017_mf_mod$;

SELECT COUNT(FencerID), Club FROM fencing_project.dbo.birm_res_new
GROUP BY Club;

SELECT * FROM fencing_project.dbo.birm_res_new;

DELETE FROM fencing_project.dbo.birm_res_new
WHERE FencerID > 117;