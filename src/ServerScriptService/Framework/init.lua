--[[

To Initialize the framework, simply require() it from a Script.

]]

local Signal = require(script:WaitForChild("Signal"))
local Players = game:GetService("Players")

local Framework = {}

local signals = {}
local finished = false
task.spawn(function()
	for i = 50, 0, -1 do
		local signal = Signal.CreateSignal()
		signal.Connect(function(player)
			print(player.Name)
		end)
        table.insert(signals, signal)
	end
	finished = true
    print('YEE')
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		repeat task.wait() until finished
		for i, v in pairs(signals) do
			v.Fire(player)
		end
	end)
end)

return Framework