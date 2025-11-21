game.ReplicatedStorage:WaitForChild("Weapons")
local numcand=0
repeat wait() until game.Players.LocalPlayer

--print("Spectate works")

local cinematic=false 

local anim=nil
GetName = require(game.ReplicatedStorage.GetTrueName)

local function PlayLocalSound(soundobj)
	if game.SoundService.Sounds.Flashbang.Enabled==false then
		local sound=soundobj:clone()
		sound.Parent=game.Players.LocalPlayer.PlayerGui.LocalSounds
		sound.Volume=sound.Volume*game.SoundService.Sounds.Volume
		sound.PlayOnRemove=true
		sound:Destroy()
	end
end

local currenttool
local camerashit=script.Parent.Parent.Parent:WaitForChild("mecameramyboy")
--game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
--print("skins")	
--print("skins")
local player = game.Players.LocalPlayer
local cam = game.Workspace.CurrentCamera
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local pos = 1
local type = "Scriptable"
local current = script.Parent:WaitForChild("Current")
local randomHumanoid = nil

local function mapSkin(gun, skin)
	local gn = gun.Name
	local skindataf = skin
	--print("skins")
	if skindataf ~= nil then
		local skin = skindataf
		--print("skins")
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
			
			local skindata = game.ReplicatedStorage.Skins:FindFirstChild(whichskin):FindFirstChild(skin)	
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
					elseif gun:FindFirstChild(skindatach[i].Name.."2") and not gun:FindFirstChild(skindatach[i].Name) and (string.find(whichskin, "Knife") or string.find(whichskin, "Karambit") or string.find(whichskin, "Cleaver") or string.find(whichskin, "Sickle") or string.find(whichskin, "Bearded Axe") or string.find(whichskin, "Bayonet")) then
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

local function getSkin(model)
	local skin 	= "Stock"
	local found	= false
	--print("skins")
	
	if model:FindFirstChild("Handle2") and model["Handle2"]:IsA("MeshPart") then
		skin = model["Handle2"].TextureID
	elseif model:FindFirstChild("Handle2") then
		skin = model["Handle2"].Mesh.TextureId
	end
	
	for _,v in pairs(game.ReplicatedStorage.Skins:GetChildren()) do
		for _,c in pairs(v:GetChildren()) do
			if c:FindFirstChild("Handle") and c["Handle"].Value == skin or c:FindFirstChild("WorldModel") and c.WorldModel:FindFirstChild("Main") and c.WorldModel.Main.Value == skin then
				skin = c.Name
				found = true
				
				break
			end
		end
		
		if found then
			break
		end
	end
	
	return skin
end

--print("worksd")
			-- A dictionary of property names, and the values they are trying to reach in the interpolation:
			
local TweenService = game:GetService("TweenService")	
			
local function makeviewmodel(viewmodel,animatevalue,player,skinkey)
	if viewmodel==nil then
		return
	end
	if game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel)==nil then
	return
	end
	currenttool=viewmodel
if cam:FindFirstChild("Arms") then
cam.Arms:Destroy()
	end
	
	--print("worksd")
local fake=game.ReplicatedStorage.Viewmodels["v_"..viewmodel]:clone()
pcall(function()
	if player.Character then
		local worldmodel	= player.Character:FindFirstChild("Gun")
		local skin	= getSkin(worldmodel)
		if skin and skin ~= "Stock" then
			pcall(function()
				mapSkin(fake, skin)
			end)
		end
	end
end)
	--SKINS
	--print("worksd")
	
--SKIN OVER
local stringvalue=Instance.new("StringValue")
stringvalue.Name="toolname"
stringvalue.Parent=fake
stringvalue.Value=viewmodel
local armies="CSSArms"
local teamthing=game.Workspace.Map.Tee.Value
if randomHumanoid and randomHumanoid.Parent and game.Players:GetPlayerFromCharacter(randomHumanoid.Parent) and player and game.Players:GetPlayerFromCharacter(randomHumanoid.Parent).Status.Team.Value=="CT" then
	teamthing=game.Workspace.Map.CeeT.Value
end
if game.ReplicatedStorage.Viewmodels:FindFirstChild(teamthing.."Arms") then
	armies=teamthing.."Arms"
end
local armsample=game.ReplicatedStorage.Viewmodels[armies]:clone()


fake.Name="Arms"
			delay(.18,function()	if fake and fake:FindFirstChild("Silencer2") and randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("Gun") and randomHumanoid.Parent.Gun:FindFirstChild("Silencer2") then
					fake.Silencer2.Transparency=randomHumanoid.Parent.Gun.Silencer2.Transparency
			end
			end)
local child=armsample
local rweld=Instance.new("Motor6D")
local lweld=nil
	if fake:FindFirstChild("Left Arm") then
		lweld=Instance.new("Motor6D")
	end
rweld.Parent=armsample["Right Arm"]
	if fake:FindFirstChild("Left Arm") then
		lweld.Parent=armsample["Left Arm"]
	end
	armsample.Parent=fake
	
	--print("worksd")
	
rweld.Part0=fake["Right Arm"]
rweld.Part1=armsample["Right Arm"]

	rweld.C0=CFrame.Angles(0,math.rad(-90),math.rad(90))
--end
	if fake:FindFirstChild("Left Arm")==nil then
		armsample["Left Arm"]:Destroy()
	end
	if fake:FindFirstChild("Left Arm") then
		lweld.Part0=fake["Left Arm"]
		lweld.Part1=armsample["Left Arm"]
	--if armies=="ECArms" then
	lweld.C0=CFrame.Angles(0,math.rad(-90),math.rad(90))
	--end
	--if armies=="PCArms" then
	
		fake["Left Arm"].Transparency=1
	end
fake["Right Arm"].Transparency=1
	
	--print("worksd")
	
		fake.Parent=cam
		if fake:FindFirstChild("Guy") and game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel) then
					if anim then
						anim:Stop()
		end
		--print('works')
				anim=fake["Guy"]:LoadAnimation(game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel)["equip"])
				local gun=game.ReplicatedStorage.Weapons:FindFirstChild(viewmodel)
				anim.KeyframeReached:connect(function(KF)
					if gun and gun:FindFirstChild("Model") and gun.Model:FindFirstChild(KF) then
						PlayLocalSound(gun.Model[KF])
					end
				end)
				if randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("Gun") and randomHumanoid.Parent.Gun:FindFirstChild("Equip") then
					PlayLocalSound(randomHumanoid.Parent.Gun.Equip)
				end
				anim:Play()
		end
local setting=1
if UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel2 then
	setting=2
elseif UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel3 then
	setting=3
elseif UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel4 then
	setting=4
elseif UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel5 then
	setting=5
elseif UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel6 then
	setting=6
elseif UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel7 then
	setting=7
elseif UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel8 then
	setting=8
elseif UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel9 then
	setting=9
elseif UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel10 then
	setting=10
end
	animatevalue.ChildAdded:connect(function(val)
		--print("worksd - anim")
		if fake:FindFirstChild("Guy") and game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel) then
			if val.Name=="Fire" then
					if anim then
						anim:Stop()
					end
				if fake and fake:FindFirstChild("Guy") and fake:FindFirstChild("Flash") and setting>3 then
						if game.ReplicatedStorage.Weapons:FindFirstChild(viewmodel):FindFirstChild("Silencer2")==nil or game.ReplicatedStorage.Weapons:FindFirstChild(viewmodel):FindFirstChild("Silencer2") and game.ReplicatedStorage.Weapons:FindFirstChild(viewmodel):FindFirstChild("Silencer2").Transparency==1 then
						local shit=game.ReplicatedStorage.Particles.Flash:GetChildren()
						for i=1,#shit do
							if shit[i].className=="ParticleEmitter" then
								local poop=shit[i]:clone()
								poop.Enabled=false
								poop:Emit(poop.Rate*0.12)
								poop.Parent=fake.Flash
								delay(0.12,function()
									wait(2.35)
									poop:Destroy()
								end)
							end
						end
						else
							local shit=game.ReplicatedStorage.Particles.FlashS:GetChildren()
							for i=1,#shit do
								if shit[i].className=="ParticleEmitter" then
									local poop=shit[i]:clone()
									poop.Enabled=false
									poop:Emit(poop.Rate*0.12)
									poop.Parent=fake.FlashS
									delay(0.12,function()
										poop.Enabled=false
										wait(2.35)
										poop:Destroy()
									end)
								end
							end
						end

				end
				anim=fake["Guy"]:LoadAnimation(game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel)["fire"])
				anim:Play()
			elseif val.Name=="Fire2" then
					if anim then
						anim:Stop()
					end
				if fake and fake:FindFirstChild("Guy") and fake:FindFirstChild("2Flash") then
					local shit=game.ReplicatedStorage.Particles.Flash:GetChildren()
					for i=1,#shit do
						if shit[i].className=="ParticleEmitter" then
							local poop=shit[i]:clone()
							poop.Enabled=false
							
							poop.Parent=fake["2Flash"]
							poop:Emit(poop.Rate*0.12)						
							delay(0.12,function()
								poop.Enabled=false
								wait(2.35)
								poop:Destroy()
							end)
						end
					end
				end
				anim=fake["Guy"]:LoadAnimation(game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel)["fire2"])
				anim:Play()
			elseif val.Name=="Reload1" then
					if anim then
						anim:Stop()
					end
				anim=fake["Guy"]:LoadAnimation(game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel)["1reload"])
				anim:Play()
			elseif val.Name=="Reload2" then
					if anim then
						anim:Stop()
					end
				anim=fake["Guy"]:LoadAnimation(game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel)["2reload"])
				anim:Play()
			elseif val.Name=="Stab" then
					if anim then
						anim:Stop()
					end
				anim=fake["Guy"]:LoadAnimation(game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel)["stab"])
				anim:Play()
			elseif val.Name=="Apply" then
					if anim then
						anim:Stop()
					end
				anim=fake["Guy"]:LoadAnimation(game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel)["sapply"])
				anim.KeyframeReached:connect(function(KF)
					if KF=="transparency0" then
					fake.Silencer2.Transparency=0
					end
					if KF=="transparency1" then
					fake.Silencer2.Transparency=1
					end
				end)
				anim:Play()
			elseif val.Name=="Remove" then
					if anim then
						anim:Stop()
					end
				anim=fake["Guy"]:LoadAnimation(game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel)["sremove"])
				anim.KeyframeReached:connect(function(KF)
					if KF=="transparency0" then
					fake.Silencer2.Transparency=0
					end
					if KF=="transparency1" then
					fake.Silencer2.Transparency=1
					end
				end)
				anim:Play()
			elseif val.Name=="Reload" then
					if anim then
						anim:Stop()
					end
				anim=fake["Guy"]:LoadAnimation(game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel)["reload"])
				anim:Play()
			elseif val.Name=="Inspect" then
					if anim then
						anim:Stop()
					end
				anim=fake["Guy"]:LoadAnimation(game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..viewmodel)["inspect"])
				anim:Play()
			end
		end
	end)
end



--Starts Off Death Stage With Free Camera
script.Parent.Changed:connect(function()
	
	--print("worksd")
	
	if script.Parent.Visible then
		
		--print("worksd")
		
		type = "Scriptable"
		cam.CameraType = Enum.CameraType.Scriptable
		current.Value = ""
	end
end)

local function spectatetp(candidates)
	
	--print("sepc tp")

	if randomHumanoid~= candidates[pos] or type == "Scriptable" then
	else
		return
	end
				if cam and cam:FindFirstChild("Arms") then
					cam.Arms:Destroy()
				end
				if type=="Scriptable" then
					type = "Follow"
	end
	--print('works')
	        randomHumanoid = candidates[pos]

			if type=="FollowFirstPerson" and randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("EquippedTool") and randomHumanoid.Parent:FindFirstChild("Gun") then
				makeviewmodel(randomHumanoid.Parent.EquippedTool.Value,randomHumanoid.Parent.Gun.AnimateValue,game.Players:FindFirstChild(randomHumanoid.Parent.Name),nil)
			end

					cam.CameraSubject = camerashit
			if randomHumanoid and randomHumanoid.Parent and game.Players:GetPlayerFromCharacter(randomHumanoid.Parent) then
				current.Value = game.Players:GetPlayerFromCharacter(randomHumanoid.Parent).Name
			end
end
--Changes Focus

local function buttonspectate()
	--print("button spec")
		if script.Parent.Visible then
		local candidates = {}
		for i=1,#game.Players:GetPlayers() do
			local other=game.Players:GetPlayers()[i]
			--print("chanGE")
		    if other.Character and other.Character:FindFirstChild("Humanoid") and other.Character:FindFirstChild("UpperTorso") and other.Character:FindFirstChild("Head") and other.Character:FindFirstChild("Gun") then
				if player and player.Status and player.Status.Team.Value=="Spectator" or other and other:FindFirstChild("Status") and player.Status.Team.Value==other.Status.Team.Value and game.ReplicatedStorage.gametype.Value=="competitive" or game.ReplicatedStorage.gametype.Value~="competitive" then		
					--print("WORKS")
				table.insert(candidates, other.Character.Humanoid)
				end
		    end
		end
        if #candidates >= 1 then -- If there is at least one candidate...
			if (pos - 1) < 1 then
				pos = #candidates
			else
				pos = pos -1
			end
            spectatetp(candidates)
			
        end
	end
end


game:GetService("UserInputService").InputBegan:Connect(function(key, u)
	--print("input_V2")
	if (script.Parent.Parent.Main.GlobalChat.ActiveOne.Value==true or script.Parent.Parent.Main.TeamChat.ActiveOne.Value==true) then
		return
	end
	if key.KeyCode == Enum.KeyCode.ButtonL1 then

		if script.Parent.Visible then
			--print('works')
		local candidates = {}
		for i=1,#game.Players:GetPlayers() do
			local other=game.Players:GetPlayers()[i]
		    if other.Character and other.Character:FindFirstChild("Humanoid") and other.Character:FindFirstChild("UpperTorso") and other.Character:FindFirstChild("Head") and other.Character:FindFirstChild("Gun") then
				if player and player.Status and player.Status.Team.Value=="Spectator" or other and other:FindFirstChild("Status") and player.Status.Team.Value==other.Status.Team.Value and game.ReplicatedStorage.gametype.Value=="competitive" then				
				table.insert(candidates, other.Character.Humanoid)
				end
		    end
		end
        if #candidates >= 1 then -- If there is at least one candidate...
			if (pos + 1) > #candidates then
				pos = 1
			else
				pos = pos + 1
			end
			spectatetp(candidates)
        end
		end
	end
	
	if key.KeyCode == Enum.KeyCode.ButtonR1 then

	if script.Parent.Visible then
		local candidates = {}
		for i=1,#game.Players:GetPlayers() do
			local other=game.Players:GetPlayers()[i]
		    if other.Character and other.Character:FindFirstChild("Humanoid") and other.Character:FindFirstChild("UpperTorso") and other.Character:FindFirstChild("Head") and other.Character:FindFirstChild("Gun") then
				if player and player.Status and player.Status.Team.Value=="Spectator" or other and other:FindFirstChild("Status") and player.Status.Team.Value==other.Status.Team.Value and game.ReplicatedStorage.gametype.Value=="competitive" or game.ReplicatedStorage.gametype.Value~="competitive" then				
				table.insert(candidates, other.Character.Humanoid)
				end
		    end
		end
        if #candidates >= 1 then -- If there is at least one candidate...
			if (pos - 1) < 1 then
				pos = #candidates
			else
				pos = pos -1
			end
            spectatetp(candidates)
		else
			type = "Scriptable"
			--cam.CameraType = Enum.CameraType.Follow
			if randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("Head") then
				cam.CameraSubject = camerashit
			end
			cam.CameraType = Enum.CameraType.Scriptable
			current.Value = ""
        end
	end
	end
end)


mouse.KeyDown:connect(function(key)
	--print("keydown")
	if key:lower()=="p" then
		if script.Parent.Parent.Parent:FindFirstChild("Loading") then
		else
			cinematic=not cinematic
		end
	end
end)

mouse.Button1Down:connect(function()
	--print("button")
	buttonspectate()
end)
local function Scan(parent,transparency)
	for i,v in pairs(parent:GetChildren()) do
		if v:IsA'BasePart' then
			v.LocalTransparencyModifier=transparency
			Scan(v,transparency)
		end
	end
end
--Frees Camera When Targeted Player Dies
game:GetService("UserInputService").InputBegan:connect(function(key)
	--print("worksd")
	if (script.Parent.Parent.Main.GlobalChat.ActiveOne.Value==true or script.Parent.Parent.Main.TeamChat.ActiveOne.Value==true) then
		return
	end
	if key.KeyCode == Enum.KeyCode.Space then
		if player.Status.Team.Value~="Spectator" and game.ReplicatedStorage.gametype.Value=="competitive" then
			else
			if script.Parent.Visible then
				if type == "Scriptable" then
					cam.CameraType = Enum.CameraType.Scriptable
					type = "FollowFirstPerson"
					if type=="FollowFirstPerson" and randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("EquippedTool") and randomHumanoid.Parent:FindFirstChild("Gun") then
						makeviewmodel(randomHumanoid.Parent.EquippedTool.Value,randomHumanoid.Parent.Gun.AnimateValue,game.Players:FindFirstChild(randomHumanoid.Parent.Name),nil)
					end
					--print('works')
				elseif type == "FollowFirstPerson" then
					cam.CameraType = Enum.CameraType.Follow
					if cam and cam:FindFirstChild("Arms") then
						cam.Arms:Destroy()
					end
					type = "Follow"
				else
					type = "Scriptable"
					--print('works')
					--cam.CameraType = Enum.CameraType.Follow
					if randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("Head") then
						cam.CameraSubject = camerashit
					end
					cam.CameraType = Enum.CameraType.Scriptable
					current.Value = ""
				end
			end
		end
	end
end)

--[[

		local players=game.Players:GetPlayers()
		for i=1,#players do 		
			if players[i].Name~=game.Players.LocalPlayer.Name and players[i] and players[i].Character and players[i].Character:FindFirstChild("Humanoid") then		
				local shits=players[i].Character:GetChildren()
					for g=1,#shits do 
						if shits[g].className=="Accessory" and shits[g]:FindFirstChild("Handle") then
							shits[g].Handle.LocalTransparencyModifier=0
						end
						if shits[g]:IsA("BasePart") then
								shits[g].LocalTransparencyModifier=0
						end
				end
			end
		end
]]

local move_anim_speed 				= 3
local last_p 						= Vector3.new()
local move_amm 						= 0


local aim_settings 					= {
	aim_amp 						= 0.5,
	aim_max_change 					= 4,
	aim_retract 					= 15,
	aim_max_deg 					= 20,
}

local last_va 						= 0
local last_va2 						= 0
local view_velocity 				= {0, 0}
local last_time 					= tick()

local waveScale = 0
local scaleIncrement = 0.05
local mgn=0 

local lastFollowedCFrame = CFrame.new(0, 0, 0)

local delayed=false





function dab()
				if cam and cam:FindFirstChild("Arms") and cam.Arms.PrimaryPart and randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("UpperTorso") then
					cam.Arms.PrimaryPart.Anchored=true
					local voffset=CFrame.new()
					if cam and cam.Arms:FindFirstChild("Offset") then
			voffset=CFrame.new(game.Players:GetPlayerFromCharacter(randomHumanoid.Parent).Stats.yy.Value,game.Players:GetPlayerFromCharacter(randomHumanoid.Parent).Stats.zz.Value,game.Players:GetPlayerFromCharacter(randomHumanoid.Parent).Stats.xx.Value)
					end
					local Camera=cam
					--[[if randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("UpperTorso") and Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("CSSArms") then
						local child=Camera.Arms
						local Player=game.Players:FindFirstChild(randomHumanoid.Parent.Name)
						if child and child.Name=="Arms" and Player.Character and Player.Character:FindFirstChild("Shirt") and Player.Character:FindFirstChild("RightUpperArm") and Player.Character:FindFirstChild("LeftUpperArm") then
							child:WaitForChild("CSSArms")["Left Arm"].Transparency=0
							child:WaitForChild("CSSArms")["Right Arm"].Transparency=0
							child:WaitForChild("CSSArms")["Left Arm"].Shirt.Texture=Player.Character.Shirt.ShirtTemplate
							child:WaitForChild("CSSArms")["Right Arm"].Shirt.Texture=Player.Character.Shirt.ShirtTemplate
							child:WaitForChild("CSSArms")["Left Arm"].BrickColor=Player.Character["LeftUpperArm"].BrickColor
							child:WaitForChild("CSSArms")["Right Arm"].BrickColor=Player.Character["RightUpperArm"].BrickColor
						end
					end]]
					local Character=randomHumanoid.Parent
					local UpperTorso=randomHumanoid.Parent.UpperTorso
					-------do your fancy viewmodel sway here
		if randomHumanoid:GetState()==Enum.HumanoidStateType.Running or randomHumanoid:GetState()==Enum.HumanoidStateType.Climbing or randomHumanoid.Parent:FindFirstChild("Climbing") or Character and Character:FindFirstChild("ScopeCooldown") then
			if waveScale < 0.5 then
			waveScale = math.min(0.5,waveScale+scaleIncrement)
			end
		else
			if waveScale > 0 then
			waveScale = math.max(0,waveScale-scaleIncrement)
			end
		end
		local abs,cos = math.abs,math.cos
		local t = cos(tick() * (math.pi*2.5))
		if mgn<UpperTorso.Velocity.magnitude then
		mgn=math.min(UpperTorso.Velocity.magnitude,mgn+1)
		end
		if mgn>UpperTorso.Velocity.magnitude then
		mgn=math.max(UpperTorso.Velocity.magnitude,mgn-1.5)
		end		
		local movementmult=(mgn/18.35)
		local bobble = CFrame.new(((0.25*movementmult)+((t/10)*movementmult))*waveScale,((0.25*movementmult)+(abs(t/10)*movementmult))*-waveScale,abs(0.25*movementmult)*waveScale) 
		--[[if ads==true then
		bobble = CFrame.new(((t/10)*(movementmult))*waveScale,(abs((t/10))*movementmult)*-waveScale,0) 
		end]]

--[[
	local delta = tick() - last_time
	last_time = tick()
	local shake_freq 				= 5
	local shake_amp 				= {0.1, 0.1}
	local arm_shake 				= CFrame.new(
		math.sin(math.rad(tick() * 90 * shake_freq)) * move_amm * shake_amp[1],
		0, math.abs(math.sin(math.rad(tick() * 90 * shake_freq)) * move_amm * shake_amp[2]))
	
	local p_distance 				= ((Camera.CoordinateFrame.lookVector)).magnitude
	if p_distance == 0 then p_distance = 0.0001 end
	local p_height 					= Camera.CoordinateFrame.lookVector.y 
	local view_angle
	if p_height ~= 0 then
		view_angle 					= math.deg(math.asin(math.abs(p_height) / p_distance)) * (math.abs(p_height) / p_height)
	else
		view_angle 					= 0
	end
	
	local cam_cf 					= Camera.CoordinateFrame
	local looking_at 				= cam_cf * CFrame.new(0, 0, -100)
	local view_angle2 				= math.deg(math.atan2(cam_cf.p.x - looking_at.p.x, cam_cf.p.z - looking_at.p.z)) + 180
	
	local v_delta1, v_delta2
	local dir1, dir2 				= 0, 0
	v_delta1 						= math.abs(view_angle - last_va)
	if v_delta1 ~= 0 then
		dir1 						= (view_angle - last_va) / v_delta1
	end
	local va_check 					= {math.abs(view_angle2 - last_va2), 360 - math.abs(view_angle2 - last_va2)}
	if view_angle2 == last_va2 then
		dir2 						= 0
		v_delta2 					= 0
	elseif va_check[1] < va_check[2] then
		v_delta2 					= va_check[1]
		dir2 						= (view_angle2 - last_va2) / va_check[1]
	else
		v_delta2 					= va_check[2]
		if last_va2 > view_angle2 then
			dir2 					= 1
		else
			dir2 					= -1
		end
	end
	last_va 						= view_angle
	last_va2 						= view_angle2
	
	view_velocity[1] 				= view_velocity[1] / (1 + (delta * aim_settings.aim_retract))
	view_velocity[2] 				= view_velocity[2] / (1 + (delta * aim_settings.aim_retract))
	
	local calc1 					= v_delta1 * dir1 * aim_settings.aim_amp
	if calc1 ~= 0 then
		view_velocity[1] 			= view_velocity[1] + (math.min(aim_settings.aim_max_change, math.abs(calc1)) * (calc1 / math.abs(calc1)))
	end
	local calc2 					= v_delta2 * dir2 * aim_settings.aim_amp
	if calc2 ~= 0 then
		view_velocity[2] 			= view_velocity[2] + (math.min(aim_settings.aim_max_change, math.abs(calc2)) * (calc2 / math.abs(calc2)))
	end
	
	if view_velocity[1] ~= 0 then
		view_velocity[1] 			= math.min(aim_settings.aim_max_deg, math.abs(view_velocity[1])) * (math.abs(view_velocity[1]) / view_velocity[1])
	end
	if view_velocity[2] ~= 0 then
		view_velocity[2] 			= math.min(aim_settings.aim_max_deg, math.abs(view_velocity[2])) * (math.abs(view_velocity[2]) / view_velocity[2])
	end					
					]]
					
					
					if randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("ADS") then
						if randomHumanoid.Parent.ADS.Value==true then
							if cam.Arms:FindFirstChild("ADS")==nil then
								local dent=Instance.new("IntValue")
								dent.Parent=cam.Arms
								dent.Name="ADS"
							end
							if randomHumanoid.Parent.ADS.Doublezoom.Value==true then
								if cam.Arms.ADS:FindFirstChild("Doublezoom")==nil then
									local dent=Instance.new("IntValue")
									dent.Parent=cam.Arms.ADS
									dent.Name="Doublezoom"
								end
							else
								if cam.Arms.ADS:FindFirstChild("Doublezoom") then
									cam.Arms.ADS.Doublezoom:Destroy()
								end
							end
						else
							if cam.Arms:FindFirstChild("ADS") then
								cam.Arms.ADS:Destroy()
							end
						end
					end
					
					if cam.Arms:FindFirstChild("ADS") then
						voffset=CFrame.new(0,0,10)
						cam.FieldOfView=31.2
						if cam.Arms.ADS:FindFirstChild("Doublezoom") then
							cam.FieldOfView=11.7
							if cam.Arms:FindFirstChild("toolname") and cam.Arms.toolname.Value=="AWP" then
								cam.FieldOfView=7.8
							end
						end
					end
					
					---------------------*CFrame.Angles(-view_velocity[1]/200,-view_velocity[2]/200,0)
					cam.Arms:SetPrimaryPartCFrame(cam.CoordinateFrame*voffset*(bobble))
				end
end





while true do
	game:GetService("RunService").Heartbeat:wait()
	if game.ReplicatedStorage.gametype.Value=="TTT" and game.Workspace.Status.CanRespawn.Value==true and player.Status.Alive.Value==false then
		script.Parent.Parent.begal.Controls2.Visible=true
	else
		script.Parent.Parent.begal.Controls2.Visible=false
	end
	pcall(function()
		if type=="Scriptable" and player.Character==nil and script.Parent.Parent.TextButton.Visible==false  then

			script.Parent.Parent.Parent.Freecam.Disabled=false
		else
			if script.Parent.Parent.Parent.Freecam.Disabled==false then
				script.Parent.Parent.Parent.Freecam.Disabled=true
				game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
			end
		end
		script.Parent.FPSpectating.Value=""
		if script.Parent.Parent.Parent:FindFirstChild("Loading") then
			script.Parent.Parent.Enabled=false
		else
			script.Parent.Parent.Enabled=not cinematic
		end
		if player and player.CameraCF and player.CameraCF.Value~=cam.CoordinateFrame then
			game.ReplicatedStorage.Events.ReplicateCamera:FireServer(cam.CoordinateFrame)
		end
			script.Parent.PlayerBox.Visible=false
			if script.Parent.Visible and type == "Follow" or script.Parent.Visible and type == "FollowFirstPerson" then
				if randomHumanoid and randomHumanoid.Parent and game.Players:GetPlayerFromCharacter(randomHumanoid.Parent) then
					script.Parent.PlayerBox.Visible=true
					local v = game.Players:GetPlayerFromCharacter(randomHumanoid.Parent)
					if v and v:FindFirstChild("EquippedPin") and v.EquippedPin.Value ~= "" then
						script.Parent.PlayerBox.PlayerPin.Image = v.EquippedPin.Value					
						script.Parent.PlayerBox.PlayerPin.Visible = true
					else
						script.Parent.PlayerBox.PlayerPin.Visible = false
					end
				script.Parent.PlayerBox.PlayerIcon.Plr.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..game.Players:GetPlayerFromCharacter(randomHumanoid.Parent).UserId.."&width=420&height=420&format=png"
				script.Parent.Xvalue.Value = game.Players:GetPlayerFromCharacter(randomHumanoid.Parent).Stats.xx.Value
				script.Parent.Yvalue.Value = game.Players:GetPlayerFromCharacter(randomHumanoid.Parent).Stats.yy.Value
				script.Parent.Zvalue.Value = game.Players:GetPlayerFromCharacter(randomHumanoid.Parent).Stats.zz.Value
				script.Parent.PlayerBox.PlayerName.Text=randomHumanoid.Parent.Name
				script.Parent.PlayerBox.PlayerName.TextColor3=game.Players:GetPlayerFromCharacter(randomHumanoid.Parent).TeamColor.Color
				script.Parent.PlayerBox.BackgroundColor3=game.Players:GetPlayerFromCharacter(randomHumanoid.Parent).TeamColor.Color
				script.Parent.PlayerBox.GreyPart.WeaponName.Text= GetName.getName(randomHumanoid.Parent.EquippedTool.Value) 
				script.Parent.PlayerBox.GreyPart.PHealth.Text=math.ceil(randomHumanoid.Health)
				end
			end
			if script.Parent.Visible then
				if player.Status.Team.Value~="Spectator" and game.ReplicatedStorage.gametype.Value=="competitive" then
			local candidates = {}
			numcand=0
			for i=1,#game.Players:GetPlayers() do
				local other=game.Players:GetPlayers()[i]
			    if other.Character and other.Character:FindFirstChild("Humanoid") and other.Character:FindFirstChild("UpperTorso") and other.Character:FindFirstChild("Head") and other.Character:FindFirstChild("Gun") then
					if player and player.Status and player.Status.Team.Value=="Spectator" or other and other:FindFirstChild("Status") and player.Status.Team.Value==other.Status.Team.Value and game.ReplicatedStorage.gametype.Value=="competitive" or game.ReplicatedStorage.gametype.Value~="competitive" then				
					numcand=numcand+1
					end
			    end
			end
					if numcand>0 then
						cam.CameraType = Enum.CameraType.Scriptable
						type = "FollowFirstPerson"
						if randomHumanoid and randomHumanoid.Health>0 then
						else					
						buttonspectate()
						end
						if type=="FollowFirstPerson" and randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("EquippedTool") and randomHumanoid.Parent:FindFirstChild("Gun") and cam and cam:FindFirstChild("Arms")==nil then
							makeviewmodel(randomHumanoid.Parent.EquippedTool.Value,randomHumanoid.Parent.Gun.AnimateValue,game.Players:FindFirstChild(randomHumanoid.Parent.Name),nil)
						end
					else
						cam.CameraType=Enum.CameraType.Scriptable
						type="Scriptable"
					end
				end
				cam.FieldOfView=75
				pcall(function()
				if randomHumanoid and randomHumanoid.Parent and game.Players:FindFirstChild(randomHumanoid.Parent.Name) and game.Players:FindFirstChild(randomHumanoid.Parent.Name).Character and game.Players:FindFirstChild(randomHumanoid.Parent.Name).Character:FindFirstChild("Humanoid") then
					randomHumanoid=game.Players:FindFirstChild(randomHumanoid.Parent.Name).Character.Humanoid
				end
				end)
		cam.CameraType=Enum.CameraType.Scriptable
		local players=game.Players:GetPlayers()
				for i=1,#players do 		
					if players[i] and players[i].Character and players[i].Character:FindFirstChild("Humanoid") then		
						if randomHumanoid and randomHumanoid.Parent and players[i].Character.Name==randomHumanoid.Parent.Name and type == "FollowFirstPerson" then
						local shits=players[i].Character:GetChildren()
							for g=1,#shits do 
								if shits[g].className=="Hat" and shits[g]:FindFirstChild("Handle") or shits[g].className=="Accessory" and shits[g]:FindFirstChild("Handle") then
									shits[g].Handle.LocalTransparencyModifier=1
								end
								if shits[g]:IsA("BasePart") then
									shits[g].LocalTransparencyModifier=1
									if shits[g].Name=="Gun" then
										Scan(shits[g],1)
									end
									if shits[g].Name=="Gun2" then
										Scan(shits[g],1)
									end
								end
							end
						else
						local shits=players[i].Character:GetChildren()
							for g=1,#shits do 
								if shits[g].className=="Hat" and shits[g]:FindFirstChild("Handle") or shits[g].className=="Accessory" and shits[g]:FindFirstChild("Handle") then
									shits[g].Handle.LocalTransparencyModifier=0
								end
								if shits[g]:IsA("BasePart") then
									shits[g].LocalTransparencyModifier=0
									if shits[g].Name=="Gun" then
										Scan(shits[g],0)
									end
									if shits[g].Name=="Gun2" then
										Scan(shits[g],0)
									end
								end
							end
						end
					end
				end
				
				
				local debra=game.Workspace.Debris:GetChildren()
				for i=1,#debra do
					if debra[i] and debra[i]:FindFirstChild("Humanoid2") then
						local shits=debra[i]:GetChildren()
						for g=1,#shits do
							if shits[g].className=="Hat" and shits[g]:FindFirstChild("Handle") or shits[g].className=="Accessory" and shits[g]:FindFirstChild("Handle") then
								shits[g].Handle.LocalTransparencyModifier=0
							end
							if shits[g]:IsA("BasePart") then
								shits[g].LocalTransparencyModifier=0
							end
						end
					end
				end
	
				if type == "Follow" then
					cam.CameraType = Enum.CameraType.Custom
					
					if randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("Head") then
						camerashit.CFrame=randomHumanoid.Parent.Head.CFrame
					end
					--[[local ray = Ray.new(camerashit.CFrame.p, cam.CFrame.p - camerashit.CFrame.p)
					local hit, position, normal = game.Workspace:FindPartOnRayWithWhitelist(ray, {game.Workspace.Map.Geometry})
					if hit and position then
						cam.CFrame = CFrame.new(position, camerashit.Position)
					end]]
					if randomHumanoid and randomHumanoid.Health>0 then
						else
						buttonspectate()
					end
				elseif type == "FollowFirstPerson" then
					if randomHumanoid and randomHumanoid.Parent and randomHumanoid.Health>0 and game.Players:FindFirstChild(randomHumanoid.Parent.Name) and game.Players:FindFirstChild(randomHumanoid.Parent.Name):FindFirstChild("CameraCF") and randomHumanoid.Parent:FindFirstChild("Head") then
						script.Parent.FPSpectating.Value=randomHumanoid.Parent.Name
						cam.CameraType = Enum.CameraType.Scriptable
						cam.CameraSubject = camerashit
						camerashit.CFrame=game.Players:FindFirstChild(randomHumanoid.Parent.Name).CameraCF.Value
						cam.CoordinateFrame=camerashit.CFrame
						--[[if delayed==false then
							delayed=true
							local tweenInfo = TweenInfo.new(
								timer*2,								-- Length of an interpolation
								Enum.EasingStyle.Sine,		-- Easing Style of the interpolation
								Enum.EasingDirection.Out		-- Easing Direction of the interpolation
							)
							game:GetService("TweenService"):Create(cam,tweenInfo, {CoordinateFrame=camerashit.CFrame}):Play()
							delay(timer*2,function()
								delayed=false
							end)
						end]]
					else
							buttonspectate()
					end
	
					if randomHumanoid and randomHumanoid.Parent and randomHumanoid.Parent:FindFirstChild("Gun") and randomHumanoid.Parent:FindFirstChild("EquippedTool") and currenttool~=randomHumanoid.Parent.EquippedTool.Value then
						
						makeviewmodel(randomHumanoid.Parent.EquippedTool.Value,randomHumanoid.Parent.Gun.AnimateValue,game.Players:FindFirstChild(randomHumanoid.Parent.Name),nil)
					end
					dab()
				else
					if cam and cam:FindFirstChild("Arms") then
						cam.Arms:Destroy()
					end
					cam.CameraType = Enum.CameraType.Scriptable
			end
			end
	end)
end

--print("Spectate works_ALL")