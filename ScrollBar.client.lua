repeat wait() until game.Players.LocalPlayer
repeat wait() until game.Players.LocalPlayer:FindFirstChild("Status")
repeat wait() until game.Players.LocalPlayer.Status:FindFirstChild("Role")

wait()

game:GetService("RunService").Stepped:Connect(function()
	for j, k in pairs (script.Parent:WaitForChild("ROBLOXians"):GetChildren()) do
		if k:IsA("TextButton") then
			for l, m in pairs (script.Parent:WaitForChild("ROBLOXians"):GetChildren()) do
				if m:IsA("Frame") and m.Name == k.Name then
					if m.Visible == true then
						k.Visible = true
					elseif m.Visible == false then
						k.Visible = false
					end
				end
			end
		end
	end
	
	local numFramesVisible = 0
	for i, frame in pairs(script.Parent:GetChildren()) do
		if frame:IsA("Frame") then
			for j, playerFrame in pairs(frame:GetChildren()) do
				if playerFrame:IsA("Frame") then
					if playerFrame.Visible == true then
						if playerFrame.Size.Y.Offset == 25 then
							numFramesVisible = numFramesVisible + 1
						elseif playerFrame.Size.Y.Offset == 50 then
							numFramesVisible = numFramesVisible + 2
						elseif playerFrame.Size.Y.Offset == 100 then
							numFramesVisible = numFramesVisible + 4
						end
					end
				elseif playerFrame:IsA("TextLabel") then
					local num = 0
					for i, v in pairs (frame:GetChildren()) do
						if v:IsA("Frame") and v.Visible then
							num = num + 1
						end
					end
					if num > 0 then
						playerFrame.Visible = true
						if frame.Name == "ConfirmedDead" then
							playerFrame.Text = "Confirmed Dead ("..num..")"
						elseif frame.Name == "MissingInAction" then
							playerFrame.Text = "Missing in Action ("..num..")"
						elseif frame.Name == "ROBLOXians" then
							playerFrame.Text = "Terrorists ("..num..")"
						elseif frame.Name == "Spectators" then
							playerFrame.Text = "Spectators ("..num..")"
						end
					else
						playerFrame.Visible = false
					end
					if playerFrame.Visible == true then
						numFramesVisible = numFramesVisible + 1
					end
				end
			end
		end
	end
	
	script.Parent.CanvasSize = UDim2.new(0, 0, (0.06 * numFramesVisible), 0)
	
	local background = script.Parent.Parent:WaitForChild("Background")
	
	if numFramesVisible < 11 then
		--script.Parent.ScrollingEnabled = false
		script.Parent.CanvasPosition = Vector2.new(0, 0)
		background.Size = UDim2.new(0, 605, 0, 170 + (30 * numFramesVisible))
	else
		--script.Parent.ScrollingEnabled = true
		background.Size = UDim2.new(0, 605, 0, 470)
	end
	
	script.Parent.Parent.Position = UDim2.new(0.5, -background.Size.X.Offset/2, 0.5, -background.Size.Y.Offset/2)
end)