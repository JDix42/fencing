/* Remove table if already exists */
DROP TABLE dbo.all_results

/* Create new table */
CREATE TABLE dbo.all_results (
BFA_ID		INT,
COMP_ID		INT,
COMP_Rank	FLOAT,
BF_Points	FLOAT
);


/* Add new data into results table */
