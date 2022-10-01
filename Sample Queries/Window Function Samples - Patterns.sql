DROP TABLE IF EXISTS #MyData;

SELECT 
Colour,No
INTO #MyData
FROM
(
VALUES
(1,'Red'),
(2,'Red'),
(3,'Blue'),
(4,'Red'),
(5,'Red'),
(6,'Blue'),
(7,'Blue'),
(8,'Blue'),
(9,'Green'),
(10,'Green'),
(11,'Green'),
(12,'Green'),
(13,'Blue'),
(14,'Blue')
) MyData(No,Colour);

WITH Change AS
(
SELECT Colour, No,
IIF(
	LAG(Colour)	OVER (ORDER BY No) <> Colour
	,1
	,0
) AS IsChange
FROM #MyData
), ChangeGroup
AS
(
SELECT
 Colour, No,IsChange,
 SUM(IsChange) OVER(ORDER BY No ROWS UNBOUNDED PRECEDING) AS ChangeSum
  FROM Change
)
SELECT ChangeSum, Colour,
MIN(No) AS StartNo,
MAX(No) AS EndNo
FROM ChangeGroup
GROUP BY ChangeSum, Colour
ORDER BY ChangeSum

WITH Change AS
(
SELECT Colour, No,
IIF(
	LAG(Colour)	OVER (ORDER BY No) <> Colour
	,1
	,0
) AS IsChange
FROM #MyData
), ChangeGroup
AS
(
SELECT
 Colour, No,IsChange,
 SUM(IsChange) OVER(ORDER BY No ROWS UNBOUNDED PRECEDING) AS ChangeSum
  FROM Change
)
SELECT No, Colour,
COUNT(*) OVER(
		PARTITION BY ChangeSum
		ORDER BY No ROWS UNBOUNDED PRECEDING
		) TimeOpen
FROM ChangeGroup

