local module = {}






module.visualizePoint = function(position)
		local point = Instance.new("Part")
	
	point.Anchored = true
point.CanCollide = false
point.BrickColor = BrickColor.new("Bright yellow")
point.Transparency=1
point.Shape="Ball"
point.Material="Neon"
point.Size=Vector3.new(0.2,0.2,0.2)
	local brick = point:Clone()
	brick.CFrame = CFrame.new(position)
	brick.Parent = workspace["Ray_Ignore"]
	brick.Transparency=1
	local att1=Instance.new("Attachment")
att1.Position=Vector3.new(0,0.1,0)
local att2=Instance.new("Attachment")
att2.Position=Vector3.new(0,-0.1,0)
att1.Parent=brick
att2.Parent=brick
	local trail=script.Trail:clone()
trail.Parent=brick
trail.Attachment0=att1
trail.Attachment1=att2
trail.Enabled=false
	return brick
end



return module