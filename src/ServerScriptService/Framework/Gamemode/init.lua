local Gamemode = {}
local gm = require(script.Class)
Gamemode.__index = Gamemode

Gamemode._currentGamemode = false
Gamemode._state = "dead"

function Gamemode.GetCurrentGamemode(): string
    return tostring(Gamemode._currentGamemode)
end

function Gamemode.SetGamemode(gamemodeName: string)
    local gamemodeClass = gm.new(gamemodeName)
    Gamemode._currentGamemode = gamemodeClass
    return gamemodeClass
end

function Gamemode.StartGame()
    Gamemode._currentGamemode:Start()
end

function Gamemode.EndGame()
    --Gamemode._currentGamemode:Stop()
end

return Gamemode