repeat wait(1) until game.Players:GetPlayerFromCharacter(script.Parent)~=nil
local running=false
local headComponents = script:GetChildren()


local steps=0


local Figure = script.Parent
local Head = Figure:WaitForChild("Humanoid")
local Humanoid = Figure:WaitForChild("Humanoid")
local hasPlayer = game.Players:GetPlayerFromCharacter(script.Parent)
local filteringEnabled = game.Workspace.FilteringEnabled

local prevState = "Run"
local velocity=script.Parent:WaitForChild("UpperTorso").Velocity.magnitude


local fallCount = 0
local fallSpeed = 0


function onStateNoStop(state, sound)
	if state then
		mainfootstep()
	end
end
local lastnum=1
function triggerfootstep(material,num)
	local chosen=1
	local numbers={}
	for i=1,num do
	table.insert(numbers,i)
    end
	if numbers[lastnum] then
	table.remove(numbers,lastnum)
    end

chosen=numbers[math.random(1,#numbers)]
lastnum=chosen
local sound=material..chosen
if script:FindFirstChild(sound) and script.Parent:FindFirstChild("UpperTorso") then
steps=steps+1
if steps>=5 then
	if script.Parent:FindFirstChild("ForceField") then
		script.Parent.ForceField:Destroy()
	end
end
local shit=script[sound]:clone()
shit.Name="Playing"
shit.Parent=script.Parent.UpperTorso
--[[shit.PlayOnRemove=true
shit:Destroy()]]
shit:Play()
delay(shit.TimeLength,function()
shit:Destroy()
end)
end	
end

function mainfootstep()
if prevState=="Run" and game.Workspace:FindFirstChild("Map") and game.Workspace.Map:FindFirstChild("Geometry") then
local ray = Ray.new(Humanoid.Parent:WaitForChild("UpperTorso").Position,Vector3.new(0, -3.4, 0))

local part, endPoint = game.Workspace:FindPartOnRayWithWhitelist(ray, {game.Workspace.Terrain,game.Workspace.Map.Geometry})

local material=nil
if part then
	if part:IsA("Terrain") then
	material=Enum.Material.Sand
	else
	material=part.Material
	end
end


if part and part.Parent and part.Parent.Parent and part.Parent:FindFirstChild("Humanoid")==nil and part.Parent.Parent:FindFirstChild("Humanoid")==nil then 
	if material==Enum.Material.LeafyGrass or material==Enum.Material.Ground or material==Enum.Material.Grass then
	triggerfootstep("Grass",6)
	elseif material==Enum.Material.Wood then
	triggerfootstep("Wood",8)
	elseif material==Enum.Material.WoodPlanks then
	triggerfootstep("Wood",8)
	elseif material==Enum.Material.Brick or material==Enum.Material.Cobblestone or material==Enum.Material.Marble or material==Enum.Material.SmoothPlastic or material==Enum.Material.Plastic then
	triggerfootstep("Conc",8)
	elseif material==Enum.Material.CorrodedMetal then
	triggerfootstep("Metal",8)
	elseif material==Enum.Material.Concrete then
	triggerfootstep("Conc",8)
	elseif material==Enum.Material.Pebble or material==Enum.Material.Mud then
	triggerfootstep("Dirt",8)
	elseif material==Enum.Material.Fabric or material==Enum.Material.Sand then
	triggerfootstep("Sand",8)
	elseif material==Enum.Material.Slate or material==Enum.Material.Granite then
	triggerfootstep("Sand",8)
	elseif material==Enum.Material.Metal then
	triggerfootstep("Metal",8)
	elseif material==Enum.Material.DiamondPlate or material==Enum.Material.Neon or material==Enum.Material.Ice then
	triggerfootstep("Metal",8)
	elseif material==Enum.Material.Water then
	triggerfootstep("Wade",6)
	else
	triggerfootstep("Conc",4)
	end
end
elseif prevState=="Swim" then
triggerfootstep("Wade",6)
elseif prevState=="Climb" then
triggerfootstep("Ladder",4)
end
end



function onSwimming(speed)
	if (prevState ~= "Swim" and speed > 0.1) then
triggerfootstep("Splash",3)
		prevState = "Swim"
		running=true
	end

end

function onClimbing(speed)

	prevState = "Climb"
end


Humanoid.Swimming:connect(onSwimming)
Humanoid.Climbing:connect(onClimbing)
Humanoid.Running:connect(function() prevState="Run" end)

Humanoid.Parent:WaitForChild("UpperTorso")
local HasBeenMoving = false -- Microstepping / Nudging debounce

while true do
	if Humanoid and Humanoid.Parent and Humanoid.Parent:FindFirstChild("UpperTorso") and Humanoid.Parent.UpperTorso.Velocity.magnitude > 10 then
		if HasBeenMoving == false then
		wait(.09)
		if Humanoid.Parent.UpperTorso.Velocity.magnitude > 11 then
		wait(5/math.max(10,Humanoid.Parent.UpperTorso.Velocity.magnitude))
		mainfootstep()
		end
		HasBeenMoving = true
		else
		wait(5/math.max(10,Humanoid.Parent.UpperTorso.Velocity.magnitude))
		mainfootstep()
		end
	else
		wait()
		HasBeenMoving = false
	end
end