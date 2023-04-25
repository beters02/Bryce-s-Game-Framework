--[[
    Add a gamemode:

    Create a new ModuleScript that will act as the Class.
    Name it accordingly.


]]

local gm = {}
gm.__index = gm

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

function gm:Start()
    
end

return gm