local Permissions = {

	-- Local preview / mp add Bot1
	
	CREATOR = {

		names = { "CommanderFoo" },
		name = "Creator"

	},

	ADMIN = {

		priority = 50,
		name = "Admin"

	},

	MODERATOR = {

		priority = 30,
		name = "Moderator"

	}

}

-- Add Bot1 if the game is local for testing local
-- multiplayer preview.
if Environment.IsLocalGame() then
	table.insert(Permissions.CREATOR.names, "Bot1")
end

return Permissions