local CommandParser = require(script:GetCustomProperty("CommandParser"))

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