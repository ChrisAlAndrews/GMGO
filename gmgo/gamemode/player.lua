include("shared.lua")

local ply = FindMetaTable("Player")

teams = {}

teams[1] = {name = "Terrorists", color = Vector( 1.0, .2, .2 ), weapons = {"m9k_ak47", "m9k_glock"}}
teams[2] = {name = "Counter-Terrorist", color = Vector( 0, 0, 1.0 ), weapons = {"m9k_m4a1", "m9k_luger"}}

function ply:SetGamemodeTeam( p )
	if not teams[p] then return end
	
	self:SetTeam( p )
	
	self:SetPlayerColor( teams[p].color )
	
	self:StripWeapons()
	
	for k,wep in pairs(teams[p].weapons) do
		self:Give( wep )
		self:GiveAmmo(300, "AR2")
		print("Gave team " ..p.. " member " ..self:Nick().. " a weapon, specifically: " ..wep.. " at value " ..k)
	end	

	return true
end 