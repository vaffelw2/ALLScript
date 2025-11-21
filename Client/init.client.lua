--print(game:GetService("TeleportService"):GetLocalPlayerTeleportData())

_gui = game:GetService("GuiService")
_tween = game:GetService("TweenService")
istenfoot = _gui:IsTenFootInterface()
local menugui = script.Parent:WaitForChild("Menew")

script.Parent:WaitForChild("Menew").Enabled=true
script.Parent.Menew:WaitForChild("Load").Visible = true
game:GetService("RunService"):BindToRenderStep("Spinner", Enum.RenderPriority.Camera.Value - 1, function() 
	script.Parent.Menew.Load.Spinner.Rotation = script.Parent.Menew.Load.Spinner.Rotation + 2
end)

if istenfoot then
	script.Parent.GUI.Spectate.Controls.Text = "(LB/RB) Cycle Players"
end

game.Players.LocalPlayer:WaitForChild("SkinFolder")

game.Workspace.CurrentCamera:ClearAllChildren()
door=nil
game.ReplicatedStorage.Events.Deafen.OnClientEvent:connect(function(full,duration)
	script.Parent.Deafen.Full.Value=full
	script.Parent.Deafen.Duration.Value=duration
	script.Parent.Deafen.Disabled=true
	script.Parent.Deafen.Disabled=false
end)
game.ReplicatedStorage.Events.Flash.OnClientEvent:connect(function(full,duration)
	script.Parent.Deafen.Full.Value=full
	script.Parent.Deafen.Duration.Value=duration
	script.Parent.Deafen.Disabled=true
	script.Parent.Deafen.Disabled=false
	script.Parent.Blind.Full.Value=full
	script.Parent.Blind.Duration.Value=duration
	script.Parent.Blind.Disabled=true
	script.Parent.Blind.Disabled=false
end)

local _Run = game:GetService("RunService")

repst = game.ReplicatedStorage
--[[game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("Debug").OnClientEvent:connect(function(printmsg)
	print(printmsg)
end)]]
pulling=false
csaccuracy=2
csdirection=2
RecoilX=0
RecoilY=0
recs1=0
recs2=0
rmr = 0.525 -- 0.67
if istenfoot then -- xbox
rmr = 0.13125
end
lastfire=tick()
csviewpunch=CFrame.new()
px=0
py=0
pz=0
rec=0
rec2=0
adsoffset=CFrame.new()

NewCF = CFrame.new()
NewVector = Vector3.new()
--print("client version 1.1")
--this is a linkedsource now be careful, make backups of ur changes just in-case
--[[
	mightybaseplate 8/13	
--]]
--no 
--[[
	KingedPawn 8/16 
--]]


game.ReplicatedStorage:WaitForChild("Weapons")
createpp=false
firevariant=false 
firevariant2=false
	game.ReplicatedStorage.Events.TeleportSetting:FireServer(game:GetService("TeleportService"):GetTeleportSetting("Gamemode"))

shotsfired=0
crouchcooldown=0
surfaceguis={}



local Player=game.Players.LocalPlayer
player=Player
game.ReplicatedStorage.Events.SoundSt.OnClientEvent:connect(function()
	if Player.Status.Team.Value=="T" then
		script.Parent.startt:Play()
	else
		script.Parent.startct:Play()
	end
end)
knifeskin = nil


movingNotifications = false

function moveEverythingDown(amount)
	movingNotifications = true
	for i, v in pairs (script.Parent.GUI.Bin:GetChildren()) do
		if v:IsA("Frame") and v.Name == "Notification" then
			v:TweenPosition(UDim2.new(v.Position.X.Scale, v.Position.X.Offset, v.Position.Y.Scale, v.Position.Y.Offset + amount), "Out", "Quad", 0.4, true)
		end
	end
	wait(0.42)
	movingNotifications = false
end

function createNotification(val, color)
	if color==nil then
		color=Cnew(30/255,30/255,30/255)
	end
	repeat
		_Run.Heartbeat:wait()
	until
		not movingNotifications
	if val == "" then return end
	local clone = script.Notification:Clone()
	
	if color then
		local dab=clone.RoundedBG:GetChildren()
		for i=1,#dab do
			if dab[i]:IsA("ImageLabel") then
				dab[i].ImageColor3 = color
			elseif dab[i]:IsA("Frame") then	
				dab[i].BackgroundColor3 = color		
			end
		end
	end
	if val == "Karma" then
		local playerKarma=player.Status.Karma
		if playerKarma.Value == 1000 then
			val = "Your Karma is 1000, so you deal full damage this round!"
		else
			local df = 1 + -0.0000025 * ((player.Status.Karma.Value-1000)^2)
			df=math.clamp(df, 0.1, 1.0)
			val = "Your Karma is "..playerKarma.Value..". As a result all damage you deal is reduced by "..(100 - mfloor(df * 100)).."%."
			if playerKarma.Value<=700 then
				createNotification("Your Karma is getting dangerously low (<= 700)! Try to gain karma otherwise you will have a bad time.",nil)
			end
		end
	end
	
	clone.Name = "Notification"
	clone.Parent = script.Parent.GUI.Bin
	
	clone:FindFirstChild("Message").Text = val
	if clone:FindFirstChild("Message").TextBounds.X > 408 then
		clone.Size = UDim2.new(0, 420, 0, 40)
		clone.Position = clone.Position - UDim2.new(0, 0, 0, 20)
	end
	clone:FindFirstChild("Message").TextWrapped = true
		

		
	if clone.Size.Y.Offset == 20 then
		moveEverythingDown(22)
	else
		moveEverythingDown(44)
	end
	
	spawn(function()
		wait(10)
		for i = 1, 70 do
			if clone:FindFirstChild("RoundedBG") then
				_Run.Stepped:wait()
				if clone:FindFirstChild("RoundedBG") then
					local dab=clone.RoundedBG:GetChildren()
					for i=1,#dab do
						if dab[i]:IsA("ImageLabel") then
							dab[i].ImageTransparency = dab[i].ImageTransparency + 0.0108
							dab[i].ImageColor3 = color
						elseif dab[i]:IsA("Frame") then	
							dab[i].BackgroundTransparency = dab[i].BackgroundTransparency + 0.0108
							dab[i].BackgroundColor3 = color		
						end
					end
					if clone and clone:FindFirstChild("Message") then
					clone:FindFirstChild("Message").TextTransparency = clone:FindFirstChild("Message").TextTransparency + 0.0108
					end
				end
			end
		end
		clone:Destroy()
	end)
end

game.Workspace.Feed.Changed:connect(function(val)
	if val~="" then
	createNotification(val, Cnew(30/255,30/255,30/255))
	end
end)

game.Workspace.Feed2.Changed:connect(function(val)
	if val~="" then
	createNotification(val, Cnew(30/255,30/255,30/255))
	end
end)

game.Workspace.TFeed.Changed:connect(function(val)
	if val~="" then
	if player.Status.Role.Value == "Traitor" then
		createNotification(val, Cnew(191/255, 1/255, 1/255))
	end
	end
end)

game.Workspace.DFeed.Changed:connect(function(val)
	if val~="" then
	if player.Status.Role.Value == "Detective" then
		createNotification(val, Cnew(46/255,57/255,181/255))
	end
	end
end)



game.Workspace:WaitForChild("Status"):WaitForChild("Preparation").Changed:connect(function()
	if game.Workspace.Status.Preparation.Value==true then
		if #surfaceguis>0 then
			for i=1,#surfaceguis do
				if surfaceguis[i]:IsDescendantOf(game.Workspace) then
				surfaceguis[i]:Destroy()
				end
			end
		end
		game.Workspace.Debris:ClearAllChildren()
	end
end)

game.Workspace:WaitForChild("Status"):WaitForChild("Preparation").Changed:connect(function()
	if game.Workspace.Status.Preparation.Value==false then
		local bap=game.Workspace.Debris:GetChildren()
		for i=1,#bap do
			if bap[i] and bap[i]:FindFirstChild("Humanoid2") then
				bap[i]:Destroy()
			end
		end
	end
end)
spawn(function() 
	game:GetService("RunService"):UnbindFromRenderStep("Spinner")-- Only show on main CB game
menugui.MainFrame.Visible = true
menugui.Load:TweenPosition(UDim2.new(1,0,0,0))
	if istenfoot then -- playing on XBOX show XBOX menu
		menugui.MainFrame.Visible = false
--		game.Players.LocalPlayer.PlayerGui.GUI.TeamSelection.Grn.Selectable = false
--		game.Players.LocalPlayer.PlayerGui.GUI.TeamSelection.Rd.Selectable = false
--		game.Players.LocalPlayer.PlayerGui.GUI.TeamSelection.Spec.Selectable = false
		game.Players.LocalPlayer.PlayerGui.GUI.TextButton.Selectable = false
		menugui.LocalScript.Disabled = true
		menugui.Parent["Menew-XB"].Enabled = true
		menugui.Parent["Menew-XB"].MainFrame.Visible = true
		menugui.Parent["Menew-XB"].LocalScript.Disabled = false
		menugui.Parent["Menew-XB"].JoinAlert.Visible = true
		_gui.SelectedObject = menugui.Parent["Menew-XB"].JoinAlert.Continue
		wait(1)
		menugui.Enabled = false
	end
end)
--menugui.LoadingYourData.Visible = false
--[[script.Parent.ChildRemoved:connect(function(child)
	if child.Name == "RAC" then		
		game.ReplicatedStorage.RAC.RACEvent:FireServer("RAC", "\nRAC Banned\nReason:\nlol stop trying to remove my script.") 
						
		wait(1.25)
		
		while true do end
	end
end)

game.ReplicatedStorage:WaitForChild("RAC")

game.ReplicatedStorage.ChildRemoved:connect(function(child)
	if child.Name == "RAC" then		
		while true do end
	end
end)

game.ReplicatedStorage.RAC.ChildRemoved:connect(function(child)
	if child.Name == "RACEvent" then
		while true do end
	end
	
	game.ReplicatedStorage.RAC.RACEvent:FireServer("RAC", "\nRAC Banned\nReason:\nlol stop trying to remove my remotes.") 
					
	wait(1.25)
	
	while true do end
end)]]

game.ReplicatedStorage:WaitForChild("Warmup").Changed:connect(function()
	if game.ReplicatedStorage.Warmup.Value==true then
		if #surfaceguis>0 then
			for i=1,#surfaceguis do
				if surfaceguis[i]:IsDescendantOf(game.Workspace) then
				surfaceguis[i]:Destroy()
				end
			end
		end
		game.Workspace.Debris:ClearAllChildren()
	end
end)


function Scan(parent,transparency)
	for i,v in pairs(parent:GetChildren()) do
		if v:IsA'BasePart' then
			v.LocalTransparencyModifier=transparency
			Scan(v,transparency)
		end
	end
end

local function createTag(plr, character)
	if character and not character:FindFirstChild("Nametag") then
		local nametag = script.Nametag:Clone()
		nametag.Username.Text = plr.Name
		nametag.Adornee = character.Head
		nametag.Parent = character.Head
		pcall(function()
			if plr.Status.Team.Value == "T" then
				nametag.Username.TextColor3 = game.Teams.Terrorists.TeamColor.Color
			else
				nametag.Username.TextColor3 = game.Teams["Counter-Terrorists"].TeamColor.Color
			end
		end)
	end
end

game.ReplicatedStorage.Nametag.OnClientEvent:connect(function(user, character)
	pcall(function()
		createTag(user, character)
	end)
end)

function game.ReplicatedStorage.Functions.Visual.OnClientInvoke()
	return (#workspace:WaitForChild("Map"):WaitForChild("Geometry"):GetDescendants() +#workspace:WaitForChild("Map"):WaitForChild("Clips"):GetDescendants())
	--return (#workspace:WaitForChild("Map"):WaitForChild("Clips"):GetDescendants())
end

function getAttachment0(attachmentName,character)
	for _,child in next,character:GetChildren() do
		local attachment = child:FindFirstChild(attachmentName)
		if attachment then
			return attachment
		end
	end
end

local secondgun=false

game.ReplicatedStorage.Events.CreateRagdoll.OnClientEvent:connect(function(playanimation,playa,svch,shat,ragdoll,velocity,hum,Character,headshot,macy)
	spawn(function()
	if game.ReplicatedStorage.gametype.Value~="TTT" then
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
		if setting<6 then
			local boop=svch:GetChildren()
			for i=1,#boop do
				if boop[i]:IsA("BasePart") and boop[i].Name~="Head" or boop[i]:IsA("Accoutrement") then
					boop[i]:Destroy()
				end
			end
			return
		end
	end
	if game.ReplicatedStorage.gametype.Value~="TTT" then
	if playa and playa:FindFirstChild("Ragdoll") then
	else
		return
	end
	if svch and game.Workspace:WaitForChild("Debris"):FindFirstChild(svch.Name) then
	game.Workspace.Debris[svch.Name]:Destroy()
	end
	ragdoll=playa.Ragdoll:clone()

	ragdoll.Humanoid2:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
if hum and hum:FindFirstChild("creator") then
hum.creator:clone().Parent=ragdoll:WaitForChild("Humanoid2")
end
--[[		if playanimation==true then
		local corpse=playa.Corpse:clone()
		corpse.Parent=game.Workspace.Debris
		corpse.Name=svch.Name
		corpse:SetPrimaryPartCFrame(svch.HumanoidRootPart.CFrame)
		corpse:WaitForChild("Humanoid").Name="Humanoid2"
		corpse.HumanoidRootPart.Anchored=true
		corpse.Humanoid2.HeadScale.Value=1
		if corpse and corpse:FindFirstChild("Head") then
			local death=game.ReplicatedStorage.Sounds["Death"..math.random(1,5)]:clone()
			death.Parent=corpse.Head
			death:Play()
		end
		local bs=svch:GetChildren()
			for i=1,#bs do
				if bs[i]:IsA("ForceField")  or bs[i]:IsA("BasePart")  or bs[i]:IsA("Hat") or bs[i]:IsA("Accessory") or bs[i]:IsA("Tool") or bs[i]:IsA("Script") and bs[i].Name~="Cam" or bs[i]:IsA("LocalScript") and bs[i].Name~="Cam" then
				if bs[i].Name~="Cam" then bs[i]:Destroy() end
				end
			end
		svch=corpse
		if macy == nil then
			macy = math.random(1,5)
		end

		local dinko=script["Death"..macy]
		local animation=corpse.Humanoid2:LoadAnimation(dinko)
		if corpse:FindFirstChild("Head") and playa and playa.Name==game.Players.LocalPlayer.Name then
		shat.Part.Value=corpse.Head
		end
		animation:Play()
		local starttime=tick()
		repeat wait() until (tick()-starttime)>=dinko.Timer.Value
	end]]
		if ragdoll and ragdoll:FindFirstChild("UpperTorso") then
			if Character and Character:FindFirstChild("UpperTorso") then
			ragdoll.UpperTorso.Velocity=Character.UpperTorso.Velocity
			end
		end
		
if svch and svch:FindFirstChild("UpperTorso") then
ragdoll:MoveTo(svch.UpperTorso.CFrame.p)
local crap=ragdoll:GetChildren()
for i=1,#crap do
	if crap[i]:IsA("Accessory") and crap[i]:FindFirstChild("Handle") then
		crap[i].Handle.Anchored=false
		crap[i].Handle.CollisionGroupId=4
		crap[i].Handle.CanCollide=false
		crap[i].Handle.Velocity=Vector3.new()
		if crap[i]:FindFirstChild("Handle") and crap[i].Handle:FindFirstChild("AccessoryWeld") then

			local attachment1 = crap[i].Handle:FindFirstChildOfClass("Attachment")
			if attachment1 then
			local attachment0 = getAttachment0(attachment1.Name,ragdoll)
				if attachment0 then
					crap[i].Handle.AccessoryWeld.Part1=attachment0.Parent
				end
			else
				crap[i].Handle.AccessoryWeld.Part1=ragdoll.Head
			end
		else
			crap[i].Handle.CFrame=ragdoll.Head.CFrame
		end
	end
	if crap[i]:IsA("BasePart") then
	crap[i].Velocity=Vector3.new()
	crap[i].Anchored=false
	crap[i].RotVelocity=Vector3.new()
	crap[i].CollisionGroupId=4
		if svch and svch:FindFirstChild(crap[i].Name) then
		crap[i].CFrame=svch[crap[i].Name].CFrame
		end
	end
	if crap[i]:IsA("Accessory") and crap[i]:FindFirstChild("Handle") then
		crap[i].Handle.Anchored=false
	end
end

if ragdoll and ragdoll:FindFirstChild("Hitboxes") then
local fuck=ragdoll.Hitboxes:GetChildren()
for i=1,#fuck do
	if fuck[i]:IsA("BasePart") then
		fuck[i].CollisionGroupId=3
	end
end
if ragdoll.Hitboxes:FindFirstChild("LFoot") and ragdoll:FindFirstChild("LeftLowerLeg") then
	ragdoll.Hitboxes.LFoot.CFrame=ragdoll.LeftLowerLeg.CFrame
end
if ragdoll.Hitboxes:FindFirstChild("RFoot") and ragdoll:FindFirstChild("RightLowerLeg") then
	ragdoll.Hitboxes.RFoot.CFrame=ragdoll.RightLowerLeg.CFrame
end
if ragdoll.Hitboxes:FindFirstChild("LHand") and ragdoll:FindFirstChild("LeftHand") then
	ragdoll.Hitboxes.LHand.CFrame=ragdoll.LeftHand.CFrame
end
if ragdoll.Hitboxes:FindFirstChild("RHand") and ragdoll:FindFirstChild("RightHand") then
	ragdoll.Hitboxes.RHand.CFrame=ragdoll.RightHand.CFrame
end
if ragdoll.Hitboxes:FindFirstChild("TorsoBox") and ragdoll:FindFirstChild("UpperTorso") then
	ragdoll.Hitboxes.TorsoBox.CFrame=ragdoll.UpperTorso.CFrame
end
if ragdoll.Hitboxes:FindFirstChild("Neck") and ragdoll:FindFirstChild("Head") then
	ragdoll.Hitboxes.Neck.CFrame=ragdoll.Head.CFrame
end
end
end

ragdoll:WaitForChild("Humanoid2").Sit=true
	

ragdoll.Name=Character.Name
ragdoll.Parent=game.Workspace:WaitForChild("Debris")
	
Character=ragdoll

		if ragdoll and ragdoll:FindFirstChild("UpperTorso") and headshot==true then
			local instance=Instance.new("BodyVelocity")
			instance.Parent=ragdoll.UpperTorso
			instance.Velocity=velocity
			instance.P=2000
			instance.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
			delay(.05,function()
			instance:Destroy()
			end)
		end

	
		
--[[delay(1,function()
ragdoll.Parent=nil
ragdoll.Parent=game.Workspace.Debris
repeat wait(2) until ragdoll and ragdoll:FindFirstChild("UpperTorso").Velocity.magnitude<=0.5 or ragdoll==nil
if ragdoll then
	local shet=ragdoll:GetChildren()
	for i=1,#shet do
		if shet[i]:IsA("BasePart") then
			shet[i].Anchored=true
		end
	end
end
end)	]]	
		if game.ReplicatedStorage.Warmup.Value==true then
			delay(5,function()
				Character:Destroy()
			end)
		end
		if Character:FindFirstChild("UpperTorso") then
		delay(5,function()
			repeat wait(1) if Character and Character:FindFirstChild("UpperTorso") then else break end until Character and Character:FindFirstChild("UpperTorso") and Character.UpperTorso.Velocity.magnitude<=0.1
			local poop=Character:GetChildren()
			for i=1,#poop do
				if poop[i]:IsA("BasePart") then
					poop[i].Anchored=true
				end
			end
		end)
		if svch and game.Players:GetPlayerFromCharacter(svch) and game.Players:GetPlayerFromCharacter(svch):FindFirstChild("Status") and game.Players:GetPlayerFromCharacter(svch).Status.Team.Value=="T" and game.ReplicatedStorage.gametype.Value=="juggernaut" then
			local death=game.ReplicatedStorage.Sounds["death"]:clone()
			death.Parent=ragdoll.Head
			death:Play()
		else
			if ragdoll and ragdoll:FindFirstChild("Head") and headshot==false and playanimation==false and macy~=nil then
				local death=game.ReplicatedStorage.Sounds["Death"..math.random(1,5)]:clone()
				death.Parent=ragdoll.Head
				death:Play()
			end			
		end

		if Character and Character:FindFirstChild("Head") and playa and playa.Name==game.Players.LocalPlayer.Name then
		shat.Part.Value=Character.Head
		end
	end
	----destroy my body
	local boop=svch:GetChildren()
	for i=1,#boop do
		if boop[i]:IsA("BasePart") and boop[i].Name~="Head" or boop[i]:IsA("Accoutrement") then
			boop[i]:Destroy()
		end
	end
	---------------	
end
	
	end)
end)

local doingaction=false

fieldofview=75
sp = script.Parent:WaitForChild("GUI"):WaitForChild("Inventory")
weapons = {sp.Item1, sp.Item2, sp.Item3, sp.Item4, sp.Item5, sp.Item6, sp.Item7, sp.Item8}
positions = {weapons[1].Position, weapons[2].Position, weapons[3].Position, weapons[4].Position,weapons[5].Position,weapons[6].Position,weapons[7].Position, weapons[8].Position}
scrolling = false
LINEAR_SLOP = 0.0001
running=false 
climbing=false
jumping=false
crouchJump = false
landing=false
walking=false
rayModule = require(game:GetService("ReplicatedStorage").GravityRaycastModule)
visualizeModule = require(game:GetService("ReplicatedStorage").VisualizeModule)
bulletpertrail=0
mgn=0
actualfadg=0
script.Parent.Music.MusicKit.Value="ValveCT"


game.Workspace.Status.Preparation.Changed:connect(function(val)
	if val==true then
		if math.random(1,2)==1 then
			script.Parent.Music.MusicKit.Value="ValveCT"
		else
			script.Parent.Music.MusicKit.Value="ValveT"
		end
	end
end)

script.Parent:WaitForChild("GUI"):WaitForChild("Defusal").Changed:connect(function()
	wait()
	if script.Parent.GUI.Defusal.Visible==true then
		if doingaction==false then
			doingaction=true
--			if game.Workspace.Map.Gamemode.Value=="hostages"  then
--				chatMessage("1. I'm bringing the hostages out.",game.ReplicatedStorage.Voices:FindFirstChild(game.Workspace.Map.CeeT.Value)["defuse"])
--			else
--				chatMessage("1. I'm defusing the bomb.",game.ReplicatedStorage.Voices:FindFirstChild(game.Workspace.Map.CeeT.Value)["defuse"])
--			end
			delay(10,function()
				doingaction=false
			end)
		end
	end
end)

DecalBloodHole={"rbxassetid://329635132", "rbxassetid://329635085", "rbxassetid://329635053", "rbxassetid://329635066", "rbxassetid://164892599", "rbxassetid://311936669", "rbxassetid://311936590", "rbxassetid://311936412", "rbxassetid://311936317", "rbxassetid://311936503", "rbxassetid://311936791"}
function splatterBlood(origin,humanoid,dmg,startpos,pos)
	--[[if game.Players.LocalPlayer.LocalData.LowViolence.Value==true then
		return
	end]]


--check mass to see if object is large enough to spray blood on
if dmg>0 then
		for x = 1, math.max(1,math.floor(dmg*.03)) do
		local bloodfromwhere=CFrame.new(startpos,pos).lookVector
		local bloodRay = Ray.new(origin,(bloodfromwhere).unit * 6)
		local hitPart, hitPoint,normal = workspace:FindPartOnRayWithIgnoreList(bloodRay,{workspace.CurrentCamera,humanoid.Parent,game.Workspace.Debris,game.Workspace["Ray_Ignore"],game.Workspace.Map.Clips,game.Workspace.Map.SpawnPoints})
			if hitPart and hitPart.Transparency==0 and hitPart.CanCollide and hitPoint and not hitPart:IsA("Terrain") then
			createbullethole(hitPart,hitPoint,true)
			else
			bloodRay = Ray.new(origin,(Vector3.new(bloodfromwhere.X,bloodfromwhere.Y-6,bloodfromwhere.Z)).unit * 6)
			hitPart, hitPoint,normal = workspace:FindPartOnRayWithIgnoreList(bloodRay,{workspace.CurrentCamera,humanoid.Parent,game.Workspace.Debris,game.Workspace["Ray_Ignore"],game.Workspace.Map.Clips,game.Workspace.Map.SpawnPoints})
				if hitPart and hitPart.Transparency==0 and hitPart.CanCollide and hitPoint and not hitPart:IsA("Terrain") then
					createbullethole(hitPart,hitPoint,true)
				end							
			end
		end
end
end

local fadg=0

script.Parent:WaitForChild("GUI")
script.Parent.GUI:WaitForChild("TopRight")
script.Parent.GUI.TopRight:WaitForChild("1")
script.Parent.GUI.TopRight:WaitForChild("2")
script.Parent.GUI.TopRight:WaitForChild("3")
script.Parent.GUI.TopRight:WaitForChild("4")
script.Parent.GUI.TopRight:WaitForChild("5")
script.Parent.GUI.TopRight:WaitForChild("6")
script.Parent.GUI.TopRight:WaitForChild("7")
script.Parent.GUI.TopRight:WaitForChild("8")
script.Parent.GUI.TopRight:WaitForChild("9")
script.Parent.GUI.TopRight:WaitForChild("10")





function GamepadVibrate(Motor, Intensity, Length)
	if Motor == "Large" then
		game:GetService("HapticService"):SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, Intensity)
		wait(Length)
		game:GetService("HapticService"):SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
	elseif Motor == "Small" then
		game:GetService("HapticService"):SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, Intensity)
		wait(Length)
		game:GetService("HapticService"):SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
	end
end

local gui = script.Parent.GUI
function FixKillFeed()
	local invisible=11
	for i = 10, 1,  -1 do
		if gui:WaitForChild("TopRight"):FindFirstChild(tostring(i)) and gui:WaitForChild("TopRight")[tostring(i)]:FindFirstChild("Pic") and gui:WaitForChild("TopRight")[tostring(i)]:FindFirstChild("Victim") and gui:WaitForChild("TopRight")[tostring(i)]:FindFirstChild("Killer") and game.Workspace.KillFeed[tostring(i)]:findFirstChild("Active").Value and (game.Workspace.DistributedTime.Value-game.Workspace.KillFeed[tostring(i)]["time"].Value)<10 then
			gui:WaitForChild("TopRight")[tostring(i)].Killer.Text = game.Workspace.KillFeed[tostring(i)]:findFirstChild("Killer").Value
			
			gui:WaitForChild("TopRight")[tostring(i)].Killer.TextColor3 = game.Workspace.KillFeed[tostring(i)]:findFirstChild("Killer"):findFirstChild("TeamColor").Value
			gui:WaitForChild("TopRight")[tostring(i)].Victim.Text = game.Workspace.KillFeed[tostring(i)]:findFirstChild("Victim").Value
			gui:WaitForChild("TopRight")[tostring(i)].Victim.TextColor3 = game.Workspace.KillFeed[tostring(i)]:findFirstChild("Victim"):findFirstChild("TeamColor").Value
			gui:WaitForChild("TopRight")[tostring(i)].Pic.Image = game.Workspace.KillFeed[tostring(i)]:findFirstChild("Weapon").Value
			if game.Workspace.KillFeed[tostring(i)]:findFirstChild("Assist").Value==game.Players.LocalPlayer.Name or gui:WaitForChild("TopRight")[tostring(i)].Victim.Text==game.Players.LocalPlayer.Name or gui:WaitForChild("TopRight")[tostring(i)].Killer.Text==game.Players.LocalPlayer.Name then
				gui:WaitForChild("TopRight")[tostring(i)].Outline.Visible = true
			else
				gui:WaitForChild("TopRight")[tostring(i)].Outline.Visible = false
			end
			if game.Workspace.KillFeed[tostring(i)]:findFirstChild("Assist").Value~="" then
				gui:WaitForChild("TopRight")[tostring(i)].Killer.Text = gui:WaitForChild("TopRight")[tostring(i)].Killer.Text.." + "..game.Workspace.KillFeed[tostring(i)]:findFirstChild("Assist").Value
			end
			gui:WaitForChild("TopRight")[tostring(i)].Pic.Headshot.Visible=false
			gui:WaitForChild("TopRight")[tostring(i)].Pic.Wallbang.Visible=false
			gui:WaitForChild("TopRight")[tostring(i)].BackgroundColor3=Color3.new(227/255,227/255,227/255)
			local offset=0
			if game.Workspace.KillFeed[tostring(i)]:findFirstChild("Weapon").Wallbang.Value=="true" then
				gui:WaitForChild("TopRight")[tostring(i)].Pic.Wallbang.Visible=true
				gui:WaitForChild("TopRight")[tostring(i)].Pic.Wallbang.Headshot.Visible=false
				offset=offset+55
				if game.Workspace.KillFeed[tostring(i)]:findFirstChild("Weapon").Headshot.Value=="true" then
					offset=offset+55
					gui:WaitForChild("TopRight")[tostring(i)].Pic.Wallbang.Headshot.Visible=true
				end				
			else
				if game.Workspace.KillFeed[tostring(i)]:findFirstChild("Weapon").Headshot.Value=="true" then
					offset=offset+55
				   	gui:WaitForChild("TopRight")[tostring(i)].Pic.Headshot.Visible=true
				end
			end

			--resize gui
			local k = gui:WaitForChild("TopRight")[tostring(i)].Killer
			local v = gui:WaitForChild("TopRight")[tostring(i)].Victim
			local p = gui:WaitForChild("TopRight")[tostring(i)].Pic
			k.Size = UDim2.new(0,2,1,0)
			v.Size = UDim2.new(0,v.TextBounds.X+2,1,0)
			v.Position = UDim2.new(1,-(v.TextBounds.X+2),0,0)
			p.Position = UDim2.new(1,(v.Position.X.Offset-(p.Size.X.Offset+offset)),0,0)
			k.Size = UDim2.new(0,k.TextBounds.X+2,1,0)
			k.Position = UDim2.new(1,(p.Position.X.Offset-(k.Size.X.Offset*1)),0,0)
			gui:WaitForChild("TopRight")[tostring(i)].Size = UDim2.new(0,k.Size.X.Offset+v.Size.X.Offset+p.Size.X.Offset+(offset+3),0,25)
			gui:WaitForChild("TopRight")[tostring(i)].Position = UDim2.new(1,-(gui:WaitForChild("TopRight")[tostring(i)].Size.X.Offset),0,gui:WaitForChild("TopRight")[tostring(i)].Position.Y.Offset)
			gui:WaitForChild("TopRight")[tostring(i)].Visible = true
			invisible=invisible-1
			else
			gui:WaitForChild("TopRight")[tostring(i)].Visible = false
		end
	end
	gui.TopRight.Position=UDim2.new(1,-275,0,10-(27*invisible))
end


w=false
s=false
a=false
d=false
Character=script.Parent
lastpriority=nil
priority=nil
dochange="W"
dochange2="W"
special=false
special2=false
dink=tick()
timer=3 
alreadynot=false
function notify(tex,time)
timer=time
dink=tick()
player.PlayerGui.GUI.Notify.TextLabel.Text=tex
player.PlayerGui.GUI.Notify.Visible=true
spawn(function() if alreadynot==false then
alreadynot=true
repeat _Run.Stepped:wait() until (tick()-dink)>=timer
player.PlayerGui.GUI.Notify.Visible=false
alreadynot=false
end end)
end
function walkupdate()
if w==true and a==false and d==false then
priority="W"
end
if s==true and a==false and d==false then
priority="S"
end
if a==true and s==false and w==false then
priority="A"
end
if d==true and s==false and w==false then
priority="D"
end
if w==true and a==true then
priority="WA"
end
if w==true and d==true then
priority="WD"
end
if s==true and a==true then
priority="SA"
end
if s==true and d==true then
priority="SD"
end
if priority~=lastpriority then
dochange=priority
dochange2=priority
end
lastpriority=priority
end

local winboard=false
local eheld=false
game:GetService("UserInputService").InputBegan:connect(function(k)

	if script.Parent:FindFirstChild("GUI") and(script.Parent.GUI.Main.GlobalChat.ActiveOne.Value==true or script.Parent.GUI.Main.TeamChat.ActiveOne.Value==true) then
		return
	end
local key=k.KeyCode
if key==Enum.KeyCode.H and player.Status.Alive.Value==true and game.ReplicatedStorage.gametype.Value=="TTT" then
	game.ReplicatedStorage.Events.Flashlight:FireServer()
end
if key==Enum.KeyCode.E then
	eheld=true
end
if key==Enum.KeyCode.G and player.Character.Rage.Value>=100  then
	game.ReplicatedStorage.Events.Rage:FireServer()
	player.Character.Rage.Value=0
end
if key==Enum.KeyCode.V and winboard==true then
	script.Parent.GUI.TR.Winner.Visible=not script.Parent.GUI.TR.Winner.Visible
end
if key==Enum.KeyCode.H and player.Status.Alive.Value==false and game.Workspace.Status.CanRespawn.Value==true and script.Parent.GUI.begal.Controls2.Visible==true  then
	game.ReplicatedStorage.Events.LoadCharacter:FireServer()
end
	if key==Enum.KeyCode.W then
		w=true
	    walkupdate()
	elseif key==Enum.KeyCode.A then
		a=true
	    walkupdate()
	elseif key==Enum.KeyCode.S then
		s=true
	    walkupdate()	
	elseif key==Enum.KeyCode.D then
		d=true
	    walkupdate()	
	end
end)

game:GetService("UserInputService").InputEnded:connect(function(k)
	if script.Parent:FindFirstChild("GUI") and (script.Parent.GUI.Main.GlobalChat.ActiveOne.Value==true or script.Parent.GUI.Main.TeamChat.ActiveOne.Value==true) then
		return
	end
local key=k.KeyCode
	if key==Enum.KeyCode.W then
		w=false
	    walkupdate()
	elseif key==Enum.KeyCode.A then
		a=false
	    walkupdate()
	elseif key==Enum.KeyCode.S then
		s=false
	    walkupdate()
	elseif key==Enum.KeyCode.D then
		d=false
	    walkupdate()
	end
end)

game.ReplicatedStorage.Events.NewMapAdded.OnClientEvent:Connect(function()
	game.Workspace:WaitForChild("Map")
	if game.Workspace.Map:FindFirstChild("Detail") then
		wait(5)
		game.Workspace.Map.Detail:Destroy()
	end
end)

game.ReplicatedStorage.Smoked.OnClientEvent:Connect(function(obj, duration)
--print("Got the message")
local setting=1
if UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel2 then
	setting=2
elseif UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel3 then
	setting=3
elseif UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel4 then
	setting=4
elseif UserSettings().GameSettings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel5 then
	setting=5
end
if setting == 1 then
obj.ParticleEmitter.Rate = 310
elseif setting == 2 then
obj.ParticleEmitter.Rate = 260
elseif setting == 3 then
obj.ParticleEmitter.Rate = 220
elseif setting == 4 then
obj.ParticleEmitter.Rate = 170
elseif setting == 5 then
obj.ParticleEmitter.Rate = 135
else
end
end)


--VOICE
--script.Parent = nil so no one can SEE/ try this later.
--game.StarterGui.Client:Destroy()
local bt=6
local DecalConcreteHole = {"rbxassetid://185237853", "rbxassetid://185237879" , "rbxassetid://185237894", "rbxassetid://185237865"}
local DecalTileHole = {"rbxassetid://185238257", "rbxassetid://185238271", "rbxassetid://185238288", "rbxassetid://185238298"}
local DecalWoodHole = {"rbxassetid://185238181", "rbxassetid://185238204", "rbxassetid://185238210", "rbxassetid://185238224"}
local DecalMetalHole = {"rbxassetid://185238332", "rbxassetid://185238308", "rbxassetid://185238298", "rbxassetid://185238288"}
local DecalBloodHole={"rbxassetid://329635132", "rbxassetid://329635085", "rbxassetid://329635053", "rbxassetid://329635066", "rbxassetid://164892599", "rbxassetid://311936669", "rbxassetid://311936590", "rbxassetid://311936412", "rbxassetid://311936317", "rbxassetid://311936503", "rbxassetid://311936791"}
local ImpactSounds = {"rbxassetid://142082166", "rbxassetid://142082167", "rbxassetid://142082170", "rbxassetid://142082171"} -- C, G, M, W
local IntNum = 0
function ReturnNormal(HitPos,Obj)
	local SurfaceCF = {
		{"Back",Obj.CFrame * CFrame.new(0,0,Obj.Size.z)};
		{"Bottom",Obj.CFrame * CFrame.new(0,-Obj.Size.y,0)};
		{"Front",Obj.CFrame * CFrame.new(0,0,-Obj.Size.z)};
		{"Left",Obj.CFrame * CFrame.new(-Obj.Size.x,0,0)};
		{"Right",Obj.CFrame * CFrame.new(Obj.Size.x,0,0)};
		{"Top",Obj.CFrame * CFrame.new(0,Obj.Size.y,0)}
	}
	local ClosestDist = math.huge
	local ClosestSurface = nil
	for _,v in pairs(SurfaceCF) do
		local SurfaceDist = (HitPos - v[2].p).magnitude
		if SurfaceDist < ClosestDist then
			ClosestDist = SurfaceDist
			ClosestSurface = v
		end
	end
	return ClosestSurface[1]
end

local PicSize = 4
local CanSize = 10 --10 pixels offset, unless replacing the Picture for something made of frames, not necessary to change



function SecondaryTex(Texture,OldFace,LastPos,Dir,part,pos,lastABSS,lastABSP,darken,characterattached)
	local SizeWidth = part.Size.X
	local SizeHeight = part.Size.Y
	local Face,Val
	local Offset = -SizeWidth+((part.CFrame:toObjectSpace(CFrame.new(pos))).p.Z/(SizeWidth))
	if Dir == 1 then
		if OldFace == "Front" then
			Face,Val = "Right",0
		elseif OldFace == "Right" then
			Face,Val = "Back",2
		elseif OldFace == "Left" then
			Face,Val = "Front",5 --Bit redundant tbf
		elseif OldFace == "Back" then
			Face,Val = "Left",3
		end
	else
		if OldFace == "Front" then
			Face,Val = "Left",3
		elseif OldFace == "Right" then
			Face,Val = "Front",5
		elseif OldFace == "Left" then
			Face,Val = "Back",2
		elseif OldFace == "Back" then
			Face,Val = "Right",0
		end
	end
	if Face == "Right" or Face == "Left" then
		SizeWidth = part.Size.Z
		SizeHeight = part.Size.Y
		Offset = -SizeWidth+((part.CFrame:toObjectSpace(CFrame.new(pos))).p.X/(SizeWidth))
	end
	local surface
	local frame
	if Face == nil then
	
		return
	end
	for _,i in pairs(part:GetChildren()) do
		if i:IsA("SurfaceGui") then
			if i.Face == Enum.NormalId[Face] and surface and surface:FindFirstChild("Framey") then
				surface = i
				frame = surface.Framey

			end
		end
	end
	if surface == nil then
		
		surface = Instance.new("SurfaceGui")
		surface.ZOffset=1
		surface.LightInfluence=1
		surface.CanvasSize = Vector2.new(SizeWidth*CanSize,SizeHeight*CanSize)
		surface.Face = Val
		--surface.Parent=part
		surface.Parent = workspace.Debris
surface.Adornee=part
		frame = Instance.new("Frame")
		frame.Name = "Framey"
		frame.Size = UDim2.new(1,0,1,0)
		frame.ClipsDescendants = true
		frame.BackgroundTransparency =1
		frame.Parent=surface
		table.insert(surfaceguis,surface)
	end

		local Tex = Instance.new("ImageLabel",frame)
		Tex.Image = Texture
		Tex.Size = UDim2.new(0,PicSize,0,PicSize)
		Tex.BackgroundTransparency = 1
			if darken and darken==true then
			Tex.ImageColor3=Color3.new(0.5,0.5,0.5)
			end
			if Dir == 0 then
				Tex.Position = UDim2.new(0,Dir-(lastABSS-lastABSP),LastPos.Y.Scale,LastPos.Y.Offset)
			else
				Tex.Position = UDim2.new(1,(lastABSP),LastPos.Y.Scale,LastPos.Y.Offset)
			end
			if characterattached==false then
delay(bt,function() Tex:Destroy() end)
end
return
end








function createbullethole(part,pos,bloodsplatter)
local darken=false
local characterattached=false
		if part then
		local Hit=part
		local Texture=""
		if bloodsplatter or Hit and Hit.Parent and Hit.Parent:FindFirstChild("Humanoid2") or Hit and Hit.Parent and Hit.Parent:FindFirstChild("Humanoid") then
		PicSize = 12
		if bloodsplatter then
		PicSize=math.random(12,30)
		end
		Texture=DecalBloodHole[math.random(1,#DecalBloodHole)]
		if istenfoot then
		Texture = "rbxassetid://rbxassetid://286657419"
		end
		darken=true
		if Hit and Hit.Parent and Hit.Parent:FindFirstChild("Humanoid") then
			characterattached=true
		end
		else
		PicSize = 4
				
if Hit.Material==Enum.Material.Metal or Hit.Material==Enum.Material.CorrodedMetal or Hit.Material==Enum.Material.DiamondPlate then
	Texture = DecalMetalHole[math.random(1,4)]
elseif Hit.Material==Enum.Material.Wood or Hit.Material==Enum.Material.WoodPlanks then
	Texture = DecalWoodHole[math.random(1,4)]
else
Texture = DecalConcreteHole[math.random(1,4)]
		end		end
		
		
			if part and game.Players.LocalPlayer.Character and part:IsDescendantOf(game.Players.LocalPlayer.Character) then
	return
	end
			local SizeWidth = part.Size.X
			local SizeHeight = part.Size.Y

			
			local Face = ReturnNormal(pos,part)
			local Val=Face
			if Face == nil then
			
				return
			end
			if Face == "Top" or Face == "Bottom" then
				SizeWidth = part.Size.Z
				SizeHeight = part.Size.X
			elseif Face == "Right" or Face == "Left" then
				SizeWidth = part.Size.Z
				SizeHeight = part.Size.Y
			end
			local surface
			local frame
				for _,i in pairs(part:GetChildren()) do
					if i:IsA("SurfaceGui") then
						if i.Face == Enum.NormalId[Face] and surface and surface:FindFirstChild("Framey") then
							surface = i
							frame = surface.Framey
						end
					end
				end
			if surface == nil then
				surface = Instance.new("SurfaceGui")
				surface.Name = "Bullet"
				surface.ZOffset=1
				surface.LightInfluence=1
				surface.CanvasSize = Vector2.new(SizeWidth*CanSize,SizeHeight*CanSize)
				surface.Face = Val
				--surface.Parent=part
				surface.Parent = workspace.Debris
				game:GetService("Debris"):AddItem(surface,15)
				surface.Adornee=part
				frame = Instance.new("Frame")
				frame.Name = "Framey"
				frame.Size = UDim2.new(1,0,1,0)
				frame.ClipsDescendants = true
				frame.BackgroundTransparency =1 
				frame.Parent=surface
				table.insert(surfaceguis,surface)
			end
			local Tex = Instance.new("ImageLabel",frame)
			Tex.Image = Texture
			Tex.Size = UDim2.new(0,PicSize,0,PicSize)
			Tex.BackgroundTransparency = 1
			if darken==true then
			Tex.ImageColor3=Color3.new(0.5,0.5,0.5)
			end
			local Size = -(part.CFrame:toObjectSpace(CFrame.new(pos))).p
			if Face == "Front" then
				Tex.Position = UDim2.new(.5+(Size.X/(SizeWidth)),-PicSize/2,.5+(Size.Y/(SizeHeight)),-PicSize/2)
			elseif Face == "Back" then
				Tex.Position = UDim2.new(.5+(-Size.X/(SizeWidth)),-PicSize/2,.5+(Size.Y/(SizeHeight)),-PicSize/2)
			elseif Face == "Right" then
				Tex.Position = UDim2.new(.5+(Size.Z/(SizeWidth)),-PicSize/2,.5+(Size.Y/(SizeHeight)),-PicSize/2)
			elseif Face == "Left" then
				Tex.Position = UDim2.new(.5+(-Size.Z/(SizeWidth)),-PicSize/2,.5+(Size.Y/(SizeHeight)),-PicSize/2)
			elseif Face == "Top" then
				Tex.Position = UDim2.new(.5+(Size.Z/(SizeWidth)),-PicSize/2,.5+(-Size.X/(SizeHeight)),-PicSize/2)
			elseif Face == "Bottom" then
				Tex.Position = UDim2.new(.5+(Size.Z/(SizeWidth)),-PicSize/2,.5+(Size.X/(SizeHeight)),-PicSize/2)
			end
			if Tex.AbsolutePosition.X>(surface.AbsoluteSize.X-PicSize) then
				SecondaryTex(Texture,Face,Tex.Position,0,part,pos,surface.AbsoluteSize.X,Tex.AbsolutePosition.X,darken,characterattached)
			elseif Tex.AbsolutePosition.X<(PicSize/2) then
				SecondaryTex(Texture,Face,Tex.Position,1,part,pos,surface.AbsoluteSize.X,Tex.AbsolutePosition.X,darken,characterattached)
			end
			if characterattached==false then
				delay(bt,function() Tex:Destroy() end)
			end
		end
	end	
		
local camera=game.Workspace.CurrentCamera
function createparticle(particle,hit,pos,lookVector,gunstats,stabbing,startpos,headshot,lq)


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
if istenfoot then
	setting = 10
end

	local v1=particle
	local v4=hit
	local v2=pos
	local v3=lookVector
	local isOnScreen=false
	if v2==nil and v4 and v4:IsA("BasePart") then
		v2=v4.Position
	end
	if v2 then
		_, isOnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(v2)
	end
	if v4 and v4.Parent then
	else
		return
	end
	if particle=="bullethole" and hit and hit.Parent and hit.Parent.Name~="Interactive" or particle=="Blood" then
		--if game.Players.LocalPlayer:FindFirstChild("LocalData") and game.Players.LocalPlayer.LocalData.NoDecals.Value==false then
			createbullethole(hit,pos)
		--end
	end
	if v1 and v2 and v3 and v4 and camera and camera:FindFirstChild("Debris") then
	if v1 == "Blood" and gunstats and gunstats:FindFirstChild("DMG") then
		if _Run:IsStudio() then
			--print("blood reg")
		end
		--if game.Players.LocalPlayer.LocalData.NoDecals.Value==false then
			if v4 and v4.Parent and v4.Parent:FindFirstChild("Humanoid") then
				if headshot then
					splatterBlood(v2,v4.Parent.Humanoid,(gunstats.DMG.Value*4),startpos,pos)
				else
					splatterBlood(v2,v4.Parent.Humanoid,(gunstats.DMG.Value),startpos,pos)
				end
			end
			if v4 and v4.Parent and v4.Parent:FindFirstChild("Humanoid2") then
				if headshot then
					splatterBlood(v2,v4.Parent.Humanoid2,(gunstats.DMG.Value*4),startpos,pos)
				else
					splatterBlood(v2,v4.Parent.Humanoid2,(gunstats.DMG.Value),startpos,pos)
				end
			end
		--end
		local parenta=v4
		local pt="Blood"
		--if game.Players.LocalPlayer.LocalData.LowViolence.Value==true or lq and lq==true then
			
		--end
		if istenfoot then
		pt = "XBBlood"
		end
		local sound=game.ReplicatedStorage.Sounds["Bullet"..math.random(1,4)]
			if game.Players:GetPlayerFromCharacter(v4.Parent) and game.Players:GetPlayerFromCharacter(v4.Parent):FindFirstChild("Kevlar") then
				if v4.Name~="RightUpperLeg" and  v4.Name~="RightLowerLeg" and v4.Name~="RightFoot" and v4.Name~="LeftUpperLeg" and  v4.Name~="LeftLowerLeg" and v4.Name~="LeftFoot" then
					sound=game.ReplicatedStorage.Sounds["Kevlar"..math.random(1,5)]
				end
			end
				if v4 and v4.Name=="Head" or v4 and v4.Name=="HeadHB" or v4 and v4.Name=="FakeHead" then
					if game.Players:GetPlayerFromCharacter(v4.Parent) and game.Players:GetPlayerFromCharacter(v4.Parent):FindFirstChild("Helmet") then
						sound=game.ReplicatedStorage.Sounds["Helmet"..math.random(1,4)]
						pt="HelmetDink"
						--if game.Players.LocalPlayer.LocalData.LowViolence.Value==true then
							pt="LowDink"
						--end
						else
						sound=game.ReplicatedStorage.Sounds["Headshot"..math.random(1,4)]
					end				
				end
				if gunstats and gunstats:FindFirstChild("Melee") and gunstats:FindFirstChild("Model") then
					if stabbing and stabbing==true then
						sound=gunstats.Model["Stab"]
					else
						sound=gunstats.Model["Hit"..math.random(1,4)]
					end
				end
				
		if setting>3 and isOnScreen then
			if _Run:IsStudio() then
				--print("particle done")
			end
			
			local pert=game.ReplicatedStorage.Particles[pt]
			--if game.Players.LocalPlayer.LocalData.LowerParticles.Value==true then
				pert=game.ReplicatedStorage.Particles.LowQuality[pt]
			--end
			local b = pert:Clone()
			b.CFrame=CFrame.new(v2,v2+(v3))
			b.Parent=camera.Debris
				local shit=b:GetChildren()
				for i=1,#shit do
					if shit[i].className=="ParticleEmitter" then
						shit[i].Enabled=false
						shit[i]:Emit(shit[i].Rate*0.1)
					end
				end
			delay(0.1,function()

			wait(2.35)
			b:Destroy()
			end)
			parenta=b
		end
		if parenta then
			if game.SoundService.Sounds.Flashbang.Enabled==false then
				local idiot=sound:clone()
				idiot.Parent=parenta
				idiot.Volume=idiot.Volume*game.SoundService.Sounds.Volume
				idiot.PlayOnRemove=true
				idiot:Destroy()
			end
		end
	else
			local sound=game.ReplicatedStorage.Sounds["Concrete"..math.random(1,4)]
			local parenta=v4

			if setting>3 and isOnScreen then
			local material="Concrete"
			if v4.Material==Enum.Material.Grass or v4.Material==Enum.Material.Fabric then
				material="Grass"
				sound=game.ReplicatedStorage.Sounds["Grass"..math.random(1,4)]
			elseif v4.Material==Enum.Material.CorrodedMetal or v4.Material==Enum.Material.DiamondPlate or v4.Material==Enum.Material.Metal then
				material="Metal"
				sound=game.ReplicatedStorage.Sounds["Metal"..math.random(1,4)]
			elseif v4.Material==Enum.Material.Brick then
				material="Dirt"
			elseif v4.Material==Enum.Material.WoodPlanks or v4.Material==Enum.Material.Wood then
				material="Wood"
				sound=game.ReplicatedStorage.Sounds["Wood"..math.random(1,5)]
			elseif v4.Material==Enum.Material.Sand then
				material="Sand"
				sound=game.ReplicatedStorage.Sounds["Sand"..math.random(1,4)]
			end
			local pert=game.ReplicatedStorage.Particles[material]
			--if game.Players.LocalPlayer.LocalData.LowerParticles.Value==true then
				pert=game.ReplicatedStorage.Particles.LowQuality[material]
			--end
 			local b = pert:Clone()
			if b:FindFirstChild("Dirt2") and b:FindFirstChild("Smoke") then
				b.Dirt2.Color=ColorSequence.new(v4.BrickColor.Color)
				b.Smoke.Color=ColorSequence.new(v4.BrickColor.Color)
			end
			b.CFrame=CFrame.new(v2,v2+(v3))
			b.Parent=camera.Debris
				local shit=b:GetChildren()
				for i=1,#shit do
					if shit[i].className=="ParticleEmitter" then
						shit[i].Enabled=false
						shit[i]:Emit(shit[i].Rate*0.1)
					end
				end
			delay(0.1,function()

			wait(2.35)
			b:Destroy()
			end)
			parenta=b
			end	
		if game.SoundService.Sounds.Flashbang.Enabled==false then
			local idiot=sound:clone()
			idiot.Parent=parenta
			idiot.PlaybackSpeed=math.random(80,120)/100
			idiot.PlayOnRemove=true
			idiot.Volume=idiot.Volume*game.SoundService.Sounds.Volume
			idiot:Destroy()	
		end
	end
	end
	if particle=="muzzle" and hit then
		--[[if hit and hit.Parent and hit.Parent.Parent and hit.Parent.Parent.Name==script.Parent.FPSpectating.Value then
		else	]]	
			if hit and hit.Parent and hit.Parent:FindFirstChild("Shoot") and hit.Parent.Parent and hit.Parent.Parent:FindFirstChild("Head") then
				if hit.Parent:FindFirstChild("Silencer2") and hit.Parent.Silencer2.Transparency==0 then
					if game.SoundService.Sounds.Flashbang.Enabled==false then
						local sound=hit.Parent.SShoot:clone()
						sound.Parent=hit.Parent.Parent.Head
						sound.PlayOnRemove=true
						sound.Volume=sound.Volume*game.SoundService.Sounds.Volume
						sound:Destroy()
					end
					--[[sound:Play()
						delay(sound.TimeLength,function()
						sound:Destroy()
						end)]]
				else
					if game.SoundService.Sounds.Flashbang.Enabled==false then
						local sound=hit.Parent.Shoot:clone()
						sound.Parent=hit.Parent.Parent.Head
						sound.PlayOnRemove=true
						sound.Volume=sound.Volume*game.SoundService.Sounds.Volume
						sound:Destroy()
					end
					--[[sound:Play()
						delay(sound.TimeLength,function()
						sound:Destroy()
						end)]]
				end
			end
			if setting>6 and isOnScreen then
				if hit and hit.Parent and hit.Parent:FindFirstChild("Silencer2") and hit.Parent.Silencer2.Transparency==0 then
					local shit=game.ReplicatedStorage.Particles.FlashS:GetChildren()
					for i=1,#shit do
						if shit[i].className=="ParticleEmitter" then
							local poop=shit[i]:clone()
							poop.Enabled=false
							
							poop.Parent=hit
							poop:Emit(poop.Rate*0.05)
							delay(0.05,function()
								poop.Enabled=false
								wait(2.35)
								poop:Destroy()
							end)
						end
					end
				else
					local shit=game.ReplicatedStorage.Particles.Flash:GetChildren()
					for i=1,#shit do
						if shit[i].className=="ParticleEmitter" then
							local poop=shit[i]:clone()
							poop.Enabled=false
							poop.Parent=hit
							poop:Emit(poop.Rate*0.05)
							delay(0.05,function()
								poop.Enabled=false
								wait(2.35)
								poop:Destroy()
							end)
						end
					end
					local muzzle5=game.ReplicatedStorage.Particles.Light:clone()
					muzzle5.Parent=hit
					muzzle5.Enabled=true
					delay(0.03,function()
						muzzle5:Destroy()
					end)	
				end
			end
		--end
	end
end



function createtrail(flash,fdirection,hitlist)
	spawn(function()

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
if setting<4 then
	return
end
		spawn(function()
			local projectile = visualizeModule.visualizePoint(Vector3.new())
			
		
			local chink=0
				local lastPos, pos, hit,normal = rayModule.shoot(flash.p, fdirection,2500,Vector3.new(0, 0, 0),hitlist,			
				
					function(posLast, pos)
						if chink>=2 then
							projectile.CFrame = CFrame.new(posLast)	
							projectile.Trail.Enabled=true			
						else
							chink=chink+1
						end
					
						return pos.y > 0
				end,3)
				projectile.Anchored=true
				delay(game.ReplicatedStorage.VisualizeModule.Trail.Lifetime,function()
					if projectile then
					projectile:Destroy()
					end
				end)			
		end)
	end)
end
game.ReplicatedStorage.Events.Trail.OnClientEvent:connect(function(flash,fdirection,hitlist)
	table.insert(hitlist,game.Workspace.CurrentCamera)
	createtrail(flash,fdirection,hitlist)
end)

local hammerunit2stud=0.0694
local damagemodifier=0
local tinsert = table.insert
fuse=tick()
mfloor = math.floor
mmax = math.max
mmin = math.min
mrandom = math.random
mrad = math.rad
Cnew = Color3.new
ssub = string.sub
local BP=nil
local object = nil
local mouseDown = false
local grabbing = false
local found = false
local selected=nil
local dist = nil
local objval = nil
local crouched=false
local equipallowed=true
local ebounce=false
local gui=script.Parent:WaitForChild("GUI")
local ammobar=gui:WaitForChild("AmmoGUI")
local hpbar=gui:WaitForChild("Vitals")
local crosshairs=gui:WaitForChild("Crosshairs")
local scope=crosshairs:WaitForChild("Scope")
local suitZoom = script.Parent:WaitForChild("GUI").TR:WaitForChild("SuitZoom")
local suitZoom2 = script.Parent:WaitForChild("GUI"):WaitForChild("SuitZoom")
local debounceScanner = true

local preparation = game.Workspace:WaitForChild("Status"):WaitForChild("Preparation")
local roundOver = game.Workspace:WaitForChild("Status"):WaitForChild("RoundOver")
local UIS = game:GetService("UserInputService")
local selectionSphere = script.Parent.SelectionSphere
local currentTarget = nil
currentTargetHealth = nil
usingStation = false


repeat _Run.Heartbeat:wait() until game.Players.LocalPlayer and game.Workspace.CurrentCamera
--Disable mouse icon
spawn(function()
game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)
end)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health,false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList,false)
game.StarterGui:SetCore("TopbarEnabled", false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)


local Bnew = BrickColor.new
local Cnew = Cnew

function PlayLocalSound(soundobj)
	if game.SoundService.Sounds.Flashbang.Enabled==false then
		local sound=soundobj:clone()
		sound.Parent=script.Parent.LocalSounds
		sound.PlayOnRemove=true
		sound.Volume=sound.Volume*game.SoundService.Sounds.Volume
		sound:Destroy()
	end
end
function gen_time(secs)
	local t = {}
	local st = {}
	t[1] = mfloor(secs/3600)
	t[2] = mfloor((secs-(t[1]*3600))/60)
	t[3] = secs-(t[1]*3600)-(t[2]*60)
	for i = 1,3 do
		st[i] = ""
		if t[i] < 10 and i==3 then
			st[i] = "0"
		end
		st[i] = st[i] .. t[i]
	end 
	if t[1] <=  0 then
		return st[2] .. ":" .. st[3]
	else
		return st[1] .. ":" .. st[2] .. ":" .. st[3]
	end
end
function gen_time2(secs)
	local t = {}
	local st = {}
	t[1] = mfloor(secs/3600)
	t[2] = mfloor((secs-(t[1]*3600))/60)
	t[3] = secs-(t[1]*3600)-(t[2]*60)
	for i = 1,3 do
		st[i] = ""
		if t[i] < 10 then
			st[i] = "0"
		end
		st[i] = st[i] .. t[i]
	end 
	if t[1] <=  0 then
		return st[2] .. ":" .. st[3]
	else
		return st[1] .. ":" .. st[2] .. ":" .. st[3]
	end
end
local ads=false
local crouchanim=nil
local crouchwalkanim=nil
shiftwalkanim=nil
local startcrouchanim=nil
local enabled5=false
local died=false
local idle=nil
aidle=nil
local fire=nil
local fire2=nil
local staba=nil
local reload=nil
local reloading=false
UIS.MouseIconEnabled=false

local Character=nil
local UpperTorso=nil
local Humanoid=nil
local active=false
local primary=""
local realgun=""
local skinname=""
local secondary=""
local grenade = ""
local grenade2 = ""
local grenade3 = ""
local grenade4 = ""
local equipment=""
local equipment2=""
local equipment3=""
local melee=""
local equipped=""
local magnetostick=""
local prevTool, currentTool = 3, 2
local mouse=game.Players.LocalPlayer:GetMouse()





function grenadeallowed(WHICHGRENADELMAO)
	local flashbangs=0
	local totalgrenades=0
	local decoy=false
	local hegrenade=false
	local smoke=false
	local firegrenade=false
	------if anyone is reading this, tell me which grenade i am missing, tyyyyyyyyyyyyyyyyyy
	if grenade=="Flashbang" then
		flashbangs=flashbangs+1
		totalgrenades=totalgrenades+1
	end
	if grenade2=="Flashbang" then
		flashbangs=flashbangs+1
		totalgrenades=totalgrenades+1
	end
	if grenade3=="Flashbang" then
		flashbangs=flashbangs+1
		totalgrenades=totalgrenades+1
	end
	if grenade4=="Flashbang" then
		flashbangs=flashbangs+1
		totalgrenades=totalgrenades+1
	end
	local which="HE Grenade"
	if grenade==which or grenade2==which or grenade3==which or grenade4==which then
		hegrenade=true
		totalgrenades=totalgrenades+1
	end
	which="Decoy Grenade"
	if grenade==which or grenade2==which or grenade3==which or grenade4==which then
		decoy=true
		totalgrenades=totalgrenades+1
	end
	which="Smoke Grenade"
	if grenade==which or grenade2==which or grenade3==which or grenade4==which then
		smoke=true
		totalgrenades=totalgrenades+1
	end
	which="Incendiary Grenade"
	if grenade==which or grenade2==which or grenade3==which or grenade4==which then
		firegrenade=true
		totalgrenades=totalgrenades+1
	end
	which="Molotov"
	if grenade==which or grenade2==which or grenade3==which or grenade4==which then
		firegrenade=true
		totalgrenades=totalgrenades+1
	end	
	local isitallowed=true
	if totalgrenades>=4 and game.ReplicatedStorage.gametype.Value=="competitive" or totalgrenades>=3 and game.ReplicatedStorage.gametype.Value~="competitive" then
		isitallowed=false
	end
	if WHICHGRENADELMAO=="HE Grenade" and hegrenade==true then
		isitallowed=false
	end
	if WHICHGRENADELMAO=="Flashbang" and flashbangs>=2 then
		isitallowed=false
	end
	if (WHICHGRENADELMAO=="Molotov" or WHICHGRENADELMAO=="Incendiary Grenade") and firegrenade==true then
		isitallowed=false
	end
	if WHICHGRENADELMAO=="Smoke Grenade" and smoke==true then
		isitallowed=false
	end
	if WHICHGRENADELMAO=="Decoy Grenade" and decoy==true then
		isitallowed=false
	end
	return isitallowed
end
local Camera=game.Workspace.CurrentCamera
script.Blur:clone().Parent=Camera 
script.ColorCorrection:clone().Parent=Camera
local status = Player:WaitForChild("Status")
local alive = status:WaitForChild("Alive")

if Camera:FindFirstChild("Debris") then
Camera.Debris:Destroy()
end
local niga=Instance.new("Folder")
niga.Parent=Camera
niga.Name="Debris"
if Camera:FindFirstChild("GUI") then
Camera.GUI:Destroy()
end

doublezoom=false

local debris=Instance.new("Folder")
debris.Parent=Camera
debris.Name="GUI"
function updateads()
	game.ReplicatedStorage.Events.AdjustADS:FireServer(ads,doublezoom)
	if ads==true then
		
		if Character:FindFirstChild("AIMING")==nil then
		local int=Instance.new("IntValue")
		int.Parent=Character
		int.Name="AIMING"
		Player.PlayerGui["In"..math.random(1,6)]:Play()
		end
		if Character:FindFirstChild("ScopeCooldown") then
		Character.ScopeCooldown:Destroy()
		end
		local dent=Instance.new("IntValue")
		dent.Parent=Character
		dent.Name="ScopeCooldown"
		delay(.2,function()
		if dent then
		dent:Destroy()
		end
		end)
		if doublezoom==true then
			spawn(function()
			if gun~="none" and gun and gun.Name=="AWP" then
			repeat _Run.Heartbeat:wait() if ads==false then return end Camera.FieldOfView=mmax(7.8*(fieldofview/70),Camera.FieldOfView-(Camera.FieldOfView/3)) until mfloor(Camera.FieldOfView)<=7.8*(fieldofview/70)
			else
			repeat _Run.Heartbeat:wait() if ads==false then return end Camera.FieldOfView=mmax(11.7*(fieldofview/70),Camera.FieldOfView-(Camera.FieldOfView/3)) until mfloor(Camera.FieldOfView)<=11.7*(fieldofview/70)
			end
			end)
		else
			spawn(function()
			repeat _Run.Heartbeat:wait() if ads==false then return end Camera.FieldOfView=mmax(31.2*(fieldofview/70),Camera.FieldOfView-(Camera.FieldOfView/3)) until mfloor(Camera.FieldOfView)<=31.2*(fieldofview/70)
			end)
		end
		if gun~="none" and gun and gun:FindFirstChild("Scoped") and gun:FindFirstChild("RifleThing")==nil then
		local visible=true
		script.Parent.GUI.Crosshairs.Crosshair.Visible=not visible
		script.Parent.GUI.Crosshairs.Scope.Visible=visible
		script.Parent.GUI.Crosshairs.Frame1.Visible=visible
		script.Parent.GUI.Crosshairs.Frame2.Visible=visible
		script.Parent.GUI.Crosshairs.Frame3.Visible=visible
		script.Parent.GUI.Crosshairs.Frame4.Visible=visible
		end
	elseif ads==false then
		doublezoom=false
		if Character:FindFirstChild("ScopeCooldown") then
		Character.ScopeCooldown:Destroy()
		end
			spawn(function()
			repeat _Run.Heartbeat:wait() if ads==true then return end Camera.FieldOfView=mmin(fieldofview,Camera.FieldOfView+(Camera.FieldOfView/3)) until Camera.FieldOfView>=fieldofview
			end)
			if Character and Character:FindFirstChild("AIMING") then
			Character.AIMING:Destroy()
			Player.PlayerGui.Sounds["Out"..math.random(1,5)]:Play()
			end
		local visible=false
		script.Parent.GUI.Crosshairs.Crosshair.Visible=not visible
		script.Parent.GUI.Crosshairs.Scope.Visible=visible
		script.Parent.GUI.Crosshairs.Frame1.Visible=visible
		script.Parent.GUI.Crosshairs.Frame2.Visible=visible
		script.Parent.GUI.Crosshairs.Frame3.Visible=visible
		script.Parent.GUI.Crosshairs.Frame4.Visible=visible
	end
end
equip=nil
inspectani=nil
idleani=nil
fireani=nil
pullani=nil
fanani=nil
adsfireani=nil
stabani=nil
fire2ani=nil
fire3ani=nil
equipani=nil
reloadani=nil
reload1ani=nil
reload2ani=nil
reload1=nil
reload2=nil
applyani=nil
removeani=nil
local cf=Camera.CoordinateFrame
local Aimed_GripCF
ammocount=0
ammocount2=0
ammocount3=0
ammocount4=0
local primarystored=0
local equipmentstored=0
local secondarystored=0
local equipment2stored=0
function autoreload()
if equipped=="primary" and ammocount<=0 then
reloadwep()
end
if equipped=="secondary" and ammocount2<=0 then
reloadwep()
end
end
function countammo()
if Humanoid then
if game.ReplicatedStorage.gametype.Value=="TTT" then
	script.Parent.GUI.TR.BL.AmmoBar.Visible=false
	local ammoGUI=script.Parent.GUI.TR.BL.AmmoBar
	if equipped=="primary" or equipped=="secondary" then
		local ammo=0
		local storedammo=0
		if equipped=="primary" then
			ammo=ammocount
			storedammo=primarystored
		elseif equipped=="secondary" then
			ammo=ammocount2
			storedammo=secondarystored
		end
		if ammo<=0 then
			ammoGUI:WaitForChild("Bar").Visible=false
		else
			ammoGUI:WaitForChild("Bar").Visible=true
			ammoGUI:WaitForChild("Bar").Size= UDim2.new((ammo/gun.Ammo.Value), 0, 1, 0)
		end
		if ammo<10 then
			ammo="0"..tostring(ammo)
		end
		if storedammo<10 then
			storedammo="0"..tostring(storedammo)
		end
		ammoGUI:WaitForChild("WhiteText").Text = ammo.." + "..storedammo
		ammoGUI:WaitForChild("WhiteText"):WaitForChild("Outline").Text=ammoGUI:WaitForChild("WhiteText").Text
		ammoGUI.Visible=true
	end
	return
else
end
if equipped=="primary" or equipped=="secondary" or equipped=="melee" and Player.Status.Team.Value=="T" and game.ReplicatedStorage.gametype.Value=="juggernaut" then
if gun~="none" and gun and gun:FindFirstChild("Equipment")==nil and gun:FindFirstChild("Equipment2")==nil and gun:FindFirstChild("Melee")==nil or equipped=="melee" and Player.Status.Team.Value=="T" and game.ReplicatedStorage.gametype.Value=="juggernaut" then
ammobar.Visible=true
if equipped=="secondary" and ammocount2<=math.floor(gun.Ammo.Value*0.2)+1 or equipped=="primary" and ammocount<=math.floor(gun.Ammo.Value*0.2)+1 then
ammobar.AmmoClip.TextColor3=Color3.new(212/255,0,0)
else
ammobar.AmmoClip.TextColor3=Color3.new(1,1,212/255)
end
if equipped=="primary" then
ammobar.AmmoClip.Text=ammocount
ammobar.AmmoReserve.Text=primarystored
elseif equipped=="secondary" then
ammobar.AmmoClip.Text=ammocount2
ammobar.AmmoReserve.Text=secondarystored
end
if equipped=="melee" and Player.Status.Team.Value=="T" and game.ReplicatedStorage.gametype.Value=="juggernaut" then
	ammobar.AmmoClip.Text=""
	ammobar.AmmoReserve.Text=""
	ammobar.Slash.Visible=false
else
	ammobar.Slash.Visible=true
end
else
ammobar.Visible=false
end
else
ammobar.Visible=false
end
end
end
local penetrationpower=0*0.01
local maxpartpenetration=4

local SpreadModifier=0
local patterns={}
local nums=1
local xvary=0
local number=1
local recoveryadd=0
function autoequip()
	local doneit=false
	local dontdoit=false
	local lil_WEEZYLOLGOTTEM = nil
	for i=1,8 do
		weapons[i].Weapon.ImageTransparency=0.8
		weapons[i].bk.Visible=false
	end
	if realgun~="" then
		gun=game.ReplicatedStorage.Weapons[realgun]
		equipped="primary"
		lil_WEEZYLOLGOTTEM = primaryowner
		doneit=true
		weapons[1].Weapon.ImageTransparency=0
	end
	if secondary~="" and doneit==false then
		gun=game.ReplicatedStorage.Weapons[secondary]
		equipped="secondary"
		lil_WEEZYLOLGOTTEM = secondaryowner
		doneit=true
		weapons[2].Weapon.ImageTransparency=0
	end
	if melee~="" and doneit==false then
		gun=game.ReplicatedStorage.Weapons[melee]
		equipped="melee"
		doneit=true
		weapons[3].Weapon.ImageTransparency=0
	end


	if doneit==true and dontdoit==false then
		spawn(function()
			if lil_WEEZYLOLGOTTEM ~= nil then
				usethatgun(lil_WEEZYLOLGOTTEM)
			else
				usethatgun()
			end
		end)
		
	end
end

local plantedat=""

function updatesilencer()
	if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2") or Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2") then
		if equipped=="secondary" and special2==true or equipped=="primary" and  special==true then
			if Camera and Camera.Arms:FindFirstChild("Silencer2") then
				Camera.Arms.Silencer2.Transparency=1
			else
				Camera.Arms.Silencer2.Transparency=1
			end
			game.ReplicatedStorage.Events.RemoveSilencer:FireServer(gun.Model.Shoot.SoundId)
		else
			if Camera and Camera.Arms:FindFirstChild("Silencer2") then
				Camera.Arms.Silencer2.Transparency=0
			else
				Camera.Arms.Silencer2.Transparency=0
			end
			game.ReplicatedStorage.Events.ApplySilencer:FireServer(gun.Model.Shoot.SoundId)
		end
	end
end
local bp
primaryowner = nil
secondaryowner = nil

function resetaccuracy()
	if gun and gun.Name=="R8" or gun and gun.Name=="DesertEagle" or gun and gun.Name=="CZ" then
		csaccuracy=0.9
	elseif gun and gun.Name=="DualBerettas" or gun and gun.Name=="Tec9" then
		csaccuracy=0.88
	elseif gun and gun.Name=="FiveSeven" then
		csaccuracy=0.92
	elseif gun and gun.Name=="Glock" or gun and gun.Name=="P2000" then
		csaccuracy=0.9
	elseif gun and gun.Name=="USP" then
		csaccuracy=0.92
	elseif gun and gun.Name=="P250" then
		csaccuracy=0.9
	else
		csaccuracy=0
	end
	nums=1
	recoveryadd=0
	csviewpunch=CFrame.new()
	csdirection=2
	px=0
	py=0
	pz=0
	rec=0
	rec2=0
	shotsfired=0
	SpreadModifier=0
end

function usethatgun(owner)
	--[[if owner then
		print("Attempting to equip " .. owner.Name .. "'s weapon")
	else
		print("This weapon has no owner")
	end]]
	
	pulling=false
	local equiplol=Player.PlayerGui.Drawing:GetChildren()
	for i=1,#equiplol do
		if equiplol[i]:IsA("Sound") then
			equiplol[i]:Stop()
		end
	end
	Player.PlayerGui.Drawing["Cloth"..math.random(1,4)]:Play()
	if equipped=="secondary" then
		Player.PlayerGui.Drawing["Pap"..math.random(1,5)]:Play()
	elseif equipped=="melee" then
		Player.PlayerGui.Drawing["Mel"..math.random(1,6)]:Play()
	elseif equipped=="grenade" or equipped=="grenade2" or equipped=="grenade3" or equipped=="grenade4" then
		Player.PlayerGui.Drawing["Gren"..math.random(1,5)]:Play()
	else
		if gun and gun~="none" then
			if gun and gun:FindFirstChild("snipo") then
				Player.PlayerGui.Drawing.Sniper:Play()
			elseif gun and gun:FindFirstChild("SMGThing") then
				Player.PlayerGui.Drawing["SMG"..math.random(1,2)]:Play()
			elseif gun and gun:FindFirstChild("Bullets") and gun.Bullets.Value>1 then
				Player.PlayerGui.Drawing.Shotgun:Play()
			else
				Player.PlayerGui.Drawing["Wap"..math.random(1,5)]:Play()
			end
		end
	end
	firevariant=false
	firevariant2=false
	if _Run:IsStudio() and game.Workspace.ThirdPerson.Value==true then
		Player.CameraMaxZoomDistance=10
	else
		Player.CameraMaxZoomDistance=0.5
	end
	Player.CameraMinZoomDistance=0.5
	if idle then
	idle:Stop()
	end
	if fire then
	fire:Stop()
	end
	if reload then
	reload:Stop()
	end
	if reload1 then
	reload1:Stop()
	end
	if reload2 then
	reload2:Stop()
	end
	if equip then
	equip:Stop()
	end
	if fire2 then
	fire2:Stop()
	end
	if fire then
	fire:Stop()
	end
	if grenade=="" and equipped=="grenade" then
	return
	end
	if grenade2=="" and equipped=="grenade2" then
	return
	end
	if grenade3=="" and equipped=="grenade3" then
	return
	end
	if grenade4=="" and equipped=="grenade4" then
	return
	end
	if equipment=="" and equipped=="equipment" then
	return
	end
	if realgun=="" and equipped=="primary" then
	return
	end
	if secondary=="" and equipped=="secondary" then
	return
	end
	if melee=="" and equipped=="melee" then
	return
	end
	if equipment2=="" and equipped=="equipment2" then
	return
	end
	if equipment3=="" and equipped=="equipment3" then
	return
	end

	if Player and Player.Character and Player.Character:FindFirstChild("UpperTorso") and Player.Character:FindFirstChild("Humanoid") then
	else
	return
	end
	if equipallowed==false then
	return
	end

if Humanoid and Humanoid.Health==0 then
return
end

DISABLED=true
if Character and Character:FindFirstChild("Gun") then
Character.Gun:Destroy()
end
if Camera:FindFirstChild("Arms") then
Camera.Arms:Destroy()
end

if Character and Character:FindFirstChild("AIMING") then
Character.AIMING:Destroy()
end
--Camera.FieldOfView=65

repst.Events.ApplyGun:FireServer(gun,owner)

if gun=="none" then
	countammo()
DISABLED=false
return
end

--print("equipping: "..gun.Name)
ads=false
updateads()
enabled5=false
if died==false then
	adsmodifier=0
local ismelee=false
if gun~="none" and gun and gun.Name==melee then
ismelee=true
end
mode="semi"





if ismelee==false then

reloadtime=gun.ReloadTime.Value
end
penetrationpower=gun.Penetration.Value*0.01

--script.Parent.Equip:FireServer(gun)

if gun~="none" and gun and gun:FindFirstChild("Auto") and gun.Auto.Value==true then
mode="automatic"
end
if gun~="none" and gun and gun:FindFirstChild("AimIdle") then
aidle=Humanoid:LoadAnimation(gun.AimIdle)
end


idle=Humanoid:LoadAnimation(gun.Idle)
if gun~="none" and gun and gun:FindFirstChild("Fire2") then
fire2=Humanoid:LoadAnimation(gun.Fire2)
end
if gun~="none" and gun and gun:FindFirstChild("Stab") then
staba=Humanoid:LoadAnimation(gun.Stab)
end
fire=Humanoid:LoadAnimation(gun.Fire)
reload=Humanoid:LoadAnimation(gun.Reload)
equip=Humanoid:LoadAnimation(gun.Equip)

idle:Play()

local gunview = gun.Name

equip:Play()
if repst.Viewmodels:FindFirstChild("v_"..gunview) then
local fake=repst.Viewmodels["v_"..gunview]:clone()
fake.Name="Arms"
	
	 if repst.Weapons:FindFirstChild(gun.Name) then
		if repst.Weapons:FindFirstChild(gun.Name):FindFirstChild("Primary") then
			owner = primaryowner
		elseif repst.Weapons:FindFirstChild(gun.Name):FindFirstChild("Secondary") then
			owner = secondaryowner
		end
	end
	if owner == nil then
		owner = player --temp
	end
	local skinfolder = player.SkinFolder
	local bps=owner.Status.Team.Value
	if bps=="Terrorist" then
		bps="T"
		
	end
	--skinfolder[bps.."Folder"]["Glove"]
	--owner = game.Players.LocalPlayer
	if owner ~= nil then
		local team = owner.SkinFolder[bps.."Folder"]
		--print(gun.Name)
		local skindataf = team:FindFirstChild(gun.Name)
		for i=1,#CurrentKnives do
			if CurrentKnives[i] == gun.Name then
				skindataf = team:FindFirstChild("Knife")
			end
		end
--		for i=1,#CurrentGloves do
--			if CurrentGloves[i] == gun.Name then
--				skindataf = team:FindFirstChild("Glove")
--			end
--		end
		if skindataf ~= nil then
			--print("Step 1")
			local skin = skindataf.Value
			
			if skin ~= "Stock" then --Don't use this yet :D
				--print("Step 2")
				
				local skindata = repst.Skins:FindFirstChild(gun.Name):FindFirstChild(skin)	
				if skindata == nil then
					skin = "Splattered" -- this is juggernaut
					skindata = repst.Skins:FindFirstChild(gun.Name):FindFirstChild(skin)	
				end
				local skindatach = skindata:GetChildren()
				for i=1, #skindatach do
					--print("Step 3")
					if skindatach[i].Name ~= "WorldModel" and fake:FindFirstChild(skindatach[i].Name) then
						if fake[skindatach[i].Name]:IsA("MeshPart") then
							fake[skindatach[i].Name].TextureID = skindatach[i].Value
						else
							fake[skindatach[i].Name]:FindFirstChild("Mesh").TextureId = skindatach[i].Value
						end
						--print("Step 4")
					--	print("replaced part")
					end
				end
			end
		end
	end

local armies="CSSArms"
local teamthing=game.Workspace.Map.Tee.Value
if Player and Player.Status.Team.Value=="CT" then
	teamthing=game.Workspace.Map.CeeT.Value
end
if repst.Viewmodels:FindFirstChild(teamthing.."Arms") then
	armies=teamthing.."Arms"
end

--skinfolder[bps.."Folder"]["Glove"]
--[[
	so you delete the existing gloves of the viewmodel
	and then clone the glove types and make its welded.part0 to the respective arm(edited)
	and apply glove textures to its mesh
--]]

local armsample=repst.Viewmodels[armies]:clone()
local newglove = nil

local glovetype = nil

--if armies == "PCArms" or armies == "ECArms" then
--	specialscale = true
--end
gloveparts = nil
if bps == "CT" then
	if CTLoadout["GloveOver"] then
		gloveparts = split(CTLoadout["Glove"][1],"_")	
		newglove = repst.Gloves[gloveparts[2]]		
	end
elseif bps == "T" then	
	if TLoadout["GloveOver"] then
		gloveparts = split(TLoadout["Glove"][1],"_")
		newglove = repst.Gloves[gloveparts[2]]				
	end
end

if newglove ~= nil then 
	local currentarm = nil 
	if armsample["Left Arm"]:FindFirstChild("Glove") then
		currentarm = armsample["Left Arm"]
		currentarm:FindFirstChild("Glove"):Destroy()		
	end
	local glovemodel = repst.Gloves.Models[gloveparts[1]].LGlove:Clone()
	glovemodel.Parent = currentarm
	glovemodel.Welded.Part0 = currentarm
	glovemodel.Mesh.TextureId = repst.Gloves[gloveparts[2]].Textures.TextureId
	if armsample["Right Arm"]:FindFirstChild("Glove") then
		currentarm = armsample["Right Arm"]
		currentarm:FindFirstChild("Glove"):Destroy()		
	end		
	local glovemodel = repst.Gloves.Models[gloveparts[1]].RGlove:Clone()
	glovemodel.Parent = currentarm
	glovemodel.Welded.Part0 = currentarm
	glovemodel.Mesh.TextureId = repst.Gloves[gloveparts[2]].Textures.TextureId	
end


--if newglove ~= nil then
--	local glove = armsample["Left Arm"]:FindFirstChild("Glove")
--	if glove then
--		glove.Mesh:Destroy()
--		local new = newglove.LMesh:Clone()	
--		if specialscale then
--			new.Scale = newglove.Special.Value
--		end	
--		new.Parent = glove
--	end
--	local glove = armsample["Right Arm"]:FindFirstChild("Glove")
--	if glove then
--		glove.Mesh:Destroy()
--		local new = newglove.RMesh:Clone()
--		if specialscale then
--			new.Scale = newglove.Special.Value
--		end	
--		new.Parent = glove
--	end
--end

local rweld=Instance.new("Motor6D")

rweld.Parent=armsample["Right Arm"]

armsample.Parent=fake
rweld.Part0=fake["Right Arm"]
rweld.Part1=armsample["Right Arm"]
--if armies=="PCArms" or armies=="ECArms" then
rweld.C0=CFrame.Angles(0,math.rad(-90),math.rad(90))
--end
if fake:FindFirstChild("Left Arm") then
local lweld=Instance.new("Motor6D")
lweld.Parent=armsample["Left Arm"]
lweld.Part0=fake["Left Arm"]
lweld.Part1=armsample["Left Arm"]
fake["Left Arm"].Transparency=1
--if armies=="PCArms" or armies=="ECArms" then
lweld.C0=CFrame.Angles(0,math.rad(-90),math.rad(90))
--end
else
armsample["Left Arm"]:Destroy()
end
			
fake["Right Arm"].Transparency=1
fake.Parent=Camera
adsoffset=CFrame.new(0,0,10)
if fake and fake:FindFirstChild("AIM") then
fake.PrimaryPart.Anchored=true
fake:SetPrimaryPartCFrame(Camera.CoordinateFrame)
local sip=fake:WaitForChild("AIM").CFrame:toObjectSpace(Camera.CoordinateFrame)
local x,y,z=sip:toEulerAnglesXYZ()
adsoffset=CFrame.new(0,0,0.5)*CFrame.new(sip.X,sip.Y,sip.Z)*CFrame.Angles(x,y,z)
--print(adsoffset)
end
if fake:FindFirstChild("inspect") then
inspectani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("inspect"))
inspectani.KeyframeReached:connect(function(KF)
	if _Run:IsStudio() then
	--print(KF)
	end
	if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild(KF) then
	PlayLocalSound(gun.Model[KF])
	end
end)
end
idleani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("idle"))
if fake and fake:FindFirstChild("stab") then
stabani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("stab"))
end
fireani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("fire"))
if fake:FindFirstChild("pull") then
	pullani=fake.Guy:LoadAnimation(fake.pull)
	fanani=fake.Guy:LoadAnimation(fake.fastfire)
end
if fake:FindFirstChild("aimfire") then
	adsfireani=fake.Guy:LoadAnimation(fake.aimfire)
else
	adsfireani=nil
end
fire2ani=nil
fire3ani=nil
if fake:FindFirstChild("fire2") then
firevariant2=true
fire2ani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("fire2"))
fire2ani.KeyframeReached:connect(function(KF)
if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild(KF) then
Character.Gun[KF]:Play()
end
end)
end
if fake:FindFirstChild("fire3") then
firevariant=true
fire3ani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("fire3"))
fire3ani.KeyframeReached:connect(function(KF)
if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild(KF) then
Character.Gun[KF]:Play()
end
end)
end
fireani.KeyframeReached:connect(function(KF)
	if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild(KF) then
	Character.Gun[KF]:Play()
	end
	
	if KF=="press1" then
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("HUD") then
		Camera.Arms.HUD.SurfaceGui.TextLabel.Text="******7"
		end
	elseif KF=="press2" then
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("HUD") then
		Camera.Arms.HUD.SurfaceGui.TextLabel.Text="*****73"
		end
	elseif KF=="press3" then
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("HUD") then
		Camera.Arms.HUD.SurfaceGui.TextLabel.Text="****735"
		end
	elseif KF=="press4" then
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("HUD") then
		Camera.Arms.HUD.SurfaceGui.TextLabel.Text="***7355"
		end
	elseif KF=="press5" then
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("HUD") then
		Camera.Arms.HUD.SurfaceGui.TextLabel.Text="**73556"
		end
	elseif KF=="press6" then
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("HUD") then
		Camera.Arms.HUD.SurfaceGui.TextLabel.Text="*735560"
		end
	elseif KF=="press7" then
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("HUD") then
		Camera.Arms.HUD.SurfaceGui.TextLabel.Text="7355608"
		end
	elseif KF == "yum" then --Halloween Planting
		Camera.Arms.yum:Play()
	elseif KF == "beep" then
		Camera.Arms.beep:Play() --Halloween Planting
	elseif KF=="plantupboy" then
		if game.Workspace.Status.EnablePlanting.Value==true then
			game.ReplicatedStorage.Events.PlantC4:FireServer(player.Character.HumanoidRootPart.CFrame*CFrame.new(0,-2.13,0)*CFrame.Angles(math.rad(90),0,math.rad(180)),plantedat)
			if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Plant") then
				Character.Gun.Plant:Play()
			end
			equipment2=""
			autoequip()
			updateInventory()
			ads=false
			updateads()
		end
	end
end)
if fake:FindFirstChild("sapply") then
applyani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("sapply"))
removeani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("sremove"))
applyani.KeyframeReached:connect(function(KF)
	if _Run:IsStudio() then
	--print(KF)
	end
if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild(KF) then
	
Character.Gun[KF]:Play()
end
if KF=="transparency0" then
	
			if Camera and Camera.Arms:FindFirstChild("Silencer2") then
				Camera.Arms.Silencer2.Transparency=0
			else
				Camera.Arms.Silencer2.Transparency=0
			end
end
if KF=="transparency1" then
			if Camera and Camera.Arms:FindFirstChild("Silencer2") then
				Camera.Arms.Silencer2.Transparency=1
			else
				Camera.Arms.Silencer2.Transparency=1
			end
end
end)
removeani.KeyframeReached:connect(function(KF)
	pcall(function()
	if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild(KF) then
	Character.Gun[KF]:Play()
	end
	if KF=="transparency0" then
		
				if Camera and Camera.Arms:FindFirstChild("Silencer2") then
					Camera.Arms.Silencer2.Transparency=0
				else
					Camera.Arms.Silencer2.Transparency=0
				end
	end
	if KF=="transparency1" then
				if Camera and Camera.Arms:FindFirstChild("Silencer2") then
					Camera.Arms.Silencer2.Transparency=1
				else
					Camera.Arms.Silencer2.Transparency=1
				end
	end
	end)
end)
end

equipani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("equip"))
equipani.KeyframeReached:connect(function(KF)
if gun~="none" and gun and gun:FindFirstChild("Model") and gun.Model:FindFirstChild(KF) then
PlayLocalSound(gun.Model[KF])
end
end)
if gun~="none" and gun and gun:FindFirstChild("Model") and gun.Model:FindFirstChild("Equip") then
	PlayLocalSound(gun.Model.Equip)
end
if gun:FindFirstChild("Melee") then
	else
if gun:FindFirstChild("PumpAction") then
reload1ani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("1reload"))
reload2ani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("2reload"))
reload1=Humanoid:LoadAnimation(gun["1Reload"])
reload2=Humanoid:LoadAnimation(gun["2Reload"])
reload2ani.KeyframeReached:connect(function(KF)
if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild(KF) then
Character.Gun[KF]:Play()
end
end)
end
reloadani=fake:WaitForChild("Guy"):LoadAnimation(fake:WaitForChild("reload"))
reload.KeyframeReached:connect(function(KF)
	if KF=="magdrop" and Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Mag") then
		game.ReplicatedStorage.Events.DropMag:FireServer(Character.Gun.Mag)
	end
end)
reloadani.KeyframeReached:connect(function(KF)
	if _Run:IsStudio() then
		--print(KF)
	end
	if KF=="lighterfire" then
		Camera.Arms.LighterF.Fire.Enabled=true
	end
	if KF=="bottlefire" then
		Camera.Arms["Rag 3"].Fire.Enabled=true
	end
	if KF=="lighterclose" then
		Camera.Arms.LighterF.Fire.Enabled=false
	end
	if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild(KF.."1") then
	Character.Gun[KF..math.random(1,5)]:Play()
	end
	if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild(KF) then
	Character.Gun[KF]:Play()
	end
	if KF=="ammorefilled" or KF=="ammofilled" or KF=="lidclose" then
		
	local ammogiven=0
	local m=0
		if equipped=="primary" then
		m=primarystored
			if ammocount>0 then
			m=m+ammocount
			end
		elseif equipped=="secondary" then
		m=secondarystored
			if ammocount2>0 then
			m=m+ammocount2
			end
		elseif equipped=="equipment" then
		m=equipmentstored
			if ammocount3>0 then
			m=m+ammocount3
			end
		elseif equipped=="equipment2" then
		m=equipment2stored
			if ammocount4>0 then
			m=m+ammocount4
			end
		end
		if equipped=="primary" then
		ammogiven=mmin(gun.Ammo.Value,m)
		primarystored=m-ammogiven
		ammocount=ammogiven
		end
		if equipped=="secondary" then
		ammogiven=mmin(gun.Ammo.Value,m)
		secondarystored=m-ammogiven
		ammocount2=ammogiven
		end
		if equipped=="equipment" then
		ammogiven=mmin(gun.Ammo.Value,m)
		equipmentstored=m-ammogiven
		ammocount3=ammogiven
		end
		if equipped=="equipment2" then
		ammogiven=mmin(gun.Ammo.Value,m)
		equipment2stored=m-ammogiven
		ammocount4=ammogiven
		end
	countammo()
	end
end)
end
if idleani and equipped~="grenade" and equipped~="grenade2" and equipped~="grenade3" and equipped~="grenade4" then
idleani:Play()
idle:Play()
else
	idle:Stop()
end
shotsfired=0
resetaccuracy()
csviewpunch=CFrame.new()
csdirection=2
px=0
py=0
pz=0
rec=0
rec2=0
nums=1
xvary=0
recoveryadd=0
SpreadModifier=0
if equipani then
equipani:Play()
end

end
DISABLED=true
countammo()
local CHOSENONE=gun
updatesilencer()
local starttime=tick() repeat if equipani then equipani:AdjustSpeed(equipani.Length/gun.EquipTime.Value) end _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=(gun.EquipTime.Value) --booshap
reloading=false
DISABLED=false
enabled5=true
autoreload()
end
end


local nags
nags = {}

local lastHealth = 100
local damagedone = 100


function changehpgui()
	if Humanoid and Humanoid.Health>0 then
		if game.ReplicatedStorage.gametype.Value=="TTT" then
			local hpbar=script.Parent.GUI.TR.BL.HPBar
			local percent=(math.floor(Humanoid.Health)/math.floor(Humanoid.MaxHealth))
			
			if percent<0.02 and percent>0 then
				percent=0.01
			end
			local health=tostring(percent*100)	
			hpbar:WaitForChild("Bar").Size = UDim2.new((tonumber(health)/100), 0, 1, 0)
			hpbar:WaitForChild("WhiteText").Text = mfloor(tonumber(health))
			hpbar:WaitForChild("WhiteText").Outline.Text = hpbar:WaitForChild("WhiteText").Text
		else
			
			local percent=(math.floor(Humanoid.Health)/math.floor(Humanoid.MaxHealth))
			
			if percent<0.02 and percent>0 then
				percent=0.01
			end
			hpbar.Health.Text=math.floor(Humanoid.Health)
			if Humanoid.Health<1 and Humanoid.Health>0 then
				hpbar.Health.Text=1
			end
			--warn(percent)
			hpbar.HealthB.Fill:TweenSize(UDim2.new(percent, 0, 1, 0), "InOut", "Quad", 0.25, true) 
			spawn(function() 
				if percent ~= 1 then
					hpbar.HealthB.BorderColor3 = Color3.new(204/255, 0, 0)	
					wait(.15)
					if percent > .30 then
						hpbar.HealthB.BorderColor3 = Color3.new(126/255, 126/255, 126/255)
					end
				end
				wait(.15)
				hpbar.HealthB.FillDMG:TweenSize(UDim2.new(percent, 0, 1, 0), "InOut", "Quad", 0.25, true)
			end)
			if percent <= .30 then
				hpbar.HealthB.Fill.BackgroundColor3 = Color3.new(225/255, 0, 0)
				hpbar.Health.TextColor3 = Color3.new(225/255, 0, 0)
			else
				hpbar.HealthB.Fill.BackgroundColor3 = Color3.new(255/255, 255/255, 212/255)
				hpbar.Health.TextColor3 = Color3.new(255/255,255/255,212/255)
				hpbar.HealthB.BorderColor3 = Color3.new(126/255, 126/255, 126/255)
			end
			gui:WaitForChild("Vitals").Visible=true
			hpbar.Visible=true
		end
	else
		gui:WaitForChild("Vitals").Visible=false
		hpbar.Visible=false
	end
end

function changearmorgui()
	if Player and Player:FindFirstChild("Kevlar") then
		
		local percent=(math.floor(Player.Kevlar.Value)/math.floor(100))
		
		if percent<0.02 and percent>0 then
			percent=0.01
		end
		hpbar.Armor.Text=tostring(percent*100)
		if Player.Kevlar.Value<1 and Player.Kevlar.Value>0 then
			hpbar.Armor.Text=1
		end
		--warn(percent)
		hpbar.ArmorB.Fill:TweenSize(UDim2.new(percent, 0, 1, 0), "InOut", "Quad", 0.25, true) 
		spawn(function() 
			if percent ~= 1 then
				hpbar.ArmorB.BorderColor3 = Color3.new(204/255, 0, 0)	
				wait(.15)
				if percent > .30 then
					hpbar.ArmorB.BorderColor3 = Color3.new(126/255, 126/255, 126/255)
				end
			end
			wait(.15)
			hpbar.ArmorB.FillDMG:TweenSize(UDim2.new(percent, 0, 1, 0), "InOut", "Quad", 0.25, true)
		end)
		if percent <= .30 then
			hpbar.ArmorB.Fill.BackgroundColor3 = Color3.new(225/255, 0, 0)
			hpbar.Armor.TextColor3 = Color3.new(225/255, 0, 0)
		else
			hpbar.ArmorB.Fill.BackgroundColor3 = Color3.new(255/255, 255/255, 212/255)
			hpbar.Armor.TextColor3 = Color3.new(255/255,255/255,212/255)
			hpbar.ArmorB.BorderColor3 = Color3.new(126/255, 126/255, 126/255)
		end
	else
		local percent=0
		hpbar.Armor.Text=tostring(percent*100)
		--warn(percent)
		hpbar.ArmorB.Fill:TweenSize(UDim2.new(percent, 0, 1, 0), "InOut", "Quad", 0.25, true) 
		spawn(function() 
			if percent ~= 1 then
				hpbar.ArmorB.BorderColor3 = Color3.new(204/255, 0, 0)	
				wait(.15)
				if percent > .30 then
					hpbar.ArmorB.BorderColor3 = Color3.new(126/255, 126/255, 126/255)
				end
			end
			wait(.15)
			hpbar.ArmorB.FillDMG:TweenSize(UDim2.new(percent, 0, 1, 0), "InOut", "Quad", 0.25, true)
		end)
		if percent <= .30 then
			hpbar.ArmorB.Fill.BackgroundColor3 = Color3.new(225/255, 0, 0)
			hpbar.Armor.TextColor3 = Color3.new(225/255, 0, 0)
		else
			hpbar.ArmorB.Fill.BackgroundColor3 = Color3.new(225/255, 225/255, 225/255)
			hpbar.Armor.TextColor3 = Color3.new(1, 1, 1)
			hpbar.ArmorB.BorderColor3 = Color3.new(126/255, 126/255, 126/255)
		end		
	end
end
Player.ChildAdded:connect(function(c)
	wait()
	if c.Name=="Kevlar" then
		changearmorgui()
		script.Parent["Kevlar"..math.random(1,2)]:Play()
		c.Changed:connect(function()
			wait()
			changearmorgui()
		end)
	end
end)


Player.ChildRemoved:connect(function(c)
	wait()
	if c.Name=="Kevlar" then
		changearmorgui()
	end
end)


bf = Instance.new("BodyForce")

game.ReplicatedStorage.Warmup.Changed:connect(function(val)
	if game.ReplicatedStorage.gametype.Value=="TTT" then
		return
	end
	delay(1/10,function()
		
	if val==true then
		if game.ReplicatedStorage.gametype.Value~="TTT" then
		ToggleTeamSelection(true)	
		end
		realgun=""
		secondary=""
		grenade=""
		grenade2=""
		grenade3=""
		grenade4=""
	else
		realgun=""
		grenade=""
		grenade2=""
		grenade3=""
		grenade4=""
		secondary=""
	special2=false
	special=false
	--[[if player.Status.Team.Value=="Terrorist" then
	secondary="FiveSeven"
	secondaryowner = game.Players.LocalPlayer
	ammocount2=game.ReplicatedStorage.Weapons[secondary].Ammo.Value
	secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value		
	end]]
	if player.Status.Team.Value=="CT" then
	secondary=CTPrimaryPistol
	secondaryowner = game.Players.LocalPlayer
	ammocount2=game.ReplicatedStorage.Weapons[secondary].Ammo.Value
	secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
	elseif player.Status.Team.Value=="T" then
	secondary="Glock"
	secondaryowner = game.Players.LocalPlayer
	ammocount2=game.ReplicatedStorage.Weapons[secondary].Ammo.Value
	secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
	end
	
	if secondary~="" then
		equipped="secondary"
		gun=game.ReplicatedStorage.Weapons[secondary]
	elseif melee~="" then
		equipped="melee"
		gun=game.ReplicatedStorage.Weapons[melee]
	end
	updateInventory()
	usethatgun()
	
	end
	end)
end)
game.ReplicatedStorage.Events.resetweapons.OnClientEvent:connect(function()
	realgun=""
	grenade=""
	grenade2=""
	grenade3=""
	grenade4=""
	special2=false
	special=false
	if player.Status.Team.Value=="CT" then
		secondary=CTPrimaryPistol
		secondaryowner = game.Players.LocalPlayer
		ammocount2=game.ReplicatedStorage.Weapons[secondary].Ammo.Value
		secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
	elseif player.Status.Team.Value=="T" then
		if game.ReplicatedStorage.gametype.Value~="juggernaut" then --melee only
			secondary="Glock"
			secondaryowner = game.Players.LocalPlayer
			ammocount2=game.ReplicatedStorage.Weapons[secondary].Ammo.Value
			secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
		else
			secondary=""
			melee="Bearded Axe"
		end
	end
end)

local spawndeb=false
function setcharacter()
script.Parent.Animate.Disabled=true
script.Parent.FlinchandIndication.Disabled=true
wait()
script.Parent.Animate.Disabled=false
script.Parent.FlinchandIndication.Disabled=false
game.Players.LocalPlayer.PlayerGui:WaitForChild("Deafen").Disabled=true
game.Players.LocalPlayer.PlayerGui:WaitForChild("Blind").Disabled=true
game.SoundService.Sounds.Flashbang.Enabled=false
game.SoundService.Sounds.Volume=1
game.SoundService.Sounds.Distortion.Enabled=false
--print("spawned")
if script.Parent:FindFirstChild("GUI") and (Player.Status.Team.Value == "T" or Player.Status.Team.Value == "CT") then
	game.Players.LocalPlayer.PlayerGui.GUI:WaitForChild("Blind").BackgroundTransparency=1

	local bp=Player.Status.Team.Value.."Spawns"
	if game.ReplicatedStorage.gametype.Value=="deathmatch" then
		bp="AllSpawns"
	end
	local nags=game.Workspace:WaitForChild("Map"):WaitForChild(bp):GetChildren()
	repeat wait() until Player and Player.Character and Player.Character.PrimaryPart
	if game.Workspace:FindFirstChild("Map") and Player and Player.Character then
		if #nags > 0  then
			Player.Character:SetPrimaryPartCFrame(nags[math.random(1,#nags)].CFrame*CFrame.new(0,4,0))
		end
	end
end
climbing=false
spawndeb=false
game.Players.LocalPlayer.PlayerGui.Sounds:WaitForChild("Ringing"):Stop()
game.Players.LocalPlayer.PlayerGui:WaitForChild("Deafen").Disabled=true
game.Players.LocalPlayer.PlayerGui:WaitForChild("Blind").Disabled=true
secondgun=false
selectedteam = Colors[Team.Value]
if Team.Value~="CT" then
selectedteam=Colors["T"]
end
Back()
Back()
	if Camera:FindFirstChild("Arms") then
	Camera.Arms:Destroy()
	end
if Camera:FindFirstChild("Arms2") then
Camera.Arms2:Destroy()
end
game.ReplicatedStorage.Events.blap.OnClientEvent:connect(function()
	if Camera:FindFirstChild("Arms2") then
		Camera.Arms2:Destroy()
	end
end)
--gui.HealthGUI.Image=gui.AmmoGUI.Image
equipallowed=false
debounceScanner = true
walking=false
prevTool = 3
currentTool = 2
equipped="none"
melee=""
equipment=""

if game.ReplicatedStorage.gametype.Value=="TTT" then --ttt is a gamemode for hetrosexual males
	realgun=""
	secondary=""
	grenade=""
	grenade2=""
	grenade3=""
	grenade4=""
end
equipment2=""
equipment3=""
magnetostick=""
ammocount=0
ammocount2=0
ammocount3=0
primarystored=0
secondarystored=0
equipmentstored=0
equipment2stored=0
ammocount4=0
gun="none"
updateInventory()

	if ads==true then
ads=false
updateads()
end
	crouched=false
	ebounce=false
BP=nil
object = nil
mouseDown = false
grabbing = false

found = false
selected=nil
dist = nil
objval = nil
lastHealth=100
damagedone=100
repeat _Run.Stepped:wait() until Player
if Player.Status.Alive.Value==false then
game.ReplicatedStorage.Events.SetCNil:FireServer()
Camera.CameraSubject=nil
Camera.CameraType="Fixed"
Player.CameraMaxZoomDistance=10
Player.CameraMinZoomDistance=10
if script.Parent:FindFirstChild("GUI") then
	Player.PlayerGui.GUI.Spectate.Visible=true
end
equipped="none"
ammobar.Visible = false
hpbar.Visible = false
gun="none"
updateInventory()
equipallowed=true
return
end
repeat _Run.Stepped:wait() until Player.Character

Character=Player.Character

Character:WaitForChild("RightFoot").Touched:connect(function(part)
	if part and part.Parent and part.Parent==game.Workspace.Debris and game.ReplicatedStorage.Weapons:FindFirstChild(part.Name) then
		if game.ReplicatedStorage.Weapons:FindFirstChild(part.Name):FindFirstChild("Equipment2") and Player.Status.Team.Value=="T"  or game.ReplicatedStorage.Weapons:FindFirstChild(part.Name):FindFirstChild("Grenade") and grenadeallowed(part.Name)==true or game.ReplicatedStorage.Weapons:FindFirstChild(part.Name):FindFirstChild("Secondary") and secondary=="" or game.ReplicatedStorage.Weapons:FindFirstChild(part.Name):FindFirstChild("Primary") and realgun=="" then
		pickup(part)
		end
	end
end)

UpperTorso=Character:WaitForChild("UpperTorso")

Humanoid=Character:WaitForChild("Humanoid")
crouchanim=Humanoid:LoadAnimation(script.Idle)
crouchwalkanim=Humanoid:LoadAnimation(script.Crouching.WWalk)
shiftwalkanim=Humanoid:LoadAnimation(script.Walking.WWalk)
Character:WaitForChild("RightUpperArm")
Character:WaitForChild("LeftUpperArm")
Camera.CameraSubject=Humanoid
Camera.CameraType="Custom"
	if _Run:IsStudio() and game.Workspace.ThirdPerson.Value==true then
		Player.CameraMaxZoomDistance=10
	else
		Player.CameraMaxZoomDistance=0.5
	end
Player.CameraMinZoomDistance=0.5
Player.PlayerGui.GUI.Spectate.Visible=false
Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
local hpbar=script.Parent.GUI.Vitals

Humanoid.HealthChanged:connect(function(health)
_Run.Heartbeat:wait()
	damagedone = lastHealth-health
	if damagedone > 0 then
	--[[	if game.Workspace.Status.Exploded.Value == false then
		spawn(function() GamepadVibrate("Large", (damagedone /200)+.1, 0.2) end)
		end]]
	end
	
	lastHealth = health
	
changehpgui()
end)
if Humanoid then
changearmorgui()
changehpgui()
end

local V3new = Vector3.new
bf.Force = V3new(0, 0, 0)

local minHeightToDamage = 17.616
local fdebounce = true
local fall = false -- do we need this variable at all?

local justFell = false

		local position = -math.huge -- not set to 0 to avoid falls under the baseplate
		local endPosition = math.huge -- these values will change
Character.Humanoid.FreeFalling:connect(function(falling) -- this event is odd
	-- Listeners have been set up, figure out if falling
	fall = falling -- this event is always connected and updating
	if fall and fdebounce then
		position = -math.huge -- not set to 0 to avoid falls under the baseplate
		endPosition = math.huge -- these values will change
		fdebounce = false -- employ basic debounce system
		-- first positions designed so change will always occur.
		while Humanoid:GetState()==Enum.HumanoidStateType.Freefall and Character and Character:FindFirstChild("UpperTorso") and game.Workspace.Status.Preparation.Value==false do
			if position < Character.UpperTorso.Position.Y then
				position = Character.UpperTorso.Position.Y
			end
			-- new if statement. not an elseif because both values change during first loop
			if endPosition > Character.UpperTorso.Position.Y then
				endPosition = Character.UpperTorso.Position.Y
			end
			local headLoc2 = game.Workspace.Terrain:WorldToCell(UpperTorso.Position)
 	local hasAnyWater2, WaterForce2, WaterDirection2 = game.Workspace.Terrain:GetWaterCell(headLoc2.x, headLoc2.y, headLoc2.z)
	if hasAnyWater2 or Humanoid:GetState() == Enum.HumanoidStateType.Swimming or climbing then
		position = -math.huge -- not set to 0 to avoid falls under the baseplate
		endPosition = math.huge -- these values will change
	end
	if Character and Character:FindFirstChild("Climbing") then
		position = -math.huge -- not set to 0 to avoid falls under the baseplate
		endPosition = math.huge -- these values will change
	end
			_Run.Stepped:wait()
		end
		local deltaY = position - endPosition
		if deltaY>=4 then
			if Player and Player.Status.Team.Value=="CT" then
			Character.Head["CTLand"..math.random(1,4)]:Play()
			else
			Character.Head["Land"..math.random(1,4)]:Play()
			end			
		end
		local shouldDamage = deltaY - minHeightToDamage
		if Character and Character:FindFirstChild("UpperTorso") then
			local ray = Ray.new(Character.UpperTorso.Position, Vector3.new(0,-5,0))
			local heet = game.Workspace:FindPartOnRayWithIgnoreList(ray,{Character, game.Workspace:WaitForChild("Debris"), game.Workspace:WaitForChild("Ray_Ignore"),game.Workspace.Map:WaitForChild("Clips"),game.Workspace.Map:WaitForChild("SpawnPoints")},true,false)
			if heet and shouldDamage > 0 and not justFell and Humanoid:GetState()~=Enum.HumanoidStateType.Swimming and Character:FindFirstChild("Climbing")==nil  then -- height fallen must exceed the min. height
				local damage = math.floor((100*(deltaY/75)))
				game.ReplicatedStorage.Events.FallDamage:FireServer(damage,Character.FallCausedBy.Value)
				justFell = true
			else
				if Character.FallCausedBy.Value~=nil then
					game.ReplicatedStorage.Events.Reset:FireServer()
				end
			end
			delay(0.1,function()
				--fallposition=-math.huge
				justFell = false
			end)
			fdebounce = true
		end
	end
end)


	nags = {}
active=false
died=false
local offStates = {"Jumping"}
local onStates = {"Running","Climbing"}




Humanoid.Died:connect(function()
climbing=false
if died==false then
suitZoom.Visible = false
suitZoom2.Visible = false
--game.ReplicatedStorage.Events.SendVoice:FireServer(game.ReplicatedStorage.Sounds["Death"..math.random(1,5)])
Back()
Back()
if game.ReplicatedStorage.gametype.Value~="deathmatch" then
local weapondropped=false
if game.Workspace.Status.Preparation.Value==false and game.ReplicatedStorage.Warmup.Value==false then  
if realgun~="" then
weapondropped=true
realgun = string.gsub(realgun, "-", "")
game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[realgun],Camera.CoordinateFrame,ammocount,primarystored,special, primaryowner, game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
end
if secondary~="" and weapondropped==false then
game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[secondary],Camera.CoordinateFrame,ammocount2,secondarystored,special2,secondaryowner, game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
end
local dropped=false
if grenade~="" then
game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade],Camera.CoordinateFrame,0,0,nil,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
dropped=true
end
if grenade2~="" and dropped==false then
game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade2],Camera.CoordinateFrame,0,0,nil,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
dropped=true
end
if grenade3~="" and dropped==false then
game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade3],Camera.CoordinateFrame,0,0,nil,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
dropped=true
end
if grenade4~="" and dropped==false then
game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade4],Camera.CoordinateFrame,0,0,nil,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
dropped=true
end
if equipment2~="" then
if game.ReplicatedStorage.Weapons:FindFirstChild(equipment2) and game.ReplicatedStorage.Weapons:FindFirstChild(equipment2):FindFirstChild("NotDroppable")==nil then
game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[equipment2],Camera.CoordinateFrame,ammocount4,equipment2stored,nil,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
end
end
end
end
if game.ReplicatedStorage.gametype.Value~="deathmatch" then
secondary=""
realgun=""
			grenade=""
			grenade2=""
			grenade3=""
			grenade4=""
equipment2=""
end
	equipped="none"
	gun="none"
	usethatgun()
local killername=nil
	if Humanoid and Humanoid:FindFirstChild("creator") and Humanoid.creator.Value and Humanoid.creator.Value:FindFirstChild("Status") then
		killername=Humanoid.creator.Value.Name
	end
	local nametag=nil
	if killername then
		if Humanoid.creator:FindFirstChild("NameTag") then
			nametag=Humanoid.creator.NameTag.Value
		end
	end
	if killername and nametag and game.Players:FindFirstChild(killername) then
		delay(1,function()
		player.PlayerGui.GUI.KillCam.Animate.Disabled=true
		player.PlayerGui.GUI.KillCam.Animate.Disabled=false
		player.PlayerGui.GUI.KillCam.KilledBy.Weapon.Text="%unknownweapon%"
		if nametag then
		player.PlayerGui.GUI.KillCam.KilledBy.Weapon.Text=GetName.getName(nametag)
		end
		player.PlayerGui.GUI.KillCam.KillerName.Text=killername.." [+0]"
		if game.Players:FindFirstChild(killername).Character and game.Players:FindFirstChild(killername).Character:FindFirstChild("Humanoid") then
			player.PlayerGui.GUI.KillCam.KillerName.Text=killername.." [+"..math.ceil(game.Players:FindFirstChild(killername).Character.Humanoid.Health).."]"
		end
		player.PlayerGui.GUI.KillCam.KillCam.Player.Image="http://www.roblox.com/thumbs/avatar.ashx?x=352&y=352&format=png&username="..killername
		-----GIVEN
		player.PlayerGui.GUI.KillCam.DMGgiven.main.Text="Damage given: 0 in 0 hits to "..killername
		if player:FindFirstChild("DamageLogs") and player.DamageLogs:FindFirstChild(killername) then
		local hitlabel=Player.DamageLogs[killername].Hits.Value
		if hitlabel==1 then
		hitlabel=hitlabel.." hit"
		else
		hitlabel=hitlabel.." hits"
		end
		player.PlayerGui.GUI.KillCam.DMGgiven.main.Text="Damage given: "..Player.DamageLogs[killername].DMG.Value.." in "..hitlabel.." to "..killername
		end
		---------TAKEN
		player.PlayerGui.GUI.KillCam.DMGtaken.main.Text="Damage taken: 0 in 0 hits from "..killername
		if game.Players:FindFirstChild(killername) and game.Players[killername]:FindFirstChild("DamageLogs") and game.Players[killername].DamageLogs:FindFirstChild(Player.Name) then
		local hitlabel=game.Players[killername].DamageLogs[Player.Name].Hits.Value
		if hitlabel==1 then
		hitlabel=hitlabel.." hit"
		else
		hitlabel=hitlabel.." hits"
		end
		local nam=game.Players[killername].DamageLogs[Player.Name].DMG.Value
		if game.ReplicatedStorage.gametype.Value=="TTT" then
			nam=nam+1
		end
		player.PlayerGui.GUI.KillCam.DMGtaken.main.Text="Damage taken: "..nam.." in "..hitlabel.." from "..killername
		end
		end)
		---------------------------------------
	end
	ammobar.Visible = false
hpbar.Visible = false
		crouched=false
			mouseDown = false
		grabbing = false
		if selected then

 selected.CanCollide=true
	end

if ads==true then
ads=false
updateads()
end
DISABLED=true
died=true
if Camera and Camera:FindFirstChild("Arms") then
Camera.Arms:Destroy()
end
if Camera:FindFirstChild("Arms2") then
Camera.Arms2:Destroy()
end
local starttime=tick()

repeat _Run.Stepped:wait() if Humanoid and Humanoid.Health>0 then player.PlayerGui.GUI.KillCam.Visible=false player.PlayerGui.GUI.KillCam.Animate.Disabled=true return end until (tick()-starttime)>=5
player.PlayerGui.GUI.KillCam.Visible=false
player.PlayerGui.GUI.KillCam.Animate.Disabled=true
if Player.Status.Alive.Value==false then
game.ReplicatedStorage.Events.SetCNil:FireServer()
Player.PlayerGui.GUI.Spectate.Visible=true
Camera.CameraSubject=nil
Camera.CameraType="Fixed"
Player.CameraMaxZoomDistance=10
Player.CameraMinZoomDistance=10
end
end

end)
Humanoid.JumpPower=32
for i=1,#onStates do
	Humanoid[onStates[i]]:connect(function (speed)
		active = (speed>1)
	end)
end
for i=1,#offStates do
	Humanoid[offStates[i]]:connect(function (speed)
		active = false
	end)
end

script.Parent:WaitForChild("GUI"):WaitForChild("Inventory").Visible=false
if secondary=="" and player.Status.Team.Value~="Terrorist" then
	special2=false
	if player.Status.Team.Value=="CT" then
	secondary=CTPrimaryPistol
	secondaryowner = game.Players.LocalPlayer
	ammocount2=game.ReplicatedStorage.Weapons[secondary].Ammo.Value
	secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
	elseif player.Status.Team.Value=="T" then
	secondary="Glock"
	secondaryowner = game.Players.LocalPlayer
	ammocount2=game.ReplicatedStorage.Weapons[secondary].Ammo.Value
	secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
	end
	equipped="secondary"
end
equipallowed=true

equipment=""
equipment2=""
equipment3=""
magnetostick=""
if Player.Status.Team.Value=="CT" then
--	if Player.SkinFolder.KnifeOver.Value == true then
--		print("User has knife under CT")
--		
--	end
	
	--print(CTLoadout["Knife"][1] .. " is the equipped knife")
	
	if CTLoadout["KnifeOver"] then		
		local parts = split(CTLoadout["Knife"][1],"_")
		melee = parts[1]		
	else
		melee="CT Knife"
	end
elseif Player.Status.Team.Value=="T" then	
	if TLoadout["KnifeOver"] then
		local parts = split(TLoadout["Knife"][1],"_")
		melee = parts[1]		
	else
		melee="T Knife"
	end
elseif Player.Status.Team.Value=="Terrorist" then
	if TLoadout["KnifeOver"] then
		local parts = split(TLoadout["Knife"][1],"_")
		melee = parts[1]		
	else
		melee="T Knife"
	end
	
end
if game.ReplicatedStorage.gametype.Value=="juggernaut" and Player.Status.Team.Value=="T" then
	secondary=""
	melee="Bearded Axe"
end
Player.CameraMaxZoomDistance=0.5
if player.Name=="DevRolve" then
	--melee="Flip Knife"
end
if secondary~="" then
	equipped="secondary"
	gun=game.ReplicatedStorage.Weapons[secondary]
else
	equipped="melee"
	gun=game.ReplicatedStorage.Weapons[melee]
end
ammocount=0
primarystored=0
if realgun~="" then
equipped="primary"
gun = game.ReplicatedStorage.Weapons[realgun]
ammocount=game.ReplicatedStorage.Weapons[realgun].Ammo.Value
primarystored=game.ReplicatedStorage.Weapons[realgun].StoredAmmo.Value
end
if secondary~="" then
ammocount2=game.ReplicatedStorage.Weapons[secondary].Ammo.Value
end
ammocount3=0
if player and player:FindFirstChild("HasC4") and game.Workspace.Map.Gamemode.Value=="defusal" then
	if repst.gametype.Value ~= "deathmatch" then 
		equipment2="C4"
		equipped="equipment2"
		gun=game.ReplicatedStorage.Weapons[equipment2]
		player.HasC4:Destroy()
	end
end
--grenade = "Smoke Grenade"
if secondary~="" then
secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
end
equipmentstored=0
equipment2stored=0
updateInventory()
spawn(function()
	for i=1,5 do
		local players=game.Players:GetPlayers()
		for i=1,#players do 		
			if players[i] and players[i].Character and players[i].Character:FindFirstChild("Humanoid") and players[i].Name~=Player.Name then		
			local shits=players[i].Character:GetChildren()
				for g=1,#shits do 
					if shits[g]:IsA("BasePart") then
						shits[g].LocalTransparencyModifier=0
					end
				end
			end
		end
		wait(1)
	end
end)
usethatgun(secondaryowner)
end
--Assign startercharacter variable



function RotCamera(RotX, RotY, SmoothRot, Duration)
		if SmoothRot then
			local Step = mmin(1.5 / mmax(Duration, 0), 90)
			local X = 0
			while _Run.Stepped:wait() do
				local NewX = X + Step
				X = (NewX > 90 and 90 or NewX)
                if Camera.CoordinateFrame.lookVector.Y>0.98 then		
					break 
				end
				local CamRot = Camera.CoordinateFrame - Camera.CoordinateFrame.p
				local CamDist = (Camera.CoordinateFrame.p - Camera.Focus.p).magnitude
				local NewCamCF = CFrame.new(Camera.Focus.p) * CamRot * CFrame.Angles(RotX / (90 / Step), RotY / (90 / Step), (RotY / (90 / Step))*2)
				Camera.CoordinateFrame = CFrame.new(NewCamCF.p, NewCamCF.p + NewCamCF.lookVector) * CFrame.new(0, 0, CamDist)
	
				if X == 90 then break end
				
			end
		else
			local CamRot = Camera.CoordinateFrame - Camera.CoordinateFrame.p
			local CamDist = (Camera.CoordinateFrame.p - Camera.Focus.p).magnitude
			local NewCamCF = CFrame.new(Camera.Focus.p) * CamRot * CFrame.Angles(RotX, RotY, RotY*2)
			Camera.CoordinateFrame = CFrame.new(NewCamCF.p, NewCamCF.p + NewCamCF.lookVector) * CFrame.new(0, 0, CamDist)
		end

end

function RAND(Min, Max, Accuracy)
	local Inverse = 1 / (Accuracy or 1)
	return (mrandom(Min * Inverse, Max * Inverse) / Inverse)
end

function KickBack(up_base, lateral_base, up_modifier, lateral_modifier, up_max, lateral_max, direction_change)
	local flKickUp
	local flKickLateral
	up_base=up_base/3
	up_modifier=up_modifier/3
	lateral_modifier=lateral_modifier/2
	lateral_base=lateral_base/2
	if shotsfired == 1 then-- This is the first round fired
		flKickUp = up_base
		flKickLateral = lateral_base
	else
		flKickUp = up_base + (shotsfired * up_modifier)
		flKickLateral = lateral_base + (shotsfired * lateral_modifier)
	end


	local x,y,z=px,py,pz
	x = math.max(-1 * up_max,x - flKickUp)
	if csdirection == -1 then
		y = math.min(y + flKickLateral,lateral_max)
	else
		y = math.max(y - flKickLateral,-1*lateral_max)
	end
	csviewpunch=CFrame.Angles(-x,-y,0)
	px=x
	py=y
	pz=0
	--[[
		Jvs: uhh I don't get this code, so they run a random int from 0 up to direction_change, 
		( which varies from 5 to 9 in the ak47 case)
		if the random craps out a 0, they make the direction negative and damp it by 1
		the actual direction in the whole source code is only used above, and it produces a different kick if it's at 1
		
		I don't know if the guy that made this was a genius or..
	]]
	local chance=shotsfired%(direction_change)
	if chance== 0 then
		csdirection= 1 - csdirection
	end
	RecoilX=math.abs(-px)
	RecoilY=-py
	--ShakeCam(csviewpunch)	
end


local Held=false

game.ReplicatedStorage.Events.RemoteEvent.OnClientEvent:connect(function(args)
	if args and args[1] == "createparticle" then
		createparticle(args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10])
	end
end)



function hitobject(Hit,Pos,normal,gunstats,stabbing)
		if Hit and Hit.Parent and Hit.Parent:FindFirstChild("Humanoid2") or Hit and Hit.Parent and Hit.Parent:FindFirstChild("Humanoid") then

		else
			if Character and Character:FindFirstChild("Head") and Hit and Pos then
			--game.ReplicatedStorage.Events.RemoteEvent:FireServer({"createparticle","Smoke",Hit,Pos,normal})
			game.ReplicatedStorage.Events.RemoteEvent:FireServer({"createparticle","bullethole",Hit,Pos})
			if createpp==false then
			createpp=true
			createparticle("Smoke",Hit,Pos,normal)
			end
			createparticle("bullethole",Hit,Pos)
			end
		end

end


function jumpscouting()
	if jumping==true and Humanoid.Parent.HumanoidRootPart.Velocity.Y<0 and not (UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.A) or UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.D)) then
		return true
	else
		return false
	end
end
game.ReplicatedStorage.Events.HatObject.OnClientEvent:connect(function(hit,position,normal,gun,stabbing,plr,startpos)
	
	local Hit=hit
	local Pos=position
	local gunstats=gun
	if startpos==nil then
		startpos=Camera.CoordinateFrame.p
	end
	if Hit and Pos then
	--[[if game.Players:GetPlayerFromCharacter(Hit.Parent) and game.Players:GetPlayerFromCharacter(Hit.Parent).Status.Team.Value==Player.Status.Team.Value then
	else]]
		local headshot=false
		if Hit.Name=="Head" or Hit.Name=="HeadHB" or Hit.Name=="FakeHead" then
			headshot=true
		end
		if player.Name==plr then

			if headshot==true and equipped~="melee" then
				if game.Players:GetPlayerFromCharacter(Hit.Parent) and game.Players:GetPlayerFromCharacter(Hit.Parent):FindFirstChild("Helmet") then
					Player.PlayerGui["HHeadshot"..math.random(1,4)]:Play()
				else
					Player.PlayerGui["Headshot"..math.random(1,4)]:Play()
				end
			end
		end
		createpp=false
		if createpp==false then
		createpp=true
		--game.ReplicatedStorage.Events.RemoteEvent:FireServer({"createparticle","Blood",Hit,Pos,normal,gunstats,stabbing,Camera.CoordinateFrame.p,headshot,true})
		createparticle("Blood",Hit,Pos,normal,gunstats,stabbing,startpos,headshot)
		end
	--end


	end

	--hitobject(hit,position,normal,gun,stabbing)
end)
	function returnlr()
		if math.random(1,2)==1 then
		return math.random(33,100)/100
		else
		return -math.random(33,100)/100
		end
	end


Player.ChildAdded:connect(function(c)
_Run.Stepped:wait()
if c.Name=="Whizz" then
	if c:FindFirstChild("sub") then
		Player.PlayerGui.Sounds["Supersonic"..math.random(1,11)]:Play()
	else
		Player.PlayerGui.Sounds["Subsonic"..math.random(1,27)]:Play()
	end
end
end)

				

FLT_EPSILON = 1e-5

function firebullet(fanfire)
--print("fire bullet") print(gun.Name, equipped)
if Character and Character:FindFirstChild("HumanoidRootPart") and Character.HumanoidRootPart:FindFirstChild("swing1") then
	if math.random(1,100)<=20 then
		Character.HumanoidRootPart["swing"..math.random(1,3)]:Play()
	end
end
coroutine.wrap(function()
if gun=="none" then
	return
end
	--print'fire bullet fired'
if equipped=="equipment2" then
	plantedat=""
	if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and jumping==false then
	local ray=Ray.new(player.Character.HumanoidRootPart.Position,Vector3.new(0,-6,0))
	local hit,pos=game.Workspace:FindPartOnRayWithWhitelist(ray,{game.Workspace.Map.SpawnPoints})
		if hit and hit.Name=="C4Plant" then
		plantedat="B"
		end
		if hit and hit.Name=="C4Plant2" then
		plantedat="A"
		end
	end
	if fireani and fireani.IsPlaying==false and plantedat~="" then
	Held=false
	if player.Character and player.Character:FindFirstChild("Gun") and player.Character.Gun:FindFirstChild("Planting") then
	player.Character.Gun.Planting:Play()
	end
		if doingaction==false then
			doingaction=true
			--chatMessage("1. I'm planting the bomb.",game.ReplicatedStorage.Voices:FindFirstChild(game.Workspace.Map.Tee.Value)["plant"])
			delay(10,function()
				doingaction=false
			end)
		end
	game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Fire")
	fireani:Play()
	fire:Play()
	end
end
if (equipped =="grenade" or equipped =="grenade2" or equipped =="grenade3" or equipped =="grenade4") then
	local CHOSENONE=gun
	if (equipped =="grenade" or equipped =="grenade2" or equipped =="grenade3" or equipped =="grenade4") and idleani and idleani.IsPlaying==false and reloadani and fire2ani and fire2ani.IsPlaying==false and fireani and fireani.IsPlaying==false  then
		if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Pin") then
			Character.Gun.Pin:Play()
		end
		if reload then
			reload:Play()
		end
		if reloadani then
			reloadani:Play()
			game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Reload")
		end
		if idleani then
			idleani:Play()
			idle:Play()
		end
		return
	end
end
local range=nil 
if gun:FindFirstChild("Range") then range=gun.Range.Value end
local firerate=nil
if gun:FindFirstChild("FireRate") then firerate=gun.FireRate.Value end
if gun:FindFirstChild("Melee") then
	range=64
	if Held2==true then
	firerate=1
	range=48
	end
end
if DISABLED==false and ammocount4>0 and equipped=="equipment2" or ammocount3>0 and equipped=="equipment" or ammocount>0 and equipped=="primary" or ammocount2>0 and equipped=="secondary" or gun~="none" and gun and gun ~= "none" and gun:FindFirstChild("Melee") then
	local CHOSENONE=gun
	createpp=false
	DISABLED=true
	if fire then
	fire:Stop()
	end
	if fire2 then
	fire2:Stop()
	end
	if inspectani then
	inspectani:Stop()
	end
	if reloadani then
	reloadani:Stop()
	end
	if reload1ani then
	reload1ani:Stop()
	end
	if reload2ani then
	reload2ani:Stop()
	end
	if equipani then
	equipani:Stop()
	end
	if fireani then
	fireani:Stop()
	end
	if fire2ani then
	fire2ani:Stop()
	end
	if fire3ani then
	fire3ani:Stop()
	end
	if stabani then
	stabani:Stop()
	end
reloading=false


-------end of custom equipment yas
	if ammocount4>0 and equipped=="equipment2" or ammocount3>0 and equipped=="equipment" or ammocount>0 and equipped=="primary" or ammocount2>0 and equipped=="secondary" or gun~="none" and gun and gun ~= "none" and gun:FindFirstChild("Melee") then



number=1
if gun~="none" and gun and gun.Model:FindFirstChild("Switch") and equipped=="secondary" and special2==true then
number=3
end
if gun~="none" and gun and gun.Model:FindFirstChild("Switch") and equipped=="primary" and special==true then
number=3
end
for i=1,number do
if ammocount4>0 and equipped=="equipment2" or ammocount3>0 and equipped=="equipment" or ammocount>0 and equipped=="primary" or ammocount2>0 and equipped=="secondary" or gun~="none" and gun and gun:FindFirstChild("Melee") then
if gun~="none" and gun and gun.className and gun.className=="Folder" and gun:FindFirstChild("Melee") then
	if Held2==true then
		game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Stab")
		if stabani then
			stabani:Play()
		end
		if staba then
		staba:Play()
		end
		else
		local choice=math.random(1,2)
			if choice==1 then
				game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Fire")
				if fireani then
				fireani:Play()
				end
				fire:Play()
			elseif choice==2 then
				game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Fire2")
				if fire2ani then
				fire2ani:Play()
				end
				if fire2 then
				fire2:Play()
				end
			end
		
	end
else
if gun and gun.Name=="DualBerettas" and secondgun==true and fire2ani then
if fire2ani then
fire2ani:Play()
end
game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Fire2")
fire2:Play()
else
local choice=1
if firevariant==true then
choice=math.random(1,3)
end
if firevariant2==true then
	choice=math.random(1,2)
	
end
if gun and gun.Name=="DualBerettas" then
	choice=1
end
if gun.Name=="AUG" or gun.Name=="SG" then
	if adsfireani then
		adsfireani:Play()
	end
else
	if fanfire==true then
		fanani:Play()
		if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("pull") then
			Character.Gun.pull:Play()
		end
	else
		if fireani and choice==1 then
		fireani:Play()
		end
		if fire2ani and choice==2 then
		fire2ani:Play()
		end
		if fire3ani and choice==3 then
		fire3ani:Play()
		end		
	end
end
game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Fire")
fire:Play()
end 
end
if equipped=="secondary" and ammocount2<=math.floor(gun.Ammo.Value*0.2)+1 or equipped=="primary" and ammocount<=math.floor(gun.Ammo.Value*0.2)+1 then
script.Parent.Sounds.Lowammo:Play()
end
	if (Camera.Focus.p - Camera.CoordinateFrame.p).magnitude <=1 and Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Flash") and camera.CameraType==Enum.CameraType.Custom then
	
	if Camera and Camera.Arms and Camera.Arms:FindFirstChild("Flash") then
		if Camera and Camera.Arms:FindFirstChild("Silencer2") and Camera.Arms.Silencer2.Transparency==0 or Camera and Camera.Arms:FindFirstChild("Silencer2") and Camera.Arms.Silencer2.Transparency==0 then
		createparticle("muzzle",Camera.Arms.FlashS)
		else
			if gun and gun.Name=="DualBerettas" and secondgun==true then
			createparticle("muzzle",Camera.Arms["2Flash"])
			else
			createparticle("muzzle",Camera.Arms.Flash)
			end
		end
	end
		if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Shoot") and Character:FindFirstChild("Head") then
			if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2") and Camera.Arms.Silencer2.Transparency==0 or  Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2") and Camera.Arms.Silencer2.Transparency==0 then
				if game.SoundService.Sounds.Flashbang.Enabled==false then
					local sound=Character.Gun.SShoot:clone()
					sound.Parent=Character.Head
					sound.PlayOnRemove=true
					sound.Volume=sound.Volume*game.SoundService.Sounds.Volume
					sound:Destroy()
				end
				--[[sound:Play()
					delay(sound.TimeLength,function()
					sound:Destroy()
					end)]]
			else
				if game.SoundService.Sounds.Flashbang.Enabled==false then
					local sound=Character.Gun.Shoot:clone()
					sound.Parent=Character.Head
					sound.PlayOnRemove=true
					sound.Volume=sound.Volume*game.SoundService.Sounds.Volume
					sound:Destroy()
				end
				--[[sound:Play()
					delay(sound.TimeLength,function()
					sound:Destroy()
					end)]]
			end
		end
	end
	if game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Gun") and game.Players.LocalPlayer.Character.Gun:FindFirstChild("Flash") then
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2") and Camera.Arms.Silencer2.Transparency==0 or Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2") and Camera.Arms.Silencer2.Transparency==0 then
		game.ReplicatedStorage.Events.RemoteEvent:FireServer({"createparticle","muzzle",game.Players.LocalPlayer.Character.Gun.FlashS,nil})
		else
			if gun and gun.Name=="DualBerettas" and secondgun==true and Player and Player.Character and Player.Character:FindFirstChild("Gun2") then
				game.ReplicatedStorage.Events.RemoteEvent:FireServer({"createparticle","muzzle",game.Players.LocalPlayer.Character.Gun2.Flash,nil})
			else
				game.ReplicatedStorage.Events.RemoteEvent:FireServer({"createparticle","muzzle",game.Players.LocalPlayer.Character.Gun.Flash,nil})
			end		
		end
    
	else
    	if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Shoot"..math.random(1,2)) then
		Character.Gun["Shoot"..math.random(1,2)]:Play()
		end
	end

if gun and gun.Name=="DualBerettas" then
	secondgun=not secondgun
end

if gun~="none" and gun and gun:FindFirstChild("Melee")==nil then


		


	if equipped=="primary" then
	ammocount=ammocount-1
	elseif equipped=="secondary" then
	ammocount2=ammocount2-1
	elseif equipped=="equipment" then
	ammocount3=ammocount3-1
	elseif equipped=="equipment2" then
	ammocount4=ammocount4-1
	end
	
	end
	if gun~="none" and gun and gun:FindFirstChild("Melee")==nil then
	countammo()
	--updateInventory()
	end
-------------------------------SHOOTING PART
if gun~="none" and gun and gun:FindFirstChild("Projectile")==nil then

if equipped=="melee" then
	local starttime=tick() repeat  _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=0.1 --before timing
end
local boola=1
if gun:FindFirstChild("Bullets") then
boola=gun.Bullets.Value
end
coroutine.wrap(function()
	if gun:FindFirstChild("Spread") and gun:FindFirstChild("FireRate") then
	else
		return
	end
for f=1,boola do
-------------
	

	shotsfired=shotsfired+1
	
	-- These modifications feed back into flSpread eventually.
	if gun.AccuracyDivisor.Value ~= -1 then
		local iShotsFired = shotsfired

		if gun and gun:FindFirstChild("AccuracyQuadratic") and gun.AccuracyQuadratic.Value==true then
			iShotsFired = iShotsFired * iShotsFired
		else
			iShotsFired = iShotsFired * iShotsFired * iShotsFired
		end
		
		csaccuracy=(( iShotsFired / gun.AccuracyDivisor.Value) + gun.AccuracyOffset.Value )
		
		if csaccuracy > gun.Spread.MaxInaccuracy.Value then
			csaccuracy=gun.Spread.MaxInaccuracy.Value
		end
	end


	local csspread=gun.Spread.Value*0.0016875
	if gun and gun:FindFirstChild("ShotgunThing") then
		csspread=csspread*60
	end
	if gun and gun.Name=="AK47" then
		if jumping==true then
			csspread= 0.04 + (0.4 * csaccuracy)
		elseif jumping==false and running==true then
			csspread= 0.04 + (0.07 * csaccuracy)
		else
			csspread= 0.0275 * csaccuracy 
		end
	elseif gun and gun.Name=="M249" then
		if jumping==true then
			csspread= 0.045 + (0.5 * csaccuracy)
		elseif jumping==false and running==true then
			csspread= 0.045 + (0.095 * csaccuracy)
		else
			csspread= 0.03 * csaccuracy 
		end
	elseif gun and gun.Name=="MAC10" then
		if jumping==true then
			csspread=0.375*csaccuracy
		else
			csspread=0.03*csaccuracy
		end
	elseif gun and gun.Name=="MP9" or gun and gun.Name=="Bizon" then
		if jumping==true then
			csspread=0.25*csaccuracy
		else
			csspread=0.03*csaccuracy
		end
	elseif gun and gun.Name=="UMP" then
		if jumping==true then
			csspread=0.24*csaccuracy
		else
			csspread=0.04*csaccuracy
		end
	elseif gun and gun.Name=="P90" then
		if jumping==true then
			csspread=0.3*csaccuracy
		elseif jumping==false and running==true then
			csspread=0.115*csaccuracy
		else
			csspread=0.045*csaccuracy
		end
	elseif gun and gun.Name=="MP7" then
		if jumping==true then
			csspread=0.2*csaccuracy
		else
			csspread=0.04*csaccuracy
		end
	elseif gun and gun.Name=="Galil" then
		if jumping==true then
			csspread= 0.04 + (0.3 * csaccuracy)
		elseif jumping==false and running==true then
			csspread= 0.04 + (0.07 * csaccuracy)
		else
			csspread= 0.0375 * csaccuracy 
		end
	elseif gun and gun.Name=="DualBerettas"  or gun and gun.Name=="Tec9" then
		if jumping==true then
			csspread= 1.3 * (1 - csaccuracy)
		elseif jumping==false and running==true then
			csspread= 0.175 * (1 - csaccuracy)
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			csspread= 0.08 * (1 - csaccuracy)
		else
			csspread= 0.1 * (1 - csaccuracy)
		end
	elseif gun and gun.Name=="P250" or gun and gun.Name=="CZ" then
		if jumping==true then
			csspread= 1.5 * (1 - csaccuracy)
		elseif jumping==false and running==true then
			csspread= 0.255 * (1 - csaccuracy)
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			csspread= 0.075 * (1 - csaccuracy)
		else
			csspread= 0.15 * (1 - csaccuracy)
		end
		if gun and gun.Name=="CZ" then
			csspread=csspread/1.5
			if csaccuracy<=0.85 then
				csspread=csspread+(0.3* (1 - csaccuracy))
			end
		end
	elseif gun and gun.Name=="Glock" or gun and gun.Name=="P2000" then
		if special2==true then
			if jumping==true then
				csspread= 1.2 * (1 - csaccuracy)
			elseif jumping==false and running==true then
				csspread= 0.185 * (1 - csaccuracy)
			elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
				csspread= 0.095 * (1 - csaccuracy)
			else
				csspread= 0.3 * (1 - csaccuracy)
			end
		else
			if jumping==true then
				csspread= 1 * (1 - csaccuracy)
			elseif jumping==false and running==true then
				csspread= 0.165 * (1 - csaccuracy)
			elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
				csspread= 0.075 * (1 - csaccuracy)
			else
				csspread= 0.1 * (1 - csaccuracy)
			end
		end
	elseif gun and gun.Name=="R8" or gun and gun.Name=="DesertEagle" then
		if jumping==true then
			csspread= 1.5 * (1 - csaccuracy)
		elseif jumping==false and running==true then
			csspread= 0.25 * (1 - csaccuracy)
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			csspread= 0.115 * (1 - csaccuracy)
		else
			csspread=0.13 * (1 - csaccuracy)
		end
		if fanfire==true then
			csspread=csspread+(240*0.0016875)
		end
	elseif gun and gun.Name=="FiveSeven" then
		if jumping==true then
			csspread= 1.5 * (1 - csaccuracy)
		elseif jumping==false and running==true then
			csspread= 0.255 * (1 - csaccuracy)
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			csspread= 0.075 * (1 - csaccuracy)
		else
			csspread=0.15 * (1 - csaccuracy)
		end
	elseif gun and gun.Name=="USP" then
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2") and Camera.Arms.Silencer2.Transparency==0 then
			if jumping==true then
				csspread= 1.3 * (1 - csaccuracy)
			elseif jumping==false and running==true then
				csspread= 0.25 * (1 - csaccuracy)
			elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
				csspread= 0.125 * (1 - csaccuracy)
			else
				csspread=0.15 * (1 - csaccuracy)
			end
		else
			if jumping==true then
				csspread= 1.2 * (1 - csaccuracy)
			elseif jumping==false and running==true then
				csspread= 0.225 * (1 - csaccuracy)
			elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
				csspread= 0.08 * (1 - csaccuracy)
			else
				csspread=0.1 * (1 - csaccuracy)
			end
		end
	elseif gun and gun.Name=="AWP" then
		if jumping==true then
			csspread= 0.85
		elseif jumping==false and running==true then
			csspread= 0.25
			if walking==true then
				csspread=0.1
			end
		else
			csspread= 0.001
			if landing==true then
				csspread=0.05
			end
			if UpperTorso.Velocity.magnitude>=3 then
				csspread=csspread+0.2
			end
			if crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
				csspread=csspread-0.001
			end
		end		

		if ads==false or Character:FindFirstChild("ScopeCooldown") or game.Players.LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.ImageTransparency>0 then
			csspread=csspread+0.35
		end
	elseif gun and gun.Name=="Scout" then
		if jumping==true and jumpscouting()==false then
			csspread= 0.2
		elseif jumping==false and running==true then
			csspread= 0.075
			if walking==true then
				csspread=0.1
			end
		else
			csspread= 0.001
			if landing==true then
				csspread=0.025
			end
			if crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
				csspread=csspread-0.001
			end
		end		
		if ads==false or Character:FindFirstChild("ScopeCooldown") then
			csspread=csspread+0.08
		end
	elseif gun and gun.Name=="G3SG1" then
		if jumping==true then
			csspread= 0.45 
		elseif jumping==false and running==true then
			csspread= 0.15
		else
			csspread= 0.005
			if crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
				csspread= csspread-0.005
			end
		end		
		if ads==false or Character:FindFirstChild("ScopeCooldown") then
			csspread=csspread+0.2
		end
	elseif gun and gun.Name=="AUG" then
		if jumping==true then
			csspread= 0.035 + 0.4 * csaccuracy
		elseif jumping==false and running==true then
			csspread= 0.035 + 0.07 * csaccuracy
		else
			csspread= 0.02 * csaccuracy 
		end
	elseif gun and gun.Name=="SG" then
		if jumping==true then
			csspread= 0.035 + 0.4 * csaccuracy
		elseif jumping==false and running==true then
			csspread= 0.035 + 0.07 * csaccuracy
		else
			csspread= 0.02 * csaccuracy 
		end
	elseif gun and (gun.Name=="M4A1" or gun.Name=="M4A4") then
		if jumping==true then
			csspread= 0.035 + 0.4 * csaccuracy
		elseif jumping==false and running==true then
			csspread= 0.035 + 0.07 * csaccuracy
		else
			csspread= 0.02 * csaccuracy 
		end
	elseif gun and (gun.Name=="Famas") then
		if jumping==true then
			csspread= 0.03 +0.3*csaccuracy
		elseif jumping==false and running==true then
			csspread= 0.03 + 0.07*csaccuracy
		else
			csspread= 0.02 * csaccuracy 
		end
	end		
	
	
	
	
	if gun and gun.Name=="G3SG1" then
		csaccuracy = 0.8 + (0.2) * (tick() - lastfire)	
	
		if (csaccuracy > 0.98) then
			csaccuracy = 0.98
		end
	end
	if gun and gun.Name=="R8" or gun and gun.Name=="DesertEagle" or gun and gun.Name=="CZ" then
		csaccuracy = csaccuracy - (0.35)*(0.4 - ( tick() - lastfire ) )
	
		if (csaccuracy > 0.9) then
			csaccuracy = 0.9
		elseif (csaccuracy < 0.1) then
			csaccuracy = 0.1
		end
	elseif gun and gun.Name=="DualBerettas"  or gun and gun.Name=="Tec9" then
		csaccuracy = csaccuracy - (0.275)*(0.325 - ( tick() - lastfire ) )
	
		if (csaccuracy > 0.88) then
			csaccuracy = 0.88
		elseif (csaccuracy < 0.55) then
			csaccuracy = 0.55
		end
	elseif gun and gun.Name=="FiveSeven" then
		csaccuracy = csaccuracy - (0.25)*(0.275 - ( tick() - lastfire ) )
	
		if (csaccuracy > 0.92) then
			csaccuracy = 0.92
		elseif (csaccuracy < 0.725) then
			csaccuracy = 0.725
		end
	elseif gun and gun.Name=="Glock" or gun and gun.Name=="P2000" then
		csaccuracy = csaccuracy - (0.275)*(0.325 - (tick()-lastfire));
	
		if (csaccuracy > 0.9) then
			csaccuracy = 0.9
		elseif (csaccuracy < 0.6) then
			csaccuracy = 0.6
		end
	elseif gun and gun.Name=="USP" then
		csaccuracy = csaccuracy - (0.275)*(0.3 - (tick()-lastfire));
	
		if (csaccuracy > 0.92) then
			csaccuracy = 0.92
		elseif (csaccuracy < 0.6) then
			csaccuracy = 0.6
		end
	elseif gun and gun.Name=="P250" then
		csaccuracy = csaccuracy - (0.3)*(0.325 - (tick()-lastfire));
	
		if (csaccuracy > 0.9) then
			csaccuracy = 0.9
		elseif (csaccuracy < 0.2) then
			csaccuracy = 0.2
		end
	end
	if _Run:IsStudio() then
		--print(csspread)
	end
	if gun.Name=="Negev" then
		if shotsfired<=16 or running==true or jumping==true or landing==true then
		else
			csspread=0.008
		end
	end
	
		csspread=csspread*20

	csspread=math.max(0,csspread)
	nums=nums+1
	if nums>#patterns then
	nums=1
	end
	if gun:FindFirstChild("Melee")==nil then
		spawn(function()
			local origshots=shotsfired
			if gun and gun~="none" and gun:FindFirstChild("Spread") and gun.Spread:FindFirstChild("RecoveryTime") then
			else
				return
			end
			local recovery=(gun.Spread.RecoveryTime.Value)
				if crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false then
				recovery=(gun.Spread.RecoveryTime.Crouched.Value)
				end
			

			local startrtime=tick()

			local lanky=SpreadModifier
				repeat _Run.Stepped:wait() 	
					if shotsfired~=origshots then
						return
					end	
				until gun~=CHOSENONE or gun~="none" and gun and gun:FindFirstChild("FireRate")==nil or gun~="none" and gun and gun:FindFirstChild("FireRate") and (tick()-startrtime)>=math.min(0.4,gun.FireRate.Value) or gun and gun:FindFirstChild("Scoped") and gun.Auto.Value==false
				startrtime=tick()
			
				repeat _Run.Stepped:wait() 	
					if shotsfired~=origshots then
						return
					end		
				local percent=(tick()-startrtime)/recovery		
				px=rec*(0.1^percent)
				py=rec2*(0.1^percent)
				--[[RecoilX=recs1*(0.1^percent)
				RecoilY=recs2*(0.1^percent)]]
				until gun~=CHOSENONE or (tick()-startrtime)>= recovery
				--print(recovery)
			nums=1
			recoveryadd=0
			csviewpunch=CFrame.new()
			csdirection=2
			px=0
			py=0
			pz=0
			rec=0
			rec2=0
			shotsfired=0
			resetaccuracy()
			SpreadModifier=0
		end)
	end



	if _Run:IsStudio() then
	--print("Spread: "..actualfadg) 
	end












	
	------
		--[[local r = math.random(0, math.floor(2 * math.pi * 100))/100
		local x = math.sin(r) * (math.random(0 , math.floor(0.5 * 100))/100)
		local y = math.cos(r) * (math.random(0 , 100)/100)]]
		local x = 0.5*returnlr()
		local y = 0.5*returnlr()
		if gun and gun:FindFirstChild("ShotgunThing") then
			x=math.random(-50,50)/1500
			y=math.random(-50,50)/1500
		end
		local veloc=(UpperTorso.Velocity.magnitude/(game.ReplicatedStorage.HUInfo[gun.Name].WalkSpeed.Value*hammerunit2stud))
		local bop=false
		if climbing==true then
			if gun and gun:FindFirstChild("ShotgunThing")==nil then
				x=x+(x*gun.Spread.Ladder.Value*0.2)
				y=y+(y*gun.Spread.Ladder.Value*0.2)
			else
				x=x+(x*gun.Spread.Ladder.Value*0.025)
				y=y+(y*gun.Spread.Ladder.Value*0.025)
			end
			bop=true
		end
		local walk=false
		local divider=1
		if bop==false and running==true and jumping==false and game.ReplicatedStorage.gametype.Value~="juggernaut"  then
			if Character.HumanoidRootPart.Velocity.magnitude<=game.ReplicatedStorage.HUInfo[gun.Name].WalkSpeed.Value*hammerunit2stud/1.8 then
				x=-math.abs(x)
				divider=2
				walk=true
			end
			if gun and gun:FindFirstChild("ShotgunThing")==nil then
				x=x+(x*gun.Spread.Move.Value*0.1*veloc/divider)
				y=y+(y*gun.Spread.Move.Value*0.1*veloc/divider)
			elseif gun and gun:FindFirstChild("RifleThing") then
				x=x+(x*gun.Spread.Move.Value*0.005*veloc/divider)
				y=y+(y*gun.Spread.Move.Value*0.005*veloc/divider)				
			else
				x=x+(x*gun.Spread.Move.Value*0.025*veloc/divider)
				y=y+(y*gun.Spread.Move.Value*0.025*veloc/divider)
			end
			bop=true
		end

		if bop==false and jumping==true then
			if gun.Name=="Scout" and jumpscouting()==false or gun.Name~="Scout" then
				if gun and gun:FindFirstChild("ShotgunThing")==nil then
					x=x+(x*gun.Spread.Jump.Value*0.2)
					y=y+(y*gun.Spread.Jump.Value*0.2)
				else
					x=x+(x*gun.Spread.Jump.Value*0.025/4)
					y=y+(y*gun.Spread.Jump.Value*0.025/4)
				end
				bop=true
			end
		end
		if bop==false and landing==true then
			if gun and gun:FindFirstChild("ShotgunThing")==nil then
				x=x+(x*gun.Spread.Land.Value*0.2)
				y=y+(y*gun.Spread.Land.Value*0.2)
			else
				x=x+(x*gun.Spread.Land.Value*0.025)
				y=y+(y*gun.Spread.Land.Value*0.025)
			end
			bop=true
		end

		if _Run:IsStudio() then
			--print(csspread)
		end
		if csspread<=0.3 and bop==false then
			csspread=0
		end
			-- "Spread, what"
		local SpreadMod = 0.75
		local pattern=CFrame.Angles(math.rad(-px*rmr*2*SpreadMod),math.rad(-py*rmr*2*SpreadMod),0)
		local ang=(Camera.CoordinateFrame*pattern*CFrame.Angles(math.rad(-x*csspread*SpreadMod),math.rad(-y*csspread*SpreadMod),0)).lookVector.unit
		local dir = ang
		
		--------------









--------------

	local Spread = CFrame.new()
		--[[
		if jumping==true or running==true or climbing==true then
			if running==true and walking==true and gun.Name~="DesertEagle" then
			Spread = CFrame.Angles((math.max(math.rad(actualfadg-5),math.rad(actualfadg*returnlr())))/(studs/(1+yrandomness)), (math.rad(actualfadg*returnlr()))/(studs/(0.5+yrandomness)), (math.rad(actualfadg*returnlr()))/(studs/(0.5+yrandomness)))
			else
			Spread = CFrame.Angles((math.rad(actualfadg*returnlr())/(studs/(2+yrandomness))), (math.rad(actualfadg*returnlr())/(studs/(1+yrandomness))), (math.rad(actualfadg*returnlr())/(studs/(1+yrandomness))))
			end
		end

		if random==true then
			Spread = CFrame.Angles(math.rad(actualfadg+(actualfadg*math.abs(yrandomness*5)))/(studs/2.2), math.rad(actualfadg*studs2)/xvariationmod, math.rad(actualfadg*studs2)/xvariationmod)
		end
		
		if gun.Name=="Negev" or gun:FindFirstChild("Melee") or gun:FindFirstChild("ShotgunThing") or gun:FindFirstChild("Scoped") and gun:FindFirstChild("RifleThing")==nil then
		Spread =  CFrame.Angles((math.rad(math.random(-actualfadg,actualfadg))/(studs/(2+yrandomness))), (math.rad(math.random(-actualfadg, actualfadg))/(studs/2+randomness)), (math.rad(math.random(-actualfadg, actualfadg))/(studs/2+randomness)))
		if actualfadg>=100 then
			Spread = CFrame.Angles((math.rad(actualfadg*returnlr())/(studs/(2+yrandomness))), (math.rad(actualfadg*returnlr())/(studs/(1+yrandomness))), (math.rad(actualfadg*returnlr())/(studs/(1+yrandomness))))
		end
		end]]
		
		
		
   local flash=nil

flash=Camera.CoordinateFrame
local hitlist={game.Workspace.Debris,Character,game.Workspace["Ray_Ignore"],Camera,game.Workspace.Map:WaitForChild("Clips"),game.Workspace.Map:WaitForChild("SpawnPoints")}

local crud=game.Players:GetPlayers()

for i=1,#crud do
if crud[i].Name~=Player.Name and crud[i].Character and crud[i].Character:FindFirstChild("UpperTorso") then
if crud[i] and crud[i].Character:FindFirstChild("HumanoidRootPart") then
tinsert(hitlist,crud[i].Character.HumanoidRootPart)
end
if crud[i] and crud[i].Character:FindFirstChild("Head") then
tinsert(hitlist,crud[i].Character.Head)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat1") then
tinsert(hitlist,crud[i].Character.Hat1)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat2") then
tinsert(hitlist,crud[i].Character.Hat2)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat3") then
tinsert(hitlist,crud[i].Character.Hat3)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat4") then
tinsert(hitlist,crud[i].Character.Hat4)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat5") then
tinsert(hitlist,crud[i].Character.Hat5)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat6") then
tinsert(hitlist,crud[i].Character.Hat6)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat7") then
tinsert(hitlist,crud[i].Character.Hat7)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat8") then
tinsert(hitlist,crud[i].Character.Hat8)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat9") then
tinsert(hitlist,crud[i].Character.Hat9)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat10") then
tinsert(hitlist,crud[i].Character.Hat10)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat11") then
tinsert(hitlist,crud[i].Character.Hat11)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat12") then
tinsert(hitlist,crud[i].Character.Hat12)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat13") then
tinsert(hitlist,crud[i].Character.Hat13)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat14") then
tinsert(hitlist,crud[i].Character.Hat14)
end
if crud[i] and crud[i].Character:FindFirstChild("Hat15") then
tinsert(hitlist,crud[i].Character.Hat15)
end
if crud[i] and crud[i].Character:FindFirstChild("DKit") then
tinsert(hitlist,crud[i].Character.DKit)
end
if crud[i] and crud[i].Character:FindFirstChild("Gun") then
tinsert(hitlist,crud[i].Character.Gun)
end
if crud[i] and crud[i].Character:FindFirstChild("Gun2") then
tinsert(hitlist,crud[i].Character.Gun2)
end
end
end
local direction=Vector3.new()
	local Mouse=(Camera.CoordinateFrame.p+(Camera.CoordinateFrame.lookVector*999))
	direction=(CFrame.new(flash.p, Mouse) * Spread).lookVector.unit * range*hammerunit2stud
	if equipped~="melee" then
		direction=dir*range*hammerunit2stud
	end
	local RayCasted = Ray.new(Camera.CoordinateFrame.p, direction)
local Hit12=nil
local Pos12=nil
local Hit, Pos = workspace:FindPartOnRayWithIgnoreList(RayCasted, hitlist,false,true)
local startpos=nil
if equipped=="melee" then
if Hit==nil then
local starttime=tick()
repeat 
	Mouse=(Camera.CoordinateFrame.p+(dir*999)) 
	flash=Camera.CoordinateFrame 
	Spread = CFrame.Angles(mrad(mrandom(-actualfadg,actualfadg)/14), mrad(mrandom(-actualfadg, actualfadg)/14), mrad(mrandom(-actualfadg, actualfadg)/14)) 
	direction=(CFrame.new(flash.p, Mouse) * Spread).lookVector.unit * range*hammerunit2stud
	RayCasted = Ray.new(Camera.CoordinateFrame.p, direction) 
	Hit,Pos= workspace:FindPartOnRayWithIgnoreList(RayCasted, hitlist,false,true) 
	_Run.Stepped:wait() until (tick()-starttime)>=firerate/2 or Hit and Pos
end
end

local dmg=gun.DMG.Value



--------------------------------------------------------------TRAIL GENERATION
local shat=gun.BulletPerTrail.Value
if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2") and Camera.Arms.Silencer2.Transparency==1 or Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2") and Camera.Arms.Silencer2.Transparency==1 then
shat=3
end
bulletpertrail=bulletpertrail+1
if equipped~="melee" and bulletpertrail>=shat and shat>0 then

	bulletpertrail=0
	local distance=gun.Range.Value
	if Pos then
	distance=(Pos-Camera.CoordinateFrame.p).magnitude
	end
		local flash=Camera.CoordinateFrame
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Flash") then
		flash=Camera.Arms.Flash.CFrame
		end
		local fMouse=(Camera.CoordinateFrame.p+(Camera.CoordinateFrame.lookVector*distance))
		local fdirection=(CFrame.new(flash.p, fMouse) * Spread).lookVector.unit * range*hammerunit2stud
		local RayCasted = Ray.new(flash.p, direction)
		game.ReplicatedStorage.Events.Trail:FireServer(flash,fdirection,{game.Workspace.Map.Geometry})
		createtrail(flash,fdirection,{game.Workspace.Map.Geometry})
end
-----------END
---------------------------PENETRATION 
	local partpenetrated=0
	local limit=0
	local PartHit
	local PositionHit
	local NormalHit
	local partmodifier=1
	local damagemodifier=1
--spawn(function()
	--print("shot number: "..shotsfired)
	pcall(function()
	repeat
	--	_Run.Stepped:wait()
	PartHit, PositionHit, NormalHit = workspace:FindPartOnRayWithIgnoreList(RayCasted, hitlist,false,true)
	
	if not PartHit then
	--	print("HIT_DEBUG: missed completely")
	end
	if (PartHit) and PartHit.Parent then
		partmodifier=1
		if PartHit.Material==Enum.Material.DiamondPlate then
			partmodifier=3
		end
		if PartHit.Material==Enum.Material.CorrodedMetal or PartHit.Material==Enum.Material.Metal or PartHit.Material==Enum.Material.Concrete or PartHit.Material==Enum.Material.Brick then
			partmodifier=2
		end
		if PartHit.Name=="Grate" or PartHit.Material==Enum.Material.Wood or PartHit.Material==Enum.Material.WoodPlanks or PartHit and PartHit.Parent and PartHit.Parent:FindFirstChild("Humanoid") then
			partmodifier=0.1
		end
		if PartHit.Transparency==1 or PartHit.CanCollide==false or PartHit.Name=="Glass" or PartHit.Name=="Cardboard" or PartHit:IsDescendantOf(game.Workspace["Ray_Ignore"]) or PartHit:IsDescendantOf(game.Workspace.Debris) or PartHit and PartHit.Parent and PartHit.Parent.Name=="Hitboxes" then
			partmodifier=0
		end
		if PartHit.Name=="nowallbang" then
			partmodifier=100
		end
		if PartHit:FindFirstChild("PartModifier") then
			partmodifier=PartHit.PartModifier.Value
		end
		local fakehit,Endposition=game.Workspace:FindPartOnRayWithWhitelist(Ray.new(PositionHit+(direction*1),direction*-2),{PartHit},true)
	    local PenetrationDistance = (Endposition-PositionHit).magnitude
		PenetrationDistance=PenetrationDistance*partmodifier
		limit=math.min(penetrationpower,limit+PenetrationDistance)
		local wallbang=false
		if partpenetrated>=1 then
			wallbang=true
		end
		if PartHit and PartHit.Parent and PartHit.Parent.Name=="Hitboxes" or PartHit and PartHit.Parent.className=="Accessory" or PartHit and PartHit.Parent.className=="Hat" or PartHit.Name=="HumanoidRootPart" and PartHit.Parent.Name~="Door" or PartHit.Name=="Head" and PartHit.Parent:FindFirstChild("Hostage")==nil then
		else
			if PartHit.Transparency<1 or PartHit.Name=="HeadHB" then
				if PartHit and PartHit.Parent:FindFirstChild("Humanoid")==nil then
					if range==48 then
						hitobject(PartHit,PositionHit,NormalHit,gun,true)
					else
						hitobject(PartHit,PositionHit,NormalHit,gun,false)
					end
				end

				game.ReplicatedStorage.Events.Hit:FireServer(PartHit,PositionHit,CHOSENONE.Name,range,Character:WaitForChild("Gun"),startpos,Pos12,damagemodifier,Held2,wallbang,Camera.CoordinateFrame.p,game.Workspace.DistributedTime.Value,NormalHit)
				if PartHit and PartHit.Parent then			
					if PartHit and PartHit.Parent and PartHit.Parent:FindFirstChild("Humanoid") then
						--print("HIT_DEBUG: hit a person: "..PartHit.Name)
					else
						--print("HIT_DEBUG: hit the environment: "..PartHit.Name)
					end
				end
			end
			

		end
		
		if partmodifier>0 then
		partpenetrated=partpenetrated+1
		end
		----print(partpenetrated.." part(s) penetrated with "..damagemodifier)
		damagemodifier=1-(limit/penetrationpower)
		if limit>=penetrationpower then
			if _Run:IsStudio() then
				--print(PartHit.Name)
				--print(PartHit.Parent.Name)
				--print("Ray hit material " .. PartHit.Material.Name.." trying to go through "..PenetrationDistance.." units")
			end
		else
		if PartHit and PartHit.Parent and PartHit.Parent.Name=="Hitboxes" or PartHit and PartHit.Parent.className=="Accessory" or PartHit and PartHit.Parent.className=="Hat" or PartHit.Name=="HumanoidRootPart" and PartHit.Parent.Name~="Door" then
		else
			if PartHit and PartHit.Parent:FindFirstChild("Humanoid")==nil then
				if range==48 then
					hitobject(PartHit,Endposition,-NormalHit,gun,true)
				else
					hitobject(PartHit,Endposition,-NormalHit,gun,false)
				end
			end
			if _Run:IsStudio() then
		    	--print("Ray went through " .. PenetrationDistance .. " units of material " .. PartHit.Material.Name)
			end
		end

		end
		if PartHit and PartHit.Parent and PartHit.Parent.Name=="Hitboxes" or PartHit and PartHit.Parent and PartHit.Parent.Parent and PartHit.Parent.Parent:FindFirstChild("Humanoid2") or PartHit and PartHit.Parent and PartHit.Parent:FindFirstChild("Humanoid2") or PartHit and PartHit.Parent and PartHit.Parent:FindFirstChild("Humanoid") and (PartHit.Transparency<1 or PartHit.Name=="HeadHB") and PartHit.Parent:IsA("Model") then
			table.insert(hitlist,PartHit.Parent)
		else
			table.insert(hitlist,PartHit)
		end
	end
	--_Run.Heartbeat:wait()
	until PartHit==nil or limit>=penetrationpower or partpenetrated>=maxpartpenetration or damagemodifier<=0
	end)
	if equipped~="melee" then
	local playas=game.Players:GetPlayers()
		for i=1,#playas do
			if playas[i] and playas[i].Name~=player.Name and playas[i].Character and playas[i].Character:FindFirstChild("Head") and (game.ReplicatedStorage.gametype.Value=="TTT" or player.Status.Team.Value~=playas[i].Status.Team.Value) then
				if PartHit and not PartHit:IsDescendantOf(playas[i].Character) or PartHit==nil then
				local arbitraryPoint=playas[i].Character.Head
				local lineStart=Camera.CoordinateFrame.p
				local StartToEnd = (PositionHit - lineStart)
				local StartToPoint = (arbitraryPoint.Position - lineStart)
				
				local SquaredMagnitudeOfLine = math.pow(StartToEnd.X, 2) + math.pow(StartToEnd.Y, 2) + math.pow(StartToEnd.Z, 2)
				local DotOfLines = StartToPoint:Dot(StartToEnd)
				local IncrementToMoveOnLine = DotOfLines / SquaredMagnitudeOfLine

				
				local ClosestPoint = lineStart + (StartToEnd * IncrementToMoveOnLine)
				--[[if _Run:IsStudio() then
					local part=Instance.new("Part")
					part.Size=Vector3.new(1,1,1)
					part.Anchored=true
					part.CFrame=CFrame.new(ClosestPoint)
					part.Parent=game.Workspace.Debris
					part.BrickColor=BrickColor.new("Bright red")
					delay(5,function()
						part:Destroy()
					end)
				end	]]			
				local normaldistance=(PositionHit-lineStart).magnitude
				local pointdistance=(ClosestPoint-lineStart).magnitude
				local magnitude=(ClosestPoint-arbitraryPoint.Position).magnitude
				local direction=(ClosestPoint-arbitraryPoint.Position).unit*-8
				local ray=Ray.new(ClosestPoint,direction)
				local hit,pos=game.Workspace:FindPartOnRayWithIgnoreList(ray,hitlist)
				local found=false
				local enemyheadpos=playas[i].Character.Head.Position
				local headpos=Camera.CoordinateFrame.p
				local dote=(headpos-enemyheadpos).unit:Dot(CFrame.new(Camera.CoordinateFrame.p,PositionHit).lookVector.unit)
				local valid=false
				if magnitude<=4 and hit and hit:IsDescendantOf(playas[i].Character) and pointdistance<=normaldistance then
					valid=true
				end
				if valid==true and dote<=math.cos(math.rad(60)) then
					found=true
				end

					if valid==true and found==true then
					game.ReplicatedStorage.Events.Whizz:FireServer(playas[i],gun)
					end
				end
			end
		end
	end	
--end)	
--------------------------------------------------
--sniper
end
end)()
else
--if gun~="none" and gun and gun:FindFirstChild("Projectile") then
--if gun.Projectile:FindFirstChild("Rocket") then
--local rocketspeed=gun.Speed.Value*hammerunit2stud
--local damage=gun.DMG.Value
--local mindamage=gun.MinDmg.Value
--local blastradius=gun.BlastRadius.Value*hammerunit2stud
--local selfdamage=gun.SelfDamage.Value
--game.ReplicatedStorage.Events.CreateProjectile:FireServer("Rocket",rocketspeed,mouse.Hit.p,game.Workspace.CurrentCamera.CoordinateFrame,damage,mindamage,selfdamage,blastradius,gun.Name)
--elseif gun.Projectile:FindFirstChild("Grenade") then
--local rocketspeed=gun.Speed.Value*hammerunit2stud
--local damage=gun.DMG.Value
--local mindamage=gun.MinDmg.Value
--local blastradius=gun.BlastRadius.Value*hammerunit2stud
--local selfdamage=gun.SelfDamage.Value
--game.ReplicatedStorage.Events.CreateProjectile:FireServer("Grenade",rocketspeed,mouse.Hit.p,game.Workspace.CurrentCamera.CoordinateFrame,damage,mindamage,selfdamage,blastradius,gun.Name)
--elseif gun.Projectile:FindFirstChild("Stickybomb") then
--local rocketspeed=gun.Speed.Value*hammerunit2stud
--local damage=gun.DMG.Value
--local mindamage=gun.MinDmg.Value
--local blastradius=gun.BlastRadius.Value*hammerunit2stud
--local selfdamage=gun.SelfDamage.Value
--game.ReplicatedStorage.Events.CreateProjectile:FireServer("Stickybomb",rocketspeed,mouse.Hit.p,game.Workspace.CurrentCamera.CoordinateFrame,damage,mindamage,selfdamage,blastradius,gun.Name)
--end
--end
end
-------------------------
if equipped~="melee" then
	lastfire=tick()
	if gun and gun.Name=="AK47" or gun and gun.Name=="CZ" then
		if jumping==false and running==true then
			KickBack( 1.5, 0.45, 0.225, 0.05, 6.5, 2.5, 7 )
		elseif jumping==true then
			KickBack( 2, 1.0, 0.5, 0.35, 9, 6, 5 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.9, 0.35, 0.15, 0.025, 5.5, 1.5, 9 )
		else
			KickBack( 1, 0.375, 0.175, 0.0375, 5.75, 1.75, 8 )
		end
	elseif gun and gun.Name=="MP7" then
		if jumping==false and running==true then
			KickBack( 0.5, 0.275, 0.2, 0.03, 3, 2, 10 )
		elseif jumping==true then
			KickBack( 0.9, 0.475, 0.35, 0.0425, 5, 3, 6 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.225, 0.15, 0.1, 0.015, 2, 1, 10 )
		else
			KickBack( 0.25, 0.175, 0.125, 0.02, 2.25, 1.25, 10 )
		end
	elseif gun and gun.Name=="P90" then
		if jumping==false and running==true then
			KickBack( 0.45, 0.3, 0.2, 0.0275, 4, 2.25, 7 )
		elseif jumping==true then
			KickBack( 0.9, 0.45, 0.35, 0.04, 5.25, 3.5, 4 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.275, 0.2, 0.125, 0.02, 3, 1, 9 )
		else
			KickBack( 0.3, 0.225, 0.125, 0.02, 3.25, 1.25, 8 )
		end
	elseif gun and gun.Name=="MAC10" then
		if jumping==false and running==true then
			KickBack( 0.9, 0.45, 0.25, 0.035, 3.5, 2.75, 7 )
		elseif jumping==true then
			KickBack( 1.3, 0.55, 0.4, 0.05, 4.75, 3.75, 5 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.75, 0.4, 0.175, 0.03, 2.75, 2.5, 10 )
		else
			KickBack( 0.775, 0.425, 0.2, 0.03, 3, 2.75, 9 )
		end
	elseif gun and gun.Name=="MP9" or gun and gun.Name=="Bizon" then
		if jumping==false and running==true then
			KickBack( 0.8, 0.4, 0.2, 0.03, 3, 2.5, 7 )
		elseif jumping==true then
			KickBack( 1.1, 0.5, 0.35, 0.045, 4.5, 3.5, 6 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.7, 0.35, 0.125, 0.025, 2.5, 2, 10 )
		else
			KickBack( 0.725, 0.375, 0.15, 0.025, 2.75, 2.25, 9 )
		end
	elseif gun and gun.Name=="UMP" then
		if jumping==false and running==true then
			KickBack( 0.55, 0.3, 0.225, 0.03, 3.5, 2.5, 10 )
		elseif jumping==true then
			KickBack( 0.125, 0.65, 0.55, 0.0475, 5.5, 4, 10 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.25, 0.175, 0.125, 0.02, 2.25, 1.25, 10 )
		else
			KickBack( 0.275, 0.2, 0.15, 0.0225, 2.5, 1.5, 10 )
		end
	elseif gun and gun.Name=="M249" then
		if jumping==false and running==true then
			KickBack( 1.1, 0.5, 0.3, 0.06, 4, 3, 8 )
		elseif jumping==true then
			KickBack( 1.8, 0.65, 0.45, 0.125, 5, 3.5, 8 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.75, 0.325, 0.25, 0.025, 3.5, 2.5, 9 )
		else
			KickBack( 0.8, 0.35, 0.3, 0.03, 3.75, 3, 9 )
		end
	elseif gun and gun.Name=="Galil" then
		if jumping==false and running==true then
			KickBack( 1.0, 0.45, 0.28, 0.045, 3.75, 3, 7 )
		elseif jumping==true then
			KickBack( 1.2, 0.5, 0.23, 0.15, 5.5, 3.5, 6 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.6, 0.3, 0.2, 0.0125, 3.25, 2, 7 )
		else
			KickBack( 0.65, 0.35, 0.25, 0.015, 3.5, 2.25, 7 )
		end
	elseif gun and gun.Name=="AWP" then
		RecoilX=2
		px=-2
	elseif gun and gun.Name=="Scout" then
		RecoilX=2
		px=-2
	elseif gun and gun.Name=="USP" or gun and gun.Name=="R8" or gun and gun.Name=="Tec9" or gun and gun.Name=="P2000" or gun and gun.Name=="P250" or gun and gun.Name=="DesertEagle" or gun and gun.Name=="DualBerettas" or gun and gun.Name=="FiveSeven" or gun and gun.Name=="Glock" then
		if gun.Name=="Glock" or gun and gun.Name=="P2000" then
			RecoilX=RecoilX+1
			px=px-(1/3)
		else
			RecoilX=RecoilX+2
			if gun and gun.Name=="R8" or gun and gun.Name=="DesertEagle" then
				if gun and gun.Name=="R8" then
					px=0
					py=0
				else
					px=px-3
					py=py-math.random(-2,2)
				end
			else
				px=px-(2/3)
			end
		end
		if gun and gun.Name~="R8" and gun and gun.Name~="DesertEagle" then				
			px=math.max(-4,px)
		else
			px=math.max(-12,px)
			py=math.clamp(py,-6,6)
			RecoilY=-py
		end
	elseif gun and gun.Name=="Nova" or gun and gun.Name=="SawedOff" or gun and gun.Name=="MAG7" then
		local number=math.random(4,6)
		if jumping==true then
			number=math.random(8,11)
		end
		RecoilX=RecoilX+number
		--px=px-number
		--px=math.max(-12,px)
	elseif gun and gun.Name=="Negev" then
		local number=1.5
		if jumping==true then
			number=3
		end
		RecoilX=RecoilX+number
		px=px-number
		px=math.max(-4,px)
	elseif gun and gun.Name=="XM" then
		local number=math.random(3,5)
		if jumping==true then
			number=math.random(7,10)
		end
		RecoilX=RecoilX+(number/5)
		px=px-(number/5)
		px=math.max(-4,px)
	elseif gun and gun.Name=="G3SG1" then
		px=px-(math.random(0.75*100,1.75*100)/100)+(px/4)
		py=py+(math.random(-0.75*100,0.75*100)/100)
		px=math.max(-5,px)
		RecoilX=math.abs(px)
		RecoilY=-py
	elseif gun and gun.Name=="AUG" then
		if jumping==false and running==true then
			KickBack(1, 0.45, 0.275, 0.05, 4, 2.5, 7)
		elseif jumping==true then
			KickBack( 1.25, 0.45, 0.22, 0.18, 5.5, 4, 5 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.575, 0.325, 0.2, 0.011, 3.25, 2, 8 )
		else
			KickBack( 0.625, 0.375, 0.25, 0.0125, 3.5, 2.25, 8 )
		end
	elseif gun and gun.Name=="SG" then
		if jumping==false and running==true then
			KickBack(1, 0.45, 0.28, 0.04, 4.25, 2.5, 7)
		elseif jumping==true then
			KickBack( 1.25, 0.45, 0.22, 0.18, 6, 4, 5 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.6, 0.35, 0.2, 0.0125, 3.7, 2, 10 )
		else
			KickBack( 0.625, 0.375, 0.25, 0.0125, 4, 2.25, 9 )
		end
	elseif gun and gun.Name=="Famas" then
		if jumping==false and running==true then
			KickBack(1, 0.45, 0.275, 0.05, 4, 2.5, 7)
		elseif jumping==true then
			KickBack( 1.25, 0.45, 0.22, 0.18, 5.5, 4, 5 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.575, 0.325, 0.2, 0.011, 3.25, 2, 8 )
		else
			KickBack( 0.625, 0.375, 0.25, 0.0125, 3.5, 2.25, 8 )
		end
	elseif gun and (gun.Name=="M4A1" or gun.Name=="M4A4") then
		if jumping==false and running==true then
			KickBack( 1.0, 0.45, 0.28, 0.045, 3.75, 3, 7 )
		elseif jumping==true then
			KickBack( 1.2, 0.5, 0.23, 0.15, 5.5, 3.5, 6 )
		elseif crouchcooldown<=1 and Character:FindFirstChild("Crouched") and jumping==false and landing==false and running==false then
			KickBack( 0.6, 0.3, 0.2, 0.0125, 3.25, 2, 7 )
		else
			KickBack( 0.65, 0.35, 0.25, 0.015, 3.5, 2.25, 7 )
		end
	end
	rec=px
	rec2=py
	recs1=RecoilX
	recs2=RecoilY
end
if number==3 then
local starttime=tick() repeat  _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=gun.Burst.Value

end

end


end
else
if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Empty") then
Character.Gun.Empty:Play()
end
Held=false
	end
	local scopeback=false
	local lastdoublezoom=doublezoom
if gun~="none" and gun and gun ~= "none" and gun.className and gun.className=="Folder" and gun:FindFirstChild("Auto") and gun.Auto.Value==false then
	if ads==true then
		ads=false
		updateads()
		scopeback=true
	end
end
	if number==3 then
local starttime=tick() repeat  _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=gun.Cooldown.Value
	else
		if equipped=="melee" then
local starttime=tick() repeat  _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=firerate-0.1
		else
			if fanfire==true then
				firerate=0.4
			end
local starttime=tick() repeat  _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=firerate
		end
end
	if scopeback==true then
		if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Zoom") then
		Character.Gun.Zoom:Play()
		end
		ads=true
		doublezoom=lastdoublezoom
		updateads()
		
	end
if gun==CHOSENONE then

DISABLED=false
autoreload()

end

end
end)()
end


Player.CharacterRemoving:connect(function()
	if selected then

	selected.CanCollide=true
	end
end)
local success=false


game.Players.PlayerRemoving:connect(function(p)
	if p.Name == Player.Name then
		mouseDown = false
		grabbing = false
		if selected then

 selected.CanCollide=true
	end
	end
end)


function Button2Down()
	if script.Parent:FindFirstChild("GUI") and game.Workspace.Status.Preparation.Value==false and Player.PlayerGui.GUI.Defusal.Visible==false and (equipped =="grenade" or equipped =="grenade2" or equipped =="grenade3" or equipped =="grenade4") then
			local CHOSENONE=gun
			if (equipped =="grenade" or equipped =="grenade2" or equipped =="grenade3" or equipped =="grenade4") and idleani and idleani.IsPlaying==false and reloadani and fire2ani and fire2ani.IsPlaying==false and fireani and fireani.IsPlaying==false  then
				if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Pin") then
				Character.Gun.Pin:Play()
				end
				if reload then
				reload:Play()
				end
				if reloadani then
				reloadani:Play()
				game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Reload")
				end
				if idleani then
				idleani:Play()
				idle:Play()
				end
				return
			end
		end
		if not UIS.MouseIconEnabled then
		Held2=true
		end
	if died==false and equipped~="none" and equipped ~= "equipment3" and gun~="none" and gun and gun:FindFirstChild("Scoped") and reloading==false and DISABLED==false then
		if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Zoom") then
		Character.Gun.Zoom:Play()
		end
		if gun~="none" and gun and gun:FindFirstChild("Scoped") and gun:FindFirstChild("RifleThing")==nil and ads==true and doublezoom==false then
		doublezoom=true
		else
		ads=not ads
			if ads==false then
			doublezoom=false
			end
		end

		updateads()

	end
	
end

function Button2Up()
		if not UIS.MouseIconEnabled then
		Held2=false
	if (equipped=="grenade" and grenade~="" or equipped=="grenade2" and grenade2~="" or equipped=="grenade3" and grenade3~="" or equipped=="grenade4" and grenade4~="")  and idleani and idleani.IsPlaying==true and fire2ani and fire2ani.IsPlaying==false and fireani and fireani.IsPlaying==false and Held2==false and Held==false then
		if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Throw") then
		Character.Gun.Throw:Play()
		end
		if reloadani then
		reloadani:Stop()
		end
		if reload then
		reload:Stop()
		end
		if fire then
			game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Fire")
		fire:Play()
		end
		if fire2ani then
		fire2ani:Play()
			if Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Handle") then
				Camera.Arms.Handle.Transparency=1
			end
			if Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Pin") then
				Camera.Arms.Pin.Transparency=1
			end
			if Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Slide") then
				Camera.Arms.Slide.Transparency=1
			end
		end
		
		local CHOSENONE=gun
		local starttime=tick()
					local char=Character
					local throwdistance=22.5
					if _Run:IsStudio() then
					--print("throw distance: "..throwdistance.. " units")
					end
					local l=25
					local h=35
					local mylengthlol=workspace.CurrentCamera.CFrame.lookVector * (throwdistance) + Vector3.new(0, 5, 0) + Vector3.new(char.Humanoid.MoveDirection.X * 25, Character.HumanoidRootPart.Velocity.Y, char.Humanoid.MoveDirection.Z * 25)
					if equipped=="grenade" then
						game.ReplicatedStorage.Events.ThrowGrenade:FireServer(game.ReplicatedStorage.Weapons[grenade].Model, nil, l,h,mylengthlol,primary,secondary)			
						grenade=""
					elseif equipped=="grenade2" then
						game.ReplicatedStorage.Events.ThrowGrenade:FireServer(game.ReplicatedStorage.Weapons[grenade2].Model, nil, l,h,mylengthlol,primary,secondary)				
						grenade2=""
					elseif equipped=="grenade3" then
						game.ReplicatedStorage.Events.ThrowGrenade:FireServer(game.ReplicatedStorage.Weapons[grenade3].Model, nil, l,h,mylengthlol,primary,secondary)				
						grenade3=""
					elseif equipped=="grenade4" then
						game.ReplicatedStorage.Events.ThrowGrenade:FireServer(game.ReplicatedStorage.Weapons[grenade4].Model, nil, l,h,mylengthlol,primary,secondary)				
						grenade4=""
					end
					updateInventory()
						repeat _Run.Stepped:wait() 			
						until gun~=CHOSENONE or gun~="none" and gun and gun:FindFirstChild("FireRate")==nil or gun~="none" and gun and gun:FindFirstChild("FireRate") and (tick()-starttime)>=(fireani.Length-0.05)
		
		autoequip()
	end 
		end
	
end


mouse.Button2Down:connect(function()
	Button2Down()
end)

mouse.Button2Up:connect(function()
	Button2Up()
end)
function reloadwep()
if DISABLED==false and reloading==false then
if Humanoid and Humanoid.Health==0 then
return
end
if equipped=="equipment2" and ammocount4<gun.Ammo.Value and equipment2stored>0 or equipped=="equipment3" and ammocount3<gun.Ammo.Value and equipmentstored>0 or equipped=="primary" and ammocount<gun.Ammo.Value and primarystored>0 or equipped=="secondary" and ammocount2<gun.Ammo.Value and secondarystored>0 then
ads=false
updateads()
reloading=true
if inspectani then
inspectani:Stop()
end
if reloadani then
reloadani:Stop()
end
if reload1ani then
reload1ani:Stop()
end
if reload2ani then
reload2ani:Stop()
end
if equipani then
equipani:Stop()
end
if fireani then
fireani:Stop()
end
local CHOSENONE=gun
if gun:FindFirstChild("PumpAction") then
if reload1ani then
reload1ani:Play()
if reload1 then
reload1:Play()
end
game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Reload1")
end
local starttime=tick() repeat  _Run.Stepped:wait() if gun:FindFirstChild("PumpAction") and DISABLED==true then return end if gun~=CHOSENONE then return end until (tick()-starttime)>=gun.SReload.Value
end


countammo()
enabled5=false


if gun:FindFirstChild("PumpAction") then


if equipped=="secondary" and secondarystored>0 and ammocount2<gun.Ammo.Value or equipped=="primary" and primarystored>0 and ammocount<gun.Ammo.Value then
repeat 
if reload1ani then
reload1ani:Stop()
if reload1 then
reload1:Stop()
end
end
reload:Play()
if reloadani then
reloadani:Play()
end
game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Reload")
local starttime=tick() repeat  _Run.Stepped:wait() if gun:FindFirstChild("PumpAction") and DISABLED==true then return end if gun~=CHOSENONE then return end until (tick()-starttime)>=reloadtime
if equipped=="primary" then
ammocount=mmin(ammocount+1,gun.Ammo.Value)
primarystored=primarystored-1
elseif equipped=="secondary" then
ammocount2=mmin(ammocount2+1,gun.Ammo.Value)
secondarystored=secondarystored-1
end
countammo()
local starttime=tick() repeat  _Run.Stepped:wait() if gun:FindFirstChild("PumpAction") and DISABLED==true then return end if gun~=CHOSENONE then return end until (tick()-starttime)>=gun.AReload.Value
until primarystored<=0 and equipped=="primary" or secondarystored<=0 and equipped=="secondary" or equipped=="secondary" and ammocount2>=gun.Ammo.Value  or equipped=="primary" and ammocount>=gun.Ammo.Value 
end

else
reload:Play()
DISABLED=true
if reloadani then
reloadani:Play()
end
game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Reload")
local starttime=tick() repeat  if reloadani then reloadani:AdjustSpeed(reloadani.Length/reloadtime) end _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=(reloadtime)

DISABLED=false
end
if gun:FindFirstChild("PumpAction") then
	game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Reload2")
if reload2ani then
reload2ani:Play()
if reload2 then
reload2:Play()
end
end
local starttime=tick() repeat  _Run.Stepped:wait() if gun:FindFirstChild("PumpAction") and DISABLED==true then return end if gun~=CHOSENONE then return end until (tick()-starttime)>=gun.EReload.Value

	else

DISABLED=false
end
reloading=false
enabled5=true

end
end


end
dooropen=false
local resetinspect=false
mouse.KeyDown:connect(function(key)
if key:lower() == "e" and not alive.Value or key:lower() == "e" and not ebounce and equipallowed and not UIS.MouseIconEnabled then

	pickup()
	local mTarget=door
	if dooropen==false and mTarget ~= nil and mTarget.Parent ~= nil and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and (Player.Character.HumanoidRootPart.Position - mTarget.Position).magnitude <= 10 and mTarget.Parent:FindFirstChild("Event") then
		local event = mTarget.Parent:FindFirstChild("Event")
		event:FireServer()
		dooropen=true
		local duration=0.5
		if game.ReplicatedStorage.gametype.Value=="TTT" then
			duration=0.1
		end
		delay(duration,function()
			dooropen=false
		end)
	end
end
if key:upper()=="R" then
	if inspectani and inspectani.IsPlaying==true then
	resetinspect=true
	end
reloadwep()
elseif key:upper()=="F" and inspectani then
if DISABLED==false and inspectani and (resetinspect==true or resetinspect==false and inspectani.IsPlaying==false) then
local dely=0
if inspectani.IsPlaying==true then
inspectani:Stop(.05,nil,nil)
dely=.05
end
resetinspect=false
spawn(function()
wait(dely)
if DISABLED==false then
script.Parent.Inspect1:Stop()
script.Parent.Inspect2:Stop()
script.Parent.Inspect3:Stop()
script.Parent["Inspect"..math.random(1,3)]:Play()
inspectani:Play(.15,nil,nil)
game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Inspect")
end
end)
end
end
end)

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


Camera.FieldOfView=fieldofview


-- BEGINNING OF ITEM EQUIPPED CODE
local bin = script.Parent:WaitForChild("GUI"):WaitForChild("Bin")
local obtained = script.Parent:WaitForChild("Sounds"):WaitForChild("Obtained")
local moving = false

function moveEverythingUp()
	moving = true
	for i, v in pairs(bin:GetChildren()) do
		if v:IsA("Frame") and v.Name == "Item" then
			if v:WaitForChild("TargetXPos").Value == 0 then
				v:TweenPosition(v.Position - UDim2.new(0, 0, 0, 35), "Out", "Quad", 0.3, true)
			else
				v:TweenPosition(UDim2.new(1, v:WaitForChild("TargetXPos").Value, 0.5, v.Position.Y.Offset - 35), "Out", "Quad", .3, true)
			end
		end
	end
	wait(0.35)
	moving = false
end

function display(name)
	spawn(function()
		repeat
			_Run.Heartbeat:wait()
		until
			not moving
			
		moveEverythingUp()
		
		--obtained:Play()
		
		local toolTip = script:WaitForChild("Item"):Clone()
		toolTip.Name = "Item"
		toolTip:WaitForChild("ToolTip").Text = name
		toolTip:WaitForChild("DropShadow").Text = name
	
		spawn(function()
			for i = 1, 0, -0.1 do
				if toolTip ~= nil then
					toolTip:FindFirstChild("ToolTip").TextTransparency = i
					toolTip:FindFirstChild("DropShadow").TextTransparency = i
					toolTip:FindFirstChild("ImageLabel"):FindFirstChild("Frame").BackgroundTransparency = i
					toolTip:FindFirstChild("ImageLabel"):FindFirstChild("Corner0").ImageTransparency = i
					toolTip:FindFirstChild("ImageLabel"):FindFirstChild("Corner").ImageTransparency = i
					toolTip:FindFirstChild("ImageLabel"):FindFirstChild("Corner1").ImageTransparency = i
					toolTip:FindFirstChild("ImageLabel"):FindFirstChild("Corner2").ImageTransparency = i
					wait()
				end
			end
		end)
		


			toolTip:WaitForChild("ImageLabel").Corner1.ImageColor3 = Color3.new(0, 255/255, 0)
			toolTip:WaitForChild("ImageLabel").Corner2.ImageColor3 = Color3.new(0, 255/255, 0)

		
		if preparation.Value then
			toolTip:WaitForChild("ImageLabel").Corner1.ImageColor3 = Color3.new(125/255, 125/255, 125/255)
			toolTip:WaitForChild("ImageLabel").Corner2.ImageColor3 = Color3.new(125/255, 125/255, 125/255)
		end
		
		toolTip.Parent = bin
		local tx = math.floor(toolTip:WaitForChild("ToolTip").TextBounds.X/2)
		toolTip.Size = UDim2.new(0, (tx * 2) + 5, 0, 30)
		toolTip:WaitForChild("ImageLabel"):WaitForChild("Frame").Size = UDim2.new(0, (tx*2)+1, 1, 0)
		toolTip.ImageLabel.Frame.Position=UDim2.new(0,15,0,0)
		
		
		toolTip:WaitForChild("TargetXPos").Value = -1 * (toolTip:WaitForChild("ToolTip").TextBounds.X + 35)
		toolTip:TweenSizeAndPosition(UDim2.new(0, toolTip:WaitForChild("ToolTip").TextBounds.X + 5, 0, 30), UDim2.new(1, -1 * (toolTip:WaitForChild("ToolTip").TextBounds.X + 35), 0.5, -15), "Out", "Quad", 0.3, true)
		wait(3)
		toolTip:WaitForChild("TargetXPos").Value = toolTip.Position.X.Offset + 115
		toolTip:TweenPosition(toolTip.Position + UDim2.new(0, 115, 0, 0), "Out", "Quad", 3, true)
		
		for i = 0, 1, 0.1 do
			if toolTip ~= nil then
				toolTip:FindFirstChild("ToolTip").TextTransparency = i
				toolTip:FindFirstChild("DropShadow").TextTransparency = i
				toolTip:FindFirstChild("ImageLabel"):FindFirstChild("Frame").BackgroundTransparency = i
				toolTip:FindFirstChild("ImageLabel"):FindFirstChild("Corner0").ImageTransparency = i
				toolTip:FindFirstChild("ImageLabel"):FindFirstChild("Corner").ImageTransparency = i
				toolTip:FindFirstChild("ImageLabel"):FindFirstChild("Corner1").ImageTransparency = i
				toolTip:FindFirstChild("ImageLabel"):FindFirstChild("Corner2").ImageTransparency = i
				wait(0.1)
			end
		end
		toolTip:Destroy()
	end)
end
-- END OF ITEM EQUIPPED CODE

-- NOTIFICATIONS CODE
local workspaceStatus = game.Workspace:WaitForChild("Status")

local notificationFrame = script:WaitForChild("Notification")



function createNotification2(val, color)
	if color==nil then
		color=Cnew(30/255,30/255,30/255)
	end
	repeat
		_Run.Heartbeat:wait()
	until
		not movingNotifications
	if val == "" then return end
	local clone = notificationFrame:Clone()
	
	if color then
		local dab=clone.RoundedBG:GetChildren()
		for i=1,#dab do
			if dab[i]:IsA("ImageLabel") then
				dab[i].ImageColor3 = color
			elseif dab[i]:IsA("Frame") then	
				dab[i].BackgroundColor3 = color		
			end
		end
	end

	
	clone.Name = "Notification"
	clone.Parent = bin
	
	clone:FindFirstChild("Message").Text = val
	if clone:FindFirstChild("Message").TextBounds.X > 408 then
		clone.Size = UDim2.new(0, 420, 0, 40)
		clone.Position = clone.Position - UDim2.new(0, 0, 0, 20)
	end
	clone:FindFirstChild("Message").TextWrapped = true
		

		
	if clone.Size.Y.Offset == 20 then
		moveEverythingDown(22)
	else
		moveEverythingDown(44)
	end
	
	spawn(function()
		wait(2)
		clone:Destroy()
	end)
end



-- END OF NOTIFICATIONS CODE

-- INVENTORY GUI CODE


function updatePosition()
	
	--Resets The Positions
	for i = 1, 8 do
		weapons[i].Position = positions[i]
	end
	--Sets the positions
	for i = 8, 2, -1 do
		if not sp:FindFirstChild("Item"..(i)).Visible and i<5 and i>7 then
			for j = 1, i-1 do
				if j<5 and j>7 then
					sp:FindFirstChild("Item"..(j)).Position = sp:FindFirstChild("Item"..(j)).Position + UDim2.new(0, 0, 0.2, 0)
				end
				if j>=5 and j<=7 then
					sp:FindFirstChild("Item"..(j)).Position=sp["Item4"].Position
				end
			end
		end
	end
	if weapons[4].Visible then
		sp:FindFirstChild("Item"..(8)).Position = weapons[4].Position+UDim2.new(0,0,0.2,0)
	else
		sp:FindFirstChild("Item"..(8)).Position = weapons[3].Position+UDim2.new(0,0,0.2,0)
	end
	if not Player.Character then
		sp.Visible = false
	end
	
end

function clearAll()
	for i, v in ipairs(weapons) do
		v:FindFirstChild("Weapon").ImageTransparency = 0.5
		if v:FindFirstChild("Weapon2") then
			v.Weapon2.ImageTransparency=0.5
		end
		if v:FindFirstChild("Weapon3") then
			v.Weapon3.ImageTransparency=0.5
		end
		if v:FindFirstChild("Weapon4") then
			v.Weapon4.ImageTransparency=0.5
		end
		v.bk.Visible=false
	end
	updatePosition()
end

function getNext(current)
	local found = false
	local current2 = current
	if realgun=="" and secondary=="" and melee=="" and equipment=="" and equipment2=="" and grenade=="" and grenade2=="" and grenade3=="" and grenade4=="" then
	else
		while found == false do
			_Run.Stepped:wait()
			if current2 == 8 then
				current2 = 1
			else
				current2 = current2 + 1
			end
			
			if weapons[current2].Visible == true then
				found = true
				break
			end
		end
	end
	return current2
end

function getPrevious(current)
	local found = false
	local current2 = current
	if realgun=="" and secondary=="" and melee=="" and equipment=="" and equipment2=="" and grenade=="" and grenade2=="" and grenade3=="" and grenade4=="" then
	else
		while found == false do
			_Run.Stepped:wait()
			if current2 == 1 then
				current2 = 8
			else
				current2 = current2 - 1
			end
			
			if weapons[current2].Visible == true then
				found = true
				break
			end
		end
	end
	return current2
end

function getSelected()
	local selected = 0
	for i = 1, 8 do
		if weapons[i]:FindFirstChild("Weapon").ImageTransparency == 0 then
			selected = i
			break
		end
	end
	return selected
end

function moveDown()
	if not scrolling then
		scrolling = true
		if weapons[1]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getNext(1)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getNext(1)].bk.Visible=true
		elseif weapons[2]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getNext(2)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getNext(2)].bk.Visible=true
		elseif weapons[3]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getNext(3)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getNext(3)].bk.Visible=true
		elseif weapons[4]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getNext(4)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getNext(4)].bk.Visible=true
		elseif weapons[5]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getNext(5)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getNext(5)].bk.Visible=true
		elseif weapons[6]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getNext(6)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getNext(6)].bk.Visible=true
		elseif weapons[7]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getNext(7)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getNext(7)].bk.Visible=true
		elseif weapons[8]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getNext(8)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getNext(8)].bk.Visible=true
		else
			clearAll()
			weapons[1]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[1].bk.Visible=true
		end
		updatePosition()
		scrolling = false
	end
	
end

function moveUp()
	if not scrolling then
		scrolling = true
		if weapons[1]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getPrevious(1)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getPrevious(1)].bk.Visible=true
		elseif weapons[2]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getPrevious(2)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getPrevious(2)].bk.Visible=true
		elseif weapons[3]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getPrevious(3)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getPrevious(3)].bk.Visible=true
		elseif weapons[4]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getPrevious(4)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getPrevious(4)].bk.Visible=true
		elseif weapons[5]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getPrevious(5)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getPrevious(5)].bk.Visible=true
		elseif weapons[6]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getPrevious(6)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getPrevious(6)].bk.Visible=true
		elseif weapons[7]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getPrevious(7)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getPrevious(7)].bk.Visible=true
		elseif weapons[8]:FindFirstChild("Weapon").ImageTransparency == 0 then
			clearAll()
			weapons[getPrevious(8)]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[getPrevious(8)].bk.Visible=true
		else
			clearAll()
			weapons[1]:FindFirstChild("Weapon").ImageTransparency = 0
			weapons[1].bk.Visible=true
		end
		updatePosition()
		scrolling = false
	end
	
end

function makeInvisible()
	sp.Visible = false
end

function makeVisible()
	if sp.Visible == false then
		sp.Visible = true
		local waiting = Instance.new("IntValue")
		waiting.Name = "Waiting2"
		waiting.Parent = Player
		delay(3,function()
			waiting:Destroy()
		end)
		
		local function hide()
			repeat wait() until Player:FindFirstChild("Waiting2") == nil 
			makeInvisible()
		end
		
		spawn(function() hide() end)
		--hider()
	else
		if Player:FindFirstChild("Waiting2") then
			Player:FindFirstChild("Waiting2"):Destroy()
			local waiting = Instance.new("IntValue")
			waiting.Parent = Player
			delay(3,function()
				waiting:Destroy()
			end)
			
			waiting.Name = "Waiting2"
		end
	end
	updatePosition()
	giveTool()
end

function giveTool()
	if equipallowed==true and ebounce==false then
		local eqap=false
	--makeInvisible()
	local selected = getSelected()
	if selected then
	else
		return
	end
	if currentTool~=selected then
	prevTool = currentTool
	end
	currentTool = selected
local gunownergive = nil
		if gun then
			
			
		if gun~="none" and gun:IsA("Folder") then
			
			if selected == 3 then
				if melee~="" and equipped~="melee" then
				equipped = "melee"
				gun = game.ReplicatedStorage.Weapons[melee]
				eqap=true
				end
			elseif selected == 2 then
				if secondary~="" and equipped~="secondary" then
					eqap=true
				equipped = "secondary"
				gunownergive = secondaryowner
				gun = game.ReplicatedStorage.Weapons[secondary]
				end
			elseif selected == 1 then
				if realgun~="" and equipped~="primary" then
					eqap=true
				equipped = "primary"
				gunownergive = primaryowner
				gun = game.ReplicatedStorage.Weapons[realgun]
				end
			elseif selected == 4 then
				if grenade~="" and equipped~="grenade" then
					eqap=true
					equipped = "grenade"
					gun = game.ReplicatedStorage.Weapons[grenade]
				end
			elseif selected == 5 then
				if grenade2~="" and equipped~="grenade2" then
					eqap=true
					equipped = "grenade2"
					gun = game.ReplicatedStorage.Weapons[grenade2]
				end
			elseif selected == 6 then
				if grenade3~="" and equipped~="grenade3" then
					eqap=true
					equipped = "grenade3"
					gun = game.ReplicatedStorage.Weapons[grenade3]
				end
			elseif selected == 7 then
				if grenade4~="" and equipped~="grenade4" then
					eqap=true
					equipped = "grenade4"
					gun = game.ReplicatedStorage.Weapons[grenade4]
				end
			elseif selected == 8 then
				if equipment2~="" and equipped~="equipment2" then
					eqap=true
				equipped = "equipment2"
				gun = game.ReplicatedStorage.Weapons[equipment2]
end
			end
			
			if Player:FindFirstChild("DNAScanner") then
				Player:FindFirstChild("DNAScanner").Value = false
			end
				if eqap==true then
				usethatgun(gunownergive)
				end
			end
			end
		

	updatePosition()
	end
end

mouse.WheelBackward:connect(function()
	if equipallowed and alive.Value then
		moveDown()
		makeVisible()
	end
end)







----------DROP

local destroyObject = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DestroyObject")

function pickup(touchedweapon)
	if game.ReplicatedStorage.gametype.Value=="juggernaut" and Player.Status.Team.Value=="T" then
		return
	end
	if Humanoid and Humanoid.Health>0 then
	else
		return
	end
	local selectedweapon=selectionSphere.Adornee
	if touchedweapon~=nil then
	selectedweapon=touchedweapon
	end
	
	if selectedweapon and game.ReplicatedStorage.Weapons:FindFirstChild(selectedweapon.Name) and (game.ReplicatedStorage.Weapons:FindFirstChild(selectedweapon.Name):FindFirstChild("Grenade")==nil or game.ReplicatedStorage.Weapons:FindFirstChild(selectedweapon.Name):FindFirstChild("Grenade") and grenadeallowed(selectedweapon.Name)==true) and Player:FindFirstChild("DROPPED")==nil and Player.Status.Alive.Value==true and selectedweapon:FindFirstChild("PickedUp")==nil and ebounce==false then
		--print("The owner of this weapon is "..selectedweapon.Owner.Value.Name)		
		local weaponName = selectedweapon.Name
		
		if game.ReplicatedStorage.Weapons:FindFirstChild(weaponName) and selectedweapon then
			--display(weaponName)
			local wap=game.ReplicatedStorage.Weapons:FindFirstChild(weaponName)
			local duncee=selectedweapon
			local ammo12=nil
			local ammo13=nil
			local pspecial=false
			local sspecial=false
			if wap and wap:FindFirstChild("Primary") and duncee:FindFirstChild("Special") then
				pspecial=duncee.Special.Value				
			end
			
			if wap and wap:FindFirstChild("Secondary") and duncee:FindFirstChild("Special") then
				sspecial=duncee.Special.Value				
			end
			
			if duncee and duncee:FindFirstChild("Ammo") and duncee:FindFirstChild("StoredAmmo") then
				ammo12=duncee.Ammo.Value
				ammo13=duncee.StoredAmmo.Value
			end
			game.ReplicatedStorage.Events.PickUp:FireServer(duncee)
			if wap and wap:FindFirstChild("Secondary") and duncee:FindFirstChild("Owner") then
					secondaryowner = selectedweapon.Owner.Value
				end
			local st=tick()
			ebounce=true
			repeat if duncee:FindFirstChild("PickedUp") and duncee.PickedUp.Value~=game.Players.LocalPlayer or duncee==nil or (tick()-st)>=3 then ebounce=false return end _Run.Stepped:wait() until duncee and duncee:FindFirstChild("PickedUp") and duncee.PickedUp.Value==game.Players.LocalPlayer
	if Humanoid and Humanoid.Health>0 then
	else
		return
	end
				destroyObject:FireServer(duncee)
			script.Parent.Pickup:Play()
			if wap:FindFirstChild("Primary") then
				
				if realgun~="" then
					game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[realgun],Camera.CoordinateFrame,ammocount,primarystored,special,primaryowner,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
					repeat wait() until Player:FindFirstChild("DROPPED")
						Player.DROPPED:Destroy()
				end
				if wap and wap:FindFirstChild("Primary") and duncee:FindFirstChild("Owner") then
					primaryowner = selectedweapon.Owner.Value
				else
					primaryowner=game.Players.LocalPlayer
				end
				
			
				special=pspecial
				
				if tostring(primaryowner) == game.Players.LocalPlayer.Name then
					primary	= wap.Name
					realgun	= primary
				else
					primary	= tostring(primaryowner).."'s "..wap.Name
					realgun	= string.find(primary, "'")
					realgun	= string.sub(primary, realgun+3)
					skinname = primaryowner.SkinFolder:FindFirstChild(primaryowner.Status.Team.Value.."Folder")[wap.Name].Value
					primary = primary.." | "..skinname
				end
				if equipped=="primary" then
				autoequip()
				end
				if not touchedweapon then
					--[[if game.ReplicatedStorage.Weapons[primary].Model.TextureID ~= selectedweapon.TextureID then
						primarySkin = selectedweapon.TextureID
					else
						primarySkin = ""
					end]]
					clearAll()
					weapons[1]:FindFirstChild("Weapon").ImageTransparency = 0
					if currentTool ~= 1 then
						prevTool = currentTool
						currentTool = 1
					end

				else
				--[[	if game.ReplicatedStorage.Weapons[primary].Model.TextureID ~= touchedweapon.TextureID then
						primarySkin = touchedweapon.TextureID
					else
						primarySkin = ""
					end]]
				end
				if ammo12 and ammo13 then
					ammocount=ammo12
					primarystored=ammo13
				else
					if realgun~="" then
						ammocount=game.ReplicatedStorage.Weapons[primary].Ammo.Value
						primarystored=game.ReplicatedStorage.Weapons[primary].StoredAmmo.Value
					end
				end
				


			end
			
			
			


if wap:FindFirstChild("Grenade") then
	local received=false
	--[[if grenade ~= "" then
		game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade], Camera.CoordinateFrame, 0, 0, nil, nil, game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
		repeat
			wait()
		until Player:FindFirstChild("DROPPED")
		Player.DROPPED:Destroy()
	end]]
	--[[if grenade2 ~= "" then

		game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade2], Camera.CoordinateFrame, 0, 0, nil, nil, game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
		repeat
			wait()
		until Player:FindFirstChild("DROPPED")
		Player.DROPPED:Destroy()
	end]]
	--[[if grenade3 ~= "" then
		game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade], Camera.CoordinateFrame, 0, 0, nil, nil, game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
		repeat
			wait()
		until Player:FindFirstChild("DROPPED")
		Player.DROPPED:Destroy()
	end]]
	--[[if game.ReplicatedStorage.gametype.Value == "competitive" and grenade4 ~= "" then
		game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade], Camera.CoordinateFrame, 0, 0, nil, nil, game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
		repeat
			wait()
		until Player:FindFirstChild("DROPPED")
		Player.DROPPED:Destroy()
	end]]
	if grenade == "" and received==false then
		received=true
		grenade = wap.Name
		if not touchedweapon then
			clearAll()
			weapons[4]:FindFirstChild("Weapon").ImageTransparency = 0
			if currentTool ~= 4 then
				prevTool = currentTool
				currentTool = 4
			end
		end
	end
	if grenade2 == "" and received==false then
		received=true
		grenade2 = wap.Name
		if not touchedweapon then
			clearAll()
			weapons[5]:FindFirstChild("Weapon").ImageTransparency = 0
			if currentTool ~= 5 then
				prevTool = currentTool
				currentTool = 5
			end
		end
	end
	if grenade3 == "" and received==false then
		received=true
		grenade3 = wap.Name
		if not touchedweapon then
			clearAll()
			weapons[6]:FindFirstChild("Weapon").ImageTransparency = 0
			if currentTool ~= 6 then
				prevTool = currentTool
				currentTool = 6
			end
		end
	end
	if grenade4 == "" and received==false and game.ReplicatedStorage.gametype.Value=="competitive" then
		received=true
		grenade4 = wap.Name
		if not touchedweapon then
			clearAll()
			weapons[7]:FindFirstChild("Weapon").ImageTransparency = 0
			if currentTool ~= 7 then
				prevTool = currentTool
				currentTool = 7
			end
		end
	end
end




		if wap:FindFirstChild("Secondary") then

			if secondary~="" then
				game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[secondary],Camera.CoordinateFrame,ammocount2,secondarystored,special2,secondaryowner,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
							repeat wait() until Player:FindFirstChild("DROPPED")
							--print("dropped")
Player.DROPPED:Destroy()
			end
	special2=sspecial
 			secondary=wap.Name
			if equipped=="secondary" then
			autoequip()
			end
			if not touchedweapon then
			--[[	if game.ReplicatedStorage.Weapons[secondary].Model.TextureID ~= selectedweapon.TextureID then
					secondarySkin = selectedweapon.TextureID
				else
					secondarySkin = ""
				end]]
				clearAll()
				weapons[2]:FindFirstChild("Weapon").ImageTransparency = 0
				if currentTool ~= 2 then
					prevTool = currentTool
					currentTool = 2
				end
			
			else
--[[				if game.ReplicatedStorage.Weapons[secondary].Model.TextureID ~= touchedweapon.TextureID then
					secondarySkin = touchedweapon.TextureID
				else
					secondarySkin = ""
				end]]
			end
			if ammo12 and ammo13 then
				ammocount2=ammo12
				secondarystored=ammo13
			else
				if secondary~="" then
					ammocount2=game.ReplicatedStorage.Weapons[secondary].Ammo.Value
					secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
				end
			end


		end
		if wap:FindFirstChild("Equipment2") then
			if equipment2~="" then
				game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[equipment2],Camera.CoordinateFrame,ammocount4,equipment2stored,nil,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
							repeat wait() until Player:FindFirstChild("DROPPED")
			Player.DROPPED:Destroy()
			end
			
			equipment2=wap.Name
			--autoequip()
			if ammo12 and ammo13 then
				ammocount4=ammo12
				equipment2stored=ammo13
			else
				if equipment~="" then
					ammocount3=game.ReplicatedStorage.Weapons[equipment].Ammo.Value
					equipmentstored=game.ReplicatedStorage.Weapons[equipment].StoredAmmo.Value
				end
			end
		end
		--print("pickedup")
		ebounce=false
		ads=false
		updateInventory()
		updateads()
	end
end

end









-----END OF DROP
mouse.WheelForward:connect(function()
	if equipallowed and alive.Value  then
		moveUp()
		makeVisible()
	end
end)

function DropWep()
	if Humanoid and Humanoid.Health>0 then
		ebounce=true
		local doneit=false
if equipped=="primary" then
	doneit=true
	if realgun~="" then
	game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[realgun],Camera.CoordinateFrame,ammocount,primarystored,special,primaryowner,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
	realgun=""
    end
autoequip()
repeat wait() until Player:FindFirstChild("DROPPED")

Player.DROPPED:Destroy()
end
--[[if (equipped=="grenade" or equipped=="grenade2" or equipped=="grenade3" or equipped=="grenade4") and doneit==false then
	doneit=true
	if equipped=="grenade" and grenade~="" then
		game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade],Camera.CoordinateFrame,0,0,nil,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
		grenade=""
	end
	if equipped=="grenade2" and grenade2~="" then
		game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade2],Camera.CoordinateFrame,0,0,nil,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
		grenade2=""
	end
	if equipped=="grenade3" and grenade3~="" then
		game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade3],Camera.CoordinateFrame,0,0,nil,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
		grenade3=""
	   end
	if equipped=="grenade4" and grenade4~="" then
		game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[grenade4],Camera.CoordinateFrame,0,0,nil,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
		grenade4=""
    end
autoequip()
repeat wait() until Player:FindFirstChild("DROPPED")

Player.DROPPED:Destroy()
	end]]
	if equipped=="secondary" and doneit==false then
	doneit=true
	if secondary~="" then
	game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[secondary],Camera.CoordinateFrame,ammocount2,secondarystored,special2,secondaryowner,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
	secondary=""
	end
autoequip()
repeat wait() until Player:FindFirstChild("DROPPED")
Player.DROPPED:Destroy()
	end



	if equipped=="equipment2" and doneit==false then
		
	if equipment2~="" then
	game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[equipment2],Camera.CoordinateFrame,ammocount4,equipment2stored,nil,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
	equipment2=""
	end
	autoequip()
	repeat wait() until Player:FindFirstChild("DROPPED")
	Player.DROPPED:Destroy()
	end
	
	
	ebounce=false
	updateInventory()
	ads=false
	updateads()
	end

end

mouse.KeyDown:connect(function(key)
if key and key:lower() then
if equipped~="equipment" or equipped=="equipment"  and game.ReplicatedStorage.Weapons:FindFirstChild(equipment) and game.ReplicatedStorage.Weapons:FindFirstChild(equipment):FindFirstChild("NotDroppable")==nil then

if key:lower()=="g" and equipallowed==true and ebounce==false and Player:FindFirstChild("DROPPED")==nil and equipped~="melee" and game.ReplicatedStorage.Warmup.Value==false and game.ReplicatedStorage.gametype.Value~="deathmatch" then 
	DropWep()
end
--------------
end
end
	if ebounce==false then
		if equipallowed then
			pcall(function()
				if key:lower() == "q" and prevTool ~= nil and weapons[prevTool].Visible then
					clearAll()
					weapons[prevTool]:FindFirstChild("Weapon").ImageTransparency = 0
					weapons[prevTool].bk.Visible=true
					updatePosition()
					giveTool()
				end
			end)
		end
	end
end)
Buymenuframe = gui:WaitForChild("Buymenu")
UIS.InputBegan:connect(function(key)
	if script.Parent:FindFirstChild("GUI") and (script.Parent.GUI.Main.GlobalChat.ActiveOne.Value==true or script.Parent.GUI.Main.TeamChat.ActiveOne.Value==true) then
		return
	end
	if Buymenuframe.Visible==false and equipallowed then
		if Player.Character and not suitZoom2.Visible and not suitZoom.Visible then	
			if key.KeyCode == Enum.KeyCode.One then
				if weapons[1].Visible then
					clearAll()
					weapons[1]:FindFirstChild("Weapon").ImageTransparency = 0
					weapons[1].bk.Visible=true		
				end
				makeVisible()
			elseif key.KeyCode == Enum.KeyCode.Two then
				if weapons[2].Visible then
					clearAll()
					weapons[2]:FindFirstChild("Weapon").ImageTransparency = 0
					weapons[2].bk.Visible=true		
				end
				makeVisible()
			elseif key.KeyCode == Enum.KeyCode.Three then
				if weapons[3].Visible then
					clearAll()
					weapons[3]:FindFirstChild("Weapon").ImageTransparency = 0
					weapons[3].bk.Visible=true		
				end
				makeVisible()
			elseif key.KeyCode == Enum.KeyCode.Four then
				local bp=false
				if weapons[5].Visible and weapons[4]:FindFirstChild("Weapon").ImageTransparency == 0 and bp==false then
					clearAll()
					weapons[5]:FindFirstChild("Weapon").ImageTransparency = 0
					weapons[5].bk.Visible=true		
					bp=true
				end
				if weapons[6].Visible and weapons[5]:FindFirstChild("Weapon").ImageTransparency == 0 and bp==false then
					clearAll()
					weapons[6]:FindFirstChild("Weapon").ImageTransparency = 0
					weapons[6].bk.Visible=true		
					bp=true
				end
				if weapons[7].Visible and weapons[6]:FindFirstChild("Weapon").ImageTransparency == 0 and bp==false then
					clearAll()
					weapons[7]:FindFirstChild("Weapon").ImageTransparency = 0
					weapons[7].bk.Visible=true		
					bp=true
				end
				if bp==false then
					if weapons[4].Visible then
						clearAll()
						weapons[4]:FindFirstChild("Weapon").ImageTransparency = 0
						weapons[4].bk.Visible=true		
					end
				end
				makeVisible()
			elseif key.KeyCode == Enum.KeyCode.Five then
				if weapons[8].Visible then
					clearAll()
					weapons[8]:FindFirstChild("Weapon").ImageTransparency = 0
					weapons[8].bk.Visible=true		
				end
				makeVisible()
			end
			
			if key.KeyCode == Enum.KeyCode.ButtonY then
				if weapons[1].Visible and weapons[1]:FindFirstChild("Weapon").ImageTransparency ~= 0 then
					clearAll()
					weapons[1]:FindFirstChild("Weapon").ImageTransparency = 0
					weapons[1].bk.Visible=true		
				elseif weapons[2].Visible and weapons[2]:FindFirstChild("Weapon").ImageTransparency ~= 0 then
					clearAll()
					weapons[2]:FindFirstChild("Weapon").ImageTransparency = 0
					weapons[2].bk.Visible=true		
				else
					clearAll()
					weapons[1]:FindFirstChild("Weapon").ImageTransparency = 0		
					weapons[1].bk.Visible=true		
				end
				makeVisible()
			end
		end
		updatePosition()
	end
	

	--[[if key.KeyCode==Enum.KeyCode.ButtonL3 and Character then
	if Character:FindFirstChild("Crouched")==nil then
	local dent=Instance.new("IntValue")
	dent.Parent=Character
	dent.Name="Crouched"
	crouchcooldown=math.min(8,crouchcooldown+2)
	if crouchanim then
	crouchanim:Play(math.max(.4,0.5*(crouchcooldown/4)),nil,nil)
	end
	crouched=true
	elseif Character and Character:FindFirstChild("Crouched") then
		Character.Crouched:Destroy()
		crouched=false
		if crouchanim then
		crouchanim:Stop(math.max(.4,0.5*(crouchcooldown/4)),nil,nil)
		end
		if crouchwalkanim then
		crouchwalkanim:Stop(math.max(.4,2*(crouchcooldown/4)),nil,nil)
		end
	end
	
	end]]
	
	
end)

local myModule = require(game.ReplicatedStorage.GetIcon)
function updateInventory()
	if Player.Character then
		if grenade=="" and grenade2~="" then
			grenade=grenade2
			grenade2=""
			if equipped=="grenade2" then
				equipped="grenade"
				spawn(function()
				usethatgun()
				end)
			end
		end
		if grenade2=="" and grenade3~="" then
			grenade2=grenade3
			grenade3=""
			if equipped=="grenade3" then
				equipped="grenade2"
				spawn(function()
				usethatgun()
				end)
			end
		end
		if grenade3=="" and grenade4~="" then
			grenade3=grenade4
			grenade4=""
			if equipped=="grenade4" then
				equipped="grenade3"
				spawn(function()
				usethatgun()
				end)
			end
		end
		weapons[1].Visible = false
		weapons[2].Visible = false
		weapons[3].Visible = false
		weapons[4].Visible = false
		weapons[5].Visible = false
		weapons[6].Visible = false
		weapons[7].Visible = false
		weapons[8].Visible = false  
		if realgun ~= "" then
			weapons[1]:FindFirstChild("ToolName").Text = GetName.getName(primary)
			weapons[1].Weapon.Image=myModule.getWeaponOfKiller(realgun)
			local color	= Color3.fromRGB(255, 255, 212)
			pcall(function()
				local fakeskin
				pcall(function()
					fakeskin = game.Players.LocalPlayer.SkinFolder[game.Players.LocalPlayer.Status.Team.Value.."Folder"][realgun].Value
				end)
				
				for _,v in pairs(script.Rarities:GetChildren()) do
					if string.find(v.Name, skinname) and string.find(primary, "'") and not string.find(skinname, "Stock") then
						color = script.Colors[v.Value].Value
					elseif not string.find(primary, "'") then
						if fakeskin and string.find(v.Name, fakeskin) and fakeskin ~= "Stock" and string.find(v.Name, realgun) then
							color = script.Colors[v.Value].Value
							weapons[1].ToolName.Text = GetName.getName(primary).." | "..fakeskin
						end
					end
				end
			end)
			weapons[1].ToolName.TextColor3= color
			weapons[1].Weapon.ImageColor3= color
			--weapons[1]:FindFirstChild("ToolName").Text = GetName.getName(primary)
			--weapons[1]:FindFirstChild("ToolName").E.Value = primary
			weapons[1].Visible = true
			
			--weapons[1].Weapon.Image=myModule.getWeaponOfKiller(primary)

		end
		
		if secondary ~= "" then
			weapons[2]:FindFirstChild("ToolName").Text = GetName.getName(secondary) 
			--weapons[2]:FindFirstChild("ToolName").E.Value = secondary
			local color	= Color3.fromRGB(255, 255, 212)
			pcall(function()
				local fakeskin = game.Players.LocalPlayer.SkinFolder[game.Players.LocalPlayer.Status.Team.Value.."Folder"][secondary].Value
				for _,v in pairs(script.Rarities:GetChildren()) do
					if string.find(v.Name, fakeskin) and fakeskin ~= "Stock" and string.find(v.Name, secondary) then
						color = script.Colors[v.Value].Value
						weapons[2].ToolName.Text = GetName.getName(secondary).." | "..fakeskin
					elseif string.find(fakeskin, "Honor") and string.find(v.Name, "Honor") then
						color = script.Colors.Pink.Value
						weapons[2].ToolName.Text = GetName.getName(secondary).." | ".."Honor-bound"
					end
				end
			end)
			weapons[2].ToolName.TextColor3= color
			weapons[2].Weapon.ImageColor3= color
			weapons[2].Visible = true
			weapons[2].Weapon.Image=myModule.getWeaponOfKiller(secondary)

		end
		if melee ~= "" then
			weapons[3]:FindFirstChild("ToolName").Text = GetName.getName(melee) 
			--weapons[3]:FindFirstChild("ToolName").E.Value = melee
			if weapons[3].ToolName.Text ~= "T Knife" and weapons[3].ToolName.Text ~= "CT Knife" then
				weapons[3].ToolName.TextColor3= script.Colors.Knife.Value
				weapons[3].Weapon.ImageColor3= script.Colors.Knife.Value
			end
			weapons[3].Weapon.Image=myModule.getWeaponOfKiller(melee)
			weapons[3].Visible = true
		end
				
		if grenade ~= "" then
			weapons[4]:FindFirstChild("ToolName").Text = grenade
			weapons[4].Weapon.Image=myModule.getWeaponOfKiller(grenade)
			weapons[4].Visible = true
		end

		if grenade2 ~= "" then
			weapons[5]:FindFirstChild("ToolName").Text = grenade2
			weapons[5].Weapon.Image=myModule.getWeaponOfKiller(grenade2)
			weapons[5].Visible = true
		end

		if grenade3 ~= "" then
			weapons[6]:FindFirstChild("ToolName").Text = grenade3
			weapons[6].Weapon.Image=myModule.getWeaponOfKiller(grenade3)
			weapons[6].Visible = true
		end

		if grenade4 ~= "" then
			weapons[7]:FindFirstChild("ToolName").Text = grenade4
			weapons[7].Weapon.Image=myModule.getWeaponOfKiller(grenade4)
			weapons[7].Visible = true
		end		
		if equipment2 ~= "" then
			weapons[8]:FindFirstChild("ToolName").Text = equipment2
			weapons[8].Weapon.Image=myModule.getWeaponOfKiller(equipment2)
			weapons[8].Visible = true
		end
		

	else
		makeInvisible()
	end
	
	updatePosition()
end
-- END OF INVENTORY GUI CODE

function UnCrouch()

local ignore = {Character, Camera, workspace:WaitForChild("Ray_Ignore"), workspace:WaitForChild("Debris"),game.Workspace.Map:WaitForChild("Clips"),game.Workspace.Map:WaitForChild("SpawnPoints")}
	local hit, position, normal = workspace:FindPartOnRayWithIgnoreList(Ray.new(Camera.CoordinateFrame.p, Vector3.new(0, 3, 0)), ignore) 
	crouched = false
	repeat 
		_Run.Stepped:wait() 
		hit, position, normal = workspace:FindPartOnRayWithIgnoreList(Ray.new(Camera.CoordinateFrame.p, Vector3.new(0, 3, 0)), ignore)
		if hit then
			--print(hit.Name)
		end
	until
		not Player.Character or crouched or not Player.Character:FindFirstChild("Head") or (not hit) and crouchJump==false
	if crouched then
		return
	end
	if Character and Character:FindFirstChild("Crouched") then
		Character.Crouched:Destroy()
	end
if crouchanim then
crouchanim:Stop(math.max(.2,0.5*(crouchcooldown/4)),nil,nil)
end
if crouchwalkanim then
crouchwalkanim:Stop(math.max(.2,0.5*(crouchcooldown/4)),nil,nil)
end
end


UIS.InputEnded:connect(function(k)
if k.KeyCode == Enum.KeyCode.ButtonL2 then
	Button2Up()
end
if k.KeyCode == Enum.KeyCode.ButtonL1 then
	walking = false
end
if k.KeyCode == Enum.KeyCode.Tab and game.ReplicatedStorage.Voten.Value==false then
	if game.ReplicatedStorage.gametype.Value~="TTT" then
	--script.Parent:WaitForChild("GUI"):WaitForChild("Scoreboard").Visible = false
	CloseScoreboard()
	end
end
if k.KeyCode == Enum.KeyCode.Tab then
	if game.ReplicatedStorage.gametype.Value=="TTT" then
		script.Parent.GUI.TR.LeaderboardGUI.Visible=false
	end
end
if Character and Humanoid and Humanoid.Health>0 then --k.KeyCode==Enum.KeyCode.ButtonL3 or 
if (k.KeyCode==Enum.KeyCode.LeftControl or k.KeyCode==Enum.KeyCode.C)  and Character and Character:FindFirstChild("Crouched") and Player and Player.Character and UpperTorso then
	UnCrouch()
end -- sorry dev I can't script
if k.KeyCode==Enum.KeyCode.LeftShift and Character and walking==true then
walking=false
		if shiftwalkanim then
		shiftwalkanim:Stop(.4,nil,nil)
		end
end
end
end)

UIS.InputBegan:connect(function(k)
	if script.Parent:FindFirstChild("GUI") and (script.Parent.GUI.Main.GlobalChat.ActiveOne.Value==true or script.Parent.GUI.Main.TeamChat.ActiveOne.Value==true) then
		return
	end
if k.KeyCode == Enum.KeyCode.Tab and game.ReplicatedStorage.Voten.Value==false then
	if game.ReplicatedStorage.gametype.Value~="TTT" then
	GenerateScoreboard()
	end
end
if k.KeyCode == Enum.KeyCode.Tab then
	if game.ReplicatedStorage.gametype.Value=="TTT" then
		script.Parent.GUI.TR.LeaderboardGUI.Visible=true
		game.Workspace.Status.PlayerChanged.Value=game.Workspace.Status.PlayerChanged.Value+1
	end
end
if Character and Humanoid and Humanoid.Health>0 then
if k.KeyCode==Enum.KeyCode.LeftShift and Character and walking==false and crouched==false  then
walking=true
end

if  Character:FindFirstChild("Charging")==nil and (k.KeyCode==Enum.KeyCode.ButtonL3 or k.KeyCode==Enum.KeyCode.LeftControl or k.KeyCode==Enum.KeyCode.C) and Character and Character:FindFirstChild("Crouched")==nil then
	if istenfoot then
		script.Parent.GUI.Vitals.Crouch.Visible = true
	end

local dent=Instance.new("IntValue")
dent.Parent=Character
dent.Name="Crouched"
	crouchcooldown=math.min(8,crouchcooldown+2)

crouched=true
if jumping==true and crouchJump==false then
	crouchJump=true
	if crouchanim then
	crouchanim:Play()
	end
else
	if crouchanim then
	crouchanim:Play(math.max(.3,0.5*(crouchcooldown/4)),nil,nil)
	end
end
elseif Character:FindFirstChild("Charging")==nil and k.KeyCode==Enum.KeyCode.ButtonL3 then
	UnCrouch()
	script.Parent.GUI.Vitals.Crouch.Visible = false
end
--crouch end

end

end)
local events=game.ReplicatedStorage:WaitForChild("Events")
events.PlayLocalSound.OnClientEvent:connect(function(sound)
PlayLocalSound(sound)
end)



local cmodifier=0


local colorscheme=Cnew(210/255,210/255,210/255)
	
local status=game.Workspace:WaitForChild("Status")
function sec2Min(secs)
	local t = {}
	local st = {}
	t[1] = math.floor(secs/3600)
	t[2] = math.floor((secs-(t[1]*3600))/60)
	t[3] = secs-(t[1]*3600)-(t[2]*60)
	for i = 1,3 do
		st[i] = ""
		if t[i] < 10 and i==3 then
			st[i] = "0"
		end
		st[i] = st[i] .. t[i]
	end 
	if t[1] <= 0 then
		return st[2] .. ":" .. st[3]
	else
		return st[1] .. ":" .. st[2] .. ":" .. st[3]
	end
end 

--[[
TTTTTTTTTTTTTTTTTTTTTTT       CCCCCCCCCCCCC      222222222222222    
T:::::::::::::::::::::T    CCC::::::::::::C     2:::::::::::::::22  
T:::::::::::::::::::::T  CC:::::::::::::::C     2::::::222222:::::2 
T:::::TT:::::::TT:::::T C:::::CCCCCCCC::::C     2222222     2:::::2 
TTTTTT  T:::::T  TTTTTTC:::::C       CCCCCC                 2:::::2 
        T:::::T       C:::::C                               2:::::2 
        T:::::T       C:::::C                            2222::::2  
        T:::::T       C:::::C                       22222::::::22   
        T:::::T       C:::::C                     22::::::::222     
        T:::::T       C:::::C                    2:::::22222        
        T:::::T       C:::::C                   2:::::2             
        T:::::T        C:::::C       CCCCCC     2:::::2             
      TT:::::::TT       C:::::CCCCCCCC::::C     2:::::2       222222
      T:::::::::T        CC:::::::::::::::C     2::::::2222222:::::2
      T:::::::::T          CCC::::::::::::C     2::::::::::::::::::2
      TTTTTTTTTTT             CCCCCCCCCCCCC     22222222222222222222
--]]
--CBROArea (ctrl + f to find me ;D )

function ToggleTeamSelection(force)
	if game.ReplicatedStorage.gametype.Value~="TTT" then
		if gui.TeamSelection.Visible == true and force == false then
			gui.TeamSelection.Visible = false
			script.Parent.Music[script.Parent.Music.MusicKit.Value].TeamSelection:Stop()
		else
			script.Parent.Music[script.Parent.Music.MusicKit.Value].TeamSelection:Stop()
			gui.TeamSelection.Visible = true
			if istenfoot then
				if gui.Parent["Menew-XB"].Enabled == false then
					gui.TeamSelection.Grn.Selectable = true
					gui.TeamSelection.Rd.Selectable = true
					gui.TeamSelection.Spec.Selectable = true
				end
			end
				if workspace:FindFirstChild("Map") then
					if workspace.Map:FindFirstChild("Origin") then
						gui.TeamSelection.PlayOn.Text = "Map: "..workspace.Map.Origin.Value
					else
						gui.TeamSelection.PlayOn.Visible = false
					end
					if workspace.Map:FindFirstChild("Gamemode") then
						for i, v in pairs (gui.TeamSelection.Defuse:GetChildren()) do
								v.Visible = false
							end
						for i, v in pairs (gui.TeamSelection.Rescue:GetChildren()) do
								v.Visible = false
							end
					if game.PlaceId == 9198438999 then
						if workspace.Map.Gamemode.Value == "hostages" then
							gui.TeamSelection.Gamemode.Text = "Gamemode: Hostage Rescue"
							gui.TeamSelection.Blue.Role.Text = "Attacking Team"
							gui.TeamSelection.Red.Role.Text = "Defending Team"
							for i, v in pairs (gui.TeamSelection.Rescue:GetChildren()) do
								v.Visible = true
							end
						elseif workspace.Map.Gamemode.Value == "defusal" then
							gui.TeamSelection.Gamemode.Text = "Gamemode: Bomb Defusal"
							for i, v in pairs (gui.TeamSelection.Defuse:GetChildren()) do
								v.Visible = true
							end
						end
					end
				end
					gui.TeamSelection.Spec.Visible=true
					gui.TeamSelection.Spectate.Visible=true
				local num = math.random(1,2)
				spawn(function()
				repeat wait() until script.Parent:FindFirstChild("Loading")==nil
				script.Parent.Music[script.Parent.Music.MusicKit.Value]["10"]:Stop()
				script.Parent.Music[script.Parent.Music.MusicKit.Value].TeamSelection:Play()
				end)
			end
		end
	end
end 
if Player.Status.Team.Value == "Spectator" then
	if game.ReplicatedStorage.gametype.Value~="TTT" then
	ToggleTeamSelection(true)	
	end
end


function updateTS()
gui.TeamSelection.Red.Number.Text=game.Workspace.Status.NumT.Value
gui.TeamSelection.Blue.Number.Text=game.Workspace.Status.NumCT.Value
if game.Workspace.Status.NumT.Value>game.Workspace.Status.NumCT.Value then
gui.TeamSelection.Red.Alert.Visible=true
gui.TeamSelection.Blue.Alert.Visible=false
elseif game.Workspace.Status.NumCT.Value>game.Workspace.Status.NumT.Value then
gui.TeamSelection.Red.Alert.Visible=false
gui.TeamSelection.Blue.Alert.Visible=true
end
end
updateTS()
game.Workspace.Status.NumT.Changed:connect(function()
wait()
updateTS()
end)
game.Workspace.Status.NumCT.Changed:connect(function()
wait()
updateTS()
end)
function JoinTeam(Team)
--	generatePlayers()
	--print("join team fired")
	game.ReplicatedStorage.Events.JoinTeam:FireServer(Team)
	ToggleTeamSelection(false)
	realgun=""
	grenade=""
	grenade2=""
	grenade3=""
	grenade4=""
	if Team=="CT" then
		secondary=CTPrimaryPistol
		secondaryowner = game.Players.LocalPlayer
		if secondary == nil then
			secondary="P2000"	
			--grenade = "Smoke Grenade"
			--warn("Couldn't load CT pistol, defaulted to P2000!")
		end
		ammocount2=game.ReplicatedStorage:WaitForChild("Weapons")[secondary].Ammo.Value
		secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
	elseif Team=="T" then
		secondary="Glock"
		secondaryowner = game.Players.LocalPlayer
		ammocount2=game.ReplicatedStorage:WaitForChild("Weapons")[secondary].Ammo.Value
		secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
	end
end
function PickClass(Class)
--	generatePlayers()
	--print("Local pickclass fired")
	--Class Limits Decided On Server
	game.ReplicatedStorage.Events.PickClass:FireServer(Class)
	--ToggleClassSelection(false)
end
gui.TeamSelection.Grn.MouseButton1Down:connect(function()
	local addition=0
	if game.Players.LocalPlayer.Status.Team.Value=="T" then
		addition=1
	end
	if game.ReplicatedStorage.gametype.Value=="juggernaut" or workspace.Status:FindFirstChild("NumCT").Value <= workspace.Status:FindFirstChild("NumT").Value-addition then 
		if game.Workspace.Status.PlayerLimit.Value>game.Workspace.Status.NumCT.Value then
			script.Parent.Sounds.MenuClick:Play() 
			JoinTeam("CT") 
		end
	end 
end)
gui.TeamSelection.Rd.MouseButton1Down:connect(function() 
	local addition=0
	if game.Players.LocalPlayer.Status.Team.Value=="T" then
		addition=1
	end
	if game.ReplicatedStorage.gametype.Value~="juggernaut" and workspace.Status:FindFirstChild("NumT").Value <= workspace.Status:FindFirstChild("NumCT").Value-addition then 
		if game.Workspace.Status.PlayerLimit.Value>game.Workspace.Status.NumT.Value then
			script.Parent.Sounds.MenuClick:Play() 
			JoinTeam("T") 
		end
	end 
end)
gui.TeamSelection.Spec.MouseButton1Down:connect(function() script.Parent.Sounds.MenuClick:Play() JoinTeam("Spectator")end)

--[[mouse.KeyDown:connect(function(key)
	if key:lower()=="m" then
		ToggleTeamSelection()
	elseif key:lower()=="v" then
		ToggleClassSelection()
	end
end)]]
local xbmenu = gui.Parent["Menew-XB"]
UIS.InputBegan:Connect(function(Key, UI)
	if script.Parent:FindFirstChild("GUI") and (script.Parent.GUI.Main.GlobalChat.ActiveOne.Value==true or script.Parent.GUI.Main.TeamChat.ActiveOne.Value==true) then
		return
	end

	if Key.KeyCode == Enum.KeyCode.ButtonL2 then
		Button2Down()
	end

	if Key.KeyCode == Enum.KeyCode.M and script.Parent.GUI.MapVote.Visible==false and script.Parent.Ban.MainHandler.Visible == false then
		ToggleTeamSelection(false)
	end
	
	-- gamepad garbage by tully
	if Key.KeyCode == Enum.KeyCode.ButtonX then
		
	reloadwep()
	end
	
	if Key.KeyCode == Enum.KeyCode.ButtonL1 and Character and walking==false then
		walking = true
	end

	if Key.KeyCode == Enum.KeyCode.DPadDown then
		DropWep()
	end

--	if Key.KeyCode == Enum.KeyCode.DPadUp then
--	if equipallowed==true and ebounce==false and Player:FindFirstChild("DROPPED")==nil and equipped~="melee" then
--	if inspectani and inspectani.IsPlaying==false then
--	if DISABLED==false and inspectani then
--	inspectani:Play()
--	end
--	end
--	end	
--	end
	if Key.KeyCode == Enum.KeyCode.ButtonB then
		if InvenFrame.Visible then
			xbmenu.Enabled = true
			_gui.SelectedObject = xbmenu.MainFrame.Inventory
			InvenFrame.Visible = false
		end
	end
	--if xbmenu.ShopFrame.Position.X.Scale >= .1 then
	if istenfoot then
		if Key.KeyCode == Enum.KeyCode.DPadUp then
			--print(tostring(xbmenu.MainFrame.Visible) .. " is visibility on mainframe")
			if xbmenu.MainFrame.Visible == false and gui.MapVote.Visible == false then
				xbmenu.MainFrame.Visible = true
				xbmenu.MainFrame.Position = UDim2.new(0,0,0,0)
				xbmenu.Enabled = true
				print ' updated '
				xbmenu.ShopFrame.Visible = false
				_gui.SelectedObject = xbmenu.MainFrame.PlayNow
			end
		end
	end
	if Key.KeyCode == Enum.KeyCode.ButtonR3 then

		--changeburstmode()
		if equipped ~= "melee" then
		equipped="melee"
		gun=game.ReplicatedStorage.Weapons[melee]
		usethatgun()
		end

	end
	

	if Key.KeyCode == Enum.KeyCode.DPadLeft then
		spawn(function() 
			wait(.18)
			if UIS:IsKeyDown(Enum.KeyCode.DPadLeft) then
				equipped="grenade" print("howdy")
				spawn(function()
				usethatgun()
				end)
			end
		end)
		if equipallowed and alive.Value then
		moveDown()
		makeVisible()
		end
		
	end
	
	if Key.KeyCode == Enum.KeyCode.DPadRight then
		if equipallowed and alive.Value then
		moveUp()
		makeVisible()
		end

	end
	
	
	
end)



--[[
	temp crosshair system
	
--]]

CHwideness=7
Crosshairs = gui:WaitForChild("Crosshairs")
Crosshair = Crosshairs:WaitForChild("Crosshair")
CrosshairCustom = gui:WaitForChild("CrosshairCustom")
vipmenu = gui:WaitForChild("vipmenu")
Preview = CrosshairCustom:WaitForChild("Crosshair")
RbxGui = require(game:GetService("ReplicatedStorage"):WaitForChild("LoadLibrary"):WaitForChild("RbxGui"))
CrosshairData = game.ReplicatedStorage.Events.DataFunction:InvokeServer({"GetCrosshair"})
if CrosshairData[9]==nil then
	CrosshairData[9]=0
end
cdynamic = CrosshairData[4]
cdot = CrosshairData[5]
cdecalch = CrosshairData[9]
CHtransparency = CrosshairData[6]
CHthicc = CrosshairData[7]
CHwideness = CrosshairData[8]
DefaultColor = Color3.new(1/255,1,1/255)
currentR = CrosshairData[1]
currentG = CrosshairData[2]
currentB = CrosshairData[3]
if cdecalch==nil then
	cdecalch=0
end
	if cdynamic==false then
		CrosshairCustom.dynamic.Text = "OFF"
	else
		CrosshairCustom.dynamic.Text = "ON"
	end	
	
	if cdot==false then
		CrosshairCustom.dot.Text = "OFF"
		CrosshairCustom.Crosshair.Dot.Visible = false
		Crosshair.Dot.Visible = false
	else		
		CrosshairCustom.dot.Text = "ON"
		CrosshairCustom.Crosshair.Dot.Visible = true
		Crosshair.Dot.Visible = true
	end	
function decalIdFromAssetId(assetId)
	local startingid = assetId
	local index = 0
	local ms = game:GetService("MarketplaceService")
	local orig = ms:GetProductInfo(startingid)
	local newid = 0
	local st=tick()
	repeat 
	    index = index+1
	    local newindex = startingid-index
	    local newname = ms:GetProductInfo(newindex)
	    _Run.Stepped:wait()
	    if orig.Name == newname.Name then
	        newid = newindex
	        break
	    end
		if (tick()-st)>=2 then
			break
		end
	until orig.Name == newname.Name
	return newid
end


CrosshairCustom.decalid.Text=cdecalch

CrosshairData = {currentR,currentG,currentB,cdynamic,cdot,CHtransparency,CHthicc,CHwideness,cdecalch}

if CHwideness==nil then
	CHwideness=7
end
local lp = game.Players.LocalPlayer
local mouse	= lp:GetMouse()
local cam = game.Workspace.CurrentCamera
local list = {"Dex", "Plorer", "Exo", "Ro-Ex", "T0p", "Topk", "Rasp", "ManE", "Moon", "Explor", "Rock", "BoxHandleAdornment", "3ds", "SelectionBox", "SphereHandleAdornment", "SelectionPartLasso", "cham", "%$#@$!&"}
local encountered = 0
local wait = wait

for _,v in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
	for _,c in pairs(v:GetChildren()) do
		if string.find(c.ClassName, "Value") then
			c:GetPropertyChangedSignal("Value"):connect(function()
				coroutine.wrap(function()
					pcall(function()
						lp:Kick("\nWeapon Stat Change.")
					end)
				end)()
				
				wait(0.15)
				
				while true do end
			end)
		end
	end
end

game.Workspace.ChildAdded:connect(function(child)
	wait(0.15)
	
	if child.Name == "Map" then
		for _,c in pairs(child:GetDescendants()) do
			if c:IsA("BasePart") then
				c:GetPropertyChangedSignal("Parent"):connect(function()
					wait(0.15)
					
					if c.Parent == game.Workspace.Ray_Ignore then
						coroutine.wrap(function()
							pcall(function()
								lp:Kick("\nMap Noclipping.")
							end)
						end)()
						
						wait(0.15)
						
						while true do end
					end
				end)
			end
		end
	end
end)

lp.PlayerGui.DescendantAdded:connect(function(obj)
	if obj:IsA("BoxHandleAdornment") then
		coroutine.wrap(function()
			pcall(function()
				lp:Kick("\nESP.")
			end)
		end)()
		
		wait(0.15)
		
		while true do end
	end
end)

game.Workspace:GetPropertyChangedSignal("Gravity"):connect(function()
	if game.Workspace.Gravity <= 125 then
		coroutine.wrap(function()
			pcall(function()
				lp:Kick("\nGravity Spoofing.")
			end)
		end)()
		
		wait(0.15)
		
		while true do end
	end
end)

local function setupChar(char)
	local head = char:WaitForChild("Head")
		
	head:GetPropertyChangedSignal("Size"):connect(function()
		if head.Size.X > 3.5 then
			coroutine.wrap(function()
				pcall(function()
					lp:Kick("\nBig Head Aimbot.")
				end)
			end)()
			
			wait(0.15)
				
			while true do end
		end
	end)
	
	head.ChildAdded:connect(function(obj)
		wait(0.15)
		
		if obj:IsA("BoxHandleAdornment") then
			coroutine.wrap(function()
				pcall(function()
					lp:Kick("\nAttempt to bypass RAC.")
				end)
			end)()
			
			wait(0.15)
				
			while true do end
		end
	end)
	
	char:WaitForChild("Humanoid"):GetPropertyChangedSignal("JumpPower"):connect(function()
		if char.Humanoid.JumpPower >= 60 then
			coroutine.wrap(function()
				pcall(function()
					lp:Kick("\nJumpPower Spoofing.")
				end)
			end)()
			
			wait(0.15)
			
			while true do end
		elseif char.Humanoid.WalkSpeed >= 50 then
			coroutine.wrap(function()
				pcall(function()
					lp:Kick("\nWalkSpeed Spoofing.")
				end)
			end)()
			
			wait(0.15)
			
			while true do end
		end
	end)
	
	char:WaitForChild("HumanoidRootPart").ChildAdded:connect(function(obj)
		wait(0.15)
		
		if obj:IsA("SurfaceGui") then
			local uis = 0
			
			for _,v in pairs(char.HumanoidRootPart:GetChildren()) do
				if v:IsA("SurfaceGui") and v.Name ~= "Bullet" then
					uis = uis+1
				end
			end
			
			if uis >= 1 then
				coroutine.wrap(function()
					pcall(function()
						lp:Kick("\nChams/Esp.")
					end)
				end)()
				
				wait(0.15)
					
				while true do end
			end
		elseif obj:IsA("Weld") or obj:IsA("ManualWeld") then
			if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and obj.Part1 == lp.Character.HumanoidRootPart then
				for _,v in pairs(game.Players:GetChildren()) do
					if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v ~= lp and obj.Part0 == v.Character.HumanoidrootPart then
						coroutine.wrap(function()
							pcall(function()
								lp:Kick("\nEnemy Teleport.")
							end)
						end)()
						
						wait(0.15)
							
						while true do end
					end
				end
			end
		end
	end)
	
	char.ChildAdded:connect(function(obj)
		if obj.Name == "Head" or obj.Name == "HumanoidRootPart" then
			local headcount = 0
			local rootpartcount = 0
			
			for _,v in pairs(char:GetChildren()) do
				if v.Name == "Head" then
					headcount = headcount+1
					
				elseif v.Name == "HumanoidRootPart" then
					rootpartcount = rootpartcount+1
				end
			end
			
			if headcount > 1 or rootpartcount > 1 then
				coroutine.wrap(function()
					pcall(function()
						lp:Kick("\nParts Aimbot.")
					end)
				end)()
					
				wait(0.15)
					
				while true do end
			end
		end
		
		if obj:IsA("HopperBin") then
			coroutine.warp(function()
				pcall(function()
					lp:Kick("\nBtools.")
				end)
			end)()
			
			wait(0.15)
				
			while true do end
		end
	end)
end

local function setupPlr(plr)
	plr:WaitForChild("Backpack").ChildAdded:connect(function(obj)
		if obj:IsA("HopperBin") then
			coroutine.warp(function()
				pcall(function()
					lp:Kick("\nBtools.")
				end)
			end)()
			
			wait(0.15)
				
			while true do end
		end
	end)
end

game.StarterGui.ChildAdded:connect(function(obj)
	if obj:IsA("ScreenGui") and obj.Name == "Gui" then
		coroutine.wrap(function()
			pcall(function()
				lp:Kick("\nStalin's CB:RO Gui")
			end)
		end)()
		
		wait(0.15)
			
		while true do end
	end
end)

local function AimAt(x, y)
	local vps = cam.ViewportSize
	local vpsx = vps.X
	local vpsy = vps.Y
	local screencenterx = vpsx/2
	local screencentery = vpsy/2
	local aimspeed = 5
	local aimatx
	local aimaty

	if x ~= 0 then
		if x > screencenterx then
			aimatx = -(screencenterx - x)
			aimatx = aimatx/aimspeed
			if aimatx + screencenterx > screencenterx * 2 then
				aimatx = 0
			end
		end
		if x < screencenterx then
			aimatx = x - screencenterx
			aimatx = aimatx/aimspeed
			if aimatx + screencenterx < 0 then
				aimatx = 0
			end
		end
	end
	
	if y ~= 0 then
		if y > screencentery then
			aimaty = -(screencentery - y)
			aimaty = aimaty/aimspeed
			if aimaty + screencentery > screencentery * 2 then
				aimaty = 0
			end
		end
		if y < screencentery then
			aimaty = y - screencentery
			aimaty = aimaty/aimspeed
			if aimaty + screencentery < 0 then
				aimaty = 0
			end
		end
	end
	
	return aimatx, aimaty
end

cam:GetPropertyChangedSignal("CFrame"):connect(function()
	for _,v in pairs(game.Players:GetChildren()) do
		pcall(function()
			if v:IsA("Player") and v.Character and v ~= lp and v.Character:FindFirstChild("Head") then
				local viewpoint = cam:WorldToScreenPoint(v.Character.Head.Position)
				local xdis, ydis = AimAt(viewpoint.X, viewpoint.Y+32)
				if v ~= lp and v.Team ~= lp.Team and lp.Character and lp.Character:FindFirstChild("Head") and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0 and (lp.TeamColor == game.Teams.Terrorists.TeamColor or lp.TeamColor == game.Teams) and v.Character and v.Character:FindFirstChild("Head") and (cam.CFrame == CFrame.new(cam.CFrame.p, v.Character.Head.Position) or cam.CFrame == CFrame.new(cam.CFrame.p, v.Character.Head.Position)*CFrame.new(0, 0, 0.5) or cam.CFrame == CFrame.new(cam.Focus.p, v.Character.Head.Position) or cam.CFrame == CFrame.new(cam.Focus.p, v.Character.Head.Position)*CFrame.new(0, 0, 0.5)) or cam.CFrame == CFrame.new(cam.CFrame.p, v.Character.Head.Position+Vector3.new(0.01, 0.01, 0.01)) and not game.Workspace.Camera:FindFirstChild("Crate") then
					encountered = encountered+1
		
					if encountered > 35 then
						--local rac	= grab:InvokeServer("RAC", "\nRAC Banned\nReason:\nAimbotting.")
						
						--coroutine.wrap(function()
						--	lp:Kick("\nAimbotting.")
					--end)()
						
						--wait(0.15)
							
					--	while true do end
						print("Hit in the center exact")
					end
				end
			end
		end)
	end
end)

for _,plr in pairs(game.Players:GetChildren()) do
	setupPlr(plr)
	
	plr.CharacterAdded:connect(function(char)
		setupChar(char)
		
		if plr == lp then
			encountered	= 0
		end
	end)
end

game.Players.PlayerAdded:connect(function(plr)
	setupPlr(plr)
	
	plr.CharacterAdded:connect(function(char)
		setupChar(char)
	end)
end)

game.DescendantAdded:connect(function(obj)
	pcall(function()
		local parent = "No Parent"
	
		local backup = pcall(function() parent = obj.Parent end)
		
		pcall(function()
			if obj:IsA("Explosion") and obj.Name ~= "BoomBoom" then
				coroutine.warp(function()
					pcall(function()
						lp:Kick("\nBtools.")
					end)
				end)()
				
				wait(0.15)
					
				while true do end
			end
		end)
		
		if not backup and parent == "No Parent" then
			local othercheck	= string.gsub(tostring(obj), "User-", "")
			for _,v in pairs(list) do
				if string.find(string.lower(tostring(obj)), string.lower(v)) and not game.Players:FindFirstChild(tostring(obj)) and not string.find(string.lower(tostring(obj), "user-")) and not game.Players:FindFirstChild(othercheck) then
					coroutine.warp(function()
						pcall(function()
							lp:Kick("\nTried Injecting "..tostring(obj)..".")
						end)
					end)()
					
					wait(0.15)
						
					while true do end
					
					wait(0.1)
					
					script.Disabled = true
					script.Parent.RACBackup.Disabled = true
					script:Destroy()
					script.Parent.RACBackup:Destroy()
				end
			end	
		end
		
		if (not list or #list < 18) then
			coroutine.warp(function()
				pcall(function()
					lp:Kick("\nTried changing my list.")
				end)
			end)()
			
			wait(0.15)
				
			while true do end
		end
	end)
end)
--CrosshairData = game.ReplicatedStorage.Events.DataFunction:InvokeServer({"GetCrosshair"})

function updatecrosshair()
	CrosshairData = {currentR,currentG,currentB,cdynamic,cdot,CHtransparency,CHthicc,CHwideness,cdecalch}
	local r,g,b,trans,thicc,wide,dot,decalch,dynamic = nil
	r = CrosshairData[1]
	g = CrosshairData[2]
	b = CrosshairData[3]
	dynamic = CrosshairData[4]
	dot = CrosshairData[5]
	trans = CrosshairData[6]
	thicc = CrosshairData[7]
	wide = CrosshairData[8]
	decalch = CrosshairData[9]
	Crosshair.BottomFrame.BackgroundColor3 = Color3.fromRGB(r,g,b)
	Crosshair.LeftFrame.BackgroundColor3 = Color3.fromRGB(r,g,b)
	Crosshair.RightFrame.BackgroundColor3 = Color3.fromRGB(r,g,b)
	Crosshair.TopFrame.BackgroundColor3 = Color3.fromRGB(r,g,b)
	Crosshair.Dot.BackgroundColor3 = Color3.fromRGB(r,g,b)
	
	Crosshair.BottomFrame.BorderColor3 = Color3.fromRGB(r,g,b)
	Crosshair.LeftFrame.BorderColor3 = Color3.fromRGB(r,g,b)
	Crosshair.RightFrame.BorderColor3 = Color3.fromRGB(r,g,b)
	Crosshair.TopFrame.BorderColor3 = Color3.fromRGB(r,g,b)
	Crosshair.Dot.BorderColor3 = Color3.fromRGB(r,g,b)
	
	Crosshair.BottomFrame.BackgroundTransparency = trans
	Crosshair.LeftFrame.BackgroundTransparency = trans
	Crosshair.RightFrame.BackgroundTransparency = trans
	Crosshair.TopFrame.BackgroundTransparency = trans
	Crosshair.Dot.BackgroundTransparency = trans
	
	Crosshair.BottomFrame.BorderSizePixel = thicc
	Crosshair.LeftFrame.BorderSizePixel = thicc
	Crosshair.RightFrame.BorderSizePixel = thicc
	Crosshair.TopFrame.BorderSizePixel = thicc
	Crosshair.Dot.BorderSizePixel = thicc
	Crosshair.RightFrame.Visible=true
	Crosshair.LeftFrame.Visible=true
	Crosshair.TopFrame.Visible=true
	Crosshair.BottomFrame.Visible=true		
	if dot then
		Crosshair.Dot.Visible = true
	else
		Crosshair.Dot.Visible = false
	end
	Crosshair.Center1.Visible=false
	Crosshair.Center1.ImageTransparency=trans
	Crosshair.Center1.ImageColor3=Color3.fromRGB(r,g,b)
	if decalch>0 then
		Crosshair.RightFrame.Visible=false
		Crosshair.LeftFrame.Visible=false
		Crosshair.TopFrame.Visible=false
		Crosshair.BottomFrame.Visible=false
		Crosshair.Dot.Visible=false
		Crosshair.Center1.Visible=true
		Crosshair.Center1.Image="rbxassetid://"..decalch
	end
	--print(wide)
	Crosshair.BottomFrame.Position=UDim2.new(0, -1, 0, -(Preview.LeftFrame.Size.X.Offset+wide))
	Crosshair.LeftFrame.Position=UDim2.new(0, -(Preview.LeftFrame.Size.X.Offset+wide),0,-1)
	Crosshair.RightFrame.Position=UDim2.new(0, wide, 0, -1)
	Crosshair.TopFrame.Position=UDim2.new(0,-1,0,wide)	
end
function updatecrosshairpreview()
	CrosshairData = {currentR,currentG,currentB,cdynamic,cdot,CHtransparency,CHthicc,CHwideness,cdecalch}
	local r,g,b,trans,thicc,wide = nil
	r = CrosshairData[1]
	g = CrosshairData[2]
	b = CrosshairData[3]
	dynamic = CrosshairData[4]
	dot = CrosshairData[5]
	trans = CrosshairData[6]
	thicc = CrosshairData[7]
	wide = CrosshairData[8]
	decalch=CrosshairData[9]
	local Crosshair = Preview
	Crosshair.BottomFrame.BackgroundColor3 = Color3.fromRGB(r,g,b)
	Crosshair.LeftFrame.BackgroundColor3 = Color3.fromRGB(r,g,b)
	Crosshair.RightFrame.BackgroundColor3 = Color3.fromRGB(r,g,b)
	Crosshair.TopFrame.BackgroundColor3 = Color3.fromRGB(r,g,b)
	Crosshair.Dot.BackgroundColor3 = Color3.fromRGB(r,g,b)
	
	Crosshair.BottomFrame.BorderColor3 = Color3.fromRGB(r,g,b)
	Crosshair.LeftFrame.BorderColor3 = Color3.fromRGB(r,g,b)
	Crosshair.RightFrame.BorderColor3 = Color3.fromRGB(r,g,b)
	Crosshair.TopFrame.BorderColor3 = Color3.fromRGB(r,g,b)
	Crosshair.Dot.BorderColor3 = Color3.fromRGB(r,g,b)
	
	Crosshair.BottomFrame.BackgroundTransparency = trans
	Crosshair.LeftFrame.BackgroundTransparency = trans
	Crosshair.RightFrame.BackgroundTransparency = trans
	Crosshair.TopFrame.BackgroundTransparency = trans
	Crosshair.Dot.BackgroundTransparency = trans
	
	Crosshair.BottomFrame.BorderSizePixel = thicc
	Crosshair.LeftFrame.BorderSizePixel = thicc
	Crosshair.RightFrame.BorderSizePixel = thicc
	Crosshair.TopFrame.BorderSizePixel = thicc
	Crosshair.Dot.BorderSizePixel = thicc
	Crosshair.RightFrame.Visible=true
	Crosshair.LeftFrame.Visible=true
	Crosshair.TopFrame.Visible=true
	Crosshair.BottomFrame.Visible=true	
	if dot then
		Crosshair.Dot.Visible = true
	else
		Crosshair.Dot.Visible = false
	end
	Crosshair.Center1.Visible=false
	Crosshair.Center1.ImageTransparency=trans
	Crosshair.Center1.ImageColor3=Color3.fromRGB(r,g,b)
	if decalch>0 then
		Crosshair.RightFrame.Visible=false
		Crosshair.LeftFrame.Visible=false
		Crosshair.TopFrame.Visible=false
		Crosshair.BottomFrame.Visible=false
		Crosshair.Dot.Visible=false
		Crosshair.Center1.Visible=true
		Crosshair.Center1.Image="rbxassetid://"..decalch
		local saz=(wide+Crosshair.RightFrame.Size.X.Offset+Crosshair.RightFrame.BorderSizePixel)*2
		saz=saz+(saz%2)
		Crosshair.Center1.Size=UDim2.new(0,saz,0,saz)
		Crosshair.Center1.Position=UDim2.new(0,-saz/2,0,-saz/2)
	end
	Crosshair.BottomFrame.Position=UDim2.new(0, -1, 0, -(Preview.LeftFrame.Size.X.Offset+wide))
	Crosshair.LeftFrame.Position=UDim2.new(0, -(Preview.LeftFrame.Size.X.Offset+wide),0,-1)
	Crosshair.RightFrame.Position=UDim2.new(0, wide, 0, -1)
	Crosshair.TopFrame.Position=UDim2.new(0,-1,0,wide)	
end
updatecrosshair()
updatecrosshairpreview()
loc = script.Parent

Rslider,RsliderPos = RbxGui.CreateSlider(256,150,UDim2.new(0.05,0,0.4,0))
Rslider.Parent = CrosshairCustom
Rslider.Bar.BackgroundColor3 = Color3.new(1,0,0)
Rslider.Bar.Slider.ImageColor3 = Color3.new(1,0,0)
Rslider.SliderPosition.Value = currentR

function onChangedR(val)
	--print("Slider value changed:",val)
	currentR = val - 1
	updatecrosshairpreview()
	updatecrosshair()
end

RsliderPos.Changed:connect(onChangedR)


Gslider,GsliderPos = RbxGui.CreateSlider(256,150,UDim2.new(0.05,0,0.5,0))
Gslider.Parent = CrosshairCustom
Gslider.Bar.BackgroundColor3 = Color3.new(0,1,0)
Gslider.Bar.Slider.ImageColor3 = Color3.new(0,1,0)
Gslider.SliderPosition.Value = currentG
function onChangedG(val)
	--print("Slider value changed:",val)
	currentG = val - 1
	updatecrosshairpreview()
	updatecrosshair()
end
 
GsliderPos.Changed:connect(onChangedG)


Bslider,BsliderPos = RbxGui.CreateSlider(256,150,UDim2.new(0.05,0,0.6,0))
Bslider.Parent = CrosshairCustom
Bslider.Bar.BackgroundColor3 = Color3.new(0,0,1)
Bslider.Bar.Slider.ImageColor3 = Color3.new(0,0,1)
Bslider.SliderPosition.Value = currentB
function onChangedB(val)
	--print("Slider value changed:",val)
	currentB = val - 1
	updatecrosshairpreview()
	updatecrosshair()
end
 
BsliderPos.Changed:connect(onChangedB)


Spreadslider,SpreadsliderPos = RbxGui.CreateSlider(50,150,UDim2.new(0.05,0,0.7,0))
Spreadslider.Parent = CrosshairCustom
Spreadslider.SliderPosition.Value = CHwideness
local function onChangedSpread(val)
	val=val-1
	CHwideness=val
	--print("Slider value changed:",val)
	updatecrosshairpreview()
	updatecrosshair()
	
	
end
SpreadsliderPos.Changed:connect(onChangedSpread)

thiccslider,thiccsliderPos = RbxGui.CreateSlider(6,150,UDim2.new(0.05,0,0.8,0))
thiccslider.Parent = CrosshairCustom

function onChangedthicc(val)
	--print("Slider value changed:",val)
	CHthicc= val - 1
	updatecrosshairpreview()
	updatecrosshair()
end
 
thiccsliderPos.Changed:connect(onChangedthicc)

transslider,transsliderPos = RbxGui.CreateSlider(10,150,UDim2.new(0.05,0,0.9,0))
transslider.Parent = CrosshairCustom

function onChangedtrans(val)
	--print("Slider value changed:",val)
	CHtransparency= (val - 1)/10
	updatecrosshairpreview()
	updatecrosshair()
end
 
transsliderPos.Changed:connect(onChangedtrans)




CrosshairCustom.toggledynamic.MouseButton1Down:connect(function()
	if cdynamic then
		cdynamic = false
		CrosshairCustom.dynamic.Text = "OFF"
	else
		cdynamic = true
		CrosshairCustom.dynamic.Text = "ON"
	end	
	updatecrosshairpreview()
	updatecrosshair()
end)
CrosshairCustom.toggledot.MouseButton1Down:connect(function()
	if cdot then
		cdot = false
		CrosshairCustom.dot.Text = "OFF"
		CrosshairCustom.Crosshair.Dot.Visible = false
		Crosshair.Dot.Visible = false
	else		
		cdot = true
		CrosshairCustom.dot.Text = "ON"
		CrosshairCustom.Crosshair.Dot.Visible = true
		Crosshair.Dot.Visible = true
	end	
	updatecrosshair()
	updatecrosshairpreview()
end)
CrosshairCustom.decalid.FocusLost:connect(function()
	cdecalch=0
	if tonumber(CrosshairCustom.decalid.Text) and tonumber(CrosshairCustom.decalid.Text)>0 then
		cdecalch=decalIdFromAssetId(tonumber(CrosshairCustom.decalid.Text))
	end
	CrosshairCustom.decalid.Text=cdecalch
	updatecrosshairpreview()
	updatecrosshair()
end)



--[[
	temp crosshair system
	
--]]
--[[
	                     _                         _  
                        | |                       | | 
  ___  ___ ___  _ __ ___| |__   ___   __ _ _ __ __| | 
 / __|/ __/ _ \| '__/ _ \ '_ \ / _ \ / _` | '__/ _` | 
 \__ \ (_| (_) | | |  __/ |_) | (_) | (_| | | | (_| | 
 |___/\___\___/|_|  \___|_.__/ \___/ \__,_|_|  \__,_| 
           (_)                | |                     
  ___ _ __  _  ___ ___ _   _  | |__   ___  _   _  ___ 
 / __| '_ \| |/ __/ _ \ | | | | '_ \ / _ \| | | |/ _ \
 \__ \ |_) | | (_|  __/ |_| | | |_) | (_) | |_| |  __/
 |___/ .__/|_|\___\___|\__, | |_.__/ \___/ \__, |\___|
     | |                __/ |               __/ |     
     |_|               |___/               |___/      

--]]
--scoreboard area
--scoreboard
Scoreboard = gui:WaitForChild("Scoreboard")
CTConstraint = Scoreboard:WaitForChild("CT")
TConstraint = Scoreboard:WaitForChild("T")
function GenerateScoreboard()
	for _,v in pairs(script.Parent.GUI.Scoreboard.CT:GetChildren()) do
		if v.Name ~= "UIGridLayout" then
			v:Destroy()
		end		
	end
	
	for _,v in pairs(script.Parent.GUI.Scoreboard.T:GetChildren()) do
		if v.Name ~= "UIGridLayout" then
			v:Destroy()
		end		
	end
	
	if game.ReplicatedStorage.gametype.Value=="TTT" then
		return
	end
	--print('scoreboard opened ')
	local boye= game.Players:GetPlayers()
	local CTY = 0
	local TY = 0
	local players = {}
		for i, v in pairs (game.Players:GetPlayers()) do
			if v:FindFirstChild("Score") then
				if #players ~= 0 then
					for j = 1, #players do
						if v.Score.Value >= players[j].Score.Value then
							table.insert(players, j, v)
							break
						end
						if j == #players then
							table.insert(players, v)
						end
					end
				else
					table.insert(players, v)
				end
			end
		end
		
		
	for i=1, #players do
		if players[i].Status.Team.Value == "CT" or players[i].Status.Team.Value == "T" then
			local playerimg = nil
			
			if players[i].Status.Team.Value == "CT" then
				playerimg = script.CTFrame:Clone()
				CTY = CTY + .1
				playerimg.Parent = CTConstraint
				if players[i].Status.Alive.Value==false then
					playerimg.BackgroundColor3=Color3.new(96/2/255,147/2/255,175/2/255)
				end
			elseif players[i].Status.Team.Value == "T" then
				playerimg = script.TFrame:Clone()
				TY = TY + .1
				playerimg.Parent = TConstraint
				if players[i].Status.Alive.Value==false then
					playerimg.BackgroundColor3=Color3.new(185/2/255,156/2/255,120/2/255)
				end
			end	
			coroutine.wrap(function()
				if playerimg then
					playerimg.Pin.Visible   = false
					local pin = players[i].EquippedPin.Value
					if pin then
						playerimg.Pin.Visible	= true
						playerimg.Pin.Image		= pin
					end
				end
			end)()

				playerimg.player.Text = players[i].Name
				--playerimg.IMGFrame.PlayerIMG.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..players[i].userId.."&width=420&height=420&format=png"
				playerimg.Visible = true
				
				playerimg.kills.Text = players[i].Status.Kills.Value
				playerimg.assists.Text = players[i].Status.Assists.Value
				playerimg.deaths.Text = players[i].Status.Deaths.Value
				playerimg.MVP.Count.Text = players[i].Status.MVPs.Value
				playerimg.ping.Text = players[i].Ping.Value
				playerimg.score.Text=players[i].Score.Value
				if game.ReplicatedStorage.gametype.Value=="deathmatch" then
					playerimg.score.Text=players[i].Status.Score.Value
				end
				--but kills deaths etc here as well			
		end
	end
	Scoreboard.Visible = true
end

game.ReplicatedStorage.Voten.Changed:Connect(function()
	wait()
if game.ReplicatedStorage.Voten.Value == false then

else
	
		GenerateScoreboard()
end
	
end)

if game.ReplicatedStorage.Voten.Value==true then
	GenerateScoreboard()
	if script.Parent.GUI.TeamSelection.Visible then
		if game.ReplicatedStorage.gametype.Value~="TTT" then
			ToggleTeamSelection()
		end
	end
end



function CloseScoreboard()
	Scoreboard.Visible = false
	local bob=CTConstraint:GetChildren()
	for i=1,#bob do
		if bob[i]:IsA("Frame") then
			bob[i]:Destroy()
		end
	end
	local bob=TConstraint:GetChildren()
	for i=1,#bob do
		if bob[i]:IsA("Frame") then
			bob[i]:Destroy()
		end
	end
end
--[[
	                     _                         _  
                        | |                       | | 
  ___  ___ ___  _ __ ___| |__   ___   __ _ _ __ __| | 
 / __|/ __/ _ \| '__/ _ \ '_ \ / _ \ / _` | '__/ _` | 
 \__ \ (_| (_) | | |  __/ |_) | (_) | (_| | | | (_| | 
 |___/\___\___/|_|  \___|_.__/ \___/ \__,_|_|  \__,_| 
           (_)                | |                     
  ___ _ __  _  ___ ___ _   _  | |__   ___  _   _  ___ 
 / __| '_ \| |/ __/ _ \ | | | | '_ \ / _ \| | | |/ _ \
 \__ \ |_) | | (_|  __/ |_| | | |_) | (_) | |_| |  __/
 |___/ .__/|_|\___\___|\__, | |_.__/ \___/ \__, |\___|
     | |                __/ |               __/ |     
     |_|               |___/               |___/      

--]]

--[[
	
  _                                              
 | |                                             
 | |__  _   _ _   _   _ __ ___   ___ _ __  _   _ 
 | '_ \| | | | | | | | '_ ` _ \ / _ \ '_ \| | | |
 | |_) | |_| | |_| | | | | | | |  __/ | | | |_| |
 |_.__/ \__,_|\__, | |_| |_| |_|\___|_| |_|\__,_|
               __/ |                             
              |___/                              

--]]

--BuyMenu
--buymenu
--buy menu

--init butts


CircleI = Buymenuframe:WaitForChild("Circle")

CircleChildren = CircleI:GetChildren()
CurrentlyHighlighted = nil
Base = Buymenuframe:WaitForChild("Base")
Outline = Base:WaitForChild("Outline")
AutoBuy = Outline:WaitForChild("AutoBuy")
BuyPrev = Outline:WaitForChild("BuyPrev")
Close = Outline:WaitForChild("Close")
List = Buymenuframe:WaitForChild("List")
GunStats = Buymenuframe:WaitForChild("GunStats")

GetIcon = require(game.ReplicatedStorage.GetIcon)
GetPrice = require(game.ReplicatedStorage.GetPrices)
GetName = require(game.ReplicatedStorage.GetTrueName)
Selected = {	
	"http://www.roblox.com/asset/?id=904060545",
	"http://www.roblox.com/asset/?id=904060701",
	"http://www.roblox.com/asset/?id=903254694",
	"http://www.roblox.com/asset/?id=904060859",
	"http://www.roblox.com/asset/?id=904061070",
	"http://www.roblox.com/asset/?id=903255023"	,
	
}
Normal = {	
	"rbxassetid://903202701",
	"rbxassetid://903203419",
	"rbxassetid://903254782",
	"rbxassetid://903203657",
	"rbxassetid://903203827",
	"rbxassetid://903254934",
		
}
ColorOBJs = {
	CircleI,AutoBuy,BuyPrev,Close
}
Colors = {
	T = {Color3.fromRGB(123, 110, 83),Color3.fromRGB(255, 205, 88 )},
	CT = {Color3.fromRGB(112, 125, 134),Color3.fromRGB(255, 229, 192)},	
}
Directories = {
	"Pistols","Heavy","SMGs","Rifles","Gear","Grenades"	
}

TDeag = "DesertEagle"
TTacticalPistol = "Tec9"
CTDeag = "DesertEagle"
CTPrimaryPistol = "P2000"
CTTacticalPistol = "FiveSeven"
CTPrimary = "M4A4"
AdditionalEquipment = nil

function updateloadout()
	ButtonsT = {
	Pistols = {
		"Glock","DualBerettas","P250",TTacticalPistol,TDeag
	},
	Heavy = {
		"Nova","XM","SawedOff","M249","Negev"
	},
	SMGs = {
		"MAC10","MP7","UMP","P90","Bizon"
	},
	Rifles = {
		"Galil","AK47","Scout","SG","AWP","G3SG1"
	},
	Gear = {
		"Kevlar Vest","Kevlar + Helmet","Zeus"
	},
	Grenades = {
		"Molotov","Decoy Grenade","Flashbang","HE Grenade","Smoke Grenade"
	}
}
ButtonsCT = {
	Pistols = {
		CTPrimaryPistol,"DualBerettas","P250",CTTacticalPistol,CTDeag
	},
	Heavy = {
		"Nova","XM","MAG7","M249","Negev"
	},
	SMGs = {
		"MP9","MP7","UMP","P90","Bizon"
	},
	Rifles = {
		"Famas",CTPrimary,"Scout","AUG","AWP","G3SG1"
	},
	Gear = {
		"Kevlar Vest","Kevlar + Helmet","Zeus","Defuse Kit" --kit could be rescue or defuse, generated on gamemode
	},
	Grenades = {
		"Incendiary Grenade","Decoy Grenade","Flashbang","HE Grenade","Smoke Grenade"
	}
}
end


updateloadout()
Directory = "Menu"
BuyMenuOpen = false
Team = Player.Status.Team
selectedteam = Colors[Team.Value]
if Team.Value~="CT" then
selectedteam=Colors["T"]
end
cash = player.Cash
game.Workspace.Status.BuyTime.Changed:connect(function(val)
	if val<=0 then
				BuyMenuOpen=false
				Buymenuframe.Visible=false
	end
end)


local buydebounce=false 

function Click(Num)		
	----print(Directory)
--	print(Directory)
--	print(Num)
	if game.ReplicatedStorage.gametype.Value=="juggernaut" and Player.Status.Team.Value=="T" then --no buy menu
		return
	end
	if Directory == "Menu" then
		Directory = Directories[Num]
		--GunStats.Visible = true
		List.Visible = false
		local ButtonTable = nil
		if Team.Value == "CT" then
			ButtonTable = ButtonsCT[Directory]
		else
			ButtonTable = ButtonsT[Directory]
		end		
		for g=1, #CircleChildren do
			CircleChildren[g].TextLabel.Visible = false
			CircleChildren[g].WeaponLabel.Visible = true
			CircleChildren[g].Icon.Visible = true
			----print(tonumber(CircleChildren[g].Name))		
			if ButtonTable[tonumber(CircleChildren[g].Name)] then
				local CurrentButton = ButtonTable[tonumber(CircleChildren[g].Name)]
				local price=GetPrice.getprice(CurrentButton)
				local kevlarbought=false
				local helmetbought=false
				if player and player:FindFirstChild("Kevlar") and player.Kevlar.Value>=100 then
				else
					kevlarbought=true
				end
				if player and player:FindFirstChild("Helmet") then
				else
					helmetbought=true
				end
				local defusebought=false
				if CurrentButton=="Defuse Kit" then
					defusebought=true
				end
				if CurrentButton=="Kevlar + Helmet" then
					price=0
					if helmetbought==true then
						price=price+350
					end
					if kevlarbought==true then
						price=price+650
					end
					if price==0 then
						price=1000
					end
				end
				CircleChildren[g].WeaponLabel.Text = "$"..price--CurrentButton
				if game.ReplicatedStorage.Weapons:FindFirstChild(CurrentButton) or CurrentButton=="Kevlar Vest" or CurrentButton=="Kevlar + Helmet" or CurrentButton=="Defuse Kit" then
					if player.Cash.Value >= price then
						CircleChildren[g].Icon.ImageColor3=Color3.new(1,1,1)
						CircleChildren[g].WeaponLabel.TextColor3 = Color3.new(1,1,1)
					else
						CircleChildren[g].Icon.ImageColor3=Color3.new(0.5,0.5,0.5)
						CircleChildren[g].WeaponLabel.TextColor3 = Color3.fromRGB(180, 60, 90) 
					end
				else
					CircleChildren[g].Icon.ImageColor3=Color3.new(0.25,0.25,0.25)
					CircleChildren[g].WeaponLabel.TextColor3 = Color3.fromRGB(50,50,50) 
				end
				CircleChildren[g].Icon.Image = GetIcon.getWeaponOfKiller(ButtonTable[tonumber(CircleChildren[g].Name)])
				CircleChildren[g].Icon.Visible = true			
			else
				CircleChildren[g].WeaponLabel.Text = ""
				CircleChildren[g].Icon.Visible = false
			end
		end
	else
		--Buy GUI
		--print' purchasing .. '
		--print(Directory) 
		--print(Num)
		if buydebounce==true then
			return
		end
		local ButtonTable = nil
		if Team.Value == "CT" then
			ButtonTable = ButtonsCT[Directory]
		else
			ButtonTable = ButtonsT[Directory]
		end
		local kevlarbought=false
		local helmetbought=false
		if player and player:FindFirstChild("Kevlar") and player.Kevlar.Value>=100 then
		else
			kevlarbought=true
		end
		if player and player:FindFirstChild("Helmet") then
		else
			helmetbought=true
		end
		local CurrentButton = ButtonTable[Num]
		local itemprice = GetPrice.getprice(CurrentButton)
				local defusebought=false
				if CurrentButton=="Defuse Kit" then
					defusebought=true
				end
		if CurrentButton=="Kevlar + Helmet" then
			itemprice=0
			if kevlarbought==true then
				itemprice=itemprice+650
			end
			if helmetbought==true then
				itemprice=itemprice+350
			end
			if itemprice==0 then
				itemprice=1000
			end
		end
		--print(grenade)
		--print(grenade2)
		--print(grenade3)
		--print(grenade4)
		if (cash.Value >= itemprice or game.ReplicatedStorage.Warmup.Value==true or game.ReplicatedStorage.gametype.Value=="deathmatch" and Directory~="Grenades") and (Directory=="Grenades" and grenadeallowed(CurrentButton)==true or Directory~="Grenades") then		
			local warmup=false
			if game.ReplicatedStorage.Warmup.Value==true then
				warmup=true
			end
			--this is local test, we do test again on server obscure scapter >:(
			--oh yes			
			local currentvalue=cash.Value
			local secondarybought=false
			local primarybought=false
	        spawn(function()
		if game.ReplicatedStorage.Weapons:FindFirstChild(CurrentButton) and game.ReplicatedStorage.Weapons:FindFirstChild(CurrentButton):FindFirstChild("Primary") and realgun~=CurrentButton then
			primarybought=true
		end
		if game.ReplicatedStorage.Weapons:FindFirstChild(CurrentButton) and game.ReplicatedStorage.Weapons:FindFirstChild(CurrentButton):FindFirstChild("Secondary") and secondary~=CurrentButton then
			secondarybought=true
		end
			local gearbought=false
			local grenadebought=false
		if CurrentButton=="Defuse Kit" and player and player:FindFirstChild("DefuseKit")==nil or CurrentButton=="Kevlar Vest" and kevlarbought==true or CurrentButton=="Kevlar + Helmet" and (kevlarbought==true or helmetbought==true) then
			gearbought=true
		end
		--print' CHECKPOINT'
		if Directory == "Grenades" then
			if game.ReplicatedStorage.Weapons:FindFirstChild(CurrentButton) and game.ReplicatedStorage.Weapons:FindFirstChild(CurrentButton):FindFirstChild("Grenade") and grenade~=CurrentButton then
				grenadebought=true
			end
		end
		if primarybought==true or secondarybought==true or gearbought==true or grenadebought==true then
			--print' CHECKPOINT 2'
			buydebounce=true
			local color=CircleI:FindFirstChild(tostring(Num)).WeaponLabel.TextColor3
			CircleI:FindFirstChild(tostring(Num)).WeaponLabel.TextColor3 = Color3.fromRGB(50,150,50)
			if game.ReplicatedStorage.Warmup.Value==false and game.ReplicatedStorage.gametype.Value~="deathmatch" then
				cash.Value=math.max(0,cash.Value-itemprice)
				script.Parent.Buy:Play()
				game.ReplicatedStorage.Events.RemoteEvent:FireServer({"buyweapon",CurrentButton})
				local starttime=tick()
				repeat wait() until CurrentButton~="Defuse Kit" and CurrentButton~="Kevlar + Helmet" and CurrentButton~="Kevlar Vest" or (tick()-starttime)>=1 or CurrentButton=="Defuse Kit" and player:FindFirstChild("DefuseKit") or CurrentButton=="Kevlar + Helmet" and player:FindFirstChild("Helmet") or CurrentButton=="Kevlar Vest" and player:FindFirstChild("Kevlar")
			end
			buydebounce=false
			CircleI:FindFirstChild(tostring(Num)).WeaponLabel.TextColor3 = color
		end

				if secondarybought==true then
					if secondary~=""  then
					game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[secondary],Camera.CoordinateFrame,ammocount2,secondarystored,special2,nil,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
					end
						special2=false

					secondary=CurrentButton
					ammocount2=game.ReplicatedStorage.Weapons[secondary].Ammo.Value
					secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
					gun=game.ReplicatedStorage.Weapons[secondary]
					equipped="secondary"
					updateInventory()
					secondaryowner = game.Players.LocalPlayer
					usethatgun(secondaryowner)
				end
				if primarybought==true then
					if realgun~=""  then
						realgun = string.gsub(realgun, "-", "")
						game.ReplicatedStorage.Events.Drop:FireServer(game.ReplicatedStorage.Weapons[realgun],Camera.CoordinateFrame,ammocount,primarystored,special,primaryowner,game.Workspace.Status.Preparation.Value,game.Workspace.Status.RoundOver.Value)
					end
						special=false
						primary=CurrentButton
						realgun=primary
						
						ammocount=game.ReplicatedStorage.Weapons[primary].Ammo.Value
						primarystored=game.ReplicatedStorage.Weapons[primary].StoredAmmo.Value
						gun=game.ReplicatedStorage.Weapons[primary]
						equipped="primary"
						updateInventory()
						primaryowner = player
						usethatgun(primaryowner)
				end
				if grenadebought and game.ReplicatedStorage.gametype.Value~="deathmatch" then
					local gottem=false
						if grenade=="" and gottem==false then
							gottem=true
							grenade=CurrentButton
							gun=game.ReplicatedStorage.Weapons[grenade]
							equipped="grenade"
							updateInventory()
							usethatgun()		
						end			
						if grenade2=="" and gottem==false then
							gottem=true
							grenade2=CurrentButton
							gun=game.ReplicatedStorage.Weapons[grenade2]
							equipped="grenade2"
							updateInventory()
							usethatgun()		
						end		
						if grenade3=="" and gottem==false then
							gottem=true
							grenade3=CurrentButton
							gun=game.ReplicatedStorage.Weapons[grenade3]
							equipped="grenade3"
							updateInventory()
							usethatgun()		
						end		
						if grenade4=="" and gottem==false then
							gottem=true
							grenade4=CurrentButton
							gun=game.ReplicatedStorage.Weapons[grenade4]
							equipped="grenade4"
							updateInventory()
							usethatgun()		
						end		
				end
			end)
		end
	end
end
function Back()
	for i=1, #ColorOBJs do
	ColorOBJs[i].ImageColor3 = selectedteam[1]	
	end
	if Directory == "Menu" then
		BuyMenuOpen = false
		Buymenuframe.Visible = false
	else
		Directory = "Menu" 
		List.Visible = true
		GunStats.Visible = false
		-----------
		local listchild = List:GetChildren()
		for g=1, #listchild do
			if listchild[g].Name ~= "TextLabel" then
				listchild[g]:Destroy()
			end
		end
		--clears previous mouseover ^^^^
	
		for g=1, #CircleChildren do
			CircleChildren[g].TextLabel.Visible = true
			CircleChildren[g].WeaponLabel.Visible = false
			CircleChildren[g].Icon.Visible = false
			----print(tonumber(CircleChildren[g].Name))
			CircleChildren[g].Icon.ImageColor3=Color3.new(1,1,1)		
			if Directories[tonumber(CircleChildren[g].Name)] then
				local CurrentButton = Directories[tonumber(CircleChildren[g].Name)]
				
				CircleChildren[g].TextLabel.Text = CurrentButton
			else
				CircleChildren[g].TextLabel.Text = ""
			end
		end
	end
end

function Mouseoverpreview(Num)
	if Directory == "Menu" then		
		local MouseoverDirectory = Directories[Num]
		local ButtonTable = nil
		if Team.Value == "CT" then
			ButtonTable = ButtonsCT[MouseoverDirectory]
		else
			ButtonTable = ButtonsT[MouseoverDirectory]
		end
		--List:ClearAllChildren()
		local listchild = List:GetChildren()
		for g=1, #listchild do
			if listchild[g].Name ~= "TextLabel" then
				listchild[g]:Destroy()
			end
		end
		local Y = 0.105
		for g=1, #ButtonTable do
			
			local temp = script.GunLabelTemplate:Clone()
			temp.TextLabel.Text = GetName.getName(ButtonTable[g])
			temp.Pic.Image =  GetIcon.getWeaponOfKiller(ButtonTable[g])
			-- temp.Pic.Image = 
			temp.Position = UDim2.new(0.04,0,Y,0)
			temp.Visible = true
			temp.Parent = List
			Y = Y + .1
		end
	else
		--must be a weapon, lets generate stats		
		GunStats.Visible = true
		local ButtonTable = nil
		if Team.Value == "CT" then
			ButtonTable = ButtonsCT[Directory]
		else
			ButtonTable = ButtonsT[Directory]
		end
		local Weapon = ButtonTable[Num]
		local Stats = GetPrice.getstats(Weapon)
		local truename = GetName.getName(Weapon)
		if Weapon then
			GunStats.TextLabel.Text="Statistics - "..truename
			GunStats.GunLabel.Pic.Image = Stats[1]
			local Firepower = Stats[2]
			local Firerate = Stats[3]
			local Accuracy = Stats[4]
			local RecoilControl = Stats[5]
			local FPC = GunStats.FP:GetChildren()
			if Firepower and Firerate and Accuracy and RecoilControl then
			for i=1, #FPC do
				if FPC[i]:IsA("Frame") then
					if tonumber(FPC[i].Name) <= Firepower then
						FPC[i].Visible = true
					else
						FPC[i].Visible = false
					end
				end
			end
			local FPC = GunStats.FR:GetChildren()
			for i=1, #FPC do
				if FPC[i]:IsA("Frame") then
					if tonumber(FPC[i].Name) <= Firerate then
						FPC[i].Visible = true
					else
						FPC[i].Visible = false
					end
				end
			end
			local FPC = GunStats.AC:GetChildren()
			for i=1, #FPC do
				if FPC[i]:IsA("Frame") then
					if tonumber(FPC[i].Name) <= Accuracy then
						FPC[i].Visible = true
					else
						FPC[i].Visible = false
					end
				end
			end
			local FPC = GunStats.R:GetChildren()
			for i=1, #FPC do
				if FPC[i]:IsA("Frame") then
					if tonumber(FPC[i].Name) <= RecoilControl then
						FPC[i].Visible = true
					else
						FPC[i].Visible = false
					end
				end
			end
			GunStats.Ammo.Label.Text=game.ReplicatedStorage.Weapons[Weapon].Ammo.Value.."/"..game.ReplicatedStorage.Weapons[Weapon].StoredAmmo.Value
			GunStats.Special.Label.Text=Stats[7]
			GunStats.Country.TextLabel.Text=Stats[8]
			end
			local visible=true
			if Stats[9] then
				GunStats.TextLabel.Text="Statistics"
				visible=false
				GunStats.Desc.Desc.Text=Stats[9]
			end
			GunStats.AC.Visible=visible
			GunStats.Ammo.Visible=visible
			GunStats.Country.Visible=visible
			GunStats.FP.Visible=visible
			GunStats.FR.Visible=visible
			GunStats.R.Visible=visible
			GunStats.Special.Visible=visible
			GunStats.Desc.Visible=not visible
		end
	end
end



for i=1, #CircleChildren do
	table.insert(ColorOBJs,1,CircleChildren[i])
	
	
	
	
	CircleChildren[i].Hitbox.MouseEnter:connect(function()
		if UserInputService.GamepadEnabled == false then
			if CurrentlyHighlighted then
				CurrentlyHighlighted.ImageColor3 = selectedteam[1]
				CurrentlyHighlighted.Image = Normal[tonumber(CurrentlyHighlighted.Name)]	
			end
			CurrentlyHighlighted = CircleChildren[i]
			CurrentlyHighlighted.ImageColor3 = selectedteam[2]
			CurrentlyHighlighted.Image = Selected[tonumber(CurrentlyHighlighted.Name)]
			----print(tonumber(CircleChildren[i].Name))
			Mouseoverpreview(tonumber(CircleChildren[i].Name))
		end
	end)
	
	
	CircleChildren[i].Hitbox.MouseLeave:connect(function()
		if CircleChildren[i] == CurrentlyHighlighted then
			CurrentlyHighlighted.ImageColor3 = selectedteam[1]
			CurrentlyHighlighted.Image = Normal[tonumber(CurrentlyHighlighted.Name)]
		end
	end)
	CircleChildren[i].Hitbox.MouseButton1Down:connect(function()
		script.Parent.Sounds.MenuClick:Play()
		----print("num " ..CircleChildren[i].Name)
		Click(tonumber(CircleChildren[i].Name))
	end)	
end
UserInputService = game:GetService("UserInputService") 

local Zone -- gamepad buymenu

local prevzone
	local function GP_UpdateBuyMenu(menu)
		
		
		if prevzone ~= menu then
			for i, v in pairs (Buymenuframe.Circle:GetChildren()) do
				if v:IsA("ImageLabel") then
					v.ImageColor3 = selectedteam[1]	
				end
			end
			script.Parent.Menu_Select:Play()
		end
		
		menu.ImageColor3 = Color3.new(1,1,1)

		prevzone = menu
	end

UserInputService.InputChanged:Connect(function(input) -- buy menu radial input
	if input.KeyCode == Enum.KeyCode.Thumbstick1 and BuyMenuOpen then
		if input.Position.X <= -0.75 and math.abs(input.Position.Y) <= 0.3 then
			Zone = 6
			Mouseoverpreview(6)
			_gui.SelectedObject = Buymenuframe.Circle[Zone].Hitbox
			GP_UpdateBuyMenu(Buymenuframe.Circle[Zone])
		elseif input.Position.X >= 0.75 and math.abs(input.Position.Y) <= 0.3 then
			Zone = 3
			Mouseoverpreview(3)
			_gui.SelectedObject = Buymenuframe.Circle[Zone].Hitbox
			GP_UpdateBuyMenu(Buymenuframe.Circle[Zone])
		elseif input.Position.X >= -0.75 and input.Position.X < 0 and input.Position.Y > 0.5 then
			Zone = 1
			Mouseoverpreview(1)
			_gui.SelectedObject = Buymenuframe.Circle[Zone].Hitbox
			GP_UpdateBuyMenu(Buymenuframe.Circle[Zone])
		elseif input.Position.X > 0 and input.Position.X <= 0.75 and input.Position.Y > 0.5 then
			Zone = 2
			Mouseoverpreview(2)
			_gui.SelectedObject = Buymenuframe.Circle[Zone].Hitbox
			GP_UpdateBuyMenu(Buymenuframe.Circle[Zone])
		elseif input.Position.X >= -0.75 and input.Position.X < 0 and input.Position.Y < 0.5 then
			Zone = 5
			Mouseoverpreview(5)
			_gui.SelectedObject = Buymenuframe.Circle[Zone].Hitbox
			GP_UpdateBuyMenu(Buymenuframe.Circle[Zone])
		elseif input.Position.X > 0 and input.Position.X <= 0.75 and input.Position.Y < 0.5 then
			Zone = 4
			Mouseoverpreview(4)
			_gui.SelectedObject = Buymenuframe.Circle[Zone].Hitbox
			GP_UpdateBuyMenu(Buymenuframe.Circle[Zone])
		elseif math.abs(input.Position.X) < 0.1 and math.abs(input.Position.Y) < 0.1 then
			_gui.SelectedObject = nil
		end
	end
end)

local function onInputBegan(input,gameProcessed)
	if script.Parent:FindFirstChild("GUI") and (script.Parent.GUI.Main.GlobalChat.ActiveOne.Value==true or script.Parent.GUI.Main.TeamChat.ActiveOne.Value==true) then
		return
	end
	--if BuyMenuOpen then this will be removed when keydown open buy menu is implemented
		if input.KeyCode == Enum.KeyCode.One and Buymenuframe.Visible then
			Click(1)
		elseif input.KeyCode == Enum.KeyCode.Two and Buymenuframe.Visible then
			Click(2)
		elseif input.KeyCode == Enum.KeyCode.Three and Buymenuframe.Visible then
			Click(3)
		elseif input.KeyCode == Enum.KeyCode.Four and Buymenuframe.Visible then
			Click(4)
		elseif input.KeyCode == Enum.KeyCode.Five and Buymenuframe.Visible then
			Click(5)
		elseif input.KeyCode == Enum.KeyCode.Six and Buymenuframe.Visible then
			Click(6)
	elseif game.Workspace.Status.BuyTime.Value>0 and script.Parent.Ban.MainHandler.Visible == false and input.KeyCode == Enum.KeyCode.B or input.KeyCode == Enum.KeyCode.ButtonX or input.KeyCode == Enum.KeyCode.ButtonB and player and player.Status.Alive.Value==true and player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health>0 and reloading == false then

				if equipped == "secondary" and ammocount2 < gun.Ammo.Value then
					return
				elseif equipped == "primary" and ammocount < gun.Ammo.Value then				
					return
				end

			--check to see if in buy menu, prob gonna use keydown for this
			-- hell no u aint
			if gui.Cash.BuyZone.Visible then
				if BuyMenuOpen then
					Back()
				else --This else will be replaced with keydown				
					Buymenuframe.Visible = true
					BuyMenuOpen = true 
				end
			else
				BuyMenuOpen=false
				Buymenuframe.Visible=false
			end		
		elseif input.KeyCode == Enum.KeyCode.Quote and script.Parent.Ban.MainHandler.Visible == false then
			if CrosshairCustom.Visible then
				CrosshairCustom.Visible = false
				--save
				game.ReplicatedStorage.Events.DataEvent:FireServer({"SaveCrosshair",CrosshairData})
				
			else
				CrosshairCustom.Visible = true 
			end
			createNotification2("DEBUG: Toggled crosshair customization",Color3.new(0,1,0))
		elseif input.KeyCode == Enum.KeyCode.Nine and game.ReplicatedStorage.gametype.Value~="TTT" and script.Parent.Ban.MainHandler.Visible == false then
			--print ' NINE '
			--Charlie Fatlegs
			--generate players
			
			local Players = game.Players:GetPlayers()
			local buttonsize = .1		
			gui.Votekick.Folder:ClearAllChildren()
			gui.Votekick.Visible = not gui.Votekick.Visible
			if gui.Votekick.Visible then
				if #Players > 9 then
					buttonsize = .9 / (#Players-1)	
				end
				local currenty = .1
				for i=1, #Players do
					if Players[i] ~= Player then
						local thebutton = script.VoteKickTemplate:Clone()
						thebutton.Parent = gui.Votekick.Folder
						thebutton.Visible = true
						thebutton.Position = UDim2.new(0,0,currenty,0)
						
						currenty = currenty + buttonsize
						thebutton.Text = Players[i].Name
						thebutton.Size = UDim2.new(1,0,buttonsize,0)
						
						local randomR = math.random(1,255)
						local randomG = math.random(1,255)
						local randomB = math.random(1,255)
						thebutton.BackgroundColor3 = Color3.fromRGB(randomR,randomG,randomB)
						thebutton.MouseButton1Down:connect(function()
							game.ReplicatedStorage.Events.Vote:FireServer(thebutton.Text)
						end)
					end
				end
			end
		elseif input.KeyCode == Enum.KeyCode.N then			
			if InvenFrame.Visible == false and gui.ShopMenu.Visible == false and not script.Parent.Ban.MainHandler.Visible then
				menugui.Enabled = not menugui.Enabled
				if player.Status.Alive.Value == true then
					menugui.MainFrame.Back.ImageTransparency = 1
					menugui.MainFrame.Back.BackgroundTransparency = 0.5
					menugui.MainFrame.Info.Text = "Press 'N' again to quickly close this menu."
					menugui.MainFrame.Info.Visible = true
					menugui.MainFrame.PlayNow.TextLabel.Text = "RESUME"
					menugui.MainFrame.SkinShop.Active = false
					menugui.MainFrame.SkinShop.Warn.Visible = true
				else
					menugui.MainFrame.Back.ImageTransparency = 0
					menugui.MainFrame.Back.BackgroundTransparency = 0
					menugui.MainFrame.PlayNow.TextLabel.Text = "PLAY NOW"
					menugui.MainFrame.SkinShop.Active = true
					menugui.MainFrame.SkinShop.Warn.Visible = false
				end
			end

			
		end
	--end
end	 

Close.MouseButton1Down:connect(function()
	script.Parent.Sounds.MenuClick:Play()
	Back()
end)
UserInputService.InputBegan:connect(onInputBegan)
--UserInputService.InputEnded:connect(onInputEnded)
	
for i=1, #ColorOBJs do
	ColorOBJs[i].ImageColor3 = selectedteam[1]	
end
Back()
Back()
--add remote event for recieving newly equipped items
--:weary:

--[[
	
  _                                              
 | |                                             
 | |__  _   _ _   _   _ __ ___   ___ _ __  _   _ 
 | '_ \| | | | | | | | '_ ` _ \ / _ \ '_ \| | | |
 | |_) | |_| | |_| | | | | | | |  __/ | | | |_| |
 |_.__/ \__,_|\__, | |_| |_| |_|\___|_| |_|\__,_|
               __/ |                             
              |___/                              

--]]
-- AMMOMOD IFICATION



--[[
TTTTTTTTTTTTTTTTTTTTTTT       CCCCCCCCCCCCC      222222222222222    
T:::::::::::::::::::::T    CCC::::::::::::C     2:::::::::::::::22  
T:::::::::::::::::::::T  CC:::::::::::::::C     2::::::222222:::::2 
T:::::TT:::::::TT:::::T C:::::CCCCCCCC::::C     2222222     2:::::2 
TTTTTT  T:::::T  TTTTTTC:::::C       CCCCCC                 2:::::2 
        T:::::T       C:::::C                               2:::::2 
        T:::::T       C:::::C                            2222::::2  
        T:::::T       C:::::C                       22222::::::22   
        T:::::T       C:::::C                     22::::::::222     
        T:::::T       C:::::C                    2:::::22222        
        T:::::T       C:::::C                   2:::::2             
        T:::::T        C:::::C       CCCCCC     2:::::2             
      TT:::::::TT       C:::::CCCCCCCC::::C     2:::::2       222222
      T:::::::::T        CC:::::::::::::::C     2::::::2222222:::::2
      T:::::::::T          CCC::::::::::::C     2::::::::::::::::::2
      TTTTTTTTTTT             CCCCCCCCCCCCC     22222222222222222222
--]]
-- DROWNING DETECTION
local secondsInWater = 0
local debounceWater = false
function isHeadInWater(char)
	if char ~= nil and char:FindFirstChild("Head") then
		local terrain = workspace.Terrain
			local headLoc2 = terrain:WorldToCell(Character.Head.Position)
 local hasAnyWater2, WaterForce2, WaterDirection2 = terrain:GetWaterCell(headLoc2.x, headLoc2.y, headLoc2.z)
return hasAnyWater2
	end
end
local dank=true
local dank2=true
local dank3=true
-- VARIABLES (For lag reduction)
local datCrosshair = crosshairs.Crosshair
--local charge=script.Parent.GUI.Crosshairs.Scope.ChargeMeter.ChargeNormal
local abs,cos,sin = math.abs,math.cos,math.sin
local hooplamod=0
local lastlook=Camera.CoordinateFrame.lookVector.Y
local look=Camera.CoordinateFrame.lookVector.Y
local viewheight=0.4
local crouchingheight=0.9 --should be 0.734 but we can't, so sad.... max is 1.32

function changeviewheight(num)
	if viewheight<num then
		viewheight=math.min(num,viewheight+(.04*(4/math.max(1,crouchcooldown))))
	elseif viewheight>num then
		viewheight=math.max(num,viewheight-(.04*(4/math.max(1,crouchcooldown))))
	end
end

function changeburstmode()
	local CHOSENONE=gun
	if DISABLED==true then
		return
	end
	if equipped=="primary" and gun~="none" and gun and gun.Model:FindFirstChild("Silencer2") then
		if inspectani then
			inspectani:Stop()
		end
		if special==true then
			if applyani then
				applyani:Play()
				game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Apply")
			end
			DISABLED=true
			local starttime=tick() repeat  _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=gun.ApplyTime.Value
			DISABLED=false
		else
			if removeani then
				removeani:Play()
				game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Remove")
			end
			DISABLED=true
			local starttime=tick() repeat  _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=gun.RemoveTime.Value
			DISABLED=false
		end
	special=not special
	updatesilencer()
	end
	if equipped=="secondary" and gun~="none" and gun and gun.Model:FindFirstChild("Silencer2") then
		if inspectani then
			inspectani:Stop()
		end
		if special2==true then
			if applyani then
				applyani:Play()
				game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Apply")
			end
			DISABLED=true
			local starttime=tick() repeat  _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=gun.ApplyTime.Value
			DISABLED=false
		else
			if removeani then
				removeani:Play()
				game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Remove")
			end
			DISABLED=true
			local starttime=tick() repeat  _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=gun.RemoveTime.Value
			DISABLED=false
		end
	special2=not special2
	updatesilencer()
	end
		if equipped=="primary" and gun~="none" and gun and gun.Model:FindFirstChild("Switch") then
		special=not special
		if special==true then
		notify("Switched to burst-fire mode",0.8)
		elseif special==false then
		notify("Switched to automatic",0.8)
		end
		DISABLED=true
			if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Switch") then
			Character.Gun.Switch:Play()
			end
		local starttime=tick() repeat  _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=0.5
		DISABLED=false
		end
		
		
		
		if equipped=="secondary" and gun~="none" and gun and gun.Model:FindFirstChild("Switch") then
		special2=not special2
		if special2==true then
		notify("Switched to burst-fire mode",0.8)
		elseif special2==false then
		notify("Switched to automatic",0.8)
		end
		DISABLED=true
			if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Switch") then
			Character.Gun.Switch:Play()
			end
		local starttime=tick() repeat  _Run.Stepped:wait() if gun~=CHOSENONE then return end until (tick()-starttime)>=0.5
		DISABLED=false
		end
end



function speedupdate()
	Humanoid.WalkSpeed=0
	if gun~="none" and gun and gun.Name and game.ReplicatedStorage.HUInfo:FindFirstChild(gun.Name) then
		Humanoid.WalkSpeed=game.ReplicatedStorage.HUInfo[gun.Name].WalkSpeed.Value*hammerunit2stud
		if pulling==true then
			Humanoid.WalkSpeed=180*hammerunit2stud
		end
		if game.ReplicatedStorage.gametype.Value=="juggernaut" and Player.Status.Team.Value=="T" then
			Humanoid.WalkSpeed=Humanoid.WalkSpeed*0.8
			if Character:FindFirstChild("Charging") then
				Humanoid.WalkSpeed=650*hammerunit2stud
			end
		end
		if ads==true then
			Humanoid.WalkSpeed=game.ReplicatedStorage.HUInfo[gun.Name].Scoped.Value*hammerunit2stud
		end

		
		
		if Humanoid:GetState()==Enum.HumanoidStateType.Swimming then
		Humanoid.WalkSpeed=Humanoid.WalkSpeed*2
		end
		if jumping==true and landing==false then
			Humanoid.WalkSpeed=Humanoid.WalkSpeed*1.2
		end
		if landing==true and Character:FindFirstChild("Crouched")==nil then
		Humanoid.WalkSpeed=Humanoid.WalkSpeed*0.75
			if jumping==true then
				Humanoid.WalkSpeed=Humanoid.WalkSpeed*0.5
			end
		end
		if Camera and Camera:FindFirstChild("Arms2") then 
			Humanoid.WalkSpeed=Humanoid.WalkSpeed*0.9
		end
		if climbing==true then
			Humanoid.WalkSpeed=Humanoid.WalkSpeed*0.9
			if Character:FindFirstChild("Crouched") then
				Humanoid.WalkSpeed=Humanoid.WalkSpeed/3
			else
				if walking==true then
				Humanoid.WalkSpeed=Humanoid.WalkSpeed/2
				end
			end
		else
			if jumping==true and landing==false then
			else
				if Character:FindFirstChild("Crouched") then
					Humanoid.WalkSpeed=Humanoid.WalkSpeed/3
				else
					if walking==true then
					Humanoid.WalkSpeed=Humanoid.WalkSpeed/2
					end
				end				
			end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
				Humanoid.WalkSpeed=Humanoid.WalkSpeed*0.9
			end
		end

	end
	if Character:FindFirstChild("Charging")==nil then
		local mult=1
		local cruds=Humanoid:GetChildren()
		for i=1,#cruds do
			if cruds[i].Name=="Tagged" then
				mult=mult*(1-(cruds[i].Value/4))
			end
		end
		mult=math.max(0.45,mult)
		if Player.Status.Team.Value=="T" and game.ReplicatedStorage.gametype.Value=="juggernaut"  then
			mult=math.max(0.6,mult)
		end
		Humanoid.WalkSpeed=math.clamp(Humanoid.WalkSpeed,0,250*hammerunit2stud*1.2)
		Humanoid.WalkSpeed=Humanoid.WalkSpeed*mult
	end
	if game.Workspace.Status.Preparation.Value==true and game.ReplicatedStorage.gametype.Value~="TTT" then
	Humanoid.WalkSpeed=0
	end
	if equipped=="equipment2" and fireani and fireani.IsPlaying==true then 
	Humanoid.WalkSpeed=0
	end
	if Buymenuframe.Visible or Player.PlayerGui.GUI.Defusal.Visible==true then
	Humanoid.WalkSpeed=0
	end
end

local dottrans=0
local cart=false
local startmusic=nil
local scopescale=0
local alive = player:WaitForChild("Status"):WaitForChild("Alive")

local canTalk = player:WaitForChild("Status"):WaitForChild("CanTalk")
--[[
-- CHAT CODE
local lastmsg = ""
local t = false
local safeChat = script.Parent:WaitForChild("GUI"):WaitForChild("SafeChat")
local chatting = safeChat:WaitForChild("chatting")


mouse.KeyDown:connect(function(key)
	if key == "y" and not chatting.Value or key == "/" and not chatting.Value then
		safeChat:WaitForChild("Back"):WaitForChild("Msg").Text = ""
		_Run.Heartbeat:wait()
		safeChat:WaitForChild("Back"):WaitForChild("Msg"):CaptureFocus()
		safeChat:WaitForChild("Back"):WaitForChild("Msg").Text = ""
		safeChat.TextLabel.Visible = false
		safeChat.Back.Effect.Visible=true
		if not alive.Value and not preparation.Value and not roundOver.Value then
			safeChat.rip.Visible = true
		else
			safeChat.rip.Visible = false	
		end
		chatting.Value = true
		t = false
	elseif key == "u" and not chatting.Value or key == ";" and not chatting.Value then

		if game.ReplicatedStorage.gametype.Value=="TTT" and player.Status.Role.Value=="Traitor" and alive.Value or game.ReplicatedStorage.gametype.Value~="TTT" and (alive.Value or Player.Status.Team.Value~="Spectator" and game.ReplicatedStorage.gametype.Value=="competitive") then
			safeChat:WaitForChild("Back"):WaitForChild("Msg").Text = ""
			_Run.Heartbeat:wait()
			safeChat:WaitForChild("Back"):WaitForChild("Msg"):CaptureFocus()
			safeChat:WaitForChild("Back"):WaitForChild("Msg").Text = ""
			safeChat.Back.Effect.Visible=true
			chatting.Value = true
			t = true
			
			safeChat.TextLabel.Visible = true
		end
	end
end)

local chatEvent = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Chat")
local timesChatted = 0
local firstTime = tick()

function checkIfSpamming()
	timesChatted = timesChatted + 1
	if timesChatted == 1 then
		firstTime = tick()
	else
		if (tick() - firstTime) > 6 then
			timesChatted = 0
		end
	end
end

]]









-- Variables For The Suit Zoom Keys
keys = suitZoom:WaitForChild("Keys")
one = keys:WaitForChild("1")
two = keys:WaitForChild("2")
three = keys:WaitForChild("3")
four = keys:WaitForChild("4")
five = keys:WaitForChild("5")
six = keys:WaitForChild("6")
seven = keys:WaitForChild("7")
eight = keys:WaitForChild("8")
nine = keys:WaitForChild("9")


function adjustVisibility2()
	if suitZoom.Visible then --If it's visible
		if Player:FindFirstChild("Dux") then
			Player:FindFirstChild("Dux"):Destroy()
		end
		if Player:FindFirstChild("Waiting") then
			Player.Waiting:Destroy()
		end
		suitZoom.Visible = false
	else -- Otherwise
		suitZoom.Visible = true -- Make it visible
		
		local waiting = Instance.new("IntValue")
		waiting.Name = "Waiting"
		game.Debris:AddItem(waiting, 3)
		waiting.Parent = Player
		spawn(function()
			repeat _Run.Heartbeat:wait() until game.Players.LocalPlayer:FindFirstChild("Waiting") == nil 
			if Player:FindFirstChild("Dux") then
				Player:FindFirstChild("Dux"):Destroy()
			end
			suitZoom.Visible = false
		end)
	end
end

-- Open/Close The SuitZoom Keys
mouse.KeyDown:connect(function(key)
	if alive.Value and Player.Character and key:lower() == "x" and canTalk.Value then
		adjustVisibility2()
	end
end)

--Cursor Function Updating The SuitZoom Keys
function cursor(target)
	local person = target
	if person then
		-- Updates If Mouse Is On Someone Alive
		if person.Parent:FindFirstChild("Humanoid") or person.Parent.Parent:FindFirstChild("Humanoid") then
			-- Finds Target Player
			local plyr = nil
			if person.Parent.Parent:FindFirstChild("Humanoid")==nil then
				plyr = game.Players:FindFirstChild(person.Parent.Name)
			else
				plyr = game.Players:GetPlayerFromCharacter(person.Parent.Parent)
			end
			if plyr then
				if game.Players.LocalPlayer:FindFirstChild("Dux") then
					game.Players.LocalPlayer["Dux"]:Destroy()
				end
				local dux5=Instance.new("IntValue")
				dux5.Parent=Player
				dux5.Name="Dux"
				game.Debris:AddItem(dux5, 1.5)
				--Updates Suit Zoom Key To Incorporate Targeted Player's Info
				if plyr and (not plyr.Character:FindFirstChild("Disguiser") or (plyr.Character:FindFirstChild("Disguiser") and not plyr.Character:FindFirstChild("Disguiser").Value)) then
					four.Text = "4: I'm with "..plyr.Name.."."
					four:WaitForChild("DropShadow").Text = "4: I'm with "..plyr.Name.."."
					five.Text = "5: I see "..plyr.Name.."."
					five:WaitForChild("DropShadow").Text = "5: I see "..plyr.Name.."."
					six.Text = "6: "..plyr.Name.." acts suspicious."
					six:WaitForChild("DropShadow").Text = "6: "..plyr.Name.." acts suspicious."
					seven.Text = "7: "..plyr.Name.." is a Traitor!"
					seven:WaitForChild("DropShadow").Text = "7: "..plyr.Name.." is a Traitor!"
					eight.Text = "8: "..plyr.Name.." is Innocent."
					eight:WaitForChild("DropShadow").Text = "8: "..plyr.Name.." is Innocent."
				else
					four.Text = "4: I'm with someone in disguise."
					four:WaitForChild("DropShadow").Text = "4: I'm with someone in disguise."
					five.Text = "5: I see someone in disguise."
					five:WaitForChild("DropShadow").Text = "5: I see someone in disguise."
					six.Text = "6: Someone in disguise acts suspicious."
					six:WaitForChild("DropShadow").Text = "6: Someone in disguise acts suspicious."
					seven.Text = "7: Someone in disguise is a Traitor!"
					seven:WaitForChild("DropShadow").Text = "7: Someone in disguise is a Traitor!"
					eight.Text = "8: Someone in disguise is Innocent."
					eight:WaitForChild("DropShadow").Text = "8: Someone in disguise is Innocent."
				end
			end
		--Updates If Mouse Is On A Corpse
		elseif person.Parent:FindFirstChild("Humanoid2") or person.Parent.Parent:FindFirstChild("Humanoid2") then
			--Finds Target Corpse's Name
			local name = ""
			if person.Parent:FindFirstChild("Humanoid2") then
				name = person.Parent.Name
			elseif person.Parent.Parent:FindFirstChild("Humanoid2") then
				name = person.Parent.Parent.Name
			end
			if name then
				if game.Players.LocalPlayer:FindFirstChild("Dux") then
					game.Players.LocalPlayer["Dux"]:Destroy()
				end
				local dux5 = Instance.new("IntValue")
				dux5.Parent = game.Players.LocalPlayer
				dux5.Name = "Dux"
				game.Debris:AddItem(dux5, 1.5)
				--Updates Suit Zoom Key To Incorporate Target Corpse's Info
				if game.Workspace.Debris:FindFirstChild(name) and game.Workspace.Debris:FindFirstChild(name):FindFirstChild("Identified") and game.Workspace.Debris:FindFirstChild(name).Identified.Value==true then
					four.Text = "4: I'm with "..name.."'s corpse."
					four:WaitForChild("DropShadow").Text = "4: I'm with "..name.."'s corpse."
					five.Text = "5: I see "..name.."'s corpse."
					five:WaitForChild("DropShadow").Text = "5: I see "..name.."'s corpse."
					six.Text = "6: "..name.."'s corpse acts suspicious."
					six:WaitForChild("DropShadow").Text = "6: "..name.."'s corpse acts suspicious."
					seven.Text = "7: "..name.."'s corpse is a Traitor!"
					seven:WaitForChild("DropShadow").Text = "7: "..name.."'s corpse is a Traitor!"
					eight.Text = "8: "..name.."'s corpse is Innocent."
					eight:WaitForChild("DropShadow").Text = "8: "..name.."'s corpse is Innocent."
				else
					four.Text = "4: I'm with an unidentified body."
					four:WaitForChild("DropShadow").Text = "4: I'm with an unidentified body."
					five.Text = "5: I see an unidentified body."
					five:WaitForChild("DropShadow").Text = "5: I see an unidentified body."
					six.Text = "6: An unidentified body acts suspicious."
					six:WaitForChild("DropShadow").Text = "6: An unidentified body acts suspicious."
					seven.Text = "7: An unidentified body is a Traitor!"
					seven:WaitForChild("DropShadow").Text = "7: An unidentified body is a Traitor!"
					eight.Text = "8: An unidentified body is Innocent."
					eight:WaitForChild("DropShadow").Text = "8: An unidentified body is Innocent."
				end
			end
		--Updates If Mouse Is On Nobody
		else
			if not Player:FindFirstChild("Dux") then
				four.Text = "4: I'm with nobody."
				four:WaitForChild("DropShadow").Text = "4: I'm with nobody."
				five.Text = "5: I see nobody."
				five:WaitForChild("DropShadow").Text = "5: I see nobody."
				six.Text = "6: Nobody acts suspicious."
				six:WaitForChild("DropShadow").Text = "6: Nobody acts suspicious."
				seven.Text = "7: Nobody is a Traitor!"
				seven:WaitForChild("DropShadow").Text = "7: Nobody is a Traitor!"
				eight.Text = "8: Nobody is Innocent."
				eight:WaitForChild("DropShadow").Text = "8: Nobody is Innocent."
			end
		end
		suitZoom.Size = UDim2.new(0, six.TextBounds.X + 11, 0, 200)
	end
end


--Mouse Movement Function
local chatvoicedeb=false
function chatMessage(label,voice)
	if chatvoicedeb==true then
		return
	end
	_Run.Heartbeat:wait()
	if label~="" then
		game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PlayerChatted"):FireServer(string.sub(label, 4), false, player.Status.Role.Value, not player:WaitForChild("Status"):WaitForChild("Alive").Value, true,true)
	end
--	if voice then
--	--local voices=voice:GetChildren()[math.random(1,#voice:GetChildren())]
----			chatvoicedeb=true
----			delay(math.max(1,voices.TimeLength+1),function()
----			chatvoicedeb=false
----			end)
--	
--	--game.ReplicatedStorage.Events.SendVoice:FireServer(voices)
--	else
--			chatvoicedeb=true
--		delay(1,function()
--			chatvoicedeb=false
--		end)
--	end
	if Player:FindFirstChild("Dux") then
		Player:FindFirstChild("Dux"):Destroy()
	end
	if Player:FindFirstChild("Waiting") then
		Player.Waiting:Destroy()
	end
	suitZoom2.Visible = false
	suitZoom.Visible = false
end
UIS.InputBegan:connect(function(key)
	if game.ReplicatedStorage.gametype.Value=="TTT" then
	else
		return
	end
	if suitZoom.Visible and alive.Value and player.Character and chatvoicedeb==false then
		if key.KeyCode == Enum.KeyCode.One then

			chatMessage(one.Text)

		elseif key.KeyCode == Enum.KeyCode.Two then

			chatMessage(two.Text)

		elseif key.KeyCode == Enum.KeyCode.Three then

			chatMessage(three.Text)

		elseif key.KeyCode == Enum.KeyCode.Four then
			chatMessage(four.Text)
		elseif key.KeyCode == Enum.KeyCode.Five then
			chatMessage(five.Text)
		elseif key.KeyCode == Enum.KeyCode.Six then
			chatMessage(six.Text)
		elseif key.KeyCode == Enum.KeyCode.Seven then

			chatMessage(seven.Text)

		elseif key.KeyCode == Enum.KeyCode.Eight then

			chatMessage(eight.Text)

		elseif key.KeyCode == Enum.KeyCode.Nine then

			chatMessage(nine.Text)

		end

	end
	if key.UserInputType == Enum.UserInputType.MouseButton3 and alive.Value and Player.Character and canTalk.Value then
		adjustVisibility()
	end
end)
-- END OF SUIT ZOOM CODE








--[[
safeChat:WaitForChild("Back"):WaitForChild("Msg").FocusLost:connect(function(enter)
	if enter and canTalk.Value then
		if safeChat:WaitForChild("Back"):WaitForChild("Msg").Text ~= "" then
		chatEvent:FireServer(safeChat:WaitForChild("Back"):WaitForChild("Msg").Text, t, false)
		--timesChatted = timesChatted + 1
		--checkIfSpamming()
		end
		lastmsg = safeChat:WaitForChild("Back"):WaitForChild("Msg").Text 
	end
		chatting.Value = false
		safeChat:WaitForChild("Back"):WaitForChild("Msg").Text = ""
		safeChat.TextLabel.Visible = false
		safeChat.BackgroundTransparency = 1
		safeChat.rip.Visible = false
		safeChat.Back.Effect.Visible=false
		t = false
end)

local chats = script.Parent:WaitForChild("GUI"):WaitForChild("Main"):WaitForChild("Chats")

function moveOldMessages()
	for _, old in pairs(chats:GetChildren()) do
		old.Position = old.Position + UDim2.new(0, 0, 0, -18)
		local oldName = old.Name
		old.Name = tonumber(oldName + 1)

		if oldName + 1 >= 7 then
			old:Destroy()
		end
	end
end

function Chat2(text, textColor)
	moveOldMessages()
	local tagLabel = Instance.new("TextLabel")
	tagLabel.Name = "1"
	tagLabel.BackgroundTransparency = 1
	tagLabel.BorderSizePixel = 0
	tagLabel.ClipsDescendants = false
	tagLabel.TextScaled = false
	tagLabel.TextColor3 = textColor
	tagLabel.TextStrokeColor3 = Cnew(0, 0, 0)
	tagLabel.TextStrokeTransparency = 0.35
	tagLabel.TextWrapped = false
	tagLabel.Font = "SciFi"
	tagLabel.FontSize = "Size18"
	tagLabel.TextXAlignment = "Left"
	tagLabel.Text = text
	tagLabel.Position = UDim2.new(0, 0, 0, 90)
	tagLabel.Parent = chats
	tagLabel.Size = UDim2.new(0, tagLabel.TextBounds.X, 0, 18)
	tagLabel.ZIndex=15
	tagLabel.BackgroundColor3=Color3.new(25/255, 27/255, 31/255)
	tagLabel.BorderColor3=Color3.new(0, 0, 0)
	tagLabel.BackgroundTransparency=1
	tagLabel.BorderSizePixel=0
end

local filter = game:GetService("ReplicatedStorage"):WaitForChild("Functions"):WaitForChild("Filter")
function Chat(name, text, color, textcolor, plyrName, tag, tagColor)

	if plyrName then
		--text = game:GetService("Chat"):FilterStringAsync(text, game.Players:FindFirstChild(plyrName), game.Players.LocalPlayer)
		pcall(function() text = filter:InvokeServer(text, game.Players:FindFirstChild(plyrName)) end)
	end
	moveOldMessages()
	local tagLabel = nil
	if tag then
		tagLabel = Instance.new("TextLabel")
		tagLabel.Name = "1"
		tagLabel.BackgroundTransparency = 1
		tagLabel.BorderSizePixel = 0
		tagLabel.ClipsDescendants = false
		tagLabel.TextScaled = false
		tagLabel.TextColor3 = tagColor
		tagLabel.TextStrokeColor3 = Cnew(0, 0, 0)
		tagLabel.TextStrokeTransparency = 0.35
		tagLabel.TextWrapped = false
		tagLabel.Font = "SciFi"
		tagLabel.FontSize = "Size18"
		tagLabel.TextXAlignment = "Left"
		tagLabel.Text = tag
		tagLabel.Position = UDim2.new(0, 0, 0, 90)
		tagLabel.Parent = chats
		tagLabel.Size = UDim2.new(0, tagLabel.TextBounds.X, 0, 18)
		tagLabel.ZIndex=15
	tagLabel.BackgroundColor3=Color3.new(25/255, 27/255, 31/255)
	tagLabel.BorderColor3=Color3.new(0, 0, 0)
	tagLabel.BackgroundTransparency=1
	tagLabel.BorderSizePixel=0
	end
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "1"
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.ClipsDescendants = false
	nameLabel.TextScaled = false
	nameLabel.TextColor3 = color
	nameLabel.TextStrokeColor3 = Cnew(0, 0, 0)
	nameLabel.TextStrokeTransparency = 0.35
	nameLabel.TextWrapped = false
	nameLabel.Font = "SciFi"
	nameLabel.FontSize = "Size18"
	nameLabel.TextXAlignment = "Left"
	nameLabel.Text = name..": "
	nameLabel.Parent = chats
	nameLabel.ZIndex=15
	if tagLabel then
		nameLabel.Position = UDim2.new(0, tagLabel.TextBounds.X + 2, 0, 0)
		nameLabel.Parent = tagLabel
		nameLabel.Size = UDim2.new(0, nameLabel.TextBounds.X, 0, 18)
	else
		nameLabel.Position = UDim2.new(0, 0, 0, 90)
		nameLabel.Parent = chats
		nameLabel.Size = UDim2.new(0, nameLabel.TextBounds.X, 0, 18)
	end
	nameLabel.BackgroundColor3=Color3.new(25/255, 27/255, 31/255)
	nameLabel.BorderColor3=Color3.new(0, 0, 0)
	nameLabel.BackgroundTransparency=1
	nameLabel.BorderSizePixel=0	
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "1"
	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.ClipsDescendants = false
	textLabel.TextScaled = false
	textLabel.TextColor3 = textcolor
	textLabel.TextStrokeColor3 = Cnew(0, 0, 0)
	textLabel.TextStrokeTransparency = 0.35
	textLabel.TextWrapped = false
	textLabel.Font = "SciFi"
	textLabel.FontSize = "Size18"
	textLabel.TextXAlignment = "Left"
	textLabel.Text = text
	textLabel.ZIndex=15
	if tagLabel then
		textLabel.Parent = tagLabel
		textLabel.Position = UDim2.new(0, tagLabel.TextBounds.X + nameLabel.TextBounds.X + 2, 0, 0)
		textLabel.Size = UDim2.new(0, 446 - (tagLabel.TextBounds.X + nameLabel.TextBounds.X + 2), 0, 18)
	else
		textLabel.Parent = nameLabel
		textLabel.Position = UDim2.new(0, nameLabel.TextBounds.X + 2, 0, 0)
		textLabel.Size = UDim2.new(0, 446 - nameLabel.TextBounds.X - 2, 0, 18)
	end
	textLabel.BackgroundColor3=Color3.new(25/255, 27/255, 31/255)
	textLabel.BorderColor3=Color3.new(0, 0, 0)
	textLabel.BackgroundTransparency=1
	textLabel.BorderSizePixel=0	
	if textLabel.TextBounds.X > textLabel.Size.X.Offset then
		
		--textLabel.Position = textLabel.Position - UDim2.new(0, 0, 0, 1)
		textLabel.TextYAlignment = "Top"
		textLabel.TextWrapped = true
		moveOldMessages()
		if tagLabel then
			textLabel.Size = UDim2.new(0, 446 - (tagLabel.TextBounds.X + nameLabel.TextBounds.X + 2), 0, 36)
			tagLabel.Name = "0.5"
		else
			textLabel.Size = UDim2.new(0, 446 - nameLabel.TextBounds.X - 2, 0, 36)
			nameLabel.Name = "0.5"
		end
	end
end

function LoadCheck(plr, text, color, plyrName)
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
	local plyrAlive = plr:WaitForChild("Status"):WaitForChild("Alive").Value
	if plyrAlive and plyrName==nil and game.ReplicatedStorage.gametype.Value~="TTT" then
		local additionaltext=""
		if plr and plr:FindFirstChild("Location") and plr.Location.Value~="" then
			additionaltext=" @ "..plr.Location.Value
		end
	if plr:WaitForChild("Status").Team.Value == Player.Status.Team.Value or Player.Status.Team.Value=="Spectator" then
	Chat(plr.Name..additionaltext, text, color.Color, Cnew(1, 1, 1), plr.Name, "*RADIO*", Cnew(80/255, 120/255, 120/255))
	end

	return
	end

		if plr and plyrAlive then
			local tag=""
			if plr:GetRankInGroup(1)>=251 then
				tag="[MOD]"
			end
			if plr:GetRankInGroup(1)>=252 then
				tag="[DEV]"
			end
			Chat(plr.Name, text, color.Color, Cnew(1, 1, 1), plyrName, tag, Cnew(80/255, 120/255, 120/255))
		elseif plr.Name==Player.Name or plr.Name=="DevRolve" or Player.Name=="DevRolve" or (not Player.Status.Alive.Value and not plyrAlive and game.ReplicatedStorage.gametype.Value=="casual") or preparation.Value or roundOver.Value or game.ReplicatedStorage.gametype.Value=="competitive" and plr and plr:FindFirstChild("Status") and plr.Status.Team.Value~="Spectator" then
			if plr.Status.Team.Value=="Spectator" then
				Chat(plr.Name, text, color.Color, Cnew(1, 1, 1), plyrName, "*SPECTATOR*", Cnew(177/255, 177/255, 0))
			else
				Chat(plr.Name, text, color.Color, Cnew(1, 1, 1), plyrName, "*DEAD*", Cnew(170/255, 0, 0))	
			end
		end 
end

function TLoadCheck(plr, text, color)
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
	if plr:WaitForChild("Status").Team.Value == Player.Status.Team.Value or Player.Status.Team.Value=="Spectator" then
		local additionaltext=""
		if plr and plr:FindFirstChild("Location") and plr.Location.Value~="" then
			additionaltext=" @ "..plr.Location.Value
		end
		if game.ReplicatedStorage.gametype.Value~="TTT" then
			if plr.Status.Team.Value=="T" then
				Chat(plr.Name..additionaltext,text, color.Color, Cnew(1, 1, 1), plr.Name, "[T]", BrickColor.new("Deep orange").Color)
			else
				Chat(plr.Name..additionaltext,text, color.Color, Cnew(1, 1, 1), plr.Name, "[CT]", BrickColor.new("Really blue").Color)
			end
		else
			if plr.Status.Role.Value==Player.Status.Role.Value then
				Chat(plr.Name..additionaltext,text, color.Color, Cnew(1, 1, 1), plr.Name, "[T]", BrickColor.new("Really red").Color)
			end
		end
	end
end]]



--[[
game.ReplicatedStorage.Events.SendMsg.OnClientEvent:connect(function(val,color)
	if val ~= "" then
			if color then
			Chat2(val, color)
			else
			Chat2(val, Cnew(1,1,1))
			end
	end
end)]]


-- VOICES; removed
--[[
game.ReplicatedStorage.Events.SendVoice.OnClientEvent:connect(function(player,voice)
	local soundname="voice"
	if Player.PlayerGui.LocalSounds:FindFirstChild(soundname) then
		Player.PlayerGui.LocalSounds[soundname]:Stop()
		Player.PlayerGui.LocalSounds[soundname]:Destroy()
	end
	local voicesam=voice:clone()
	voicesam.Parent=Player.PlayerGui.LocalSounds
	voicesam.Name=soundname
	voicesam:Play()
end)
]]

--[[
function CheckSafeChat(plr) 
	plr.ChildAdded:connect(function(obj) 
		if obj:IsA("StringValue") and obj.Name == "ChatzMsg" then 

				LoadCheck(plr, obj.Value, Bnew("Parsley Blue"), plr.Name) 

		elseif obj:IsA("StringValue") and obj.Name == "QChatzMsg" then

				LoadCheck(plr, obj.Value, Bnew("Parsley Blue"), nil) 

		elseif obj:IsA("StringValue") and obj.Name == "TChatzMsg" then
			if plr and plr.Status.Alive.Value==true and game.ReplicatedStorage.gametype.Value=="casual" or game.ReplicatedStorage.gametype.Value=="competitive" or game.ReplicatedStorage.gametype.Value=="TTT" then
			TLoadCheck(plr, obj.Value, Bnew("Really red")) 
			end
		end
	end) 
end]]
--[[
game.Players.ChildAdded:connect(function(plr) 
	if plr and plr:IsA("Player") then
		CheckSafeChat(plr) 
	end
end)

local playas = game.Players:GetPlayers()
for i = 1, #playas do
	if playas[i] and playas[i]:IsA("Player") then
		CheckSafeChat(playas[i])
	end
	spawn(function()
		playas[i]:WaitForChild("Status"):WaitForChild("Team").Changed:connect(function(val)
			--generatePlayers()
		end)
		playas[i]:WaitForChild("Status"):WaitForChild("Alive").Changed:connect(function(val)
		--	generatePlayers()
		end)
	end)
end]]
-- END OF CHAT CODE

--[[

   ___   _____  _____  _________  _________     _       
 .'   `.|_   _||_   _||  _   _  ||  _   _  |   / \      
/  .-.  \ | |    | |  |_/ | | \_||_/ | | \_|  / _ \     
| |   | | | '    ' |      | |        | |     / ___ \    
\  `-'  /  \ \__/ /      _| |_      _| |_  _/ /   \ \_  
 `.___.'    `.__.'      |_____|    |_____||____| |____| 

 ____    ____  ____  ____  
|_   \  /   _||_  _||_  _| 
  |   \/   |    \ \  / /   
  | |\  /| |     \ \/ /    
 _| |_\/_| |_    _|  |_    
|_____||_____|  |______|   
                          
  ______     ______  _______     _____  _______   
.' ____ \  .' ___  ||_   __ \   |_   _||_   __ \  
| (___ \_|/ .'   \_|  | |__) |    | |    | |__) | 
 _.____`. | |         |  __ /     | |    |  ___/  
| \____) |\ `.___.'\ _| |  \ \_  _| |_  _| |_     
 \______.' `.____ .'|____| |___||_____||_____|        

--]]

--credits
--invensys
--inventory system
--inven area
--loadout area
--loadoutarea
--[[
	mightybaseplate- scripter
	mightybaseplate- builder
	mightybaseplate- ceoF
	mightybaseplate- graphics design
	mightybaseplate- ascii art copy paster
	mightybaseplate- scripter
	
--]]

InvenFrame = gui:WaitForChild("Inventory&Loadout")
Inventory = InvenFrame:WaitForChild("Inventory")
Loadout = InvenFrame:WaitForChild("Loadout")
--Factions = InvenFrame:WaitForChild("Factions")
ShopMenu = gui:WaitForChild("ShopMenu").TempMenu
CaseFrame = ShopMenu:WaitForChild("CaseFrame")


InvenFrame.Changed:connect(function(property)
	--print(property)
	if property == "Visible" then
--print ' property = visible '		
		if InvenFrame.Visible == true then
			--print ' invenframe visible true '
			GeneratePage(currentpage)
			InvenFrame.Visible = true 
		end		
	end
end)
switchb = InvenFrame.Switch
InvenFrame.Switch.MouseButton1Down:connect(function()	
	if currentteam == "CT" then		
		currentteam = "T" 
		else
		currentteam = "CT"
	end
	switchb.Image = switchb[currentteam].Value
	GeneratePage("All")	
end)
InvenFrame.Switch.MouseEnter:connect(function()
	switchb.Image = switchb[currentteam.."_Switch"].Value
end)
InvenFrame.Switch.MouseLeave:connect(function()
	switchb.Image = switchb[currentteam].Value
end)
function table2string(args)
	local returnstring = ""
	for q_=1, #args do
		returnstring = returnstring .. tostring(args[q_])
	end
	return returnstring
end
CurrentInventory,CTLoadout,TLoadout = game.ReplicatedStorage.Events.DataFunction:InvokeServer({"GetInventory&Loadout"})
FundsObj = player.SkinFolder.Funds
FundsObj.Changed:connect(function()
	ShopMenu.FundsMenu.Funds.Text = FundsObj.Value	
	ShopMenu.CasePreview.Funds.Text = FundsObj.Value
end)
ShopMenu.FundsMenu.Funds.Text = FundsObj.Value	
ShopMenu.CasePreview.Funds.Text = FundsObj.Value
CaseSelected = false
CurrentCase = nil
openingcase = false
ImageLibrary = script.Images
ShopMenu.CasePreview.buy.MouseButton1Down:connect(function()
	if openingcase == false then 
		openingcase = true
		game.ReplicatedStorage.Events.DataEvent:FireServer({"BuyCase",CurrentCase})
	end
end)
ShopMenu.CasePreview.back.MouseButton1Down:connect(function()
	if not Requesting then
		Requesting = true
		
		ShopMenu.CasePreview.Visible = false
		
		Requesting = false
		CaseSelected = false
	end
end)

function RequestSkins(Case,CaseInformation)
	--local Case = CurrentCase.Name
	--deb()--print("case clicked= "..Case)
	local CasePreview = ShopMenu.CasePreview
	CasePreview.Visible = true
	
	if not Requesting and not CaseSelected then	
		CurrentCase = Case
		Requesting = true
		CaseSelected = true
--		local casechildren = CurrentCase:GetChildren()
--		for i=1, #casechildren do
--			--print(casechildren[i].Name)
--		end

		local caseps = CasePreview.PotentialSkins:GetChildren()
		for i=1, #caseps do
			if caseps[i].ClassName ~= "UIGridLayout" then
				caseps[i]:Destroy()
			end
		end
		local CaseButton = CasePreview.Case --stinky
		CaseButton.Price.Value = CaseInformation[3]
		
		CaseButton.Image = CaseInformation[2]
	
		CaseButton.Title.Text = CurrentCase
		
		CasePreview.buy.Text = "Buy for :"..CaseButton.Price.Value.."$"
		local SkinList, SkinQuality = game.ReplicatedStorage.Events.DataFunction:InvokeServer({"RequestCaseContents",Case})
		repeat 
			wait()
			--Loading
			--debug--print("Loading")
		until SkinList and SkinQuality
		
		local CaseChildren = CaseFrame:GetChildren()
		CasePositionSave = {}

		--CaseFrame.PotentialSkins:TweenPosition(UDim2.new(0.3,0,0,0),Enum.EasingDirection.In,Enum.EasingStyle.Linear,.1)
		local skinX = 0.025
		local skinY = 0
		local queue = {}
		--blues
		local Doing = true
		local Status = 1
		local knife_1 = true
		while Doing do
			----print("Lets go")
			if Status == 6 then
				Doing = false
			end
			for i=1, #SkinList do
				local DoThisOne = false
				if Status == 1 then
					if SkinQuality[i] == "Blue" then		
						DoThisOne = true										
					end
				elseif Status == 2 then
					if SkinQuality[i] == "Purple" then
						DoThisOne = true
					end
				elseif Status == 3 then
					if SkinQuality[i] == "Pink" then
						DoThisOne = true
					end
				elseif Status == 4 then
					if SkinQuality[i] == "Red" then
						DoThisOne = true
					end
				elseif Status == 5 then
					if knife_1 then
						knife_1 = false
						local parta = split(SkinList[i],"_")
						local key = parta[1]
						local value = parta[2]
			
						local ImageButton = script.WeaponTemplate:Clone()
						--ImageButton.Position = UDim2.new(skinX,0,skinY,0) -- tween ?	
						ImageButton.Size = UDim2.new(.2,0,.3,0)					
						ImageButton.Parent = CasePreview.PotentialSkins
						ImageButton.Visible = true
						----print(key .. " | " .. value)
						--local DispName = ImageLibrary:FindFirstChild(key).DisplayName.Value
						ImageButton.Wep.Image = "http://www.roblox.com/asset/?id=537592824"
						
						ImageButton.NameLabel.Text = "Rare Knife"
						if Case == "Karambit Case" then
							ImageButton.Wep.Image = "http://www.roblox.com/asset/?id=686454796"
							ImageButton.NameLabel.Text = "Rare Karambit Knife"
						elseif Case == "Imaginem Case" then
							ImageButton.NameLabel.Text = "Rare Imaginem Knife"
						elseif Case == "Holiday Case 2" then
							ImageButton.Visible = false
						elseif Case == "Remastered Case" then
							ImageButton.NameLabel.Text = "Rare Gloves"
						end
						
						ImageButton.NameLabel.TextColor3 = Color3.new(1, 1, 0)
						skinX = skinX + .25
						if skinX > .8 then
							skinX = .025
							skinY = skinY + .35
						end
					end
				end
				if DoThisOne then
					local parta = split(SkinList[i],"_")
					local key = parta[1]
					local value = parta[2]
					--print("attempting to do " ..key .. value)
					local ImageButton = script.WeaponTemplate:Clone()
					--ImageButton.Position = UDim2.new(skinX,0,skinY,0) -- tween ?
					ImageButton.Size = UDim2.new(.2,0,.3,0)
					ImageButton.Parent = CasePreview.PotentialSkins
					ImageButton.Visible = true
					--print(key .. " | " .. value)
					
					local DispName = ImageLibrary:FindFirstChild(key).DisplayName.Value
					ImageButton.Wep.Image = ImageLibrary:FindFirstChild(key):FindFirstChild(value).Value
					ImageButton.NameLabel.Text = DispName .. " | " .. value
					ImageButton.NameLabel.TextColor3 = script.Colors:FindFirstChild(SkinQuality[i]).Value
					skinX = skinX + .25
					if skinX > .8 then
						skinX = .025
						skinY = skinY + .29
					end
				end
			end
			Status = Status + 1
		end
		
		--CaseFrame.buy:TweenPosition(UDim2.new(0.021,0,.55,0),Enum.EasingDirection.In,Enum.EasingStyle.Linear,.1)
		--CaseFrame.back:TweenPosition(UDim2.new(0.021,0,.65,0),Enum.EasingDirection.In,Enum.EasingStyle.Linear,.1)
		--pinks
		--purples
		--blues
		
		wait(.1)
		Requesting = false
	end
end

function RequestCases()
	--debug--print("Request Fired")
	local Cases , CaseImages, CasePrices = game.ReplicatedStorage.Events.DataFunction:InvokeServer({"RequestCases"})
	--debug--print("Gottem")
	repeat 
		wait()
		--Loading
		--debug--print("Loading")
	until Cases and CaseImages
	local X = 0
	local Y = 0
	--debug--print("Done loading AND CaseLength = "..#Cases)
	for i=1, #Cases do
		--debug--print("Currently doing "..Cases[i])
		local CurrentCase = script.Case:Clone()
		CurrentCase.Price.Value = CasePrices[i]
		CurrentCase.Parent = ShopMenu.CaseFrame
		CurrentCase.Image = CaseImages[i]
		CurrentCase.Name = Cases[i]
		CurrentCase.Title.Text = Cases[i]
		CurrentCase.Position = UDim2.new(X,0,Y,0)
		--CurrentCase:TweenPosition(UDim2.new(X,0,Y,0),Enum.EasingDirection.In,Enum.EasingStyle.Sine,.1)
		CurrentCase.Visible = true
		X = X + .25
		if X >= 1 then
			X = 0 
			Y = Y + .35 --request case contents
		end
		wait(.05)
		CurrentCase.MouseButton1Down:connect(function()
			RequestSkins(CurrentCase.Name,{Cases[i],CaseImages[i],CasePrices[i]})
		end)
	end
end
RequestCases()

local numslots=0
SkinWon = ShopMenu:WaitForChild("SkinWon")
--
function generate(key,value,Quality,CaseName)
	Requesting = false
	local slot=script:WaitForChild("Skin"):clone()
	slot.Parent=ShopMenu.Wheel.Wheel	
	--slot.ZIndex = slot.ZIndex + 20
	slot.Position=UDim2.new(0,(220*numslots)+990,0,0)
	numslots=numslots+1
	slot:WaitForChild("Serial").Value=numslots
	slot.Visible=false
	if slot.Serial.Value==87 then
		slot.Visible = true
	else
		local CaseChildren = game.ReplicatedStorage.Cases:GetChildren()
		local CaseOpened = nil
		for i=1, #CaseChildren do
			----print("Searching casechildren")
			if CaseChildren[i].Name == CaseName then
				CaseOpened = CaseChildren[i]
				----print ' o ya thats the one '
			end
		end
		local BlueTable = {} 
		local PurpleTable = {}
		local PinkTable = {}
		local RedTable = {}
		--5/1200
		if CaseOpened ~= nil then			
			local SkinChildren = CaseOpened:GetChildren()
			for i=1, #SkinChildren do
				if SkinChildren[i]:IsA("StringValue") then
					if SkinChildren[i].Value == "Blue" then
						table.insert(BlueTable,1,SkinChildren[i].Name)
					elseif SkinChildren[i].Value == "Purple" then
						table.insert(PurpleTable,1,SkinChildren[i].Name)
					elseif SkinChildren[i].Value == "Pink" then
						table.insert(PinkTable,1,SkinChildren[i].Name)
					elseif SkinChildren[i].Value == "Red" then
						table.insert(RedTable,1,SkinChildren[i].Name)
					end					
				end
			end
		end
		--math.randomseed(random)
		local Chance = math.random(1,1192)
		local Type = ""
		if Chance >= 480-8 then
			--blue
			Type = "Blue"
		elseif Chance >=  150-8 then
			--purple
			Type = "Purple"
		elseif Chance >= 50-8 then
			--pink
			Type = "Pink"
		elseif Chance >= 7 then --orig 5 
			--red
			Type = "Red"
		elseif Chance >= 0 then
			--knife
			----print ' knieeef'
			Type = "Knife"
		end
		local earnedSkin = ""
		if CaseName == "Holiday Case 2" then
			Type = "Blue"
		end
		if Type == "Blue" then
			local skin = math.random(1,#BlueTable)
			earnedSkin = BlueTable[skin]
		elseif Type == "Purple" then
			local skin = math.random(1,#PurpleTable)

			earnedSkin = PurpleTable[skin]
		elseif Type == "Pink" then
			local skin = math.random(1,#PinkTable)
			earnedSkin = PinkTable[skin]
		elseif Type == "Red" then
			local skin = math.random(1,#RedTable)
			earnedSkin = RedTable[skin]
		elseif Type == "Knife" then 
			--uh oh
			local PossibleKnives = game.ReplicatedStorage.Knives:GetChildren()
			if CaseName == "Karambit Case" then				
				PossibleKnives = game.ReplicatedStorage.KarambitKnives:GetChildren()
			elseif CaseName == "Imaginem Case" then
				PossibleKnives = game.ReplicatedStorage.ImaginemKnives:GetChildren()
			elseif CaseName == "Halloween Case" then
				PossibleKnives = game.ReplicatedStorage.HallowsKnives:GetChildren()
			elseif CaseName == "Halloween Case 2018" then
				PossibleKnives = game.ReplicatedStorage.Halloween2018Knives:GetChildren()
			elseif CaseName == "Remastered Case" then
				PossibleKnives = game.ReplicatedStorage.GlovesSkins:GetChildren()
			end
			
			local Selected = math.random(1,#PossibleKnives)
			--print(PossibleKnives[Selected])
			earnedSkin = PossibleKnives[Selected].Name
			--game.Workspace.ServerFeed.Value = "WOAH!" .. player.Name.. " has unboxed a KNIFE!"
		end		
		local quality = Type
		Quality=quality
		local parta = split(earnedSkin,"_")
		key = parta[1]
		value = parta[2]
	end
	slot.WeaponTemplate.Wep.Image = ImageLibrary:FindFirstChild(key):FindFirstChild(value).Value
	slot.WeaponTemplate.NameLabel.Text = key .. " | " .. value
	if Quality == "Knife" then
		SkinWon.WeaponTemplate.NameLabel.Text = ImageLibrary:FindFirstChild(key):FindFirstChild(value).DisplayName.Value
	end
	slot.WeaponTemplate.NameLabel.TextColor3 = script.Colors:FindFirstChild(Quality).Value
end

game.ReplicatedStorage.Events.DataEvent.OnClientEvent:connect(function(args)
	if args[1] == "PurchaseCompleted" then -- beep beep lettuce
		ShopMenu.Back.Visible=false
		Requesting = false
		caseopening=-5
		--print(" the client now knows, "..SkinEarned .. Quality)
		--script.Parent.Visible=false
		--d o this
		-- load unbox area
		numslots=0
--	    distancemove=220/3
--	    makesounddist=990+220
--		ShopMenu.Wheel.Visible=true
--		local shite=ShopMenu.Wheel.Wheel:GetChildren()
--		if #shite>=1 then
--			for i=1,#shite do
--				shite[i]:Destroy()
--			end
--		end
--			for i=1,100 do
--			generate(key,value,Quality,assetId)
--			end
--			
--		ShopMenu.Wheel.Wheel.CanvasPosition=Vector2.new(0,0)
--		while distancemove>0 do
--			_Run.Stepped:wait()
--			ShopMenu.Wheel.Wheel.CanvasPosition=Vector2.new(ShopMenu.Wheel.Wheel.CanvasPosition.X+distancemove,0)
--			distancemove=math.max(0,distancemove-(0.14))
--			if ShopMenu.Wheel.Wheel.CanvasPosition.X>makesounddist then
--				caseopening=caseopening+1
--				makesounddist=makesounddist+(220)
--				local scroll=script.Scroll:clone()
--				scroll.Parent=script
--				scroll.Name="SE"
--				scroll.PlayOnRemove=true
--				scroll:Destroy()
--			end
--		end
		wait(4)
		ShopMenu.Wheel.Visible=false
		openingcase = false
		ShopMenu.Back.Visible=true
	elseif args[1] == "RefreshInventory" then
		CurrentInventory,CTLoadout,TLoadout = game.ReplicatedStorage.Events.DataFunction:InvokeServer({"GetInventory&Loadout"})

		repeat wait()
			----print("loading")
		until CurrentInventory and CTLoadout and TLoadout
		--loadingframe.Visible = false
		GeneratePage("All")	
	end
end)

--repeat wait() 
--	--print('loading') --hopefully this dosnt seize the whole client if something is loading
--until CurrentInventory and CTLoadout and TLoadout
Page = "All"
function split(str, split)
	local splitter = split
	if splitter == nil then
		splitter = " "
	end 
	local num = 1
	local tab = {}
	local q = ""
	for i=1,string.len(str) do
		if string.sub(str,i,i)~= splitter then
			q = q..string.sub(str,i,i)
		else
			tab[num] = q
			q = ""
			num = num+1
		end
	end
	if q~="" then
		tab[num] = q
	end
	return tab
end
RClickframe = InvenFrame:WaitForChild("RClickFrame")
RClickframe.MouseLeave:connect(function()
	RClickframe.Visible = false
end)
rclickcurrentitem = 0
RClickframe.EquipT.MouseButton1Down:connect(function()
	equipitem(rclickcurrentitem,"T")
end)
RClickframe.EquipCT.MouseButton1Down:connect(function()
	equipitem(rclickcurrentitem,"CT")
end)
RClickframe.EquipBoth.MouseButton1Down:connect(function()
	equipitem(rclickcurrentitem,"Both")
end)

Mouse = game.Players.LocalPlayer:GetMouse()
currentpage = ""
currentteam = "CT"
CurrentKnives = {"Bayonet","Huntsman Knife","Falchion Knife","Karambit","Gut Knife","Butterfly Knife", "Banana","Sickle","Bearded Axe","Cleaver"}
CurrentGloves = {"Sports Glove","Strapped Glove","Fingerless Glove","Handwraps"}
function equipitem(invennum,team)
	----print(invennum)
	local item2equip = CurrentInventory[invennum]
	--print(item2equip)
	local physicalitem = item2equip[1]
	local splitter = split(physicalitem,"_")
	local weapon = splitter[1]
	local skin = splitter[2]
	
	for i=1, #CurrentKnives do
		if CurrentKnives[i] == weapon then
			weapon = "Knife"
			--print("Gun set to knife")
		end
	end
	for i=1, #CurrentGloves do
		if CurrentGloves[i] == weapon then
			weapon = "Glove"
			--print("Gun set to glove")
		end
	end
	--gon send to server for them to handle it, and then it will come back to client
	--once done, but for now some of this code will be client
	--dont forget fuckface
	local specialover = nil
	
	if (team == "CT" or team == "Both") and CTLoadout[weapon] then	
		--this weapon is able to be equipped on this team
		if weapon == "M4A1" then
			CTLoadout["M4A1Over"] = true
			CTPrimary = "M4A1"
			specialover = {"M4A1Over",true}
		elseif weapon == "M4A4" then
			CTLoadout["M4A1Over"] = false
			CTPrimary = "M4A4"
			specialover = {"M4A1Over",false}
		end
		if weapon == "USP" then
			CTLoadout["USPOver"] = true
			CTPrimaryPistol = "USP"
			specialover = {"USPOver",true}
		elseif weapon == "P2000" then
			CTLoadout["USPOver"] = false
			CTPrimaryPistol = "P2000"
			specialover = {"USPOver",false}
		end
		if weapon == "CZ" then
			CTLoadout["CZOver"] = true
			CTTacticalPistol="CZ"
			specialover = {"CZOver",true}
		elseif weapon == "FiveSeven" then
			CTLoadout["CZOver"] = false
			CTTacticalPistol="FiveSeven"
			specialover = {"CZOver",false}
		end
		if weapon == "R8" then
			CTLoadout["R8Over"] = true
			CTDeag="R8"
			specialover = {"R8Over",true}
		elseif weapon == "DesertEagle" then
			CTLoadout["R8Over"] = false
			CTDeag="DesertEagle"
			specialover = {"R8Over",false}
		end
		if weapon == "CTKnife" then
			CTLoadout["KnifeOver"] = false
			specialover = {"KnifeOver",false}
		elseif weapon == "Knife" then
			CTLoadout["KnifeOver"] = true
			specialover = {"KnifeOver",true}
		end
		if weapon == "CTGlove" then
			CTLoadout["GloveOver"] = false
			specialover = {"GloveOver",false}
		elseif weapon == "Glove" then
			CTLoadout["GloveOver"] = true
			specialover = {"GloveOver",true}
		end
		CTLoadout[weapon] = item2equip
		
	end
	if (team == "T" or team == "Both") and TLoadout[weapon] then	
		--this weapon is able to be equipped on this team			
		if weapon == "CZ" then
			TLoadout["CZOver"] = true
			TTacticalPistol = "CZ"
			specialover = {"CZOver",true}
		elseif weapon == "Tec9" then
			TLoadout["CZOver"] = false
			TTacticalPistol = "Tec9"
			specialover = {"CZOver",false}
		end
		if weapon == "R8" then
			TLoadout["R8Over"] = true
			TDeag="R8"
			specialover = {"R8Over",true}
		elseif weapon == "DesertEagle" then
			TLoadout["R8Over"] = false
			TDeag="DesertEagle"
			specialover = {"R8Over",false}
		end
		if weapon == "TKnife" then
			TLoadout["KnifeOver"] = false
			specialover = {"KnifeOver",false}
		elseif weapon == "Knife" then
			TLoadout["KnifeOver"] = true
			specialover = {"KnifeOver",true}
		end
		if weapon == "TGlove" then
			TLoadout["GloveOver"] = false
			specialover = {"GloveOver",false}
		elseif weapon == "Glove" then
			TLoadout["GloveOver"] = true
			specialover = {"GloveOver",true}
		end
		TLoadout[weapon] = item2equip	
	end
	
	GeneratePage(currentpage)
	game.ReplicatedStorage.Events.DataEvent:FireServer({"EquipItem",team,weapon,item2equip,specialover})
	--print("local save")
end

function GeneratePage(Page)
	local currentitem = 0
	currentpage = Page
	RClickframe.Visible = false
	local invenchild = Inventory:GetChildren() 
	for i=1, #invenchild do
		if invenchild[i]:IsA("ImageButton") then
			invenchild[i]:Destroy()
		end
	end
	local loadoutchild = Loadout:GetChildren()
	for i=1, #loadoutchild do
		if loadoutchild[i]:IsA("ImageButton") then
			loadoutchild[i]:Destroy()
		end
	end
	local amnt = 0
	
	for i=1, #CurrentInventory do
		pcall(function()
		--print(tostring(CurrentInventory[i][1]) .. tostring(CurrentInventory[i][2]))
		local currentitem = split(CurrentInventory[i][1],"_")
		local item = currentitem[1]
		local skin = currentitem[2]
		local trueitem = item
		for g=1, #CurrentKnives do
			if item == CurrentKnives[g] then
				trueitem = "Knife"
			end
		end
		for g=1, #CurrentGloves do
			if item == CurrentGloves[g] then
				trueitem = "Glove"
			end
		end
	--	print("Item: "..item)
	--	print("skin : "..skin)
		----print(item)
		if script.Images:FindFirstChild(item).Value == Page or Page == "All" then
			if Inventory:FindFirstChild(table2string(CurrentInventory[i])) == nil then
				local template = script.WeaponTemplate:Clone()
				template.Name = i
				template.Parent = Inventory
				
				if i == 521 then
				--	print("Step 1")
				--	print(item .. skin)
				end
				--template.NameLabel.Text = CurrentInventory[i][1]
				if CurrentInventory[i][2] ~= nil and CurrentInventory[i][2] ~= "StatTrak" then
					--override color3
					----print(CurrentInventory[i][2])
					template.NameLabel.TextColor3 = script.ColorLibrary:FindFirstChild(CurrentInventory[i][2]).Value
				end
				--print(script.Images[item])
				local DispName = script.Images:FindFirstChild(item):FindFirstChild("DisplayName")
				if DispName ~= nil then
					DispName = DispName.Value
				else
					DispName = CurrentInventory[i][1]
				end			
				local Quality =  ImageLibrary:FindFirstChild(item):FindFirstChild(skin):FindFirstChild("Quality")	
				if Quality ~= nil then
					
					Quality = ImageLibrary:FindFirstChild(item):FindFirstChild(skin).Quality.Value
					
				else					
					Quality = "Knife"
					if skin == "Stock" then
						Quality = "Stock"
					end
				end
				template.Wep.Image = script.Images:FindFirstChild(item):FindFirstChild(skin).Value
				template.NameLabel.Text = DispName .. " | " .. skin
				template.Quality.BackgroundColor3 = script.Colors:FindFirstChild(Quality).Value
				template.Wep.Image = script.Images:FindFirstChild(item):FindFirstChild(skin).Value 	
				--finale = template.Position.Y.Offset
				----print(finale)
				amnt = amnt + 1
				if CTLoadout[trueitem] ~= nil then
					template.CTCheck.Visible = true
					--CTLoadout[item]
					--print("Comparing " .. table2string(CTLoadout[trueitem]) .. " to : "..table2string(CurrentInventory[i]))
					if table2string(CTLoadout[trueitem]) == table2string(CurrentInventory[i]) then
						template.CTCheck.Text = "?"
						--print("Found " .. table2string(CTLoadout[trueitem]))
					end
					if item == "M4A1" then
						if CTLoadout["M4A1Over"] == false then
							template.CTCheck.Text = ""
						end
					elseif item == "M4A4" then
						if CTLoadout["M4A1Over"] == true then
							template.CTCheck.Text = ""
						end
					end
					if item == "USP" then
						if CTLoadout["USPOver"] == false then
							template.CTCheck.Text = ""
						end						
					elseif item == "P2000" then
						if CTLoadout["USPOver"] == true then
							template.CTCheck.Text = ""
						end		
					end
					if item == "CZ" then
						if CTLoadout["CZOver"] == false then
							template.CTCheck.Text = ""
						end								
					elseif item == "FiveSeven" then
						if CTLoadout["CZOver"] == true then
							template.CTCheck.Text = ""
						end						
					end
					if item == "R8" then
						if CTLoadout["R8Over"] == false then
							template.CTCheck.Text = ""
						end						
					elseif item == "DesertEagle" then
						if CTLoadout["R8Over"] == true then
							template.CTCheck.Text = ""
						end						
					end
					if trueitem == "CTKnife" then
						if CTLoadout["KnifeOver"] == true then
							template.CTCheck.Text = ""
						end						
					elseif trueitem == "Knife" then
						if CTLoadout["KnifeOver"] == false then
							template.CTCheck.Text = ""
						end		
					end
					if trueitem == "CTGlove" then
						if CTLoadout["GloveOver"] == true then
							template.CTCheck.Text = ""
						end						
					elseif trueitem == "Glove" then
						if CTLoadout["GloveOver"] == false then
							template.CTCheck.Text = ""
						end		
					end
					
				end
				if TLoadout[trueitem] ~= nil then
					template.TCheck.Visible = true
					if table2string(TLoadout[trueitem]) == table2string(CurrentInventory[i]) then
						template.TCheck.Text = "?"
						--print("Found " .. table2string(TLoadout[trueitem]))
					end
					if item == "CZ" then
						if TLoadout["CZOver"] == false then
							template.TCheck.Text = ""
						end								
					elseif item == "Tec9" then
						if TLoadout["CZOver"] == true then
							template.TCheck.Text = ""
						end						
					end
					if item == "R8" then
						if TLoadout["R8Over"] == false then
							template.TCheck.Text = ""
						end						
					elseif item == "DesertEagle" then
						if TLoadout["R8Over"] == true then
							template.TCheck.Text = ""
						end						
					end
					if trueitem == "TKnife" then
						if TLoadout["KnifeOver"] == true then
							template.TCheck.Text = ""
						end						
					elseif trueitem == "Knife" then
						if TLoadout["KnifeOver"] == false then
							template.TCheck.Text = ""
						end		
					end
					if trueitem == "TGlove" then
						if TLoadout["GloveOver"] == true then
							template.TCheck.Text = ""
						end						
					elseif trueitem == "Glove" then
						if TLoadout["GloveOver"] == false then
							template.TCheck.Text = ""
						end		
					end
				end
				template.Name = table2string(CurrentInventory[i])
				if istenfoot then
					template.MouseButton1Down:Connect(function()
						_gui.SelectedObject = template.Parent.Parent.topbuttons.Pistol
						if CTLoadout[trueitem] and TLoadout[trueitem] then
							equipitem(i,"Both")
						elseif CTLoadout[trueitem] then
							equipitem(i,"CT")
						elseif TLoadout[trueitem] then
							equipitem(i,"T")
						end
						
						return
					end)
				else
					template.Wep.MouseButton1Down:Connect(function()

					RClickframe.Visible = true
					if CTLoadout[trueitem] then
						RClickframe.EquipCT.Visible = true
					else
						RClickframe.EquipCT.Visible = false
					end
					if TLoadout[trueitem] then
						RClickframe.EquipT.Visible = true
					else
						RClickframe.EquipT.Visible = false
					end
					if RClickframe.EquipT.Visible and RClickframe.EquipCT.Visible then
						RClickframe.EquipBoth.Visible = true
					else
						RClickframe.EquipBoth.Visible = false
					end
					RClickframe.Position = UDim2.new(0,Mouse.X-10,0,Mouse.Y-10)
					currentitem = i
					rclickcurrentitem = i
				end)
						--gigga
				end

				
				
			else
				local template = Inventory:FindFirstChild(table2string(CurrentInventory[i]))				
				template.amount.count.Value = template.amount.count.Value + 1
				template.amount.Text = "x"..template.amount.count.Value
				template.amount.Visible = true
			end
			
		end
		end)
		
	end
	--print(tostring(CTLoadout["M4A1Over"]).. " is m4a1 over")
	if CTLoadout["M4A1Over"] == true then
		CTPrimary = "M4A1"
	--	print("set CTPrimary to "..CTPrimary)
	else
		CTPrimary = "M4A4"
	--	print("set CTPrimary to "..CTPrimary)
	end
	if CTLoadout["CZOver"] == true then
		CTTacticalPistol = "CZ"
	--	print("set CTPrimary to "..CTPrimary)
	else
		CTTacticalPistol = "FiveSeven"
	--	print("set CTPrimary to "..CTPrimary)
	end
	if CTLoadout["R8Over"] == true then
		CTDeag = "R8"
	--	print("set CTPrimary to "..CTPrimary)
	else
		CTDeag = "DesertEagle"
	--	print("set CTPrimary to "..CTPrimary)
	end
	if TLoadout["CZOver"] == true then
		TTacticalPistol = "CZ"
	--	print("set CTPrimary to "..CTPrimary)
	else
		TTacticalPistol = "Tec9"
	--	print("set CTPrimary to "..CTPrimary)
	end
	if TLoadout["R8Over"] == true then
		TDeag = "R8"
	--	print("set CTPrimary to "..CTPrimary)
	else
		TDeag = "DesertEagle"
	--	print("set CTPrimary to "..CTPrimary)
	end
	if CTLoadout["USPOver"] == true then
		CTPrimaryPistol = "USP"
	else
		CTPrimaryPistol = "P2000"
	end
	updateloadout()
	local amountofloadout = 0
	if currentteam == "CT" then
		for key, value in pairs(CTLoadout) do
			pcall(function()
				if value == true or value == false or value == "" then
					----print("boolean lol")
				else
					
					local currentitem = split(value[1],"_")
					local item = currentitem[1]
					local skin = currentitem[2]
					----print(item .. " is in ct loadout")
					if script.Images:FindFirstChild(item).Value == Page or Page == "All" then
						local template = script.WeaponTemplate:Clone()
						template.Name = "fish"
						template.Parent = Loadout
						template.NameLabel.Text = value[1]
						if value[2] ~= nil and value[2] ~= "StatTrak" then
							--override color3
							----print(value[2])
							template.NameLabel.TextColor3 = script.ColorLibrary:FindFirstChild(value[2]).Value
						end
						template.Wep.Image = script.Images:FindFirstChild(item):FindFirstChild(skin).Value 	
						amountofloadout = amountofloadout + 75
					end
				end
			end)
		end
		--Loadout.CanvasSize = UDim2.new(0,0,0,amountofloadout)
		Loadout.CanvasSize = UDim2.new(0, 0, 0, Loadout.UIGridLayout.AbsoluteContentSize.Y+3)
	end
	if currentteam == "T" then
		for key, value in pairs(TLoadout) do
			pcall(function()
				if value == true or value == false or value == "" then
					----print("boolean lol")
				else
					local currentitem = split(value[1],"_")
					local item = currentitem[1]
					local skin = currentitem[2]
					----print(item .. " is in t loadout")
					if script.Images:FindFirstChild(item).Value == Page or Page == "All" then
						local template = script.WeaponTemplate:Clone()
						template.Name = "fish"
						template.Parent = Loadout
						template.NameLabel.Text = value[1]
						if value[2] ~= nil and value[2] ~= "StatTrak" then
							--override color3
							----print(value[2])
							template.NameLabel.TextColor3 = script.ColorLibrary:FindFirstChild(value[2]).Value
						end
						template.Wep.Image = script.Images:FindFirstChild(item):FindFirstChild(skin).Value 	
						amountofloadout = amountofloadout + 75
					end
				end
			end)	
		end
		--Loadout.CanvasSize = UDim2.new(0,0,0,amountofloadout)
		Loadout.CanvasSize = UDim2.new(0, 0, 0, Loadout.UIGridLayout.AbsoluteContentSize.Y+3)
	end
	wait(0.1)
	--Inventory.CanvasSize = UDim2.new(0,0,amnt/10,0)
	Inventory.CanvasSize = UDim2.new(0, 0, 0, Inventory.UIGridLayout.AbsoluteContentSize.Y+3)
end
GeneratePage("All")
topbuttons = InvenFrame:WaitForChild("topbuttons")
topbuttonschild = topbuttons:GetChildren()
for i=1, #topbuttonschild do
	topbuttonschild[i].MouseButton1Down:connect(function()
		----print("poke")
		GeneratePage(topbuttonschild[i].Name)
	end)
end

--[[

   ___   _____  _____  _________  _________     _       
 .'   `.|_   _||_   _||  _   _  ||  _   _  |   / \      
/  .-.  \ | |    | |  |_/ | | \_||_/ | | \_|  / _ \     
| |   | | | '    ' |      | |        | |     / ___ \    
\  `-'  /  \ \__/ /      _| |_      _| |_  _/ /   \ \_  
 `.___.'    `.__.'      |_____|    |_____||____| |____| 

 ____    ____  ____  ____  
|_   \  /   _||_  _||_  _| 
  |   \/   |    \ \  / /   
  | |\  /| |     \ \/ /    
 _| |_\/_| |_    _|  |_    
|_____||_____|  |______|   
                          
  ______     ______  _______     _____  _______   
.' ____ \  .' ___  ||_   __ \   |_   _||_   __ \  
| (___ \_|/ .'   \_|  | |__) |    | |    | |__) | 
 _.____`. | |         |  __ /     | |    |  ___/  
| \____) |\ `.___.'\ _| |  \ \_  _| |_  _| |_     
 \______.' `.____ .'|____| |___||_____||_____|        

--]]

-- SUIT ZOOM CODE

-- Variables For The Suit Zoom Keys
local keys = suitZoom2:WaitForChild("Keys1")

function adjustVisibility()
	if suitZoom2.Visible then --If it's visible
		if Player:FindFirstChild("Dux") then
			Player:FindFirstChild("Dux"):Destroy()
		end
		if Player:FindFirstChild("Waiting") then
			Player.Waiting:Destroy()
		end
		suitZoom2.Visible = false
	else -- Otherwise
		suitZoom2.Visible = true -- Make it visible
		
		local waiting = Instance.new("IntValue")
		waiting.Name = "Waiting"
		delay(3,function()
			waiting:Destroy()
		end)
		waiting.Parent = Player
		spawn(function()
			repeat _Run.Heartbeat:wait() until game.Players.LocalPlayer:FindFirstChild("Waiting") == nil 
			if Player:FindFirstChild("Dux") then
				Player:FindFirstChild("Dux"):Destroy()
			end
			suitZoom2.Visible = false
		end)
	end
end
-- Open/Close The suitZoom2 Keys
mouse.KeyDown:connect(function(key)
	if alive.Value and Player.Character and canTalk.Value then
		if game.ReplicatedStorage.gametype.Value=="TTT" then
			return
		end
		if key:lower() == "z" then
		if script.Parent.GUI.SuitZoom.Keys1.Visible==true or script.Parent.GUI.SuitZoom.Visible==false then
			adjustVisibility()
		end
		script.Parent.GUI.SuitZoom.Keys1.Visible=true
		script.Parent.GUI.SuitZoom.Keys2.Visible=false
		script.Parent.GUI.SuitZoom.Keys3.Visible=false
		keys = suitZoom2:WaitForChild("Keys1")
		elseif key:lower() == "x" then
		if script.Parent.GUI.SuitZoom.Keys2.Visible==true or script.Parent.GUI.SuitZoom.Visible==false then
			adjustVisibility()
		end
		script.Parent.GUI.SuitZoom.Keys1.Visible=false
		script.Parent.GUI.SuitZoom.Keys2.Visible=true
		script.Parent.GUI.SuitZoom.Keys3.Visible=false
		keys = suitZoom2:WaitForChild("Keys2")
		--[[elseif key:lower() == "c" then--and game.Players.LocalPlayer.LocalData.AltCrouch.Value == false then
		if script.Parent.GUI.SuitZoom.Keys3.Visible==true or script.Parent.GUI.SuitZoom.Visible==false then
			adjustVisibility()
		end
		script.Parent.GUI.SuitZoom.Keys1.Visible=false
		script.Parent.GUI.SuitZoom.Keys2.Visible=false
		script.Parent.GUI.SuitZoom.Keys3.Visible=true
		keys = suitZoom2:WaitForChild("Keys3")]]
		elseif key:lower() == "v" then--and game.Players.LocalPlayer.LocalData.AltCrouch.Value == true then
			if script.Parent.GUI.SuitZoom.Keys3.Visible==true or script.Parent.GUI.SuitZoom.Visible==false then
			adjustVisibility()
		end
		script.Parent.GUI.SuitZoom.Keys1.Visible=false
		script.Parent.GUI.SuitZoom.Keys2.Visible=false
		script.Parent.GUI.SuitZoom.Keys3.Visible=true
		keys = suitZoom2:WaitForChild("Keys3")
		end
	end
end)

--Cursor Function Updating The suitZoom2 Keys


--Mouse Movement Function



UIS.InputBegan:connect(function(key)
	if script.Parent:FindFirstChild("GUI") and (script.Parent.GUI.Main.GlobalChat.ActiveOne.Value==true or script.Parent.GUI.Main.TeamChat.ActiveOne.Value==true) then
		return
	end

	if suitZoom2.Visible and alive.Value and Player.Character and canTalk.Value and chatvoicedeb==false then

		local valid=false
			local ttg=game.Workspace.Map.Tee.Value
			if Player and Player.Status.Team.Value=="CT" then
				ttg=game.Workspace.Map.CeeT.Value
			end
			if game.ReplicatedStorage.Voices:FindFirstChild(ttg) then
				if key.KeyCode == Enum.KeyCode.One then
					valid=true
					if keys.Name=="Keys3" then
					chatMessage(keys["1"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["spotted"])
					elseif keys.Name=="Keys2" then
					chatMessage(keys["1"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["affirm"])
					elseif keys.Name=="Keys1" then
					chatMessage(keys["1"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["go"])
					end
				elseif key.KeyCode == Enum.KeyCode.Two then
					valid=true
					if keys.Name=="Keys3" then
					chatMessage(keys["2"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["backup"])
					elseif keys.Name=="Keys2" then
					chatMessage(keys["2"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["nega"])
					elseif keys.Name=="Keys1" then
					chatMessage(keys["2"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["fallback"])
					end
				elseif key.KeyCode == Enum.KeyCode.Three then
					valid=true
					if keys.Name=="Keys3" then
					chatMessage(keys["3"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["takepoint"])
					elseif keys.Name=="Keys2" then
					chatMessage("1. Cheer!",game.ReplicatedStorage.Voices:FindFirstChild(ttg)["brag"])
					elseif keys.Name=="Keys1" then
					chatMessage(keys["3"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["regroup"])
					end
				elseif key.KeyCode == Enum.KeyCode.Four then
					valid=true
					if keys.Name=="Keys3" then
					chatMessage(keys["4"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["clear"])
					elseif keys.Name=="Keys2" then
					chatMessage("1. Nice!",game.ReplicatedStorage.Voices:FindFirstChild(ttg)["brag"])
					elseif keys.Name=="Keys1" then
					chatMessage(keys["4"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["hold"])
					end
				elseif key.KeyCode == Enum.KeyCode.Five then
					valid=true
					if keys.Name=="Keys3" then
					chatMessage(keys["5"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["inposition"])
					elseif keys.Name=="Keys2" then
					chatMessage(keys["5"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["thanks"])
					elseif keys.Name=="Keys1" then
					chatMessage(keys["5"].Text,game.ReplicatedStorage.Voices:FindFirstChild(ttg)["followme"])
					end
				elseif key.KeyCode == Enum.KeyCode.Zero then
					adjustVisibility()
				end
			end
	end
	
	if key.UserInputType == Enum.UserInputType.MouseButton3 and alive.Value and Player.Character and canTalk.Value then
		adjustVisibility()
	end
	
end)
-- END OF SUIT ZOOM CODE



mouse.Button1Down:connect(function()

		if not UIS.MouseIconEnabled then
			Held=true
		end

end)
mouse.KeyDown:connect(function(key)
	if key:lower()=="e" and equipped=="equipment2" then
		Held=true
	end
end)
mouse.KeyUp:connect(function(key)
	if key:lower()=="e" and equipped=="equipment2" then
		Held=false
	if fireani and fireani.IsPlaying==true then
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("HUD") then
		Camera.Arms.HUD.SurfaceGui.TextLabel.Text="*******"
		end
		if player.Character and player.Character:FindFirstChild("Gun") and player.Character.Gun:FindFirstChild("Planting") then
		player.Character.Gun.Planting:Stop()
		end
		game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("StopFire")
	fireani:Stop(.4,nil,nil)
	fire:Stop(.4,nil,nil)
	end
	end
end)
mouse.Button1Up:connect(function()
if equipped=="equipment2" then
	if fireani and fireani.IsPlaying==true then
		if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("HUD") then
		Camera.Arms.HUD.SurfaceGui.TextLabel.Text="*******"
		end
		if player.Character and player.Character:FindFirstChild("Gun") and player.Character.Gun:FindFirstChild("Planting") then
		player.Character.Gun.Planting:Stop()
		end
	fireani:Stop(.4,nil,nil)
	fire:Stop(.4,nil,nil)
	end
end
if pulling==true then
	if pullani then
		pullani:Stop(0.2)
	end
	pulling=false
	if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("unpull") then
		Character.Gun.unpull:Play()
	end
end
Held=false
mouseDown = false
	if (equipped=="grenade" and grenade~="" or equipped=="grenade2" and grenade2~="" or equipped=="grenade3" and grenade3~="" or equipped=="grenade4" and grenade4~="")  and idleani and idleani.IsPlaying==true and fire2ani and fire2ani.IsPlaying==false and fireani and fireani.IsPlaying==false and Held2==false and Held==false then
		if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Throw") then
		Character.Gun.Throw:Play()
		end
		if reloadani then
		reloadani:Stop()
		end
		if reload then
		reload:Stop()
		end
		if fire then
			game.ReplicatedStorage.Events.ReplicateAnimation:FireServer("Fire")
		fire:Play()
		end
		if fireani then
		fireani:Play()
			if Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Handle") then
				Camera.Arms.Handle.Transparency=1
			end
			if Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Pin") then
				Camera.Arms.Pin.Transparency=1
			end
			if Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Slide") then
				Camera.Arms.Slide.Transparency=1
			end
		end
		
		local CHOSENONE=gun
		local starttime=tick()
					local char=Character
					local throwdistance=120
					if Character and Character:FindFirstChild("HumanoidRootPart") and Character.HumanoidRootPart.Velocity.magnitude>=10 then
						throwdistance=125
					end
					if Humanoid:GetState()==Enum.HumanoidStateType.Jumping or Humanoid:GetState()==Enum.HumanoidStateType.Freefall then
						throwdistance=130
						if Character and Character:FindFirstChild("HumanoidRootPart") and Character.HumanoidRootPart.Velocity.magnitude>=10 then
							throwdistance=135
						end
					end
					if _Run:IsStudio() then
					--print("throw distance: "..throwdistance.. " units")
					end
					local l=25
					local h=35
					local mylengthlol=workspace.CurrentCamera.CFrame.lookVector * (throwdistance) + Vector3.new(0, 15, 0) + Vector3.new(Character.HumanoidRootPart.Velocity.X / 2, Character.HumanoidRootPart.Velocity.Y / 4, Character.HumanoidRootPart.Velocity.Z / 2)
					if equipped=="grenade" then
						game.ReplicatedStorage.Events.ThrowGrenade:FireServer(game.ReplicatedStorage.Weapons[grenade].Model, nil, l,h,mylengthlol,primary,secondary)			
						grenade=""
					elseif equipped=="grenade2" then
						game.ReplicatedStorage.Events.ThrowGrenade:FireServer(game.ReplicatedStorage.Weapons[grenade2].Model, nil, l,h,mylengthlol,primary,secondary)				
						grenade2=""
					elseif equipped=="grenade3" then
						game.ReplicatedStorage.Events.ThrowGrenade:FireServer(game.ReplicatedStorage.Weapons[grenade3].Model, nil, l,h,mylengthlol,primary,secondary)				
						grenade3=""
					elseif equipped=="grenade4" then
						game.ReplicatedStorage.Events.ThrowGrenade:FireServer(game.ReplicatedStorage.Weapons[grenade4].Model, nil, l,h,mylengthlol,primary,secondary)				
						grenade4=""
					end
					updateInventory()
						repeat _Run.Stepped:wait() 			
						until gun~=CHOSENONE or gun~="none" and gun and gun:FindFirstChild("FireRate")==nil or gun~="none" and gun and gun:FindFirstChild("FireRate") and (tick()-starttime)>=(fireani.Length-0.05)
		
		autoequip()
	end 
end)



local Tinf = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

game.Workspace.Status.Timer.Changed:connect(function()
	_Run.Heartbeat:wait()
	colorscheme=Cnew(210/255,210/255,210/255)
	gui.TR.BL.Role.WhiteText.Text=gen_time2(game.Workspace.Status.Timer.Value)
	gui.TR.BLA.Role.WhiteText.Text=gui.TR.BL.Role.WhiteText.Text
	gui.TR.BL.Role.WhiteText.Outline.Text=gui.TR.BL.Role.WhiteText.Text
	gui.TR.BLA.Role.WhiteText.Outline.Text=gui.TR.BL.Role.WhiteText.Text
	gui.UpperInfo.Timer.Visible=true
	gui.UpperInfo.Timer.Text=gen_time(game.Workspace.Status.Timer.Value)
	gui.UpperInfo.Warmup.Visible = game.ReplicatedStorage.Warmup.Value
	gui.UpperInfo.Timer.TextColor3=Color3.new(1,1,1)
	if game.Workspace.Status.Timer.Value<=10 and workspace.Status.Preparation.Value == false then
		local Twn = _tween:Create(gui.UpperInfo.Timer, Tinf, {TextColor3 = Color3.fromRGB(234, 0, 0)})
		Twn:Play()
	elseif game.Workspace.Status.Timer.Value<=20 and workspace.Status.Preparation.Value == false then
		gui.UpperInfo.Timer.TextColor3=Color3.fromRGB(255, 124, 48) -- 255, 124, 48
	end
	gui.UpperInfo.TScore.Text=game.Workspace.Status.TWins.Value
	gui.UpperInfo.CTScore.Text=game.Workspace.Status.CTWins.Value

end)

game.Workspace.Status.TWins.Changed:connect(function()
gui.UpperInfo.TScore.Text=game.Workspace.Status.TWins.Value
gui.UpperInfo.CTScore.Text=game.Workspace.Status.CTWins.Value
end)
game.Workspace.Status.CTWins.Changed:connect(function()
gui.UpperInfo.TScore.Text=game.Workspace.Status.TWins.Value
gui.UpperInfo.CTScore.Text=game.Workspace.Status.CTWins.Value
end)
script.Parent.GUI.TeamSelection.Blue.ImageLabel.MouseEnter:Connect(function()
	script.Parent.GUI.TeamSelection.Blue.Select.Visible = true
	script.Parent.Sounds.MenuHover:Play()
end)
UpperInfo = gui:WaitForChild("UpperInfo")
DynamicMiniscoreboard = true
game.Workspace.Status.PlayerChanged.Changed:connect(function()
	--local MyTeam = Player.Status.Team.Value
	local players = game.Players:GetPlayers()
	local amnt = 5
	local TCount = 0
	local CTCount = 0
	if DynamicMiniscoreboard then	
		if game.ReplicatedStorage.gametype.value=="casual" then 
			amnt = 10
		else
			amnt = 5
		end
	else
		amnt = 5
	end
	
	
	local TCount = 0
	local CTCount = 0
	--this shit can be optimized this is the half-assed way
	--for it to be more optimized we can have a folder that has players in it, and fire off childadded and childremoved
	local TPlus = nil
	local CTPlus = nil
	if amnt == 5 then
		TPlus = UpperInfo.T
		CTPlus = UpperInfo.CT
	elseif amnt == 10 then
		TPlus = UpperInfo.Tplus
		CTPlus = UpperInfo.CTplus
	end	
	
	if amnt == 5 then
		UpperInfo.Tplus.Visible = false
		UpperInfo.CTplus.Visible = false
		
		UpperInfo.CT.Visible = true
		UpperInfo.T.Visible = true
	elseif amnt == 10 then
		UpperInfo.Tplus.Visible = true
		UpperInfo.CTplus.Visible = true
		
		UpperInfo.CT.Visible = false
		UpperInfo.T.Visible = false
	end
	
	for i=1, amnt do
		local t1 = TPlus:FindFirstChild(tostring(i))
		local ct1 =	CTPlus:FindFirstChild(tostring(i))
		t1.Visible = false
		ct1.Visible = false
		ct1.Dead.Visible = false
		t1.Dead.Visible = false
		ct1.Player.ImageColor3 = Color3.new(1,1,1)
		t1.Player.ImageColor3 = Color3.new(1,1,1)		
	end
	if game.ReplicatedStorage.gametype.Value=="deathmatch" then
		return
	end
	for i=1, #players do
		if players[i]:FindFirstChild("Status") then
		if players[i].Status.Team.Value == "T" or players[i].Status.Team.Value == "CT" then
			if players[i].Status.Team.Value == "T" then
				TCount = TCount+ 1
				local current = TPlus:FindFirstChild(tostring(TCount))
				if current then
				if players[i].Status.Alive.Value then
					current.Dead.Visible = false
				else
					current.Dead.Visible = true
					current.Player.ImageColor3 = Color3.fromRGB(149,149,149)
				end
				current.Visible = true
				current.Player.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..players[i].UserId.."&width=420&height=420&format=png"
				end
			elseif players[i].Status.Team.Value =="CT" then
				CTCount = CTCount+ 1
				local current = CTPlus:FindFirstChild(tostring(CTCount))
				if current then
				if players[i].Status.Alive.Value then
					current.Dead.Visible = false
				else
					current.Dead.Visible = true
				end
				current.Visible = true
				current.Player.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..players[i].UserId.."&width=420&height=420&format=png"
				end
			end			
		end
		end
	end
end)
script.Parent.GUI.TeamSelection.Red.ImageLabel.MouseEnter:Connect(function()
	script.Parent.GUI.TeamSelection.Red.Select.Visible = true
	script.Parent.Sounds.MenuHover:Play()
end)

script.Parent.GUI.TeamSelection.Blue.ImageLabel.MouseLeave:Connect(function()
	script.Parent.GUI.TeamSelection.Blue.Select.Visible = false
end)

script.Parent.GUI.TeamSelection.Red.ImageLabel.MouseLeave:Connect(function()
	script.Parent.GUI.TeamSelection.Red.Select.Visible = false
end)
-- BODY SEARCH MENU CODE
function closeBodySearchResults()
	gui.TR.BodySearchResults.Visible = false
	gui.TR.BodySearchResults.Modal = false
end
gui.TR:WaitForChild("BodySearchResults"):WaitForChild("CloseGui").MouseButton1Down:connect(closeBodySearchResults)
gui.TR:WaitForChild("BodySearchResults"):WaitForChild("CloseGui2").MouseButton1Down:connect(closeBodySearchResults)

for _, v in pairs(gui.TR:WaitForChild("BodySearchResults"):WaitForChild("Weps"):WaitForChild("Scroll"):GetChildren()) do
	spawn(function()
		local button = gui.TR:WaitForChild("BodySearchResults"):WaitForChild("Weps"):WaitForChild("Button")
		v.MouseButton1Down:connect(function()
			v:WaitForChild("Chosen").Value = true
		end)	
		
		v.MouseEnter:connect(function()
			v.Hover.Visible = true
			v.Highlight.Visible = false
		end)
		
		v.MouseLeave:connect(function()
			v.Hover.Visible = false
			if v.Chosen.Value then
				v.Highlight.Visible = true
			end
		end)
		
		v.MouseButton1Click:connect(function()
			v.Hover.Visible = false
			v.Highlight.Visible = true
			v.Chosen.Value = true
			for _, j in pairs (v.Parent:GetChildren()) do
				if j.Name ~= v.Name then
					j:WaitForChild("Chosen").Value = false
				end
			end
		end)
		
		v:WaitForChild("Chosen").Changed:connect(function(val)			
			v.Hover.Visible = false
			if val then
				if v.Name ~= "1" then
					button.ImageLabel.Image = v.ImageLabel.Image
				else
					button.ImageLabel.Image = "rbxassetid://191396383"
				end
				button.TextLabel.Text = v.Chosen["Text"].Value
				button.ImageLabel.Visible = true
				button.TextLabel.Visible = true
				v.Highlight.Visible = true
			else
				v.Highlight.Visible = false
			end
		end)
	end)
end



function loadBodySearchMenu(mTarget)
	local bodyRole = mTarget.Parent:FindFirstChild("Role").Value
	if not mTarget.Parent:FindFirstChild("Identified").Value and alive.Value then
		--print("IDing Body")
		game.ReplicatedStorage.Events.IDBody:FireServer("id",mTarget.Parent)
	end
	
	if not alive.Value or mTarget.Parent:FindFirstChild("DetectiveCalled") then
		gui.TR.BodySearchResults.CallDetective.ImageColor3 = Cnew(181/255, 181/265, 181/255)
	else
		gui.TR.BodySearchResults.CallDetective.ImageColor3 = Cnew(1, 1, 1)
	end
	
	if script.Parent:WaitForChild("DetectiveCalls"):WaitForChild("Calls"):FindFirstChild(mTarget.Parent.Name) then
		script.Parent:WaitForChild("DetectiveCalls"):WaitForChild("Calls"):FindFirstChild(mTarget.Parent.Name):Destroy()
	end
	
	local bodySearchResults = gui.TR.BodySearchResults
	local weps = bodySearchResults.Weps
	local button = weps.Button
	local searchItems = weps.Scroll
	
	bodySearchResults.Tookparters.Text = "Body Search Results - "..mTarget.Parent.Name
	searchItems["1"]["Player"].Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..mTarget.Parent:FindFirstChild("UserId").Value.."&width=420&height=420&format=png"
	searchItems["1"]["Chosen"]["Text"].Value = "This is the body of "..mTarget.Parent.Name.."."
	
	if bodyRole == "Innocent" then
		searchItems["2"]["Chosen"]["Text"].Value = "They were an innocent terrorist."
		searchItems["2"]["ImageLabel"].Image = "rbxassetid://191396359"
	elseif bodyRole == "Detective" then
		searchItems["2"]["Chosen"]["Text"].Value = "They were a Detective."
		searchItems["2"]["ImageLabel"].Image = "rbxassetid://191396651"
	else
		searchItems["2"]["Chosen"]["Text"].Value = "They were a Traitor."
		searchItems["2"]["ImageLabel"].Image = "rbxassetid://191395619"
	end
	
	local timeDead =  gen_time2(mfloor(game.Workspace.DistributedTime.Value - mTarget.Parent:WaitForChild("TimeDead").Value))
	searchItems["3"]["TextLabel"].Text = timeDead
	searchItems["3"]["Chosen"]["Text"].Value = "They died roughly "..timeDead.." before you conducted the search."
	
	if mTarget.Parent:FindFirstChild("DNASampleTime") then
		local dnaTime = gen_time2(mTarget.Parent:WaitForChild("DNASampleTime").Value)
		searchItems["4"].Visible = true
		searchItems["4"].TextLabel.Text = dnaTime
		if mTarget.Parent:WaitForChild("DNASampleTime").Value ~= 0 then
			searchItems["4"]["Chosen"]["Text"].Value = "The DNA sample on this dead body decays in "..dnaTime.."."
		else
			searchItems["4"]["Chosen"]["Text"].Value = "The DNA sample on this dead body has decayed."
		end
	else
		searchItems["4"].Visible = false
	end
	
	local body=mTarget.Parent
	local pronoun = "He"
	local pronoun2 = "he"
	local pronoun3 = "His"
	local pronoun4 = "his"
	local pronoun5 = "him"
	searchItems["6"].Visible = false
	searchItems["7"].Visible = false
	searchItems["8"].Visible = false
	searchItems["9"].Visible = false
	searchItems["10"].Visible = false
	local weapons = game.ReplicatedStorage.Weapons
	if body:WaitForChild("WeaponKilledBy").Value ~= "Mysterious" then
		if weapons[body:WaitForChild("WeaponKilledBy").Value] and weapons[body:WaitForChild("WeaponKilledBy").Value]:IsA("Folder") and weapons[body:WaitForChild("WeaponKilledBy").Value]:FindFirstChild("TextureId") then
			searchItems["5"].ImageLabel.Image = weapons[body:WaitForChild("WeaponKilledBy").Value].TextureId.Value
		else
			searchItems["5"].ImageLabel.Image = "rbxassetid://323137727"	
		end
		local firstLetter = string.lower(string.sub(GetName.getName(body:WaitForChild("WeaponKilledBy").Value), 1, 1))
		if firstLetter ~= "a" and firstLetter ~= "e" and firstLetter ~= "i" and firstLetter ~= "o" and firstLetter ~= "u" then
			searchItems["5"]["Chosen"]["Text"].Value = pronoun.." was killed by a "..GetName.getName(body:WaitForChild("WeaponKilledBy").Value).."."
		else
			searchItems["5"]["Chosen"]["Text"].Value = pronoun.." was killed by an "..GetName.getName(body:WaitForChild("WeaponKilledBy").Value).."."
		end
	else
		searchItems["5"].ImageLabel.Image = "rbxassetid://191395787"
		searchItems["5"]["Chosen"]["Text"].Value = pronoun.." died under mysterious circumstances."
	end
	if searchItems["3"].Visible then
		searchItems["5"].Position = searchItems["3"].Position + UDim2.new(0, 64, 0, 0)
	end								
	if searchItems["4"].Visible then
		searchItems["5"].Position = searchItems["4"].Position + UDim2.new(0, 64, 0, 0)
	end

	
	if body:FindFirstChild("Cause") and body.Cause.Value ~= "None" then
		searchItems["6"].Visible = true
		if body.Cause.Value=="Bullet" then
			searchItems["6"]["Chosen"]["Text"].Value = "It is obvious "..pronoun2.." was shot to death."
			searchItems["6"]:FindFirstChild("ImageLabel").Image =  "rbxassetid://191396966"
		elseif body.Cause.Value=="Fire" then
			searchItems["6"]["Chosen"]["Text"].Value = "Smells like roasted terrorist around here..."
			searchItems["6"]:FindFirstChild("ImageLabel").Image =  "rbxassetid://476935595"
		elseif body.Cause.Value=="Explosion" then
			searchItems["6"]["Chosen"]["Text"].Value = pronoun3.." wounds and singed clothes indicate an explosion caused their end."
			searchItems["6"]:FindFirstChild("ImageLabel").Image =  "rbxassetid://477112823"
		elseif body.Cause.Value=="Electricity" then
			searchItems["6"]["Chosen"]["Text"].Value = "This body is turning into ashes! They were eletrocuted."
			searchItems["6"]:FindFirstChild("ImageLabel").Image =  "rbxassetid://323137734"
		elseif body.Cause.Value=="Beaten" then
			searchItems["6"]["Chosen"]["Text"].Value = "The body is bruised and battered. Clearly "..pronoun2.." was clubbed to death."
			searchItems["6"]:FindFirstChild("ImageLabel").Image =  "rbxassetid://191395787"															
		elseif body.Cause.Value=="Fall" then
            searchItems["6"].Visible=false
			searchItems["5"]["Chosen"]["Text"].Value = "They fell to their death."
			searchItems["5"]:FindFirstChild("ImageLabel").Image =  "rbxassetid://477112812"	
		elseif body.Cause.Value=="Crush" then
            searchItems["6"].Visible=false	
			searchItems["5"]["Chosen"]["Text"].Value = "Many of "..pronoun4.." bones are broken. It seems the impact of a heavy object killed "..pronoun5.."."
			searchItems["5"]:FindFirstChild("ImageLabel").Image =  "rbxassetid://476935910"
		elseif body.Cause.Value=="Stab" then
			searchItems["6"]["Chosen"]["Text"].Value = pronoun.." was stabbed and cut before quickly bleeding to death."
			searchItems["6"]:FindFirstChild("ImageLabel").Image = "rbxassetid://191395787"										
		end
		
		if searchItems["4"].Visible then
			searchItems["6"].Position = searchItems["4"].Position + UDim2.new(0, 64, 0, 0)
		end
		if searchItems["5"].Visible then
			searchItems["6"].Position = searchItems["5"].Position + UDim2.new(0, 64, 0, 0)
		end
	end
		
	if body:FindFirstChild("HEADSHOT") and searchItems["6"].Visible==true then
		searchItems["7"].Visible = true
	elseif body:FindFirstChild("HEADSHOT") and searchItems["6"].Visible==false then
		searchItems["6"].Visible = true
		searchItems["6"]["Chosen"]["Text"].Value = searchItems["7"]["Chosen"]["Text"].Value
		searchItems["6"]:FindFirstChild("ImageLabel").Image =  searchItems["7"]:FindFirstChild("ImageLabel").Image
	end
	
	if searchItems["4"].Visible then
		searchItems["7"].Position = searchItems["4"].Position + UDim2.new(0, 64, 0, 0)
	end
	if searchItems["5"].Visible then
		searchItems["7"].Position = searchItems["5"].Position + UDim2.new(0, 64, 0, 0)
	end
	if searchItems["6"].Visible then
		searchItems["7"].Position = searchItems["6"].Position + UDim2.new(0, 64, 0, 0)
	end
	
	if body:FindFirstChild("LastWords") then
		searchItems["8"].Visible = true
		searchItems["8"]["Chosen"]["Text"].Value = pronoun3.." last words before dying were, \""..body:FindFirstChild("LastWords").Value.."\""
		searchItems["8"].Position = UDim2.new(0, 276, 0.09, 0)								
		if searchItems["4"].Visible then
			searchItems["8"].Position = searchItems["4"].Position + UDim2.new(0, 64, 0, 0)
		end
		if searchItems["5"].Visible then
			searchItems["8"].Position = searchItems["5"].Position + UDim2.new(0, 64, 0, 0)
		end
		if searchItems["6"].Visible then
			searchItems["8"].Position = searchItems["6"].Position + UDim2.new(0, 64, 0, 0)
		end
		if searchItems["7"].Visible then
			searchItems["8"].Position = searchItems["7"].Position + UDim2.new(0, 64, 0, 0)
        end

	end
	
	if body:FindFirstChild("ListOfKills") then
		searchItems["9"].Visible = true
		if not body:FindFirstChild("Confirmed") then
			game.ReplicatedStorage.Events.IDBody:FireServer("conf",body)
			searchItems["9"]["Chosen"]["Text"].Value = "You found a list of kills that confirms the death of: "
		else
			searchItems["9"]["Chosen"]["Text"].Value = "You found a list of kills with these names: "
		end
		
		local kills = body:FindFirstChild("ListOfKills"):GetChildren()
		local num = #kills
		for i = 1, num do
			if i ~= num and i ~= num-  1 then
				searchItems["9"]["Chosen"]["Text"].Value = searchItems["9"]["Chosen"]["Text"].Value..kills[i].Name..", "
			elseif i == num - 1 then
				searchItems["9"]["Chosen"]["Text"].Value = searchItems["9"]["Chosen"]["Text"].Value..kills[i].Name.." and "
			else
				searchItems["9"]["Chosen"]["Text"].Value = searchItems["9"]["Chosen"]["Text"].Value..kills[i].Name.."."
			end
			spawn(function()
				if alive.Value and game.Workspace.Debris:FindFirstChild(kills[i].Name) and not game.Workspace.Debris:FindFirstChild(kills[i].Name):FindFirstChild("Identified").Value then
					game.ReplicatedStorage.Events.IDBody:FireServer("confirm",game.Workspace.Debris:FindFirstChild(kills[i].Name))					

				end
			end)
		end
		
		searchItems["9"].Position = UDim2.new(0, 276, 0.09, 0)								
		if searchItems["4"].Visible then
			searchItems["9"].Position = searchItems["4"].Position + UDim2.new(0, 64, 0, 0)
		end
		if searchItems["5"].Visible then
			searchItems["9"].Position = searchItems["5"].Position + UDim2.new(0, 64, 0, 0)
		end
		if searchItems["6"].Visible then
			searchItems["9"].Position = searchItems["6"].Position + UDim2.new(0, 64, 0, 0)
		 end
		if searchItems["7"].Visible then
			searchItems["9"].Position = searchItems["7"].Position + UDim2.new(0, 64, 0, 0)
        end
		if searchItems["8"].Visible then
			searchItems["9"].Position = searchItems["8"].Position + UDim2.new(0, 64, 0, 0)
        end
	end

	if body:FindFirstChild("RDM") or body:FindFirstChild("Proven") then
		searchItems["10"].Visible = true

		if body:FindFirstChild("Proven") then
			searchItems["10"]["Chosen"]["Text"].Value = pronoun.." was proven to be Innocent."	
			searchItems["10"].ImageLabel.Image = "rbxassetid://324952515"	
		end
		if body:FindFirstChild("RDM") then
			searchItems["10"]["Chosen"]["Text"].Value = pronoun.." attemped to RDM"
        	searchItems["10"].ImageLabel.Image = "rbxassetid://324952510"							
		end
		searchItems["10"].Position = UDim2.new(0, 276, 0.09, 0)								
		if searchItems["4"].Visible then
			searchItems["10"].Position = searchItems["4"].Position + UDim2.new(0, 64, 0, 0)
		end
		if searchItems["5"].Visible then
			searchItems["10"].Position = searchItems["5"].Position + UDim2.new(0, 64, 0, 0)
		end
		if searchItems["6"].Visible then
			searchItems["10"].Position = searchItems["6"].Position + UDim2.new(0, 64, 0, 0)
		 end
		if searchItems["7"].Visible then
			searchItems["10"].Position = searchItems["7"].Position + UDim2.new(0, 64, 0, 0)
        end
		if searchItems["8"].Visible then
			searchItems["10"].Position = searchItems["8"].Position + UDim2.new(0, 64, 0, 0)
        end
			if searchItems["9"].Visible then
			searchItems["10"].Position = searchItems["9"].Position + UDim2.new(0, 64, 0, 0)
        end
	end	

	-- This is the part at the very end. Do not add anything after this.

	if mTarget.Parent.Name ~= bodySearchResults:WaitForChild("LastChecked").Value then
		bodySearchResults.LastChecked.Value = mTarget.Parent.Name
		searchItems.CanvasPosition = Vector2.new(0, 0)
		button:FindFirstChild("TextLabel").Text = "This is the body of "..mTarget.Parent.Name.."."
		button:FindFirstChild("ImageLabel").Image = "rbxassetid://191396383"
		searchItems["1"]["Chosen"].Value = true
		searchItems["1"]["Highlight"].Visible = true
		searchItems["1"]["Hover"].Visible = false
		searchItems["2"]["Chosen"].Value = false
		searchItems["3"]["Chosen"].Value = false
		searchItems["4"]["Chosen"].Value = false
		searchItems["5"]["Chosen"].Value = false
		searchItems["6"]["Chosen"].Value = false
		searchItems["7"]["Chosen"].Value = false
		searchItems["8"]["Chosen"].Value = false
		searchItems["9"]["Chosen"].Value = false
		searchItems["10"]["Chosen"].Value = false
	else
		if searchItems["3"]["Chosen"].Value then
			searchItems["3"]["Chosen"].Value = false
			_Run.Heartbeat:wait()
			searchItems["3"]["Chosen"].Value = true
		elseif searchItems["4"]["Chosen"].Value == true then
			searchItems["4"]["Chosen"].Value = false
			_Run.Heartbeat:wait()
			searchItems["4"]["Chosen"].Value = true
		elseif searchItems["9"]["Chosen"].Value == true then
			searchItems["9"]["Chosen"].Value = false
			_Run.Heartbeat:wait()
			searchItems["9"]["Chosen"].Value = true
		end	
	end
	
	local numVisible = 0
	for i, v in pairs (searchItems:GetChildren()) do
		if v.Visible then
			numVisible = numVisible + 1
		end
	end
	searchItems.CanvasSize = UDim2.new(0, 64 * numVisible, 0, 0)
						
	bodySearchResults.Visible = true
	bodySearchResults.Modal = true
end



-- END OF BODY SEARCH MENU CODE

-- MUSIC (by stinky8950) / r = request / v = variable
local Random = 1
local garbage = 0

game.Workspace.Status.Preparation.Changed:connect(function()
	if game.Workspace.Status.Preparation.Value==false and game.ReplicatedStorage.gametype.Value=="TTT" then
		gui.TR.BodySearchResults.Visible = false
		gui.TR.BodySearchResults.Modal = false
		gui.TR.BodySearchResults.LastChecked.Value = ""
		winboard=false
		script.Parent.GUI.TR.Winner.Visible=false
		local role=player.Status.Role
		local gui=script.Parent.GUI.TR
		wait(1)
		
		if role.Value == "Innocent" then
			gui:FindFirstChild("RoleInfos"):FindFirstChild("InnoInfo").Visible = true
		elseif role.Value == "Detective" then
			gui:FindFirstChild("RoleInfos"):FindFirstChild("DInfo").Visible = true
		elseif role.Value == "Traitor" then
			wait(1)
			local fellowTraitors = {}
			local pos = 1
			for _, v in pairs(game.Players:GetPlayers()) do
				if v.Name ~= Player.Name and v:WaitForChild("Status"):WaitForChild("Role").Value == "Traitor" then
					fellowTraitors[pos] = v.Name
					pos = pos + 1
				end
			end
			
			if #fellowTraitors > 0 then
				for i = 1, #fellowTraitors do
					gui:FindFirstChild("RoleInfos"):FindFirstChild("TInfo"):FindFirstChild("Comrade"..i).Text = fellowTraitors[i]
				end
				gui:FindFirstChild("RoleInfos"):FindFirstChild("TInfo").Visible = true
			else
				gui:FindFirstChild("RoleInfos"):FindFirstChild("TAloneInfo").Visible = true
			end
		end
		
		wait(14.5)
		
		gui:FindFirstChild("RoleInfos"):FindFirstChild("InnoInfo").Visible = false
		gui:FindFirstChild("RoleInfos"):FindFirstChild("DInfo").Visible = false
		if gui:FindFirstChild("RoleInfos"):FindFirstChild("TInfo").Visible then
			gui:FindFirstChild("RoleInfos"):FindFirstChild("TInfo"):FindFirstChild("Comrade1").Text = ""
			gui:FindFirstChild("RoleInfos"):FindFirstChild("TInfo"):FindFirstChild("Comrade2").Text = ""
			gui:FindFirstChild("RoleInfos"):FindFirstChild("TInfo"):FindFirstChild("Comrade3").Text = ""
			gui:FindFirstChild("RoleInfos"):FindFirstChild("TInfo").Visible = false
		end
		gui:FindFirstChild("RoleInfos"):FindFirstChild("TAloneInfo").Visible = false
	end
end)
game.ReplicatedStorage.Voten.Changed:connect(function()
	if game.ReplicatedStorage.Voten.Value==true then
		winboard=false
		script.Parent.GUI.TR.Winner.Visible=false
	end
end)

function activatemusic(r,v)
	local Kit = script.Parent.Music.MusicKit.Value
	if script.Parent.GUI.TeamSelection.Visible == false then
	if r == "Finish" then
		if game.ReplicatedStorage.gametype.Value=="TTT" then
			winboard=true
			script.Parent.GUI.TR.Winner.Visible=true
			script.Parent.GUI.TR.Winner.Tookpart.Text=game.Workspace.Innocents.Value+game.Workspace.Traitors.Value+game.Workspace.Detectives.Value.." player(s) took part, "..game.Workspace.Traitors.Value.." were traitor(s)"
			script.Parent.GUI.TR.Winner.roundlasted.Text="The round lasted "..gen_time2(game.Workspace.RoundEnded.Value)
			if v=="CT" then
				script.Parent.GUI.TR.Winner.IRole.Visible=false
				script.Parent.GUI.TR.Winner.TRole.Visible=true
			else
				script.Parent.GUI.TR.Winner.IRole.Visible=true
				script.Parent.GUI.TR.Winner.TRole.Visible=false			
			end
			return
		end
		for i, v in pairs (script.Parent.Music:FindFirstChild(Kit):GetChildren()) do
				if v:IsA("Sound") and v.Name~="TeamSelection" then
					v:Stop()
				end
		end
		for i, v in pairs (script.Parent.Music:FindFirstChild(Kit).StartAction:GetChildren()) do
				if v:IsA("Sound") then
					v:Stop()
				end
		end
		for i, v in pairs (script.Parent.Music:FindFirstChild(Kit).StartRound:GetChildren()) do
				if v:IsA("Sound") then
					v:Stop()
				end
			end		
		spawn(function() 
		wait(8)
	
		script.Parent.GUI.CTWin.Visible = false
		script.Parent.GUI.TWin.Visible = false
		script.Parent.GUI.DMWin.Visible=false		
		end)		
		
			for i, v in pairs (script.Parent.Music:FindFirstChild(Kit):GetChildren()) do
				if v:IsA("Sound") then
					v:Stop()
				end
			end
		if v == "CT" then
			-- MVP ballocks
			script.Parent.GUI.CTWin.Visible = true			
			script.Parent.GUI.CTWin.MVPPlayer.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..game.Workspace.Status.MVP.ID.Value.."&width=420&height=420&format=png"
			script.Parent.GUI.CTWin.TextLabel.Text="MVP: "..game.Workspace.Status.MVP.Value..game.Workspace.Status.MVP.Reason.Value
			script.Parent.GUI.CTWin.Info.TextLabel.Text=game.Workspace.Status.FunFact.Value
			script.Parent.GUI.CTWin.Pin.Image = game.Players:FindFirstChild(game.Workspace.Status.MVP.Value).EquippedPin.Value
			if game.Players.LocalPlayer.TeamColor == BrickColor.new("Bright blue") then
				script.Parent.Music:FindFirstChild(Kit).Win:Play()
			elseif game.Players.LocalPlayer.TeamColor == BrickColor.new("Bright yellow") then
				script.Parent.Music:FindFirstChild(Kit).Lose:Play()
			else
				script.Parent.Music:FindFirstChild(Kit).Win:Play()
			end
			delay(8,function()
				script.Parent.Music:FindFirstChild(Kit).Lose:Stop()
				script.Parent.Music:FindFirstChild(Kit).Win:Stop()
			end)
		elseif v == "T" then
			-- MVP ballocks part 2
			script.Parent.GUI.TWin.Visible = true
			script.Parent.GUI.TWin.MVPPlayer.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..game.Workspace.Status.MVP.ID.Value.."&width=420&height=420&format=png"
			script.Parent.GUI.TWin.TextLabel.Text="MVP: "..game.Workspace.Status.MVP.Value..game.Workspace.Status.MVP.Reason.Value			
			script.Parent.GUI.TWin.Info.TextLabel.Text=game.Workspace.Status.FunFact.Value
			script.Parent.GUI.TWin.Pin.Image = game.Players:FindFirstChild(game.Workspace.Status.MVP.Value).EquippedPin.Value
			if game.Players.LocalPlayer.TeamColor == BrickColor.new("Bright yellow") then
				script.Parent.Music:FindFirstChild(Kit).Win:Play()
			elseif game.Players.LocalPlayer.TeamColor == BrickColor.new("Bright blue") then
				script.Parent.Music:FindFirstChild(Kit).Lose:Play()
			else
				script.Parent.Music:FindFirstChild(Kit).Win:Play()
			end
			delay(8,function()
				script.Parent.Music:FindFirstChild(Kit).Lose:Stop()
				script.Parent.Music:FindFirstChild(Kit).Win:Stop()
			end)
		elseif v == "DM" then
			-- MVP ballocks part 2
			script.Parent.GUI.DMWin.Visible = true
			script.Parent.GUI.DMWin.MVPPlayer.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..game.Workspace.Status.First.ID.Value.."&width=420&height=420&format=png"
			script.Parent.GUI.DMWin.MVPPlayer.TextLabel.Text=game.Workspace.Status.First.Value		
			script.Parent.GUI.DMWin.Third.Second.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..game.Workspace.Status.Second.ID.Value.."&width=420&height=420&format=png"
			script.Parent.GUI.DMWin.Third.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..game.Workspace.Status.Third.ID.Value.."&width=420&height=420&format=png"
		end
	end	
	if r == "BombDefusedStopMusic" then
		script.Parent.Music:FindFirstChild(Kit)["Bomb"]:Stop()
	end
	if r == "BombPlanted45sec" then
		script.Parent.Music:FindFirstChild(Kit)["Bomb"]:Play()
	end
	if r == "PreStart" and Camera and Camera:FindFirstChild("ColorCorrection") then
		startmusic=false
		Camera.ColorCorrection.Saturation=(-1)
		if game.Lighting:FindFirstChild("ColorCorrection") then
			Camera.ColorCorrection.Saturation=Camera.ColorCorrection.Saturation-game.Lighting.ColorCorrection.Saturation
		end
		local freezetime=5
		if game.ReplicatedStorage.gametype.Value=="competitive" then
			freezetime=15
		end
		freezetime=freezetime-2
		delay(freezetime,function()
			while Camera.ColorCorrection.Saturation<0 do
				_Run.Stepped:wait()
				Camera.ColorCorrection.Saturation=math.min(0,Camera.ColorCorrection.Saturation+.01)
			end
		end)
		local bullies=script.Parent.Music:GetChildren()
		for i=1,#bullies do
			if bullies[i]:FindFirstChild("Bomb") then
				bullies[i].Bomb:Stop()
			end
		end
		for i, v in pairs (script.Parent.Music:FindFirstChild(Kit):GetChildren()) do
				if v:IsA("Sound") then
					v:Stop()
				end
		end
		for i, v in pairs (script.Parent.Music:FindFirstChild(Kit).StartAction:GetChildren()) do
				if v:IsA("Sound") then
					v:Stop()
				end
		end
		for i, v in pairs (script.Parent.Music:FindFirstChild(Kit).StartRound:GetChildren()) do
				if v:IsA("Sound") then
					v:Stop()
				end
			end
			local yes = script.Parent.Music:FindFirstChild(Kit).StartRound:GetChildren()[math.random(1,#script.Parent.Music:FindFirstChild(Kit).StartRound:GetChildren())]
			yes:Play()			
			repeat wait(.2) until startmusic==true or game.Workspace.Status.Preparation.Value==false and script.Parent.GUI.Spectate.Visible==true
			if script.Parent.GUI.Spectate.Visible==true then
				spawn(function() activatemusic("Start") end)
			end
			repeat wait() yes.Volume = yes.Volume - 0.05 until yes.Volume <= 0
			yes:Stop()
			yes.Volume = 0.85
			yes = nil
	end
	if r == "Tensec" then
			local yes = script.Parent.Music:FindFirstChild(Kit)["10"]
			yes:Play()			
	end
	if r == "Start" then
		local bullies=script.Parent.Music:GetChildren()
		for i=1,#bullies do
			if bullies[i]:FindFirstChild("Bomb") then
				bullies[i].Bomb:Stop()
			end
		end
			local yes = script.Parent.Music:FindFirstChild(Kit).StartAction:GetChildren()[math.random(1,#script.Parent.Music:FindFirstChild(Kit).StartAction:GetChildren())]
			yes:Play()			
			wait(5)
			repeat wait() yes.Volume = yes.Volume - 0.01 until yes.Volume <= 0 
			yes:Stop()
			yes.Volume = 0.85
			yes = nil
	end
	end
end

game.ReplicatedStorage.Events.Audio.OnClientEvent:Connect(function(r, v)
activatemusic(r,v)
end)

-- explosion vibration gamepad 
game.Workspace.Status.Exploded.Changed:Connect(function()
	if game.Workspace.Status.Exploded.Value == true then
		spawn(function() GamepadVibrate("Large", 0.75, 0.45) end)
		spawn(function() GamepadVibrate("Small", 0.4, 0.75) end)
	end
end)


-- VARIABLES (For Lag Reduction)

setcharacter(game.Players.LocalPlayer.Character)
	game.Players.LocalPlayer.CharacterAdded:connect(function(c)
		if c then
		setcharacter(c)
		end
	end)
--generatePlayers()
health1=game.Players.LocalPlayer.PlayerGui:WaitForChild("GUI"):WaitForChild("Crosshairs"):WaitForChild("Iconhair").Health
name500=game.Players.LocalPlayer.PlayerGui:WaitForChild("GUI"):WaitForChild("Crosshairs"):WaitForChild("Iconhair").Name500

reputation = game.Players.LocalPlayer.PlayerGui:WaitForChild("GUI"):WaitForChild("Crosshairs"):WaitForChild("Iconhair").Reputation









game.Workspace["Ray_Ignore"].ChildAdded:connect(function(c)
	wait(0.1)
	if c and c:FindFirstChild("Hostage") and c.Name==Player.Name then
		local boop=c:GetDescendants()
		for i=1,#boop do
			if boop[i]:IsA("BasePart") or boop[i]:IsA("Decal") then
				boop[i].LocalTransparencyModifier=1
				boop[i].Transparency=1
			end
		end
	end
end)




local tag=reputation.Parent.Tag
local tr=reputation.Parent.T
local d=reputation.Parent.D

Player.Status.Role.Changed:connect(function(val)
	_Run.Heartbeat:wait()
	if val=="Traitor" then
		debris:ClearAllChildren()
		local cucks=game.Players:GetPlayers()
		for i=1,#cucks do
			if cucks[i]:FindFirstChild("Status") and cucks[i].Status.Role.Value=="Traitor" and cucks[i].Character and cucks[i].Character:FindFirstChild("Head") and cucks[i].Name~=Player.Name then
				local billboard=script.Traitor:clone()
				billboard.Parent=debris
				billboard.Adornee=cucks[i].Character.Head
				billboard.Enabled=true
			end
		end
	else
		debris:ClearAllChildren()
	end
end)



game.ReplicatedFirst:WaitForChild("CustomLoadingScreen")
newangle=CFrame.new()

chargeleft=100

function tttuiupdt()
	if game.ReplicatedStorage.Voten.Value==false then
		script.Parent.GUI.MapVote.Visible=false
	end
	if player and player.Character and player.Character:FindFirstChild("RDMProtection")==nil and player.Status.Alive.Value==true then
		script.Parent.GUI.TR.RoleGUI.RDMNotify.Visible=true
	else
		script.Parent.GUI.TR.RoleGUI.RDMNotify.Visible=false
	end
end


_Run.RenderStepped:Connect(function()
	--print(DISABLED)
	if game.ReplicatedStorage.gametype.Value~="TTT" and equipment2~="" and game.Workspace.Status.HasBomb.Value~=player.Name then
		equipment2=""
		updateInventory()
		if equipped=="equipment2" then
			autoequip()
		end
	end
	if script.Parent:FindFirstChild("GUI") then
	gui.ShopMenu.TempMenu.Visible=gui.ShopMenu.Visible
	script.Parent.GUI.Main.Position=UDim2.new(0,0,1,-(script.Parent.GUI.TR.BL.AbsoluteSize.Y+script.Parent.GUI.Main.Size.Y.Offset+10))
	if game.ReplicatedStorage.gametype.Value=="deathmatch" then
		if realgun~="" then
			primarystored=game.ReplicatedStorage.Weapons[primary].StoredAmmo.Value
		end
		if secondary~="" then
			secondarystored=game.ReplicatedStorage.Weapons[secondary].StoredAmmo.Value
		end
	end
	if UIS.MouseIconEnabled==true then
		script.Parent.GUI.TextButton.Visible=true
		script.Parent.GUI.TextButton.Modal=true
	else
		script.Parent.GUI.TextButton.Visible=false
		script.Parent.GUI.TextButton.Modal=false
	end
	if Humanoid then
		if Humanoid:GetState()==Enum.HumanoidStateType.Swimming then
			Humanoid.JumpPower=55
		else
			Humanoid.JumpPower=32
		end
	end
	if game.ReplicatedStorage.gametype.Value=="TTT" then
		tttuiupdt()
		crouchingheight=1.32
	else
		crouchingheight=0.9
	end
	Camera.CoordinateFrame=Camera.CoordinateFrame*(newangle:inverse())
	local srx=((-px)+RecoilX)/1.5
	local sry=((-py)+RecoilY)/1.5
	newangle=CFrame.Angles(math.rad(srx),math.rad(sry),0)
	Camera.CoordinateFrame=Camera.CoordinateFrame*newangle
	local len = math.sqrt((RecoilX^2)+(RecoilY^2))

	local den = 1 / ( len + FLT_EPSILON )
	RecoilX = RecoilX * den
	RecoilY = RecoilY * den

	len = len - ( ( 10 + len * 0.5 ) * (1/70) )
	len = math.max( len, 0 )

	RecoilX = RecoilX * len
	RecoilY = RecoilY * len
if Player.Status.Alive.Value==true and game.ReplicatedStorage.Warmup.Value==false then
	--script.Parent.GUI["Inventory&Loadout"].Visible=false
end
if inspectani and inspectani.IsPlaying==true and adsmodifier>0 then
	inspectani:Stop()
end
if game.ReplicatedFirst:FindFirstChild("CustomLoadingScreen")==nil then
	game.ReplicatedStorage.Events.RemoteEvent:FireServer({"kick","error 4"})
end
	if ammocount>150 or ammocount2>150 then
		game.ReplicatedStorage.Events.RemoteEvent:FireServer({"kick","error 2"})
	end
	if equipped=="primary" or equipped=="secondary" then
		if gun and gun~="none" and gun:FindFirstChild("Recoil") then
			if gun.Recoil.Value<=10 then
				game.ReplicatedStorage.Events.RemoteEvent:FireServer({"kick","error 3"})
			end
		end
	end
	if Player and Player:FindFirstChild("DefuseKit") then
		gui.AmmoGUI.DefuseKit.Visible=true
	else
		gui.AmmoGUI.DefuseKit.Visible=false
	end
	if Player.Status.Alive.Value==false and player.Character==nil and Player.PlayerGui.GUI.Spectate.Visible==false then
		Camera.CameraSubject=nil
		Camera.CameraType="Fixed"
		Player.CameraMaxZoomDistance=10
		Player.CameraMinZoomDistance=10
		Player.PlayerGui.GUI.Spectate.Visible=true
		equipped="none"
		ammobar.Visible = false
		hpbar.Visible = false
		gun="none"
		updateInventory()
		equipallowed=true
		return
	end
		crouchcooldown=math.max(0,crouchcooldown-(1/16))
	--[[if Player and Player.Status.Alive.Value==true and (player.Character==nil) and spawndeb==false then
		game.ReplicatedStorage.Events.Spawnme:FireServer()
		spawndeb=true
		delay(math.max(5,Player.Ping.Value/500),function()
			spawndeb=false
		end)
	end]]

	if Buymenuframe.Visible==true then
		Camera.Blur.Size=math.min(Camera.Blur.Size+1.8,24)
	else
		Camera.Blur.Size=math.max(Camera.Blur.Size-2.4,0)
	end
	if game.ReplicatedStorage.Warmup.Value==false and game.Workspace.Status.TWins.Value==0 and game.Workspace.Status.CTWins.Value==0 and realgun~="" and game.ReplicatedStorage.gametype.Value~="juggernaut" and game.ReplicatedStorage.gametype.Value~="deathmatch" and game.ReplicatedStorage.gametype.Value~="TTT" then
		realgun=""
		autoequip()
		updateInventory()
	end
fadg=0
if gun~="none" and gun and gun~="none" and gun:FindFirstChild("Spread") then
	
	fadg=gun.Spread.Value

    fadg=math.min(fadg*100,fadg+SpreadModifier)
		if gun:FindFirstChild("Melee")==nil and gun:FindFirstChild("Equipment2")==nil and gun:FindFirstChild("Grenade") ==nil  then
			if ads==true and Character then
				if gun:FindFirstChild("RifleThing") or gun:FindFirstChild("Scoped") and gun.Auto.Value==true then
					if SpreadModifier==0 then
						fadg=0
					end
				fadg=fadg/1.5
				else
				fadg=0
				end
			end
------print(fadg)
			local walky=(game.ReplicatedStorage.HUInfo[gun.Name].WalkSpeed.Value*hammerunit2stud)/2.5
			if gun and gun:FindFirstChild("Scoped") and ads==true then
				walky=0.5
			end
			if gun.Name=="AK47" then
				walky=0.5
			end
			if landing==true or Character:FindFirstChild("ScopeCooldown") and gun and gun:FindFirstChild("Scoped") then
			fadg=fadg+gun.Spread.Land.Value
			end
			if running==true and jumping==false and climbing==false and (UpperTorso.Velocity.magnitude>=5 and Character:FindFirstChild("Crouched") or crouched==false and UpperTorso.Velocity.magnitude>=walky) then
				local val=(gun.Spread.Move.Value/4*math.min(1,(UpperTorso.Velocity.magnitude/(game.ReplicatedStorage.HUInfo[gun.Name].WalkSpeed.Value*hammerunit2stud))))
				if game.ReplicatedStorage.HUInfo[gun.Name]:FindFirstChild("Scoped") and ads==true then
				val=(gun.Spread.Move.Value/4*math.min(1,(UpperTorso.Velocity.magnitude/(game.ReplicatedStorage.HUInfo[gun.Name].Scoped.Value*hammerunit2stud))))
				end
					if gun:FindFirstChild("SMGThing") then
					val=val/3
					end
					if gun:FindFirstChild("RifleThing") then
					val=val/3
					end
					if walking==true then
					val=val/2
					end
				fadg=fadg+val
			end
			if climbing==true then
				fadg=fadg+(gun.Spread.Ladder.Value/4)
			end
		    if jumping==true then
			fadg=fadg+(gun.Spread.Jump.Value/4)
		    end
			    if ads==false then if Character and Character:FindFirstChild("Humanoid") and Character:FindFirstChild("Crouched") and jumping==false and landing==false then
				local vl=gun.Spread.Crouch.Value/20
			    fadg=fadg+(vl)
			    else
				local vl=gun.Spread.Stand.Value/20
			    fadg=fadg+(vl)
			    end
			end
		end
		if gun:FindFirstChild("RifleThing") or gun:FindFirstChild("SMGThing") then
		fadg=fadg*3.2
		end

	fadg=fadg*0.8
	if gun:FindFirstChild("ShotgunThing") then
	fadg=fadg/2
	end
	if gun~="none" and gun and gun.Model:FindFirstChild("Switch") and equipped=="secondary" and special2==true then
	fadg=fadg*3
	end	
	if gun~="none" and gun and gun.Model:FindFirstChild("Switch") and equipped=="primary" and special==true then
	fadg=fadg*3
	end	
	if Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2") and Camera.Arms.Silencer2.Transparency==1 or (Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2")==nil or Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Silencer2") and Camera.Arms.Silencer2.Transparency==1) then
		fadg=fadg*1.5
	end
	--[[if gun and gun:FindFirstChild("Scoped") then
		fadg=fadg*1.5
	end]]
	--fadg=math.min(fadg,200)
	if fadg<=4 then
	fadg=0
	end
end
if actualfadg<fadg then
	actualfadg=math.min(actualfadg+25,fadg)
end
if actualfadg>fadg then
	actualfadg=math.max(actualfadg-50,fadg)
end
if Player.PlayerGui.GUI.Crosshairs.Crosshair.Visible then
local wideness=math.max(CHwideness,actualfadg+(CHwideness-7))
if dynamic==false then
	wideness=CHwideness
end
wideness=wideness+(wideness%2)
local chair=Player.PlayerGui.GUI.Crosshairs.Crosshair
chair.BottomFrame.Position=UDim2.new(0, -1, 0, -(chair.LeftFrame.Size.X.Offset+wideness))
chair.LeftFrame.Position=UDim2.new(0, -(chair.LeftFrame.Size.X.Offset+wideness),0,-1)
chair.RightFrame.Position=UDim2.new(0, wideness, 0, -1)
chair.TopFrame.Position=UDim2.new(0,-1,0,wideness)
local saz=(wideness+chair.RightFrame.Size.X.Offset+chair.RightFrame.BorderSizePixel)*2
saz=saz+(saz%2)
chair.Center1.Size=UDim2.new(0,saz,0,saz)
chair.Center1.Position=UDim2.new(0,-saz/2,0,-saz/2)
if wideness<=15 then
dottrans=math.min(1,dottrans+.2)
else
dottrans=math.max(0,dottrans-.4)
end
--chair.Dot.BackgroundTransparency=dottrans
end

if gun~="none" and gun and gun~="none" and gun.className=="Folder" and gun:FindFirstChild("Scoped") and ads==true then
	if aidle and aidle.IsPlaying==false then
	aidle:Play()
	end
else
	if aidle and aidle.IsPlaying==true then
	aidle:Stop()
	end
end


if Humanoid and Humanoid.Health>0 then

	if equipped=="equipment2" and fireani and fireani.IsPlaying==true then 
		changeviewheight(0.04-crouchingheight)
	else
		if Character and Character:FindFirstChild("Crouched") then
			if crouchJump==true then
				if viewheight~=0.04-crouchingheight then
					viewheight=0.04-crouchingheight
					Character.HumanoidRootPart.CFrame=Character.HumanoidRootPart.CFrame*CFrame.new(0,crouchingheight,0)
				end
			else
				changeviewheight(0.04-crouchingheight)
			end
		else
			if crouchJump==false then
				changeviewheight(0.04)
			end
		end
	end
	if Humanoid:GetState()==Enum.HumanoidStateType.Jumping or Humanoid:GetState()==Enum.HumanoidStateType.Freefall then
		if jumping==false then
			--Character.Head["Jump"]:Play()	
			jumping=true
		end
	else
		if jumping==true then
		if Character and Character:FindFirstChild("Head") then
			--print(tostring(crouchJump).." "..tostring(crouched))
			spawn(function()
			--wait(1/20)
				--if jumping==false then
					landing=true
					crouchJump = false
					local starttime=tick()
					repeat _Run.RenderStepped:wait() if jumping==true then return end until (tick()-starttime)>=.25
					landing=false
					
				--end
			end)
		end
		jumping=false
		end
	end
	running=false
	if Humanoid and (Humanoid:GetState()==Enum.HumanoidStateType.Climbing or Character:FindFirstChild("Climbing")) then
		climbing=true
	else
		climbing=false
	end
	if Player and Player.Character and Player.Character:FindFirstChild("UpperTorso") and Player.Character.UpperTorso.Velocity.magnitude>=5 and jumping==false then
		if Humanoid:GetState()==Enum.HumanoidStateType.Running or Humanoid:GetState()==Enum.HumanoidStateType.RunningNoPhysics then
			if (crouched==false or crouchcooldown>1) and not climbing and (UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.D) or Player.Character.UpperTorso.Velocity.magnitude>=game.ReplicatedStorage.HUInfo[gun.Name].WalkSpeed.Value*hammerunit2stud*0.9) then
			running=true
			end
		end
	end
look=Camera.CoordinateFrame.lookVector.Y
if look and lastlook and look~=lastlook then
game.ReplicatedStorage.Events.ControlTurn:FireServer(look,climbing)
end
lastlook=look

	speedupdate()
	if Character:FindFirstChild("Crouched") then
		if hooplamod<1 then
		hooplamod=math.min(1,hooplamod+0.1)
		end
	elseif crouched==false then
		if hooplamod>0 then
		hooplamod=math.max(0,hooplamod-0.1)
		end
	end
	if gun~="none" and gun and gun:FindFirstChild("Scoped") and gun:FindFirstChild("RifleThing")==nil and not _Run:IsStudio() or ads==true then
	gui.Crosshairs.Crosshair.Visible=false
	else
	gui.Crosshairs.Crosshair.Visible=true
	end
	if equipped~="none" and gun~="none" and gun and gun:FindFirstChild("Scoped") then
	scope.Position=UDim2.new(.5,-10-(gui.AbsoluteSize.y/2),0,-10-18)
	scope.Size=UDim2.new(0,20+gui.AbsoluteSize.y,0,20+gui.AbsoluteSize.y)
		if landing==true or running==true or jumping==true and (gun.Name=="Scout" and jumpscouting()==false or gun.Name~="Scout") or climbing==true or Character and Character:FindFirstChild("ScopeCooldown") then
			if scopescale < 0.5 then
			scopescale = math.min(0.5,scopescale+scaleIncrement)
				if Character:FindFirstChild("ScopeCooldown")  then
					scopescale=0.5
				end
			end
		else
			if scopescale > 0 then
			scopescale = math.max(0,scopescale-(scaleIncrement*2))
			end
		end
	scope.Scope.ImageTransparency=1*(scopescale*2)
	if Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Dot") then
		Camera.Arms.Dot.Transparency=0+(0.8*(scopescale*2))
	end
	scope.Scope.Blur.ImageTransparency=1-(0.05*(scopescale*2))
	scope.Scope.Blur.Blur.ImageTransparency=1-(0.15*(scopescale*2))
	crosshairs.Frame1.Size=UDim2.new(1,24+((gui.AbsoluteSize.x-gui.AbsoluteSize.y)/2),3,20)
	crosshairs.Frame1.Position=UDim2.new(-1,-26,-0.75,-10)
	crosshairs.Frame2.Size=UDim2.new(1,120+((gui.AbsoluteSize.x-gui.AbsoluteSize.y)/2),3,20)
	crosshairs.Frame2.Position=UDim2.new(1,3-((gui.AbsoluteSize.x-gui.AbsoluteSize.y)/2),-0.75,-10)

	end
		if Character and Character:FindFirstChild("Crouched") then
			if UpperTorso and UpperTorso.Velocity.magnitude>=1 and crouchwalkanim then
				if dochange~="" then
					if crouchwalkanim and crouchwalkanim.IsPlaying==true then
					crouchwalkanim:Stop(2*(crouchcooldown/4),nil,nil)
					end
				crouchwalkanim=Humanoid:LoadAnimation(script.Crouching[dochange.."Walk"])
				dochange=""
				end
				if crouchwalkanim and crouchwalkanim.IsPlaying==false then
				crouchwalkanim:Play(math.max(.4,2*(crouchcooldown/4)),nil,nil)
				end
				if crouchwalkanim then
					crouchwalkanim:AdjustSpeed(UpperTorso.Velocity.Magnitude/6.116)
				end
			else
				if crouchwalkanim and crouchwalkanim.IsPlaying==true then
				crouchwalkanim:Stop(math.max(.4,2*(crouchcooldown/4)),nil,nil)
				end
			end
		end
		if Character and crouched==false then
			if UpperTorso and UpperTorso.Velocity.magnitude<10 and shiftwalkanim and running==true then
				if dochange2~="" then
					if shiftwalkanim and shiftwalkanim.IsPlaying==true then
					shiftwalkanim:Stop(.4,nil,nil)
					end
				shiftwalkanim=Humanoid:LoadAnimation(script.Walking[dochange2.."Walk"])
				dochange2=""
				end
				if shiftwalkanim and shiftwalkanim.IsPlaying==false then
				shiftwalkanim:Play(.4,nil,nil)
				end
				if shiftwalkanim then
					shiftwalkanim:AdjustSpeed(UpperTorso.Velocity.Magnitude/10)
				end
			else
				if shiftwalkanim and shiftwalkanim.IsPlaying==true then
				shiftwalkanim:Stop(.4,nil,nil)
				end
			end
		end
	end
	if UpperTorso and Character and Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("Head") and Character:FindFirstChild("Humanoid") then
			Humanoid.CameraOffset=Vector3.new(0,viewheight-0.4,0)
	end
if Camera and Camera:FindFirstChild("Arms") and Character and Character:FindFirstChild("UpperTorso") then
	local cArms = Camera:FindFirstChild("Arms")

		if active or Character and Character:FindFirstChild("ScopeCooldown") then
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
		if ads==true then
		bobble = CFrame.new(((t/10)*(movementmult*0.35))*waveScale,(abs((t/10))*movementmult*0.35)*-waveScale,0) 
		end


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
	
	
	
if cArms:FindFirstChild("CSSArms") and Player and Player.Character and Player.Character:FindFirstChild("RightUpperArm") and Player.Character:FindFirstChild("Shirt") then
local cssArms = cArms:FindFirstChild("CSSArms")
local cssRightArm = cssArms:FindFirstChild("Right Arm")
cssRightArm.Transparency=0
cssRightArm.Shirt.Texture=Player.Character.Shirt.ShirtTemplate
cssRightArm.BrickColor=Player.Character["RightUpperArm"].BrickColor
if Player.Character:FindFirstChild("LeftUpperArm") and Camera.Arms.CSSArms:FindFirstChild("Left Arm") then
local cssLeftArm = cssArms:FindFirstChild("Left Arm")
cssLeftArm.Transparency=0
cssLeftArm.Shirt.Texture=Player.Character.Shirt.ShirtTemplate
cssLeftArm.BrickColor=Player.Character["LeftUpperArm"].BrickColor
end
end
local offset=CFrame.new(0,0,0)
--offset=offset*CFrame.new(0,0,0.4)

if tonumber(adsmodifier) and adsmodifier<1 and Character:FindFirstChild("AIMING") then
adsmodifier=mmin(1,adsmodifier+0.09)
if gun~="none" and gun and gun:FindFirstChild("Scoped") and gun:FindFirstChild("RifleThing")==nil then
adsmodifier=1
end
end
if tonumber(adsmodifier) and adsmodifier>0 and Character:FindFirstChild("AIMING")==nil then
adsmodifier=mmax(0,adsmodifier-0.09)
if gun~="none" and gun and gun:FindFirstChild("Scoped") and gun:FindFirstChild("RifleThing")==nil then
adsmodifier=0
end
end
			
			local cf=CFrame.new()
			local voffset=CFrame.new()
			if Camera and Camera.Arms:FindFirstChild("Offset") then
				Camera.Arms.Offset.Value = Vector3.new(player.Stats.yy.Value, player.Stats.zz.Value, player.Stats.xx.Value)
				voffset=CFrame.new(Camera.Arms.Offset.Value.X,Camera.Arms.Offset.Value.Y,Camera.Arms.Offset.Value.Z)
			end
			cf=Camera.CoordinateFrame*voffset
cArms.PrimaryPart.Anchored=true
--local cf=Camera.CoordinateFrame*offset
--if _Run:IsStudio() then
	----experimental shooting sway
	if adsmodifier<0.5 then
		local pivot=Camera.Arms.PrimaryPart.CFrame
		local angles=CFrame.Angles(math.rad(-px*rmr*2),math.rad(-py*rmr*2),0)
		if Camera.Arms:FindFirstChild("Joint") then
			local x,y,z=pivot:toEulerAnglesXYZ()
			pivot=CFrame.new(Camera.Arms.Joint.CFrame.p)*CFrame.Angles(x,y,z)
		end
		cf=((pivot * angles) * pivot:inverse()) * cf
	end
--end
cf=cf*(bobble)
		if ads==true and gun~="none" and gun and gun:FindFirstChild("Scoped") then
		crosshairs.Position=UDim2.new(bobble.X,0,-bobble.Y,0)
		else
		crosshairs.Position=UDim2.new(0,0,0,0)
		end
adscf=adsoffset
local x3,y3,z3=adscf:toEulerAnglesXYZ()
if tonumber(adsmodifier) then
cf=cf*CFrame.new(adscf.X*adsmodifier,adscf.Y*adsmodifier,adscf.Z*adsmodifier)*CFrame.Angles(x3*adsmodifier,y3*adsmodifier,z3*adsmodifier)
end
	if Camera and Camera:FindFirstChild("Arms2") then
		Camera.Arms2.PrimaryPart.Anchored=true
		Camera.Arms2:SetPrimaryPartCFrame(camera.CoordinateFrame*(bobble)*CFrame.Angles(-view_velocity[1]/150,-view_velocity[2]/150,0))
	end
if ads==false then
cf=cf*CFrame.Angles(-view_velocity[1]/150,-view_velocity[2]/150,0)
end
if game.Workspace:FindFirstChild("Crate") then
	cf=cf*CFrame.new(0,150,0)
end
cArms:SetPrimaryPartCFrame(cf)

end

	if Character and Character:FindFirstChild("PF")==nil and (Held==true or gun and gun~="none" and gun.Name=="R8" and Held2==true) and DISABLED==false and Humanoid and Humanoid.Health>0 and game.Workspace.Status.Preparation.Value==false and Player.PlayerGui.GUI.Defusal.Visible==false then
		--print('bashobi')	
		if gun.Name=="R8" and Held==true then
			Held=false
			fireani:Stop()
			pullani:Play(nil,nil,0.65)
			pulling=true
			local nib=tick()
			spawn(function()
				if pulling==true then
					if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("pull") then
						Character.Gun.pull:Play()
					end
					repeat _Run.RenderStepped:wait() if jumping==true then pullani:Stop(.3) return end if DISABLED==true then return end if pulling==false then return end until (tick()-nib)>=0.3
					pulling=false 
					firebullet()
					if equipped=="secondary" and ammocount2<=0 or equipped=="primary" and ammocount<=0 then
						if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Empty") then
						Character.Gun.Empty:Play()
						Held=false
						end
					end	
				end
			end)
		else
			if (Held==true or gun and gun~="none" and gun.Name=="R8" and Held2==true)  then
				if mode=="automatic" or gun~="none" and gun and gun~="none" and (gun:FindFirstChild("Melee") or gun:FindFirstChild("Grenade")) then
				else
					Held=false
					if gun and gun.Name=="R8" then
						Held2=false
					end
				end
			end
			if gun.Name=="R8" then
				firebullet(true)
			else
				firebullet()
			end
			if Character:FindFirstChild("Charging") then
				chargeleft=0
			end
			if equipped=="secondary" and ammocount2<=0 or equipped=="primary" and ammocount<=0 then
				if Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("Empty") then
				Character.Gun.Empty:Play()
				Held=false
				end
			end			
		end
	end
	
	if Character and Character:FindFirstChild("Charging") and Character:FindFirstChild("HumanoidRootPart") and Vector3.new(Character.HumanoidRootPart.Velocity.X,0,Character.HumanoidRootPart.Velocity.Z).magnitude<=16 and chargeleft<=80 then
		chargeleft=0
	end	
	if Character and Character:FindFirstChild("Charging") then
		chargeleft=math.clamp(chargeleft-(100/(60*1.5)),0,100)
		if chargeleft<=0 then
			Character.Charging:Destroy()
			Player.Character.HumanoidRootPart.Charge:Stop()
		end
	else
		local uncharged=false
		if chargeleft<100 then
			uncharged=true
		end
		chargeleft=math.clamp(chargeleft+(100/(60*8)),0,100)
		if chargeleft==100 and uncharged==true then
			script.Parent.Sounds.Recharged:Play()
		end
	end
	if game.ReplicatedStorage.gametype.Value=="juggernaut" and player.Status.Team.Value=="T" and Character and Character:FindFirstChild("Rage") then
		script.Parent.GUI.AmmoGUI.chrg.Visible=true
		script.Parent.GUI.AmmoGUI.rag.Visible=true
		script.Parent.GUI.AmmoGUI.chrg.Text="Rage (G): "..math.floor(Character.Rage.Value).."%"
		script.Parent.GUI.AmmoGUI.rag.Text="Charge (RMB): "..math.floor(chargeleft).."%"
	else
		script.Parent.GUI.AmmoGUI.chrg.Visible=false
		script.Parent.GUI.AmmoGUI.rag.Visible=false
	end
	if Character and Held2==true and DISABLED==false and Humanoid and Humanoid.Health>0 then
		if game.ReplicatedStorage.gametype.Value=="juggernaut" and Player.Status.Team.Value=="T" and Humanoid.WalkSpeed>0 then
			if chargeleft==100 then
				--charge me 180
				Held2=false
				Player.Character.HumanoidRootPart.Charge:Play()
				local int=Instance.new("IntValue")
				int.Name="Charging"
				int.Parent=Player.Character
			end
		else
			if  equipped=="melee" and game.Workspace.Status.Preparation.Value==false and Camera and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("Flash")==nil and Player.PlayerGui.GUI.Defusal.Visible==false then
				if mode=="automatic" or gun~="none" and gun and gun~="none" and gun:FindFirstChild("Melee") then
				else
				Held2=false
				end
				firebullet()
			end
			changeburstmode()
		end


		

	end
	
	

	
	if Humanoid and Humanoid.Health>0 then
		player.PlayerGui.GUI.KillCam.Visible=false
		player.PlayerGui.GUI.KillCam.Animate.Disabled=true
		if Character:FindFirstChild("PF") then
			Humanoid.PlatformStand=true
		else
			Humanoid.PlatformStand=false
		end
	else
		local visible=false
		script.Parent.GUI.Crosshairs.Crosshair.Visible=not visible
		script.Parent.GUI.Crosshairs.Scope.Visible=visible
		script.Parent.GUI.Crosshairs.Frame1.Visible=visible
		script.Parent.GUI.Crosshairs.Frame2.Visible=visible
		script.Parent.GUI.Crosshairs.Frame3.Visible=visible
		script.Parent.GUI.Crosshairs.Frame4.Visible=visible
	end


		--MouseCursorArea
		if ((script.Parent.GUI.Main.GlobalChat.ActiveOne.Value==true or script.Parent.GUI.Main.TeamChat.ActiveOne.Value==true or script.Parent.GUI["ShopMenu"].Visible==true or script.Parent:FindFirstChild("Ban").MainHandler.Visible) or script.Parent.Menew.Enabled==true or gui.TR.BodySearchResults.Visible or gui.TR.Winner.Visible or gui.TR.LeaderboardGUI.Visible or gui.TeamSelection.Visible or gui["Inventory&Loadout"].Visible or Buymenuframe.Visible or gui.MapVote.Visible or vipmenu.Visible or CrosshairCustom.Visible or ShopMenu.Visible or menugui.Enabled) or script.Parent.GUI.Spectate.Visible==true and (Camera.CameraType~=Enum.CameraType.Scriptable or Camera.CameraType==Enum.CameraType.Scriptable and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("toolname") and game.ReplicatedStorage.Weapons:FindFirstChild(Camera.Arms.toolname.Value) and game.ReplicatedStorage.Weapons:FindFirstChild(Camera.Arms.toolname.Value):FindFirstChild("Scoped")) then --or gui.Class.Visible or leaderboardGUI.Visible then
				local visible=false
				script.Parent.GUI.Crosshairs.Crosshair.Visible=not visible
				script.Parent.GUI.Crosshairs.Scope.Visible=visible
				script.Parent.GUI.Crosshairs.Frame1.Visible=visible
				script.Parent.GUI.Crosshairs.Frame2.Visible=visible
				script.Parent.GUI.Crosshairs.Frame3.Visible=visible
				script.Parent.GUI.Crosshairs.Frame4.Visible=visible
			Held = false
			currentTarget = nil
			crosshairs.Visible = false
			if Camera.CameraType==Enum.CameraType.Scriptable and Camera:FindFirstChild("Arms") and Camera.Arms:FindFirstChild("ADS") then
				crosshairs.Visible=true
				local visible=true
				script.Parent.GUI.Crosshairs.Crosshair.Visible=not visible
				script.Parent.GUI.Crosshairs.Scope.Visible=visible
				script.Parent.GUI.Crosshairs.Frame1.Visible=visible
				script.Parent.GUI.Crosshairs.Frame2.Visible=visible
				script.Parent.GUI.Crosshairs.Frame3.Visible=visible
				script.Parent.GUI.Crosshairs.Frame4.Visible=visible
				scope.Position=UDim2.new(.5,-10-(gui.AbsoluteSize.y/2),0,-10-18)
				scope.Size=UDim2.new(0,20+gui.AbsoluteSize.y,0,20+gui.AbsoluteSize.y)
				scope.Scope.ImageTransparency=0
				scope.Scope.Blur.ImageTransparency=1
				scope.Scope.Blur.Blur.ImageTransparency=1
				crosshairs.Frame1.Size=UDim2.new(1,24+((gui.AbsoluteSize.x-gui.AbsoluteSize.y)/2),3,20)
				crosshairs.Frame1.Position=UDim2.new(-1,-26,-0.75,-10)
				crosshairs.Frame2.Size=UDim2.new(1,120+((gui.AbsoluteSize.x-gui.AbsoluteSize.y)/2),3,20)
				crosshairs.Frame2.Position=UDim2.new(1,3-((gui.AbsoluteSize.x-gui.AbsoluteSize.y)/2),-0.75,-10)
			end
			if gui.Spectate.Visible==true and ((script.Parent.GUI.Main.GlobalChat.ActiveOne.Value==false and script.Parent.GUI.Main.TeamChat.ActiveOne.Value==false) and gui.TR.BodySearchResults.Visible==false and script.Parent.Menew.Enabled==false and gui.TR.Winner.Visible==false and gui.TR.LeaderboardGUI.Visible==false and gui["Inventory&Loadout"].Visible==false and script.Parent.GUI["ShopMenu"].Visible==false and gui.TeamSelection.Visible==false and gui.MapVote.Visible == false and Buymenuframe.Visible==false and CrosshairCustom.Visible==false and vipmenu.Visible == false and ShopMenu.Visible ==false) and InvenFrame.Visible == false then
				if not script.Parent:FindFirstChild("Ban").MainHandler.Visible then
					UIS.MouseIconEnabled = false
					crosshairs.Visible=true
				else
					UIS.MouseIconEnabled = true
				end
			else
				UIS.MouseIconEnabled = true
			end
			if script.Parent:FindFirstChild("Loading") then
				UIS.MouseIconEnabled = true
			end
		else
			UIS.MouseIconEnabled = false
		end
		if UIS.MouseIconEnabled == true then
			crosshairs.Visible=false
		end
		if eheld==true and game.ReplicatedStorage.gametype.Value=="TTT" then
			
			if gui.TR.BodySearchResults.Visible then
				eheld=false
				gui.TR.BodySearchResults.Visible = false
				gui.TR.BodySearchResults.Modal = false
			end
		end
		-------mouse hover
		if UIS.MouseIconEnabled==false  and game.Workspace:FindFirstChild("Map") then
			crosshairs.Visible = true
			crosshairs.Iconhair.D.Visible=false
			crosshairs.Iconhair.T.Visible=false
			local hitlist={game.Workspace["Ray_Ignore"],Camera,game.Workspace.Map:WaitForChild("Clips"),game.Workspace.Map:WaitForChild("SpawnPoints")}
			if Character then
				table.insert(hitlist,Character)
			end
			local ray=Ray.new(Camera.CoordinateFrame.p,Camera.CoordinateFrame.lookVector*999)
			local mTarget,targetpos=game.Workspace:FindPartOnRayWithIgnoreList(ray,hitlist)
			cursor(mTarget)

			if (eheld==true and not alive.Value or eheld==true and not ebounce and equipallowed and not UIS.MouseIconEnabled) and game.ReplicatedStorage.gametype.Value=="TTT" then
				eheld=false
				local mTarget = mouse.Target
				if mTarget and mTarget.Parent and mTarget.Parent:FindFirstChild("Identified") and ((alive.Value and UpperTorso and (UpperTorso.Position - mTarget.Parent:FindFirstChild("UpperTorso").Position).magnitude <= 10) or (not alive.Value and (Camera.CFrame.p - mTarget.Parent:FindFirstChild("UpperTorso").Position).magnitude <= 20)
					or (gun and gun.Name == "Binoculars")) then
					loadBodySearchMenu(mTarget)
				elseif mTarget and mTarget.Parent and mTarget.Parent.Parent and mTarget.Parent.Parent:FindFirstChild("Identified") and ((alive.Value and UpperTorso and (UpperTorso.Position - mTarget.Parent.Parent:FindFirstChild("UpperTorso").Position).magnitude <= 10) or (not alive.Value and (Camera.CFrame.p - mTarget.Parent.Parent:FindFirstChild("UpperTorso").Position).magnitude <= 20)) then
					loadBodySearchMenu(mTarget.Parent)
				end
				if gui.TR:FindFirstChild("DNA Scanner").Visible then
					gui.TR:FindFirstChild("DNA Scanner").Visible = false
					gui.TR:FindFirstChild("DNA Scanner").Modal = false
					gui.TR:FindFirstChild("DNAScannerNotify").Visible = true
				end
				pickup()
			end
			if mTarget ~= currentTarget or health1.Visible==false or (currentTargetHealth and currentTarget and currentTarget:FindFirstChild("Humanoid") and currentTarget:FindFirstChild("Humanoid").Health ~= currentTargetHealth) then
				currentTarget = mTarget
				health1.Visible = false
				name500.Visible = false
				reputation.Visible=false
				tag.Visible=false
				d.Visible=false
				tr.Visible=false
				name500.TextColor3 = Bnew("White").Color
				if Humanoid and Humanoid.Health > 0 or not alive.Value then
					if mTarget and mTarget.Parent and mTarget.Parent.Parent and (mTarget.Parent.Parent:FindFirstChild("Humanoid") or mTarget.Parent.Parent:FindFirstChild("Humanoid2")) then
						mTarget = mTarget.Parent
						currentTarget = mTarget
					end
					if mTarget and mTarget.Parent and mTarget.Parent:FindFirstChild("Humanoid2")  or mTarget and mTarget.Parent and mTarget.Parent:FindFirstChild("Humanoid") or mTarget and (mTarget.Name == "Health Station Object" or mTarget.Name == "Death Station Object") then
						local mTargetP = mTarget.Parent
						if mTarget and mTargetP and mTargetP:FindFirstChild("Humanoid2")  then
							if game.ReplicatedStorage.gametype.Value=="TTT" and mTargetP:FindFirstChild("Role") then
							health1.Visible = true
							name500.Visible = true
							reputation.Visible = true
							health1.Text = "Corpse"
							health1.TextColor3 = Cnew(255/255,255/255,255/255)
							reputation.TextColor3=Cnew(1,1,1)
							if mTargetP:FindFirstChild("Identified") and not mTargetP:FindFirstChild("Identified").Value then
								name500.TextColor3 = Cnew(1,1, 0)
								name500.Text = "Unidentified body"
								reputation.Text = "Press E to identify. Alt + E to search covertly."
							else
								name500.Text = mTargetP.Name
								reputation.Text = "Press E to search. Alt + E to search covertly."
							end
							currentTargetHealth = nil
							end
						else
							if game.ReplicatedStorage.gametype.Value=="TTT" or game.Players:GetPlayerFromCharacter(mTargetP) and game.Players:GetPlayerFromCharacter(mTargetP).Status.Team.Value==Player.Status.Team.Value then
								if game.ReplicatedStorage.gametype.Value=="TTT" then
									health1.Visible=true
									name500.Visible=true
									reputation.Visible=true
									reputation.Parent.Tag.Visible=true
									reputation.Parent.Tag.Text=""
									if player["Tags"][mTargetP.Name]["Tag"].Value ~= "" then
										tag.Visible = true
										tag.Text = player["Tags"][mTargetP.Name]["Tag"].Value
										tag.TextColor3 = player["Tags"][mTargetP.Name]["TagColor"].Value
									end
									if game.Players:GetPlayerFromCharacter(mTargetP):FindFirstChild("Status") then
										if game.Players:GetPlayerFromCharacter(mTargetP).Status.Role.Value=="Detective" then
											if d and tag then
											d.Visible=true
											
											tag.Visible=true
											tag.Text="DETECTIVE"
											tag.TextColor3=Cnew(0,0,255)
											end
										elseif game.Players:GetPlayerFromCharacter(mTargetP).Status.Role.Value=="Traitor" and Player.Status.Role.Value=="Traitor" then
											if tr and tag then
											tr.Visible=true
											tag.Visible=true
											tag.Text="FELLOW TRAITOR"
											tag.TextColor3=Cnew(255,0,0)
											end
										end
									end
									local label="Healthy"
									local color=Cnew(0,255/255,0)
									local hp = mTargetP.Humanoid.Health
									currentTargetHealth = hp
									if hp<100 then
										label="Hurt"
										color=Cnew(127/255,255/255,0)
									end
									if hp<=90 then
										label="Wounded"
										color=Cnew(255/255,255/255,0)
									end
									if hp<=50 then
										label="Badly Wounded"
										color=Cnew(255/255,127/255,0)
									end
									if hp<=25 then
										label="Near Death"
										color=Cnew(255/255,0,0)
									end
									reputation.Text="Reputable"
									reputation.TextColor3=Cnew(1,1,1)
									if game.Players:GetPlayerFromCharacter(mTargetP) and game.Players:GetPlayerFromCharacter(mTargetP):FindFirstChild("Status") then
										local kerma=game.Players:GetPlayerFromCharacter(mTargetP).Status.FakeKarma.Value
										if kerma<1000 then
											reputation.Text="Crude"
											reputation.TextColor3=Cnew(0.5,1,0)
										end
										if kerma<=900 then
											reputation.Text="Trigger-happy"
											reputation.TextColor3=Cnew(1,1,0)
										end
										if kerma<=800 then
											reputation.Text="Dangerous"
											reputation.TextColor3=Cnew(1,0.5,0)
										end
										if kerma<=700 then
											reputation.Text="Liable"
											reputation.TextColor3=Cnew(1,0,0)
										end
									end
									health1.Text=label
									health1.TextColor3=color
									name500.Text=mTargetP.Name
								end
								if game.Players:GetPlayerFromCharacter(mTargetP) then
									if game.Players:GetPlayerFromCharacter(mTargetP):FindFirstChild("LockedIn") then
										game.Players:GetPlayerFromCharacter(mTargetP).LockedIn:Destroy()
									end
									local bap=Instance.new("IntValue")
									bap.Name="LockedIn"
									bap.Parent=game.Players:GetPlayerFromCharacter(mTargetP)
									delay(0.5,function()
										bap:Destroy()
									end)
								end
								currentTarget=nil
							else
								name500.Text = ""
								currentTarget = nil
								currentTargetHealth = nil
							end
						end
					else
						name500.Text = ""
						currentTargetHealth = nil
					end
				end
				selectionSphere.Adornee = nil
				door=nil
				if mTarget and mTarget.Parent and mTarget.Parent:FindFirstChild("Event") and ((mTarget.Name=="HumanoidRootPart" or mTarget.Name=="Handle") and mTarget.Parent.Name=="Door" or mTarget.Parent.Name~="Door")  then
					door=mTarget
				end
				if alive.Value and mouse and mTarget and mTarget:IsA("BasePart") and mTarget:IsDescendantOf(game.Workspace.Debris) and UpperTorso and (mTarget.Position - UpperTorso.Position).magnitude <= 12 then
					local dunkey=mTarget
					if dunkey.Parent~=game.Workspace.Debris then
					dunkey=mTarget.Parent
					end
					if dunkey and game.ReplicatedStorage.Weapons:FindFirstChild(dunkey.Name) then
						if game.ReplicatedStorage.Weapons:FindFirstChild(dunkey.Name):FindFirstChild("Equipment2")==nil or game.ReplicatedStorage.Weapons:FindFirstChild(dunkey.Name):FindFirstChild("Equipment2") and Player.Status.Team.Value=="T" then
						name500.Visible = true
						health1.Visible = true
						health1.Text = "Press E to pick up"
						health1.TextColor3 = Cnew(1,1,1)
						name500.Text = GetName.getName(dunkey.Name)
						selectionSphere.Adornee = dunkey
						end
					end
				end
			end
			end
		end
end)




--anti cheat
local delay = false
itemblacklist = {
	"SphereHandleAdornment","BoxHandleAdornment","RodHandleAdornment"
}
local whitelist = {
	["Players"] = {0,1},
	["Page"] = {0,1},
	["ReportAbusePage"] = {0,1},
	["AlertViewBacking"] = {0,1},
	["Selection1"] = {0,math.huge},
	["Help"] = {0,1},
	["Record"] = {0,1},
	["LeaveGamePage"] = {0,1},
	["DeveloperConsole"] = {0,1},
	["TextLabel"] = {0,math.huge},
	["Output"] = {0,1},
	["MemoryAnalyzerRowClass"] = {0,1},
	["Avg Ping ms"] = {0,math.huge},
	["Replicator SendCluster"] = {0,math.huge},
	["Replicator ProcessPackets"] = {0,math.huge},
	["MemoryAnalyzerRowClass"] = {0,math.huge},
	["ResetCharacter"] = {0,math.huge},
	["TableHeader"] = {0,math.huge},
	["PerformanceStats"] = {0,math.huge},
	["Frame"] = {0,math.huge},
	["Notification"] = {0,math.huge},
	["StopRecording"] = {0,math.huge},
	["Record"] = {0,math.huge},
	["StatsBody"] = {0,math.huge},
	["PopupFrame"] = {0,math.huge},
	["SocialIcon"] = {0,math.huge},
	["ImageButton"] = {0,math.huge},
	["FriendStatus"] = {0,math.huge},
	["BGFrame"] = {0,math.huge},
	["PlayerName"] = {0,math.huge},
	["UITextSizeConstraint"] = {0,math.huge},
	["FriendStatusTextLabel"] = {0,math.huge},
	["ReportPlayerImageLabel"] = {0,math.huge},
	["Enabled"] = {0,math.huge},
	["MembershipIcon"] = {0,math.huge},
	["RightSideButtons"] = {0,math.huge},
	["NameLabel"] = {0,math.huge},
	["Icon"] = {0,math.huge},
	["ReportPlayer"] = {0,math.huge},
	["RightSideListLayout"] = {0,math.huge},
}
local count = 0

game.DescendantAdded:connect(function(obj)
	local can = pcall(function()
		local thing = obj.Parent
	end)
	if can then
		for i=1, #itemblacklist do
			if obj:IsA(itemblacklist[i]) then
				game.ReplicatedStorage.Events.test:FireServer(player.userId,"ILLEGALOBJ "..itemblacklist[i].." with the name of "..obj.Name)
			end
		end
	end
	if delay == true then return end
	count = count + 1
	if count > 10 then delay = true end
	
	
	
	spawn(function()
		local kick = false
		
		if can == false then
			local name = tostring(obj)
			local isPlayer = false
			
			for a,b in pairs(game.Players:GetChildren()) do
				if b.Name == name then
					isPlayer = true
					break
				end
			end
			
			if name ~= "TextLabel" and isPlayer == false then
				if whitelist[name] then
					whitelist[name][1] = whitelist[name][1] + 1
					
					if whitelist[name][1] > whitelist[name][2] then kick = true end
				else
					kick = true
				end
			end
		end
		
		if kick == true then game.ReplicatedStorage.Events.test:FireServer(player.userId,"Player was caught trying to inject "..tostring(obj)) end
	end)
	
	wait(0.5)
	
	if delay == true then
		delay = false
	end
end)


_Run.Heartbeat:connect(function()
	if (Buymenuframe.Visible or player and player:FindFirstChild("Status") and player.Status.Alive.Value==false) and game.ReplicatedStorage.gametype.Value~="TTT"  then
		gui.Cash.Visible=false
		gui.Location.Visible=false
		gui.Circle.Visible=false
		gui.Top.Visible=false
	else
		if game.ReplicatedStorage.gametype.Value=="TTT" then
			gui.Location.Visible=false
			gui.Circle.Visible=false
			gui.Top.Visible=false
			if player.Status.Alive.Value==false then
				gui.TR.BL.Visible=false
				gui.TR.BLA.Visible=true
				gui.TR.BLA.Role.InProg.Visible=false
				gui.TR.BLA.Role.RoundOver.Visible=false
				gui.TR.BLA.Role.Prep.Visible=false
				
				if game.Workspace.Status.Preparation.Value==true then
					gui.TR.BLA.Role.Prep.Visible=true
				elseif game.Workspace.Status.RoundOver.Value==true then
					gui.TR.BLA.Role.RoundOver.Visible=true
				else
					gui.TR.BLA.Role.InProg.Visible=true
				end
			else
				gui.TR.BLA.Visible=false
				gui.TR.BL.Visible=true
				gui.TR.BL.Role.Detective.Visible=false
				gui.TR.BL.Role.Innocent.Visible=false
				gui.TR.BL.Role.Prep.Visible=false
				gui.TR.BL.Role.RoundOver.Visible=false
				gui.TR.BL.Role.Traitor.Visible=false
				if game.Workspace.Status.Preparation.Value==true then
					gui.TR.BL.Role.Prep.Visible=true
				elseif game.Workspace.Status.RoundOver.Value==true then
					gui.TR.BL.Role.RoundOver.Visible=true
				else
					if player.Status.Role.Value=="Innocent" then
						gui.TR.BL.Role.Innocent.Visible=true
					elseif player.Status.Role.Value=="Traitor" then
						gui.TR.BL.Role.Traitor.Visible=true
					elseif player.Status.Role.Value=="Detective" then
						gui.TR.BL.Role.Detective.Visible=true
					end
				end
				end
			gui.Cash.Visible=false

		else
			gui.TR.BL.Visible=false
			gui.TR.BLA.Visible=false
			gui.Location.Visible=true
			gui.Location.Text="  "..player.Location.Value
			if game.ReplicatedStorage.gametype.Value=="deathmatch" or game.ReplicatedStorage.gametype.Value=="TTT" then
				if game.ReplicatedStorage.gametype.Value=="deathmatch" then
					gui.Top.Visible=true
				end
			else
				gui.Circle.Visible=true
			end
			
			gui.Cash.Visible=true
			gui.Cash.Text="$"..player.Cash.Value
		end
	end
	if player and player.Status and player.Status.Alive.Value==false and player.Character==nil and gui.TeamSelection.Visible==false then
		if game.ReplicatedStorage.gametype.Value=="deathmatch" or game.ReplicatedStorage.gametype.Value=="TTT" then
			if game.ReplicatedStorage.gametype.Value=="deathmatch" then
				gui.Top.Visible=true
			end
		else
			gui.Circle.Visible=true
		end
	
	end
	if player and player.Status and player.Status.Alive.Value==true and game.Workspace.Status.BuyTime.Value>0 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and game.Workspace.Map:FindFirstChild("SpawnPoints") and game.ReplicatedStorage.gametype.Value~="TTT" then
	local ray=Ray.new(player.Character.HumanoidRootPart.Position,Vector3.new(0,-150,0))
	local hit,pos=game.Workspace:FindPartOnRayWithWhitelist(ray,{game.Workspace.Map.SpawnPoints})
		if hit and hit.Name=="BuyArea" and Player.Status.Team.Value=="T" or hit and hit.Name=="BuyArea2" and Player.Status.Team.Value=="CT" or game.ReplicatedStorage.gametype.Value=="deathmatch" and Character and Character:FindFirstChild("ForceField") then
		gui.Cash.BuyZone.Visible=true
		else
		gui.Cash.BuyZone.Visible=false	
			if startmusic==false and Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health>0 and game.Workspace.Status.Preparation.Value==false and UpperTorso and UpperTorso.Velocity.magnitude>=6 then
				startmusic=true
				activatemusic("Start")
			end
		end
	end
	FixKillFeed()
	Buymenuframe.Base.Outline.Cash.Text="$"..player.Cash.Value
	Buymenuframe.Base.Outline.TimeLeft.Text="Buy Time Left: "..game.Workspace.Status.BuyTime.Value

	if Player and Player:FindFirstChild("Status") and Player.Status.Alive.Value==true then
		--InvenFrame.Visible = false
	end
	if Humanoid and Humanoid.Health>0 then
	elseif script.Parent:FindFirstChild("GUI") then
		script.Parent.GUI.Defusal.Visible=false
	end


	if game.Workspace:FindFirstChild("C4") and script.Parent:FindFirstChild("GUI") then
		game.Players.LocalPlayer.PlayerGui.GUI.UpperInfo.Timer.TextTransparency=1
		game.Players.LocalPlayer.PlayerGui.GUI.UpperInfo.Timer.Bomb.Visible=true
	elseif script.Parent:FindFirstChild("GUI") then
		game.Players.LocalPlayer.PlayerGui.GUI.UpperInfo.Timer.TextTransparency=0
		game.Players.LocalPlayer.PlayerGui.GUI.UpperInfo.Timer.Bomb.Visible=false
	end
	
	
end)

game.Workspace.ChildAdded:connect(function(child)	
	if child.Name == "Map" and game.Players.LocalPlayer:FindFirstChild("LocalData") and game.Players.LocalPlayer.LocalData:FindFirstChild("NoDecals") and game.Players.LocalPlayer.LocalData.NoDecals.Value==false then
		for _,v in pairs(child:GetDescendants()) do
			pcall(function()
				if v:IsA("Texture") or v:IsA("Decal") and v.Parent and v.Parent.Name~="Radar2" and v.Parent.Name~="Radar" then
					v:Destroy()
				end
			end)
		end
	end
end)

--[[
local Ping = require(game.ReplicatedStorage.Modules.ping)
Ping:Loop()
]]


coroutine.wrap(function()
	while wait(5) do
		if game.Workspace.Status.CanRespawn.Value==true and game.Players.LocalPlayer.Status.Alive.Value==true and game.Players.LocalPlayer.Status.Team.Value~="Spectator" and (game.Players.LocalPlayer.Character==nil or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")==nil) then
			game.ReplicatedStorage.Events.ForceRespawn:FireServer()
		end
	end
end)()
local firetime=nil
--while _Run.Stepped:wait() do
while wait(0.2) do
	local damaged=false
	local boop=game.Workspace["Ray_Ignore"].Fires:GetChildren()
	if #boop>0 and Character and Character:FindFirstChild("HumanoidRootPart") then
		for i=1,#boop do
			local ray=Ray.new(Character.HumanoidRootPart.Position,Vector3.new(0,-10,0))
			local h,p=game.Workspace:FindPartOnRayWithWhitelist(ray,{boop[i]})
			if h then
				if h.Fire.Enabled==true then
					---OWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWIE
					damaged=true
					if firetime==nil then
						firetime=tick()
					end
					game.ReplicatedStorage.Events.BURNME:FireServer(h,tick()-firetime)
				end
			end
		end
		wait(0.2)
	end
	if damaged==false then
		firetime=nil
	end
end
