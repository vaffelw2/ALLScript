local Camera=game.Workspace.CurrentCamera
if Camera:FindFirstChild("Debris") then
Camera.Debris:Destroy()
end
local niga=Instance.new("Folder")
niga.Parent=Camera
niga.Name="Debris"









local mfloor = math.floor
local mmax = math.max
local mabs = math.abs
local mrandom = math.random
local mrad = math.rad
local Cnew = Color3.new


script.Parent:WaitForChild("GUI"):WaitForChild("hurtOverlay").Position=UDim2.new(-1.293, 0,-1.293, -22)
script.Parent:WaitForChild("GUI"):WaitForChild("hurtOverlay").Size=UDim2.new(3.413, 0,3.563, 30)
script.Parent:WaitForChild("GUI"):WaitForChild("Bin"):ClearAllChildren()

if game.Players.LocalPlayer.Status.Team.Value ~= "Spectator" then
game.Workspace:WaitForChild(game.Players.LocalPlayer.Name)
repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso")
and game.Players.LocalPlayer.Character:FindFirstChild("Head")
and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
else
wait(.1)
end



local gui = script.Parent:WaitForChild("GUI")

local playergui = gui.Parent
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local rs = game:GetService("RunService")

local frTemplate = game.Lighting:WaitForChild("Frame")

local camera = workspace.CurrentCamera
local radius = 100


local character=game.Players.LocalPlayer.Character
local mse=game.Players.LocalPlayer:GetMouse()
local humanoid
while game.Players.LocalPlayer.Character==nil do
	wait()
end
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
humanoid=game.Players.LocalPlayer.Character.Humanoid
end

-- Helper functions




function angleBetweenPoints(p0, p1)
	local p = p0 - p1
	return -math.atan2(p.z, p.x)
end

function getCameraAngle(camera)
	local cf, f = camera.CoordinateFrame, camera.Focus
	return angleBetweenPoints(cf.p, f.p)
end

-- Indicator class

local Indicator = {}
Indicator.all = {}

function Indicator:new(position)
	local newIndicator = newIndicator or {}
	
	-- Properties
	newIndicator.time = (3.2*mmax(0.5,(damagedone/100))) or 1
	newIndicator.position = humanoid:FindFirstChild("creator").Value.Character:FindFirstChild("UpperTorso").Position or Vector3.new()

	newIndicator.timeCreated = tick()
	newIndicator.timeExpire = tick() + newIndicator.time
	newIndicator.alive = true
	
	newIndicator.frame = frTemplate:clone()
	newIndicator.frame.Parent = gui:WaitForChild("Bin")
	newIndicator.frame.Archivable = false
	setmetatable(newIndicator, Indicator)
	self.__index = self
	table.insert(Indicator.all, newIndicator)
	
	newIndicator:update2()
	
	return newIndicator
end

function Indicator:expire()
	self.alive = false
	
	-- Cleanup resources
	self.frame:Destroy()
	
	-- Remove from all
	for i = 1, #Indicator.all do
		if self == Indicator.all[i] then
			table.remove(Indicator.all, i)
			break
		end
	end
end

function Indicator:setAngle(angleRadians)
	if not self.alive then return end
	
	local angleDegrees = angleRadians * (180 / math.pi)
	self.frame.Position = UDim2.new(
			.5,
			math.cos(angleRadians) * radius + self.frame.AbsoluteSize.X / -2,
			.5,
			math.sin(angleRadians) * radius + self.frame.AbsoluteSize.Y / -2
		)
	self.frame.Rotation = angleDegrees + 90
end

function Indicator:update()
	if tick() >= self.timeExpire then
		self:expire()
	else
		local perc = (tick() - self.timeCreated) / self.time
		self:setAngle(getCameraAngle(camera) - angleBetweenPoints(camera.Focus.p, self.position) - math.pi / 2)

		self.frame.ImageLabel.ImageTransparency = perc
		self.frame.ImageLabel.Size = UDim2.new(0, 350, 0, 350 * (1 - perc))
	end
end
function Indicator:update2()
	if tick() >= self.timeExpire then
		self:expire()
	else
		local perc = (tick() - self.timeCreated) / self.time
		self:setAngle(getCameraAngle(camera) - angleBetweenPoints(camera.Focus.p, self.position) - math.pi / 2)

		self.frame.ImageLabel.ImageTransparency = perc
		self.frame.ImageLabel.Size = UDim2.new(0, 350, 0, 350 * (1 - perc))
	end
end

function Indicator:updateAll()
	local i = 1
	while i <= #Indicator.all do
		rs.Heartbeat:wait()
		local indicator = Indicator.all[i]
		indicator:update()
		if indicator.alive then
			i = i + 1
		end
	end
end

-- Update camera if it changes


		camera = workspace.CurrentCamera




-- Hook up CreateIndicator bindable function



-- Start update loop



-- 10/15/2014 12:33 AM

---


lastHealth=100
damagedone=100
function AnimateHurtOverlay()
	
-- Start:
-- overlay.Position = UDim2.new(0, 0, 0, -22)
-- overlay.Size = UDim2.new(1, 0, 1.15, 30)

-- Finish:
-- overlay.Position = UDim2.new(-2, 0, -2, -22)
-- overlay.Size = UDim2.new(4.5, 0, 4.65, 30)

local overlay = gui.hurtOverlay
overlay.Position = UDim2.new(-2, 0, -2, -22)
overlay.Size = UDim2.new(4.5, 0, 4.65, 30)
-- Animate In, fast
local i_total = 2
local wiggle_total = 0
local wiggle_i = 0.02
for i=1,i_total do
overlay.Position = UDim2.new( (-2 + (2 * (i/i_total)) + wiggle_total/2), 0, (-2 + (2 * (i/i_total)) + wiggle_total/2), -22 )
overlay.Size = UDim2.new( (4.5 - (3.5 * (i/i_total)) + wiggle_total), 0, (4.65 - (3.5 * (i/i_total)) + wiggle_total), 30 )
local starttick=tick() repeat rs.Heartbeat:wait() until (tick()-starttick)>=0.01
end
i_total = 30




if humanoid then
if humanoid:FindFirstChild("creator") then
if humanoid:FindFirstChild("creator").Value then
	if humanoid:FindFirstChild("creator").Value.Character then
	if humanoid:FindFirstChild("creator").Value.Character:FindFirstChild("UpperTorso") then
	Indicator:new{}

	end	
	end
end
end
end
local starttick=tick() repeat rs.Heartbeat:wait() until (tick()-starttick)>=0.1

-- Animate Out, slow
for i=1,i_total do
if( mabs(wiggle_total) > (wiggle_i * 3) ) then
wiggle_i = -wiggle_i
end
wiggle_total = wiggle_total + wiggle_i
overlay.Position = UDim2.new( (0 - (2 * (i/i_total)) + wiggle_total/2), 0, (0 - (2 * (i/i_total)) + wiggle_total/2), -22 )
overlay.Size = UDim2.new( (1 + (3.5 * (i/i_total)) + wiggle_total), 0, (1.15 + (3.5 * (i/i_total)) + wiggle_total), 30 )
local starttick=tick() repeat rs.Heartbeat:wait() until (tick()-starttick)>=0.01
end

-- Hide after we're done
overlay.Position = UDim2.new(10, 0, 0, 0)
end


local AltRoll = false
local IsRoll = false
local Multi = 1
local Camera = game.Workspace.CurrentCamera
function RotCamera(RotX, RotY, SmoothRot, Duration)
	spawn(function()
		if SmoothRot then

			
			local Step = math.min(1.5 / mmax(Duration, 0), 90)
			local X = 0
			while rs.RenderStepped:wait() do
				local NewX = X + Step
				X = (NewX > 90 and 90 or NewX)
				

				if Camera.CoordinateFrame.lookVector.Y > 0.98 then		
					break 
				end
				local CamRot = Camera.CoordinateFrame - Camera.CoordinateFrame.p
				local CamDist = (Camera.CoordinateFrame.p - Camera.Focus.p).magnitude
				local NewCamCF = CFrame.new(Camera.Focus.p) * CamRot * CFrame.Angles(RotX / (90 / Step), 0, 0)
				Camera.CoordinateFrame = CFrame.new(NewCamCF.p, NewCamCF.p + NewCamCF.lookVector) * CFrame.new(0, 0, CamDist)
				
				if X == 90 then break end
			end

		else
			local CamRot = Camera.CoordinateFrame - Camera.CoordinateFrame.p
			local CamDist = (Camera.CoordinateFrame.p - Camera.Focus.p).magnitude
			local NewCamCF = CFrame.new(Camera.Focus.p) * CamRot * CFrame.Angles(RotX, 0, 0)
			Camera.CoordinateFrame = CFrame.new(NewCamCF.p, NewCamCF.p + NewCamCF.lookVector) * CFrame.new(0, 0, CamDist)
		end
	end)
end

function RAND(Min, Max, Accuracy)
	local Inverse = 1 / (Accuracy or 1)
	return (mrandom(Min * Inverse, Max * Inverse) / Inverse)
end


function ShakeCam(Recoil)
	if game.ReplicatedStorage.gametype.Value=="juggernaut" and player.Status.Team.Value=="T" then
		return
	end
	local CurrentRecoil =  Recoil*0.25
	local RecoilX = math.rad(CurrentRecoil)
	local RecoilY = 0
	RotCamera(RecoilX, RecoilY, false, 0.005)
	RotCamera(-RecoilX, -RecoilY, true, 0.4)
end




function healthGUIUpdate(health)
	damagedone=lastHealth-health
		if damagedone > 5 then
			print(damagedone)
			if humanoid and humanoid:FindFirstChild("creator") and humanoid.creator:FindFirstChild("Flinch") or rs:IsStudio() then
				if rs:IsStudio() or humanoid.creator:FindFirstChild("HEADSHOT") and player:FindFirstChild("Helmet")==nil or humanoid.creator:FindFirstChild("HEADSHOT")==nil and player:FindFirstChild("Kevlar")==nil then
					spawn(function()
						if game:GetService("RunService"):IsStudio() then
							--print("aimpunch")
						end
						ShakeCam(damagedone)
					end)
				end
			end
			if humanoid.Health ~= humanoid.MaxHealth then
				spawn(function()
					AnimateHurtOverlay()
				end)
			end
		end
	lastHealth = health
end


character:WaitForChild("Humanoid").HealthChanged:connect(function()
	wait()
	healthGUIUpdate(character.Humanoid.Health)
end)



while wait() do
    Indicator:updateAll()
end



