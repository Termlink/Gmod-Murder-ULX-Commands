//Murder ULX Commands
//Made by ZombieWizzard

//Update checker
//mulxrepo = "https://raw.github.com/zombiewizzard/murder-ulx-commands/master/data/version-number.txt"
//mulxcurversion = 0
//mulxnewversion = 0
//mulxcheckfailed = false
//function UpdateChecker()
//	if ( file.Exists( "data/version-number.txt", "GAME" ) ) then
//		mulxcurversion = tonumber( file.Read( "data/version-number.txt", "GAME" ))
//	end
//	http.Fetch( mulxrepo,
//		function( content ) //Succeeded
//			mulxnewversion = tonumber( content )
//		end,
//		function( failCode ) //Failed
//			if SERVER then //Only logs in server console
//				print ( "Murder module failed to check for updates" )
//				print ( mulxrepo, " returned ", failCode )
//			end
//			mulxcheckfailed = true
//		end
//	)
//	
//	timer.Simple( 5, function() 
//		if mulxcurversion < mulxnewversion and !mulxcheckfailed then
//			if SERVER then
//				print( "Murder module update available" )
//				print( "You are using version ", mulxcurversion )
//				print( "The latest version is ", mulxnewversion )
//			end
//			mulxoutdated = true
//		elseif !mulxcheckfailed then
//			if SERVER then
//				print( "Murder module is up to date" )
//				print( "You are using version ", mulxcurversion )
//			end
//			mulxoutdated = false
//		end
//	end )
//end
//
//UpdateChecker()

//if CLIENT then
//	timer.Simple( 10, function() include( "cl_updatenotify.lua" ) end )
//end

local CATEGORY_NAME = "Murder"

//!Murder - Opens the murder administration panel
function ulx.murder( calling_ply )
	calling_ply:ConCommand( "mu_adminpanel" ) //Using built in command on caller so it shows the panel to them
end

local murder = ulx.command( CATEGORY_NAME, "ulx murder", ulx.murder, "!murder" )
murder:defaultAccess( ULib.ACCESS_ADMIN )
murder:help( "Opens the murder administration panel." )

//!FSpec and !UnSpec - Forces the target(s) to/from spectator
function ulx.murderspec( calling_ply, target_plys, should_unspec )
	for i=1, #target_plys do
		local v = target_plys[ i ]
		
		if should_unspec then
			v:SetTeam( 2 ) //Player
		else
			v:SetTeam( 1 ) //Spectator
			v:Kill() //Kills them just to make sure it works
		end
	end
	if should_unspec then
		ulx.fancyLogAdmin( calling_ply, "#A has forced #T to play!", target_plys )
	else
		ulx.fancyLogAdmin( calling_ply, "#A has forced #T to spectate!", target_plys )
	end
end

local murderspec = ulx.command( CATEGORY_NAME, "ulx fspec", ulx.murderspec, "!fspec" )
murderspec:addParam{ type=ULib.cmds.PlayersArg }
murderspec:addParam{ type=ULib.cmds.BoolArg, invisible=true }
murderspec:defaultAccess( ULib.ACCESS_ADMIN )
murderspec:help( "Forces the target(s) to/from spectator." )
murderspec:setOpposite( "ulx unspec", {_, _, true}, "!unspec" )

//!FNextMurderer - Forces target to be murderer next round
function ulx.fnextmurderer( calling_ply, target_ply )
	RunConsoleCommand( "mu_forcenextmurderer", target_ply:EntIndex() ) //Runs built in command on server console
	
	ulx.fancyLogAdmin( calling_ply, true, "#A has forced #T to be murderer next round!", target_ply )
end

local fnextmurderer = ulx.command ( CATEGORY_NAME, "ulx fnextmurderer", ulx.fnextmurderer, "!fnextmurderer" )
fnextmurderer:addParam{ type=ULib.cmds.PlayerArg }
fnextmurderer:defaultAccess( ULib.ACCESS_SUPERADMIN )
fnextmurderer:help( "Forces target to be murderer next round." )

//!AddLoot - Adds a spawn for loot where you are looking
function ulx.addloot( calling_ply, model )
	calling_ply:ConCommand( "mu_loot_add " .. model ) //Based on !rcon to parse the model variable through
													  //Has to be run on callers console to grab where they are looking
	ulx.fancyLogAdmin( calling_ply, true, "#A has added loot with the model #s where they were looking!", model )
end

local addloot = ulx.command ( CATEGORY_NAME, "ulx addloot", ulx.addloot, "!addloot" )
addloot:addParam{ type=ULib.cmds.StringArg, hint="model", ULib.cmds.takeRestOfLine }
addloot:defaultAccess( ULib.ACCESS_SUPERADMIN )
addloot:help( "Adds a spawn for loot where you are looking. Use '!ModelList' to find out the model name aliases." )

//!LootList - Prints list of loot spawns in your chat
function ulx.lootlist( calling_ply )
	calling_ply:ConCommand( "mu_loot_list" ) //Runs on caller so it doesn't print it in server console
end

local lootlist = ulx.command ( CATEGORY_NAME, "ulx lootlist", ulx.lootlist, "!lootlist" )
lootlist:defaultAccess( ULib.ACCESS_SUPERADMIN )
lootlist:help( "Prints list of loot spawns in your chat." )

//!LootRemove - Removes the loot spawn with the id you provide
function ulx.lootremove( calling_ply, id )
	RunConsoleCommand( "mu_loot_remove " .. id ) //Based on !rcon again
	
	ulx.fancyLogAdmin( calling_ply, true, "#A has removed the loot spawn with the id #s!", id )
end

local lootremove = ulx.command ( CATEGORY_NAME, "ulx lootremove", ulx.lootremove, "!lootremove" )
lootremove:addParam{ type=ULib.cmds.StringArg, hint="id", ULib.cmds.takeRestOfLine }
lootremove:defaultAccess( ULib.ACCESS_SUPERADMIN )
lootremove:help( "Removes the loot spawn with the id you provide." )

//!LootRespawn - Respawns all of the loot
function ulx.lootrespawn( calling_ply )
	RunConsoleCommand( "mu_loot_respawn" ) //Self explanatory
	
	ulx.fancyLogAdmin( calling_ply, true, "#A respawned all of the loot!", target_plys )
end

local lootrespawn = ulx.command ( CATEGORY_NAME, "ulx lootrespawn", ulx.lootrespawn, "!lootrespawn" )
lootrespawn:defaultAccess( ULib.ACCESS_SUPERADMIN )
lootrespawn:help( "Respawns all of the loot." )

//!ModelList - Lists the names to use for models on !AddLoot in your chat
function ulx.modellist( calling_ply )
	calling_ply:ConCommand( "mu_loot_models_list" ) //Runs on callers console so it doesn't print in server console
end

local modellist = ulx.command ( CATEGORY_NAME, "ulx modellist", ulx.modellist, "!modellist" )
modellist:defaultAccess( ULib.ACCESS_SUPERADMIN )
modellist:help( "Lists the names to use for models on !AddLoot in your chat." )

//!Respawn - Respawns target(s)
function ulx.respawn( calling_ply, target_plys )
	for i=1, #target_plys do
		local v = target_plys[ i ]
		v:SetTeam( 2 ) //Makes sure they aren't a spectator
		v:Spawn() //Spawns them in
	end
	
	ulx.fancyLogAdmin( calling_ply, true, "#A respawned #T!", target_plys )
end
			
local respawn = ulx.command ( CATEGORY_NAME, "ulx respawn", ulx.respawn, "!respawn" )
respawn:addParam{ type=ULib.cmds.PlayersArg }
respawn:defaultAccess( ULib.ACCESS_SUPERADMIN )
respawn:help( "Respawns target(s.)" )

//!FTaunt - Forces target to taunt
ulx.taunts={} //Creates taunts table
ulx.taunts[1]="scream"
ulx.taunts[2]="help"
ulx.taunts[3]="funny"
ulx.taunts[4]="morose"

function ulx.ftaunt( calling_ply, target_ply, taunt_type )
	target_ply:ConCommand( "mu_taunt " .. taunt_type ) //Runs the taunt command on target
	
	ulx.fancyLogAdmin( calling_ply, "#A forced #T to use a #t taunt!", target_ply, taunt_type )
end

local ftaunt = ulx.command ( CATEGORY_NAME, "ulx ftaunt", ulx.ftaunt, "!ftaunt" )
ftaunt:addParam{ type=ULib.cmds.PlayerArg }
ftaunt:addParam{ type=ULib.cmds.StringArg, completes=ulx.taunts, hint="taunt type", error="invalid taunt type \"%s\" specified", ULib.cmds.restrictToCompletes, default="scream", ULib.cmds.optional }
ftaunt:defaultAccess( ULib.ACCESS_ADMIN )
ftaunt:help( "Forces target to taunt." )

//!ShowMurderer - Reveals the murderer's evil presence until he kills someone
function ulx.showmurderer( calling_ply )
	local players = team.GetPlayers(2)
	local murderer
	for k,v in pairs( players ) do
		if v:GetMurderer() then
			murderer = v
		end
	end
	if murderer && !murderer:GetMurdererRevealed() then
		murderer:SetMurdererRevealed(true)
	end
end

local showmurderer = ulx.command ( CATEGORY_NAME, "ulx showmurderer", ulx.showmurderer, "!showmurderer" )
showmurderer:defaultAccess( ULib.ACCESS_ADMIN )
showmurderer:help( "Reveals the murderer's evil presence until he kills someone." )