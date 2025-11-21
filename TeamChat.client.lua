wait(2)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local sp = script.Parent
local globalChat = script.Parent.Parent.GlobalChat
local teamLabel = script.Parent.Parent.Team
local sf = script.Parent.Parent.Chats
local freeMouse = script.Parent.Parent:WaitForChild("free")
local times = script.Parent.Parent:WaitForChild("TimesChatted")
local rs = game:GetService("RunService")
local faded = {}




game:GetService("UserInputService").InputBegan:connect(function(inst)
	if script.Parent.ActiveOne.Value==true then
		return
	end
	if script.Parent.Parent.GlobalChat.ActiveOne.Value==true then
		return
	end
	if (inst.KeyCode==Enum.KeyCode.U and not script.Parent.Parent.Parent.Parent.Ban.MainHandler.Visible or inst.KeyCode==Enum.KeyCode.Semicolon and not script.Parent.Parent.Parent.Parent.Ban.MainHandler.Visible) and sp.Visible and not game.Players.LocalPlayer.PlayerGui.GUI.TwitterFrame.Code:IsFocused() then
		sp:CaptureFocus()
	end
	if (inst.KeyCode==Enum.KeyCode.U and not script.Parent.Parent.Parent.Parent.Ban.MainHandler.Visible or  inst.KeyCode==Enum.KeyCode.Semicolon and not script.Parent.Parent.Parent.Parent.Ban.MainHandler.Visible) and not game.Players.LocalPlayer.PlayerGui.GUI.TwitterFrame.Code:IsFocused() and (game.ReplicatedStorage.gametype.Value=="competitive" or player.Status.Alive.Value == true)  and player:WaitForChild("Status"):WaitForChild("CanTalk").Value then
		if (player.Status.Role.Value == "Traitor" or player.Status.Role.Value == "Detective" or game.ReplicatedStorage.gametype.Value~="TTT" and player.Status.Team.Value~="Spectator")  then
			freeMouse.Modal = true
			sp.Visible = true
			teamLabel.Visible = true
			sp.ActiveOne.Value = true
			globalChat.ActiveOne.Value = false
			sf.BackgroundTransparency = 0.7
			sf.ScrollingEnabled = true
			sf.ScrollBarThickness = 5
			sp:CaptureFocus()
			rs.RenderStepped:wait()
			script.Parent.Text = ""
			for i, v in pairs (sf:GetChildren()) do
				if v.Name:sub(1,4) == "Line" then
					if v.TextTransparency == 1 then
						table.insert(faded, v)
					end
					v.TextTransparency = 0
					v.TextStrokeTransparency = v.TextTransparency
				end
			end
		else
			return
		end
	end

end)

sp.FocusLost:connect(function(enter)
	if enter then
		if sp.ActiveOne.Value == true then
			sp.ActiveOne.Value = false
			globalChat.ActiveOne.Value = false
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
			teamLabel.Visible = false
			sf.BackgroundTransparency = 1
			sf.ScrollingEnabled = false
			sf.ScrollBarThickness = 0
			sp.Text = ""
			sp.Size = UDim2.new(0, 460, 0, 25)
			for i, v in ipairs (faded) do
				if v then
					v.TextTransparency = 1
					v.TextStrokeTransparency = 1
				end
			end
			if message ~= "" then
				if player:WaitForChild("Status"):WaitForChild("CanTalk").Value then
					times.Value = times.Value + 1
					game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PlayerChatted"):FireServer(message, true, role, not player:WaitForChild("Status"):WaitForChild("Alive").Value, true)
				end
			end
		end
	else
		if sp.ActiveOne.Value == true then
			sp.ActiveOne.Value = false
			globalChat.ActiveOne.Value = false
			freeMouse.Modal = false
			sp.Visible = false
			teamLabel.Visible = false
			sf.BackgroundTransparency = 1
			sf.ScrollingEnabled = false
			sf.ScrollBarThickness = 0
			sp.Text = ""
			sp.Size = UDim2.new(0, 460, 0, 25)
			for i, v in ipairs (faded) do
				if v then
					v.TextTransparency = 1
					v.TextStrokeTransparency = 1
				end
			end
		end
	end
end)