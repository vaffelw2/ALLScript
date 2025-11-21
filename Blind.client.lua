script.Parent.Blnd.Blind.BackgroundTransparency=0
local rs = game:GetService("RunService")
local starttime=tick()
repeat rs.Heartbeat:wait() until (tick()-starttime)>=script.Full.Value
local starttime=tick()
repeat rs.Heartbeat:wait() local dur=((tick()-starttime)/script.Duration.Value) script.Parent.Blnd.Blind.BackgroundTransparency=dur until (tick()-starttime)>=script.Duration.Value
script.Parent.Blnd.Blind.BackgroundTransparency=1
script.Disabled=true
