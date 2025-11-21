wait(2)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local sp = script.Parent
local teamChat = script.Parent.Parent.TeamChat
local sf = script.Parent.Parent.Chats
local freeMouse = script.Parent.Parent:WaitForChild("free")
local Rs	= game:GetService("RunService")
local times = script.Parent.Parent:WaitForChild("TimesChatted")
local faded = {}
local uis = game:GetService("UserInputService")
--local changeValue = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ChangeValue")

function takeUserInput()
	freeMouse.Modal = true
	script.Parent.TextTransparency = 0
	script.Parent.Text = ""
	sp.Visible = true
	sp.ActiveOne.Value = true
	teamChat.ActiveOne.Value = false
	sf.BackgroundTransparency = 0.7
	sf.ScrollingEnabled = true
	sf.ScrollBarThickness = 5
	sp:CaptureFocus()
	Rs.RenderStepped:wait()
	script.Parent.Text = ""
	for i, v in pairs (sf:GetChildren()) do
		if v.Name:sub(1, 4) == "Line" then
			if v.TextTransparency == 1 then
				table.insert(faded, v)
			end
			v.TextTransparency = 0
			v.TextStrokeTransparency = v.TextTransparency
		end
	end
end


uis.InputBegan:connect(function(inst)
	if script.Parent.ActiveOne.Value==true then
		return
	end
	if script.Parent.Parent.TeamChat.ActiveOne.Value==true then
		return
	end
	if (inst.KeyCode==Enum.KeyCode.Y or inst.KeyCode==Enum.KeyCode.Slash) and sp.Visible and not game.Players.LocalPlayer.PlayerGui.GUI.TwitterFrame.Code:IsFocused() and not script.Parent.Parent.Parent.Parent.Ban.MainHandler.Visible then
		sp:CaptureFocus()
	end
	if (inst.KeyCode==Enum.KeyCode.Y or inst.KeyCode==Enum.KeyCode.Slash) and sp.Visible == false and not game.Players.LocalPlayer.PlayerGui.GUI.TwitterFrame.Code:IsFocused() and sp.Parent.TeamChat.Visible == false and player:WaitForChild("Status"):WaitForChild("CanTalk").Value and not script.Parent.Parent.Parent.Parent.Ban.MainHandler.Visible then
		takeUserInput()
	end
end)

sp.FocusLost:connect(function(enter)
	if enter then
		if sp.ActiveOne.Value == true then
			sp.ActiveOne.Value = false
			teamChat.ActiveOne.Value = false
			local message = ""
			local role = ""
			if sp.Text ~= ""  then
				message = sp.Text
				if player.Status.Team.Value~="Spectator" then
					role = player:WaitForChild("Status"):WaitForChild("Role").Value
				else
					role = "Spectator"
				end
			end
			freeMouse.Modal = false
			sp.Visible = false
			sf.BackgroundTransparency = 1
			sf.ScrollingEnabled = false
			sf.ScrollBarThickness = 0
			sp.Text = ""
			sp.Size = UDim2.new(0, 500, 0, 25)
			for i, v in ipairs (faded) do
				if v then
					v.TextTransparency = 1
					v.TextStrokeTransparency = 1
				end
			end
			if message ~= "" then
				if player:WaitForChild("Status"):WaitForChild("CanTalk").Value then
					times.Value = times.Value + 1
					game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PlayerChatted"):FireServer(message, false, role, not player:WaitForChild("Status"):WaitForChild("Alive").Value, true)
				end
			end
		end
	else
		if sp.ActiveOne.Value == true then
			sp.ActiveOne.Value = false
			teamChat.ActiveOne.Value = false
			freeMouse.Modal = false
			sp.Visible = false
			sf.BackgroundTransparency = 1
			sf.ScrollingEnabled = false
			sf.ScrollBarThickness = 0
			sp.Text = ""
			sp.Size = UDim2.new(0, 500, 0, 25)
			for i, v in ipairs (faded) do
				if v then
					v.TextTransparency = 1
					v.TextStrokeTransparency = 1
				end
			end
		end
	end
end)
