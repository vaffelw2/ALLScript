-- Client Ping Module:
local Ping = {
	CurrentPing = 0;
	Interval = 1;
}
local pingRemoteFunc = script.Parent.Parent.Functions.Ping
-- Ping the server:
function Ping:Measure()
	local start = tick()
	pingRemoteFunc:InvokeServer()
	self.CurrentPing = tick() - start -- Measure time the request took
	game.ReplicatedStorage.Events.UpdatePing:FireServer(self.CurrentPing)
end
-- Constantly check ping every "Interval" time:
function Ping:Loop()
	spawn(function()
		while (true) do
			self:Measure()
			wait(self.Interval)
		end
	end)
end
return Ping