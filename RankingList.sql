/* This query creates the rankings for the fencers based on
the top six domestic "all_results" table */

/* This command generate a basic ranking list for all fencers */
SELECT BFA_ID, FirstName, LastName, SUM(BF_Points) AS TotalPoints, COUNT(FirstName)
FROM dbo.all_results
GROUP BY BFA_ID, FirstName, LastName
ORDER BY TotalPoints DESC;