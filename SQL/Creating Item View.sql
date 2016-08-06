USE [eveonline]
GO

Create view ItemView as  
SELECT 
	KillID
	,SUM([Remote Reps]) as 'Remote Reps'
	,SUM([Remote Assistance]) as 'Remote Assistance'
	,SUM([Armament]) as 'Armament'
	,SUM([WeaponUpgr]) as 'WeaponUpgr'
	,SUM([Mining]) as 'Mining'
	,SUM([Scanning]) as 'Scanning'
	,SUM([SpeedMods]) as 'SpeedMods'
	,SUM([Ewar]) as 'Ewar'
	,SUM(CapPower) as 'CapPower'
	,SUM(Cloack) as 'Cloack'
	,SUM(Salvager) as 'Salvager'
	,SUM([Warp Scrambler]) as 'Warp Scrambler'
	,SUM([Stasis Web]) as 'Stasis Web'
	,SUM([MWD]) as 'MWD'
	,SUM([MWD]) as 'AB'
	,SUM([Cynosural Field]) as 'Cynosural Field'
	,SUM([Covert Cyno]) as 'Covert Cyno'
	
	,SUM(CovOpsCloack) as 'CovOpsCloack'
	
	,SUM([Energy Dest/Vamp]) as 'Energy Destabilizer'
	,SUM([Capacitor Booster]) as 'Capacitor Booster'
	,SUM([Ice Product]) as 'Ice Product'
	,SUM([Interdiction Probe]) as 'Interdiction Probe'
	,SUM([Shield Extender]) as 'Shield Extender'
	,SUM([Shield Booster]) as 'Shield Booster'
	,SUM([Sresist]) as 'Sresist'
	,SUM([Repper]) as 'Repper'
	,SUM([Aresist]) as 'Aresist'
	,(SUM([Infrastructure]) ) as 'Structure'
	,SUM([Commoduties]) as 'Commod'
	,SUM([DUST]) as 'DUST'
	,SUM([Clothing]) as 'Clothes'
	,SUM([Deployable]) as 'Deployb'
	,SUM([SleeperSalvage]) as 'SleepSalv'

	,SUM([ExCargo]) as 'ExCargo'
	,SUM([Drugs]) as 'Drugs'
	,SUM([ECM]) as 'ECM'
	,SUM([Drones]) as 'Drones'
	,SUM([Analyzers]) as 'Analyzers'
	,SUM([Blueprint]) as 'Blueprint'
	,SUM([Implants]) as 'Implant'
	,SUM(CargoVolume) as 'CargoVolume'
	

  FROM (

		SELECT [ItemDropID]
		  ,[KillID]
		  ,[ItemID]
		  ,([QtyDropped] + [QtyDestroyed]) as Quantity
		  ,ItemNames.typeName
		  ,ItemGroups.groupName
		  ,ItemGroups.groupID
		  ,ItemCategories.categoryName
		  ,ItemCategories.categoryID
			
		,volume*([QtyDropped] + [QtyDestroyed]) as 'CargoVolume'

		,Case /*Shield, cap and Armor transfers*/
		When ItemGroups.groupID in (67,325,41, 585) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Remote Reps'

		,Case /*Shield, cap and Armor transfers*/
		When ItemGroups.groupID in (209, 290) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Remote Assistance'

		,Case                 /* Guns&drones    || Mossiles               ||*/
		When ItemGroups.groupID in (55,53,74,56,506,507,508,509,510,511,771) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Armament'

		,Case                 
		When ItemGroups.groupID in (100) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Drones'

		,Case                   /*                             ||drone   ||  Rigs            */
		When ItemGroups.groupID in (59, 205, 302, 367, 211, 213, 645, 646, 775,776,777,778,779) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'WeaponUpgr'

		,Case 
		When ItemGroups.groupID in (546,464,483,54,49,737) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Mining'

		,Case 
		When ItemGroups.groupID in (765) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'ExCargo'

		,Case 
		When ItemGroups.groupID in (1223,481,1233) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Scanning'

		,Case /*ELEctronic Warfare.*/
		When ItemGroups.groupID in (208,379, 842, 291) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Ewar'

		,Case /*ELEctronic Warfare.*/
		When ItemGroups.groupID in (201) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'ECM'

		,Case /*ELEctronic Warfare.*/
		When ItemGroups.groupID in (313) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Drugs'

		,Case /*Overdrives nanofibers and inertial stabilisers*/
		When ItemGroups.groupID in (764, 763, 762) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'SpeedMods'

		,Case /*add capacitor flux coils and power diagnostics, and CCC rigs*/
		When ItemGroups.groupID in (768, 766, 767, 43, 61) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'CapPower'

		,Case 
		When ItemGroups.groupID in (330) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Cloack'

		,Case 
		When ItemNames.typeID in (11578) THEN (1)
		else 0  END as 'CovOpsCloack'
		

		,Case 
		When ItemGroups.groupID in (1122) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Salvager'

		,Case /* Data Analysers, etc*/
		When ItemGroups.categoryID in (538) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Analyzers'

		,Case 
		When ItemGroups.groupID in (52) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Warp Scrambler'

		,Case 
		When ItemGroups.groupID in (65) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Stasis Web'

		,Case 
		When ItemNames.typeID in (434, 440, 5945, 5971, 5973, 5975, 12052, 12054, 14116, 12084, 
		12076, 14492, 14492, 14494, 14496, 14498, 14508, 14510, 14512, 14514, 15747, 15751, 15755, 15759, 15764, 
		15768) THEN ([QtyDropped] + [QtyDestroyed])
		else 0  END as 'MWD'

		,Case 
		When ItemNames.typeID in (15770, 15766, 15761, 15757, 15753, 18658, 18660, 18662, 18664, 18666, 18668, 18670,
18672, 18674, 18676, 18680, 18682, 18684, 18686, 18688, 18690, 18692, 18690, 18692, 18694, 18696, 18698, 15749, 14504, 14506, 14500,
14502, 14504, 14484, 14486, 14488, 14490, 14112, 14108, 14104, 14102, 12056, 12058, 12066, 12068, 6001, 6003, 6005, 438, 439 ) 
		THEN ([QtyDropped] + [QtyDestroyed])
		else 0  END as 'AB'


		,Case 
		When ItemNames.typeID in (21096) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Cynosural Field'

		,Case 
		When ItemNames.typeID in (28646) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Covert Cyno'

		,Case 
		When ItemGroups.groupID in (71, 68) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Energy Dest/Vamp'

		,Case 
		When ItemGroups.groupID in (76) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Capacitor Booster'

		,Case 
		When ItemGroups.groupID in (423) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Ice Product'

		,Case
		When ItemGroups.groupID in (548) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Interdiction Probe'

		,Case 
		When ItemGroups.groupID in (38) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Shield Extender'

		,Case
		When ItemGroups.groupID in (40, 1156) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Shield Booster'

		,Case 
		When ItemGroups.groupID in (295,77) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Sresist'
		
		,Case 
		When ItemGroups.groupID in (329) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Aplates'

		,Case
		When ItemGroups.groupID in (62, 1199) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Repper'

		,Case 
		When ItemGroups.groupID in (326,98, 1150) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Aresist'

		,Case /*misc cargo only stuff*/
		When ItemGroups.categoryID in ( 17, 42, 43) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Commoduties'


		 ,Case /*misc cargo only stuff*/
		When ItemGroups.categoryID in (350001) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'DUST'

		 ,Case /*misc cargo only stuff*/
		When ItemGroups.categoryID in (30) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Clothing'

		
		,Case /*misc cargo only stuff*/
		When ItemGroups.categoryID in (22) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Deployable'
		
		 ,Case /*misc cargo only stuff*/
		When ItemGroups.categoryID in (34) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'SleeperSalvage'
		

		,Case /*  Soverenity Structures, Pos, Reaction blueprints, PI command centers*/
		When ItemGroups.categoryID in (40, 23, 24, 41) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Infrastructure'

		,Case /*misc cargo only stuff*/
		When ItemGroups.categoryID in (20) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Implants'
		
		,Case /*misc cargo only stuff*/
		When ItemGroups.categoryID in (9) THEN ([QtyDropped] + [QtyDestroyed])
		else 0 END as 'Blueprint'
		

		
		

	  FROM [eveonline].[dbo].[zkbItems] as KillItems
	  left join [eveonline].[dbo].[invTypes] as ItemNames 
	  on ItemID = ItemNames.typeID

	  left join [eveonline].[dbo].[invGroups] as ItemGroups 
	  on ItemNames.groupID = ItemGroups.groupID

	  left join [eveonline].[dbo].[invCategories] as ItemCategories
	  on ItemGroups.categoryID = ItemCategories.categoryID 
	)
	
	Data

	Group by Data.KillID

	

		/*		
		
		
		

		*/


GO


