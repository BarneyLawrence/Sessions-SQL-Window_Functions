DROP TABLE IF EXISTS #MyData;

SELECT 
Colour,CAST(MyDate as date) AS Mydate
INTO #MyData
FROM
(
VALUES
('20220101','Red'),
('20220102','Red'),
('20220103','Blue'),
('20220104','Red'),
('20220105','Red'),
('20220106','Blue'),
('20220107','Blue'),
('20220108','Blue'),
('20220109','Green'),
('20220110','Green'),
('20220111','Green'),
('20220112','Green'),
('20220113','Blue'),
('20220114','Blue')
) MyData(MyDate,Colour);

DECLARE @Origin date = CAST('20220101' as date)

SELECT Mydate, Colour
,DATE_BUCKET(week,1,MyDate,@Origin) AS WeekGroup
, COUNT(IIF(Colour = 'Red',1,NULL)) 
	OVER (
		PARTITION BY DATE_BUCKET(week,1,MyDate,@Origin)
		) RedInWeek
FROM #MyData
