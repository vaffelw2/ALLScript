--[[
	// FileName: ShiftLockController
	// Written by: jmargh
	// Version 1.2
	// Description: Manages the state of shift lock mode

	// Required by:
		RootCamera

	// Note: ContextActionService sinks keys, so until we allow binding to ContextActionService without sinking
	// keys, this module will use UserInputService.
--]]

local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
-- Settings and GameSettings are read only
local Settings = UserSettings()	-- ignore warning
local GameSettings = Settings.GameSettings

local ShiftLockController = {}

--[[ Script Variables ]]--
while not Players.LocalPlayer do
	wait()
end
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild('PlayerGui')
local ScreenGui = nil
local ShiftLockIcon = nil
local InputCn = nil
local IsShiftLockMode = true
local IsShiftLocked = true
local IsActionBound = false
local IsInFirstPerson = false

-- Toggle Event
ShiftLockController.OnShiftLockToggled = Instance.new('BindableEvent')

-- wrapping long conditional in function
local function isShiftLockMode()
	return IsShiftLocked
end

sShiftLockMode = isShiftLockMode()


--[[ Constants ]]--

--[[ Local Functions ]]--


--[[ Public API ]]--
function ShiftLockController:IsShiftLocked()
	return IsShiftLockMode and IsShiftLocked
end

function ShiftLockController:SetIsInFirstPerson(isInFirstPerson)
	IsInFirstPerson = isInFirstPerson
end


local function disableShiftLock()
	IsShiftLockMode = false
	ShiftLockController.OnShiftLockToggled:Fire()
end

-- TODO: Remove when we figure out ContextActionService without sinking keys

local function enableShiftLock()
	IsShiftLockMode = true
			ShiftLockController.OnShiftLockToggled:Fire()
end

enableShiftLock()

return ShiftLockController
