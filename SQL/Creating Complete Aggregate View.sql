USE [eveonline]
GO

Create view dbo.TrainingSample2 as

SELECT       chars.charName, Ships.Ship, vk.charID, vk.killID, vk.Time, Corps.corpName, vk.corpID, allien.allienceName, vk.allienceID, vk.factionID, vk.shipID, vk.damage, vk.moonID, Ships.Class, Ships.volume, 
                  Ships.Cargo, Ships.mass, Ships.Price, ISNULL(Ships.LowSlots,0) as 'LowSlots', ISNULL(Ships.MidSlots,0) as 'MidSlots', 
				  
				  Case When (ISNULL(Ships.Weapons,7) < ISNULL(Armament,0))
                  Then (ISNULL(Ships.Weapons,7)  ) Else ( ISNULL(Armament,0) )  End 'Weapons',
				 
				  Case When (ISNULL(Ships.Weapons, ISNULL(Ships.HiSlots,Armament))) > 2
                  Then ISNULL(WeaponUpgr,0) /2 Else 0  End 'WeaponUpgr',

				  ECM, 
				  Drugs,
				  ExCargo,
				  Commod,
				  Valuables, 
				  Drones,
				  Analyzers,
				
				  Ships.[Warp Speed], Ships.Speed, Ships.Maneuverability, Ships.Size, Ships.WeaponSize,  
                  Ships.DroneBay, Ships.Defence, Ships.LockSpeed, Ships.CPU, Ships.Power, Ships.[Power bank], Ships.CapRecharge, ss.RegionName, vk.solarSystemID, ss.constellationID, ss.solarSystemName, ss.borderSys, 
                  ss.fringesys, ss.CorridorSys, ss.hubSys, ss.internationalSys, ss.regionalSys, ss.constellationSys, ss.SecurityStatus, Items.[Remote Reps], Items.[Remote Assistance], Items.Armament, Items.Mining, Items.Scanning, 
                  Items.SpeedMods, Items.Ewar, Items.CapPower, Items.Cloack, Items.Salvager, Items.[Warp Scrambler], Items.[Stasis Web], Items.[Propultion Module], Items.[Cynosural Field], Items.[Energy Destabilizer], 
                  Items.[Capacitor Booster], Items.[Ice Product], Items.[Interdiction Probe], Items.[Shield Extender], Items.[Shield Booster], Items.Sresist, Items.Repper, Items.Aresist, ss.NofGates, Attackers.[N Attackers], 
                  Attackers.[Mic Security], Attackers.[Average Security], Attackers.KilledBy, Attackers.KilledByType, Attackers.Frigates, Attackers.Cruisers, Attackers.Battleships, Attackers.Industrials, Attackers.Titans, 
                  Attackers.[Roockie Ships], Attackers.[Assault Ship], Attackers.[Heavy AS], Attackers.[Deep Space Transports], Attackers.BattleCruisers, Attackers.Destroyers, Attackers.MiningBarges, Attackers.Dreadnoughts, 
                  Attackers.Interdictors, Attackers.CommandShips, Attackers.Exhumers, Attackers.Interceptor, Attackers.Logistics, Attackers.[Force Recon], Attackers.Bomber, Attackers.[E - War], Attackers.[Heavy Interdictor], 
                  Attackers.[Black Ops], Attackers.Marauder, Attackers.[Combat Recon Ship], Attackers.[Attack Battlecruiser], Attackers.[Blockade Runner], Attackers.CovOps, crowd.Fit, crowd.Sit
FROM     [eveonline].dbo.zkbVictims AS vk INNER JOIN
                  [eveonline].dbo.zkbSolarSystemsTable AS ss ON vk.solarSystemID = ss.solarSystemID LEFT OUTER JOIN
                  [eveonline].dbo.zkbCharacters AS chars ON vk.charID = chars.charID INNER JOIN
                  [eveonline].dbo.zkbStarShipTable AS Ships ON vk.shipID = Ships.ShipID INNER JOIN
                  [eveonline].dbo.zkbAttackerInfoTable AS Attackers ON vk.killID = Attackers.KillID LEFT OUTER JOIN
                  [eveonline].dbo.ItemView AS Items ON vk.killID = Items.KillID INNER JOIN
                  [eveonline].dbo.[zCombinedDetails] AS crowd ON vk.killID = crowd.KillID LEFT OUTER JOIN
                  [eveonline].dbo.zkbCorporations AS Corps ON vk.corpID = Corps.corpID LEFT OUTER JOIN
                  [eveonline].dbo.zkbAlliences AS allien ON vk.allienceID = allien.allienceID

