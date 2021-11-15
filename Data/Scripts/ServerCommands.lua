local CommandParser = require(script:GetCustomProperty("CommandParser"))

-- /tp toplayer
-- /tp player toplayer
CommandParser.AddCommand("tp", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.MODERATOR) then
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
CommandParser.AddCommand("kill", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
		local who = CommandParser.ParamIsValid(params[2])

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
				who = CommandParser.GetPlayer(params[2])

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

CommandParser.AddCommand("grantrp", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
		local who = CommandParser.ParamIsValid(params[2])

		if who ~= nil then
			local amount = tonumber(params[3]) or 250

			if who == "all" then
				for k, player in ipairs(Game.GetPlayers()) do
					player:GrantRewardPoints(amount, "Awarded Points")
				end

				status.success = true
				status.senderMessage = "All players granted reward points."
			else
				who = CommandParser.GetPlayer(params[2])

				if who ~= nil then
					who:GrantRewardPoints(amount, "Awarded Points")
					status.success = true
					status.senderMessage = "Player granted reward points."
					status.receiverMessage = "You have been granted " .. tostring(amount) .. " reward points." 
					status.receiverPlayer = who
				end
			end
		else
			status.senderMessage = CommandParser.error.INVALID_PLAYER
		end
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

CommandParser.AddCommand("invisible", {
	
	on = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
			sender.isVisible = false
		end
	end,

	off = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
			sender.isVisible = true
		end
	end

})

CommandParser.AddCommand("resetstorage", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
		local who = CommandParser.ParamIsValid(params[2])

		if who ~= nil then
			if who == "all" then
				for k, player in ipairs(Game.GetPlayers()) do
					if player ~= sender then
						Storage.SetPlayerData(player, {})
					end
				end

				status.success = true
				status.senderMessage = "All players reset."
			else
				who = CommandParser.GetPlayer(params[2])

				if who ~= nil then
					Storage.SetPlayerData(who, {})
					status.success = true
					status.senderMessage = "Player reset."
					status.receiverMessage = "You have been reset." 
					status.receiverPlayer = who
				end
			end
		else
			status.senderMessage = CommandParser.error.INVALID_PLAYER
		end
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

CommandParser.AddCommandData("coins", {

    name = "Coins",
    resourceKey = "coins",
    storageKey = "c"

})

CommandParser.AddCommandData("gems", {

    name = "Gems",
    resourceKey = "gems",
    storageKey = "g"

})

CommandParser.AddCommand("give", {

	resource = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.MODERATOR) then
			local who = CommandParser.GetPlayer(CommandParser.ParamIsValid(params[3]))
	
			if who ~= nil then
				local commandData = CommandParser.GetCommandData(params[4])

				if commandData ~= nil then	
					local playerData = Storage.GetPlayerData(who)
					local amount = tonumber(params[5]) or 0

					who:AddResource(commandData.resourceKey, amount)

					if not playerData[commandData.storageKey] then
						playerData[commandData.storageKey] = amount
					else
						playerData[commandData.storageKey] = playerData[commandData.storageKey] + amount
					end

					Storage.SetPlayerData(who, playerData)

					status.success = true
					status.senderMessage = "Resource successfully given."
					status.receiverMessage = "You have been gifted " .. tostring(amount) .. " " .. commandData.name .. "."
					status.receiverPlayer = who
				else
					status.senderMessage = "Command data \"" .. item .. "\" does not exist."
				end	
			else
				status.senderMessage = CommandParser.error.INVALID_PLAYER
			end
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end

})

CommandParser.AddCommand("help", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.MODERATOR) then
		local msg = { "Commands:" }

		for k, c in pairs(CommandParser.commands) do
			table.insert(msg, "/" .. k)
		end

		if #msg > 0 then
			Chat.BroadcastMessage(table.concat(msg, "\n"), { players = sender })
		end
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)


-- /setteam player team
-- CommandParser.AddCommand("setteam", function(sender, params, status)
-- 	if CommandParser.HasPermission(sender, CommandParser.permissions.MODERATOR) then
-- 		local player = CommandParser.GetPlayer(params[2])

-- 		if player ~= nil then
-- 			player.team = tonumber(params[3]) or player.team

-- 			status.success = true
-- 			status.senderMessage = "Player team set."
-- 		else
-- 			status.senderMessage = CommandParser.error.INVALID_PLAYER
-- 		end
-- 	else
-- 		status.senderMessage = CommandParser.error.NO_PERMISSION
-- 	end
-- end)