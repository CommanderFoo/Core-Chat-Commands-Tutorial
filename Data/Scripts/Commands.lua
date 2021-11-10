local CommandParser = require(script:GetCustomProperty("CommandParser"))

-- /promote player permission
CommandParser.AddCommand("promote", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ROOT_ADMIN) then
		local promotePlayer = CommandParser.GetPlayer(params[2])

		if promotePlayer ~= nil then
			if CommandParser.SetPermission(promotePlayer, params[3]) then
				status.success = true
				status.senderMessage = promotePlayer.name .. " was successfully promoted."
			else
				status.senderMessage = "Invalid permission."
			end
		else
			status.senderMessage = "Invalid player."
		end
	else
		status.senderMessage = "You do not have permission."
	end
end)

-- /demote player
CommandParser.AddCommand("demote", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ROOT_ADMIN) then
		local demotePlayer = CommandParser.GetPlayer(params[2])

		if demotePlayer ~= nil then
			CommandParser.RemovePermission(demotePlayer)
			status.success = true
			status.senderMessage = demotePlayer.name .. " was successfully deomoted."
		else
			status.senderMessage = "Invalid player."
		end
	else
		status.senderMessage = "You do not have permission."
	end
end)