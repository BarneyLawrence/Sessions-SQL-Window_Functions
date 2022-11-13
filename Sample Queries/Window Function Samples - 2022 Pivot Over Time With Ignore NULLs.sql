DROP TABLE IF EXISTS #MyData;

SELECT 
RecordDate,Colour
INTO #MyData
FROM
(
VALUES
(CAST('220101' AS date) ,'Red'),
(CAST('220102' AS date) ,'Green'),
(CAST('220103' AS date) ,'Blue'),
(CAST('220104' AS date) ,'Red'),
(CAST('220105' AS date) ,'Red'),
(CAST('220106' AS date) ,'Blue'),
(CAST('220107' AS date) ,'Red'),
(CAST('220108' AS date) ,'Red'),
(CAST('220109' AS date) ,'Green'),
(CAST('220110' AS date) ,'Red'),
(CAST('220111' AS date),'Green'),
(CAST('220112' AS date) ,'Red'),
(CAST('220113' AS date) ,'Blue'),
(CAST('220114' AS date) ,'Red')
) MyData(RecordDate,Colour);

SELECT RecordDate, Colour,
LEAD(RecordDate) 
	OVER MyOrder AS NextDate,
LAST_VALUE(IIF(Colour='Red',RecordDate,NULL)) IGNORE NULLS
	OVER MyWindow AS LastSeenRed,
LAST_VALUE(IIF(Colour='Green',RecordDate,NULL)) IGNORE NULLS
	OVER MyWindow AS LastSeenGreen,
LAST_VALUE(IIF(Colour='Blue',RecordDate,NULL)) IGNORE NULLS
	OVER MyWindow AS LastSeenBlue
FROM #MyData
WINDOW 
MyOrder AS (
			ORDER BY RecordDate
			),
MyWindow AS (
			MyOrder
		ROWS BETWEEN
			UNBOUNDED PRECEDING
			AND CURRENT ROW
		)