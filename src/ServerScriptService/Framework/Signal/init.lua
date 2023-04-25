--[[

    local s = Signal.CreateSignal()
    s.Connect(function() end)
    s.Disconnect()

    Maybe add automatic cacheing
    If a signal remains unconnected for some time then move it to "Cache", once it is connected move it back to stored

]]

local RunService = game:GetService("RunService")

local Signal = {}
Signal.__index = Signal
Signal._currentIDIndex = 0
Signal._stored = {}

function Signal.CreateSignal()
    local t = setmetatable({}, Signal)
    t.__index = t
    t._id = Signal._generateSignalID()
    t._connected = false
    t._execute = false
    t._currentRunFunction = nil
    t._currentRunArguments = nil

    t.Connect = function(functionToExecute)
        t._connected = true
        t._currentRunFunction = functionToExecute
    end

    t.Disconnect = function()
        t._connected = false
        t._currentRunFunction = nil
    end

    t.Fire = function(...)
        t._execute = true
        t._currentRunArguments = table.pack(...)
    end
    
    table.insert(Signal._stored, t)

    return t
end

--#region PRIVATE SCRIPT FUNCTIONS

function Signal._generateSignalID()
    Signal._currentIDIndex += 1
    return Signal._currentIDIndex
end

function Signal._getSignalFromID(id: number)
    for i, v in pairs(Signal._stored) do
        if v.id == id then return v, i end
    end
    return false
end

function Signal._update()
    for i, signal in pairs(Signal._stored) do
        if signal._connected and signal._execute then
            task.spawn(function()
                signal._execute = false
                signal._currentRunFunction(table.unpack(signal._currentRunArguments))
            end)
        end
    end
end

--#endregion

RunService.Heartbeat:Connect(Signal._update)

return Signal