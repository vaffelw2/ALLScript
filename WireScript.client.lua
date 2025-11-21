-- I commented the entire script out for now since we're not working on it and it may cause errors

--[[
script.Parent.MouseEnter:connect(function()
	if script.Parent.Parent.Parent.Parent.Cut.Value == 0 then
		script.Parent.Parent.Scissors.Visible = true
	end
end)

script.Parent.MouseLeave:connect(function()
	script.Parent.Parent.Scissors.Visible = false
end)

script.Parent.MouseButton1Up:connect(function()
	if script.Parent.Parent.Parent.Parent.Cut.Value == 0 then
		if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Cut") then
			game.Players.LocalPlayer.PlayerGui.Sounds.Cut:Play()
		end
		script.Parent.Parent.Parent.Parent.Cut.Value = 1
		script.Parent.Parent.Wire.Visible = false
		script.Parent.Parent.Scissors.Visible = false
		
		if script.Parent.Parent:FindFirstChild("Dangerous") == nil then
			if  script.Parent.Parent.Parent.Parent.Parent.Parent.C4Object.Value and  script.Parent.Parent.Parent.Parent.Parent.Parent.C4Object.Value:FindFirstChild("Time") then
				script.Parent.Parent.Parent.Parent.Parent.Parent.C4Object.Value.Script.Disabled = true
				script.Parent.Parent.Parent.Parent.Parent.Parent.C4Object.Value.Time:Destroy()
				script.Parent.Parent.Parent.Parent.Parent.Parent.C4Object.Value.Parent:WaitForChild("HUD"):WaitForChild("SurfaceGui").TextLabel.Visible = false
				script.Parent.Parent.Parent.Parent.Parent.Parent.C4Object.Value.Parent:WaitForChild("HUD"):WaitForChild("SurfaceGui").Script.Disabled = true
			end
		else
			if script.Parent.Parent.Parent.Parent.Parent.Parent.C4Object.Value then
				local explosion = Instance.new("IntValue")
				explosion.Name = "BOOM"
				explosion.Parent = script.Parent.Parent.Parent.Parent.Parent.Parent.C4Object.Value
			end
			script.Parent.Parent.Parent.Parent.Parent.Parent.Visible = false
			script.Parent.Parent.Parent.Parent.Parent.Parent.Modal = false
		end
		script.Parent.Parent.WireCut.Visible = true
	end
end)
]]--