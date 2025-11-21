_insert = game:GetService("InsertService")
local drops = 0
local dmgmodule = require(game.ReplicatedStorage.Modules.Damage)
local gt = game.ReplicatedStorage.gametype
------------TROUBLE IN TERRORIST TOWN------------------------------
local traitorpct = 0.25
local traitormax = 32
local rs = game:GetService("RunService")
local RepStorage = game:GetService("ReplicatedStorage")

local detectiveminplayers = 8
currencybranch = "release1"
marketplaceservice = game:GetService("MarketplaceService")
BadgeService = game:GetService("BadgeService")
currencyData = game:GetService("DataStoreService"):GetDataStore("Currency", currencybranch)
local detectivepct = 0.13
local detectivemax = 32
local minkarmadet = 800
local kmid = 0007
local playerChatted = game.ReplicatedStorage.Events:WaitForChild("PlayerChatted")
playerChatted.OnServerEvent:connect(function(player, message, team, role, dead, filter, qc)
	playerChatted:FireAllClients(player.Name, message, team, role, dead, filter, qc)
end)

game.ReplicatedStorage.Events.Reset.OnServerEvent:connect(function(player)
	if player and player.Character and player.Character:FindFirstChild("FallCausedBy") then
		player.Character.FallCausedBy.Value = nil
	end
end)


game.ReplicatedStorage.Events.Rage.OnServerEvent:connect(function(p)
	if p and p.Character and p.Character.Rage.Value>=100 and p.Character:FindFirstChild("HumanoidRootPart") and gt.Value=="juggernaut" and p.Status.Team.Value=="T"  then
		local sp=p.Character.HumanoidRootPart.Position
		p.Character.Rage.Value=0
		local losers=game.Players:GetPlayers()
		for i=1,#losers do
			if losers[i].Name~=p.Name and losers[i].Character and losers[i].Character:FindFirstChild("HumanoidRootPart") and (sp-losers[i].Character.HumanoidRootPart.Position).magnitude<=70 then
				local modifier=(sp-losers[i].Character.HumanoidRootPart.Position).magnitude/70
				local mech=Instance.new("IntValue")
				mech.Name="PF"
				mech.Parent=losers[i].Character
				losers[i].Character.Humanoid.PlatformStand=true
				local force = Instance.new("BodyVelocity")
				force.Name = "WindEffect"
				force.maxForce = Vector3.new(1e7, 1e7, 1e7)
				force.P = 125
				force.velocity = ((sp-losers[i].Character.HumanoidRootPart.Position).unit*-50*(1-modifier))+Vector3.new(0,25*(1-modifier),0)
				force.Parent = losers[i].Character.HumanoidRootPart
				delay(0.25,function()
					force:Destroy()
				end)
				local pp=game.ReplicatedStorage.Sounds.Discombobulate:clone()
				pp.Parent=losers[i].Character.HumanoidRootPart
				pp.PlayOnRemove=true
				pp:Destroy()
				local duration=5*(1-modifier)
				delay(duration,function()
					mech:Destroy()
				end)
			end
		end
	end
end)


game.ReplicatedStorage.Events.IDBody.OnServerEvent:connect(function(player, s, c)
	if s == "id" and c then
		c.Identified.Value = true
		if c.Role.Value == "Innocent" then
			game.Workspace.Feed.Value = player.Name.." has found the body of "..c.Name..". They were innocent."
		else
			game.Workspace.Feed.Value = player.Name.." has found the body of "..c.Name..". They were a "..c.Role.Value.."!"
		end
		if game.Players:FindFirstChild(c.Name) and game.Players:FindFirstChild(c.Name):FindFirstChild("Status") then
			game.Players:FindFirstChild(c.Name):FindFirstChild("Status").Identified.Value = true
		end
	end
	if s == "conf" and c then
		local object = Instance.new("Folder")
		object.Name = "Confirmed"
		object.Parent = c
	end
	if s == "confirm" and c then
		c.Identified.Value = true
		game.Workspace.Feed.Value = player.Name.." confirmed the death of "..c.Name.."."
		if game.Players:FindFirstChild(c.Name) and game.Players:FindFirstChild(c.Name):FindFirstChild("Status") then
			game.Players:FindFirstChild(c.Name):FindFirstChild("Status").Identified.Value = true
		end
	end
end)

game.ReplicatedStorage.Events.LoadCharacter.OnServerEvent:connect(function(p)
	if gt.Value == "TTT" and game.Workspace.Status.CanRespawn.Value == true and p.Status.Alive.Value == false then
		if game.Workspace.Debris:FindFirstChild(p.Name) then
			game.Workspace.Debris[p.Name]:Destroy()
		end
		p.Status.Team.Value = "Terrorist"
		p.Status.Alive.Value = true
		
		loadcharacter(p)
	end
end)

game.ReplicatedStorage.Events.ForceRespawn.OnServerEvent:connect(function(p)
	if p and game.Workspace.Status.CanRespawn.Value == true and p.Status.Team.Value ~= "Spectator" then
		if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
		else
			loadcharacter(p)
		end
	end
end)


local function GetTraitorCount(ply_count)
   -- get number of traitors: pct of players rounded down
	local traitor_count = math.floor(ply_count * traitorpct)
   -- make sure there is at least 1 traitor
	traitor_count = math.clamp(traitor_count, 1, traitormax)

	return traitor_count
end


local function GetDetectiveCount(ply_count)
	if ply_count < detectiveminplayers then
		return 0
	end

	local det_count = math.floor(ply_count * detectivepct)
   -- limit to a max
	det_count = math.clamp(det_count, 1, detectivemax)

	return det_count
end


function tttwincheck()
	local traitor_alive = false
	local innocent_alive = false
	for k, v in pairs(game.Players:GetPlayers()) do
		if v.Status.Alive.Value == true and v.Status.Team.Value == "Terrorist" then
			if v.Status.Role.Value == "Traitor" then
				traitor_alive = true
			else
				innocent_alive = true
			end
		end

		if traitor_alive and innocent_alive then
			return "timeranout"
		end
	end

	if traitor_alive and not innocent_alive then
		return "traitor"
	elseif not traitor_alive and innocent_alive then
		return "innocent"
	elseif not innocent_alive then
      -- ultimately if no one is alive, traitors win
		return "traitor"
	end

	return "timeranout"
end

function hasvalue(tab, str)
	local boop = tab
	for i = 1, #boop do
		if boop[i] == str then
			return true
		end
	end
	return false
end

function DefaultCredits(p)
	
end

function SelectRoles()
	local choices = {}
	local innocent = {}
	local traitor = {}
	local detective = {}

	for k, v in pairs(game.Players:GetPlayers()) do
      -- everyone on the spec team is in specmode
		if v and v:FindFirstChild("Status") and v.Status.Alive.Value == true and v.Status.Team.Value == "Terrorist" then
         -- save previous role and sign up as possible traitor/detective

			local r = v.Status.LastRole.Value == "Innocent" and innocent or v.Status.LastRole.Value == "Traitor" and traitor or v.Status.LastRole.Value == "Detective" and detective

			table.insert(r, v)

			table.insert(choices, v)
			v.Status.Identified.Value = false
		end
		if v:FindFirstChild("Status") then
			v.Status.Role.Value = "Innocent"
		end
	end

   -- determine how many of each role we want
	local choice_count = #choices
	local traitor_count = GetTraitorCount(choice_count)
	local det_count = GetDetectiveCount(choice_count)

	if choice_count == 0 then
		return
	end

   -- first select traitors
	local ts = 0
	while ts < traitor_count do
      -- select random index in choices table
		local pick = math.random(1, #choices)

      -- the player we consider
		local pply = choices[pick]

      -- make this guy traitor if he was not a traitor last time, or if he makes
      -- a roll
		if pply:IsA("Player") and
         ((not hasvalue(traitor, pply)) or (math.random(1, 3) == 2)) then
			pply.Status.Role.Value = "Traitor"

			table.remove(choices, pick)
			ts = ts + 1
		end
	end

   -- now select detectives, explicitly choosing from players who did not get
   -- traitor, so becoming detective does not mean you lost a chance to be
   -- traitor
	local ds = 0
	local min_karma = minkarmadet or 0
	while (ds < det_count) and (#choices >= 1) do

      -- sometimes we need all remaining choices to be detective to fill the
      -- roles up, this happens more often with a lot of detective-deniers
		if #choices <= (det_count - ds) then
			for k, pply in pairs(choices) do
				if pply:IsA("Player") then
					pply.Status.Role.Value = "Detective"
				end
			end

			break -- out of while
		end


		local pick = math.random(1, #choices)
		local pply = choices[pick]

      -- we are less likely to be a detective unless we were innocent last round
		if (pply:IsA("Player") and
          ((pply.Status.Karma.Value > min_karma and
          hasvalue(innocent, pply)) or
           math.random(1, 3) == 2)) then

         -- if a player has specified he does not want to be detective, we skip
         -- him here (he might still get it if we don't have enough
         -- alternatives)
        -- if not pply:GetAvoidDetective() then
			pply.Status.Role.Value = "Detective"
			ds = ds + 1
         --end

			table.remove(choices, pick)
		end
	end
	game.Workspace.Innocents.Value = choice_count - (ts + ds)
	game.Workspace.Traitors.Value = ts
	game.Workspace.Detectives.Value = ds
	for _, ply in pairs(game.Players:GetPlayers()) do
		if ply:FindFirstChild("Status") then
      -- initialize credit count for everyone based on their role
			DefaultCredits(ply)

      -- store a steamid -> role map
			ply.Status.LastRole.Value = ply.Status.Role.Value
		end
	end
	local feed = game.Workspace.Feed
	local tFeed = game.Workspace.TFeed
	game.Workspace.RoundStart:Play()
	if ts == 1 then
		feed.Value = "A new round has begun. There are currently "..(game.Workspace.Innocents.Value).." Innocent(s), "..game.Workspace.Detectives.Value.." Detective(s) and 1 Traitor."
		spawn(function()
			wait(0.5)
			tFeed.Value = "Traitor, you stand alone!"
			wait(0.5)
			tFeed.Value = ""
		end)
	else
		feed.Value = "A new round has begun. There are currently "..(game.Workspace.Innocents.Value).." Innocent(s), "..ds.." Detective(s) and "..ts.." Traitors."
	end
end




---------------------------

local PhysicsService = game:GetService("PhysicsService")
PhysicsService:CreateCollisionGroup("T")
PhysicsService:CreateCollisionGroup("CT")
PhysicsService:CreateCollisionGroup("Debris")
PhysicsService:CreateCollisionGroup("RagdollParts")
PhysicsService:CreateCollisionGroup("Players")
PhysicsService:CreateCollisionGroup("Grenades")
PhysicsService:CreateCollisionGroup("Clips")
PhysicsService:CreateCollisionGroup("Glass") --8
PhysicsService:CreateCollisionGroup("CTGrenades")
PhysicsService:CollisionGroupSetCollidable("CT", "Debris", false)
PhysicsService:CollisionGroupSetCollidable("T", "Debris", false)
PhysicsService:CollisionGroupSetCollidable("CT", "CT", false)
PhysicsService:CollisionGroupSetCollidable("T", "T", false)

--------------
PhysicsService:CollisionGroupSetCollidable("CT", "Grenades", true)
PhysicsService:CollisionGroupSetCollidable("T", "Grenades", false)
PhysicsService:CollisionGroupSetCollidable("Glass", "Grenades", false)
PhysicsService:CollisionGroupSetCollidable("RagdollParts", "Grenades", false)
PhysicsService:CollisionGroupSetCollidable("Debris", "Grenades", false)
PhysicsService:CollisionGroupSetCollidable("Clips", "Grenades", false)
PhysicsService:CollisionGroupSetCollidable("Players", "Grenades", false)
PhysicsService:CollisionGroupSetCollidable("Grenades", "Grenades", false)
--
PhysicsService:CollisionGroupSetCollidable("CT", "CTGrenades", false)
PhysicsService:CollisionGroupSetCollidable("T", "CTGrenades", true)
PhysicsService:CollisionGroupSetCollidable("Glass", "CTGrenades", false)
PhysicsService:CollisionGroupSetCollidable("RagdollParts", "CTGrenades", false)
PhysicsService:CollisionGroupSetCollidable("Debris", "CTGrenades", false)
PhysicsService:CollisionGroupSetCollidable("Clips", "CTGrenades", false)
PhysicsService:CollisionGroupSetCollidable("Players", "CTGrenades", false)
PhysicsService:CollisionGroupSetCollidable("CTGrenades", "CTGrenades", false)
--------------------

--------------------
PhysicsService:CollisionGroupSetCollidable("RagdollParts", "CT", false)
PhysicsService:CollisionGroupSetCollidable("RagdollParts", "T", false)
PhysicsService:CollisionGroupSetCollidable("RagdollParts", "Debris", false)
PhysicsService:CollisionGroupSetCollidable("RagdollParts", "RagdollParts", false)
PhysicsService:CollisionGroupSetCollidable("Players", "Debris", false)
PhysicsService:CollisionGroupSetCollidable("RagdollParts", "Players", false)
PhysicsService:CollisionGroupSetCollidable("Players", "Players", true)

-------

local GamemodeID_CasualActiveDuty = 9198438999
local GamemodeID_CasualReserves = 1
local GamemodeID_Demolition = 1
local GamemodeID_Competitive = 1480424328
local GamemodeID_TTT = 1849599345
local GamemodeID_Deathmatch = 9507822620
local GamemodeID_Juggernaut = 2503278085
local GamemodeID_OrganCollection = 0000
local PlaceID = game.PlaceId
function removemaps(gamemode)
	local shit = game.ServerStorage.Maps:GetChildren()
	for i = 1, #shit do
		if string.sub(shit[i].Name, 1, 3) == "ttt" then
			if gamemode == "TTT" then
			else
				shit[i]:Destroy()
			end
		--elseif string.sub(shit[i].Name,1,2)=="dm" then
			--if gamemode=="deathmatch" then
			--else
			--	shit[i]:Destroy()
			--end
		else		
			if gamemode == "TTT"  then
				shit[i]:Destroy()
			end
		end
		
	end
end
gt.Value = "casual"
if PlaceID == GamemodeID_CasualActiveDuty or rs:IsStudio() then
	gt.Value = "casual"
elseif PlaceID == GamemodeID_CasualReserves then
	gt.Value = "casual"
elseif PlaceID == GamemodeID_Competitive then
	gt.Value = "competitive"
	PhysicsService:CollisionGroupSetCollidable("CT", "CT", true)
	PhysicsService:CollisionGroupSetCollidable("T", "T", true)
elseif PlaceID == GamemodeID_TTT then
	gt.Value = "TTT"
	PhysicsService:CollisionGroupSetCollidable("CT", "CT", true)
	PhysicsService:CollisionGroupSetCollidable("T", "T", true)
elseif PlaceID == GamemodeID_Demolition then
	gt.Value = "demolition"
elseif PlaceID == GamemodeID_Deathmatch then
	gt.Value = "deathmatch"
elseif PlaceID == GamemodeID_Juggernaut then
	gt.Value = "juggernaut"
end

--if rs:IsStudio() then
	--gt.Value = "juggernaut" --remove on release
--end

removemaps(gt.Value)



local BoolSettings = {
	"LowQuality",
	"LowViolence",
	"AltCrouch"
}
local NumberSettings = {
	"MusicVolume",
	"FOV",
	"CustomPlayerIcon"
}

DS = game:GetService("DataStoreService"):GetDataStore("stinky2")	

game.ReplicatedStorage.Events.TeleportSetting.OnServerEvent:connect(function(player, setting)
	if setting and setting ~= "" and setting ~= "dab" and game.Workspace.Status.changemade.Value == false then
		game.Workspace.Status.changemade.Value = true
		gt.Value = setting
		if setting == "TTT" then
			local boop = game.Players:GetPlayers()
			for i = 1, #boop do
				boop[i].Status.Team.Value = "Spectator"
				boop[i].TeamColor = BrickColor.new("Really red")
				loadcharacter(boop[i])
			end
		end
		if setting == "competitive" or setting == "TTT" then
			PhysicsService:CollisionGroupSetCollidable("CT", "CT", true)
			PhysicsService:CollisionGroupSetCollidable("T", "T", true)
		end
	end
end)
function assignvariants()
	local players = game.Players:GetPlayers()
	local tvariants = {
		1,
		2,
		3,
		4,
		5
	}
	local ctvariants = {
		1,
		2,
		3,
		4,
		5
	}
	for i = 1, #players do
		if players[i]:FindFirstChild("Status") and players[i].Status.Team.Value ~= "Spectator" then
			if players[i].Status.Team.Value == "CT" then
				if players[i].Variant.Value > 0 then
					for g = 1, #ctvariants do
						if ctvariants[g] == players[i].Variant.Value then
							table.remove(ctvariants, g)
						end
					end
				end
			end
			if players[i].Status.Team.Value == "T" then
				if players[i].Variant.Value > 0 then
					for g = 1, #tvariants do
						if tvariants[g] == players[i].Variant.Value then
							table.remove(tvariants, g)
						end
					end
				end
			end
		end
	end
	for i = 1, #players do
		if players[i]:FindFirstChild("Variant") and players[i].Variant.Value == 0 and players[i].Status.Team.Value ~= "Spectator" then
			if #tvariants <= 0 then
				tvariants = {
					1,
					2,
					3,
					4,
					5
				}
			end
			if #ctvariants <= 0 then
				ctvariants = {
					1,
					2,
					3,
					4,
					5
				}
			end
			if players[i].Status.Team.Value == "T" then
				local numy = math.random(1, #tvariants)
				local ree = tvariants[numy]
				players[i].Variant.Value = ree
				table.remove(tvariants, numy)				
			elseif players[i].Status.Team.Value == "CT" then
				local numy = math.random(1, #ctvariants)
				local ree = ctvariants[numy]
				players[i].Variant.Value = ree
				table.remove(ctvariants, numy)				
			end
		end
	end
end
-- Server:
local roundtime = 120
local gametype = gt
local playersinteam = 5
function game.ReplicatedStorage.Functions.Ping.OnServerInvoke(player)
	return true
end


function createhelmet(player)
	if player:FindFirstChild("Helmet") == nil then
		local narb2 = Instance.new("IntValue")
		narb2.Name = "Helmet"
		narb2.Parent = player
	end				
end
function createkevlar(player)
	if player:FindFirstChild("Kevlar") then
		player.Kevlar:Destroy()
	end
	local narb = Instance.new("IntValue")
	narb.Name = "Kevlar"
	narb.Value = 100
	narb.Parent = player
	if player:FindFirstChild("Kevlar") then
		narb = player:FindFirstChild("Kevlar")
		narb.Changed:connect(function(c)
			wait()
			if player:FindFirstChild("Kevlar") then
				if player:FindFirstChild("Kevlar").Value <= 0  then
					if player:FindFirstChild("Helmet") then
						player.Helmet:Destroy()
					end
					player:FindFirstChild("Kevlar"):Destroy()
				end
			end	
		end)
	end
end
game.ReplicatedStorage.Events.UpdatePing.OnServerEvent:connect(function(player, ping)
	if player and player:FindFirstChild("Ping") and ping and tonumber(ping) then
		player.Ping.Value = math.floor(ping * 500)
	end
end)







local playercollisions = false
local teamdamage = false
local rounds = 15
local roundsneededtowin = 8



local tlosingstreak = 0
local ctlosingstreak = 0



-- sprays [don't do it you gay motherfucker]
game.ReplicatedStorage.Events.CreatePray.OnServerEvent:Connect(function(player, surface, part)
	
end) 













local tremove = table.remove
local tinsert = table.insert
local mmax = math.max
local mmin = math.min
local mrandom = math.random
local ssub = string.sub
local defaultcash = 1000
local maxmoney = 10000

game.ReplicatedStorage.Events.AdjustADS.OnServerEvent:connect(function(player, val, val2)
	if player and player.Character and player.Character:FindFirstChild("ADS") and player.Character.ADS:FindFirstChild("Doublezoom") then
		player.Character.ADS.Value = false
		player.Character.ADS.Doublezoom.Value = false
		if val == true then
			player.Character.ADS.Value = val
		end
		if val2 == true then
			player.Character.ADS.Doublezoom.Value = val2
		end
	end
end)
local function addcash(player, cash, context)
	if gt.Value == "TTT" or gt.Value == "deathmatch" then
		return
	end
	if player and player:FindFirstChild("Cash") then
		player.Cash.Value = math.min(player.Cash.Value + cash, maxmoney)
		if context then
			game.ReplicatedStorage.Events.SendMsg:FireClient(player, context, Color3.new(0, 210 / 255, 0))
		end
	end
end

local function removecash(player, cash, context)
	if player and player:FindFirstChild("Cash") then
		player.Cash.Value = math.max(player.Cash.Value - cash, 0)
		if context then
			game.ReplicatedStorage.Events.SendMsg:FireClient(player, context, Color3.new(210 / 255, 0, 0))
		end
	end
end
local function peoplealive()
	local ppls = {}
	local T = 0
	local CT = 0
	if rs:IsStudio() then
		T = T + 1
		CT = CT + 1
	end
	local dead = 0
	local proven = 0
	local players = game.Players:GetPlayers()
	for i = 1, #players do 
		if players[i]:FindFirstChild("Status") and players[i].Status.Alive.Value == false and players[i].Status.Team.Value == "Terrorist" then
			dead = dead + 1
		end
		if players[i]:FindFirstChild("Status") and players[i].Status.Team.Value ~= "Spectator" and players[i].Status.Alive.Value == true then
			tinsert(ppls, players[i])
			if gt.Value == "TTT" then
				if players[i].Status.Role.Value == "Traitor" then
					CT = CT + 1
				else
					T = T + 1
					if players[i].Character and players[i].Character:FindFirstChild("Proven") then
						proven = proven + 1
					end
				end
			else
				
				if players[i].Status.Team.Value == "CT" then
					CT = CT + 1
				elseif players[i].Status.Team.Value == "T" then
					T = T + 1
				end
			end
		end
	end	
	if gt.Value == "TTT" then
		if math.floor(proven) >= math.floor(CT) or T <= CT then
			for i = 1, #players do
				if players[i]:FindFirstChild("Status") and players[i].Status.Role.Value == "Traitor" then
					if players[i].Character and players[i].Character:FindFirstChild("RDMProtection") then
						players[i].Character.RDMProtection:Destroy()
					end
				end
			end
		end
	end
	return ppls, T, CT
end




local function getKillerOfHumanoidIfStillInGame(humanoid)

	local tag = nil
	for i = 1, #humanoid:GetChildren() do
		local v = humanoid:GetChildren()[i]
		if v.Name == "creator" then
			if not tag then
				tag = v

			end
		--[[	if not assister and tag ~= v then
			assister = v.Value
			end]]--
		end
	end
	if tag then
		
		local killer = tag.Value
		if killer.Parent then 
			return killer
		end
	end

	return nil
end

game.ReplicatedStorage.Events.Flashlight.OnServerEvent:connect(function(player)
	if player and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character.Head:FindFirstChild("SpotLight") then
		player.Character.Head.SpotLight.Enabled = not player.Character.Head.SpotLight.Enabled
	end
end)
game.ReplicatedStorage.Events.ReplicateCamera.OnServerEvent:connect(function(player, cf)
	if player.CameraCF then
		player.CameraCF.Value = cf
	end
end)
game.ReplicatedStorage.Events.ReplicateAnimation.OnServerEvent:connect(function(player, kf)
	if player and player.Character and player.Character:FindFirstChild("Gun") and player.Character.Gun:FindFirstChild("AnimateValue") then
		local obj = Instance.new("IntValue")
		obj.Name = kf
		obj.Parent = player.Character.Gun.AnimateValue
		delay(.4, function()
			obj:Destroy()
		end)
	end
end)

local magRate = {}
local MAG_RATE_LIMIT = 1.25 -- Nobody is dropping mags this fast
game.ReplicatedStorage.Events.DropMag.OnServerEvent:connect(function(player, mag)
	-- Rate limit
	local now = tick()
	local lastSent = magRate[player] or 0
	if now - lastSent < MAG_RATE_LIMIT then return end
	magRate[player] = now
	
	-- Rolve Code (vomit now)
	if mag and player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
		local magclone = mag:clone()
		magclone.Name = "MagDrop"
		magclone.CollisionGroupId = 3
		magclone.CanCollide = true
		if magclone:FindFirstChild("Welded") then
			magclone.Welded:Destroy()
		end
		magclone.CFrame = mag.CFrame
		magclone.Parent = game.Workspace["Ray_Ignore"]
		delay(10, function()
			magclone:Destroy()
		end)
	end
end)
local shots = 0
game.ReplicatedStorage.Events.ApplySilencer.OnServerEvent:connect(function(player, soundid)
	wait(1 / 10)
	if player and player.Character and player.Character:FindFirstChild("Gun") and player.Character.Gun:FindFirstChild("Silencer2") then
		if player.Character.Gun.Shoot.SoundId == soundid then
			player.Character.Gun.Silencer2.Transparency = 0
		end
	end
end)
game.ReplicatedStorage.Events.RemoveSilencer.OnServerEvent:connect(function(player, soundid)
	wait(1 / 10)
	if player and player.Character and player.Character:FindFirstChild("Gun") and player.Character.Gun:FindFirstChild("Silencer2") then
		if player.Character.Gun.Shoot.SoundId == soundid then
			player.Character.Gun.Silencer2.Transparency = 1
		end
	end
end)

game.ReplicatedStorage.Events.Trail.OnServerEvent:connect(function(player, flash, fdirection, hitlist)
	spawn(function()
		local players = game.Players:GetPlayers()
		for i = 1, #players do
			if players[i]:FindFirstChild("Status") then
				if players[i].Name ~= player.Name and (gt.Value == "TTT" or players[i].Status:FindFirstChild("HasSelectedTeam") == nil) then
					game.ReplicatedStorage.Events.Trail:FireClient(players[i], flash, fdirection, hitlist)
				end
			end
		end
	end)
end)



game.ReplicatedStorage.Events.Whizz.OnServerEvent:connect(function(player, whichplayer, gun)
	if player and whichplayer then
		if gt.Value == "TTT" then
			if whichplayer and whichplayer.Character and whichplayer.Character:FindFirstChild("RDMProtection") then
				if player and player.Character and player.Character:FindFirstChild("RDMProtection") then
					player.Character.RDMProtection:Destroy()
					delay(4, function()
						if player:FindFirstChild("RDM") == nil and player.Status.Role.Value ~= "Traitor" then
							local part = Instance.new("IntValue")
							part.Parent = player.Character
							part.Name = "RDMProtection"						
						end
					end)
				end
			end
		end
	end
	if whichplayer then
		local appropriateterm = whichplayer:GetChildren()
		for i = 1, #appropriateterm do
			if appropriateterm[i].Name == "Whizz" and appropriateterm[i]:FindFirstChild("creator") and appropriateterm[i].creator.Value and appropriateterm[i].creator.Value.Name == player.Name then
				appropriateterm[i]:Destroy()
			end
		end
		local instance = Instance.new("IntValue")
		instance.Name = "Whizz"
		if gun and gun:FindFirstChild("Secondary") then
			local bap = Instance.new("IntValue")
			bap.Name = "sub"
			bap.Parent = instance
		end
		instance.Parent = whichplayer

		local butt = Instance.new("ObjectValue")
		butt.Parent = instance 
		butt.Name = "creator"
		butt.Value = player
	end
end)


--[[function clearsurfaceguis(parent)
	for i,v in pairs(parent:GetChildren()) do
		if v:IsA'SurfaceGui' and v.Name~="doych"  then
		v:Destroy()
		end
		clearsurfaceguis(v)
	end
end]]

local function sendvoice(player, voice)
	local players = game.Players:GetPlayers()
	for i = 1, #players do
		if players[i] and players[i]:FindFirstChild("Status") then
			if players[i].Status.Team.Value == "Spectator" and voice.Parent.Name ~= "lockload" or players[i].Status.Team.Value == player.Status.Team.Value and (gt.Value == "TTT" or players[i].Status:FindFirstChild("HasSelectedTeam") == nil) then
				game.ReplicatedStorage.Events.SendVoice:FireClient(players[i], player, voice)
			end
		end
	end
end

game.ReplicatedStorage.Events.SendVoice.OnServerEvent:connect(function(player, voice)
	sendvoice(player, voice)
end)



function drop(pos, weapon)
	local gun = game.ReplicatedStorage.Weapons[weapon]
	if gun and gun:FindFirstChild("Model") then
		if gt.Value ~= "TTT" then
			if gun and gun:FindFirstChild("Equipment2") then
				if game.Workspace:FindFirstChild("C4") then
					return
				end
				game.Workspace.Status.HasBomb.Value = ""
			end
		end

		local gn = gun.Name
		local gun = gun.Model:clone()
		if gt.Value ~= "TTT" then
			drops = drops + 1
		end
		gun.CustomPhysicalProperties = PhysicalProperties.new(2, 1, 1, 1, 1)
		gun.Name = gn
		if gt.Value ~= "TTT" then
			if game.Workspace.Debris:FindFirstChild(gn) and drops >= 10 then
				game.Workspace.Debris[gn]:Destroy()
			end
		end
		gun.Parent = game.Workspace.Debris
		gun.CollisionGroupId = 3
		gun.CanCollide = true
		local bass = gun:GetDescendants()
		for i = 1, #bass do
			if bass[i]:IsA("BasePart") then
				bass[i].CanCollide = true
				bass[i].CollisionGroupId = 3
			end
		end
		gun.Anchored = false

		local dropa = game.ReplicatedStorage.Other.GunDrop:clone()
		dropa.Parent = gun
		dropa.Disabled = false
		local maxsize = math.max(gun.Size.X, gun.Size.Y, gun.Size.Z)
		local torsocframe = pos
	
	--local x,y,z=gun.CFrame:toEulerAnglesXYZ()
		gun.CFrame = torsocframe--*CFrame.Angles(x,y,z)
		if weapon ~= "C4" then
			gun.Anchored = true
		end
	--[[if player and player.Character and player.Character:FindFirstChild("UpperTorso") then
	gun.Velocity=gun.Velocity+player.Character.UpperTorso.Velocity
	end]]
	--if math.random(1,2)==1 then
		if gun.Name == "C4" then
			gun.Velocity = gun.Velocity + Vector3.new(0, 10, 0)
--[[	else
	gun.Velocity = gun.Velocity+(velocity.lookVector * 15) + Vector3.new(0,0,0)
	end]]
			gun.RotVelocity = Vector3.new(10 * math.random(-1, 1), 10 * math.random(-1, 1), 10 * math.random(-1, 1))
		end
	end
end


game.ReplicatedStorage.Events.Drop.OnServerEvent:connect(function(player, gun, velocity, ammo, storedammo, special, owner, prep, ro)
	if gt.Value == "deathmatch" then
		return
	end
	if game.Workspace.Status.Preparation.Value == prep then
	else
		return
	end  
	if game.Workspace.Status.RoundOver.Value == ro then
	else
		return
	end  
	local dent = Instance.new("IntValue")
	dent.Parent = player
	dent.Name = "DROPPED"

	delay(2, function()
		if dent then
			dent:Destroy()
		end
	end)
	if game.ReplicatedStorage.Warmup.Value then
		return
	end
	if gun and gun:FindFirstChild("Model") and player then
		if gun and gun:FindFirstChild("Equipment2") then
			if game.Workspace:FindFirstChild("C4") then
				return
			end
			game.Workspace.Status.HasBomb.Value = ""
		end

		local gn = gun.Name
		local gun = gun.Model:clone()
		gun.Name = gn
	
	
	--local gunowner = owner
		pcall(function()
			local ow = Instance.new("ObjectValue")
			ow.Name = "Owner"
			ow.Value = owner
			ow.Parent = gun
		
			mapskin(gun, owner.SkinFolder[owner.Status.Team.Value.."Folder"][gun.Name].Value)
		end)
		drops = drops + 1
		gun.CustomPhysicalProperties = PhysicalProperties.new(2, 1, 1, 1, 1)
		if game.Workspace.Debris:FindFirstChild(gn) and drops >= 10 then
			game.Workspace.Debris[gn]:Destroy()
		end
		gun.Parent = game.Workspace.Debris
	
		local ownerval = Instance.new("ObjectValue")
		ownerval.Name = "ownerval"
		ownerval.Value = owner
		if special then
			local dent = Instance.new("BoolValue")
			dent.Parent = gun
			dent.Name = "Special"
			dent.Value = special
			if dent.Value == true then
				if gun:FindFirstChild("Silencer2") then
					gun.Silencer2.Transparency = 1
				end
			end
		end
		gun.CollisionGroupId = 3
		gun.CanCollide = true
		local bass = gun:GetChildren()
		for i = 1, #bass do
			if bass[i]:IsA("BasePart") then
				bass[i].CanCollide = true
				bass[i].CollisionGroupId = 3
			end
		end
		gun.Anchored = false
		local dropa = game.ReplicatedStorage.Other.GunDrop:clone()
		dropa.Parent = gun
		dropa.Disabled = false
		local maxsize = math.max(gun.Size.X, gun.Size.Y, gun.Size.Z)
		local torsocframe = velocity * CFrame.new(0, 2, -(maxsize / 2))
	
	--local x,y,z=gun.CFrame:toEulerAnglesXYZ()
		gun.CFrame = torsocframe--*CFrame.Angles(x,y,z)
	--[[if player and player.Character and player.Character:FindFirstChild("UpperTorso") then
	gun.Velocity=gun.Velocity+player.Character.UpperTorso.Velocity
	end]]
	--if math.random(1,2)==1 then
		gun.Velocity = gun.Velocity + (velocity.lookVector * 30) + Vector3.new(0, 30, 0)
--[[	else
	gun.Velocity = gun.Velocity+(velocity.lookVector * 15) + Vector3.new(0,0,0)
	end]]
		gun.RotVelocity = Vector3.new(10 * math.random(-1, 1), 10 * math.random(-1, 1), 10 * math.random(-1, 1))
		if ammo and storedammo then
			local dent = Instance.new("IntValue")
			dent.Parent = gun
			dent.Name = "Ammo"
			dent.Value = ammo
			local dent2 = Instance.new("IntValue")
			dent2.Parent = gun
			dent2.Name = "StoredAmmo"
			dent2.Value = storedammo
		end
	end
end)




game.ReplicatedStorage.Events.PlantC4.OnServerEvent:connect(function(player, position, plantedat)
	if game.Workspace:FindFirstChild("C4") then
		return
	end
	if game.Workspace:FindFirstChild("Map") then
		local canPlant	= false
		
		local ray=Ray.new(player.Character.HumanoidRootPart.Position,Vector3.new(0,-6,0))
		local hit,pos=game.Workspace:FindPartOnRayWithWhitelist(ray,{game.Workspace.Map.SpawnPoints})
		if hit and (hit.Name == "C4Plant" or hit.Name == "C4Plant2") then
			canPlant	= true
		end
		
		if canPlant then
			if plantedat == "B" then
				game.Workspace.Map:WaitForChild("SpawnPoints"):WaitForChild("C4Plant")["Planted"].Value = true
			end
			if plantedat == "A" then
				game.Workspace.Map:WaitForChild("SpawnPoints"):WaitForChild("C4Plant2")["Planted"].Value = true
			end
			if player then
				addcash(player, 300, "+$300: Award for planting the bomb.")
			end
			local c4clone = game.ReplicatedStorage.C4:clone()
			c4clone.Parent = game.Workspace
			c4clone:SetPrimaryPartCFrame(position)
			local ct = Instance.new("ObjectValue")
			ct.Name = "creator"
			ct.Value = player
			ct.Parent = c4clone.Handle
			c4clone.Handle.Script.Disabled = false
			if player and player:FindFirstChild("Status") then
				player.Status.Score.Value = player.Status.Score.Value + 1
				player.Score.Value = player.Score.Value + 1
				player.Status.Score.Reasoning.Value = " for planting the bomb."
			end
		end
	end
end)


--------------------KILLLFEEED OMGGG

-- wtf u hecker de stinki et entfient 

local myModule = require(game.ReplicatedStorage.GetIcon)

local killer2 = nil
local victim2 = nil
local wep = nil
function UpdateKill(killerName, victimName, wep, assister, kColor, vColor, building, yeah, headshot, bang, assist)

	local killfeed =  game.Workspace.KillFeed
	for i = 1, 10, 1 do
		if i < 10 then
			killfeed:findFirstChild(i):findFirstChild("time").Value = killfeed:findFirstChild(i + 1):findFirstChild("time").Value
			killfeed:findFirstChild(i):findFirstChild("Active").Value = killfeed:findFirstChild(i + 1):findFirstChild("Active").Value
			killfeed:findFirstChild(i):findFirstChild("Killer").Value = killfeed:findFirstChild(i + 1):findFirstChild("Killer").Value
			killfeed:findFirstChild(i):findFirstChild("Assist").Value = killfeed:findFirstChild(i + 1):findFirstChild("Assist").Value
			killfeed:findFirstChild(i):findFirstChild("Killer"):findFirstChild("TeamColor").Value = killfeed:findFirstChild(i + 1):findFirstChild("Killer"):findFirstChild("TeamColor").Value
			killfeed:findFirstChild(i):findFirstChild("Victim").Value = killfeed:findFirstChild(i + 1):findFirstChild("Victim").Value
			killfeed:findFirstChild(i):findFirstChild("Victim"):findFirstChild("TeamColor").Value = killfeed:findFirstChild(i + 1):findFirstChild("Victim"):findFirstChild("TeamColor").Value
			killfeed:findFirstChild(i):findFirstChild("Weapon").Value = killfeed:findFirstChild(i + 1):findFirstChild("Weapon").Value
			killfeed:findFirstChild(i):findFirstChild("Weapon").Headshot.Value = killfeed:findFirstChild(i + 1):findFirstChild("Weapon").Headshot.Value
			killfeed:findFirstChild(i):findFirstChild("Weapon").Wallbang.Value = killfeed:findFirstChild(i + 1):findFirstChild("Weapon").Wallbang.Value
		end
	end

--add new data
	killfeed:findFirstChild("10"):findFirstChild("Active").Value = true
	killfeed:findFirstChild("10"):findFirstChild("Victim").Value = victimName
	killfeed:findFirstChild("10"):findFirstChild("time").Value = game.Workspace.DistributedTime.Value
	if vColor then
		killfeed:findFirstChild("10"):findFirstChild("Victim"):findFirstChild("TeamColor").Value = vColor
	else
		killfeed:findFirstChild("10"):findFirstChild("Victim"):findFirstChild("TeamColor").Value = game.Players:findFirstChild(victimName).TeamColor.Color
	end
	if killerName then
		killer2 = game.Players:FindFirstChild(killerName)
		if victimName then
			victim2 = game.Players:FindFirstChild(victimName)
		end
		if killerName == victimName then
			assist = ""
		end
		if assist then
			killfeed:findFirstChild("10"):findFirstChild("Assist").Value = assist
		else
			killfeed:findFirstChild("10"):findFirstChild("Assist").Value = ""
		end		
		if game.Players:FindFirstChild(assist) and game.Players:FindFirstChild(assist):FindFirstChild("Status") then
			----award him for assists
			game.Players:FindFirstChild(assist).Status.Assists.Value = game.Players:FindFirstChild(assist).Status.Assists.Value + 1
		end
		

		if victim2 or building then
		--
			if killer2 or building then
			
			---	

			
				if headshot then
					killfeed:findFirstChild("10"):findFirstChild("Weapon").Headshot.Value = "true"
				else
					killfeed:findFirstChild("10"):findFirstChild("Weapon").Headshot.Value = "false"			
				end
				if bang then
					killfeed:findFirstChild("10"):findFirstChild("Weapon").Wallbang.Value = "true"
				else
					killfeed:findFirstChild("10"):findFirstChild("Weapon").Wallbang.Value = "false"			
				end
				killfeed:findFirstChild("10"):findFirstChild("Killer").Value = killerName
				if killerName == victimName then
					killfeed:findFirstChild("10"):findFirstChild("Killer").Value = ""
				end

					
					
				if kColor then
					killfeed:findFirstChild("10"):findFirstChild("Killer"):findFirstChild("TeamColor").Value = kColor
				else
					killfeed:findFirstChild("10"):findFirstChild("Killer"):findFirstChild("TeamColor").Value = game.Players:findFirstChild(killerName).TeamColor.Color
				end
						
			end
		end
	end
	if wep ~= "" then
		killfeed:findFirstChild("10"):findFirstChild("Weapon").Value = wep
	else

	end
	local ta = Instance.new("NumberValue")
	delay(0.25, function()
		ta:Destroy()
	end)
	ta.Parent = killfeed
end

local function clearFeed()
	local killfeed = game.Workspace.KillFeed
	for i = 1, #killfeed:GetChildren() do
		local v = killfeed:GetChildren()[i]
		for a = 1, #v:GetChildren() do
			local q = v:GetChildren()[i]
			if q.className == "BoolValue" then
				q.Value = false
			elseif q.className == "StringValue" then
				q.Value = ""
			end
		end
	end
end
--add degeneration to tag, "finished off" and crap
GetName = require(game.ReplicatedStorage.GetTrueName)
local function onHumanoidDied(humanoid, player)
	local killer = getKillerOfHumanoidIfStillInGame(humanoid)
	local assister = ""
	if killer and humanoid then
		local tag = humanoid:findFirstChild("creator")
		if tag and tag:FindFirstChild("NameTag") then --assist?
			wep = myModule.getWeaponOfKiller(tag.NameTag.Value)
		end
		local killerName = killer.Name
		local victimName = player.Name
		if killer and player then
			if player:FindFirstChild("Damaged") and player.Damaged.Value ~= killer.Name and game.Players:FindFirstChild(player.Damaged.Value) then
				local teammate = game.Players:FindFirstChild(player.Damaged.Value)
				if teammate and teammate.Character and teammate.Character:FindFirstChild("Humanoid") and teammate.Character.Humanoid.Health > 0 then
					local string1 = "** You just saved "..teammate.Name.." by killing "..player.Name.."! **"
					local string2 = "** "..killer.Name.." just saved you by killing "..player.Name.."! **"
					game.ReplicatedStorage.Events.SendMsg:FireClient(killer, string1, Color3.new(0, 210 / 255, 0))
					game.ReplicatedStorage.Events.SendMsg:FireClient(teammate, string2, Color3.new(0, 210 / 255, 0))
				end
			end
		end
		if game.ReplicatedStorage.Weapons:FindFirstChild(tag.NameTag.Value) and game.ReplicatedStorage.Weapons[tag.NameTag.Value].KillAward.Value > 0 then
			local cashadded = game.ReplicatedStorage.Weapons[tag.NameTag.Value].KillAward.Value
			if gametype.Value == "competitive" then
				if game.ReplicatedStorage.Weapons[tag.NameTag.Value]:FindFirstChild("Grenade") then
					cashadded = cashadded * 3
				else
					cashadded = cashadded * 2
				end
			end
			if gt.Value ~= "deathmatch" and gt.Value ~= "TTT" then
				if killer and player and killer.Name ~= player.Name then
					killer.Status.Score.Value = killer.Status.Score.Value + 1
				else
					cashadded = 0
				end
			else
				if gt.Value == "deathmatch" then
					if game.ReplicatedStorage.Weapons:FindFirstChild(tag.NameTag.Value) then
						killer.Status.Score.Value = killer.Status.Score.Value + game.ReplicatedStorage.Weapons:FindFirstChild(tag.NameTag.Value).PointsAward.Value
					end
				end
			end
			if player and player.Status.Team.Value ~= "Spectator" and player.Status.Team.Value ~= "Terrorist" and killer and killer.TeamColor == player.TeamColor and killer.Name ~= player.Name then
				if gt.Value ~= "deathmatch" then
					
				
					killer.Score.Value = killer.Score.Value - 1
					killer.Status.Kills.Value = killer.Status.Kills.Value - 1
					removecash(killer, 300, "-$300: Lost by killing a teammate.")
					killer.TeamKills.Value = killer.TeamKills.Value + 1
					if killer.TeamKills.Value == 1 then
						game.ReplicatedStorage.Events.SendMsg:FireClient(killer, "WARNING: Avoid teamkilling! Killing two more teammates will ban you from the server!", Color3.new(210 / 255, 0, 0))
					elseif killer.TeamKills.Value == 2 then
						game.ReplicatedStorage.Events.SendMsg:FireClient(killer, "WARNING: Avoid teamkilling! Killing one more teammate will ban you from the server!", Color3.new(210 / 255, 0, 0))
					end
					spawn(function()
						if killer.TeamKills.Value >= 3 then
							game.ReplicatedStorage.Events.SendMsg:FireAllClients(killer.Name.." has been kicked for killing too many teammates.", Color3.new(210 / 255, 0, 0))
							local ban = Instance.new("StringValue")
							ban.Parent = game.ServerStorage.Banned
							ban.Name = killer.Name	
							killer:Kick("You have been kicked for killing too many teammates.")
						end
					end)
				end
			else
				if killer and player and killer.Name ~= player.Name then
					if gt.Value ~= "TTT" and gt.Value ~= "deathmatch" then
						killer.Score.Value = killer.Score.Value + 1	
						if tag and tag:FindFirstChild("HEADSHOT") then
							killer.Score.Value = killer.Score.Value + 1
						end
					end
					killer.Status.Kills.Value = killer.Status.Kills.Value + 1
				end
			end
			if killer and player and killer.Name ~= player.Name then
				if killer and killer:FindFirstChild("Additionals") then
					killer.Additionals.OverallKills.Value = killer.Additionals.OverallKills.Value + 1
					if game.Workspace.FunFacts["First Blood"].Value == "" then
						local timetaken = roundtime - game.Workspace.Status.Timer.Value
						game.Workspace.FunFacts["First Blood"].Value = timetaken.." seconds into the round, "..killer.Name.." got the first kill."
						game.Workspace.FunFacts["First Blood"].Priority.Value = (60 - timetaken) / 10
					end
					if humanoid and humanoid.Parent and humanoid.Parent:FindFirstChild("Multimeter") then
						killer.Additionals.StoppedBombDefuser.Value = true
					end
					local ppls, T, CT = peoplealive()
					if killer:FindFirstChild("Status") then
						if killer.Status.Team.Value == "CT" and CT <= 1 or killer.Status.Team.Value == "T" and T <= 1 then
							killer.Additionals.ONEANDONLYKILLS.Value = killer.Additionals.ONEANDONLYKILLS.Value + 1
						end
					end
					if humanoid and humanoid:FindFirstChild("creator") then
						if humanoid.creator:FindFirstChild("HEADSHOT") then
							killer.Additionals.HeadshotKills.Value = killer.Additionals.HeadshotKills.Value + 1
						end
						local nametag = ""
						if humanoid.creator:FindFirstChild("NameTag") then
							nametag = humanoid.creator.NameTag.Value
						end
						if game.ReplicatedStorage.Weapons:FindFirstChild(nametag) and game.ReplicatedStorage.Weapons[nametag]:FindFirstChild("Melee") then
							killer.Additionals.KnifeKills.Value = killer.Additionals.KnifeKills.Value + 1
						end
					end
				end
			end
			if gt.Value ~= "TTT" and player and player:FindFirstChild("Status") then
				player.Status.Deaths.Value = player.Status.Deaths.Value + 1
			end
			if player and killer and killer.TeamColor == player.TeamColor then
			else
				addcash(killer, cashadded, "+$"..cashadded..": Award for neutralizing an enemy with the "..GetName.getName(tag.NameTag.Value)..".")
			end
		end
		if humanoid:FindFirstChild("Assist") then
			assister = humanoid.Assist.Value
			if assister == killer.Name then
				assister = ""
			end
		end
		if gt.Value == "TTT" then
			if killer.Status.Role.Value == "Innocent" then
				game.ReplicatedStorage.Events.SendMsg:FireClient(player, "You were killed by "..killer.Name..", they were an innocent!")
			else
				game.ReplicatedStorage.Events.SendMsg:FireClient(player, "You were killed by "..killer.Name..", they were a "..string.lower(killer.Status.Role.Value).."!")
			end
			return
		end
		if humanoid and humanoid:FindFirstChild("creator") and humanoid.creator.Value then
			if humanoid:FindFirstChild("creator") and humanoid.creator:FindFirstChild("WALLBANG") then
				if humanoid:FindFirstChild("creator") and humanoid.creator:FindFirstChild("HEADSHOT") then
					UpdateKill(killerName, victimName, wep, nil, false, false, false, false, true, true, assister)
				else
					UpdateKill(killerName, victimName, wep, nil, false, false, false, false, false, true, assister)
				end
			else
				if humanoid:FindFirstChild("creator") and humanoid.creator:FindFirstChild("HEADSHOT") then
					UpdateKill(killerName, victimName, wep, nil, false, false, false, false, true, false, assister)
				else
					UpdateKill(killerName, victimName, wep, nil, false, false, false, false, false, false, assister)
				end
			end
		end
	end
end









----------------END OF KILLFEED YAAAASSSS

function game.ReplicatedStorage.Functions.GetPlayerSettings.OnServerInvoke(p)
	local path = game.ServerStorage.PlayerData:WaitForChild(tostring(p))
	wait()
	local data2send = {
		path.Settings.LowViolence.Value,
		path.Settings.LowQuality.Value,
		path.Settings.MusicVolume.Value,
		path.Settings.AltCrouch.Value,	
		path.Settings.FOV.Value
	}
	return data2send
end


local hammerunit2stud = 0.0694


getprices = require(game.ReplicatedStorage.GetPrices)
game.ReplicatedStorage.Events.RemoteEvent.OnServerEvent:connect(function(player, args)
	if args[1] == "createparticle" then
		local players = game.Players:GetPlayers()
		for i = 1, #players do
			if players[i].Name ~= player.Name and players[i]:FindFirstChild("Status") and (gt.Value == "TTT" or players[i].Status:FindFirstChild("HasSelectedTeam") == nil) then
				game.ReplicatedStorage.Events.RemoteEvent:FireClient(players[i], args)
			end
		end
	elseif args[1] == "buyweapon" then
		local item = args[2]
	--print("buyweapon fired" .. args[2]	)
		local price = getprices.getprice(item)
		if player.Cash.Value >= price and player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			if player and player:FindFirstChild("Additionals") then
				player.Additionals.BoughtItems.Value = player.Additionals.BoughtItems.Value + 1
				player.Additionals.MoneySpent.Value = player.Additionals.MoneySpent.Value + price
			end
		--DEVROLVE MAKE IT EQUIP O_O_O_O_O_O
			local helmetbought = false
			local kevlarbought = false
			if player and player:FindFirstChild("Kevlar") and player.Kevlar.Value >= 100 then
			else
				kevlarbought = true
			end
			if player and player:FindFirstChild("Helmet") then
			else
				helmetbought = true
			end
			if args[2] == "Kevlar Vest" then
				if kevlarbought == true then
					createkevlar(player)
				end
			end
			if args[2] == "Kevlar + Helmet" then
				price = 0
				if kevlarbought == true then
					price = price + 650
					createkevlar(player)
				end
				if helmetbought == true then
					price = price + 350
					createhelmet(player)
				end
				if price == 0 then
					price = 1000
				end
			end
			if args[2] == "Defuse Kit" and player:FindFirstChild("DefuseKit") == nil then
				local shit = Instance.new("IntValue")
				shit.Parent = player 
				shit.Name = "DefuseKit"
				if player:FindFirstChild("DefuseKit") and player and player.Character then
					local defusekit = game.ReplicatedStorage.CharacterModels.DefuseKit:clone()
					defusekit.Parent = player.Character
					defusekit.Name = "DKit"
				end
			end
			if not game:GetService("RunService"):IsStudio() then
				player.Cash.Value = player.Cash.Value - price
			end
		end
	end
end)

game.ReplicatedStorage.Events.CreateMuzzle.OnServerEvent:connect(function(player, gun)
	if gun and player and player.Character then
		if gun:FindFirstChild("Equipment") == nil or gun:FindFirstChild("Equipment") and gun.Equipment:FindFirstChild("Silenced") == nil then
			if player.Character and player.Character:FindFirstChild("Gun") then
				local muzzle5 = player.Character.Gun.Muzzle
				muzzle5.Enabled = true
				delay(0.04, function()
					muzzle5.Enabled = false
				end)
			end
		end
	end
end)

game.ReplicatedStorage.Events.PlayVoice.OnServerEvent:connect(function(player, sound, soundid)
	if sound and sound.className == "Sound" and soundid then
		sound:Stop()
		sound.SoundId = soundid
		sound:Play()
	end
end)

local Ignore_Model = game.Workspace["Ray_Ignore"]

local necko = CFrame.new(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0)
local armo1 = CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
local armo2 = CFrame.new(-1, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)

--THIS SCRIPT UTILISES ALL SERVER SCRIPTING
local Ray_Ignore = game.Workspace:WaitForChild("Ray_Ignore")

local function PlaySound(sound)
	if sound and sound.className and sound.className == "Sound" then
		sound.PlayOnRemove = true
		sound:Destroy()
	end
end


game.ReplicatedStorage.Events.DestroyObject.OnServerEvent:connect(function(player, gun)
	if gun and game.ReplicatedStorage.Weapons:FindFirstChild(gun.Name) and gun:IsDescendantOf(game.Workspace.Debris) then
		gun:Destroy()
	end
end)

local hnng = false
--[[workspace:WaitForChild("SpectatorBox"):WaitForChild("Bagel").Touched:Connect(function(h) 
	if h.Parent:FindFirstChild("Humanoid") and hnng == false then
		hnng = true
		if game.Players:FindFirstChild(tostring(h.Parent)) then
			loadcharacter(game.Players:FindFirstChild(tostring(h.Parent)))
		end
		wait(.5)
		hnng=false
	end
end)]]


game.ReplicatedStorage.Events.PickUp.OnServerEvent:connect(function(player, gun)
	if gun and gun:IsDescendantOf(game.Workspace.Debris) and game.ReplicatedStorage.Weapons:FindFirstChild(gun.Name) then
		if gun:FindFirstChild("PickedUp") == nil then
			if game.ReplicatedStorage.Weapons[gun.Name]:FindFirstChild("Equipment2") then
				game.Workspace.Status.HasBomb.Value = player.Name
			end
			local int = Instance.new("ObjectValue")
			int.Parent = gun
			int.Name = "PickedUp"
			int.Value = player
			delay(2, function()
				int:Destroy()
			end)
		end
	end
end)


game.ReplicatedStorage.Events.SetCNil.OnServerEvent:connect(function(player)
	if player and player.Character and player.Status.Alive.Value == false then
		player.Character = nil
	end
end)
function addvelocitytobb(Hit, veloc)
	local instance = Instance.new("BodyVelocity")
	instance.Parent = Hit
	instance.Velocity = Hit.Velocity + veloc
		--instance.RotVelocity=Vector3.new(math.random(-10,10),math.random(-10,10),math.random(-10,10)).unit*veloc
	instance.P = 1500
	instance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	delay(.1, function()
		instance:Destroy()
	end)	
end
--Handle shattering parts

function createTriangle(a, b, c, template, depth)
	depth = 0.15
	local edges = {
		{
			longest = (c - b),
			other = (a - b),
			position = b
		},
		{
			longest = (a - c),
			other = (b - c),
			position = c
		},
		{
			longest = (b - a),
			other = (c - a),
			position = a
		}
	}
	table.sort(edges, function(a, b)
		return a.longest.magnitude > b.longest.magnitude
	end)
	local edge = edges[1]
	-- get angle between two vectors
	local theta = math.acos(edge.longest.unit:Dot(edge.other.unit)) -- angle between two vectors
	-- SOHCAHTOA
	local s1 = Vector2.new(edge.other.magnitude * math.cos(theta), edge.other.magnitude * math.sin(theta))
	local s2 = Vector2.new(edge.longest.magnitude - s1.x, s1.y)
	-- positions
	local p1 = edge.position + edge.other * 0.5 -- wedge1's position
	local p2 = edge.position + edge.longest + (edge.other - edge.longest) * 0.5 -- wedge2's position
	-- rotation matrix facing directions
	local right = edge.longest:Cross(edge.other).unit
	local up = right:Cross(edge.longest).unit
	local back = edge.longest.unit
	-- put together the cframes
	local cf1 = CFrame.new( -- wedge1 cframe
		p1.x, p1.y, p1.z,
		-right.x, up.x, back.x,
		-right.y, up.y, back.y,
		-right.z, up.z, back.z
	)
	local cf2 = CFrame.new( -- wedge2 cframe
		p2.x, p2.y, p2.z,
		right.x, up.x, -back.x,
		right.y, up.y, -back.y,
		right.z, up.z, -back.z
	)
	-- put it all together by creating the wedges
	local w1 = template:Clone()
	local w2 = template:Clone()
	w1.Size = Vector3.new(depth, s1.y, s1.x)
	w2.Size = Vector3.new(depth, s2.y, s2.x)
	w1.CFrame = cf1
	w2.CFrame = cf2
	w1.Anchored = false
	w2.Anchored = false
	return {
		w1,
		w2
	}
end

function getThinAxis(part)
	local vals = {
		part.Size.X,
		part.Size.Y,
		part.Size.Z
	}
	local lowest = math.min(vals[1], vals[2], vals[3])
	
	local axis
	if lowest == vals[1] then
		axis = 1
	end
	if lowest == vals[2] then
		axis = 2
	end
	if lowest == vals[3] then
		axis = 3
	end
	
	return axis, lowest
end

function getPoints(part)
	
	local thinAxis = getThinAxis(part)
	
	local width, height, depth = part.Size.X / 2, part.Size.Y / 2, part.Size.Z / 2
	
	local up = CFrame.new(0, height, 0)
	local down = CFrame.new(0, -height, 0)
	local left = CFrame.new(-width, 0, 0)
	local right = CFrame.new(width, 0, 0)
	local front = CFrame.new(0, 0, -depth)
	local back = CFrame.new(0, 0, depth)
	

	if thinAxis == 1 then
		--X is small, get points on Y and Z	
		local tab = {
			part.CFrame * up * front,
			part.CFrame * down * front,
			part.CFrame * down * back,
			part.CFrame * up * back,
		}
		if part:IsA("WedgePart") then
			table.remove(tab, 1)
		end

		return tab
	elseif thinAxis == 2 then
		--Y is small, get points on X and Z	
		local tab = {
			part.CFrame * front * right,
			part.CFrame * back * right,
			part.CFrame * back * left,
			part.CFrame * front * left,
		}

		return tab
	elseif thinAxis == 3 then
		--Z is small, get points on X and Y	
		local tab = {
			part.CFrame * up * right,
			part.CFrame * down * right,
			part.CFrame * down * left,
			part.CFrame * up * left,
		}

		return tab
	end
	
end

function getShatterPoint(part, impactPosition)
	local function shouldReverseDirection(dir, depth)
		local rev = dir * -1
		
		local checkNormal = CFrame.new(impactPosition, impactPosition + dir).p
		local checkReversed = CFrame.new(impactPosition, impactPosition + rev).p
		
		local difNormal = checkNormal - part.CFrame.p
		local difReversed = checkReversed - part.CFrame.p
		
		local distNormal = (difNormal.X ^ 2) + (difNormal.Y ^ 2) + (difNormal.Z ^ 2)
		local distReversed = (difReversed.X ^ 2) + (difReversed.Y ^ 2) + (difReversed.Z ^ 2)
		
		if distNormal < distReversed then
			return false
		else
			return true
		end
	end

	local thinAxis, depth = getThinAxis(part)
	
	local direction
	if thinAxis == 1 then
		direction = part.CFrame.rightVector
	end
	if thinAxis == 2 then
		direction = part.CFrame.upVector
	end
	if thinAxis == 3 then
		direction = part.CFrame.lookVector
	end
	
	if shouldReverseDirection(direction, depth) then
		direction = direction * -1
	end
	
	local pointing = CFrame.new(impactPosition, impactPosition + direction)
	local cf = pointing * CFrame.new(0, 0, -depth / 2)
	

	
	return cf.p, direction
end

function shatter(part, impactPosition, force)
	local origcf = part.CFrame
	local size = math.min(part.Size.X, part.Size.Y, part.Size.Z)
	local ind
	if size == part.Size.X then
		ind = "x"
	elseif size == part.Size.Y then
		ind = "y"
	elseif size == part.Size.Z then
		ind = "z"
	end
	if ind == "x" then
		part.Size = Vector3.new(0.05, part.Size.Y, part.Size.Z)
	elseif ind == "y" then
		part.Size = Vector3.new(part.Size.X, 0.05, part.Size.Z)
	elseif ind == "z" then
		part.Size = Vector3.new(part.Size.X, part.Size.Y, 0.05)
	end
	part.CFrame = origcf
	local verts = getPoints(part)	
	local shatterPoint, direction = getShatterPoint(part, impactPosition)
	
	local template = Instance.new("WedgePart")
	template.Transparency = part.Transparency
	template.TopSurface = Enum.SurfaceType.Smooth
	template.BottomSurface = Enum.SurfaceType.Smooth
	template.BrickColor = part.BrickColor
	local canShatter = Instance.new("BoolValue")
	canShatter.Name = "canShatter"
	canShatter.Parent = template
	
	local thin, partDepth = getThinAxis(part)
	
	
	local tris = {}
	if #verts == 4 then
		tris = {
			{
				verts[1],
				verts[2],
				shatterPoint
			},
			{
				verts[2],
				verts[3],
				shatterPoint
			},
			{
				verts[3],
				verts[4],
				shatterPoint
			},
			{
				verts[4],
				verts[1],
				shatterPoint
			}
		}
	else
		tris = {
			{
				verts[1],
				verts[2],
				shatterPoint
			},
			{
				verts[2],
				verts[3],
				shatterPoint
			},
			{
				verts[3],
				verts[1],
				shatterPoint
			},
		}
	end
	
	local triParts = {}
	
	for i = 1, #tris do
		local t = createTriangle(
			tris[i][1].p,
			tris[i][2].p,
			tris[i][3],
			template,
			partDepth
		)
		table.insert(triParts, t)
	end
	
	local par = game.Workspace["Ray_Ignore"]
	for i = 1, #triParts do
		for p = 1, #triParts[i] do
			local prt = triParts[i][p]
			prt.Parent = par
			prt.CollisionGroupId = 4
			addvelocitytobb(prt, force + Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5)))
			prt.Transparency = part.Transparency
			prt.Reflectance = part.Reflectance
			prt.Material = Enum.Material.Glass
			prt.CanCollide = true
			delay(1, function()
				prt:Destroy()
			end)
		end
	end
	part.Transparency = 1
	part:Destroy()	
end



-----so much shit for glass shattering holy moly aaaaaaaaa



game.ReplicatedStorage.Events.Hit.OnServerEvent:connect(function(player, Hit, Pos, gunname, range, worldgun, flek, Pos12, dmgmod, held2, penetration, startpos, dt, normal)
	if player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Head") then
	else
		return
	end
	if player and player.Character and player.Character:FindFirstChild("ForceField") then
		player.Character.ForceField:Destroy()
	end
	if Hit and Hit:FindFirstChild("HitNoise") then
		Hit.HitNoise:Play()
	end
	if Hit and game.Workspace.Map.Regen:FindFirstChild("Glasses") and Hit:IsDescendantOf(game.Workspace.Map.Regen.Glasses) then
		local idiot = game.ReplicatedStorage.Sounds.Glass:clone()
		idiot.Parent = Hit
		idiot.PlaybackSpeed = math.random(80, 120) / 100
		idiot.PlayOnRemove = true
		idiot:Destroy()	
		if player and player.Character and player.Character:FindFirstChild("Head") then
			shatter(Hit, Pos, player.Character.Head.CFrame.lookVector.unit * game.ReplicatedStorage.Weapons[gunname].DMG.Value)
		end
	end
	if Hit and Hit.Name == "BreakableMetal" then
		Hit:Destroy()
	end
	if Hit and Hit.Name == "Vent" then
		Hit.Anchored = false
		Hit.CanCollide = true
		Hit.CollisionGroupId = 3
	end
	if Hit and Hit.Name == "BreakMeBaby" then
		if Hit.Parent.Name == "MarketWindow" then
			local www = game.ReplicatedStorage.Destruction.MarketWin:Clone()
			www.Parent = workspace.Debris
			for i, v in ipairs (Hit.Parent:GetChildren()) do
				v.Anchored = false
				v.CanCollide = false
			end
			for i, v in ipairs (www:GetChildren()) do
				v.CollisionGroupId = 3
				delay(math.random(4, 12), function()
					v:Destroy()
				end)
			end
			
		end
		return
	end
	if Hit and Hit:IsDescendantOf(game.Workspace.Map.Regen.Props) and Hit.Transparency == 0 then
		local velocity = (player.Character.Head.CFrame.lookVector.unit * (game.ReplicatedStorage.Weapons[gunname].DMG.Value))
		if game.ReplicatedStorage.PropFragments:FindFirstChild(Hit.Name) then
			local POOP = game.ReplicatedStorage.PropFragments:FindFirstChild(Hit.Name):clone()
			local dab = POOP:GetDescendants()
			for i = 1, #dab do
				if dab[i]:IsA("BasePart") then
					dab[i].Anchored = false
					dab[i].CanCollide = true
					dab[i].CollisionGroupId = 4
					dab[i].CFrame = Hit.CFrame
					if dab[i].Name == "Fragment" then
						addvelocitytobb(dab[i], velocity + Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5)))
						local fish = dab[i]
						delay(3, function()
							game:GetService("TweenService"):Create(fish, TweenInfo.new(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
								Transparency = 1
							}):Play()
						end)
					elseif dab[i].Name == "Particle" then
						dab[i].Anchored = true
						dab[i].CanCollide = false					
					end
					
				elseif dab[i]:IsA("ParticleEmitter") then
					if dab[i]:FindFirstChild("EmitCount") then
						dab[i]:Emit(dab[i].EmitCount.Value)
					else
						dab[i]:Emit(dab[i].Rate)
					end
				end
			end
			POOP.Name = "Fragment"
			POOP.Parent = game.Workspace["Ray_Ignore"]
			delay(3.6, function()
				POOP:Destroy()
			end)
			if POOP:FindFirstChild("BreakSound") then
				local sc = POOP.BreakSound:clone()
				sc.Parent = Hit
				sc.PlayOnRemove = true
			end
			Hit:Destroy()
		else
			addvelocitytobb(Hit, velocity)
		end
		return
	end
	if Pos == false then
		return
	end	

	local dealminimum = false	
	--[[if player and player:FindFirstChild("Ping") and (game.Workspace.DistributedTime.Value-dt)>=11 then
		game.ReplicatedStorage.Events.Debug:FireClient(player,"HIT_DEBUG: didn't register because ping is too high (>=1100)")
		return
	end]]
	
	if player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("Head") then
	else
		game.ReplicatedStorage.Events.Debug:FireClient(player, "HIT_DEBUG: didn't register damage because you died before it could")
		dealminimum = true
		if game.Workspace.Status.Killtrade.Value == false then
			return
		end
	end
	local damagedone = false
	shots = shots + 1
	if shots > 1 then
		game.Workspace.FunFacts["Shots were fired"].Value = shots.." shots were fired that round."
	end
	local funky = false

	
	local gun = game.ReplicatedStorage.Weapons:FindFirstChild(gunname)
	local Humanoid = nil
	local MyPlayer = player
	
	if Hit then
		if Hit and Hit.Parent and Hit.Parent:FindFirstChild("Humanoid") then
			Humanoid = Hit.Parent.Humanoid
			local stabbing = false
			if gun and gun:FindFirstChild("Melee") and held2 == true then
				stabbing = true
			end
				
			if Humanoid and Humanoid.Parent:FindFirstChild("UpperTorso") and MyPlayer and startpos then
				local hitPlayer = game.Players:GetPlayerFromCharacter(Humanoid.Parent)
				if gt.Value ~= "TTT" then
					if hitPlayer and hitPlayer:FindFirstChild("Status")  then
						if hitPlayer:FindFirstChild("Status").Team.Value == MyPlayer.Status.Team.Value and teamdamage == false  then
							return
						end
					end
				end			
				game.ReplicatedStorage.Events.HatObject:FireAllClients(Hit, Pos, normal, gun, stabbing, player.Name, player.Character.Head.Position)
				local backstab = false
				if Hit and Hit.Parent:FindFirstChild("HumanoidRootPart") and gun:FindFirstChild("Melee") then
					local mt = player.Character.HumanoidRootPart
					local et = Hit.Parent.HumanoidRootPart
					local v1 = (Vector3.new(et.Position.X, 0, et.Position.Z) - Vector3.new(mt.Position.X, 0, mt.Position.Z)).unit
					if v1:Dot(et.CFrame.lookVector.unit) > math.cos(math.rad(180 / 2)) then
						backstab = true
					end
				end		
				if Humanoid:FindFirstChild("creator") then
					Humanoid.creator:Destroy()
				end
				damagedone = true
				local c = Instance.new("ObjectValue")
				c.Name = "creator"
				c.Value = MyPlayer
				delay(1, function()
					c:Destroy()
				end)
				c.Parent = Humanoid
				local piece = Instance.new("StringValue")
				piece.Parent = c
				piece.Name = "NameTag"
				piece.Value = gunname
				if penetration and penetration == true then
					local piece2 = Instance.new("StringValue")
					piece2.Parent = c
					piece2.Name = "WALLBANG"
				end
				if game.ReplicatedStorage.Weapons:FindFirstChild(gunname) and game.ReplicatedStorage.Weapons:FindFirstChild(gunname):FindFirstChild("Equipment") and game.ReplicatedStorage.Weapons:FindFirstChild(gunname).Equipment:FindFirstChild("Silenced") then
					local piece = Instance.new("StringValue")
					piece.Parent = c
					piece.Name = "Silenced"
					piece.Value = gunname		
				end
				local rangemod = gun.RangeModifier.Value
				if player and player.Character and player.Character:FindFirstChild("Gun") and player.Character.Gun:FindFirstChild("Silencer2") and player.Character.Gun.Silencer2.Transparency == 1 then
					rangemod = math.min(100, rangemod + 10)
				end
								
				rangemod = rangemod / 100
				local distance = (Humanoid.Parent.HumanoidRootPart.Position - startpos).magnitude
				local DistanceFallOff = math.clamp(rangemod ^ (distance / (500 * hammerunit2stud)), 0.45, 1)
				local basedamage=gun.DMG.Value
				if player.Status.Team.Value=="T" and gt.Value=="juggernaut" then
					basedamage=basedamage*3 --critical hits as jugg
				end
				if Hit.Name == "Head" or Hit.Name == "FakeHead" or Hit.Name == "HeadHB" or Hit.Parent.className == "Accessory" or Hit.Parent.className == "Hat" then
					if gun and gun:FindFirstChild("Melee") == nil and gt.Value~="juggernaut" then
						dmgmod = dmgmod * 4
					end
					local DIDDAMAGE = (basedamage) * dmgmod
					if backstab == true then
						DIDDAMAGE = 90
					end
					if stabbing == true then
						DIDDAMAGE = 65
						if backstab == true then
							DIDDAMAGE = 180
						end
					end
					local piece2 = Instance.new("StringValue")
					piece2.Parent = c
					piece2.Name = "Flinch"
					if gun:FindFirstChild("Melee") == nil then
						local piece2 = Instance.new("StringValue")
						piece2.Parent = c
						piece2.Name = "HEADSHOT"
					end
					dmgmodule.takeDamage(MyPlayer, Humanoid, math.max(DIDDAMAGE * gun.MinDmg.Value, (DIDDAMAGE) * DistanceFallOff), gun, true, false, dealminimum)

				elseif Hit.Name == "RightFoot" or Hit.Name == "RightLowerLeg" or Hit.Name == "RightUpperLeg" then
					if gun and gun:FindFirstChild("Melee") == nil then
						dmgmod = dmgmod * 0.75
					end
					local DIDDAMAGE = (gun.DMG.Value) * dmgmod
					if backstab == true then
						DIDDAMAGE = 90
					end
					if stabbing == true then
						DIDDAMAGE = 65
						if backstab == true then
							DIDDAMAGE = 180
						end
					end

					dmgmodule.takeDamage(MyPlayer, Humanoid, math.max(DIDDAMAGE * gun.MinDmg.Value, gun.MinDmg.Value, (DIDDAMAGE) * DistanceFallOff), gun, false, true, dealminimum)
				elseif Hit.Name == "LeftFoot" or Hit.Name == "LeftLowerLeg" or Hit.Name == "LeftUpperLeg" then
					if gun and gun:FindFirstChild("Melee") == nil then
						dmgmod = dmgmod * 0.75
					end
					local DIDDAMAGE = (basedamage) * dmgmod
					if backstab == true then
						DIDDAMAGE = 90
					end
					if stabbing == true then
						DIDDAMAGE = 65
						if backstab == true then
							DIDDAMAGE = 180
						end
					end
					dmgmodule.takeDamage(MyPlayer, Humanoid, math.max(DIDDAMAGE * gun.MinDmg.Value, gun.MinDmg.Value, (DIDDAMAGE) * DistanceFallOff), gun, false, true, dealminimum)
				elseif Hit.Name == "RightHand" or Hit.Name == "RightLowerArm" or Hit.Name == "RightUpperArm" then
					local DIDDAMAGE = (basedamage) * dmgmod
					if backstab == true then
						DIDDAMAGE = 90
					end
					if stabbing == true then
						DIDDAMAGE = 65
						if backstab == true then
							DIDDAMAGE = 180
						end
					end
					local piece2 = Instance.new("StringValue")
					piece2.Parent = c
					piece2.Name = "Flinch"
					dmgmodule.takeDamage(MyPlayer, Humanoid, math.max(DIDDAMAGE * gun.MinDmg.Value, gun.MinDmg.Value, (DIDDAMAGE) * DistanceFallOff), gun, false, false, dealminimum)
				elseif Hit.Name == "LeftHand" or Hit.Name == "LeftLowerArm" or Hit.Name == "LeftUpperArm" then
					local DIDDAMAGE = (basedamage) * dmgmod
					if backstab == true then
						DIDDAMAGE = 90
					end
					if stabbing == true then
						DIDDAMAGE = 65
						if backstab == true then
							DIDDAMAGE = 180
						end
					end
					local piece2 = Instance.new("StringValue")
					piece2.Parent = c
					piece2.Name = "Flinch"
					dmgmodule.takeDamage(MyPlayer, Humanoid, math.max(DIDDAMAGE * gun.MinDmg.Value, gun.MinDmg.Value, (DIDDAMAGE) * DistanceFallOff), gun, false, false, dealminimum)
				elseif Hit.Name == "LowerTorso" then
					if gun and gun:FindFirstChild("Melee") == nil then
						dmgmod = dmgmod * 1.25
					end
					local DIDDAMAGE = (basedamage) * dmgmod
					if backstab == true then
						DIDDAMAGE = 90
					end
					if stabbing == true then
						DIDDAMAGE = 65
						if backstab == true then
							DIDDAMAGE = 180
						end
					end
					local piece2 = Instance.new("StringValue")
					piece2.Parent = c
					piece2.Name = "Flinch"
					dmgmodule.takeDamage(MyPlayer, Humanoid, math.max(DIDDAMAGE * gun.MinDmg.Value, gun.MinDmg.Value, (DIDDAMAGE) * DistanceFallOff), gun, false, false, dealminimum)
				else
					local DIDDAMAGE = (basedamage) * dmgmod
					if backstab == true then
						DIDDAMAGE = 90
					end
					if stabbing == true then
						DIDDAMAGE = 65
						if backstab == true then
							DIDDAMAGE = 180
						end
					end
					local piece2 = Instance.new("StringValue")
					piece2.Parent = c
					piece2.Name = "Flinch"
					dmgmodule.takeDamage(MyPlayer, Humanoid, math.max(DIDDAMAGE * gun.MinDmg.Value, gun.MinDmg.Value, (DIDDAMAGE) * DistanceFallOff), gun, false, false, false)
						
				end
			end
		elseif Hit then
			if Hit and Hit.Parent and Hit.Parent:FindFirstChild("HumanoidRootPart") and Hit.Parent.Name == "Door" and Hit.Name == "HumanoidRootPart" and Hit.Parent:FindFirstChild("Invincible") == nil then
				if Hit.Parent:FindFirstChild("HumanoidRootPart") then
					local health = Hit.Parent.HumanoidRootPart.Health
					health.Value = math.max(0, health.Value - gun.DMG.Value)
					if health.Value <= 0 and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						--breakdoor
						if Hit and Hit.Parent and Hit.Parent.HumanoidRootPart:FindFirstChild("motor") then
							Hit.Parent.HumanoidRootPart.motor:Destroy()
							local hitsound = game.ReplicatedStorage.Sounds.breaks:clone()
							hitsound.Parent = Hit.Parent.HumanoidRootPart
							hitsound.PlayOnRemove = true
							hitsound:Destroy()
							addvelocitytobb(Hit, (CFrame.new(player.Character.HumanoidRootPart.Position, Hit.Parent.HumanoidRootPart.Position).lookVector * (gun.DMG.Value)))
						end
					end
				end
			else

					--game.ReplicatedStorage.Events.CreateParticle:FireAllClients("bullet",Hit,Pos)
			end
		end
	end
	if Hit and Hit.Parent and Hit.Parent:FindFirstChild("Humanoid") and dealminimum == false then
		if damagedone == true then
			game.ReplicatedStorage.Events.Debug:FireClient(player, "HIT_DEBUG: your damage registered to: "..Hit.Name)
		else
			game.ReplicatedStorage.Events.Debug:FireClient(player, "HIT_DEBUG: didn't register due to unknown reasons")
		end
	end
end)

function mapskin(gun, skin, inhand)
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
			
			local skindata = game.ReplicatedStorage.Skins:FindFirstChild(whichskin):FindFirstChild(skin)	
			local skindatach = skindata:GetDescendants()
			
			if inhand then
				gun	= inhand
			end
			
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
			
game.ReplicatedStorage.Events.ApplyGun.OnServerEvent:connect(function(player, weapon, owner)
	-- SANITIZE
	if typeof(weapon) ~= "Instance" then
		return
	end
	
	if player and weapon and player.Character and player.Character:FindFirstChild("RightHand") then
		local char = player.Character
		if char then
			if char and char:FindFirstChild("Gun") then
				char.Gun:Destroy()
			end
			if char and char:FindFirstChild("Gun2") then
				char.Gun2:Destroy()
			end
			if weapon == "none" or weapon == "DNA Scanner" then
			else
				local gun = weapon
				if char:FindFirstChild("EquippedTool") then
					char.EquippedTool.Value = gun.Name
				end
				local weaponinhand = gun.Model:clone()
				weaponinhand.Parent = char
				pcall(function()
					if owner ~= nil then
						mapskin(gun, owner.SkinFolder[owner.Status.Team.Value.."Folder"][gun.Name].Value, weaponinhand)	
					elseif player then
						mapskin(gun, player.SkinFolder[player.Status.Team.Value.."Folder"].Knife.Value, weaponinhand)
					end
				end)
				local gunweld = Instance.new("Motor6D")
				gunweld.Parent = weaponinhand
				gunweld.Part0 = char["RightHand"]
				gunweld.Part1 = weaponinhand
				gunweld.Name = "GunWeld"
				weaponinhand.Name = "Gun"
				if gun.Name == "DualBerettas" then
					local weaponinhand2 = gun.Model2:clone()
					weaponinhand2.Parent = char
					local gunweld = Instance.new("Motor6D")
					gunweld.Parent = weaponinhand2
					gunweld.Part0 = char["LeftHand"]
					gunweld.Part1 = weaponinhand2
					gunweld.Name = "GunWeld"
					weaponinhand2.Name = "Gun2"
					pcall(function()
						if owner ~= nil then
							mapskin(gun, owner.SkinFolder[owner.Status.Team.Value.."Folder"][gun.Name].Value, weaponinhand2)
						elseif player then
							mapskin(gun, player.SkinFolder[player.Status.Team.Value.."Folder"].Knife.Value, weaponinhand)		
						end
					end)
				end
				local string = Instance.new("StringValue")
				string.Parent = weaponinhand
				string.Name = "AnimateValue"
				if gun.Name == "MP7" then
					gunweld.C0 = CFrame.new(0.15, 0, 0.15)
				end
				if gun.Name == "Negev" then
					gunweld.C0 = CFrame.new(-0.15, 0, 0.3)
				end
				if gun.Name == "Bizon" then
					gunweld.C0 = CFrame.new(0.3, -0.45, 0.15) * CFrame.Angles(math.rad(-45), math.rad(50), math.rad(200))
				end
				if gun.Name == "T Knife" or gun.Name == "CT Knife" then
					gunweld.C1 = CFrame.Angles(0, 0, math.rad(180))
				end
				if gun.Name == "Scout" or gun.Name == "AWP" or gun.Name == "G3SG1" then
					gunweld.Part0 = char["LeftHand"]
					gunweld.C0 = CFrame.new(0.5, -0.6, -0.5) * CFrame.Angles(math.rad(155), math.rad(0), math.rad(-75))
				end
			end
		end
	end
end)

game.ReplicatedStorage.Events.FallDamage.OnServerEvent:connect(function(player, damage, atkr)
	if game.Workspace.Status.Preparation.Value == true then
		return
	end
	if player and player.Character and player.Character:FindFirstChild("UpperTorso") and player.Character:FindFirstChild("Humanoid") then
		local Humanoid = player.Character.Humanoid
		local UpperTorso = player.Character.UpperTorso
		if Humanoid:FindFirstChild("creator") then
			Humanoid.creator:Destroy()
		end	
		local damageSound = game.ReplicatedStorage.Sounds["Damage"..mrandom(1, 3)]:clone()
		damageSound.Parent = UpperTorso
		damageSound.PlayOnRemove = true
		damageSound:Destroy()
		
		local fall = Instance.new("IntValue")
		fall.Parent = Humanoid
		fall.Name = "Fall"
		delay(1, function()
			fall:Destroy()
		end)
		if damage < 0 then
			player:Kick("rekt")
		end
		if atkr and atkr.Name and game.Players:FindFirstChild(atkr.Name) then
			local c = Instance.new("ObjectValue")
			c.Name = "creator"
			c.Value = atkr
			delay(1, function()
				c:Destroy()
			end)
			c.Parent = Humanoid
			local piece = Instance.new("StringValue")
			piece.Parent = c
			piece.Name = "NameTag"
			piece.Value = "Discombobulator"
			dmgmodule.takeDamage(atkr, Humanoid, damage, game.ReplicatedStorage.Weapons.Discombobulator, false, false, false)
			player.Character.FallCausedBy.Value = nil
		else
			
			Humanoid:TakeDamage(damage)
		end
	end
end)
local function setDeathEnabled(humanoid,value)
	humanoid:SetStateEnabled("Dead",value)
	if game.ReplicatedStorage.Functions:FindFirstChild("SetDeathEnabled") then
		local char = humanoid.Parent
		local player = game.Players:GetPlayerFromCharacter(char)
		if player then
			game.ReplicatedStorage.Functions.SetDeathEnabled:InvokeClient(player,value)
		end
	end
end

function applyPackage(character,humanoid,model)
	local package = model
	local rigType = humanoid.RigType.Name
	
	local verifyJoints=game.ReplicatedStorage.Functions.VerifyJoints
	local player = game.Players:GetPlayerFromCharacter(character)
	
	local accessories = {}
	for _,child in pairs(character:GetChildren()) do
		if child:IsA("Accoutrement") then
			child.Parent = nil
			table.insert(accessories,child)
		end
	end
	
	setDeathEnabled(humanoid,false)
	
	for _,newLimb in pairs(package:GetChildren()) do
		local oldLimb = character:FindFirstChild(newLimb.Name)
		if oldLimb and newLimb:IsA("MeshPart")  then
			newLimb=newLimb:clone()
			newLimb.BrickColor = oldLimb.BrickColor
			newLimb.CFrame = oldLimb.CFrame
			newLimb.Parent = character
			oldLimb:Destroy()
		end
	end
		
	humanoid:BuildRigFromAttachments()
	
	if player then
		pcall(function ()
			local attempts = 0
			while attempts < 10 do
				local success = verifyJoints:InvokeClient(player)
				if success then
					break
				else
					attempts = attempts + 1
				end
			end
			if attempts == 10 then
				warn("Failed to apply package to ",player)
			end
		end)
	end
	for _,accessory in pairs(accessories) do
		accessory.Parent = character
	end
	setDeathEnabled(humanoid,true)
end


--[[game.ReplicatedStorage.Events.PlaySound.OnServerEvent:connect(function(player, parent, sound)
	if sound and parent then
		local clone = sound:clone()
		clone.Parent = parent
		clone.PlayOnRemove = true
		clone:Destroy()
			--clone:Play()
				--delay(clone.TimeLength,function()
				--clone:Destroy()
				--end)
	end
end)]]

function addappearance(player, model)
	if game.ReplicatedStorage.Warmup.Value == true then
		local buck = game.Players:GetPlayers()
		for i = 1, #buck do
			if buck[i]:FindFirstChild("DamageLogs") then
				if buck[i].DamageLogs:FindFirstChild(player.Name) then
					buck[i].DamageLogs[player.Name]:Destroy()
				end
			end
		end
	end
-------REMOVE THIS SET OF CODE IF IT'S COMPETITIVE THIS IS AUTO-GIVING ARMOR!!!!'

-- ok noob

	if gt.Value ~= "competitive" and gt.Value ~= "TTT" then

		createhelmet(player)
		createkevlar(player)

	end

--------------------------------did you see that :)
		


	if player and player.Character then
		local character = model:GetChildren()
		local numa = 0
		for i = 1, #character do
			if character[i].ClassName == "Shirt" or character[i].ClassName == "Pants" or character[i].ClassName == "BodyColors" or character[i]:IsA("Accoutrement") then
				if character[i].className == "BodyColors" then
					if player.Character:FindFirstChild("FakeHead") then
						player.Character.FakeHead.BrickColor = character[i].HeadColor
					end
				end
				local noob = character[i]:clone()
				if character[i]:IsA("Accoutrement") then
					numa = numa + 1
					noob.Name = "Hat"..numa
				end
				if noob and noob:FindFirstChild("Handle") then
					noob.Handle.CustomPhysicalProperties = PhysicalProperties.new(0, 1, 0, 1, 1)
					noob.Handle.CFrame = player.Character.Head.CFrame
				end
					
				noob.Parent = player.Character
				if noob and noob:FindFirstChild("Handle") then
					noob.Handle.CFrame = player.Character.Head.CFrame
				end
			elseif character[i].className=="Part" or character[i]:IsA("MeshPart") then
				if player and player.Character and player.Character:FindFirstChild(character[i].Name) then
					player.Character:FindFirstChild(character[i].Name).BrickColor = character[i].BrickColor
					--[[if character[i].Name~="Head" and character[i].Name~="HumanoidRootPart" and model:FindFirstChild("HasCustomPackage")  then
						if character[i]:IsA("MeshPart") then
							---------cool new packages 
							--player.Character.Humanoid:ReplaceBodyPartR15(character[i].Name,character[i])
						end
					end]]
				end
				if character[i].Name == "Head" then
					player.Character:WaitForChild("FakeHead", 2)
					if player.Character.FakeHead:FindFirstChild("face") then
						player.Character.FakeHead.face:Destroy()
					end
					character[i].face:clone().Parent = player.Character.FakeHead
				end
			end
		end	
		local faka = player.Character:GetDescendants()
		for i = 1, #faka do
			if faka[i] and faka[i]:IsA("BasePart") then
					--if playercollisions==false then
				if player.Status.Team.Value == "CT" then
					faka[i].CollisionGroupId = 2
				else
					faka[i].CollisionGroupId = 1
				end
					--[[else
						faka[i].CollisionGroupId=5
					end]]
			end
		end
	end
	if game.ReplicatedStorage.Warmup.Value == true or gt.Value == "deathmatch" then
		local ff = Instance.new("ForceField")
		ff.Parent = player.Character
		delay(7.5, function()
			ff:Destroy()
		end)
	end
	player.Character.Humanoid.HeadScale.Value = 1
	if player.Character.Humanoid:FindFirstChild("HeadScale") and model.Humanoid:FindFirstChild("HeadScale") and model.Humanoid:FindFirstChild("BodyHeightScale") and model.Humanoid:FindFirstChild("BodyDepthScale") and model.Humanoid:FindFirstChild("BodyWidthScale") then
		player.Character.Humanoid.HeadScale.Value=model.Humanoid.HeadScale.Value
		player.Character.Humanoid.BodyHeightScale.Value=model.Humanoid.BodyHeightScale.Value
		player.Character.Humanoid.BodyDepthScale.Value=model.Humanoid.BodyDepthScale.Value
		player.Character.Humanoid.BodyWidthScale.Value=model.Humanoid.BodyWidthScale.Value
	end
	
	
	--[[if player:FindFirstChild("Corpse") then
	player.Corpse:Destroy()
	end
	if player.Character then
	player.Character.Archivable=true
	end
	local dink=player.Character:clone()
	dink.Parent=player
	dink.Name="Corpse"
	player.Character.Archivable=false]]
	local bs = player.Character:GetChildren()
	for i = 1, #bs do
		if bs[i]:IsA("BasePart") and bs[i].Name ~= "HeadHB" and bs[i].Name ~= "Head" and bs[i].Name ~= "HumanoidRootPart" and bs[i].Name ~= "BackC4" then
			bs[i].Transparency = 0
			bs[i].Anchored = false
		end
	end
	player.Character:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame * CFrame.new(0, 1, 0))
	local ragdollneeded = false
	if player:FindFirstChild("Ragdoll") and player.Ragdoll.Appearance.Value == model.Name then
	else
		ragdollneeded = true
	end
	if ragdollneeded == true then
		local dink2 = game.ReplicatedStorage.Other.Ragdoll:clone()
		local bs = player.Character:GetChildren()
		for i = 1, #bs do
			if bs[i].className == "ShirtGraphic" or bs[i].className == "CharacterMesh" or  bs[i].className == "Accessory"  or bs[i].className == "BodyColors" or bs[i].className == "Shirt" or bs[i].className == "Pants" then
						
				local shit = bs[i]:clone()
			
			--[[if shit:IsA("Accessory") and shit:FindFirstChild("Handle") then
			dink2.Humanoid2:AddAccessory(shit)
			else]]
				shit.Parent = dink2
			--end
			end
		end
		local bap = Instance.new("StringValue")
		bap.Parent = dink2
		bap.Name = "Appearance"
		bap.Value = model.Name
		dink2.Parent = game.Workspace
		dink2:MoveTo(Vector3.new(0, -1000, 0))	
		delay(.5, function()
			local fuckboy = dink2:GetChildren()
			for i = 1, #fuckboy do
				local part = fuckboy[i]
				if part:IsA("Accessory") and part:FindFirstChild("Handle") then
					part.Handle.Anchored = true
				end
				if part:IsA("BasePart") then
					part.Anchored = true
				end
			end
			if player:FindFirstChild("Ragdoll") then
				player.Ragdoll:Destroy()
			end
			dink2.Parent = player
		end)
	end
	----------------------------
	--[[if dink and dink:FindFirstChild("Gun") then
	dink.Gun:Destroy()
	end
	local dinkchild=dink:GetChildren()
	for i=1,#dinkchild do
		if dinkchild[i]:IsA("BasePart") then
		dinkchild[i].CollisionGroupId=3
		end
		if dinkchild[i]:IsA("Script") or dinkchild[i]:IsA("LocalScript") then
		dinkchild[i]:Destroy()
		end
	end]]
	local dent = Instance.new("IntValue")
	dent.Parent = player.Character
	dent.Name = "IsAPlayer"
	if gametype.Value == "casual" or gametype.Value == "demolition" and player:FindFirstChild("DefuseKit") == nil then
		local shit = Instance.new("IntValue")
		shit.Parent = player 
		shit.Name = "DefuseKit"
	end
	if player and player:FindFirstChild("Status") and player.Status.Team.Value == "T" then
		if player:FindFirstChild("DefuseKit") then
			player.DefuseKit:Destroy()
		end
	end
	if player:FindFirstChild("DefuseKit") then
		local defusekit = game.ReplicatedStorage.CharacterModels.DefuseKit:clone()
		defusekit.Parent = player.Character
		defusekit.Name = "DKit"
	end
	
	for _, v in pairs(game.Players:GetChildren()) do
		pcall(function()
			if v.Status.Team.Value == player.Status.Team.Value and player ~= v then
				game.ReplicatedStorage.Nametag:FireClient(v, player, player.Character)
			end
		end)
	end
end

local necko = CFrame.new(-5.96046448e-08, 0.799999952, 1.1920929e-07, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local armo2 = CFrame.new(-1.24989128, 0.549999952, 1.1920929e-07, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local armo1 = CFrame.new(1.24998045, 0.549999952, 1.1920929e-07, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local uppat = CFrame.new(-1.1920929e-07, 0.550000072, 7.64462551e-20, 1, 0, 0, 0, 1, 0, 0, 0, 1)	


game.ReplicatedStorage.Events.ControlTurn.OnServerEvent:connect(function(player, ylookvector, climbing)
	if player.Character and player.Character:FindFirstChild("UpperTorso")  and player.Character:FindFirstChild("RightUpperArm") then
		if player.Character.RightUpperArm  and player.Character.LeftUpperArm  and player.Character.Head then
			local neck = player.Character.Head.Neck
			local arm = player.Character.LeftUpperArm.LeftShoulder
			local arm2 = player.Character.RightUpperArm.RightShoulder
			local waist = player.Character.UpperTorso.Waist
			if waist then
				local angle = ((math.pi / 3) * 1) * (ylookvector) * 0.6

				waist.C0 = uppat * CFrame.Angles(angle, 0, 0)

			end
			if neck then
				neck.C0 = necko * CFrame.Angles(((math.pi / 3) * 1) * ylookvector, 0, 0)
			end
			if arm then
				arm.C0 = armo2 * CFrame.Angles(((math.pi / 3) * 1) * ylookvector * 0.5, 0, 0)

			end
			if arm2 then
				arm2.C0 = armo1 * CFrame.Angles(((math.pi / 3) * 1) * ylookvector * 0.5, 0, 0)
			end
			if climbing then
				waist.C0 = uppat
				neck.C0 = necko
				arm.C0 = armo2
				arm2.C0 = armo1
			end
		end
	end
end)


local function openfunc(door, motor)
	door.HumanoidRootPart["Squeak1"]:Stop()
	door.HumanoidRootPart["Squeak2"]:Stop()
	if gt.Value == "TTT" then
		if motor.CurrentAngle == 0 then
			door.Controller:LoadAnimation(game.ReplicatedStorage.Other.Open):Play()
			local sound = door.HumanoidRootPart.Latch:clone()
			sound.Parent = door.HumanoidRootPart
			sound:Play()
			sound.Name = "OpenSC"
			delay(0.6, function()
				sound:Destroy()
			end)
			local sound2 = Instance.new("IntValue")
			sound2.Parent = door.HumanoidRootPart
			sound2.Name = "OpenSE"
			delay(0.25, function()
				sound2:Destroy()
			end)
		end
		repeat
			wait()
		until door.HumanoidRootPart:FindFirstChild("OpenSE") == nil or motor.CurrentAngle ~= 0
	end
	door.HumanoidRootPart["Squeak"..mrandom(1, 2)]:Play()
end
local function doors(map)


	local deers = map.Regen.Doors:GetChildren()
	for i = 1, #deers do
		local door = deers[i]
		local dippie = Instance.new("IntValue")
		dippie.Name = "Health"
		dippie.Parent = door.Door
		dippie.Value = 800
		if door.Door.Transparency == 1 then
			dippie.Value = 800
		end
		door:WaitForChild("Door").Name = "HumanoidRootPart"
		local ac = Instance.new("AnimationController")
		ac.Parent = door
		ac.Name = "Controller"
		local open = false
		local clickDistance = 10
	
	-- Create motors
		local motor = Instance.new("Motor")
		motor.Name = "motor"
		local yoff = door.FrameLeft.Position.Y - door.HumanoidRootPart.Position.Y
		motor.Parent = door.HumanoidRootPart
		motor.Part0 = door.FrameLeft
		motor.Part1 = door.HumanoidRootPart
		motor.C0 = CFrame.new(door.FrameLeft.Size.X / 2, -yoff, 0) * CFrame.Angles(math.pi / 2, 0, 0)
		motor.C1 = CFrame.new(-door.HumanoidRootPart.Size.X / 2, 0, 0) * CFrame.Angles(-3 * math.pi / 2, 0, 0)
		motor.MaxVelocity = .03
	
	-- Weld handles
	
	
	
		local weld = Instance.new("Motor6D")
		weld.Part0 = door.HumanoidRootPart
		weld.Part1 = door.Handle
		weld.C0 = CFrame.new(1.62901795, -0.629663229, -9.926036e-005, 1, 1.69786407e-012, 0, 3.51685348e-012, 1, 0, 0, 0, 1)
		weld.C1 = CFrame.new(0.1899997, 5.9604663e-006, -5.80027699e-006, 1, -8.97382169e-012, 0, 8.97382169e-012, 1, 0, 0, 0, 1)
		weld.Parent = door.HumanoidRootPart
	
	-- Handle event fire
		local event = game.ReplicatedStorage.Events.Event:clone()
		event.Parent = door
		event.OnServerEvent:connect(function(player)	
			if door and door:FindFirstChild("HumanoidRootPart") and door.HumanoidRootPart:FindFirstChild("motor") then
		-- Check distance to the character's UpperTorso. If too far, don't do anything
				if player and player.Character and player.Character:FindFirstChild("UpperTorso") then	
					local UpperTorso = player.Character:FindFirstChild("UpperTorso")
					local toUpperTorso = UpperTorso.Position - door.HumanoidRootPart.Position
					if toUpperTorso.magnitude < clickDistance then
						if open then
							openfunc(door, motor)
							motor.DesiredAngle = 0
							open = false
							repeat
								wait()
								if open == true then
									return
								end
							until motor.CurrentAngle == motor.DesiredAngle
							door.HumanoidRootPart["Squeak1"]:Stop()
							door.HumanoidRootPart["Squeak2"]:Stop()
							door.HumanoidRootPart["Close"..mrandom(1, 2)]:Play()
						else
							local left = Vector3.FromNormalId(Enum.NormalId.Left)
							local localToUpperTorso = door.FrameLeft.CFrame:vectorToObjectSpace(toUpperTorso)
							local cross = (localToUpperTorso:Cross(left)).Y
							local angle = -math.pi / 2
							if cross > 0 then
								angle = math.pi / 2
							end				
							openfunc(door, motor)
							motor.DesiredAngle = angle
							open = true
							repeat
								wait()
								if open == false then
									return
								end
							until motor.CurrentAngle == motor.DesiredAngle
							door.HumanoidRootPart["Squeak1"]:Stop()
							door.HumanoidRootPart["Squeak2"]:Stop()
							door.HumanoidRootPart.Open1:Play()
						end
					end
				end
			end
		end)
		
		door:WaitForChild("HumanoidRootPart").Anchored = false
		door:WaitForChild("Handle").Anchored = false
		door.HumanoidRootPart.CanCollide = true
	end
end














function getAttachment0(attachmentName, character)
	for _, child in next, character:GetChildren() do
		local attachment = child:FindFirstChild(attachmentName)
		if attachment then
			return attachment
		end
	end
end


local function OnDeath(Character)
	local headshot = false
	local playanimation = false
	if Character and Character:FindFirstChild("Head") and Character.Head:FindFirstChild("SpotLight") then
		Character.Head.SpotLight.Enabled = false
	end
	local svch = Character
	local boopman = svch:GetChildren()
	for i = 1, #boopman do
		if boopman[i]:IsA("BasePart") then
			boopman[i].Anchored = true
		end
	end
	if svch and svch:FindFirstChild("Humanoid") and svch.Humanoid:FindFirstChild("creator") and svch.Humanoid.creator:FindFirstChild("HEADSHOT") then
		headshot = true
	--playanimation=false
	end
	--[[if svch and svch:FindFirstChild("Humanoid") and svch.Humanoid:FindFirstChild("creator") and svch.Humanoid.creator:FindFirstChild("NameTag") then
		if svch.Humanoid.creator.NameTag.Value=="Knife" or svch.Humanoid.creator.NameTag.Value=="C4" then
		playanimation=false
		end
	else
		playanimation=false
	end]]
	if svch and svch:FindFirstChild("Head") and svch.Head:FindFirstChild("Voice") then
		svch.Head.Voice:Stop()
	end
	--[[local ray=Ray.new(svch.HumanoidRootPart.Position,Vector3.new(4,0,0))
	local hit,pos=game.Workspace:FindPartOnRayWithIgnoreList(ray,{svch, game.Workspace:WaitForChild("Debris"), game.Workspace:WaitForChild("Ray_Ignore"),game.Workspace.Map:WaitForChild("Clips"),game.Workspace.Map:WaitForChild("CTSpawns"),game.Workspace.Map:WaitForChild("TSpawns"),game.Workspace.Map:WaitForChild("SpawnPoints")},true,false)
	if hit then
	playanimation=false
	end    
	local ray=Ray.new(svch.HumanoidRootPart.Position,Vector3.new(-4,0,0))
	local hit,pos=game.Workspace:FindPartOnRayWithIgnoreList(ray,{svch, game.Workspace:WaitForChild("Debris"), game.Workspace:WaitForChild("Ray_Ignore"),game.Workspace.Map:WaitForChild("Clips"),game.Workspace.Map:WaitForChild("CTSpawns"),game.Workspace.Map:WaitForChild("TSpawns"),game.Workspace.Map:WaitForChild("SpawnPoints")},true,false)
	if hit then
	playanimation=false
	end    
	local ray=Ray.new(svch.HumanoidRootPart.Position,Vector3.new(0,0,4))
	local hit,pos=game.Workspace:FindPartOnRayWithIgnoreList(ray,{svch, game.Workspace:WaitForChild("Debris"), game.Workspace:WaitForChild("Ray_Ignore"),game.Workspace.Map:WaitForChild("Clips"),game.Workspace.Map:WaitForChild("CTSpawns"),game.Workspace.Map:WaitForChild("TSpawns"),game.Workspace.Map:WaitForChild("SpawnPoints")},true,false)
	if hit then
	playanimation=false
	end    
	local ray=Ray.new(svch.HumanoidRootPart.Position,Vector3.new(0,0,-4))
	local hit,pos=game.Workspace:FindPartOnRayWithIgnoreList(ray,{svch, game.Workspace:WaitForChild("Debris"), game.Workspace:WaitForChild("Ray_Ignore"),game.Workspace.Map:WaitForChild("Clips"),game.Workspace.Map:WaitForChild("CTSpawns"),game.Workspace.Map:WaitForChild("TSpawns"),game.Workspace.Map:WaitForChild("SpawnPoints")},true,false)
	if hit then
	playanimation=false
	end    
	local ray=Ray.new(svch.HumanoidRootPart.Position,Vector3.new(0,-3,0))
	local hit,pos=game.Workspace:FindPartOnRayWithIgnoreList(ray,{svch, game.Workspace:WaitForChild("Debris"), game.Workspace:WaitForChild("Ray_Ignore"),game.Workspace.Map:WaitForChild("Clips"),game.Workspace.Map:WaitForChild("CTSpawns"),game.Workspace.Map:WaitForChild("TSpawns"),game.Workspace.Map:WaitForChild("SpawnPoints")},true,false)
	if hit then
	else
	playanimation=false
	end    ]]
	
	local playa = game.Players:GetPlayerFromCharacter(svch)
	if game.Workspace.Status.CanRespawn.Value == false then
		playa.Status.Alive.Value = false
	end

	local shat = script.Cam:clone()
	shat.Part.Value = nil
	shat.Parent = svch
	shat.Disabled = false
	local hum = Character:findFirstChild("Humanoid")
	local shits = Character:GetChildren()
	for i = 1, #shits do
		if shits[i]:IsA("BasePart") and shits[i].CanCollide == true then
			shits[i].CollisionGroupId = 4
		end
	end
	local ragdoll = nil
	local id2 = nil
	local getkiller = nil
	local velocity = Vector3.new()
	if hum and hum:FindFirstChild("creator") and hum.creator.Value and hum.creator.Value.className == "Player" then
		getkiller = hum.creator.Value
		if getkiller and getkiller.Character and getkiller.Character:FindFirstChild("HumanoidRootPart") and svch and svch:FindFirstChild("HumanoidRootPart") then
			velocity = (CFrame.new(getkiller.Character.HumanoidRootPart.CFrame.p, svch.HumanoidRootPart.CFrame.p).lookVector.unit * 30) + Vector3.new(0, -5, 0)
		end
	end
	--[[if playa and playa:FindFirstChild("Corpse")==nil or svch and svch:FindFirstChild("HumanoidRootPart")==nil then
	playanimation=false
	end]]
	
	if playa then
		if playa:FindFirstChild("DefuseKit") then
			playa.DefuseKit:Destroy()
		end
		if playa:FindFirstChild("Kevlar") then
			playa.Kevlar:Destroy()
		end
		if playa:FindFirstChild("Helmet") then
			playa.Helmet:Destroy()
		end
	end
	local duration = 3.2
	if gt.Value == "TTT" then
		if game.Workspace.Status.CanRespawn.Value == true and playa.Status.Team.Value ~= "Spectator" then
			playa.Status.Alive.Value = true
			loadcharacter(playa)
			return
		end
	end
	delay(duration, function()
		if playa and playa.Character and playa.Character:FindFirstChild("Humanoid") and playa.Character.Humanoid.Health > 0 then
		else 
			if game.Workspace.Status.CanRespawn.Value == true and playa.Status.Team.Value ~= "Spectator" then
				playa.Status.Alive.Value = true
				loadcharacter(playa)
			end
		end
	end)
------server side ragdolls start here
	if gt.Value == "TTT" then
		local macy = math.random(1, 5)
		if playa and playa:FindFirstChild("Ragdoll") then
		else
			return
		end
-------------------------------------

		if svch and game.Workspace:WaitForChild("Debris"):FindFirstChild(svch.Name) then
			game.Workspace.Debris[svch.Name]:Destroy()
		end
		ragdoll = playa.Ragdoll:clone()

		ragdoll.Humanoid2:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		if hum and hum:FindFirstChild("creator") then
			hum.creator:clone().Parent = ragdoll:WaitForChild("Humanoid2")
		end

		if ragdoll and ragdoll:FindFirstChild("UpperTorso") then
			if Character and Character:FindFirstChild("UpperTorso") then
				ragdoll.UpperTorso.Velocity = Character.UpperTorso.Velocity
			end
		end
		
		if svch and svch:FindFirstChild("UpperTorso") then
			ragdoll:MoveTo(svch.UpperTorso.CFrame.p)
			local crap = ragdoll:GetChildren()
			for i = 1, #crap do
				if crap[i]:IsA("Accessory") and crap[i]:FindFirstChild("Handle") and crap[i].Handle:FindFirstChild("AccessoryWeld") then
					crap[i].Handle.Anchored = false
					crap[i].Handle.CollisionGroupId = 4
					crap[i].Handle.CanCollide = false
					crap[i].Handle.Velocity = Vector3.new()
					local attachment1 = crap[i].Handle:FindFirstChildOfClass("Attachment")
					if attachment1 then
						local attachment0 = getAttachment0(attachment1.Name, ragdoll)
						if attachment0 then
							crap[i].Handle.AccessoryWeld.Part1 = attachment0.Parent
						end
					else
						crap[i].Handle.AccessoryWeld.Part1 = ragdoll.Head
					end
				end
				if crap[i]:IsA("BasePart") then
					crap[i].Velocity = Vector3.new()
					crap[i].Anchored = false
					crap[i].RotVelocity = Vector3.new()
					crap[i].CollisionGroupId = 4
					if svch and svch:FindFirstChild(crap[i].Name) then
						crap[i].CFrame = svch[crap[i].Name].CFrame
					end
				end
				if crap[i]:IsA("Accessory") and crap[i]:FindFirstChild("Handle") then
					crap[i].Handle.Anchored = false
				end
			end

			if ragdoll and ragdoll:FindFirstChild("Hitboxes") then
				local fuck = ragdoll.Hitboxes:GetChildren()
				for i = 1, #fuck do
					if fuck[i]:IsA("BasePart") then
						fuck[i].CollisionGroupId = 3
					end
				end
				ragdoll.Hitboxes.LFoot.CFrame = ragdoll.LeftLowerLeg.CFrame
				ragdoll.Hitboxes.RFoot.CFrame = ragdoll.RightLowerLeg.CFrame
				ragdoll.Hitboxes.LHand.CFrame = ragdoll.LeftHand.CFrame
				ragdoll.Hitboxes.RHand.CFrame = ragdoll.RightHand.CFrame
				ragdoll.Hitboxes.TorsoBox.CFrame = ragdoll.UpperTorso.CFrame
				ragdoll.Hitboxes.Neck.CFrame = ragdoll.Head.CFrame
			end


		end

		ragdoll:WaitForChild("Humanoid2").Sit = true
	
----------------------TTT


		ragdoll.Name = playa.Name

		local getkiller = nil
		if hum and hum:FindFirstChild("creator") and hum.creator.Value and hum.creator.Value.className == "Player" then
			getkiller = hum.creator.Value
		end
		if game.Players:GetPlayerFromCharacter(svch) and game.Players:GetPlayerFromCharacter(svch):FindFirstChild("Status") and ragdoll then
	--[[if game.Players:GetPlayerFromCharacter(svch).Status.Role.Value=="Traitor" then
		local buttheads=game.Players:GetPlayers()
		for i=1,#buttheads do
			if buttheads[i]:FindFirstChild("Status") and buttheads[i].Status.Role.Value=="Detective" then
				buttheads[i].Status.Credits.Value=buttheads[i].Status.Credits.Value+2
				dFeed.Value=""
				dFeed.Value="Detectives, you have been awarded 2 equipment credits for your performance."
			end
		end
	end]]
			game.Players:GetPlayerFromCharacter(svch).Status.Role:Clone().Parent = ragdoll
			game.Players:GetPlayerFromCharacter(svch).Status.Identified:Clone().Parent = ragdoll
	--[[if getkiller and getkiller:FindFirstChild("Status") and getkiller.Status.Role.Value=="Traitor" then
		local buttheads=game.Players:GetPlayers()
		for i=1,#buttheads do
			if buttheads[i]:FindFirstChild("Status") and buttheads[i].Status.Role.Value=="Traitor" then
				buttheads[i].Status.Credits.Value=buttheads[i].Status.Credits.Value+1
				if game.Players:GetPlayerFromCharacter(svch).Status.Role.Value=="Detective" then
					buttheads[i].Status.Credits.Value=buttheads[i].Status.Credits.Value+1
					tFeed.Value=""
					tFeed.Value="Traitors, you have been awarded 2 equipment credits for your performance."
				else
					tFeed.Value=""
					tFeed.Value="Traitors, you have been awarded 1 equipment credit for your performance."
				end
			end
		end
	end]]
			if getkiller then
				if getkiller.Character and getkiller.Character:FindFirstChild("ListOfKills") == nil then
					local int = Instance.new("IntValue")
					int.Parent = getkiller.Character
					int.Name = "ListOfKills"
				end
				if getkiller.Character and getkiller.Character:FindFirstChild("ListOfKills") then
					local killed = Instance.new("StringValue")
					killed.Parent = getkiller.Character.ListOfKills
					killed.Name = svch.Name
					killed.Value = "Dead"
					killed.Archivable = true
				end
			end
			if hum:FindFirstChild("creator") and hum:FindFirstChild("creator"):FindFirstChild("HEADSHOT") then
				local id7 = Instance.new("StringValue")
				id7.Parent = ragdoll
				id7.Name = "HEADSHOT"
				id7.Value = "Bullet"	
			end
			if hum:FindFirstChild("creator") and hum:FindFirstChild("creator"):FindFirstChild("Silenced") then
				local id7 = Instance.new("StringValue")
				id7.Parent = ragdoll
				id7.Name = "Silenced"
				id7.Value = "Bullet"	
			end

			id2 = Instance.new("StringValue")
			id2.Parent = ragdoll
			id2.Name = "WeaponKilledBy"
			if hum:FindFirstChild("creator") and hum:FindFirstChild("creator"):FindFirstChild("NameTag") then
				id2.Value = hum:FindFirstChild("creator"):FindFirstChild("NameTag").Value
			else
				id2.Value = "Mysterious"
			end
			local id6 = Instance.new("StringValue")
			id6.Parent = ragdoll
			id6.Name = "Cause"
			id6.Value = "Bullet"
			if id2.Value == "Mysterious" then
				id6.Value = "None"
			end
			if id2.Value == "Banana Bomb" or id2.Value == "S-Bomb" or id2.Value == "HE Grenade" or id2.Value == "Tripwire Mine" or id2.Value == "Stun Grenade" or id2.Value == "C4" then
				id6.Value = "Explosion"
			end
			if id2.Value == "Molotov" or id2.Value == "Incendiary Grenade" then
				id6.Value = "Fire"
			end
			if id2.Value == "Crowbar" or id2.Value == "Bloxy" then
				id6.Value = "Beaten"
			end
		
			if id2.Value == "Zap"  or id2.Value == "aaa" then
				id6.Value = "Electricity"
			end
			if id2.Value == "Prop" then
				id6.Value = "Crush"
			end
			if id2.Value == "T Knife" then
				id6.Value = "Stab"
			end
			if hum and hum:FindFirstChild("Fall") then
				id6.Value = "Fall"
				id2.Value = "Mysterious"
			end
			if hum and hum:FindFirstChild("Propped") then
				id2.Value = "Prop"
				id6.Value = "Crush"
			end	

			if game.Players[ragdoll.Name]:FindFirstChild("LastWords") and game.Players:FindFirstChild(ragdoll.Name).LastWords.Value ~= "" then
				local id7 = Instance.new("StringValue")
				id7.Name = "LastWords"
				id7.Value = game.Players:FindFirstChild(ragdoll.Name):WaitForChild("LastWords").Value
				id7.Parent = ragdoll
			end
		


			if ragdoll:FindFirstChild("ListOfKills") == nil then
				if svch and svch:FindFirstChild("ListOfKills") then
					svch.ListOfKills:clone().Parent = ragdoll
				end
			end
			if game.Players:GetPlayerFromCharacter(svch) then
				if svch:FindFirstChild("Proven") then
					local int = Instance.new("IntValue")
					int.Parent = ragdoll
					int.Name = "Proven"
				end
				if game.Players:GetPlayerFromCharacter(svch):FindFirstChild("RDM") then
					local int = Instance.new("IntValue")
					int.Parent = ragdoll
					int.Name = "RDM"
					if game.Players:GetPlayerFromCharacter(svch):FindFirstChild("DamageLogs") and #game.Players:GetPlayerFromCharacter(svch).DamageLogs:GetChildren() > 0 then
						local idiot = game.Players:GetPlayerFromCharacter(svch).DamageLogs:GetChildren()
						for i = 1, #idiot do
							if game.Players:FindFirstChild(idiot[i].Name) and idiot[i]:FindFirstChild("RDM") then
								local hpm = game.Players:FindFirstChild(idiot[i].Name)
								if hpm and hpm.Character and hpm.Character:FindFirstChild("Humanoid") then
									hpm.Character.Humanoid.Health = math.min(hpm.Character.Humanoid.MaxHealth, hpm.Character.Humanoid.Health + (idiot[i].DMG.Value + 1))
								end
							end
						end
					end
					if ragdoll:FindFirstChild("Proven") then
						ragdoll.Proven:Destroy()
					end
				end
			end
		
			if  Character and Character:FindFirstChild("UpperTorso") and id2 and id2.Value ~= "Mysterious" and getkiller and getkiller.Character and getkiller.Character:FindFirstChild("UpperTorso") then
				local id8 = Instance.new("IntValue")
				id8.Name = "DNASampleTime"
				id8.Value = math.floor(120 * mmax(1 - (((getkiller.Character.UpperTorso.Position - Character.UpperTorso.Position).magnitude) / 40), 0))
				spawn(function()
					while id8 and id8.Value > 0 do 
						wait(1)
						if id8 and id8.Value > 0 then
							id8.Value = id8.Value - 1
						end
					end
				end)
				id8.Parent = ragdoll
			--print(Character.Name.."'s DNA decays at "..id8.Value)
				local killer = Instance.new("StringValue")
				killer.Name = "Killer"
				killer.Value = getkiller.Name
				killer.Parent = ragdoll
			end
		
			local userId = Instance.new("IntValue")
			userId.Name = "UserId"
			userId.Value = game.Players:GetPlayerFromCharacter(Character).UserId
			userId.Parent = ragdoll
			local timeDead = Instance.new("NumberValue")
			timeDead.Name = "TimeDead"
			timeDead.Value = game.Workspace.DistributedTime.Value
			timeDead.Parent = ragdoll
		
		
		




		end

-----------------------TTTT
		ragdoll.Name = Character.Name
		ragdoll.Parent = game.Workspace:WaitForChild("Debris")
	
		Character = ragdoll

		if ragdoll and ragdoll:FindFirstChild("UpperTorso") and headshot == true then
			local instance = Instance.new("BodyVelocity")
			instance.Parent = ragdoll.UpperTorso
			instance.Velocity = velocity
			instance.P = 2000
			instance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			delay(.05, function()
				instance:Destroy()
			end)
		end
		if Character:FindFirstChild("UpperTorso") then
			if ragdoll and ragdoll:FindFirstChild("Head") and headshot == false and playanimation == false and macy ~= nil then
				local death = game.ReplicatedStorage.Sounds["Death"..math.random(1, 5)]:clone()
				death.Parent = ragdoll.Head
				death:Play()
			end
			shat.Part.Value = Character.Head
		end
		local idiots = svch:GetChildren()
		for i = 1, #idiots do
			if idiots[i]:IsA("BasePart") or idiots[i]:IsA("Accoutrement") then
				idiots[i]:Destroy()
			end
		end
		--game.ReplicatedStorage.Events.CreateRagdoll:FireAllClients(playanimation,playa,svch,shat,ragdoll,velocity,hum,Character,headshot,math.random(1,5))
	------------------------------------------------------------------------
	else
		
		local players1 = game.Players:GetPlayers()
		for i = 1, #players1 do
			if players1[i].Status:FindFirstChild("HasSelectedTeam") == nil then
				game.ReplicatedStorage.Events.CreateRagdoll:FireClient(players1[i], playanimation, playa, svch, shat, ragdoll, velocity, hum, Character, headshot, math.random(1, 5))
			end
		end
	end


end
local function SpawnPlayer(Player)
	loadcharacter(Player)
end


function loadData(p)
	local pdata = DS:GetAsync("config2-"..p.UserId)
	if pdata then
		local path = game.ServerStorage.PlayerData:WaitForChild(tostring(p))
		path.Settings.LowViolence.Value = pdata[1]
		path.Settings.LowQuality.Value = pdata[2]
		path.Settings.MusicVolume.Value = pdata[3]
		path.Settings.AltCrouch.Value = pdata[4]
		path.Settings.FOV.Value = pdata[5]
	end
end


game.ReplicatedStorage.Events.Spawnme.OnServerEvent:connect(function(player)
	SpawnPlayer(player)
end)
local function onRespawn(character, plr)
	local humm = character:findFirstChild("Humanoid")
	if humm ~= nil then
		if character:FindFirstChild("Head") then
			for _, v in pairs(game.Players:GetChildren()) do
				pcall(function()
					if v.Status.Team.Value == plr.Status.Team.Value and plr ~= v then
						game.ReplicatedStorage.Nametag:FireClient(v, plr, plr.Character)
					end
				end)
			end
			local instance = Instance.new("Sound")
			instance.Parent = character.Head
			instance.Volume = 3
			instance.Name = "Voice"
		end
		if gt.Value == "TTT" then
			local part = Instance.new("IntValue")
			part.Parent = character
			part.Name = "RDMProtection"
		end
		local bounce = false
		local conn = humm.Died:connect(function()
			if bounce then
				return
			end
			if plr and plr:FindFirstChild("Kevlar") then
				plr.Kevlar:Destroy()
			end
			if plr and plr:FindFirstChild("Helmet") then
				plr.Helmet:Destroy()
			end
			bounce = true
			onHumanoidDied(humm, plr)
			OnDeath(character)
		end)
	end
	
end

function loadcharacter(player)
	if player and player:FindFirstChild("Status") then
		--[[if player.Character then
	    	player.Character:Destroy() -- Destroy creates less bugs and added spawn to oppose yields (bug: https://gyazo.com/0bf4a2c7e612c14fef1fb826f9f4424b)
			--game.Debris:AddItem(player.Character, 0) -- Destroy yields the script.
		end]]
		--[[local newchar=game.StarterPlayer.StarterCharacter:clone()
		newchar.Name=player.Name 
		newchar.Parent=game.Workspace
		newchar:MakeJoints()
		player.Character=newchar]]
		if player.Status.Team.Value ~= "Spectator" then
			player.Status.Alive.Value = true
		end
		pcall(function()
			player:LoadCharacter()
			
			player.Character:WaitForChild("Head")
			
			for _, v in pairs(game.Players:GetChildren()) do
				pcall(function()
					if v.Status.Team.Value == player.Status.Team.Value and player ~= v then
						game.ReplicatedStorage.Nametag:FireClient(v, player, player.Character)
					end
				end)
			end
		end)
	end
end
local DataStore = nil
if not rs:IsStudio() then
	DataStore = game:GetService("DataStoreService"):GetDataStore("TR_Updated")
end

local function waitForDataStoreReady(func)
	local success = false
	local message = ""
	success, message = pcall(func)
	if not success then
		while not success do
			success, message = pcall(func)
			wait(1)
		end
	end
end


local intvalues = {
	"TotalDamage",
	"OverallKills",
	"StoppedBombDefuser",
	"KnifeKills",
	"GrenadeKills",
	"HeadshotKills",
	"BoughtItems",
	"ONEANDONLYKILLS",
	"Shots",
	"MoneySpent"
}


local boolvalues = {
	"StoppedBombDefuser"
}
game.Players.PlayerAdded:connect(function(newPlayer)
	if newPlayer.userId == 89561349 then
		newPlayer:Kick("servers are currently down")
		return
	end
	
	--[[spawn(function()
		if BadgeService:UserHasBadgeAsync(newPlayer.UserId, 2124439970) == false then
			BadgeService:AwardBadge(newPlayer.UserId, 2124439970)
		end		
	end)]]
	
	if gt.Value == "TTT" then
		newPlayer.TeamColor = BrickColor.new("Really red")
	end
	--[[if game.PlaceId == 1675049933 then
		if newPlayer:IsInGroup(4081725) or newPlayer.Name == "Player1" or newPlayer.Name == "Player2" or newPlayer.Name == "TC8950" then -- this is why kenny threw a fit, okay.
		else
			newPlayer:Kick("only cbr balance testers can join")
			return
		end
	end]]
	if game.ServerStorage.Banned:FindFirstChild(newPlayer.Name) then
		newPlayer:Kick("You have been kicked for doing too much team damage.")
		return
	end
	local valid = true
	if newPlayer.Name == "DevRolve" or game.Players:FindFirstChild("DevRolve") or rs:IsStudio() then
		valid = true
	end
	if valid == false then
		newPlayer:Kick("dev's not in the server tho")
		return
	end
	game.Workspace:WaitForChild("Status"):WaitForChild("PlayerEntered").Value = ""
	game.Workspace:WaitForChild("Status"):WaitForChild("PlayerEntered").Value = newPlayer.Name
	-- SETTINGS (by tc)
	
	local f = Instance.new("Folder")
	f.Name = newPlayer.Name
	f.Parent = game.ServerStorage.PlayerData
	local f2 = Instance.new("Folder")
	f2.Name = "Settings"
	f2.Parent = f
		
	local bo = Instance.new("BoolValue")
	bo.Value = false
	bo.Name = "SetChanged"
	bo.Parent = f
		
		
	for i, v in ipairs(BoolSettings) do
		--	print(BoolSettings)
		local b = Instance.new("BoolValue")
		b.Value = false
		b.Name = v 
		b.Parent = f2
	end
		
	for i, v in ipairs (NumberSettings) do
		local n = Instance.new("IntValue")
		n.Value = 0
		n.Name = v 
		n.Parent = f2
	end
		
	f2.LowViolence.Value = true
	f2.LowQuality.Value = false
	f2.MusicVolume.Value = 50
	f2.FOV.Value = 80

	loadData(newPlayer)

	
	-- END SETTINGS
	if gt.Value == "demolition" then
		local zibbbb = Instance.new("IntValue")
		zibbbb.Name = "GunRank"
		zibbbb.Value = 1
		zibbbb.Parent = newPlayer
	end
	local shit = Instance.new("StringValue")
	shit.Parent = newPlayer
	shit.Name = "Location"
	shit.Value = ""
	local ping = Instance.new("IntValue")
	ping.Parent = newPlayer
	ping.Name = "Ping"
	ping.Value = 0
	local teamdamage = Instance.new("IntValue")
	teamdamage.Parent = newPlayer
	teamdamage.Name = "TeamDamage"
	teamdamage.Value = 0
	local teamdamage = Instance.new("IntValue")
	teamdamage.Parent = newPlayer
	teamdamage.Name = "TeamKills"
	teamdamage.Value = 0
	local nfolder = Instance.new("Folder")
	nfolder.Name = "Additionals"
	nfolder.Parent = newPlayer
	local CtheSights = Instance.new("Folder")
	CtheSights.Name = "TheSights"
	CtheSights.Parent = newPlayer
	
	for i = 1, #intvalues do
		local intvalue = Instance.new("IntValue")
		intvalue.Parent = nfolder
		intvalue.Name = intvalues[i]
	end
	for i = 1, #boolvalues do
		local intvalue = Instance.new("BoolValue")
		intvalue.Parent = nfolder
		intvalue.Name = boolvalues[i]
	end
	local folder = Instance.new("Folder")
	folder.Name = "Status"
	folder.Parent = newPlayer
	local Team = Instance.new("StringValue")
	Team.Name = "Team"
	Team.Value = "Spectator"
	Team.Parent = folder
	local role = Instance.new("StringValue")
	role.Parent = folder
	role.Name = "Role"
	role.Value = "Innocent"
	role.Changed:connect(function()
		if role.Value == "Detective" then
			createhelmet(newPlayer)
			createkevlar(newPlayer)
		else
			if newPlayer:FindFirstChild("Kevlar") then
				newPlayer.Kevlar:Destroy()
			end
			if newPlayer:FindFirstChild("Helmet") then
				newPlayer.Helmet:Destroy()
			end
		end
	end)
	local karma = Instance.new("IntValue")
	karma.Name = "Karma"
	karma.Parent = folder
	karma.Value = 1000
	local fkarma = Instance.new("IntValue")
	fkarma.Name = "FakeKarma"
	fkarma.Parent = folder
	fkarma.Value = 1000
	spawn(function()
		waitForDataStoreReady(function()
			DataStore:GetAsync(newPlayer.userId.." Karma"..kmid)
		end)
		if DataStore:GetAsync(newPlayer.userId.." Karma"..kmid) then
			karma.Value = DataStore:GetAsync(newPlayer.userId.." Karma"..kmid)
		else
			waitForDataStoreReady(function()
				DataStore:SetAsync(newPlayer.userId.." Karma"..kmid, karma.Value)
			end)
		end
		fkarma.Value = karma.Value
		local boop = Instance.new("IntValue")
		boop.Parent = newPlayer
		boop.Name = "KarmaDone"
	end)
	local lrole = Instance.new("StringValue")
	lrole.Parent = folder
	lrole.Name = "LastRole"
	lrole.Value = "Innocent"
	local ingy = Instance.new("BoolValue") -- attempt to cancle out some data being sent to people loading
	ingy.Name = "HasSelectedTeam"
	ingy.Value = false
	ingy.Parent = folder
	local alive = Instance.new("BoolValue")
	alive.Name = "Alive"
	alive.Value = false
	alive.Parent = folder
	local balive = Instance.new("BoolValue")
	balive.Name = "Identified"
	balive.Value = false
	balive.Parent = folder
	local pup = Instance.new("CFrameValue")
	pup.Name = "CameraCF"
	pup.Parent = newPlayer
	pup.Value = CFrame.new()
	local cash = Instance.new("IntValue")
	cash.Parent = newPlayer
	cash.Name = "Cash"
	cash.Value = defaultcash
	local kills = Instance.new("IntValue")
	kills.Parent = folder
	kills.Name = "Kills"
	local assis = Instance.new("IntValue")
	assis.Parent = folder
	assis.Name = "Assists"
	local deaths = Instance.new("IntValue")
	deaths.Parent = folder
	deaths.Name = "Deaths"
	local MVPs = Instance.new("IntValue")
	MVPs.Parent = folder
	MVPs.Name = "MVPs"
	if game.ReplicatedStorage.Warmup.Value == true then
		cash.Value = maxmoney
	end
	local variant = Instance.new("IntValue")
	variant.Parent = newPlayer
	variant.Value = 0
	variant.Name = "Variant"
	local boughtitems = Instance.new("Folder")
	boughtitems.Name = "BoughtItems"
	boughtitems.Parent = newPlayer
	local specmode = Instance.new("BoolValue")
	specmode.Name = "SpecMode"
	specmode.Value = false
	specmode.Parent = folder
	local canTalk = Instance.new("BoolValue")
	canTalk.Name = "CanTalk"
	canTalk.Value = true
	canTalk.Parent = folder
	local dominations = Instance.new("Folder")
	dominations.Name = "Dominations"
	dominations.Parent = folder
	local score = Instance.new("IntValue")
	score.Name = "Score"
	score.Parent = folder
	local score12 = Instance.new("IntValue")
	score12.Name = "Score"
	score12.Parent = newPlayer
	local dinka = Instance.new("StringValue")
	dinka.Parent = score
	dinka.Name = "Reasoning"
	dinka.Value = " for most eliminations."
	--[[if newPlayer.Name=="DevROLve" then
	specmode.Value=true
	end]]
	local dent = Instance.new("IntValue")
	dent.Name = "Damage"
	dent.Value = 0
	dent.Parent = newPlayer
	local logs = Instance.new("Folder")
	logs.Parent = newPlayer
	logs.Name = "DamageLogs"
	local checkChar = newPlayer.Character
	if checkChar ~= nil then
		onRespawn(checkChar)
	end
	newPlayer.CharacterAdded:connect(function(char)
		newPlayer.DamageLogs:ClearAllChildren()
		if newPlayer.Status.Team.Value ~= "Spectator" and newPlayer.Status.Alive.Value == true then
			if newPlayer:FindFirstChild("Spotted") then
				newPlayer.Spotted:Destroy()
			end
			if newPlayer:FindFirstChild("LastSeen") then
				newPlayer.LastSeen:Destroy()
			end
			onRespawn(char, newPlayer)
			--repeat wait(1) until char and char:FindFirstChild("UpperTorso") and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health>0 and char:FindFirstChild("Head") and newPlayer.Status.Alive.Value==true or newPlayer.Status.Alive.Value==false
			local cname = ""
			if newPlayer.Status.Team.Value == "CT" then
				cname = game.Workspace:WaitForChild("Map"):WaitForChild("CeeT").Value..tostring(newPlayer.Variant.Value)
			elseif newPlayer.Status.Team.Value == "T" then
				cname = game.Workspace:WaitForChild("Map"):WaitForChild("Tee").Value..tostring(newPlayer.Variant.Value)
			else
				cname = game.Workspace:WaitForChild("Map"):WaitForChild("Tee").Value..tostring(game.Workspace.Variant.Value)
			end
			if gt.Value=="juggernaut" and newPlayer.Status.Team.Value=="T" then --super gay
				cname="Juggernaut"
			end
			if game.ReplicatedStorage.CharacterModels:FindFirstChild(cname) then
				addappearance(newPlayer, game.ReplicatedStorage.CharacterModels[cname])
				if gt.Value=="juggernaut" and newPlayer.Status.Team.Value=="T" and newPlayer.Character and newPlayer.Character:FindFirstChild("Humanoid") then
					local pp=game.ServerStorage.JuggSounds:GetChildren()
					for i=1,#pp do
						pp[i]:clone().Parent=newPlayer.Character.HumanoidRootPart
					end
					local n=game.Workspace.Status.NumCT.Value
					local hp=((400+n)*n)^1.075
					newPlayer.Character.Humanoid.MaxHealth=hp
					newPlayer.Character.Humanoid.Health=newPlayer.Character.Humanoid.MaxHealth
					game.ReplicatedStorage.MHP.Value=hp
					game.ReplicatedStorage.HP.Value=hp
					game.ReplicatedStorage.BossName.Value=newPlayer.Name
					newPlayer.Character.Humanoid.HealthChanged:connect(function()
						wait()
						game.ReplicatedStorage.HP.Value=newPlayer.Character.Humanoid.Health
					end)
				end
				local Player = newPlayer
				if Player.Status.Team.Value == "T" or Player.Status.Team.Value == "Terrorist"  or Player.Status.Team.Value == "CT" then
					local bp = Player.Status.Team.Value.."Spawns"
					if gt.Value == "deathmatch" then
						bp = "AllSpawns"
					end
					local nags = game.Workspace:WaitForChild("Map"):WaitForChild(bp):GetChildren()
					repeat
						wait()
					until Player and Player.Character and Player.Character.PrimaryPart
					if game.Workspace:FindFirstChild("Map") and Player and Player.Character then
						if #nags > 0  then
							Player.Character:SetPrimaryPartCFrame(nags[math.random(1, #nags)].CFrame * CFrame.new(0, 4, 0))
							if gt.Value == "deathmatch" and Player and Player.Character and Player.Character:FindFirstChild("Head") then
								Player.Character.Head.bass:Play()
							end
						end
					end
				end
			end
		end
	end)
	loadcharacter(newPlayer)
end)



game.Players.PlayerRemoving:connect(function(oldie)
	if oldie:FindFirstChild("KarmaDone") then
		waitForDataStoreReady(function()
			DataStore:UpdateAsync(oldie.userId.." Karma"..kmid, function(oldValue)
				return oldie.Status.Karma.Value
			end)
		end)
	end
	if oldie.Name == game.Workspace.Status.HasBomb.Value then
		game.Workspace.Status.HasBomb.Value = ""
	end
	if game.ServerStorage.PlayerData:FindFirstChild(tostring(oldie)) then
		game.ServerStorage.PlayerData:FindFirstChild(tostring(oldie)):Destroy()
	end
	
	if oldie and oldie:FindFirstChild("Status") and oldie.Status.Team.Value ~= "Terrorist" and oldie.Status.Team.Value ~= "Spectator" then
		game.Workspace.Status["Num"..oldie.Status.Team.Value].Value = game.Workspace.Status["Num"..oldie.Status.Team.Value].Value - 1
		
	end
	if ssub(oldie.Name, 1, 6) ~= "Guest " then
		game.Workspace:WaitForChild("Status"):WaitForChild("PlayerLeft").Value = ""
		game.Workspace:WaitForChild("Status"):WaitForChild("PlayerLeft").Value = oldie.Name
	end
end)





-- EVENT DEFINITIONS





-- CHAT EVENT
game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Chat").OnServerEvent:connect(function(plyr, val, t, quickChat)
	local newmsg = Instance.new("StringValue") 
	if t then
		newmsg.Name = "TChatzMsg" 
	else
		if quickChat then
			newmsg.Name = "QChatzMsg" 
		else
			newmsg.Name = "ChatzMsg"
		end
	end
	newmsg.Value = val
	
	newmsg.Parent = plyr
	game:service("Debris"):AddItem(newmsg, 2) 
end)

-- FILTER EVENT
local filter = game:GetService("ReplicatedStorage"):WaitForChild("Functions"):WaitForChild("Filter")
function filter.OnServerInvoke(player, message, sender)
	local msg = ""
	pcall(function()
		msg = game:GetService("Chat"):FilterStringAsync(message, sender, player)
		
		--[[for _,c in pairs(filters) do
			pcall(function()
				msg	= string.gsub(msg, c[1], c[2])
			end)
		end]]
	end)
	return msg
end

local function whosthemostvalid(string)
	local playername = ""
	local value = 0
	local players = game.Players:GetChildren()
	for i = 1, #players do
		if players[i] and players[i]:FindFirstChild("Additionals") then
			if players[i].Additionals:FindFirstChild(string) and players[i].Additionals[string].Value >= value then
				if string ~= "TotalDamage" or string == "TotalDamage" and players[i].Additionals.OverallKills.Value == 0 then
					playername = players[i].Name
					value = players[i].Additionals[string].Value
				end
			end
		end
	end
	return playername, value
end


local function whosthemostbool(string)
	local playername = ""
	local players = game.Players:GetChildren()
	for i = 1, #players do
		if players[i] and players[i]:FindFirstChild("Additionals") then
			if players[i].Additionals:FindFirstChild(string) and players[i].Additionals[string].Value == true then
				playername = players[i].Name
			end
		end
	end
	return playername
end



--TC2 STUFF SEARCH ME Tc2STuff

game.ReplicatedStorage.Events.JoinTeam.OnServerEvent:connect(function(Player, Team)
--	print("join team recieved xd")
	local OppTeam = ""
	if Player.Status:FindFirstChild("HasSelectedTeam") then
		Player.Status.HasSelectedTeam:Destroy()
	end
	if Team == "T" then
		OppTeam = "CT"
		if gt.Value == "juggernaut" then
			return
		end
	else
		OppTeam = "T"
	end	
	if Team == "Spectator" and Player.Status.SpecMode.Value == false then
	--game.ReplicatedStorage.Events.SendMsg:FireAllClients(Player.Name.." has joined Spectators.")
	end
	if Player.Status.Team.Value ~= Team and Team ~= "Spectator" or Team == "Spectator" then --it wont bother if they pick the same team they are on
		--   print(Team)
		if Team ~= "Spectator" then
		--	print("team does not equal spec LETS A SET!")
			if gt.Value == "juggernaut" or workspace.Status:FindFirstChild("Num"..Team).Value < game.Workspace.Status.PlayerLimit.Value and workspace.Status:FindFirstChild("Num"..Team).Value <= workspace.Status:FindFirstChild("Num"..OppTeam).Value then
				--print("Can join")
				if game.Workspace.Status:FindFirstChild("Num"..Player.Status.Team.Value)  then
					game.Workspace.Status["Num"..Player.Status.Team.Value].Value = game.Workspace.Status["Num"..Player.Status.Team.Value].Value - 1
				end
				game.Workspace.Status["Num"..Team].Value = game.Workspace.Status["Num"..Team].Value + 1
				Player.Status.Team.Value = Team
				Player.Variant.Value = 0
				assignvariants()
				if Team == "T" then
					if Player.Name == game.Workspace.Status.HasBomb.Value then
						game.Workspace.Status.HasBomb.Value = ""
					end
					if Player:FindFirstChild("HasC4") then
						Player.HasC4:Destroy()
					end
					Player.TeamColor = BrickColor.new("Bright yellow")
				--game.ReplicatedStorage.Events.SendMsg:FireAllClients(Player.Name.." has joined Terrorists.")
				elseif Team == "CT" then
					if Player.Name == game.Workspace.Status.HasBomb.Value then
						game.Workspace.Status.HasBomb.Value = ""
					end
					if Player:FindFirstChild("HasC4") then
						Player.HasC4:Destroy()
					end
					Player.TeamColor = BrickColor.new("Bright blue")
				--game.ReplicatedStorage.Events.SendMsg:FireAllClients(Player.Name.." has joined Counter-Terrorists.")
				end
				if game.Workspace.Status.CanRespawn.Value == true then
					Player.Status.Alive.Value = true
					loadcharacter(Player)
				else
					if Player and Player.Character and Player.Character:FindFirstChild("Humanoid") then
						Player.Character.Humanoid.Health = 0
					end
				end
				Player.Status.SpecMode.Value = false
				
			else
				--print("Teams won't be balanced if you do that ;(")
			end
		else
			if game.Workspace.Status:FindFirstChild("Num"..Player.Status.Team.Value)  then
				game.Workspace.Status["Num"..Player.Status.Team.Value].Value = game.Workspace.Status["Num"..Player.Status.Team.Value].Value - 1
			end
			Player.Status.SpecMode.Value = true
			Player.Status.Team.Value = "Spectator"
			if Player.Status.Alive.Value == true then
				Player.Status.Alive.Value = false
			
				if Player and Player.Character and Player.Character:FindFirstChild("Humanoid") and game.Workspace.Status.CanRespawn.Value == false then
					Player.Character.Humanoid.Health = 0
				else
					loadcharacter(Player)
				end
			end
			
			--print("hi spectator rolve")
		end
	end
end)

game.ReplicatedStorage.MapVoting.Submit.OnServerEvent:connect(function(player, mapvoting, averyappropriateterm)
	local bitches = mapvoting:GetChildren()
	for i = 1, #bitches do
		if bitches[i]:FindFirstChild(player.Name) then
			bitches[i][player.Name]:Destroy()
		end
	end
	local int = Instance.new("IntValue")
	int.Parent = mapvoting:WaitForChild(averyappropriateterm)
	int.Name = player.Name
--[[if player:GetRankInGroup(1) > 250 then
local int2=Instance.new("IntValue")
int2.Parent=mapvoting:WaitForChild(averyappropriateterm)
int2.Name=player.Name
local int3=Instance.new("IntValue")
int3.Parent=mapvoting:WaitForChild(averyappropriateterm)
int3.Name=player.Name
local int4=Instance.new("IntValue")
int4.Parent=mapvoting:WaitForChild(averyappropriateterm)
int4.Name=player.Name
local int5=Instance.new("IntValue")
int5.Parent=mapvoting:WaitForChild(averyappropriateterm)
int5.Name=player.Name
end]]
end)



-- END OF EVENT DEFINITIONS
--Bread and butter game loop gameloop
local timer = game.Workspace.Status.Timer

local warmuptimer = 120
local freezetime = 15
local buytime = 45



function updategametype()
	if gametype.Value == "competitive" then
		defaultcash = 800
		maxmoney = 16000
		rounds = 30
		warmuptimer = 60
		roundsneededtowin = 16
		teamdamage = false
		playercollisions = true
		playersinteam = 5
		roundtime = 115
		freezetime = 20
		buytime = 35
	elseif gametype.Value == "demolition" then
		defaultcash = 0
		maxmoney = 0
		rounds = 20
		warmuptimer = 30
		roundsneededtowin = 10
		teamdamage = false
		playercollisions = false
		playersinteam = 10
		roundtime = 90
		freezetime = 5
		buytime = 6
	elseif gametype.Value == "deathmatch" then
		defaultcash = 10000
		maxmoney = 10000
		rounds = 1
		warmuptimer = 45
		roundsneededtowin = 1
		teamdamage = true
		playercollisions = false
		playersinteam = 5
		roundtime = 600
		freezetime = 5
		buytime = 600
	else
		defaultcash = 1000
		maxmoney = 10000
		rounds = 15
		warmuptimer = 60
		roundsneededtowin = 8
		teamdamage = false
		playercollisions = false
		playersinteam = 10
		roundtime = 120
		freezetime = 5
		buytime = 45
		if gametype.Value=="juggernaut" then
			rounds = 5
			roundsneededtowin = 5
			freezetime = 20
			maxmoney = 5000
			defaultcash = 5000
			playercollisions = true
			roundtime=300
		end
	end
	if gt.Value == "TTT" then
		rounds = 4
		playercollisions = true
	end
	game.Workspace.Status.PlayerLimit.Value = playersinteam
end
local function CreateRegion3FromLocAndSize(Position, Size)
	local SizeOffset = Size / 2
	local Point1 = Position - SizeOffset
	local Point2 = Position + SizeOffset
	return Region3.new(Point1, Point2)
end










local function updatelocations(locations)
	local whitelist = {}
	local players = game.Players:GetPlayers()
	for i = 1, #players do
		if players[i].Character then
			table.insert(whitelist, players[i].Character)
		end
	end
	for i = 1, #locations do
		local parts = game.Workspace:FindPartsInRegion3WithWhiteList(locations[i][1], whitelist)
		if #parts > 0 then
			for y = 1, #parts do
				if parts[y] and parts[y].Name == "HumanoidRootPart" and game.Players:GetPlayerFromCharacter(parts[y].Parent) and game.Players:GetPlayerFromCharacter(parts[y].Parent):FindFirstChild("Location") then
					game.Players:GetPlayerFromCharacter(parts[y].Parent).Location.Value = locations[i][2]
				end
			end
		end
	end
end
local stinkystuff = {}
local bamble
function game.ReplicatedStorage.Functions.SheHeckMe.OnServerInvoke() -- I didn't know you couldn't use JSON on client >.<
	for i, v in ipairs(stinkystuff) do
		--print(v)
	end
	return stinkystuff
end

-----hell yeahhhh
local DefaultMaps = {}
local RandomMaps = {}
local VoteMaps = {}
local MapsAvalible = 0
for i, v in ipairs(DefaultMaps) do
	MapsAvalible = MapsAvalible + 1
end

-- WARNING SORTING GARBAGE BELOW
-- Map Pool , mappool
local function VoteForGarbage()
	if gt.Value == "competitive" then
		DefaultMaps = {
			"de_inferno",
			"de_dust2",
			"de_nuke",
			"de_fallen",
			"de_mirage",
			"de_cobblestone",
			"de_train",
			"de_cache"
		}
	elseif gt.Value == "casual" or gt.Value=="juggernaut"  then
	--DefaultMaps = {"de_inferno","de_cobblestone","de_dust2","de_fallen","de_nuke","de_vertigo", "de_mirage"}
		DefaultMaps = {
			"de_cache",
			"de_fallen",
			"de_dust2",
			"de_vertigo",
			"de_inferno",
			"de_train",
			"de_nuke",
			"de_seaside",
			"de_mirage",
		}

	if game.PlaceId == 2546855276 then
	DefaultMaps = {
			"de_cache",
--			"de_fallen",
			"de_dust2",
			"de_vertigo",
				--			"de_inferno",
				"de_mirage",
--			"de_nuke",
			"de_seaside",
			"de_metro",
			"cs_agency",
			"cs_office",
}

	end
			
		
	elseif gt.Value == "TTT" then
		DefaultMaps = {
			"ttt_fabrik",
			"ttt_67thway",
			"ttt_streetcorner",
			"ttt_metropolis",
			"ttt_wholesale",
			"ttt_santafe"
		}
	elseif gt.Value == "deathmatch" then
		DefaultMaps = {
			"de_dust2",
			"de_cache",
			"de_fallen",
			"de_nuke",
			"de_mirage",
			"de_vertigo"
		}
	elseif gt.Value == "demolition" then
		DefaultMaps = {
			"de_safehouse"
		}
	end			

	local MapsAvalible = 0
	for i, v in ipairs(DefaultMaps) do
		MapsAvalible = MapsAvalible + 1
	end
	local list = {}
	for i = 1, #DefaultMaps do
		table.insert(list, DefaultMaps[i])
	end
--print(#list .. " is the length")
	VoteMaps = {}
	repeat
		wait()
		local i = math.random(1, #list)
		table.insert(VoteMaps, list[i])
		table.remove(list, i)
	until #VoteMaps == 4
			
			--[[game.ReplicatedStorage.MapVoting.Map1.Value = VoteMaps[1]	
			game.ReplicatedStorage.MapVoting.Map2.Value = VoteMaps[2]	
			game.ReplicatedStorage.MapVoting.Map3.Value = VoteMaps[3]	
			game.ReplicatedStorage.MapVoting.Map4.Value = VoteMaps[4]		]]
	stinkystuff = VoteMaps
	game.ReplicatedStorage.MapVoting.Maps.Value = game:GetService("HttpService"):JSONEncode(VoteMaps)
			
			
			
	game.ReplicatedStorage.MapVoting.Counts:ClearAllChildren()
			
	for i, v in ipairs(VoteMaps) do
		local z = Instance.new("StringValue")
		z.Name = v
		z.Parent = game.ReplicatedStorage.MapVoting.Counts
	end
			
	game.ReplicatedStorage.Voten.Value = true			
			
	game.Workspace.Status.Timer.Value = 15
	if gt.Value == "TTT" then
		game.Workspace.Status.Timer.Value = 15
	end
	if game.ServerScriptService.VIPMENU.forcemap.Value ~= "" then
		game.Workspace.Status.Timer.Value = 0
	end
	while game.Workspace.Status.Timer.Value > 0 do
		wait(1)
		updategametype()
		game.Workspace.Status.Timer.Value = game.Workspace.Status.Timer.Value - 1
	end
			
	local selected = VoteMaps[math.random(1, #VoteMaps)]
	local votes = 0
	local shits = game.ReplicatedStorage:WaitForChild("MapVoting"):WaitForChild("Counts"):GetChildren()
	for i = 1, #shits do
		if #shits[i]:GetChildren() >= votes and #shits[i]:GetChildren() > 0 then
			votes = #shits[i]:GetChildren()
			selected = shits[i].Name
			shits[i]:ClearAllChildren()
		end
	end
	game.ReplicatedStorage.Voten.Value = false
	if game.ServerScriptService.VIPMENU.forcemap.Value ~= "" then
		selected = game.ServerScriptService.VIPMENU.forcemap.Value
		game.ServerScriptService.VIPMENU.forcemap.Value = ""
	end
	return selected
end
-- sorry for the garbage	



function doGame()
	repeat
		wait(0.5)
	until game.Players.NumPlayers >= 1
	wait(2)
	--[[
		VOTE SYSTEM HERE!!! SERVER!!
	--]]	
	game.ServerStorage.Banned:ClearAllChildren()


	local mapname = VoteForGarbage()

----------------------CREATE MAP
	updategametype()
	if game.Workspace:FindFirstChild("Map") then
		game.Workspace.Map:Destroy()
	end
	game.Workspace.Terrain:Clear()
--	
	if game:GetService("RunService"):IsStudio() then -- studio map test
		--mapname="de_dust2"
		--	mapname = "de_barcelona"
		mapname = "de_dust2"
	end	
	--mapname = "hw_seaside"
	--[[if (rs:IsStudio() or game.PlaceId==1675049933) and gt.Value~="deathmatch" and gt.Value~="TTT" then
		mapname="de_inferno"
	end]]

	if game.ServerStorage.Maps[mapname]:FindFirstChild("MapName") then
		game.Workspace.Status.MapParent.Value = game.ServerStorage.Maps[mapname].MapName.Value
	end
	local map 
	if game.ServerStorage.Maps[mapname]:IsA("IntValue") then
	local insert = _insert:LoadAsset(game.ServerStorage.Maps[mapname].Value)
	map = insert[mapname]
		local regenf = map.Regen:Clone()
		if game.ServerStorage.Maps[mapname]:FindFirstChild("Regen") == nil then
			regenf.Parent = game.ServerStorage.Maps[mapname]
		end
	else
	map = game.ServerStorage.Maps[mapname]:clone()
	end
	map.Name = "Map"
	map.Parent = game.Workspace
	if map:FindFirstChild("Region") then
		workspace.Terrain:PasteRegion(map.Region, workspace.Terrain.MaxExtents.Min, true)
	end
	spawn(function()
		if game.Workspace.Map:FindFirstChild("Ignore") then
	
			for _, v in pairs(game.Workspace.Map.Ignore:GetChildren()) do
				if v.Name == "LadderDetector" then
					if v:FindFirstChild("Front") then
						v.Front:Destroy()
					end
				end
			end
		end
	end)
	if map:FindFirstChild("Tester") then
		if map:FindFirstChild("existtester") == nil then
			local newtester = game.ReplicatedStorage.Tester:clone()
			newtester:SetPrimaryPartCFrame(map.Tester.Color.CFrame)
			map.Tester:Destroy()
			newtester.Parent = map
		end
		local dab = game.ServerStorage["TR"]["TR_Tester"]:clone()
		dab.Parent = map
		dab.Disabled = false
	end
	local origman = Instance.new("StringValue")
	origman.Name = "Origin"
	origman.Parent = map
	origman.Value = mapname
	game.ReplicatedStorage.Events.NewMapAdded:FireAllClients()
	if game.Lighting:FindFirstChild("Bloom") then
		game.Lighting.Bloom:Destroy()
	end
	if game.Lighting:FindFirstChild("Blur") then
		game.Lighting.Blur:Destroy()
	end
	if game.Lighting:FindFirstChild("ColorCorrection") then
		game.Lighting.ColorCorrection:Destroy()
	end
	if game.Lighting:FindFirstChild("SunRays") then
		game.Lighting.SunRays:Destroy()
	end
	if game.Lighting:FindFirstChild("Sky") then
		game.Lighting.Sky:Destroy()
	end
	if map.LightingSettings:FindFirstChild("Sky") then
		map.LightingSettings.Sky:clone().Parent = game.Lighting
	end
	if map.LightingSettings:FindFirstChild("SunRays") then
		map.LightingSettings.SunRays:clone().Parent = game.Lighting
	end
	if map.LightingSettings:FindFirstChild("Bloom") then
		map.LightingSettings.Bloom:clone().Parent = game.Lighting
	end
	if map.LightingSettings:FindFirstChild("Blur") then
		map.LightingSettings.Blur:clone().Parent = game.Lighting
	end
	if map.LightingSettings:FindFirstChild("ColorCorrection") then
		map.LightingSettings.ColorCorrection:clone().Parent = game.Lighting
	end
	game.Lighting.FogEnd = map.LightingSettings.FogEnd.Value
	game.Lighting.Ambient = map.LightingSettings.Ambient.Value
	game.Lighting.GeographicLatitude = map.LightingSettings.Latitude.Value
	game.Lighting.OutdoorAmbient = map.LightingSettings.OutdoorAmbient.Value
	game.Lighting.Brightness = map.LightingSettings.Brightness.Value
	game.Lighting.FogColor = map.LightingSettings.FogColor.Value
	game.Lighting.TimeOfDay = map.LightingSettings.TimeOfDay.Value
	map.LightingSettings:Destroy()
	local function MapInit()
		local map = game.Workspace:WaitForChild("Map")

--------------------------
		if game.ReplicatedStorage:FindFirstChild("RedDoor") and game.ReplicatedStorage:FindFirstChild("GreenDoor") then
			game.ReplicatedStorage.RedDoor:Destroy()
			game.ReplicatedStorage.GreenDoor:Destroy()
		end
		if map:FindFirstChild("RedDoor") and map:FindFirstChild("GreenDoor") then
			map.RedDoor.Parent = game.ReplicatedStorage
			map.GreenDoor.Parent = game.ReplicatedStorage
		end
		if map:FindFirstChild("Radar") then
			map.Radar.Touched:connect(function(part)
				if part and part.Parent and part.Parent:FindFirstChild("Humanoid") then
					part.Parent.Humanoid.Health = 0
				end
			end)
		end
		if map:FindFirstChild("Killers") then
			local killers = map.Killers:GetChildren()
			for i = 1, #killers do
				if killers[i]:IsA("BasePart") then
					killers[i].Touched:connect(function(part)
						if part and game.ReplicatedStorage.Weapons:FindFirstChild(part.Name) then
							part:Destroy()
							return
						end
						if part and part.Parent and part.Parent:FindFirstChild("Humanoid") then
							part.Parent.Humanoid.Health = 0
						end
					end)
				end
			end
		end
		doors(map)
	end
	MapInit()
	
	local regions = game.Workspace.Map.Clips.Locations:GetChildren()




	local locations = {}
	for i = 1, #regions do
		local location = CreateRegion3FromLocAndSize(regions[i].Position, regions[i].Size)
		table.insert(locations, {
			location,
			regions[i].Name
		})
		regions[i]:Destroy()
	end


	if script.Parent.VIPMENU.forcewarmup.Value then
		warmuptimer = 9999999
	end

	local ttt = false
	if gt.Value == "TTT" then
		ttt = true
	end
	game.Workspace.Status.CanRespawn.Value = true
	game.ReplicatedStorage.Warmup.Value = true
	game.Workspace.Status.RoundOver.Value = false --Once this loops over it respawns everyone and the vicious cycle repeats
	if ttt == true then
		warmuptimer = 0
	end
	timer.Value = warmuptimer
	game.Workspace.Status.BuyTime.Value = 1000
	if (rs:IsStudio() or game.PlaceId == 1675049933) and ttt == false then
--				timer.Value=12345
--				game.Workspace.Status.BuyTime.Value=12345
	end

	game.Workspace.Status.NumT.Value = 0
	game.Workspace.Status.NumCT.Value = 0
	game.Workspace.Status.CTWins.Value = 0
	game.Workspace.Status.TWins.Value = 0
	game.Workspace.Status.TLost.Value = 0
	game.Workspace.Status.CTLost.Value = 0
	local players = game.Players:GetPlayers()
	for i = 1, #players do
		if players[i]:FindFirstChild("Variant") then
			players[i].Variant.Value = 0
		end
	end
	
	for i = 1, #players do
		if players[i]:FindFirstChild("TeamDamage") then
			players[i].TeamDamage.Value = 0
		end
		if players[i]:FindFirstChild("TeamKills") then
			players[i].TeamKills.Value = 0
		end
		if players[i]:FindFirstChild("HasC4") then
			players[i].HasC4:Destroy()
		end
		if players[i]:FindFirstChild("Status")  then
			players[i].Location.Value = ""
			players[i].Score.Value = 0
			players[i].Status.Kills.Value = 0
			players[i].Status.Assists.Value = 0
			players[i].Status.Deaths.Value = 0
			players[i].Status.MVPs.Value = 0
			if gt.Value ~= "TTT" then
				players[i].Status.Alive.Value = false
				players[i].Status.Team.Value = "Spectator"
			end
			players[i].Status.SpecMode.Value = false
			players[i].Cash.Value = maxmoney
		end
		if warmuptimer > 0 then
			loadcharacter(players[i])
		end
	end	
	--clearsurfaceguis(game.Workspace.Map)
	tlosingstreak = 0
	ctlosingstreak = 0
	while timer.Value > 0 do
		if game.Workspace:FindFirstChild("C4") then
			game.Workspace.C4:Destroy()
		end
		updatelocations(locations)
		if game.Workspace.Status.BuyTime.Value > 0 then
			game.Workspace.Status.BuyTime.Value = game.Workspace.Status.BuyTime.Value - 1
		end		
		workspace.Status.PlayerChanged.Value = workspace.Status.PlayerChanged.Value + 1
		timer.Value = timer.Value - 1
		if timer.Value <= 3 then
			game.Workspace.Sounds.Beep:Play()
		end
--		if (game.Workspace.Status.NumT.Value+game.Workspace.Status.NumCT.Value)>=10 and timer.Value>10 then
--			timer.Value=10
--		end
		wait(1)
	end
	drops = 0

	game.ReplicatedStorage.Warmup.Value = false
	for roundno = 1, rounds do
		for i, v in pairs (game.Players:GetPlayers()) do
			if v:FindFirstChild("Tags") then
				for j, k in pairs (v:FindFirstChild("Tags"):GetChildren()) do
					if k:FindFirstChild("Tag") then
						k:FindFirstChild("Tag").Value = ""
					end
				end
			end
		end
		game.Workspace.Status.Rounds.Value = roundno
		game.Workspace.Status.RoundOver.Value = false --Once this loops over it respawns everyone and the vicious cycle repeats
		if ttt == true then
			game.Workspace.Variant.Value = math.random(1, 5)
			local players = game.Players:GetPlayers()		
			for i = 1, #players do
				if players[i] and players[i].TeamColor == BrickColor.new("Really red") and players[i]:FindFirstChild("Status") then
					if players[i].Status.Alive.Value == false and players[i].Status.Team.Value == "Terrorist" then
						players[i].Status.Deaths.Value = players[i].Status.Deaths.Value + 1
					end
					if players[i].Status.Alive.Value == true and players[i].Character and players[i].Character:FindFirstChild("Humanoid") and players[i].Character.Humanoid.Health > 0 then
						players[i].Character.Humanoid.Health = 0
						local bap = game.ReplicatedStorage.Sounds["Damage"..math.random(1, 3)]:clone()
						bap.Parent = game.Workspace
						bap.PlayOnRemove = true
						bap:Destroy()
					end
					players[i].Status.Team.Value = "Spectator"
					players[i].Status.Role.Value = "Innocent"
					players[i].Status.Alive.Value = false
					if players[i]:FindFirstChild("DamageLogs") then
						players[i].DamageLogs:ClearAllChildren()
					end
				end
				wait()
			end
		end
		drops = 0
		shots = 0
	--clearsurfaceguis(game.Workspace.Map)
	
		game.Workspace.Status.MVP.Value = "ROBLOX"
		game.Workspace.Status.MVP.Reason.Value = " for most eliminations."
		game.Workspace.Status.Armed.Value = false
		game.Workspace.Status.Exploded.Value = false
		game.Workspace.Status.Defused.Value = false
		game.Workspace.Status.FirstTime.Value = false
		if game.Workspace.Map:FindFirstChild("Gamemode") and game.Workspace.Map.Gamemode.Value == "defusal" then
			game.Workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant2")["Planted"].Value = false
			game.Workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant")["Planted"].Value = false
		end
		game.Workspace.KillFeed["1"].Active.Value = false
		game.Workspace.KillFeed["2"].Active.Value = false
		game.Workspace.KillFeed["3"].Active.Value = false
		game.Workspace.KillFeed["4"].Active.Value = false
		game.Workspace.KillFeed["5"].Active.Value = false
		game.Workspace.KillFeed["6"].Active.Value = false
		game.Workspace.KillFeed["7"].Active.Value = false
		game.Workspace.KillFeed["8"].Active.Value = false
		game.Workspace.KillFeed["9"].Active.Value = false
		game.Workspace.KillFeed["10"].Active.Value = false
		game.Workspace.Debris:ClearAllChildren()
		local stations = Instance.new("Folder")
		stations.Name = "Stations"
		stations.Parent = game.Workspace.Debris
		game.Workspace["Ray_Ignore"]:ClearAllChildren()
		local stations = Instance.new("Folder")
		stations.Name = "Smokes"
		stations.Parent = game.Workspace["Ray_Ignore"]
		local stations = Instance.new("Folder")
		stations.Name = "Fires"
		stations.Parent = game.Workspace["Ray_Ignore"]
		game.Workspace.Status.Preparation.Value = true
		local feed = game.Workspace.Feed
		local feed2 = game.Workspace.Feed2
		local tfeed = game.Workspace.TFeed
		local dfeed = game.Workspace.DFeed
	
		if #game.ServerStorage.Maps[mapname].Regen:GetChildren() > 2 then
			if game.Workspace.Map:FindFirstChild("Regen") then
				game.Workspace.Map.Regen:Destroy()
			end
			map = game.ServerStorage.Maps[mapname].Regen:clone()
			map.Parent = game.Workspace.Map
			doors(game.Workspace.Map)
		end
		local crud = game.Workspace.Sounds:GetChildren()
		for i = 1, #crud do
			crud[i]:Stop()
		end


	--doors(game.Workspace.Map)
		local trs = {}
		local c4given = false
		local players = game.Players:GetPlayers()
		game.Workspace.Status.HasBomb.Value = ""
		timer.Value = freezetime
		if gt.Value == "TTT" then
			timer.Value = 45
		end
		game.ReplicatedStorage.Events.Audio:FireAllClients("PreStart")
		game.Workspace.Status.CanRespawn.Value = true
		game.Workspace.Status.BuyTime.Value = buytime
		if roundno == 16 then
			local ctwins = game.Workspace.Status.CTWins.Value
			local twins = game.Workspace.Status.TWins.Value
			local numt = game.Workspace.Status.NumT.Value
			local numct = game.Workspace.Status.NumCT.Value
			tlosingstreak = 0
			ctlosingstreak = 0
			game.Workspace.Status.TWins.Value = ctwins
			game.Workspace.Status.CTWins.Value = twins
			game.Workspace.Status.NumT.Value = numct
			game.Workspace.Status.NumCT.Value = numt
		end
		if gt.Value ~= "TTT" then
			local blas = game.Players:GetPlayers()
			for i = 1, #blas do
				if blas[i]:FindFirstChild("Status") and blas[i].Status.Team.Value == "T" then
					table.insert(trs, blas[i])
				end
			end
			local chosen = nil
			if #trs >= 1 then
				chosen = trs[math.random(1, #trs)]
			end
			if gt.Value=="juggernaut" then
				local trs={}
				local blas = game.Players:GetPlayers()
				for i = 1, #blas do
					if blas[i]:FindFirstChild("Status") and blas[i].Status.Team.Value == "CT" then
						table.insert(trs, blas[i])
					end
				end
				if #trs >= 1 then
					chosen = trs[math.random(1, #trs)]
				end
			end
			for i = 1, #players do
				if players[i] and players[i]:FindFirstChild("Status") then			
					if gametype.Value == "competitive" and roundno == 16 then
						if players[i]:FindFirstChild("Status") then
							if players[i]:FindFirstChild("DefuseKit") then
								players[i].DefuseKit:Destroy()
							end
							if players[i]:FindFirstChild("Kevlar") then
								players[i].Kevlar:Destroy()
							end
							if players[i]:FindFirstChild("Helmet") then
								players[i].Helmet:Destroy()
							end
							if players[i]:FindFirstChild("Cash") then
								players[i].Cash.Value = defaultcash
							end
							if players[i].Status.Team.Value == "CT" then
								players[i].Status.Team.Value = "T"
								players[i].TeamColor = BrickColor.new("Bright yellow")
								game.ReplicatedStorage.Events.resetweapons:FireClient(players[i])
							elseif players[i].Status.Team.Value == "T" then
								players[i].Status.Team.Value = "CT"
								players[i].TeamColor = BrickColor.new("Bright blue")
								game.ReplicatedStorage.Events.resetweapons:FireClient(players[i])
							end
						end
					end
					if gt.Value=="juggernaut" and players[i].Status.Team.Value=="T" then
						players[i].Status.Team.Value = "CT"
						players[i].TeamColor = BrickColor.new("Bright blue")
					end
					if gt.Value=="juggernaut" then
						game.ReplicatedStorage.Events.resetweapons:FireClient(players[i])
						if players[i]:FindFirstChild("Cash") then
							players[i].Cash.Value = defaultcash
						end
					end
					if roundno == 1 then
						if players[i]:FindFirstChild("DefuseKit") then
							players[i].DefuseKit:Destroy()
						end
						if players[i]:FindFirstChild("Kevlar") then
							players[i].Kevlar:Destroy()
						end
						if players[i]:FindFirstChild("Helmet") then
							players[i].Helmet:Destroy()
						end
						if players[i]:FindFirstChild("Status") then
							players[i].Score.Value = 0
							players[i].Status.Kills.Value = 0
							players[i].Status.Assists.Value = 0
							players[i].Status.Deaths.Value = 0
							players[i].Status.MVPs.Value = 0
						end
						if players[i]:FindFirstChild("Cash") then
							players[i].Cash.Value = defaultcash
						end
					end
					if players[i]:FindFirstChild("Additionals") then
						local pups = players[i].Additionals:GetChildren()
						for g = 1, #pups do
							if pups[g].className == "IntValue" then
								if pups[g].Name == "TotalDamage" then
									if pups[g].Value >= 1000 and game.ReplicatedStorage.gametype.Value == "juggernaut" then 
										--[[spawn(function()
											BadgeService:AwardBadge(players[i].UserId, 2124439971)
										end)		]]								
									end
								end
								pups[g].Value = 0
							elseif pups[g].className == "BoolValue" then
								pups[g].Value = false
							end
						end
					end
					if players[i]:FindFirstChild("DamageLogs") then
						players[i].DamageLogs:ClearAllChildren()
					end
					if players[i]:FindFirstChild("HasC4") then
						players[i].HasC4:Destroy()
					end
					if players[i].Status:FindFirstChild("Score") then
						players[i].Status.Score.Value = 0
						players[i].Status.Score.Reasoning.Value = " for most eliminations."
					end
					if players[i]:FindFirstChild("Status") and players[i].Status.Team.Value ~= "Spectator" then
						players[i].Status.Alive.Value = true
						if gt.Value=="juggernaut" and chosen and players[i]==chosen then
							players[i].Status.Team.Value = "T"
							players[i].TeamColor = BrickColor.new("Bright yellow")
						end
						if players[i].Status.Team.Value == "T" and game.Workspace.Map.Gamemode.Value == "defusal" or gt.Value=="juggernaut" then
							if chosen and players[i] == chosen then
								if gt.Value=="deathmatch" or gt.Value=="juggernaut" then
								else
									c4given = true
									local anappropriateword = Instance.new("IntValue")
									anappropriateword.Parent = players[i]
									anappropriateword.Name = "HasC4"
									game.Workspace.Status.HasBomb.Value = players[i].Name
								end
							end
						end
					end
				end
			end	
			--This tabbing is garbage and this script editor is absolute shit, does nothing to help this fucking garbage. Why doesn't roblox just fix the god damn script editor this shit was reported a hundred times. Why is this engine such shit. Studio won't properly snap windows, the new toolbox is fucking ass for inserting decals, NO you guys want us to upload decals through the game now, that creates clutter and is not scalable. Fuck you roblox. Fix your fucking engine	
		
			local tcount=0
			local ctcount=0
			for i = 1, #players do
				if players[i] and players[i]:FindFirstChild("Status") then
					if players[i].Status.Team.Value=="CT" then
						ctcount=ctcount+1
					elseif players[i].Status.Team.Value=="T" then
						tcount=tcount+1
					end
				end
				if players[i] and players[i]:FindFirstChild("Status") and players[i].Status.Alive.Value == true then
				--if players[i].Character then
				--	players[i].Character:Destroy()
					--game.Debris:AddItem(players[i].Character, 0)
				--end
					loadcharacter(players[i])
				--[[local starttime=tick()
				repeat wait() until game.Workspace:FindFirstChild(players[i].Name) or (tick()-starttime)>=.5]]
				end
			end
			game.Workspace.Status.NumCT.Value=ctcount
			game.Workspace.Status.NumT.Value=tcount
		end
		game.Workspace.Debris:ClearAllChildren()
		wait(1)
		if gt.Value ~= "deathmatch" then
			if game.Workspace.Status.TWins.Value == roundsneededtowin - 1 or game.Workspace.Status.CTWins.Value == roundsneededtowin - 1 then
				game.ReplicatedStorage.Events.Matchpoint:FireAllClients()
			end
		end
		game.Workspace.Debris:ClearAllChildren()
		if gt.Value == "TTT" then
			local poop = game.Workspace.Map.Regen.WeaponDrops:GetChildren()
			for i = 1, #poop do
				if game.ReplicatedStorage.Weapons:FindFirstChild(poop[i].Name) then
					poop[i].CanCollide = false
					poop[i].Anchored = true
					local da = CFrame.Angles(0, 0, 0)
					if game.Workspace.Map:FindFirstChild("classic") then
						if poop[i].Name == "AK47" then
							da = CFrame.Angles(math.rad(-90), math.rad(0), math.rad(180))
						elseif poop[i].Name == "XM" then
							da = CFrame.Angles(math.rad(90), math.rad(180), math.rad(0))--xm
						elseif poop[i].Name == "Glock" then
							da = CFrame.Angles(math.rad(-90), math.rad(90), math.rad(90))--cz
						elseif poop[i].Name == "MAC10" then
							da = CFrame.Angles(math.rad(90), math.rad(90), math.rad(0)) * CFrame.new(0.15, 0.3, 0)--mac10
						elseif poop[i].Name == "M249" then
							da = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(0))--m249
						elseif poop[i].Name == "Discombobulator" then
							da = CFrame.Angles(math.rad(0), math.rad(90), math.rad(0))--discombob
						elseif poop[i].Name == "Molotov" then
							da = CFrame.Angles(math.rad(0), math.rad(90), math.rad(0))--molotov
						elseif poop[i].Name == "DesertEagle" then
							da = CFrame.Angles(math.rad(270), math.rad(0), math.rad(180))--desert eagle
						elseif poop[i].Name == "Scout" then
							da = CFrame.Angles(math.rad(270), math.rad(0), math.rad(180)) * CFrame.new(0, 0, 1)--scout		
						end			
					end
					drop(poop[i].CFrame * da, poop[i].Name)
				end
				poop[i]:Destroy()
			end
		end
		if game.PlaceId == 1849599345 then
		feed.Value = "You have 30 seconds to prepare."
		end
		while timer.Value > 0 do		
			wait(1)
			if game.Workspace.Map:FindFirstChild("Gamemode") and game.Workspace.Map.Gamemode.Value == "defusal" then
				game.Workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant2")["Planted"].Value = false
				game.Workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant")["Planted"].Value = false
			end
			game.Workspace.KillFeed["1"].Active.Value = false
			game.Workspace.KillFeed["2"].Active.Value = false
			game.Workspace.KillFeed["3"].Active.Value = false
			game.Workspace.KillFeed["4"].Active.Value = false
			game.Workspace.KillFeed["5"].Active.Value = false
			game.Workspace.KillFeed["6"].Active.Value = false
			game.Workspace.KillFeed["7"].Active.Value = false
			game.Workspace.KillFeed["8"].Active.Value = false
			game.Workspace.KillFeed["9"].Active.Value = false
			game.Workspace.KillFeed["10"].Active.Value = false
			game.Workspace.Status.MVP.Value = "ROBLOX"
			game.Workspace.Status.MVP.Reason.Value = " for most eliminations."
			game.Workspace.Status.Armed.Value = false
			game.Workspace.Status.Exploded.Value = false
			game.Workspace.Status.FirstTime.Value = false
			game.Workspace.Status.Defused.Value = false
			if game.Workspace:FindFirstChild("C4") then
				game.Workspace.C4:Destroy()
			end
			updatelocations(locations)
			workspace.Status.PlayerChanged.Value = workspace.Status.PlayerChanged.Value + 1
			timer.Value = timer.Value - 1
			if timer.Value == 28 then
				feed.Value = "Karma"
			end
			if timer.Value <= 5 then
				game.Workspace.Sounds.Beep:Play()
			end
			if game.Workspace.Status.BuyTime.Value > 0 then
				game.Workspace.Status.BuyTime.Value = game.Workspace.Status.BuyTime.Value - 1
			end
		end
		local shattas = game.Workspace.FunFacts:GetChildren()
		for i = 1, #shattas do
			if shattas[i].className == "StringValue" and shattas[i]:FindFirstChild("Joke") == nil then
				shattas[i].Value = ""
			end
		end
	
	
		local Ts = {}
		local CTs = {}
		local players = game.Players:GetChildren()
		for i = 1, #players do
			if players[i] and players[i]:FindFirstChild("Status") then
				if players[i].Status.Team.Value == "CT" then
					table.insert(CTs, players[i])
				elseif players[i].Status.Team.Value == "T" then
					table.insert(Ts, players[i])
				end
			end
		end
--	if #Ts>0 then
--		local voicefolder=game.ReplicatedStorage.Voices[game.Workspace.Map.Tee.Value].lockload
--		sendvoice(Ts[math.random(1,#Ts)],voicefolder:GetChildren()[math.random(1,#voicefolder:GetChildren())])
--	end
--	if #CTs>0 then
--		local voicefolder=game.ReplicatedStorage.Voices[game.Workspace.Map.CeeT.Value].lockload
--		sendvoice(CTs[math.random(1,#CTs)],voicefolder:GetChildren()[math.random(1,#voicefolder:GetChildren())])
--	end
		local acect = #CTs
		local acet = #Ts
	--local randomsound = math.random(1,4)
	--PlaySound(game.ReplicatedStorage.Announcer["Start"..randomsound])
		if gt.Value == "juggernaut" then
		game.ReplicatedStorage.Events.SoundSt:FireAllClients()
		end
		game.Workspace.Status.Preparation.Value = false
		game.Workspace.Status.ITSGOINGTOEXPLODE.Value = false

		timer.Value = roundtime
		if gt.Value == "TTT" then
			timer.Value = 60 * 5
		end
		local didntexplode = false
		local ppls, T, CT
		local actualtimetaken = 0
		if gt.Value ~= "deathmatch" then
			game.Workspace.Status.CanRespawn.Value = false
		end
		if gt.Value == "TTT" then
			SelectRoles()
		end
		repeat 
			wait(1)
			if gt.Value=="deathmatch" or gt.Value=="juggernaut" then
			else
				if game.Workspace.Map:FindFirstChild("Gamemode") and game.Workspace.Map.Gamemode.Value == "defusal" and game.Workspace.Status.Armed.Value == false and game.Workspace.Status.HasBomb.Value == "" and game.Workspace.Debris:FindFirstChild("C4") == nil then
					local spawnp = game.Workspace.Map.TSpawns:GetChildren()[math.random(1, #game.Workspace.Map.TSpawns:GetChildren())]
					drop(CFrame.new(spawnp.Position + Vector3.new(0, 3, 0)), "C4")
				end
			end
			actualtimetaken = actualtimetaken + 1
			if game.Workspace.Status.BuyTime.Value > 0 then
				game.Workspace.Status.BuyTime.Value = game.Workspace.Status.BuyTime.Value - 1
			end
			ppls, T, CT = peoplealive()
			workspace.Status.PlayerChanged.Value = workspace.Status.PlayerChanged.Value + 1
			if T <= 0 and game.Workspace:FindFirstChild("C4") == nil or CT <= 0 then
				game.Workspace.Status.RoundOver.Value = true
			end
			if game.Workspace.Status.Exploded.Value == true or game.Workspace.Status.Defused.Value == true then
				game.Workspace.Status.RoundOver.Value = true
			end
			if game.Workspace:FindFirstChild("C4") then
			else
				timer.Value = timer.Value - 1
				if timer.Value == 10 and game.ReplicatedStorage.Warmup.Value == false and game.Workspace.Status.Preparation.Value == false then
					game.ReplicatedStorage.Events.Audio:FireAllClients("Tensec")
				end
			end
			if timer.Value <= 0 then
				game.Workspace.Status.RoundOver.Value = true
			end
			updatelocations(locations)
			if game.Workspace.Status.ITSGOINGTOEXPLODE.Value == true and didntexplode == false then
				didntexplode = true
				local Ts = {}
				local CTs = {}
				local players = game.Players:GetChildren()
				for i = 1, #players do
					if players[i] and players[i]:FindFirstChild("Status") and players[i].Character and players[i].Character:FindFirstChild("HumanoidRootPart") and game.Workspace:FindFirstChild("C4") and game.Workspace.C4:FindFirstChild("Handle") and (players[i].Character.HumanoidRootPart.Position - game.Workspace.C4.Handle.Position).magnitude <= 100 then
						if players[i].Status.Team.Value == "CT" then
							table.insert(CTs, players[i])
						elseif players[i].Status.Team.Value == "T" then
							table.insert(Ts, players[i])
						end
					end
				end
				
			end
				
		until game.Workspace.Status.RoundOver.Value == true --based on gamemode
		game.Workspace.RoundEnded.Value = 300 - game.Workspace.Status.Timer.Value
		
		local reasoning = "elimination"
		local wincondition = "t"
		if game.Workspace.Status.Exploded.Value == true then
			if game.Workspace:FindFirstChild("C4") and game.Workspace.C4:FindFirstChild("Handle") and game.Workspace.C4.Handle:FindFirstChild("creator") and game.Workspace.C4.Handle.creator.Value then
				game.Workspace.C4.Handle.creator.Value.Status.Score.Value = game.Workspace.C4.Handle.creator.Value.Status.Score.Value + 1
				game.Workspace.C4.Handle.creator.Value.Score.Value = game.Workspace.C4.Handle.creator.Value.Score.Value + 1
			end
			reasoning = "exploded"
		end
		if game.Workspace.Status.Timer.Value <= 0 then
			reasoning = "timeranout"
		end
		if game.Workspace.Status.Defused.Value == true or T <= 0 and game.Workspace:FindFirstChild("C4") == nil and game.Workspace.Status.Exploded.Value == false and game.Workspace.Status.Armed.Value == false or timer.Value <= 0 and game.Workspace.Map:FindFirstChild("Gamemode") and game.Workspace.Map.Gamemode.Value ~= "hostages" then
			wincondition = "ct"
			if game.Workspace.Status.Defused.Value == true then
				reasoning = "defused"
			end
		end
		if gt.Value == "TTT" then
			local players = game.Players:GetPlayers()
			for i = 1, #players do
				if players[i] and players[i]:FindFirstChild("Status") then
					if players[i]:FindFirstChild("RDM") then
						players[i].RDM:Destroy()
						players[i].Status.Karma.Value = math.min(1000, players[i].Status.Karma.Value + 5)
					else
						players[i].Status.Karma.Value = math.min(1000, players[i].Status.Karma.Value + 35)
					end
					players[i].Status.Score.Value = players[i].Status.Kills.Value
					if players[i].Status:FindFirstChild("Karma") then
						players[i].Status.FakeKarma.Value = players[i].Status.Karma.Value
					end 
				end
			end			
		end
		local funfact = "this game is bad"
			-----CALCULATING FACTS
		local playername, value = whosthemostvalid("TotalDamage")
		if game.Players:FindFirstChild(playername) then
			game.Workspace.FunFacts["Tons of Damage!"].Value = playername.." had no kills, but did "..value.." damage."
			game.Workspace.FunFacts["Tons of Damage!"].Priority.Value = math.floor(value / 100)
		end
			----------------------
		local playername, value = whosthemostvalid("OverallKills")
		local acevalue = 0
		if game.Players:FindFirstChild(playername) then
			if game.Players[playername]:FindFirstChild("Status") then
				if game.Players[playername].Status.Team.Value == "T" then
					acevalue = acect
				elseif game.Players[playername].Status.Team.Value == "T" then
					acevalue = acet
				end
			end
		end
		if game.Players:FindFirstChild(playername) then
			if value >= acevalue and acevalue > 0 and acevalue >= 5 then
				game.Workspace.FunFacts["Ace!"].Value = "Ace! "..playername.." killed the entire enemy team."
			end
			game.Workspace.FunFacts["Opponents Killed"].Value = playername.." killed "..value.." opponents."
			game.Workspace.FunFacts["Opponents Killed"].Priority.Value = value
		end
			-----------------------------------------------
		local playername, value = whosthemostbool("StoppedBombDefuser")
		if game.Players:FindFirstChild(playername) then
			game.Workspace.FunFacts["Counter-Counter-Terrorist"].Value = playername.." successfully stopped the bomb defuser."
		end
			-----------------------------------------------
		local playername, value = whosthemostvalid("KnifeKills")
		if game.Players:FindFirstChild(playername) and value > 0 then
			if value > 1 then
				game.Workspace.FunFacts["Knife Kills"].Value = playername.." had "..value.." knife kills this round."
				game.Workspace.FunFacts["Knife Kills"].Priority.Value = 5 + value
			else
				game.Workspace.FunFacts["Knife Kill"].Value = playername.." killed an enemy with the knife."
			end
		end
			-----------------------------------------------
		local playername, value = whosthemostvalid("HeadshotKills")
		if game.Players:FindFirstChild(playername) and value > 0 then
			if value > 1 then
				game.Workspace.FunFacts["Headshots"].Value = playername.." killed "..value.." enemies with headshots that round."
				game.Workspace.FunFacts["Headshots"].Priority.Value = 5 + value
			end
		end
			-----------------------------------------------
		local playername, value = whosthemostvalid("BoughtItems")
		if game.Players:FindFirstChild(playername) and value > 0 then
			game.Workspace.FunFacts["Toomanyitems"].Value = playername.." bought "..value.." items."
			game.Workspace.FunFacts["Toomanyitems"].Priority.Value = value
		end
			-----------------------------------------------
		local playername, value = whosthemostvalid("MoneySpent")
		if game.Players:FindFirstChild(playername) and value > 0 then
			game.Workspace.FunFacts["Moneyspent"].Value = playername.." spent $"..value.." that round."
			game.Workspace.FunFacts["Moneyspent"].Priority.Value = math.floor(value / 1400)
		end
			-----------------------------------------------
		local playername, value = whosthemostvalid("ONEANDONLYKILLS")
		if game.Players:FindFirstChild(playername) and value > 0 then
			if value > 1 then
				if game.Players[playername]:FindFirstChild("Status") then
					if game.Players[playername].Status.Team.Value == "CT" and wincondition == "ct" or game.Players[playername].Status.Team.Value == "T" and wincondition ~= "ct" then
						game.Workspace.FunFacts["Headshots"].Value = "As the last member alive, "..playername.." killed "..value.." enemies and won."
						game.Workspace.FunFacts["Headshots"].Priority.Value = 5 + value
					end
				end
			end
		end
			-----------------------------------------------
		local timetaken = actualtimetaken
		game.Workspace.FunFacts["Fast Round"].Value = "That round only took "..timetaken.." seconds!"
		game.Workspace.FunFacts["Fast Round"].Priority.Value = (60 - timetaken) / 6
			-----------------------------------------------
		if T >= game.Workspace.Status.NumT.Value and T > 1 then
			game.Workspace.FunFacts["TWonwithoutcasualties"].Value = "Terrorists won without taking any casualties."
			game.Workspace.FunFacts["CTWonwithoutcasualties"].Priority.Value = T
		end
		if CT >= game.Workspace.Status.NumCT.Value and CT > 1 then
			game.Workspace.FunFacts["CTWonwithoutcasualties"].Value = "Counter-Terrorists won without taking any casualties."
			game.Workspace.FunFacts["CTWonwithoutcasualties"].Priority.Value = CT
		end
		local first = nil
		local second = nil
		local third = nil
		local priority = {}
		for i, v in pairs (game.Players:GetPlayers()) do
			if v:FindFirstChild("Status") and v.Status:FindFirstChild("Score") and v.Status.Alive.Value == true then
				if #priority ~= 0 then
					for j = 1, #priority do
						if v.Status.Score.Value >= priority[j].Status.Score.Value then
							tinsert(priority, j, v)
							break
						end
						if j == #priority then
							tinsert(priority, v)
						end
					end
				else
					tinsert(priority, v)
				end
			end
		end
		first = priority[1]
		second = priority[2]
		third = priority[3]
		game.Workspace.Status.First.Value = "ROBLOX"
		game.Workspace.Status.First.ID.Value = 1
		game.Workspace.Status.Second.Value = "ROBLOX"
		game.Workspace.Status.Second.ID.Value = 1
		game.Workspace.Status.Third.Value = "ROBLOX"
		game.Workspace.Status.Third.ID.Value = 1
		if first then
			game.Workspace.Status.First.Value = first.Name
			game.Workspace.Status.First.ID.Value = first.UserId
			if second then
				game.Workspace.Status.Second.Value = second.Name
				game.Workspace.Status.Second.ID.Value = second.UserId
				if third then
					game.Workspace.Status.Third.Value = third.Name
					game.Workspace.Status.Third.ID.Value = third.UserId
				end
			end
		end

			------------------- SELECTING THE MOST VALID FACT
		local shits = game.Workspace.FunFacts:GetChildren()
		local priority = -math.huge
		for i = 1, #shits do
			if shits[i].Value ~= "" and shits[i]:FindFirstChild("Priority") and shits[i].Priority.Value >= priority then
				priority = shits[i].Priority.Value
				funfact = shits[i].Value
			end
		end
			---------------------------------------
		game.Workspace.Status.FunFact.Value = funfact
		if gt.Value ~= "TTT" and gt.Value ~= "deathmatch" then
			if wincondition == "ct" then
				ctlosingstreak = 0
				tlosingstreak = tlosingstreak + 1
				local maxscore = 0
				local players = game.Players:GetPlayers()
				for i = 1, #players do
					if players[i] and players[i]:FindFirstChild("Status") and players[i].Status.Team.Value == "CT" then
						if players[i].Status.Score.Reasoning.Value == " for defusing the bomb." then
							if players[i] then
								addcash(players[i], 300, "+$300: Award for defusing the bomb.")
							end
						end
						if game.Workspace.Status.FirstTime.Value == true then
							if players[i] then
								addcash(players[i], 150, "+$150: Award for carrying the hostage.")
							end
						end
						if players[i].Status.Score.Value >= maxscore then
							maxscore = players[i].Status.Score.Value
							game.Workspace.Status.MVP.Value = players[i].Name
							game.Workspace.Status.MVP.Reason.Value = players[i].Status.Score.Reasoning.Value
							game.Workspace.Status.MVP.ID.Value = players[i].userId
						end
					end
				end
				game.ReplicatedStorage.Events.Audio:FireAllClients("Finish", "CT")
				spawn(function()
					if game.Workspace.Status.Defused.Value == true then
						wait(2)
					end
					workspace.Sounds.CT:Play()
				end)
				game.Workspace.Status.CTWins.Value = game.Workspace.Status.CTWins.Value + 1
				game.Workspace.Status.CTLost.Value = 0
				game.Workspace.Status.TLost.Value = game.Workspace.Status.TLost.Value + 1
				local players = game.Players:GetPlayers()
				for i = 1, #players do
					if players[i]:FindFirstChild("Status") then
						if players[i].Status.Team.Value == "CT" then
							if reasoning == "elimination" then
								if game.Workspace.Map.Gamemode.Value == "defusal" then
									if gametype.Value == "competitive" then
										addcash(players[i], 3250, "+$3250: Team award for eliminating the enemy team.")
									else
										addcash(players[i], 2700, "+$2700: Team award for eliminating the enemy team.")
									end
								else
									if gametype.Value == "competitive" then
										addcash(players[i], 3000, "+$3000: Team award for eliminating the enemy team.")
									else
										addcash(players[i], 2300, "+$2300: Team award for eliminating the enemy team.")
									end
								end
							elseif reasoning == "defused" then
								if game.Workspace.Map.Gamemode.Value == "defusal" then
									if gametype.Value == "competitive" then
										addcash(players[i], 3500, "+$3500: Team award for defusing the bomb.")
									else
										addcash(players[i], 2700, "+$2700: Team award for defusing the bomb.")
									end
								else
									if gametype.Value == "competitive" then
										addcash(players[i], 2900, "+$2900: Team award for rescuing the hostage.")
									else
										addcash(players[i], 3000, "+$3000: Team award for rescuing the hostage.")
									end
								end
							elseif reasoning == "timeranout" then
								if gametype.Value == "competitive" then
									addcash(players[i], 3250, "+$3250: Team award for running down the clock.")
								else
									addcash(players[i], 2700, "+$2700: Team award for running down the clock.")
								end
							end
						elseif players[i].Status.Team.Value == "T" then
							if gametype.Value == "competitive" then
								if reasoning == "timeranout" and players[i].Status.Alive.Value == true then
									addcash(players[i], 0, "+$0: No income for running down the clock.")
								else
									local losingstreak = tlosingstreak
									if losingstreak == 1 then
										addcash(players[i], 1400, "+$1400: Income for losing.")
									elseif losingstreak == 2 then
										addcash(players[i], 1900, "+$1900: Income for losing for 2 rounds in a row.")
									elseif losingstreak == 3 then
										addcash(players[i], 2400, "+$2400: Income for losing for 3 rounds in a row.")
									elseif losingstreak == 4 then
										addcash(players[i], 2900, "+$2900: Income for losing for 4 rounds in a row.")
									elseif losingstreak >= 5 then
										addcash(players[i], 3400, "+$3400: Income for losing for more than 5 rounds in a row.")
									end										
								end
							else
								if reasoning == "timeranout" and players[i].Status.Alive.Value == true then
									addcash(players[i], 0, "+$0: No income for running down the clock.")
								else
									addcash(players[i], 2400, "+$2400: Income for losing.")								
								end
							end
							if game.Workspace.Status.Armed.Value == true then
								if gametype.Value == "competitive" then
									addcash(players[i], 800, "+$800: Team award for planting the bomb.")
								else
									addcash(players[i], 200, "+$200: Team award for planting the bomb.")
								end
							end
						end
					end
				end
			else
				tlosingstreak = 0
				ctlosingstreak = ctlosingstreak + 1
				local maxscore = 0
				local players = game.Players:GetPlayers()
				for i = 1, #players do
					if players[i] and players[i]:FindFirstChild("Status") and players[i].Status.Team.Value == "T" then
						if players[i].Status.Score.Value >= maxscore then
							maxscore = players[i].Status.Score.Value
							game.Workspace.Status.MVP.Value = players[i].Name
							game.Workspace.Status.MVP.Reason.Value = players[i].Status.Score.Reasoning.Value
							game.Workspace.Status.MVP.ID.Value = players[i].userId
						end
					end
				end
				game.ReplicatedStorage.Events.Audio:FireAllClients("Finish", "T")
				workspace.Sounds.T:Play()
				game.Workspace.Status.TWins.Value = game.Workspace.Status.TWins.Value + 1
				game.Workspace.Status.TLost.Value = 0
				game.Workspace.Status.CTLost.Value = game.Workspace.Status.CTLost.Value + 1
				local players = game.Players:GetPlayers()
				for i = 1, #players do
					if players[i]:FindFirstChild("Status") then
						if players[i].Status.Team.Value == "T" then
							if reasoning == "elimination" then
								if game.Workspace.Map.Gamemode.Value == "defusal" then
									if gametype.Value == "competitive" then
										addcash(players[i], 3250, "+$3250: Team award for eliminating the enemy team.")
									else
										addcash(players[i], 2700, "+$2700: Team award for eliminating the enemy team.")
									end
								else
									if gametype.Value == "competitive" then
										addcash(players[i], 3000, "+$3000: Team award for eliminating the enemy team.")
									else
										addcash(players[i], 2000, "+$2000: Team award for eliminating the enemy team.")
									end										
								end
							elseif reasoning == "exploded" then
								if gametype.Value == "competitive" then
									addcash(players[i], 3500, "+$3500: Team award for detonating the bomb.")
								else
									addcash(players[i], 2700, "+$2700: Team award for detonating the bomb.")
								end
							elseif reasoning == "timeranout" then
								if gametype.Value == "competitive" then
									addcash(players[i], 3250, "+$3250: Team award for running down the clock.")
								else
									addcash(players[i], 2000, "+$2000: Team award for running down the clock.")
								end
							end
						elseif players[i].Status.Team.Value == "CT" then
							if game.Workspace.Status.FirstTime.Value == true then
								if players[i] then
									addcash(players[i], 150, "+$150: Award for carrying the hostage.")
								end
							end
							if gametype.Value == "competitive" then
								if reasoning == "timeranout" and players[i].Status.Alive.Value == true then
									addcash(players[i], 0, "+$0: No income for running down the clock.")
								else
									local losingstreak = ctlosingstreak
									if losingstreak == 1 then
										addcash(players[i], 1400, "+$1400: Income for losing.")
									elseif losingstreak == 2 then
										addcash(players[i], 1900, "+$1900: Income for losing for 2 rounds in a row.")
									elseif losingstreak == 3 then
										addcash(players[i], 2400, "+$2400: Income for losing for 3 rounds in a row.")
									elseif losingstreak == 4 then
										addcash(players[i], 2900, "+$2900: Income for losing for 4 rounds in a row.")
									elseif losingstreak >= 5 then
										addcash(players[i], 3400, "+$3400: Income for losing for more than 5 rounds in a row.")
									end
								end
							else
								if reasoning == "timeranout" and players[i].Status.Alive.Value == true then
									addcash(players[i], 0, "+$0: No income for running down the clock.")
								else
									addcash(players[i], 2400, "+$2400: Income for losing.")
								end
							end
						end
					end
				end
			end
		else
			if gt.Value == "TTT" then
			---------------TTT
				game.Workspace.RoundEnd:Play()
				if tttwincheck() == "traitor" then
					game.ReplicatedStorage.Events.Audio:FireAllClients("Finish", "CT")
					feed.Value = "The dastardly traitors won the round!"
				else
					if tttwincheck() == "timeranout" then
						feed.Value = "The traitors ran out of time and lost!"
					else
						feed.Value = "The lovable innocent terrorists won the round!"
					end
					game.ReplicatedStorage.Events.Audio:FireAllClients("Finish", "T")
				end
			else
				game.ReplicatedStorage.Events.Audio:FireAllClients("Finish", "DM")
			end
		end
		if game.Players:FindFirstChild(game.Workspace.Status.MVP.Value) and game.Players:FindFirstChild(game.Workspace.Status.MVP.Value):FindFirstChild("Status") then
			game.Players:FindFirstChild(game.Workspace.Status.MVP.Value).Status.MVPs.Value = game.Players:FindFirstChild(game.Workspace.Status.MVP.Value).Status.MVPs.Value + 1
			game.Players:FindFirstChild(game.Workspace.Status.MVP.Value).Score.Value = game.Players:FindFirstChild(game.Workspace.Status.MVP.Value).Score.Value + 1	
		end
		local players = game.Players:GetPlayers()
		game.Workspace.Status.BuyTime.Value = 0

		if gt.Value == "TTT" then
			timer.Value = 15
			while timer.Value > 0 do
				wait(1)
				workspace.Status.PlayerChanged.Value = workspace.Status.PlayerChanged.Value + 1
				timer.Value = timer.Value - 1
				if timer.Value == 14 then
					feed.Value = "Let's look at the round report for 15 seconds."
				end
			end
		else
			if gt.Value == "deathmatch" then
				game.Workspace.Status.Preparation.Value = true
			end
			local notimertimer = 8 --doesnt display timer, this is for the end-game 
			while notimertimer > 0 do
				wait(1)
				updatelocations(locations)
				workspace.Status.PlayerChanged.Value = workspace.Status.PlayerChanged.Value + 1
				notimertimer = notimertimer - 1
			end
			game.Workspace.Status.Preparation.Value = false
		end
		
		--game.ReplicatedStorage.Events.UpdateUI:FireAllClients({"Cleanup"})	
		if game.Workspace:FindFirstChild("C4") then
			game.Workspace.C4:Destroy()
		end
		--END OF GAME
		--Halloween Sights
	--[[	spawn(function()
			if string.find(mapname,"hw_") then
				local players = game.Players:GetPlayers()
				for i=1, #players do
					if players[i]:FindFirstChild("TheSights") then
						if players[i].TheSights:FindFirstChild(mapname) == nil then						
							local str = Instance.new("StringValue")
							str.Name = mapname		
							str.Parent = players[i].TheSights						
							local amount = #players[i].TheSights:GetChildren()
							if amount >= 4 then
								if BadgeService:UserHasBadgeAsync(players[i].UserId, 2124440051) == false then
									BadgeService:AwardBadge(players[i].UserId, 2124440051)
								end	
							end
						end
					end
				end
			end
		end) ]]
		
		if game.Workspace.Status.TWins.Value >= roundsneededtowin or game.Workspace.Status.CTWins.Value >= roundsneededtowin then
			if (game.VIPServerId == "" or string.len(tostring(game.VIPServerId)) == 0) and #game.Players:GetChildren() >= 5 then
				if game.Workspace.Status.TWins.Value >= roundsneededtowin then
					for _, v in pairs(game.Players:GetChildren()) do
						spawn(function()
							pcall(function()
								if v.Status.Team.Value == "T" then
									local earned = 10
									
									pcall(function()		
										if marketplaceservice:PlayerOwnsAsset(v, 892333274) then
											earned = 15
										end	
									end)					
									if gt.Value == "competitive" then
										earned = earned * 2
									end
									currencyData:UpdateAsync(tostring(v.userId), function(oldValue)			
										local newValue = oldValue		
										newValue = newValue + earned
										v.SkinFolder.Funds.Value = newValue			
										return newValue
									end)
								end
							end)
						end)
					end
				else
					for _, v in pairs(game.Players:GetChildren()) do
						spawn(function()
							pcall(function()
								if v.Status.Team.Value == "CT" then
									local earned = 10
															
									pcall(function()		
										if marketplaceservice:PlayerOwnsAsset(v, 892333274) then
											earned = 15
										end	
									end)					
									if gt.Value == "competitive" then
										earned = earned * 2
									end								
									currencyData:UpdateAsync(tostring(v.userId), function(oldValue)			
										local newValue = oldValue		
										newValue = newValue + earned
										v.SkinFolder.Funds.Value = newValue			
										return newValue
									end)
								end
							end)
						end)
					end
				end
			end
			break
		end
		if game.ServerScriptService.VIPMENU.STOP.Value == true then
			game.ServerScriptService.VIPMENU.STOP.Value = false
			break
		end
	end
	--	print("cleanup activated... time to loop")
	wait()
	doGame()
end

doGame()