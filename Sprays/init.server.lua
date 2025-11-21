--	services

local ReplicatedStorage	= game:GetService("ReplicatedStorage")
local DataStoreService	= game:GetService("DataStoreService")
local Workspace			= game:GetService("Workspace")
local Players			= game:GetService("Players")

--	constants

local Sprays	= DataStoreService:GetDataStore("Sprays")

--	functions

ReplicatedStorage.Spray.OnServerEvent:Connect(function(player, type, ...)
	if type == "Spray" then
		local pos	= ...
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and (pos.p-player.Character.HumanoidRootPart.CFrame.p).magnitude <= 5 then
			local spray	= "rbxassetid://2194268977" --Sprays:GetAsync(player.userId).Equipped
			
			local part			= script.Spray:Clone()
			part.Icon.Texture	= spray
			part.CFrame			= CFrame.new(pos*CFrame.new(0, 0, 0.5).p, player.Character.HumanoidRootPart.CFrame.p)
			part.Parent			= Workspace.Map	
		end
	elseif type == "equip" then
	end
end)