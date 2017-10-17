/* Creates initial table for Birmingham Open
Uses the rank as the primary key and table
contains the name, country and club of the
fencers*/

DROP TABLE comp_name;

CREATE TABLE comp_name (	comp_id		INT				IDENTITY(1,1),	short_name	varchar (8)		NOT NULL,	full_name	varchar (100)	NOT NULL,	file_name	varchar	(100)	NOT NULL,	PRIMARY KEY ( comp_id ));
	
INSERT INTO comp_name(short_name, full_name, file_name)
VALUES	("birm","Birmingham International Open","birm_2017_mf.csv");

SELECT short_name as comp FROM comp_name WHERE comp_id == 1;

DROP TABLE comp;

CREATE TABLE comp (	rank		INT(5)			NOT NULL,	name		varchar (100) 	NOT NULL,	country		char (3)		NOT NULL,	club		varchar (100) NOT NULL);

/* convert read mode to the .csv format */
.mode csv

.import birm_2017_mf.csv comp


