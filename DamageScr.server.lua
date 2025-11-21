local h = 100
local timer=0
local RunService	= game:GetService("RunService")
repeat wait() until script.Parent.Humanoid:FindFirstChild("Assist")
local assist=script.Parent.Humanoid:FindFirstChild("Assist")
local killer=""
local v=script.Parent:WaitForChild("Humanoid")
local nono=0

v.ChildAdded:connect(function(c)
	if c and c.Name=="creator" then
	else
		return
	end
	
	if v and v:FindFirstChild("creator") and v.creator.Value then
		if killer==v.creator.Value.Name then
		else
			if game.Players:FindFirstChild(killer) and game.Players:FindFirstChild(killer).Status.Team.Value==v.creator.Value.Status.Team.Value then
				assist.Value=killer
				timer=5
				if RunService:IsStudio() then
					timer=100
				end
			end
		end
		
		killer=v.creator.Value.Name
		
	end
end)

while wait(1) do
	if timer>0 then
		timer=timer-1
	else
		if assist.Value~="" then
			killer=""
			assist.Value=""
		end
	end
end

