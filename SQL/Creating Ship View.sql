USE [eveonline]
GO

CREATE VIEW StarShips AS

 
SELECT 
	  types.marketGroupID as marketGroupID
	  ,types.[groupID] as groupID
      ,[raceID] as raceID
	  ,types.typeID as ShipID
      ,types.[typeName] AS Ship 
      ,groups.groupName AS 'Class'
      ,[volume] 
      ,[capacity] AS 'Cargo'
	  ,[mass]
      ,[basePrice] 'Price'
	  ,COALESCE(LowSlots.valueFloat, LowSlots.valueInt) AS 'LowSlots' 
	  ,COALESCE(MidSlots.valueFloat, MidSlots.valueInt) AS 'MidSlots'
	  ,COALESCE(HiSlots.valueFloat, HiSlots.valueInt) AS 'HiSlots'
	  ,COALESCE( WrpSpd.valueFloat, WrpSpd.valueInt)*COALESCE( WrpFac.valueFloat, WrpFac.valueInt) AS 'Warp Speed'
	  ,COALESCE(Speed.valueFloat, Speed.valueInt) AS 'Speed'
	  ,100000000/([mass]*COALESCE(Agility.valueFloat, Agility.valueInt)) AS 'Maneuverability'
	  ,COALESCE(SigSize.valueFloat, SigSize.valueInt) AS 'Size'
	  ,CASE WHEN COALESCE(Missiles.valueFloat, Missiles.valueInt) > COALESCE(Turrets.valueFloat, Turrets.valueInt) 
	   THEN COALESCE(Missiles.valueFloat, Missiles.valueInt) 
	   ELSE COALESCE(Turrets.valueFloat, Turrets.valueInt)
	   End AS 'Weapons'

	   ,COALESCE(RigSize.valueFloat, RigSize.valueInt) as 'WeaponSize'

	   ,COALESCE(DroneBand.valueFloat, DroneBand.valueInt) 'DronesBand'
	   ,COALESCE(DroneCap.valueFloat, DroneCap.valueInt) as 'DroneBay'
	   
	   ,(COALESCE(Shield.valueFloat, Shield.valueInt) 
			* 
	   ((ShdThrm.valueFloat + ShdEm.valueFloat + ShdExp.valueFloat + ShdKin.valueFloat)/4))
			+ 
	   (COALESCE(Armor.valueFloat, Armor.valueInt)
			* 
	   ((ArmThrm.valueFloat + ArmEm.valueFloat + ArmExp.valueFloat + ArmKin.valueFloat)/4))
	    AS 'Defence' 
		 
	   ,COALESCE(ScanRes.valueFloat, ScanRes.valueInt) AS 'LockSpeed' 
	   ,COALESCE( CPU.valueFloat, CPU.valueInt) AS 'CPU' 
	   ,COALESCE( PWRSupply.valueFloat, PWRSupply.valueInt) AS 'Power' 
	   ,COALESCE( Capacitor.valueFloat, Capacitor.valueInt) AS 'Power bank' 
	   ,COALESCE( Capacitor.valueFloat, Capacitor.valueInt)/COALESCE( RechRate.valueFloat, RechRate.valueInt)*1000 AS 'CapRecharge'

	   
  FROM [dbo].[invTypes] as types
 

  inner join [dbo].[invGroups] as groups
  on types.groupID = groups.groupID
    
  left join [dbo].[dgmTypeAttributes] as LowSlots
  on types.typeID = LowSlots.typeID AND LowSlots.attributeID = 12 

  left join [dbo].[dgmTypeAttributes] as MidSlots
  on types.typeID = MidSlots.typeID AND MidSlots.attributeID = 13
  
  left join [dbo].[dgmTypeAttributes] as HiSlots
  on types.typeID = HiSlots.typeID AND HiSlots.attributeID = 14

  inner join [dbo].[dgmTypeAttributes] as Speed
  on types.typeID = Speed.typeID AND Speed.attributeID = 37

  inner join [dbo].[dgmTypeAttributes] as Agility
  on types.typeID = Agility.typeID AND Agility.attributeID = 70

  left join [dbo].[dgmTypeAttributes] as Turrets
  on types.typeID = Turrets.typeID AND Turrets.attributeID = 102

  left join [dbo].[dgmTypeAttributes] as Missiles
  on types.typeID = Missiles.typeID AND Missiles.attributeID = 101

  left join [dbo].[dgmTypeAttributes] as RigSize
  on types.typeID = RigSize.typeID AND RigSize.attributeID = 1547

  inner join [dbo].[dgmTypeAttributes] as SigSize
  on types.typeID = SigSize.typeID AND SigSize.attributeID = 552
  
  left join [dbo].[dgmTypeAttributes] as DroneBand
  on types.typeID = DroneBand.typeID AND DroneBand.attributeID = 1271

  left join [dbo].[dgmTypeAttributes] as DroneCap
  on types.typeID = DroneCap.typeID AND DroneCap.attributeID = 283

  inner join [dbo].[dgmTypeAttributes] as Armor
  on types.typeID = Armor.typeID AND Armor.attributeID = 265

  inner join [dbo].[dgmTypeAttributes] as Shield
  on types.typeID = Shield.typeID AND Shield.attributeID = 263

  left join [dbo].[dgmTypeAttributes] as ScanRes
  on types.typeID = ScanRes.typeID AND ScanRes.attributeID = 564

  left join [dbo].[dgmTypeAttributes] as CPU
  on types.typeID = CPU.typeID AND CPU.attributeID = 48

  left join [dbo].[dgmTypeAttributes] as PWRSupply
  on types.typeID = PWRSupply.typeID AND PWRSupply.attributeID = 11

  left join [dbo].[dgmTypeAttributes] as Capacitor
  on types.typeID = Capacitor.typeID AND Capacitor.attributeID = 482

  left join [dbo].[dgmTypeAttributes] as RechRate
  on types.typeID = RechRate.typeID AND RechRate.attributeID = 55

  inner join [dbo].[dgmTypeAttributes] as ArmEm
  on types.typeID = ArmEm.typeID AND ArmEm.attributeID = 267

  inner join [dbo].[dgmTypeAttributes] as ArmExp
  on types.typeID = ArmExp.typeID AND ArmExp.attributeID = 268

  inner join [dbo].[dgmTypeAttributes] as ArmKin
  on types.typeID = ArmKin.typeID AND ArmKin.attributeID = 269

  inner join [dbo].[dgmTypeAttributes] as ArmThrm
  on types.typeID = ArmThrm.typeID AND ArmThrm.attributeID = 270

  inner join [dbo].[dgmTypeAttributes] as ShdEm
  on types.typeID = ShdEm.typeID AND ShdEm.attributeID = 271

  inner join [dbo].[dgmTypeAttributes] as ShdExp
  on types.typeID = ShdExp.typeID AND ShdExp.attributeID = 272

  inner join [dbo].[dgmTypeAttributes] as ShdKin
  on types.typeID = ShdKin.typeID AND ShdKin.attributeID = 273

  inner join [dbo].[dgmTypeAttributes] as ShdThrm
  on types.typeID = ShdThrm.typeID AND ShdThrm.attributeID = 274

  inner join [dbo].[dgmTypeAttributes] as WrpFac
  on types.typeID = WrpFac.typeID AND WrpFac.attributeID = 600

  inner join [dbo].[dgmTypeAttributes] as WrpSpd
  on types.typeID = WrpSpd.typeID AND WrpSpd.attributeID = 1281

GO


