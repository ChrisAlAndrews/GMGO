GM.Name = "Garry's Mod: Global Offensive"
GM.Author = "Christopher Andrews @ ZARP Gaming"
GM.Email = "chris.alex.andrews@gmail.com"
GM.Website = "www.zarpgaming.com"

-------------------------------------------------------------------------------
//////																	//////
//////					SETS UP GAMEMODE N SHIZZLE   					//////
//////																	//////
-------------------------------------------------------------------------------

team.SetUp(1, "Terrorists", Color(255, 0, 0))
team.SetSpawnPoint( 1, "info_player_terrorist" )
team.SetUp(2, "Counter-Terrorists", Color(0, 0, 255))
team.SetSpawnPoint( 2, "info_player_counterterrorist" )
	
function GM:Initialize()
	self.BaseClass.Initialize( self )
end

-------------------------------------------------------------------------------
//////																	//////
//////					STUFF FOR TESTING    							//////
//////																	//////
-------------------------------------------------------------------------------

function molest(ply, commandName, args)
	curteam = ply:Team()
	
	if curteam == 1 then
		ply:SetGamemodeTeam( 2 )
		print("Changed to team 2")
	
	elseif curteam == 2 then
		ply:SetGamemodeTeam( 1 )
		print("Changed to team 1")
	end
	
	ply:KillSilent()
	
end

concommand.Add("swapme", molest)

function fspawn(ply)
	ply:UnSpectate()
	ply:Spawn()
	ply:UnLock()
end
concommand.Add("spawnme", fspawn)