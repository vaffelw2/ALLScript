wait()

local player = game.Players.LocalPlayer
local sp = script.Parent
local numMessages = 0
local rs = game:GetService("RunService")
local isStudio = rs:IsStudio()


--Samples
local sampleName = script.Parent:WaitForChild("SampleName")
local sampleNotification = script.Parent:WaitForChild("SampleNotification")

--sp.CanvasPosition = Vector2.new(0, 540)

function moveOldMessages()
	for _, old in pairs(script.Parent:GetChildren()) do
		if old:IsA("TextLabel") and old.Name:sub(1, 4) == "Line" then
			old.Position = old.Position + UDim2.new(0, 0, 0, -19)
			local oldName = old.Name
			old.Name = "Line"..(1 + tonumber(string.sub(oldName, 5)))

			if old.Name == "Line37" then
				old:Destroy()
			end

		end
	end
end

function adjustPositions()
	for _, old in pairs(script.Parent:GetChildren()) do
		if old:IsA("TextLabel") and old.Name:sub(1, 4) == "Line" then
			if not old.Active then
				old.Position = UDim2.new(old.Position.X.Scale, old.Position.X.Offset, old.Position.Y.Scale, (script.Parent.CanvasSize.Y.Offset - 31) - ((tonumber(string.sub(old.Name, 5) - 1) * 19)))
			else
				old.Position = UDim2.new(old.Position.X.Scale, old.Position.X.Offset, old.Position.Y.Scale, (script.Parent.CanvasSize.Y.Offset - 31) - (((tonumber(string.sub(old.Name, 5) - 1) * 19) - 8)))
			end
		end
	end
end

function fade(textLabel)
	wait(15)
	for i = 0, 1, 0.1 do
		if script.Parent.Parent:WaitForChild("GlobalChat").Visible or script.Parent.Parent:WaitForChild("TeamChat").Visible == true then
			textLabel.TextTransparency = 0
			textLabel.TextStrokeTransparency = textLabel.TextTransparency
			repeat wait() until script.Parent.BackgroundTransparency == 1
		end
		textLabel.TextTransparency = i
		textLabel.TextStrokeTransparency = textLabel.TextTransparency
		wait(0.1)
	end
end

function round(num)
	return math.floor(num + 0.5)
end

function createNewMessage(playerName, theMessage, color1, color2, xValue, teamLabel)
	--theMessage = functions.Filter:InvokeServer(theMessage)
	local name = Instance.new("TextLabel", script.Parent)
	name.Name = "Line1"
	name.BackgroundTransparency = 1
	name.BorderSizePixel = 0
	name.ClipsDescendants = false
	name.TextScaled = false
	name.TextColor3 = color1
	name.TextStrokeColor3 = Color3.new(0, 0, 0)
	name.TextStrokeTransparency = name.TextTransparency
	name.TextWrapped = false
	name.Font = "ArialBold"
	name.FontSize = "Size14"
	name.TextXAlignment = "Left"
	name.Size = UDim2.new(590, 0, 30, 0)
	name.Text = playerName
	sampleName.Text = playerName
	local nameLength = sampleName.TextBounds.X + 1
	name.Size = UDim2.new(0, nameLength, 0, 30)
	name.Position = UDim2.new(xValue, 0, 0, 147)
	
	local playerMessage = Instance.new("TextLabel", script.Parent)
	playerMessage.Name = "Line1"
	playerMessage.BackgroundTransparency = 1
	playerMessage.BorderSizePixel = 0
	playerMessage.Active = false
	playerMessage.ClipsDescendants = false
	playerMessage.TextScaled = false
	playerMessage.TextWrapped = false
	local before = name.TextBounds.X
	if teamLabel then
		before = before + teamLabel.TextBounds.X
	end
	playerMessage.Size = UDim2.new(0, 493 - before, 0, 30)
	playerMessage.Position = name.Position + UDim2.new(0, nameLength, 0, 0)
	playerMessage.TextColor3 = color2
	playerMessage.TextStrokeColor3 = Color3.new(0, 0, 0)
	playerMessage.TextStrokeTransparency = playerMessage.TextTransparency
	playerMessage.Font = "ArialBold"
	playerMessage.FontSize = "Size14"
	playerMessage.TextXAlignment = "Left"
	--theMessage = string.sub(theMessage, 1, 100)
	playerMessage.Text = ": "..theMessage
	if playerMessage.TextBounds.X <= (487 - before) and playerMessage.TextBounds.Y <= 15 then
		numMessages = numMessages + 1
	else
		moveOldMessages()
		if not string.find(theMessage, " ") then
			local b4 = string.sub(theMessage, 1, math.ceil(string.len(theMessage)/3))
			local after = string.sub(theMessage, math.ceil(string.len(theMessage)/3) + 1)
			playerMessage.Text = ": "..b4.."  "..after
		end
		playerMessage.Size = UDim2.new(0, 493 - before, 0, 30)
		playerMessage.Position = playerMessage.Position + UDim2.new(0, 0, 0, 8)
		playerMessage.TextYAlignment = "Top"
		playerMessage.Active = true
		numMessages = numMessages + 2
	end
	playerMessage.TextWrapped = true
	if numMessages < 36 then
		script.Parent.CanvasSize = UDim2.new(0, 0, 0, round(numMessages * 19.77))
	else
		script.Parent.CanvasSize = UDim2.new(0, 0, 0, 693)
	end

	if numMessages > 9 then
		adjustPositions()
		script.Parent.CanvasPosition = Vector2.new(0, script.Parent.CanvasSize.Y.Offset - 178)
	end
end
 local preparation=game.Workspace.Status.Preparation
local roundOver=game.Workspace.Status.RoundOver
game.ReplicatedStorage.Events.PlayerChatted.OnClientEvent:connect(function(name, message, team, role, dead, filter, qc)
	if filter and not isStudio then
		message = game.ReplicatedStorage.Functions.Filter:InvokeServer(message, game.Players:FindFirstChild(name))
	end
	local plr=game.Players[name]
	local color=nil
	if plr and plr.Status.Team.Value=="T" then
		color=BrickColor.new("Bright yellow")
	elseif plr and plr.Status.Team.Value=="CT" then
		color=BrickColor.new("Bright blue")
	elseif game.ReplicatedStorage.gametype.Value=="TTT" then
		color=BrickColor.new("Bright green")
		if plr and plr.Status.Role.Value=="Traitor" and player.Status.Role.Value=="Traitor" then
			color=BrickColor.new("Bright red")
		end
		if plr and plr.Status.Role.Value=="Detective" then
			color=BrickColor.new("Bright blue")
		end
	else
		color=BrickColor.new("White")
	end
	color=color.Color
	if not team then
		if role == "Innocent" or role == "Traitor" or game.ReplicatedStorage.gametype.Value~="TTT" and player.Status.Team.Value~="Spectator" then
		

		local plyrAlive = plr:WaitForChild("Status"):WaitForChild("Alive").Value
		if plyrAlive and qc and game.ReplicatedStorage.gametype.Value~="TTT" then
			local additionaltext=""
			if plr and plr:FindFirstChild("Location") and plr.Location.Value~="" then
				additionaltext=" @ "..plr.Location.Value
			end
			if game.ReplicatedStorage.gametype.Value~="TTT" and (plr:WaitForChild("Status").Team.Value == game.Players.LocalPlayer.Status.Team.Value or game.Players.LocalPlayer.Status.Team.Value=="Spectator") then
				moveOldMessages()
				local deadLabel = Instance.new("TextLabel", script.Parent)
				deadLabel.Name = "Line1"
				deadLabel.BackgroundTransparency = 1
				deadLabel.BorderSizePixel = 0
				deadLabel.Size = UDim2.new(0, 590, 0, 30)
				deadLabel.Position = UDim2.new(0.01, 0, 0, 147)
				deadLabel.TextColor3 = Color3.new(80/255, 120/255, 120/255)
				deadLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
				deadLabel.TextStrokeTransparency = deadLabel.TextTransparency
				deadLabel.TextWrapped = false
				deadLabel.Font = "ArialBold"
				deadLabel.FontSize = "Size14"
				deadLabel.TextXAlignment = "Left"
				deadLabel.Text = "*RADIO*"
				deadLabel.Size=UDim2.new(0,deadLabel.TextBounds.X + 2,0,30)
				createNewMessage(name, message, color, Color3.new(255, 255, 255), 0.12, deadLabel)
			end
			return
		end
			if not dead then
				moveOldMessages()
				if script.Parent.Parent.Visible then
					createNewMessage(name, message, color, Color3.new(255, 255, 255), 0.01, nil)
				end
			else
				local Player=game.Players.LocalPlayer
				if plr.Name==Player.Name or plr.Name=="DevRolve" or Player.Name=="DevRolve" or (not Player.Status.Alive.Value and not plyrAlive and game.ReplicatedStorage.gametype.Value=="casual") or preparation.Value or roundOver.Value or game.ReplicatedStorage.gametype.Value=="competitive" and plr and plr:FindFirstChild("Status") and plr.Status.Team.Value~="Spectator" then
					moveOldMessages()
					local deadLabel = Instance.new("TextLabel", script.Parent)
					deadLabel.Name = "Line1"
					deadLabel.BackgroundTransparency = 1
					deadLabel.BorderSizePixel = 0
					deadLabel.Size = UDim2.new(0, 590, 0, 30)
					deadLabel.Position = UDim2.new(0.01, 0, 0, 147)
					deadLabel.TextColor3 = script.Parent.DeadColor.Value
					deadLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
					deadLabel.TextStrokeTransparency = deadLabel.TextTransparency
					deadLabel.TextWrapped = false
					deadLabel.Font = "ArialBold"
					deadLabel.FontSize = "Size14"
					deadLabel.TextXAlignment = "Left"
					deadLabel.Text = "*DEAD*"
					deadLabel.Size=UDim2.new(0,deadLabel.TextBounds.X + 1,0,30)
					createNewMessage(name, message, color, Color3.new(255, 255, 255), 0.11, deadLabel)
				end
			end
		elseif role == "Detective" then
			if not dead then
				moveOldMessages()
				createNewMessage(name, message, script.Parent.DetectiveTeamChatColor.Value, Color3.new(255, 255, 255), 0.01, nil)
			else
				if not player.Character or preparation.Value or roundOver.Value then
					moveOldMessages()
					local deadLabel = Instance.new("TextLabel", script.Parent)
					deadLabel.Name = "Line1"
					deadLabel.BackgroundTransparency = 1
					deadLabel.BorderSizePixel = 0
					deadLabel.Size = UDim2.new(0, 590, 0, 30)
					deadLabel.Position = UDim2.new(0.01, 0, 0, 147)
					deadLabel.TextColor3 = script.Parent.DeadColor.Value
					deadLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
					deadLabel.TextStrokeTransparency = deadLabel.TextTransparency
					deadLabel.TextWrapped = false
					deadLabel.Font = "ArialBold"
					deadLabel.FontSize = "Size14"
					deadLabel.TextXAlignment = "Left"
					deadLabel.Text = "*DEAD*"
					deadLabel.Size=UDim2.new(0,deadLabel.TextBounds.X + 1,0,30)
					createNewMessage(name, message, color, Color3.new(255, 255, 255), 0.11, deadLabel)
				end
			end
		elseif role == "Spectator" then
			local Player=game.Players.LocalPlayer
			if plr.Name==Player.Name or plr.Name=="DevRolve" or Player.Name=="DevRolve" or (not Player.Status.Alive.Value and plr.Status.Alive.Value==false and game.ReplicatedStorage.gametype.Value=="casual") or preparation.Value or roundOver.Value or game.ReplicatedStorage.gametype.Value=="competitive" and plr and plr:FindFirstChild("Status") and plr.Status.Team.Value~="Spectator" then
				moveOldMessages()
				local spectatorLabel = Instance.new("TextLabel", script.Parent)
				spectatorLabel.Name = "Line1"
				spectatorLabel.BackgroundTransparency = 1
				spectatorLabel.BorderSizePixel = 0
				spectatorLabel.Size = UDim2.new(0, 590, 0, 30)
				spectatorLabel.Position = UDim2.new(0.01, 0, 0, 147)
				spectatorLabel.TextColor3 = script.Parent.SpectatorColor.Value
				spectatorLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
				spectatorLabel.TextStrokeTransparency = spectatorLabel.TextTransparency
				spectatorLabel.TextWrapped = false
				spectatorLabel.Font = "ArialBold"
				spectatorLabel.FontSize = "Size14"
				spectatorLabel.TextXAlignment = "Left"
				spectatorLabel.Text = "(SPECTATOR)"
				spectatorLabel.Size=UDim2.new(0,spectatorLabel.TextBounds.X + 1,0,30)
				createNewMessage(name, message, color, Color3.new(255, 255, 255), 0.2, spectatorLabel)
			end
		end
	else
		local currentRole = player:WaitForChild("Status"):WaitForChild("Role").Value
		if (game.ReplicatedStorage.gametype.Value=="competitive" or player.Character) and (game.ReplicatedStorage.gametype.Value=="TTT" and currentRole == role and role ~= "Innocent" or game.ReplicatedStorage.gametype.Value~="TTT" and plr.Status.Team.Value==player.Status.Team.Value)  then
			moveOldMessages()
			local teamLabel = Instance.new("TextLabel", script.Parent)
			teamLabel.Name = "Line1"
			teamLabel.BackgroundTransparency = 1
			teamLabel.BorderSizePixel = 0
			teamLabel.Size = UDim2.new(0, 590, 0, 30)
			teamLabel.Position = UDim2.new(0.01, 0, 0, 147)
			teamLabel.TextColor3 = script.Parent.TeamValueColor.Value
			teamLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
			teamLabel.TextStrokeTransparency = teamLabel.TextTransparency
			teamLabel.TextWrapped = false
			teamLabel.Font = "ArialBold"
			teamLabel.FontSize = "Size14"
			teamLabel.TextXAlignment = "Left"
			teamLabel.Text = "(TEAM)"
			teamLabel.Size=UDim2.new(0,teamLabel.TextBounds.X + 1,0,30)
			createNewMessage(name, message, color, Color3.new(255, 255, 255), 0.11, teamLabel)
		end
	end
end)





function Chat2(val,color)
	if val ~= "" then
		moveOldMessages()
		local notification = Instance.new("TextLabel", script.Parent)
		notification.Name = "Line1"
		notification.BackgroundTransparency = 1
		notification.BorderSizePixel = 0
		notification.Size = UDim2.new(0, 590, 0, 30)
		notification.Position = UDim2.new(0.01, 0, 0, 147)
		notification.TextColor3 = color
		notification.TextStrokeColor3 = Color3.new(0, 0, 0)
		notification.TextStrokeTransparency = notification.TextTransparency
		notification.TextWrapped = false
		notification.Font = "ArialBold"
		notification.FontSize = "Size14"
		notification.TextXAlignment = "Left"
		notification.Text = val
		numMessages = numMessages + 1
		if numMessages < 36 then
			script.Parent.CanvasSize = UDim2.new(0, 0, 0, round(numMessages * 19.77))
		else
			script.Parent.CanvasSize = UDim2.new(0, 0, 0, 693)
		end
		if numMessages > 9 then
			adjustPositions()
			script.Parent.CanvasPosition = Vector2.new(0, script.Parent.CanvasSize.Y.Offset - 178)
		end
	end
end
game.Workspace:WaitForChild("Status"):WaitForChild("PlayerEntered").Changed:connect(function(val)
	if val ~= "" then
		if game.Players:FindFirstChild(val.Name):IsInGroup(14673267) then
			return
		end
		Chat2(val.." has joined the server.", Color3.new(129/255, 193/255, 193/255))
		--generatePlayers()
	end
end)

game.Workspace:WaitForChild("Status"):WaitForChild("PlayerLeft").Changed:connect(function(val)
	if val ~= "" then
		if game.Workspace.ServerShutdown.Value==false then
			Chat2(val.." has left the server.", Color3.new(129/255, 193/255, 193/255))
		end
		--generatePlayers()
	end
end)

game.Workspace:WaitForChild("RacBanFeed").Changed:Connect(function(val)
	print("Changed")
	if val ~= "None" then
		Chat2(val.." Has been RAC banned",Color3.new(0.862745, 0, 0))
	end
end)

game.ReplicatedStorage.Events.SendMsg.OnClientEvent:connect(function(val,color)
	if color==nil then
		color=Color3.new(1,1,1)
	end
	Chat2(val,color)
end)

script.Parent.DescendantAdded:connect(function(child)
	if child:IsA("TextLabel") then
		if not child.Active then
			rs.Heartbeat:wait()
			fade(child)
		end
	end
end)
