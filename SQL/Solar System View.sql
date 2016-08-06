USE [eveonline]
GO

create view [dbo].[SolarSystems] as
SELECT max(ss.[regionID]) as RegionID
	  ,max(reg.regionName) As RegionName
      ,max(ss.[constellationID])  as constellationID
      ,max(ss.[solarSystemID]) as solarSystemID
      ,max(ss.[solarSystemName]) as solarSystemName
      ,max(ss.[luminosity]) as Luminosity
      ,max(ss.[border]) as borderSys
      ,max(ss.[fringe]) as fringesys
      ,max(ss.[corridor]) as CorridorSys
      ,max(ss.[hub]) as hubSys
      ,max(ss.[international]) as internationalSys
      ,max(ss.[regional]) as regionalSys
      ,max(ss.[constellation]) as constellationSys
      ,max(ss.[security]) as SecurityStatus
      ,max(ss.[radius]) as SystemRadius 
	  ,max(reg.[radius]) as RegionalRadius 
      ,max(ss.[sunTypeID]) as sunTypeID
	  ,count(JumpTo.security) as 'NofGates' 
	  ,min(ISNULL(JumpTo.security,-0.99)) as 'Lowest Sec Connection' 
	  ,max(ISNULL(JumpTo.security,-0.99)) as 'Highest Sec Connection'
	  

  FROM [dbo].[mapSolarSystems] as ss
  join [dbo].[mapRegions] as reg
  on ss.regionID = reg.regionID

  left join [dbo].[mapSolarSystemJumps] as jump1
  on ss.solarSystemID = jump1.fromSolarSystemID

  left join [dbo].[mapSolarSystems] as JumpTo
  on jump1.fromSolarSystemID = JumpTo.solarSystemID

  group by ss.solarSystemID



  /*      ,[x]
      ,[y]
      ,[z]
      ,[xMin]
      ,[xMax]
      ,[yMin]
      ,[yMax]
      ,[zMin]
      ,[zMax]
	  */
GO


