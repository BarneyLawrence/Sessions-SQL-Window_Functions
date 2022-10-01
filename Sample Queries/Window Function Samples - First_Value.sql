DROP TABLE IF EXISTS #MyData;

SELECT 
Colour,Day,Team,No
INTO #MyData
FROM
(
VALUES
('Red',1,'A',8),
('Red',2,'A',12),
('Red',3,'A',8),
('Red',1,'B',10),
('Red',2,'B',5),
('Red',3,'B',19),
('Blue',1,'A',15),
('Blue',2,'A',15),
('Blue',3,'A',18),
('Blue',1,'B',4),
('Blue',2,'B',14),
('Blue',3,'B',1)
) MyData(Colour,Day,Team,No);

SELECT [Colour],[Day],[Team],[No],
FIRST_VALUE([Team])
OVER (
	PARTITION BY [Day]
	ORDER BY [No] DESC
	) AS BestTeam
FROM #MyData
WHERE Colour = 'Red'

DROP TABLE IF EXISTS #MyDataBig;

--Make a bigger data set
--Multiply rows by 1 million and spread days over 100
WITH TimesTen AS
(
SELECT *
FROM
(VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) V(n)
)
SELECT [Colour],ABS(CHECKSUM(NewId())) % 100 AS [Day],[Team],[No]
INTO #MyDataBig
FROM #MyData
CROSS JOIN TimesTen AS T10
CROSS JOIN TimesTen AS T100
CROSS JOIN TimesTen AS T1000
CROSS JOIN TimesTen AS T10000
CROSS JOIN TimesTen AS T100000
CROSS JOIN TimesTen AS T1000000

DECLARE
@Colour varchar(20),
@Day int,
@Team varchar(20),
@No int,
@BestTeam varchar(20)

SELECT @Colour = [Colour],@Day = [Day],@Team = [Team], @No= [No],
@BestTeam = FIRST_VALUE([Team])
OVER (
	PARTITION BY [Day]
	ORDER BY [No] DESC
	) 
FROM #MyDataBig
WHERE Colour = 'Red'
OPTION(MAXDOP 1)

CREATE INDEX WindowGoFast ON #MyDataBig
(
[Colour] ASC,
[Day] ASC,
[No] DESC
)
INCLUDE
(
[Team]
)

SELECT @Colour = [Colour],@Day = [Day],@Team = [Team], @No= [No],
@BestTeam = FIRST_VALUE([Team])
OVER (
	PARTITION BY [Day]
	ORDER BY [No] DESC
	) 
FROM #MyDataBig
WHERE Colour = 'Red'
OPTION(MAXDOP 1)


DROP  INDEX WindowGoFast ON #MyDataBig
CREATE CLUSTERED COLUMNSTORE INDEX CCIX_WindowGoFAST ON #MyDataBig;


SELECT @Colour = [Colour],@Day = [Day],@Team = [Team], @No= [No],
@BestTeam = FIRST_VALUE([Team])
OVER (
	PARTITION BY [Day]
	ORDER BY [No] DESC
	) 
FROM #MyDataBig
WHERE Colour = 'Red'
OPTION(MAXDOP 1)