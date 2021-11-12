local CommandParser = require(script:GetCustomProperty("CommandParser"))

CommandParser.AddCommand("print", {
	
	time = function(sender, params, status)
		status.success = true
		status.senderMessage = "Time is: " .. tostring(DateTime.CurrentTime({ isLocal = true })) .. "."
	end,

	word = function(sender, params, status)
		if params[3] ~= nil then
			status.success = true
			status.senderMessage = "The word was: " .. params[3]
		end
	end

})