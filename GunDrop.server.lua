local gunname=script.Parent.Name


if game.ReplicatedStorage.HUInfo:FindFirstChild(gunname) and game.ReplicatedStorage.HUInfo[gunname].WalkSpeed.Value<=230 then
local impact=script.Impact4:clone()
impact.Parent=script.Parent
impact.Name="Impact1"
local impact=script.Impact5:clone()
impact.Parent=script.Parent
impact.Name="Impact2"
local impact=script.Impact6:clone()
impact.Parent=script.Parent
impact.Name="Impact3"
else
local impact=script.Impact1:clone()
impact.Parent=script.Parent
impact.Name="Impact1"
local impact=script.Impact2:clone()
impact.Parent=script.Parent
impact.Name="Impact2"
local impact=script.Impact3:clone()
impact.Parent=script.Parent
impact.Name="Impact3"
end
local imp=false

local parts=script.Parent.Parent:GetChildren()
for i=1,#parts do
	
	
	
if parts[i].className=="Part" and parts[i].Transparency==0 then
script.Parent.Touched:connect(function(h)
if not h:IsDescendantOf(script.Parent.Parent) and imp==false and h and h.Transparency<1 and script.Parent.Anchored==false  then
imp=true
delay(1,function()
	imp=false
end)
local s=script.Parent["Impact"..math.random(1,3)]:clone()
s.Parent=script.Parent
s.Name="Impact"
s:Play()
delay(2,function()
s:Destroy()
end)
end	
end)
end
end

