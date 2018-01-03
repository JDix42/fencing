DROP TABLE #Table2

CREATE TABLE #Table2
(ID		INT,
YearS	Float,
Val		NVARCHAR(255))

INSERT INTO #Table2
VALUES(1, 2000, 'A')

INSERT INTO #Table2
VALUES(1, 2001, 'A')

INSERT INTO #Table2
VALUES(2, 2000, 'A')

INSERT INTO #Table2
VALUES(3, 2004, 'A')

INSERT INTO #Table2
VALUES(1, 2002, 'A')

INSERT INTO #Table2
VALUES(2, 2003, 'A')

INSERT INTO #Table2
VALUES(3, 2000, 'A')

INSERT INTO #Table2
VALUES(1, 2004, 'A')

INSERT INTO #Table2
VALUES(2, 2003, 'A')

INSERT INTO #Table2
VALUES(3, 2003, 'A')

INSERT INTO #Table2
VALUES(1, 2005, 'A')

INSERT INTO #Table2
VALUES(3, 2000, 'A')

DECLARE @query VARCHAR(4000)
DECLARE @years VARCHAR(2000)

SELECT @years = STUFF((
    SELECT DISTINCT
        '],[' + ltrim(str(YearS))
    FROM #Table2
    ORDER BY '],[' + ltrim(str(YearS))
    FOR XML PATH('')), 1, 2, '') + ']'

PRINT @years

SET @query =
    'SELECT * FROM
    (
        SELECT ID AS ID,YearS,Val
        FROM #Table2
    ) AS t
    PIVOT (MAX(Val) FOR YearS IN (' + @years + ')) AS pvt'

EXECUTE (@query)
