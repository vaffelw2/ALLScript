local userInput = game:GetService("UserInputService")
 
local rs = game:GetService("RunService")
local lastUpdate = tick()
 
local camDirections =
{
    W = Vector3.new(0,0,-1);
    S = Vector3.new(0,0,1);
    A = Vector3.new(-1,0,0);
    D = Vector3.new(1,0,0);
}
 
local alternatives =
{
    W = "Up";
    A = "Left";
    D = "Right";
    S = "Down";
}
 
local speed = 40
local down = {}
local changedQueue = {}
local focusActive = false
local changingFocus = false
local activeCamera
 
local MOUSE_SENSITIVITY = Vector2.new(math.pi*4, math.pi*1.9)
local MIN_Y = math.rad(-80)
local MAX_Y = math.rad(80)
local eight2Pi = math.pi / 4
 
local function round(num)
    return math.floor(num + 0.5)
end
 
local function clamp(min,max,val)
    return math.max(min,math.min(max,val))
end
 
local function rotateVectorByAngleAndRound(camLook, rotateAngle, roundAmount)
    if camLook ~= Vector3.new(0,0,0) then
        camLook = camLook.unit
        local currAngle = math.atan2(camLook.z, camLook.x)
        local newAngle = round((math.atan2(camLook.z, camLook.x) + rotateAngle) / roundAmount) * roundAmount
        return newAngle - currAngle
    end
    return 0
end
 
 
local function mouseTranslationToAngle(translationVector)
    local xTheta = (translationVector.X/1920)
    local yTheta = (translationVector.Y/1200)
    return Vector2.new(xTheta,yTheta) * MOUSE_SENSITIVITY
end
 
local function rotateLookVector(startLook,xyRotateVector)
    local startCFrame = cframenew(Vector3.new(), startLook)
    local startVertical = math.asin(startLook.y)
    local yTheta = clamp(-MAX_Y + startVertical, -MIN_Y + startVertical, xyRotateVector.y)
    local resultLookVector = (CFrame.Angles(0, -xyRotateVector.x, 0) * startCFrame * CFrame.Angles(-yTheta,0,0)).lookVector
    return resultLookVector, Vector2.new(xyRotateVector.x, yTheta)
end
 
local function onInputBegan(input,gameProcessed)
    if not gameProcessed then
        down[input.UserInputType] = input
    end
end
 
local function onInputChanged(input,gameProcessed)
    if not gameProcessed then
        changedQueue[input] = true
    end
end
 
local function onInputEnded(input,gameProcessed)
    if not gameProcessed then
        down[input.UserInputType] = nil
    end
end
 
local function isKeyDown(key)
    return (userInput:IsKeyDown(Enum.KeyCode[key]))
end
 
local function setFocus(focus)
    local c = workspace.CurrentCamera
    changingFocus = true
    c.Focus = focus
    changingFocus = false
end
 
local function pushedKey(key)
    -- If a key is in the down queue, remove it from the queue and return true.
    -- Used to simulate one at a time key presses with ease.
    local keyDown = down[Enum.UserInputType.Keyboard]
    if keyDown then
        if keyDown.KeyCode == Enum.KeyCode[key] then
            down[Enum.UserInputType.Keyboard] = nil
            return true
        end
    end
    return false
end
cframenew = CFrame.new
local function updateCamera()

        local c = workspace.CurrentCamera
        if activeCamera ~= c then
            activeCamera = c
           -- c.CameraType = "Scriptable"
            c.Changed:connect(function (property)
                if property == "Focus" and not changingFocus then
                    focusActive = true
                end
            end)
        end
        local now = tick()
        local deltaTime = now-lastUpdate
       
        lastUpdate = now
       
        local nextPos = Vector3.new()
       
        for key,pos in pairs(camDirections) do
            if isKeyDown(key) or (alternatives[key] and isKeyDown(alternatives[key])) then
                nextPos = nextPos + pos
            end
        end
       
        local lookVector = c.CoordinateFrame.lookVector
        local currentSpeed = speed
        local canSetFocus = true
       
        local isShiftDown = isKeyDown("LeftShift")
        if isShiftDown then
            currentSpeed = currentSpeed / 5
        end
       
        local isRightMouseDown = down[Enum.UserInputType.MouseButton2]
        local isRollKeyDown = false--(down[Enum.UserInputType.MouseButton3] ~= nil or isKeyDown("R"))
       
        if (isRightMouseDown or isRollKeyDown) and userInput.MouseBehavior ~= Enum.MouseBehavior.LockCurrentPosition then
            userInput.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
        elseif not (isRightMouseDown or isRollKeyDown) and userInput.MouseBehavior ~= Enum.MouseBehavior.Default then
            userInput.MouseBehavior = Enum.MouseBehavior.Default
        end
       
        local roll = c:GetRoll()
        local rotateInput = Vector2.new()
       
        for input in pairs(changedQueue) do
            local inputType = input.UserInputType
            local delta = input.Delta
            local pos = input.Position
            if inputType == Enum.UserInputType.MouseMovement then
                local translation = mouseTranslationToAngle(delta)
                if isRollKeyDown then
                    roll = roll + translation.X
                    c:SetRoll(roll)
                else
                    rotateInput = rotateInput + translation
                end
            elseif inputType == Enum.UserInputType.MouseWheel then
                if isShiftDown then
                    c.FieldOfView = clamp(1,120,c.FieldOfView + (input.Position.Z*-5))
                else
                    if pos.Z > 0 then
                        nextPos = nextPos - Vector3.new(0,0,15)
                    else
                        nextPos = nextPos + Vector3.new(0,0,15)
                    end
                end
            end
            changedQueue[input] = nil
        end

        local camPos = ((c.CoordinateFrame * CFrame.Angles(0,0,-roll)) * cframenew(nextPos * (deltaTime * currentSpeed))).p
 
        if nextPos ~= Vector3.new() then
            focusActive = false
        end
       
        if focusActive then
            local expectedLookVector = rotateLookVector(cframenew(camPos,c.Focus.p).lookVector,rotateInput)
            local dist = (c.Focus.p-c.CoordinateFrame.p).magnitude
            camPos = c.Focus.p - (expectedLookVector*dist)
        else
            lookVector = rotateLookVector(lookVector,rotateInput)
            setFocus(cframenew(camPos+(lookVector*2)))
        end 
        c.CoordinateFrame = cframenew(camPos,c.Focus.p)


end
 
userInput.InputBegan:connect(onInputBegan)
userInput.InputChanged:connect(onInputChanged)
userInput.InputEnded:connect(onInputEnded)
 
game:GetService("RunService").RenderStepped:connect(function()
	updateCamera()
end)