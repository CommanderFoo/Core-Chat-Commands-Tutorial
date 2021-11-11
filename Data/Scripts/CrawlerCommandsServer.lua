local CommandParser = require(script:GetCustomProperty("CommandParser"))

-- /give xp player amount
-- /give coins player amount
CommandParser.AddCommand("give", {

	xp = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
			local who = CommandParser.GetPlayer(params[3])
		
			if who ~= nil then
				local amount = tonumber(params[4])

				if amount > 0 then
					CommandParser.AddResource(who, "XP", "XP", amount)
					status.success = true
					status.senderMessage = "Player given XP."
				else
					status.senderMessage = CommandParser.error.INVALID_VALUE
				end
			else
				status.senderMessage = CommandParser.error.INVALID_PLAYER
			end
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end,

	coins = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
			local who = CommandParser.GetPlayer(params[3])
		
			if who ~= nil then
				local amount = tonumber(params[4])

				if amount > 0 then
					CommandParser.AddResource(who, "Coins", "Coins", amount)
					status.success = true
					status.senderMessage = "Player given Coins."
				else
					status.senderMessage = CommandParser.error.INVALID_VALUE
				end
			else
				status.senderMessage = CommandParser.error.INVALID_PLAYER
			end
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end

})

CommandParser.AddCommand("reset", {

	level = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
			local who = CommandParser.GetPlayer(params[3])

			if who ~= nil then
				CommandParser.SetResource(who, "XP", "XP", 0)
				status.success = true
				status.senderMessage = "Player level reset."
			else
				status.senderMessage = CommandParser.error.INVALID_PLAYER
			end
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end,

	coins = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
			local who = CommandParser.GetPlayer(params[3])

			if who ~= nil then
				CommandParser.SetResource(who, "Coins", "Coins", 0)
				status.success = true
				status.senderMessage = "Player coins reset."
			else
				status.senderMessage = CommandParser.error.INVALID_PLAYER
			end
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end
	
})

CommandParser.AddCommand("heal", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
		local who = CommandParser.GetPlayer(params[2]) or sender

		if who ~= nil then
			who:ApplyDamage(Damage.New(-1000))
		else
			status.senderMessage = CommandParser.error.INVALID_PLAYER
		end
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

CommandParser.AddCommand("killnpcs", function(sender, params, status)
	if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
		local objs = World.GetRootObject():GetChildren()
		local count = 0

		for i, c in ipairs(objs) do
			if c.name:find("NPC") then
				local attackServer = c:FindChildByName("NPCAttackServer")

				if attackServer ~= nil then
					attackServer.context.ApplyDamage(Damage.New(50000), sender)
					count = count + 1
				end
			end
		end

		status.success = true
		status.senderMessage = "NPC's killed " .. tostring(count) .. "."
	else
		status.senderMessage = CommandParser.error.NO_PERMISSION
	end
end)

local regen_players = {}
local regen_task = nil

-- /regen on player
-- /regen off player
CommandParser.AddCommand("regen", {
	
	on = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
			local who = CommandParser.GetPlayer(params[3]) or sender

			if who ~= nil then
				status.success = true

				if regen_players[who.id] == nil then
					regen_players[who.id] = who
					status.senderMessage = "Health regen turned on."
				else
					status.senderMessage = "Health regen already on."
					return
				end

				if regen_task == nil then
					regen_task = Task.Spawn(function()
						local count = 0

						for id, player in pairs(regen_players) do
							if Object.IsValid(player) then
								player:ApplyDamage(Damage.New(-1000))
								count = count + 1
							end
						end

						if count == 0 then
							regen_task:Cancel()
							regen_task = nil
							regen_players = {}
						end
					end)

					regen_task.repeatCount = -1
					regen_task.repeatInterval = .5
				end
			else
				status.senderMessage = CommandParser.error.INVALID_PLAYER
			end
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end,

	off = function(sender, params, status)
		if CommandParser.HasPermission(sender, CommandParser.permissions.ADMIN) then
			local who = CommandParser.GetPlayer(params[3]) or sender

			if who ~= nil then
				status.success = true

				if regen_players[who.id] ~= nil then
					regen_players[who.id] = nil
					status.senderMessage = "Health regen turned off."
				else
					status.senderMessage = "Health regen already off."
				end
			else
				status.senderMessage = CommandParser.error.INVALID_PLAYER
			end
		else
			status.senderMessage = CommandParser.error.NO_PERMISSION
		end
	end

})