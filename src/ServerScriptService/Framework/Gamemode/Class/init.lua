--[[
    Add a gamemode:

    Create a new ModuleScript that will act as the Class.
    Name it accordingly.

    Start a Game:

    In a script,
    then Gamemode.StartGame()

]]

local Players = game:GetService("Players")

local gm = {}
gm.__index = gm
gm._players = {}
gm._connections = {
    players = {}
}

function gm.sPrint(toPrint)
    task.spawn(function() print(toPrint) end)
end

function gm.verify(gamemodeName: string)
    local Location = script.Parent
    for _, child in pairs(Location:GetChildren()) do
        if string.match(gamemodeName, child.Name) then
            return child
        end
    end
    return false
end

function gm.new(gamemodeName: string)
    local class = gm.verify(gamemodeName)
    if not class then
        warn("COULD NOT CREATE CLASS")
        return
    end
    
    --local self = setmetatable({__index = gm}, require(class))
    --local self = setmetatable(setmetatable({}, gm), require(class))
    local self = setmetatable(require(class), gm)
    return self
end

--#region PRIVATE SCRIPT FUNCTIONS

function gm._setGamemodeGameOptions(self)
    if self.OPTIONS.CharacterAutoLoads ~= nil then
        Players.CharacterAutoLoads = self.OPTIONS.CharacterAutoLoads
    end
end

function gm._startPhaseVerifyPlayers(self) -- Verify and Init current players and players added upon PlayerAdded during the game start phase

    local conn = Players.PlayerAdded:Connect(function(player)
        gm._initPlayer(self, player)
    end)
    for _, plr in pairs(Players:GetPlayers()) do
        gm._initPlayer(self, plr)
    end

    if #gm._players < self.OPTIONS.requiredPlayerCount then
        repeat task.wait() until #gm._players >= self.OPTIONS.requiredPlayerCount
    end

    conn:Disconnect()
    return gm._players
end

function gm._postStartPhaseVerifyPlayers(self) -- Verify players upon PlayerAdded after the game has started
    gm._connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        if #gm._players >= self.OPTIONS.maximumPlayerCount then
            -- add player to spectator
        else
            gm._initPlayer(self, player)
        end
    end)
end

function gm._reloadCharacters()
    for _, plr in pairs(gm._players) do
        plr:LoadCharacter()
    end
end

function gm._initPlayer(self, player: Player) -- init character added connection, add player to players
    table.insert(gm._players, player)
    gm._connections.players[player.Name] = {
        player.CharacterAdded:Connect(function(character)
            gm._initCharacter(self, player, character)
        end)
    }
end

function gm._initCharacter(self, player: Player, character: Model) -- SpawnCharacter, init PlayerDied
    self:SpawnCharacter(character)
    character:WaitForChild("Humanoid").Died:Once(function()
        gm:PlayerDied(player)
    end)
end

--#endregion

--#region PUBLIC CLASS OVERRIDE FUNCTIONS

--[[==
    Start:
    Called when Gamemode.StartGame()
]]

function gm:Start()

    -- wait for required players
    local players = self:_startPhaseVerifyPlayers()

    -- connnect player added connection
    self:_postStartPhaseVerifyPlayers()

    -- set game options
    self:_setGamemodeGameOptions()

    -- reload characters
    gm._reloadCharacters()

end

--[[==
    SpawnCharacter:
    Called when a Character is added.
    Automatically bound to player.CharacterAdded
]]

function gm:SpawnCharacter(character: Model)
    local location = workspace:FindFirstChild("SpawnLocation")
    if location then
        character:PivotTo(location.CFrame)
    end
end

--[[==
    PlayerDied:
    Called when a Humanoid Player dies.
    Automatically bound to player.Character.Humanoid.Died
]]

function gm:PlayerDied(player: Player)
    task.wait(1)
    player:LoadCharacter()
end

--#endregion

return gm