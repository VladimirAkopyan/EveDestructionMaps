USE [eveonline]
GO


create  view [dbo].[zCombinedDetails] as 
 Select
KillID ,
MAX(Fit) as Fit


FROM
(
SELECT 
FIRST_VALUE (fitting) OVER(partition by KillID ORDER BY N DESC) AS Fit, 
[KillID],N

From( SELECT
[KillID]
		,Fit as fitting
	
	  ,count(Fit) over (partition by Fit,KillID) as N

  FROM [dbo].[zCombinedDetailsRAW]
 
  ) as data
   
  )    as DATA
 
 group by KillID

   /* 
   ,
MAX(N) as N
  
  */







 




