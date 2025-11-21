local rs = game:GetService("RunService")
spawn(function()
while script.Parent.Transparency>0.5 do
	rs.Stepped:wait()
	script.Parent.Transparency=math.max(0.5,script.Parent.Transparency-.4)
	local scale=1*(1-script.Parent.Transparency)
local oldcf=script.Parent.CFrame
script.Parent.Size=Vector3.new(175*scale,175*scale,175*scale)
script.Parent.CFrame=oldcf
end
wait(.1)
while script.Parent.Transparency<1 do
	rs.Stepped:wait()
	script.Parent.Transparency=math.min(1,script.Parent.Transparency+.2)
	local scale=1*(1-script.Parent.Transparency)
local oldcf=script.Parent.CFrame
script.Parent.Size=Vector3.new(175*scale,175*scale,175*scale)
script.Parent.CFrame=oldcf
end
end)
for i=1,10 do
local particle=script.Parent:WaitForChild("Particle"):clone()
particle.Parent=script.Parent
particle.Enabled=true
delay(12,function()
	particle:Destroy()
end)
delay(0.2,function()
particle.Enabled=false
end) 
local particle=script.Parent:WaitForChild("CartoonExplosion"):clone()
particle.Parent=script.Parent
particle.Enabled=true
delay(12,function()
	particle:Destroy()
end)
delay(0.2,function()
particle.Enabled=false
end) 
end

wait(6)


script.Parent:destroy()