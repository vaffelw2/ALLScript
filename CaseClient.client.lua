--	services

local Workspace			= game:GetService("Workspace")
local ReplicatedStorage	= game:GetService("ReplicatedStorage")
local TweenService		= game:GetService("TweenService")

--	constants

local CrateAnim	= ReplicatedStorage:FindFirstChild("CrateAnimation")
local GetName 	= require(ReplicatedStorage.GetTrueName)
local Camera	= Workspace.CurrentCamera
local Crate		= script.Crate
local camPos	= CFrame.new(Crate.Camera.CFrame.p, Crate.HumanoidRootPart.CFrame.p)
local Skipped	= false

--	functions

local function mapSkin(gun, skin)
	local gn = gun.Name
	local skindataf = skin
	
	if skindataf ~= nil then
		local skin = skindataf
		
		if skin ~= "Stock" then
			local whichskin	= gun.Name
			if string.find(string.lower(gun.Name), "falchion") then
				whichskin	= "Falchion Knife"
			end
			if string.find(string.lower(gun.Name), "bayonet") then
				whichskin	= "Bayonet"
			end
			if string.find(string.lower(gun.Name), "huntsman") then
				whichskin	= "Huntsman Knife"
			end
			if string.find(string.lower(gun.Name), "butterfly") then
				whichskin	= "Butterfly Knife"
			end
			if string.find(string.lower(gun.Name), "gut") then
				whichskin	= "Gut Knife"
			end
			if string.find(string.lower(gun.Name), "karambit") then
				whichskin	= "Karambit"
			end
			
			if string.find(whichskin, "Glove") or string.find(whichskin, "Handwraps") then
				local newskin
				
				for _,v in pairs(ReplicatedStorage.Gloves:GetChildren()) do
					if string.find(v.Name, skin) then
						newskin	= v
						break
					end
				end
				
				gun.Mesh.TextureId	= newskin.Textures.TextureId
			else
				local skindata = ReplicatedStorage.Skins:FindFirstChild(whichskin):FindFirstChild(skin)	
				local skindatach = skindata:GetDescendants()
				
				for i = 1, #skindatach do
					pcall(function()
						if gun:FindFirstChild(skindatach[i].Name) then			
							if not gun[skindatach[i].Name]:FindFirstChild("Mesh") then
								pcall(function()	
									gun[skindatach[i].Name].TextureID = skindatach[i].Value 
								end)
							elseif gun[skindatach[i].Name]:FindFirstChild("Mesh") then
								pcall(function()	
									gun[skindatach[i].Name].Mesh.TextureId = skindatach[i].Value 
								end)
							end
						elseif gun:FindFirstChild(skindatach[i].Name.."2") and not gun:FindFirstChild(skindatach[i].Name) and (string.find(whichskin, "Knife") or string.find(whichskin, "Karambit") or string.find(whichskin, "Bayonet")) then
							if not gun[skindatach[i].Name.."2"]:FindFirstChild("Mesh") then
								pcall(function()	
									gun[skindatach[i].Name.."2"].TextureID = skindatach[i].Value 
								end)
							elseif gun[skindatach[i].Name.."2"]:FindFirstChild("Mesh") then
								pcall(function()	
									gun[skindatach[i].Name.."2"].Mesh.TextureId = skindatach[i].Value 
								end)
							end	
						end
					end)
				end
			end
		end
	end
end

imgs = script.Parent.Parent:WaitForChild("Client").Images

local function doAnimation(gun, skin)
	Skipped	= false
	local back	= script.Back:Clone()
	back.Parent	= script.Parent
	
	if gun == "Scar" then
		gun 	= "G3SG1"
	end
	
	local name	= gun
	
	Camera.CameraType	= Enum.CameraType.Scriptable
	local crate		= script.Crate:Clone()
	crate.Parent	= Workspace.Camera
	
	Camera.CFrame	= CFrame.new(Crate.Camera.CFrame.p, Crate.HumanoidRootPart.CFrame.p)
	
	gun					= ReplicatedStorage.Weapons[gun].Model:Clone()
	gun.Name			= name
	gun.Parent			= crate
	
	for _,v in pairs(gun:GetChildren()) do
		if v:IsA("BasePart") then
			v.Transparency	= 1
		end
	end
	
	local angle	= 90
	
	local weld	= Instance.new("Weld")
	weld.Part0	= gun
	weld.Part1	= crate.Weapon
	weld.C0		= weld.C0*CFrame.Angles(0, math.rad(angle), 0)
	weld.Parent	= gun
	
	mapSkin(gun, skin)
	
	local animTrack	= crate.Humanoid:LoadAnimation(crate.Crate)
	
	back.MouseButton1Down:connect(function()
		script.Parent.Parent.Menew.Enabled	= true
		script.Parent.FreeMouse.Modal		= false
		script.Parent.FreeMouse.Active		= false
		script.Parent.FreeMouse.Selectable	= false
		script.Parent.FreeMouse.Visible		= false
		local gui
		for _,v in pairs(Camera:GetChildren()) do
			if v.Name == "GUI" and v:IsA("ScreenGui") then
				gui	= v
				
				break
			end
		end
		gui.Parent	= game.Players.LocalPlayer.PlayerGui
		Skipped	= true
		animTrack:Stop()
		crate:Destroy()
		back:Destroy()
	end)
	
	animTrack.KeyframeReached:connect(function(frame)
		script[frame]:Play()
		
		if frame == "transparency" then			
			for _,v in pairs(gun:GetChildren()) do
				if v:IsA("BasePart") then
					v.Transparency	= 0
				end
			end
			
			if gun:FindFirstChild("Flash") then
				gun.Flash.Transparency	= 1
			end
			
			if gun:FindFirstChild("Mag") then
				gun.Mag.Transparency	= 1
			end
			
			if gun:FindFirstChild("FlashS") then
				gun.FlashS.Transparency	= 1
			end
			
			coroutine.wrap(function()
				wait(1)
				
				animTrack:AdjustSpeed(0)
				
				local CameraVal	= Instance.new("CFrameValue")
				CameraVal.Value	= CFrame.new(Crate.Camera.CFrame.p, Crate.HumanoidRootPart.CFrame.p)
				CameraVal:GetPropertyChangedSignal("Value"):connect(function()
					Camera.CFrame	= CameraVal.Value
					camPos			= CameraVal.Value
				end)
				
				TweenService:Create(CameraVal, TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {Value	= CFrame.new(gun.Position-Vector3.new(3.5, 0, 0), gun.Position)}):Play()
				local emit	= script.Rarity:Clone()
				emit.Parent	= gun
				
				local color 
				if imgs:FindFirstChild(gun.Name):FindFirstChild(skin) then
					if imgs:FindFirstChild(gun.Name):FindFirstChild(skin):FindFirstChild("Quality") then
						color = script.Colors[imgs:FindFirstChild(gun.Name):FindFirstChild(skin).Quality.Value].Value
					else
						color	= script.Colors.Knife.Value
					end					
				else
					color	= script.Colors.Knife.Value
				end
				print(color)
				gun.Rarity.Color	= ColorSequence.new(color)
				gun.Rarity.Enabled	= true
				
				if crate and crate:FindFirstChild("Weapon") then
					crate.Weapon.Item.Skin.Text				= GetName.getName(gun.Name).." | "..skin
					crate.Weapon.Item.Skin.TextStrokeColor3	= color
					crate.Weapon.Item.Enabled				= true
				end
				
				wait(0.35)
				
				CameraVal:Destroy()
				
				local static	= weld.C0
				angle			= 0
				
				while gun and gun.Parent and crate and crate.Parent and not Skipped do
					angle	= angle-1
					weld.C0	= static*CFrame.Angles(0, math.rad(angle), 0)
					
					Camera.CameraType	= Enum.CameraType.Scriptable
					Camera.CFrame		= camPos
					
					wait(0.025)
				end
			end)()
		end
	end)
	
	animTrack:Play()
end

CrateAnim.OnClientEvent:connect(function(gun, skin)
	script.Parent.Parent.Menew.Enabled	= false
	script.Parent.FreeMouse.Modal		= true
	script.Parent.FreeMouse.Active		= true
	script.Parent.FreeMouse.Selectable	= true
	script.Parent.FreeMouse.Visible		= true
	script.Parent.Parent.GUI.Parent	= Camera
	game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
	
	doAnimation(gun, skin)
end)