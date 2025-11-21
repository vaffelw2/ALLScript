
--[[
-- Disabled for now...
if not game:GetService("RunService"):IsStudio() then
	script.Disabled = true
end]]--
local char = script.Parent
local sound = char:WaitForChild("Sound")
local hum = char:WaitForChild("Humanoid")
local currentLadder = nil
-- No need for this script if there are no ladders on the map
if game.Workspace:FindFirstChild("Map") and (game.Workspace["Map"]:FindFirstChild("Ignore")==nil or (game.Workspace["Map"]:FindFirstChild("Ignore") and game.Workspace["Map"]["Ignore"]:FindFirstChild("LadderDetector")==nil)) then
	script.Disabled = true
end


spawn(function()
	if game.Workspace:FindFirstChild("Map") and game.Workspace.Map:FindFirstChild("Ignore") then

		for _, v in pairs(game.Workspace.Map.Ignore:GetChildren()) do
			if v.Name == "LadderDetector" then
				v.Touched:connect(function(hit)
					if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name==script.Parent.Name and not currentLadder then
						--print("biggie dab")
						local char = hit.Parent
						currentLadder = v
						local humRootPart = char:FindFirstChild("HumanoidRootPart")
						
						if not char:FindFirstChild("HumanoidRootPart"):FindFirstChild("BodyPosition") then
							local bp = Instance.new("BodyPosition")
							bp.D = 500
							bp.P = 5000
							local pos = v.Position + -v.CFrame.upVector * (v.Position.Y - humRootPart.Position.Y)
							local y = humRootPart.Position.Y
							y=humRootPart.Position.Y-v.Position.Y
							--print(v.Position.Y - v.Size.Y/2, hit.Parent:FindFirstChild("LeftFoot").Position.Y)
							if (v.Position - v.CFrame.upVector * v.Size.Y/2).Y > (hit.Parent:FindFirstChild("LeftFoot").Position.Y - 0.15) then
								--print("adjusting height")
								--y = v.Position.Y - v.Size.Y/2 + (humRootPart.Position.Y - hit.Parent:FindFirstChild("LeftFoot").Position.Y) + 0.25
								pos = pos + Vector3.new(0, humRootPart.Position.Y - hit.Parent:FindFirstChild("LeftFoot").Position.Y, 0)
							end
							if y > 150 then
								y	= 150
							end
							bp.Position = Vector3.new(v.Position.X, v.Position.Y+y, v.Position.Z)
							bp.MaxForce = Vector3.new(40000, 40000, 40000)
							bp.Parent = char:FindFirstChild("HumanoidRootPart")
						end
					end
				end)
			end
		end
	end
end)
	

local humRootPart = char:WaitForChild("HumanoidRootPart")
local lowerTorso = char:WaitForChild("LowerTorso")
local head = char:WaitForChild("Head")



local cam = game.Workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local mouse = game.Players:GetPlayerFromCharacter(char):GetMouse()
local bp = nil
local justAttached = false
local climbingSound = false
local mrandom = math.random

local deg, atan2, abs = math.deg, math.atan2, math.abs

-- Can't climb anymore the default way ¯\_(ツ)_/¯
hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)

local playSound = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PlaySound")
local function playClimbingSound()
	if not climbingSound then
		climbingSound = true
		spawn(function()
			--playSound:FireServer(char.UpperTorso, sound["Ladder"..mrandom(1, 4)])
			--sound["Ladder"..mrandom(1, 4)]:Play()
			wait(0.6)
			climbingSound = false
		end)
	end
end

-- Retrieves the angle between two given vectors
local function getAngle(u, v)
	local x = deg(atan2(u.x, u.z) - atan2(v.x, v.z))
	-- Constrains the x from [-180, 180) or [-pi/2, pi/2)
	if x >= -360 and x <= -180 then
		x = x + 360
	elseif x > 180 then
		x = x - 360
	end
	
	return x
end

local function isHeadTouchingLadder()
	for _, v in pairs(char.Head:GetTouchingParts()) do
		if v.Name == "LadderDetector" then
			return true
		end
	end
	return false
end

local function isFootTouchingLadder()
	for _, v in pairs(char.LeftFoot:GetTouchingParts()) do
		if v.Name == "LadderDetector" then
			return true
		end
	end
	for _, v in pairs(char.RightFoot:GetTouchingParts()) do
		if v.Name == "LadderDetector" then
			return true
		end
	end
	return false
end

local function detach()
	delay(0.5, function()
		if currentLadder then
			currentLadder = nil
		end
	end)
	--hum.WalkSpeed = 16
	if bp then
		bp:Destroy()
		bp = nil
	end
end

local bodyParts = {}
humRootPart.ChildAdded:connect(function(child)
	if child.Name == "BodyPosition" and child:IsA("BodyPosition") then
		local angle = abs(getAngle(currentLadder.CFrame.lookVector, cam.CFrame.lookVector))
		--print(angle)
		
		if isHeadTouchingLadder() and 
			(char.HumanoidRootPart.Velocity.Magnitude < 0.5
			or (angle > 35 and UIS:IsKeyDown(Enum.KeyCode.W))
			or ((angle > 120 or angle < 35) and (UIS:IsKeyDown(Enum.KeyCode.A) or UIS:IsKeyDown(Enum.KeyCode.D)))
			or (angle < 145 and UIS:IsKeyDown(Enum.KeyCode.S))) then
			
			child.MaxForce = Vector3.new(0, 0, 0)
			delay(1/60, function()
				child:Destroy()
			end)
			detach()
			return
		end
		
		justAttached = true
		--hum.WalkSpeed = 0
		
		if humRootPart:FindFirstChild("Mover") then
			humRootPart:FindFirstChild("Mover"):Destroy()
		end
		spawn(function()
			for i = 500, 300, -5 do
				if not child then break end
				child.D = i
				RunService.RenderStepped:wait()
			end
		end)
		bp = child
		hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
		delay(0.5, function()
			justAttached = false
			for _, v in pairs(bodyParts) do
				v.CanCollide = true
			end
			bodyParts = {}
		end)
	end
end)

humRootPart.ChildRemoved:connect(function(child)
	if child:IsA("BodyPosition") then
		bp = nil
		hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
	end
end)

--local function controlLadderMovement()
	--print("bp:", tostring(bp ~= nil), "; climbing:", tostring(currentLadder ~= nil))
	--if bp and currentLadder and (not justAttached or (justAttached and not UIS:IsKeyDown(Enum.KeyCode.A) and not UIS:IsKeyDown(Enum.KeyCode.D))) then

--end

--game:GetService("RunService"):BindToRenderStep("ClientLoop", Enum.RenderPriority.First, controlLadderMovement)
w, a, s, d = UIS:IsKeyDown(Enum.KeyCode.W), UIS:IsKeyDown(Enum.KeyCode.A), UIS:IsKeyDown(Enum.KeyCode.S), UIS:IsKeyDown(Enum.KeyCode.D)
UIS.InputEnded:connect(function(key,gpe)
	if not gpe then
		w, a, s, d = UIS:IsKeyDown(Enum.KeyCode.W), UIS:IsKeyDown(Enum.KeyCode.A), UIS:IsKeyDown(Enum.KeyCode.S), UIS:IsKeyDown(Enum.KeyCode.D)
	end
end)
UIS.InputBegan:connect(function(key, gpe)
	if not gpe then
		if key.KeyCode == Enum.KeyCode.E or key.KeyCode == Enum.KeyCode.Space then
			if currentLadder then
				detach()
			else
				if mouse.Target and mouse.Target.Name == "LadderDetector" and (humRootPart.Position - mouse.Hit.p).magnitude <= 7 and not currentLadder then
					local target = mouse.Target
					--print("biggie dab")
					local char = script.Parent
					currentLadder = target
					local v=target
					local humRootPart = char:FindFirstChild("HumanoidRootPart")
					local hit=script.Parent.Head
					if not char:FindFirstChild("HumanoidRootPart"):FindFirstChild("BodyPosition") then
						local bp = Instance.new("BodyPosition")
						bp.D = 500
						bp.P = 5000
						local pos = v.Position + -v.CFrame.upVector * (v.Position.Y - humRootPart.Position.Y)
						local y = humRootPart.Position.Y
						--print(v.Position.Y - v.Size.Y/2, hit.Parent:FindFirstChild("LeftFoot").Position.Y)
						if (v.Position - v.CFrame.upVector * v.Size.Y/2).Y > (hit.Parent:FindFirstChild("LeftFoot").Position.Y - 0.15) then
							--print("adjusting height")
							--y = v.Position.Y - v.Size.Y/2 + (humRootPart.Position.Y - hit.Parent:FindFirstChild("LeftFoot").Position.Y) + 0.25
							pos = pos + Vector3.new(0, humRootPart.Position.Y - hit.Parent:FindFirstChild("LeftFoot").Position.Y, 0)
						end
						bp.Position = Vector3.new(v.Position.X, y, v.Position.Z)
						bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
						bp.Parent = char:FindFirstChild("HumanoidRootPart")
					end				
					--[[local mover = Instance.new("BodyPosition")
					mover.Name = "Mover"
					mover.D = 500
					mover.P = 5000	
					local y = humRootPart.Position.Y
					--print(script.Parent.Position.Y - script.Parent.Size.Y/2, hit.Parent:FindFirstChild("LeftFoot").Position.Y)
					if target.Position.Y - target.Size.Y/2 > (char:FindFirstChild("LeftFoot").Position.Y - 0.15) then
						--print("adjusting height")
						y = target.Position.Y - target.Size.Y/2 + (humRootPart.Position.Y - char:FindFirstChild("LeftFoot").Position.Y) + 0.1
					end
					mover.Position = Vector3.new(target.Position.X, y, target.Position.Z)
					mover.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
					mover.Parent = humRootPart]]
				end
			end
		elseif (key.KeyCode == Enum.KeyCode.W or key.KeyCode == Enum.KeyCode.A or key.KeyCode == Enum.KeyCode.S or key.KeyCode == Enum.KeyCode.D) then
			w, a, s, d = UIS:IsKeyDown(Enum.KeyCode.W), UIS:IsKeyDown(Enum.KeyCode.A), UIS:IsKeyDown(Enum.KeyCode.S), UIS:IsKeyDown(Enum.KeyCode.D)
		end
	end
end)











while true do
	local delta=game:GetService("RunService").Heartbeat:wait()
	if bp and currentLadder then
		if char:FindFirstChild("Climbing")==nil then
			local bap=Instance.new("IntValue")
			bap.Parent=char
			bap.Name="Climbing"
		end
	else
		if char:FindFirstChild("Climbing") then
			char.Climbing:Destroy()
		end
	end
	if bp and currentLadder then
		local stop=false
		local footTouchingLadder = isFootTouchingLadder()
		local magn = hum.WalkSpeed*delta
		local dir = cam.CFrame.lookVector:Dot(currentLadder.CFrame.rightVector)
		if (w and cam.CFrame.lookVector.Y >= 0) 
		or (s and cam.CFrame.lookVector.Y < 0)
		or (a and dir >= 0) 
		or (d and dir < 0) then
			local ray = Ray.new(head.Position, Vector3.new(0, 1, 0))
			local hit = workspace:FindPartOnRayWithWhitelist(ray, {game.Workspace.Map.Geometry})
			
			--print("Up:", hit)
			if not hit or hit and hit.CanCollide==false then
				bp.Position = bp.Position + currentLadder.CFrame.upVector*magn
				if hum.WalkSpeed>10 then
					playClimbingSound()
				end
			end
		elseif (w and cam.CFrame.lookVector.Y < 0) 
			or (s and cam.CFrame.lookVector.Y >= 0) 
			or (a and dir < 0) 
			or (d and dir >= 0) then
			local ray = Ray.new(lowerTorso.Position, Vector3.new(0, -4, 0))
			local hit = workspace:FindPartOnRayWithWhitelist(ray, {game.Workspace.Map.Geometry})
			
			--print("Down:", hit)
			if not hit or hit and hit.CanCollide==false then
				bp.Position = bp.Position - currentLadder.CFrame.upVector*magn
				if hum.WalkSpeed>10 then
					playClimbingSound()
				end
			else
				stop=true
			end
		end
		
		if not footTouchingLadder and not justAttached and not justAttached or stop==true then
			--print("detaching")		
			detach()
		end
	end
end