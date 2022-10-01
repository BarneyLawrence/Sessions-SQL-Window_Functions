DROP TABLE IF EXISTS #MyData;

SELECT 
Colour,No
INTO #MyData
FROM
(
VALUES
('Red',10),
('Red',20),
('Red',30),
('Blue',100),
('Blue',200),
('Blue',300),
('Green',15),
('Green',25),
('Green',35)
) MyData(Colour,No);

SELECT Colour, No
FROM (
	SELECT Colour, No,
	ROW_NUMBER() 
	OVER (
		PARTITION BY Colour
		ORDER BY No DESC
	) AS Seq
	FROM #MyData
) AS Sequenced
WHERE Seq = 1


