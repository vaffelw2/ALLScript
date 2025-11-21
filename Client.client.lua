--	services
--[[
local ReplicatedStorage	= game:GetService("ReplicatedStorage")
local UserInputService	= game:GetService("UserInputService")
local Players			= game:GetService("Players")

--	constants

local LocalPlayer	= Players.LocalPlayer
local GroupId		= 1
local Ban			= ReplicatedStorage:FindFirstChild("Ban")
local Gui			= script.Parent

--	functions

if LocalPlayer:IsInGroup(GroupId) and LocalPlayer:GetRankInGroup(GroupId) >= 254 then
	local function createPlayerlist()
		for _,v in pairs(Gui.Playerlist:GetChildren()) do
			if v.Name == "User" then
				v:Destroy()
			end
		end
		
		for _,v in pairs(Players:GetChildren()) do
			if v ~= LocalPlayer then
				local user	= script.User:Clone()
				user.Text	= v.Name
				user.Parent	= Gui.Playerlist
				
				user.MouseButton1Down:connect(function()
					Gui.Username.Text = v.Name
				end)
			end
		end
		
		spawn(function()
			wait(0.1)
			
			Gui.Playerlist.CanvasSize	= UDim2.new(0, 0, 0, Gui.Playerlist.UIListLayout.AbsoluteContentSize.Y)
		end)
	end
	
	Gui.Ban.MouseButton1Down:connect(function()
		if tonumber(Gui.Time.Text) >= 1 then
			Ban:FireServer(Gui.Username.Text, Gui.Reason.Text, Gui.Time.Text)
		end
	end)
	
	UserInputService.InputBegan:connect(function(key)
		if key.KeyCode == Enum.KeyCode.Minus then
			Gui.Visible = not Gui.Visible
			
			if Gui.Visible then
				createPlayerlist()
			end
		end
	end)
end]]