local CommandParser = {

	permissions = require(script:GetCustomProperty("CommandPermissions")),
	data = {},
	commands = {},
	storageKey = "cmdperm"

}

CommandParser.HasPermission = function(sender, permission)
	if not Object.IsValid(sender) or not sender:IsA("Player") then
		return false
	end

	if permission.names ~= nil then
		for i, n in ipairs(permission.names) do
			if sender.name == n then
				return true
			end
		end
	else
		if sender:GetResource(CommandParser.storageKey) >= permission.id then
			return true
		end
	end

	return false
end

CommandParser.GetPlayer = function(receiver)
	receiver = CommandParser.ParamIsValid(receiver)

	if receiver == nil then
		return nil
	end

	for i, player in ipairs(Game.GetPlayers()) do
		if player.name == receiver then
			return player
		end
	end

	return nil
end

CommandParser.SetPermission = function(player, perm)
	perm = CommandParser.GetPermission(perm)

	if perm ~= nil and perm.id ~= nil then
		local data = Storage.GetPlayerData(player)

		data[CommandParser.storageKey] = perm.id or 0

		player:SetResource(CommandParser.storageKey, perm.id or 0)
		Storage.SetPlayerData(player, data)

		return true
	end

	return false
end

CommandParser.RemovePermission = function(player)
	local data = Storage.GetPlayerData(player)

	data[CommandParser.storageKey] = 0

	player:SetResource(CommandParser.storageKey, 0)
	Storage.SetPlayerData(player, data)

	return true
end

CommandParser.GetPermission = function(perm)
	perm = CommandParser.ParamIsValid(perm, true)

	for k, p in pairs(CommandParser.permissions) do
		if string.lower(k) == perm then
			return p
		end
	end

	return nil
end

CommandParser.ParamIsValid = function(param, lower)
	if param ~= nil then
		param = CoreString.Trim(tostring(param) or "")

		if string.len(param) > 0 then
			if lower then
				param = string.lower(param)
			end
			
			return param
		end
	end

	return nil
end


CommandParser.GetPlayerPrefix = function(player)
	local prefix = ""
	local data = Storage.GetPlayerData(player)
	local permID = data[CommandParser.storageKey] or 0

	for k, p in pairs(CommandParser.permissions) do
		local hasPerm = false

		if p.names ~= nil then
			for i, n in ipairs(p.names) do
				if n == player.name then
					hasPerm = true
					prefix = "[" .. p.name .. "]"
					break
				end
			end
		end

		if not hasPerm and p.id ~= nil and p.id == permID then
			prefix = "[" .. p.name .. "]"
			hasPerm = true
			break
		end
	end

	return prefix
end

CommandParser.ParseMessage = function(speaker, params)
	local message = params.message
	local prefix = CommandParser.GetPlayerPrefix(speaker)
	
	params.speakerName = prefix .. params.speakerName

	if message:sub(1, 1) == "/" then
		local status = {

			success = false,
			senderMessage = "Invalid command",
			receiverMessage = nil,
			receiverPlayer = nil

		}

		local tokens = { CoreString.Split(message:sub(2), " ") }
		local command = CommandParser.ParamIsValid(tokens[1])
		local theCommand = CommandParser.commands[command]

		if theCommand ~= nil then
			if type(theCommand) == "table" then
				local subCommand = CommandParser.ParamIsValid(tokens[2])

				if subCommand ~= nil and theCommand[subCommand] ~= nil then
					theCommand = theCommand[subCommand]
				end
			end

			theCommand(speaker, tokens, status)
		end

		Chat.BroadcastMessage(status.senderMessage, { players = speaker })

		if status.success and status.receiverMessage ~= nil and Object.IsValid(status.receiverPlayer) then
			Chat.BroadcastMessage(status.receiverMessage, { players = status.receiverPlayer })
		end

		params.message = ""
	end
end

CommandParser.ReceiveMessage = function(speaker, params)
	CommandParser.ParseMessage(speaker, params)
end

Chat.receiveMessageHook:Connect(CommandParser.ReceiveMessage)

CommandParser.AddCommandData = function(key, perk)
	CommandParser.data[key] = perk
end

CommandParser.GetCommandData = function(key)
	return CommandParser.data[key]
end

CommandParser.AddCommand = function(key, command)
	CommandParser.commands[key] = command
end

CommandParser.init = function()
	Game.playerJoinedEvent:Connect(function(player)
		local data = Storage.GetPlayerData(player)

		if data.perm ~= nil then
			player:SetResource(CommandParser.storageKey, data.perm)
		end
	end)
end

CommandParser.init()

return CommandParser