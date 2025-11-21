--[[
	// FileName: MasterControl
	// Version 1.0
	// Written by: jeditkacheff
	// Description: All character control scripts go thru this script, this script makes sure all actions are performed
--]]

--[[ Local Variables ]]--
local MasterControl = {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')

local HasVRAPI = pcall(function() return UserInputService.VREnabled and UserInputService.GetUserCFrame end)

while not Players.LocalPlayer do
	wait()
end
local LocalPlayer = Players.LocalPlayer
local CachedHumanoid = nil
local RenderSteppedCon = nil
local SeatedCn = nil
local moveFunc = LocalPlayer.Move

local isJumping = false
local isSeated = false
local myVehicleSeat = nil
local moveValue = Vector3.new(0,0,0)
local moveValue2 = Vector3.new(0,0,0)
local lastmove = Vector3.new(0,0,0)
--[[ Local Functions ]]--
local function getHumanoid()
	local character = LocalPlayer and LocalPlayer.Character
	if character then
		if CachedHumanoid and CachedHumanoid.Parent == character then
			return CachedHumanoid
		else
			CachedHumanoid = nil
			for _,child in pairs(character:GetChildren()) do
				if child:IsA('Humanoid') then
					CachedHumanoid = child
					return CachedHumanoid
				end
			end
		end
	end
end

--[[ Public API ]]--
function MasterControl:Init()
	
	local renderStepFunc = function()
		if LocalPlayer and LocalPlayer.Character then
			local humanoid = getHumanoid()
			if not humanoid then return end
			if humanoid:GetState()~=Enum.HumanoidStateType.Swimming then
				if isJumping==true then
					if humanoid and humanoid.Parent and humanoid.Parent:FindFirstChild("Stunned")==nil and humanoid.Parent:FindFirstChild("Taunting")==nil  and humanoid.Parent:FindFirstChild("Charging")==nil then
					else
						isJumping=false
					end
				end
			end
			if humanoid and not humanoid.PlatformStand and isJumping then
				humanoid.Jump = isJumping
			end
			if humanoid:GetState()~=Enum.HumanoidStateType.Swimming then
				if isJumping==true then
					isJumping=false
				end
			end
			if LocalPlayer.Character:FindFirstChild("Charging") then
				moveValue2=Vector3.new(0,0,-2)
				humanoid.MaxSlopeAngle = 75
			else
				moveValue2=moveValue
				humanoid.MaxSlopeAngle = 51
			end
			local adjustedMoveValue = moveValue2
			if HasVRAPI and UserInputService.VREnabled and workspace.CurrentCamera.HeadLocked then
				local vrFrame = UserInputService.UserHeadCFrame
				local lookVector = Vector3.new(vrFrame.lookVector.X, 0, vrFrame.lookVector.Z).unit
				local rotation = CFrame.new(Vector3.new(0, 0, 0), lookVector)
				adjustedMoveValue = rotation:vectorToWorldSpace(adjustedMoveValue)
			end
			local state = humanoid:GetState()
			------air control boi
			local percent=(1/3)
			if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall or LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Hyped") or LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("RocketJumped") and LocalPlayer.Character:FindFirstChild("MTL") or LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("changedirection") or LocalPlayer.Character:FindFirstChild("Charging") then
				moveFunc(LocalPlayer, moveValue2, true)
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("changedirection") then
					if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						local direction=""
						local bp=CFrame.Angles(0,0,0)
						if moveValue2.Z==1 then
							direction="s"
						end
						if moveValue2.Z==-1 then
							direction="w"
						end
						if moveValue2.X==-1 then
							direction=direction.."a"
						end
						if moveValue2.X==1 then
							direction=direction.."d"
						end
						if direction=="s" then
							bp=CFrame.Angles(0,math.rad(180),0)
						elseif direction=="a" then
							bp=CFrame.Angles(0,math.rad(90),0)
						elseif direction=="d" then
							bp=CFrame.Angles(0,math.rad(-90),0)
						elseif direction=="sa" then
							bp=CFrame.Angles(0,math.rad(90+45),0)
						elseif direction=="sd" then
							bp=CFrame.Angles(0,math.rad(-(90+45)),0)
						elseif direction=="wa" then
							bp=CFrame.Angles(0,math.rad(45),0)
						elseif direction=="wd" then
							bp=CFrame.Angles(0,math.rad(-45),0)
						end
						if direction~="" then
							LocalPlayer.Character.HumanoidRootPart.Velocity=(LocalPlayer.Character.HumanoidRootPart.CFrame*bp).lookVector*LocalPlayer.Character.Humanoid.WalkSpeed
						end
					end
					LocalPlayer.Character.changedirection:Destroy()
				else
				end
				lastmove=moveValue2
			else
				moveFunc(LocalPlayer, lastmove+(moveValue2*percent), true)
			end
		end
	end
	
	local success = pcall(function() RunService:BindToRenderStep("MasterControlStep", Enum.RenderPriority.Input.Value, renderStepFunc) end)
	
	if not success then
		if RenderSteppedCon then return end
		RenderSteppedCon = RunService.RenderStepped:connect(renderStepFunc)
	end
end

function MasterControl:Disable()
	local success = pcall(function() RunService:UnbindFromRenderStep("MasterControlStep") end)
	if not success then
		if RenderSteppedCon then
			RenderSteppedCon:disconnect()
			RenderSteppedCon = nil
		end
	end
	
	moveValue = Vector3.new(0,0,0)
	isJumping = false
end

function MasterControl:AddToPlayerMovement(playerMoveVector)
	moveValue = Vector3.new(moveValue.X + playerMoveVector.X, moveValue.Y + playerMoveVector.Y, moveValue.Z + playerMoveVector.Z)
end

function MasterControl:GetMoveVector()
	return moveValue
end

function MasterControl:SetIsJumping(jumping)
	isJumping = jumping
end

function MasterControl:DoJump()
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.Jump = true
	end
end

return MasterControl

