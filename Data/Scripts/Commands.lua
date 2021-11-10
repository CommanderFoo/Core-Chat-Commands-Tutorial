local CommandParser = require(script:GetCustomProperty("CommandParser"))

-- /promote player permission
CommandParser.AddCommand("promote", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
		local promotePlayer = CommandParser.GetPlayer(params[2])

		if promotePlayer ~= nil then
			if CommandParser.SetPermission(promotePlayer, params[3]) then
				status.success = true
				status.senderMessage = promotePlayer.name .. " was successfully promoted."
			else
				status.senderMessage = CommandParser.error.INVALID_PERMISSION
			end
		else
			status.senderMessage = CommandParser.error.INVALID_PLAYER
		end
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
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
			status.senderMessage = CommandParser.error.INVALID_PLAYER
		end
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

-- /tp toplayer
-- /tp player toplayer
CommandParser.AddCommand("tp", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
		local playerA = CommandParser.GetPlayer(params[2])
		local playerB = CommandParser.GetPlayer(params[3])

		if playerA ~= nil then
			if playerB ~= nil then
				playerA:SetWorldPosition(playerB:GetWorldPosition())
				playerA:SetWorldRotation(playerB:GetWorldRotation())
			else
				sender:SetWorldPosition(playerA:GetWorldPosition())
				sender:SetWorldRotation(playerA:GetWorldRotation())
			end

			status.success = true
		else
			status.senderMessage = CommandParser.error.INVALID_PLAYER
		end
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

-- /kick player
-- /kick all
CommandParser.AddCommand("kick", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.MODERATOR) then
		local who = CommandParser.ParamIsValid(params[2])

		if who ~= nil then
			if who == "all" then
				for k, player in ipairs(Game.GetPlayers()) do
					if player ~= sender then
						player:TransferToGame("e39f3e/core-world")
					end
				end

				status.success = true
				status.senderMessage = "All players kicked."
			else
				who = CommandParser.GetPlayer(params[2])

				if who ~= nil then
					who:TransferToGame("e39f3e/core-world")

					status.success = true
					status.senderMessage = "Player kicked."
				end
			end
		else
			status.senderMessage = CommandParser.error.INVALID_PLAYER
		end
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

-- /closeserver
CommandParser.AddCommand("closeserver", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
		Game.StopAcceptingPlayers()
		status.success = true
		status.senderMessage = "Server closed."
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

-- /fly on
-- /fly off
CommandParser.AddCommand("fly", {

	on = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
			sender:ActivateFlying()
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end,

	off = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
			sender:ActivateWalking()
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end

})

-- /voice mute all
-- /voice mute player
-- /voice unmute all
-- /voice unmute player
CommandParser.AddCommand("voice", {

	mute = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.MODERATOR) then
			local who = CommandParser.ParamIsValid(params[3])

			if who ~= nil then
				if who == "all" then
					for k, player in ipairs(Game.GetPlayers()) do
						if player ~= sender then
							for i, c in pairs(VoiceChat.GetChannels()) do
								c:MutePlayer(player)
							end
						end
					end

					status.success = true
					status.senderMessage = "All players muted."
				else
					who = CommandParser.GetPlayer(params[3])

					if who ~= nil then
						for i, c in pairs(VoiceChat.GetChannels()) do
							c:MutePlayer(who)
						end

						status.success = true
						status.senderMessage = "Player muted."
					end
				end
			else
				status.senderMessage = CommandParser.error.INVALID_PLAYER
			end
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end,

	unmute = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.MODERATOR) then
			local who = CommandParser.ParamIsValid(params[3])

			if who ~= nil then
				if who == "all" then
					for k, player in ipairs(Game.GetPlayers()) do
						if player ~= sender then
							for i, c in pairs(VoiceChat.GetChannels()) do
								c:UnmutePlayer(player)
							end
						end
					end

					status.success = true
					status.senderMessage = "All players unmuted."
				else
					who = CommandParser.GetPlayer(params[3])

					if who ~= nil then
						for i, c in pairs(VoiceChat.GetChannels()) do
							c:UnmutePlayer(who)
						end

						status.success = true
						status.senderMessage = "Player unmuted."
					end
				end
			else
				status.senderMessage = CommandParser.error.INVALID_PLAYER
			end
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end

})

-- /setteam player team
CommandParser.AddCommand("setteam", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.MODERATOR) then
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

-- /speed player walkspeed
CommandParser.AddCommand("speed", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.MODERATOR) then
		local player = CommandParser.GetPlayer(params[2])

		if player ~= nil then
			player.maxWalkSpeed = tonumber(params[3]) or player.maxWalkSpeed
			status.success = true
			status.senderMessage = "Player speed set."
		else
			status.senderMessage = CommandParser.error.INVALID_PLAYER
		end
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

-- /kill all
-- /kill player
CommandParser.AddCommand("speed", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.MODERATOR) then
		local who = CommandParser.ParamIsValid(params[3])

		if who ~= nil then
			if who == "all" then
				for k, player in ipairs(Game.GetPlayers()) do
					if player ~= sender then
						player:Die()
					end
				end

				status.success = true
				status.senderMessage = "All players killed."
			else
				who = CommandParser.GetPlayer(params[3])

				if who ~= nil then
					who:Die()
					status.success = true
					status.senderMessage = "Player killed."
				end
			end
		else
			status.senderMessage = CommandParser.error.INVALID_PLAYER
		end
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

-- Command data for Coins resource
CommandParser.AddCommandData("coins", {

	name = "Coins",
	resourceKey = "coins",
	storageKey = "c"

})

-- /give resource player amount
-- /give resource all amount
CommandParser.AddCommand("give", {

	resource = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
			local commandData = CommandParser.GetCommandData(params[2])

			if commandData ~= nil then
				local who = CommandParser.ParamIsValid(params[3])
		
				if who ~= nil then
					if who == "all" then
						for k, player in ipairs(Game.GetPlayers()) do
							if player ~= sender then
								CommandParser.AddResource(player, commandData, tonumber(params[4]))
							end
						end
		
						status.success = true
						status.senderMessage = "All players given resource."
					else
						who = CommandParser.GetPlayer(params[3])
		
						if who ~= nil then
							CommandParser.AddResource(who, commandData, tonumber(params[4]))
							status.success = true
							status.senderMessage = "Player given resource."
						end
					end
				else
					status.senderMessage = CommandParser.error.INVALID_PLAYER
				end
			else
				status.senderMessage = CommandParser.error.INVALID_COMMAND_DATA
			end
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end

})