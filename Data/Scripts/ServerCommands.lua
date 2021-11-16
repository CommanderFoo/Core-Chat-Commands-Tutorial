local CommandParser = require(script:GetCustomProperty("CommandParser"))
local ABGS = require(script:GetCustomProperty("APIBasicGameState"))

-- /setteam player team
CommandParser.AddCommand("setteam", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
		local player = CommandParser.GetPlayer(params[2])

		if player ~= nil then
			player.team = tonumber(params[3]) or player.team

			status.success = true
			status.senderMessage = "Player team set."
		else
			status.senderMessage = CommandParser.error.INVALID_PLAYER
		end
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

-- /setscore team score
CommandParser.AddCommand("setscore", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
		Game.SetTeamScore(tonumber(params[2]), tonumber(params[3]))
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

-- /endround
CommandParser.AddCommand("endround", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
		if Game.GetTeamScore(1) > Game.GetTeamScore(2) then
			Events.Broadcast("TeamVictory", 1)
		elseif Game.GetTeamScore(2) > Game.GetTeamScore(1) then
			Events.Broadcast("TeamVictory", 2)
		else
			Events.Broadcast("TieVictory")
		end

		ABGS.SetGameState(ABGS.GAME_STATE_ROUND_END)
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)