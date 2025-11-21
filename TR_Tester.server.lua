local bapada=script.Parent.Tester
local door=bapada.Booth.Door
local door2=door.Parent.Door2


local closeoffset=door.CFrame
local openoffset=door.CFrame*CFrame.new(0,-(door.Size.Y+0.1),0)
local closeoffset2=door2.CFrame
local openoffset2=door2.CFrame*CFrame.new(0,-(door.Size.Y+0.1),0)

local topoffset=bapada.Booth.Top.CFrame
local botoffset=bapada.Booth.Bottom.CFrame

door.CFrame=openoffset
door2.CFrame=openoffset2
local function CreateRegion3FromLocAndSize(Position, Size)
	local SizeOffset = Size/2
	local Point1 = Position - SizeOffset
	local Point2 = Position + SizeOffset
	return Region3.new(Point1, Point2)
end


function getplayers()
	local wl={}
	local bap=game.Players:GetPlayers()
	for i=1,#bap do
		local d=bap[i]
		if d and d.Character and d.Character:FindFirstChild("HumanoidRootPart") and (d.Character.HumanoidRootPart.Position-bapada.Booth.PlayerDetector.Position).magnitude<=3.5 then
			table.insert(wl,d.Character.HumanoidRootPart)
		end
	end
	local hitparts=game.Workspace:FindPartsInRegion3WithWhiteList(CreateRegion3FromLocAndSize(bapada.Booth.PlayerDetector.CFrame.p, bapada.Booth.PlayerDetector.Size),wl,math.huge)
	if #hitparts>1 then
		return "toomany"
	elseif #hitparts==1 then
		return hitparts[1].Parent.Name
	else
		return "nobody"
	end
end
function colorchange(role)
	if role=="Innocent" then
		bapada.Color.BrickColor=BrickColor.new("Bright green")
		bapada.Color.Proven:Play()
	elseif role=="Traitor" then
		bapada.Color.BrickColor=BrickColor.new("Bright red")
		bapada.Color.SPY:Play()
	elseif role=="Detective" then
		bapada.Color.BrickColor=BrickColor.new("Bright blue")
		bapada.Color.Proven:Play()
		delay(0.5,function()
			bapada.Color.Proven:Play()
		end)
	else
		bapada.Color.BrickColor=BrickColor.new("Black")
		bapada.Color.huh:Play()
	end
end
function resetcolor()
	bapada.Color.BrickColor=BrickColor.new("Dark stone grey")
end

local debounce=false
function test()
	debounce=true
	game:GetService("TweenService"):Create(door,TweenInfo.new(0.4,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{CFrame=closeoffset}):Play()
	game:GetService("TweenService"):Create(door2,TweenInfo.new(0.4,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{CFrame=closeoffset2}):Play()
	wait(0.5)
	wait(0.25)
	local person=nil
	if game.Players:FindFirstChild(getplayers()) then
		person=game.Players[getplayers()]
	end
	game:GetService("TweenService"):Create(bapada.Booth.Top,TweenInfo.new(2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{CFrame=botoffset}):Play()
	game:GetService("TweenService"):Create(bapada.Booth.Bottom,TweenInfo.new(2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{CFrame=topoffset}):Play()	
	wait(2.2)
	game:GetService("TweenService"):Create(bapada.Booth.Top,TweenInfo.new(2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{CFrame=topoffset}):Play()
	game:GetService("TweenService"):Create(bapada.Booth.Bottom,TweenInfo.new(2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{CFrame=botoffset}):Play()
	wait(2.25)
	local role=""
	if game.Players:FindFirstChild(getplayers()) and person==game.Players[getplayers()] then
		if person and person:FindFirstChild("Status") and person.Character then
			role=person.Status.Role.Value
			if role=="Traitor" then
				if person.Character and person.Character:FindFirstChild("RDMProtection") then
					person.Character.RDMProtection:Destroy()
				end
			else
				if person.Character:FindFirstChild("Proven")==nil then
					local int = Instance.new("IntValue")
					int.Parent = person.Character
					int.Name = "Proven"
				end
			end
		end
	end
	colorchange(role)
	wait(0.5)
	game:GetService("TweenService"):Create(door,TweenInfo.new(0.4,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{CFrame=openoffset}):Play()
	game:GetService("TweenService"):Create(door2,TweenInfo.new(0.4,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{CFrame=openoffset2}):Play()	
	wait(0.5)
	resetcolor()
	debounce=false
end

local event=game.ReplicatedStorage.Events.Event:clone()
event.Parent=bapada.Booth.Close
event.OnServerEvent:connect(function(player)	
	if debounce==false then
		test()
	end
end)