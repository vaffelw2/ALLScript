wait(3)

local player = game.Players.LocalPlayer

local tinsert = table.insert

local first = script.Parent.Parent.Parent.Parent:WaitForChild("ROBLOXians")
local second = script.Parent.Parent.Parent.Parent:WaitForChild("MissingInAction")
local third = script.Parent.Parent.Parent.Parent:WaitForChild("ConfirmedDead")
local fourth = script.Parent.Parent.Parent.Parent:WaitForChild("Spectators")

local ROBLOXians = {}
local missingIA = {}
local confirmedDead = {}
local spectators = {}


for i, v in pairs (first:GetChildren()) do
	if v:IsA("Frame") then
		tinsert(ROBLOXians, v)
	end
end

for i, v in pairs (second:GetChildren()) do
	if v:IsA("Frame") then
		tinsert(missingIA, v)
	end
end

for i, v in pairs (third:GetChildren()) do
	if v:IsA("Frame") then
		tinsert(confirmedDead, v)
	end
end

for i, v in pairs (fourth:GetChildren()) do
	if v:IsA("Frame") then
		tinsert(spectators, v)
	end
end

--Frame Positions
local frame = {}
for i = 30, 1800, 30 do
	wait()
	tinsert(frame, UDim2.new(0, 0, 0, i))
end

function updateScroll()
	local numROBLOXians = 0
	for i, v in pairs (first:GetChildren()) do
		if v:IsA("Frame") and v.Visible then
			if v.Size.Y.Offset == 25 then
				numROBLOXians = numROBLOXians + 1
			elseif v.Size.Y.Offset == 50 then
				numROBLOXians = numROBLOXians + 2
			end
		end
	end
	
	local numMissingIA = 0
	if second.Visible == true then
		for j = 1, #missingIA do
			if missingIA[j].Visible == true then
				if missingIA[j].Size.Y.Offset == 25 then
					numMissingIA = numMissingIA + 1
				else
					numMissingIA = numMissingIA + 4
				end
			end
		end
	end
	
	local numDead = 0
	for k = 1,#confirmedDead do
		if confirmedDead[k].Visible == true then
			if confirmedDead[k].Size.Y.Offset == 25 then
				numDead = numDead + 1
			end
		end
	end
	
	if first.ROBLOXians.Visible == true then
		second.Position = frame[numROBLOXians + 1]
	else
		second.Position = UDim2.new(0, 0, 0, 0)
	end
	
	if second.Visible == true then
		if first.ROBLOXians.Visible == true and second.MissingInAction.Visible ==  true then
			third.Position = frame[numROBLOXians + numMissingIA + 2]
		elseif first.ROBLOXians.Visible == true and second.MissingInAction.Visible == false then
			third.Position = frame[numROBLOXians + 1]
		elseif first.ROBLOXians.Visible == false and second.MissingInAction.Visible == true then
			third.Position = frame[numMissingIA + 1]
		elseif first.ROBLOXians.Visible == false and second.MissingInAction.Visible == false then
			third.Position = UDim2.new(0, 0, 0, 0)
		end
	else
		if first.ROBLOXians.Visible == true then
			third.Position = frame[numROBLOXians + 1]
		else
			third.Position = UDim2.new(0, 0, 0, 0)
		end
	end
	
	if second.Visible == true then
		if first.ROBLOXians.Visible == true and second.MissingInAction.Visible == true and third.ConfirmedDead.Visible == true then
			fourth.Position = frame[numROBLOXians + numMissingIA + numDead + 3]
		elseif first.ROBLOXians.Visible == false and second.MissingInAction.Visible == true and third.ConfirmedDead.Visible == true then
			fourth.Position = frame[numMissingIA + numDead + 2]
		elseif first.ROBLOXians.Visible == false and second.MissingInAction.Visible == true and third.ConfirmedDead.Visible == false then
			fourth.Position = frame[numMissingIA + 1]
		elseif first.ROBLOXians.Visible == false and second.MissingInAction.Visible == false and third.ConfirmedDead.Visible == true then
			fourth.Position = frame[numDead + 1]
		elseif first.ROBLOXians.Visible == true and second.MissingInAction.Visible == false and third.ConfirmedDead.Visible == true then
			fourth.Position = frame[numROBLOXians + numDead + 2]
		elseif first.ROBLOXians.Visible == true and second.MissingInAction.Visible == true and third.ConfirmedDead.Visible == false then
			fourth.Position = frame[numROBLOXians + numMissingIA + 2]
		elseif first.ROBLOXians.Visible == false and second.MissingInAction.Visible == false and third.ConfirmedDead.Visible == false then
			fourth.Position = UDim2.new(0, 0, 0, 0)
		elseif first.ROBLOXians.Visible == true and second.MissingInAction.Visible == false and third.ConfirmedDead.Visible == false then
			fourth.Position = frame[numROBLOXians + 1]
		end
	else
		if first.ROBLOXians.Visible == true and third.ConfirmedDead.Visible == true then
			fourth.Position = frame[numROBLOXians + numDead + 2]
		elseif first.ROBLOXians.Visible == true and third.ConfirmedDead.Visible == false then
			fourth.Position = frame[numROBLOXians + 1]
		elseif first.ROBLOXians.Visible == false and third.ConfirmedDead.Visible == true then
			fourth.Position = frame[numDead + 1]
		elseif first.ROBLOXians.Visible == false and third.ConfirmedDead.Visible == false then
			fourth.Position = UDim2.new(0, 0, 0, 0)
		end
	end
	
	for j, k in pairs (script.Parent.Parent.Parent:GetChildren()) do
		if k:IsA("TextButton") then
			for l, m in pairs (script.Parent.Parent.Parent:GetChildren()) do
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
	for i, frame in pairs(script.Parent.Parent.Parent.Parent:GetChildren()) do
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
	
	script.Parent.Parent.Parent.Parent.CanvasSize = UDim2.new(0, 0, (0.06 * numFramesVisible), 0)
	
	local background = script.Parent.Parent.Parent.Parent.Parent:WaitForChild("Background")
	
	if numFramesVisible < 11 then
		--script.Parent.ScrollingEnabled = false
		script.Parent.Parent.Parent.Parent.CanvasPosition = Vector2.new(0, 0)
		background.Size = UDim2.new(0, 605, 0, 170 + (30 * numFramesVisible))
	else
		--script.Parent.ScrollingEnabled = true
		background.Size = UDim2.new(0, 605, 0, 470)
	end
	
	script.Parent.Parent.Parent.Parent.Parent.Position = UDim2.new(0.5, -background.Size.X.Offset/2, 0.5, -background.Size.Y.Offset/2)
end

script.Parent.MouseButton1Click:connect(function()
	player.PlayerGui.Sounds.ClickAgain:Play()
	script.Parent.Parent.Size = UDim2.new(0, 580, 0, 25)
	player:WaitForChild("Tags")
	if player.Tags:FindFirstChild(script.Parent.Parent:FindFirstChild("PlayerName").Text):FindFirstChild("Tag").Value ~= script.Parent.Text then
		player.Tags:FindFirstChild(script.Parent.Parent:FindFirstChild("PlayerName").Text).Tag.Value=script.Parent.Text
		player.Tags:FindFirstChild(script.Parent.Parent:FindFirstChild("PlayerName").Text).TagColor.Value=script.Parent.TextColor3
		script.Parent.Parent:WaitForChild("Tag").Text = script.Parent.Text
		script.Parent.Parent:WaitForChild("Tag").TextColor3 = script.Parent.TextColor3
	else
		player.Tags:FindFirstChild(script.Parent.Parent:FindFirstChild("PlayerName").Text).Tag.Value=""
		script.Parent.Parent:WaitForChild("Tag").Text = ""
	end
	for i, v in pairs (script.Parent.Parent:GetChildren()) do
		if v:IsA("TextButton") and v.Name ~= "Tag" then
			v.Visible = false
		end
	end
	for i, v in pairs (script.Parent.Parent.Parent:GetChildren()) do
		if v:IsA("TextButton") then
			local name, num = string.gsub(v.Name, "Button", "")
			if name == script.Parent.Parent.Name then
				v:FindFirstChild("Clicked").Value = false
			end
		end
	end
	
	updateScroll()
end)