--[[
To Initialize the framework, simply require() it from a Script.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Signal = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Signal"))
local Timer = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Timer"))
local Gamemode = require(script.Gamemode)

local Framework = {}

return Framework