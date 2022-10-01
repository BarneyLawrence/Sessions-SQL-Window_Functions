DROP TABLE IF EXISTS #MyData;

SELECT 
day,No
INTO #MyData
FROM
(
VALUES
(1,11),
(2,3),
(3,13),
(3,5),
(4,7),
(5,2),
(5,1),
(6,1),
(6,5),
(6,2),
(7,0),
(7,8),
(7,3),
(7,1)
) MyData(Day,No);


SELECT [Day], [No],
SUM([No]) 
	OVER (
		ORDER BY [Day]
		ROWS BETWEEN 
			1 PRECEDING AND 
			1 FOLLOWING

		) AS [Sum No]
FROM #MyData
ORDER BY 1