local local_player = Game.GetLocalPlayer()

local_player.resourceChangedEvent:Connect(function(resource, key, amount)
	print(key, amount)
end)