AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("player.lua")

-------------------------------------------------------------------------------
//////																	//////
//////					PLAYER SETUP STUFF								//////
//////																	//////
-------------------------------------------------------------------------------

// Added 12/06 for team balancing.
function checkteams()
	judgeteam = {terrorists = {}, counterterrorists = {}}
	for k,v in pairs(player.GetAll()) do
		if v:Team() == 1 then
			judgeteam.terrorists[#judgeteam.terrorists+1] = v:Nick()
		elseif v:Team() == 2 then
			judgeteam.counterterrorists[#judgeteam.counterterrorists+1] = v:Nick()
		end
	end
end

hook.Add( "Think", "checkteams", checkteams())

// Team assigning and initial spawm.
function GM:PlayerInitialSpawn( ply )

	print(ply:Nick() .. " spawned.")
	
	if judgeteam.terrorists[#judgeteam.terrorists] > judgeteam.counterterrorists[#judgeteam.counterterrorists] then
		ply:SetGamemodeTeam( 2 )
	elseif judgeteam.counterterrorists[#judgeteam.counterterrorists] > judgeteam.terrorists[#judgeteam.terrorists] then
		ply:SetGamemodeTeam( 1 )
	elseif judgeteam.counterterrorists[#judgeteam.counterterrorists] == 5 and judgeteam.terrorists[#judgeteam.terrorists] == 5 then
		ply:Kick("All teams full!")
	else
		ply:SetGamemodeTeam( math.random(1, 2) )
	end

	PlayerSetModel( ply )
end

// Spawns thereafter.
function GM:PlayerSpawn( ply )
	if ply:GetObserverTarget() then ply:KillSilent() return false end
	
	for k,wep in pairs(teams[ply:Team()].weapons) do
		ply:Give( wep )
		ply:GiveAmmo(300, "AR2")
		print("Gave team " ..ply:Team().. " member " ..ply:Nick().. " a weapon, specifically: " ..wep.. " at value " ..k)
	end	
	
	PlayerSetModel( ply )
end

function GM:PlayerAuthed( ply, steamid, uniqueid )
	print("[GMGO] Player " ..ply:Nick().. " has connected. SteamID: " ..steamid)
end

function PlayerSetModel( ply )
	if ply:Team() == 2 then
		ply:SetModel("models/player/swat.mdl")
	elseif ply:Team() == 1 then
		ply:SetModel("models/player/guerilla.mdl")
	end
end

function GM:PlayerShouldTakeDamage( victim, pl )
if pl:IsPlayer() then -- check the attacker is player 	
if( pl:Team() == victim:Team() and GetConVarNumber( "mp_friendlyfire" ) == 0 ) then -- check the teams are equal and that friendly fire is off.
		return false -- do not damage the player
	end
end
 
	return true -- damage the player
end

-------------------------------------------------------------------------------
//////																	//////
//////					ROUND/GAME STUFF								//////
//////																	//////
-------------------------------------------------------------------------------

Round = {}

Round.roundtime = 240
Round.precedingtime = 10
Round.endtime = 5
Round.tscore = 0
Round.ctscore = 0
Round.round = 0

local teamnames = {}
teamnames[1] = "Terrorists"
teamnames[2] = "Counter Terrorists"

function Round.waitforgame()
	Round.tscore = 0
	Round.ctscore = 0
	Round.round = 0
end

function Round.initialize()
	for k,v in pairs(player.GetAll()) do
		k:UnSpectate()
		k:Spawn()
		k:Lock()
	end
	timer.Simple(Round.precedingtime, Round.start)
end

function Round.start()
	Round.round = Round.round + 1
end

function Round.finish( winner )
	if winner == 1 then
		round.tscore = round.tscore + 1
	elseif winner == 2 then
		round.ctscore = round.ctscore + 1
	end

	teamnames = {"", "Terrorists", "Counter Terrorists"}
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint("[GMGO] " ..teamnames[winner].. "have won round " ..Round.round ".")
		v:ChatPrint("[GMGO] TERRORISTS " ..Round.tscore.. " - " ..Round.ctscore.. " COUNTER-TERRORISTS.")
	end
	
	Round.CheckIfEnd()
	
	Round.start()
end

function Round.CheckIfEnd( )
	if Round.tscore == 16 then
		Round.gamewin( 1 )
	elseif Round.ctscore == 16 then
		Round.gamewin( 2 )
	elseif Round.ctscore == 15 and Round.tscore == 15 then
		gametie()
	end

	return false
end

function Round.gamewin( winner )

end

function Round.gametie()

end

function Round.spec(ply)
	ply:Spectate( OBS_MODE_IN_EYE )
    ply:SpectateEntity( player.GetAll() )
	ply:Lock()
end
hook.Add( "PlayerDeath", "playerdied", Round.spec)