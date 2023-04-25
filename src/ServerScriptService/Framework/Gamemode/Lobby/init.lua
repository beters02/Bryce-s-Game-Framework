local LobbyGM = {}
LobbyGM.__index = LobbyGM

LobbyGM.OPTIONS = {
    requiredPlayerCount = 1,
    maximumPlayerCount = 10,

    CharacterAutoLoads = false,
}

--#region PUBLIC CLASS OVERRIDE FUNCTIONS

--[[==
    Start:
    Called when Gamemode.StartGame()
]]

--[[function LobbyGM:Start()
end]]

--[[==
    SpawnCharacter:
    Called when a Character is added.
    Automatically bound to player.CharacterAdded
]]

--[[function LobbyGM:SpawnCharacter(character: Model)
end]]

--[[==
    PlayerDied:
    Called when a Humanoid Player dies.
    Automatically bound to player.Character.Humanoid.Died
]]

--[[function LobbyGM:PlayerDied(player: Player)
end]]

--#endregion

return LobbyGM