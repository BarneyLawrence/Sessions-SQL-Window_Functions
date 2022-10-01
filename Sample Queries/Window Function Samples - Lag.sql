DROP TABLE IF EXISTS #MyData;

SELECT 
week,day,No
INTO #MyData
FROM
(
VALUES
(1,1,11),
(1,2,3),
(1,3,13),
(1,4,5),
(1,5,7),
(1,6,2),
(1,7,1),
(2,1,1),
(2,2,5),
(2,3,2),
(2,4,0),
(2,5,8),
(2,6,3),
(2,7,1)
) MyData(week,day,No);


SELECT [week],[day], [No],
LAG(No)		OVER (ORDER BY [week],[day])
FROM #MyData