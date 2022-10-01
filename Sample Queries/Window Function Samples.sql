DROP TABLE IF EXISTS #MyData;

SELECT 
week,day,No
INTO #MyData
FROM
(
VALUES
(1,1,2),
(1,2,2),
(1,3,2),
(1,4,2),
(1,5,2),
(1,6,2),
(1,7,2),
(2,1,2),
(2,2,2),
(2,3,2),
(2,4,2),
(2,5,2),
(2,6,2),
(2,7,2)
) MyData(week,day,No);

SELECT [week],[day],[No], 
Total.SumOfNo
FROM #MyData
CROSS JOIN
(
	SELECT SUM([No]) AS SumOfNo
	FROM #MyData
) AS Total

SELECT [week],[day],[No],
SUM([No]) OVER() AS SumOfNo
FROM #MyData