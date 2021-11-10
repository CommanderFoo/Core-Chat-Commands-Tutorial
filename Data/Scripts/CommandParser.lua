local CommandParser = {

	permissions = require(script:GetCustomProperty("CommandPermissions")),
	data = {},
	commands = {},
	storageKey = "cmdperm",

	error = {

		INVALID = "Invalid command.",
		INVALID_SUB_COMMAND = "Invalid sub command.",
		INVALID_PLAYER = "Invalid player.",
		INVALID_PERMISSION = "Invalid permission.",
		NO_PERMISSION = "You do not have permission.",
		INVALID_COMMAND_DATA = "Invalid command data."

	}
}

CommandParser.HasPermission = function(sender, permission)
	if not Object.IsValid(sender) or not sender:IsA("Player") then
		return false
	end

	for k, p in pairs(CommandParser.permissions) do
		if p.names ~= nil then
			for i, n in ipairs(p.names) do
				if n == sender.name then
					return true
				end
			end
		end
	end

	if permission.id ~= nil and sender:GetResource(CommandParser.storageKey) >= permission.id then
		return true
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
			senderMessage = "",
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

			if theCommand ~= nil and type(theCommand) == "function" then
				theCommand(speaker, tokens, status)
			else
				status.senderMessage = CommandParser.error.INVALID_SUB_COMMAND
			end
		end

		if string.len(status.senderMessage) > 0 then
			Chat.BroadcastMessage(status.senderMessage, { players = speaker })
		end

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

CommandParser.AddResource = function(player, commandData, amount)
	local playerData = Storage.GetPlayerData(player)

	player:AddResource(commandData.resourceKey, amount or 0)

	if not playerData[commandData.storageKey] then
		playerData[commandData.storageKey] = amount
	else
		playerData[commandData.storageKey] = playerData[commandData.storageKey] + amount
	end

	Storage.SetPlayerData(player, playerData)
end

CommandParser.RemoveResource = function(player, commandData, amount)
	local playerData = Storage.GetPlayerData(player)

	player:RemoveResource(commandData.resourceKey, amount or 0)

	if not playerData[commandData.storageKey] then
		playerData[commandData.storageKey] = amount
	else
		playerData[commandData.storageKey] = math.max(0, playerData[commandData.storageKey] - amount)
	end

	Storage.SetPlayerData(player, playerData)
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