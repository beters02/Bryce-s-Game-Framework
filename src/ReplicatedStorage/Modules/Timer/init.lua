local RunService = game:GetService("RunService")
local Signal = require(script.Parent.Signal)

local Timer = {}
Timer.__index = Timer

function Timer.New(lengthSec: number)
    local self = setmetatable({}, Timer)
    self._length = lengthSec
    self._start = nil
    self._end = nil
    self._active = false
    self._paused = false
    self._conn = nil
    self._time = nil
    self._print = nil
    self._lastSec = nil
    self._ended = Signal.CreateSignal()
    return self
end

function Timer:Start()
    if self._paused then -- resume
        self._paused = false
    else
        self._active = true
    end
    self._start = tick()
    self._end = tick() + self._length
    self:_connect()
end

function Timer:Pause()
    self._length -= self._end - tick()
    self._conn:Disconnect()
    self._paused = true
end

function Timer:Stop()
    self._ended.Fire()
    task.delay(1, self._ended.Destroy)
    self._conn:Disconnect()
    self = nil
end

function Timer._connect(self)
    if RunService:IsClient() then
        self._conn = RunService.RenderStepped:Connect(function()
            self:_update()
        end)
    else
        self._conn = RunService.Heartbeat:Connect(function()
            self:_update()
        end)
    end
end

function Timer._update(self)
    self._time = math.round(self._end - tick())
    if tick() >= self._end then
        self:Stop()
    end
    local Last = self._time - (self._time % 1)
    if not self._lastSec or (Last < self._lastSec) then
        self._lastSec = Last
        if self._print then print(tostring(self._time)) end
    end
end

return Timer