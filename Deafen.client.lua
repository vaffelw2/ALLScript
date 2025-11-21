script.Parent.Sounds.Ringing.Volume=0
script.Parent.Sounds.Ringing:Play()
game.SoundService.Sounds.Flashbang.Enabled=true
game.SoundService.Sounds.Distortion.Enabled=true
game.SoundService.Sounds.Volume=0
local rs = game:GetService("RunService")
spawn(function()
	while script.Parent.Sounds.Ringing.Volume<1 do
	rs.RenderStepped:wait()
	script.Parent.Sounds.Ringing.Volume=math.min(1,script.Parent.Sounds.Ringing.Volume+.003)
	if game.SoundService.Sounds.Flashbang.Enabled==false then
		break
	end
	end
end)
local starttime=tick()
repeat rs.Heartbeat:wait() until (tick()-starttime)>=script.Full.Value
local starttime=tick()
game.SoundService.Sounds.Flashbang.Enabled=false
game.SoundService.Sounds.Distortion.Enabled=false
repeat rs.Heartbeat:wait() local dur=((tick()-starttime)/script.Duration.Value) script.Parent.Sounds.Ringing.Volume=1-dur game.SoundService.Sounds.Volume=dur until (tick()-starttime)>=script.Duration.Value
game.SoundService.Sounds.Volume=1
script.Parent.Sounds.Ringing.Volume=0


script.Parent.Sounds.Ringing:Stop()
script.Disabled=true
