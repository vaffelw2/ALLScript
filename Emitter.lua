local self = script.Parent
local particles = self:WaitForChild("Particles")
local debris = game:GetService("Debris")
local emitter={}
function emitter.emit(part)
	assert(typeof(part) == "Instance","Argument #1 should be an Instance (of type BasePart or Attachment)")
	assert(part:IsA("BasePart") or part:IsA("Attachment"),"Argument #1 should be either a BasePart or an Attachment")
	
	for _,particle in pairs(particles:GetChildren()) do
		local rep = particle:Clone()
		rep.Parent = part
		local count = 1
		if particle:FindFirstChild("EmitCount") then
			count = particle.EmitCount.Value
		end
		spawn(function()
			rep:Emit(count)
			delay(particle.Lifetime.Max,function()
				rep:Destroy()
			end)
		end)
	end
end

return emitter