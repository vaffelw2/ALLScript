wait(0.5)

local tinsert = table.insert
local Cnew = Color3.new

local localPlayer = game.Players.LocalPlayer

local gui=script.Parent.Parent.GUI.TR.LeaderboardGUI

local rs = game:GetService("RunService")


--Different Sections
local first = gui.ScrollingFrame.ROBLOXians
local second = gui.ScrollingFrame.MissingInAction
local third = gui.ScrollingFrame.ConfirmedDead
local fourth = gui.ScrollingFrame.Spectators

--Different Player Slots In Sections
local ROBLOXians = {first.Player1, first.Player2, first.Player3, first.Player4, first.Player5, first.Player6, first.Player7, first.Player8, first.Player9, first.Player10, first.Player11, first.Player12, first.Player13, first.Player14, first.Player15, first.Player16, first.Player17, first.Player18, first.Player19, first.Player20, first.Player21}
local missingIA = {second.Player1, second.Player2, second.Player3, second.Player4, second.Player5, second.Player6, second.Player7, second.Player8, second.Player9, second.Player10, second.Player11, second.Player12, second.Player13, second.Player14, second.Player15, second.Player16, second.Player17, second.Player18, second.Player19, second.Player20, second.Player21}
local confirmedDead = {third.Player1, third.Player2, third.Player3, third.Player4, third.Player5, third.Player6, third.Player7, third.Player8, third.Player9, third.Player10, third.Player11, third.Player12, third.Player13, third.Player14, third.Player15, third.Player16, third.Player17, third.Player18, third.Player19, third.Player20, third.Player21}
local spectators = {fourth.Player1, fourth.Player2, fourth.Player3, fourth.Player4, fourth.Player5, fourth.Player6, fourth.Player7, fourth.Player8, fourth.Player9, fourth.Player10, fourth.Player11, fourth.Player12, fourth.Player13, fourth.Player14, fourth.Player15, fourth.Player16, fourth.Player17, fourth.Player18, fourth.Player19, fourth.Player20, fourth.Player21}

for i, v in pairs (first:GetChildren()) do
	if v:IsA("Frame") then
		tinsert(ROBLOXians, v)
	end
end

--Frame Positions
local frame = {}
for i = 30, 1800, 30 do
	tinsert(frame, UDim2.new(0, 0, 0, i))
end

--Tags To Identify People By Role
function addSpecialTag(name, frame)
end

--Gives Appropriate Membership Logo To Those Who Have Builder's Club [BC/TBC/OBC]
function addMembershipLogo(name, frame)
end

--Clears Everything
function clearEverything()
	for i = 1, #ROBLOXians do
		ROBLOXians[i].Visible = false
	end
	for i = 1, #missingIA do
		missingIA[i].Visible = false
	end
	second.Visible = false
	for i = 1, #confirmedDead do
		confirmedDead[i].Visible = false
	end
	for i = 1, #spectators do
		spectators[i].Visible = false
	end
end

function updateScroll()
	rs.Heartbeat:wait()
	for j, k in pairs (gui.ScrollingFrame:WaitForChild("ROBLOXians"):GetChildren()) do
		if k:IsA("TextButton") then
			for l, m in pairs (gui.ScrollingFrame:WaitForChild("ROBLOXians"):GetChildren()) do
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
	for i, frame in pairs(gui.ScrollingFrame:GetChildren()) do
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
	
	gui:WaitForChild("ScrollingFrame").CanvasSize = UDim2.new(0, 0, (0.06 * numFramesVisible), 0)
	
	local background = gui:WaitForChild("Background")
	
	if numFramesVisible < 11 then
		gui.ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
		background.Size = UDim2.new(0, 605, 0, 170 + (30 * numFramesVisible))
	else
		background.Size = UDim2.new(0, 605, 0, 470)
	end
	
	gui.Position = UDim2.new(0.5, -background.Size.X.Offset/2, 0.5, -background.Size.Y.Offset/2)
end

local roundOver=game.Workspace.Status.RoundOver

function update()
	rs.Heartbeat:wait()
	clearEverything()
	for i, v in pairs (game.Players:GetPlayers()) do
		if game.Players:WaitForChild(v.Name) and v:FindFirstChild("Status") and v.Status:FindFirstChild("FakeKarma") and v:FindFirstChild("Status") and v:FindFirstChild("Status"):FindFirstChild("Identified") and v:FindFirstChild("Status"):FindFirstChild("Deaths") and v:FindFirstChild("Status"):FindFirstChild("Score") and v:FindFirstChild("Status"):FindFirstChild("Alive") and v:FindFirstChild("Status"):FindFirstChild("Role") then
			if v.Status:FindFirstChild("Team") and v.Status.Team.Value=="Terrorist" then
				local whichOne = ""
				if localPlayer:WaitForChild("Status"):WaitForChild("Role").Value == "Traitor" or not localPlayer.Status:WaitForChild("Alive").Value or roundOver.Value then
					whichOne = "Traitor"
				else
					whichOne = "Innocent"
				end
				
				if whichOne == "Traitor" then
					if v:WaitForChild("Status"):WaitForChild("Alive").Value then
						for i = 1, #ROBLOXians do
							if ROBLOXians[i].Visible == false then
								ROBLOXians[i].Visible = true
								ROBLOXians[i]:WaitForChild("PlayerName").Text = v.Name
								ROBLOXians[i]:WaitForChild("ImageLabel").Image = "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username="..v.Name
								ROBLOXians[i]:WaitForChild("Tag").Text = localPlayer:WaitForChild("Tags"):WaitForChild(v.Name):WaitForChild("Tag").Value
								ROBLOXians[i]:WaitForChild("Tag").TextColor3 = localPlayer:WaitForChild("Tags"):WaitForChild(v.Name):WaitForChild("TagColor").Value
								if game.Players:WaitForChild(v.Name) and game.Players[v.Name]:WaitForChild("Status") then
									ROBLOXians[i]:WaitForChild("Karma").Text = game.Players[v.Name]:WaitForChild("Status"):WaitForChild("FakeKarma").Value
								else
									ROBLOXians[i]:WaitForChild("Karma").Text = "Loading..."
								end
								ROBLOXians[i]:WaitForChild("Score").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Score").Value
								ROBLOXians[i]:WaitForChild("Deaths").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Deaths").Value
								addSpecialTag(v.Name, ROBLOXians[i])
								addMembershipLogo(v.Name, ROBLOXians[i])
								if game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Role").Value == "Traitor" and localPlayer:WaitForChild("Status"):WaitForChild("Role").Value == "Traitor" then
									ROBLOXians[i].BackgroundColor3 = gui:WaitForChild("TraitorColor").Value
								elseif game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Role").Value == "Detective" then
									ROBLOXians[i].BackgroundColor3 = gui:WaitForChild("DetectiveColor").Value
								else
									ROBLOXians[i].BackgroundColor3 = ROBLOXians[i].OriginalColor.Value
								end
								break
							end
						end
					elseif not v:WaitForChild("Status"):WaitForChild("Alive").Value and not v.Status:WaitForChild("Identified").Value then
						second.Visible = true
						for i = 1, #missingIA do
							if missingIA[i].Visible == false then
								missingIA[i].Visible = true
								missingIA[i]:WaitForChild("PlayerName").Text = v.Name
								missingIA[i]:WaitForChild("ImageLabel").Image = "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username="..v.Name
								if game.Players:FindFirstChild(v.Name) and game.Players[v.Name]:FindFirstChild("Status") then
									missingIA[i]:WaitForChild("Karma").Text = game.Players[v.Name]:WaitForChild("Status"):WaitForChild("FakeKarma").Value
								else
									missingIA[i]:WaitForChild("Karma").Text = "Loading..."
								end
								missingIA[i]:WaitForChild("Score").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Score").Value
								missingIA[i]:WaitForChild("Deaths").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Deaths").Value
								addSpecialTag(v.Name, missingIA[i])
								addMembershipLogo(v.Name, missingIA[i])
								if game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Role").Value == "Traitor" and (localPlayer:WaitForChild("Status"):WaitForChild("Role").Value == "Traitor" or roundOver.Value) then
									missingIA[i].BackgroundColor3 = gui:WaitForChild("TraitorColor").Value
								elseif game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Role").Value == "Detective" then
									missingIA[i].BackgroundColor3 = gui:WaitForChild("DetectiveColor").Value
								else
									missingIA[i].BackgroundColor3 = missingIA[i].OriginalColor.Value
								end
								break
							end
						end
					elseif not v:FindFirstChild("Status"):FindFirstChild("Alive").Value and v.Status:FindFirstChild("Identified").Value then
						for i = 1, #confirmedDead do
							if confirmedDead[i].Visible == false then
								confirmedDead[i].Visible = true
								
								if game.Players:FindFirstChild(v.Name) and game.Players[v.Name]:FindFirstChild("Status") then
									confirmedDead[i]:WaitForChild("Karma").Text = game.Players[v.Name]:WaitForChild("Status"):WaitForChild("FakeKarma").Value
								else
									confirmedDead[i]:WaitForChild("Karma").Text = "Loading..."
								end
								
								confirmedDead[i]:WaitForChild("PlayerName").Text = v.Name
								confirmedDead[i]:WaitForChild("ImageLabel").Image = "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username="..v.Name
								addSpecialTag(v.Name, confirmedDead[i])
								addMembershipLogo(v.Name, confirmedDead[i])
								confirmedDead[i]:WaitForChild("Score").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Score").Value
								confirmedDead[i]:WaitForChild("Deaths").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Deaths").Value
								if game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Role").Value == "Traitor" then
									confirmedDead[i].BackgroundColor3 = gui:WaitForChild("TraitorColor").Value
								elseif game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Role").Value == "Detective" then
									confirmedDead[i].BackgroundColor3 = gui:WaitForChild("DetectiveColor").Value
								else
									confirmedDead[i].BackgroundColor3 = confirmedDead[i].OriginalColor.Value
								end
								break
							end
						end
					end
				elseif whichOne == "Innocent" then
					if not v:WaitForChild("Status"):WaitForChild("Identified").Value then
						for i = 1, #ROBLOXians do
							if ROBLOXians[i].Visible == false then
								ROBLOXians[i].Visible = true
								ROBLOXians[i]:WaitForChild("PlayerName").Text = v.Name
								ROBLOXians[i]:WaitForChild("ImageLabel").Image = "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username="..v.Name
								ROBLOXians[i]:WaitForChild("Tag").Text = localPlayer:WaitForChild("Tags"):WaitForChild(v.Name):WaitForChild("Tag").Value
								ROBLOXians[i]:WaitForChild("Tag").TextColor3 = localPlayer:WaitForChild("Tags"):WaitForChild(v.Name):WaitForChild("TagColor").Value
								if game.Players:FindFirstChild(v.Name) and game.Players[v.Name]:FindFirstChild("Status") then
									ROBLOXians[i]:WaitForChild("Karma").Text = game.Players[v.Name]:WaitForChild("Status"):WaitForChild("FakeKarma").Value
								else
									ROBLOXians[i]:WaitForChild("Karma").Text = "Loading..."
								end
								ROBLOXians[i]:WaitForChild("Score").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Score").Value
								ROBLOXians[i]:WaitForChild("Deaths").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Deaths").Value
								addSpecialTag(v.Name, ROBLOXians[i])
								addMembershipLogo(v.Name, ROBLOXians[i])
								if game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Role").Value == "Traitor" and localPlayer:WaitForChild("Status"):WaitForChild("Role").Value == "Traitor" then
									ROBLOXians[i].BackgroundColor3 = gui:WaitForChild("TraitorColor").Value
								elseif game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Role").Value == "Detective" then
									ROBLOXians[i].BackgroundColor3 = gui:WaitForChild("DetectiveColor").Value
								else
									ROBLOXians[i].BackgroundColor3 = ROBLOXians[i].OriginalColor.Value
								end
								break
							end
						end
					else
						for i = 1, #confirmedDead do
							if confirmedDead[i].Visible == false then
								confirmedDead[i].Visible = true
								
								if game.Players:FindFirstChild(v.Name) and game.Players[v.Name]:FindFirstChild("Status") then
									confirmedDead[i]:WaitForChild("Karma").Text = game.Players[v.Name]:WaitForChild("Status"):WaitForChild("FakeKarma").Value
								else
									confirmedDead[i]:WaitForChild("Karma").Text = "Loading..."
								end
								
								confirmedDead[i]:WaitForChild("PlayerName").Text = v.Name
								confirmedDead[i]:WaitForChild("ImageLabel").Image = "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username="..v.Name
								addSpecialTag(v.Name, confirmedDead[i])
								addMembershipLogo(v.Name, confirmedDead[i])
								confirmedDead[i]:WaitForChild("Score").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Score").Value
								confirmedDead[i]:WaitForChild("Deaths").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Deaths").Value
								if game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Role").Value == "Traitor" then
									confirmedDead[i].BackgroundColor3 = gui:WaitForChild("TraitorColor").Value
								elseif game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Role").Value == "Detective" then
									confirmedDead[i].BackgroundColor3 = gui:WaitForChild("DetectiveColor").Value
								else
									confirmedDead[i].BackgroundColor3 = confirmedDead[i].OriginalColor.Value
								end
								break
							end
						end
					end
				end
			else				
				for i = 1, #spectators do
					if spectators[i].Visible == false then
						spectators[i].Visible = true
						spectators[i]:WaitForChild("PlayerName").Text = v.Name
						spectators[i]:FindFirstChild("ImageLabel").Image = "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username="..v.Name
						addSpecialTag(v.Name, spectators[i])
						addMembershipLogo(v.Name, spectators[i])
						if game.Players:FindFirstChild(v.Name) and game.Players[v.Name]:FindFirstChild("Status") and game.Players[v.Name]:FindFirstChild("Status"):FindFirstChild("Karma") then
							spectators[i]:WaitForChild("Karma").Text = game.Players[v.Name]:WaitForChild("Status"):WaitForChild("FakeKarma").Value
						else
							spectators[i]:WaitForChild("Karma").Text = "Loading..."
						end
						spectators[i]:WaitForChild("Score").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Score").Value
						spectators[i]:WaitForChild("Deaths").Text = game.Players:WaitForChild(v.Name):WaitForChild("Status"):WaitForChild("Deaths").Value
						break
					end
				end
			end
		end
	end
	
	updateScroll()
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
	
	updateScroll()
end

local leaderboardGUI=gui
game.Workspace.Status.PlayerChanged.Changed:connect(function()
	if leaderboardGUI.Visible==true then
		update()
	end
end)

leaderboardGUI.Changed:connect(function()
	if leaderboardGUI.Visible==true then
		update()
	end
end)

gui.Parent.Winner.CloseGui.MouseButton1Down:connect(function()
	gui.Parent.Winner.Visible=false
end)

gui.Parent.Winner.CloseGui2.MouseButton1Down:connect(function()
	gui.Parent.Winner.Visible=false
end)