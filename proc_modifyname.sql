USE [fencing_project]
GO
/****** Object:  StoredProcedure [dbo].[uspname_modify]    Script Date: 25/11/2017 12:28:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[uspname_modify]
AS 
	UPDATE fencing_project.dbo.TempComp
	SET FirstName = SUBSTRING(LTRIM(FirstName), 0, CHARINDEX(' ', LTRIM(FirstName))),
	MidName = SUBSTRING(LTRIM(FirstName), CHARINDEX(' ', LTRIM(FirstName)), LEN(FirstName))
	WHERE CHARINDEX(' ', LTRIM(FirstName)) > 0;

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = LTRIM(FirstName);

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Nicholas'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'Nick'
	AND (REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'MORT' 
	OR REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'DOOTSON');
	
	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Joshua'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'JOSH'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'BURN';

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Daniel'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'DAN'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'ELLIKER';

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Kevin'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'KEV'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'MILNE';

	UPDATE fencing_project.dbo.TempComp
	SET LastName = 'DE LANGE'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'DE LANG'
	AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'KIERAN'

	UPDATE fencing_project.dbo.TempComp
	SET LastName = 'WOOLLARD'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'WOOLARD'
	AND	REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'JONATHAN'

	UPDATE fencing_project.dbo.TempComp
	SET LastName = 'MARROQUÍN'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '')  = 'MARROQUIN'
	AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'DIEGO'

	UPDATE fencing_project.dbo.TempComp
	SET LastName = 'MACCHIAROLA',
	FirstName = 'ALESSANDRO'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '')  = 'MACHIAROLA'
	AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ALLESSANDRO'

	UPDATE fencing_project.dbo.TempComp
	SET	FirstName = 'Dominic'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'DE ALMEIDA'
	AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'DOMINC'

	UPDATE fencing_project.dbo.TempComp
	SET LastName ='VAN AARSEN'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'VAN-AARSE'
	AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'GEERT'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName ='Tony'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'BARTLETT'
	AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ANTHONY'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'James'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'DAVIS'
	AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'JAMES-ANDREW'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Ben'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'BENJAMIN'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'PEGGS'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Rafael', MidName = 'Rhys', LastName = 'Pollitt'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'RAFAEL'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'RHYS POLLITT'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Rafael', MidName = 'Rhys', LastName = 'Pollitt'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') LIKE 'POLLITT%'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'RHY'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Rob'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ROBERT'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'WILLIAMS'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Alex'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ALEXANDRE'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'SCHLINDWEIN'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Matthew'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'MATT'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'POWELL'

	UPDATE fencing_project.dbo.TempComp
	SET	LastName = 'PHILLIPS LANGLEY'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'THOMAS'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'PHILLIPS-LANGLEY'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Joshua'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'JOSH'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'SAMBROOK'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Jeffrey'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'JEFF'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'KIY'
	
	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Samuel'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'SAM'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'SMITH'
	
	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'William'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'WILL'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'GALLIMORE-TALLEN'
	
	UPDATE fencing_project.dbo.TempComp
	SET LastName = 'Henderson'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ROSS'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))),NCHAR(160), '') = 'HENDERSONNBSP;'
	
	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Samuel'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'SAM'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'FINCH'
	
	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Sebastian'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'SEBASTAIN'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'SACCHI-WILSON'
	
	UPDATE fencing_project.dbo.TempComp
	SET LastName = 'De Almeida'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'DE-ALMEIDA'
	AND REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'DOMINIC'
	
	UPDATE fencing_project.dbo.TempComp
	SET LastName = 'Gillman'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'JOHN'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'GILMAN'
	
	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Isaac'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ISSAC'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'JOLLEY'
	
	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Daniel'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'DAN'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'HEPNER'
	
	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Benjamin'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'BEN'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'WEBB'

	UPDATE fencing_project.dbo.TempComp
	SET LastName = 'Corlett'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'THOMAS'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'CORLET'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Timothy'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'TIM'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'WAGHORN'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Daniel'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'DAN'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'SUMMERFIELD'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Matthew'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'MATT'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'BALLIN'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Ali'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'ALISTAIR'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'DELBOYER'

	UPDATE fencing_project.dbo.TempComp
	SET FirstName = 'Geert'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'GERT'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'VAN AARSEN'

	UPDATE dbo.TempComp
	SET BFA_ID = '30613'
	WHERE REPLACE(RTRIM(LTRIM(UPPER(FirstName))), NCHAR(160), '') = 'PATRICK'
	AND REPLACE(RTRIM(LTRIM(UPPER(LastName))), NCHAR(160), '') = 'DEMPSEY'