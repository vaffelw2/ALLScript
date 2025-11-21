
script.Parent.Touched:connect(function(humanoid)
if humanoid.Parent:FindFirstChild("Humanoid") then
local nig=humanoid.Parent.Humanoid
if nig.Parent:FindFirstChild("HostagePicked") then
	local Character=nig.Parent
if Character:FindFirstChild("HostagePicked")  then
local variant="A"
if Character.HostagePicked:FindFirstChild("Variant") then
variant=Character.HostagePicked.Variant.Value
end
Character["HostagePicked"]:Destroy()
local niggie=game.ReplicatedStorage["Hostage_"..variant]:clone()
niggie.Parent=game.Workspace:WaitForChild("Map"):WaitForChild("Regen")
niggie.Name="Hostage"
local ray=Ray.new(Character:WaitForChild("Torso").Position,Vector3.new(0,-100,0))
local hit,pos=game.Workspace:FindPartOnRay(ray,Character)
if hit then
niggie:WaitForChild("Torso").Anchored=false
niggie:WaitForChild("Torso").CFrame=CFrame.new(pos+Vector3.new(0,1.8,0))
niggie:WaitForChild("Torso").Anchored=true
niggie.Name="Hostage"
local int=Instance.new("IntValue")
int.Parent=niggie
int.Name="Dont"
if game.Workspace.MVP.Value=="" then
game.Workspace.MVP.Value=Character.Name
game.Workspace.Rescued.Value=true
game.ReplicatedStorage.LaggyPleb:Fire("H", "OST", "IE", nil, Character.Name)
--game.Workspace.Rescued.Rescue:Play()
end

end
end



end

end
end)