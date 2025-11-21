_uis = game:GetService("UserInputService")
local mouse=game.Players.LocalPlayer:GetMouse()

local defusing=nil

local bomb=nil
local bap=nil



local defusetime=10

local starttime=tick()
local time=-1000

local tinsert=table.insert
local Camera=game.Workspace.CurrentCamera

function KeyDown(e)
	if game.ReplicatedStorage.gametype.Value=="TTT" then
		return
	end
	if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Workspace.CurrentCamera:FindFirstChild("Arms2")==nil then
	local Mouse=Camera.CoordinateFrame.p+(Camera.CoordinateFrame.lookVector*5)
	local RayCasted = Ray.new(game.Players.LocalPlayer.Character.Head.Position, (CFrame.new(game.Players.LocalPlayer.Character.Head.Position, Mouse)).lookVector.unit * 5)
	local ignorelist={}
	if game.Workspace:FindFirstChild("C4") then
		table.insert(ignorelist,game.Workspace.C4)
		script.Parent.Defusing.Text="Defuse Time:"
	end
	if game.Workspace:FindFirstChild("Map") and game.Workspace.Map.Regen:FindFirstChild("Hostages") then
		table.insert(ignorelist,game.Workspace.Map.Regen.Hostages)
		script.Parent.Defusing.Text="Time:"
	end
	local Hit, Pos = workspace:FindPartOnRayWithWhitelist(RayCasted, ignorelist,false,true)
if  e:lower()=="e" and game.Players.LocalPlayer.TeamColor==BrickColor.new("Bright blue") and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso") and (Hit and Hit.Parent.Name=="C4" and Hit.Parent:FindFirstChild("Handle") and Hit.Parent.Handle:FindFirstChild("Script") or game.Workspace.Map.Gamemode.Value=="hostages" and Hit:IsDescendantOf(game.Workspace.Map.Regen.Hostages)) and (Hit.Position-game.Players.LocalPlayer.Character.UpperTorso.Position).magnitude<=6 and Hit.Parent and Hit.Parent:FindFirstChild("Defusing")==nil  and Hit.Parent:FindFirstChild("Defused")==nil then
bomb=Hit.Parent
bap=Hit
if bomb.Parent:FindFirstChild("Humanoid") then
	bomb=bomb.Parent
end
game.Players.LocalPlayer.Backpack.PressDefuse:FireServer(bomb)
repeat wait(1/30) until bomb:FindFirstChild("Defusing") and bomb.Defusing.Value==game.Players.LocalPlayer
starttime=tick()
script.Parent.Visible=true
	
	script.Parent.Bar.Fill.Size=UDim2.new(1,0,1,0)
	script.Parent.Time.Text="00:05"
	while wait(1/30) do
	Mouse=Camera.CoordinateFrame.p+(Camera.CoordinateFrame.lookVector*5)
	RayCasted = Ray.new(game.Players.LocalPlayer.Character.Head.Position, (CFrame.new(game.Players.LocalPlayer.Character.Head.Position, Mouse)).lookVector.unit * 5)
	Hit, Pos = workspace:FindPartOnRayWithWhitelist(RayCasted, ignorelist,false,true)
	if Hit and Hit.Parent and Hit.Parent.Parent:FindFirstChild("Head") then
		Hit=Hit.Parent.Parent.Head
	end
		if Hit and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health>0 and game.Players.LocalPlayer.TeamColor==BrickColor.new("Bright blue") and Hit.Parent:FindFirstChild("Defusing") and Hit.Parent:FindFirstChild("Defusing").Value==game.Players.LocalPlayer and Hit.Parent:FindFirstChild("Defused")==nil and Hit.Parent:FindFirstChild("CANTDEFUSE")==nil then
		else
		break
		end
	end

script.Parent.Visible=false
end
end
end

mouse.KeyDown:connect(function(e)
 KeyDown(e)
end)

script.Parent.Changed:connect(function()
	if script.Parent.Visible and starttime then
		defusetime=10
		if game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("DefuseKit") then
			defusetime=5
		end
		if game.Workspace.Map.Gamemode.Value=="hostages"  then
			defusetime=math.floor(defusetime/2)
		end
	time=math.max(0,defusetime-(tick()-starttime))
		while time>0.005 and starttime and script.Parent.Visible do
		time=math.max(0,defusetime-(tick()-starttime))
		script.Parent.Bar.Fill.Size=UDim2.new(1*(time/defusetime),0,1,0)
			if script.Parent.Visible==false then break end
			if time>=9 then
			script.Parent.Time.Text="00:"..math.floor(time+1)
			else
			script.Parent.Time.Text="00:0"..math.floor(time+1)
			end
			if time<=0.005 then
				break
			end
		wait(1/30)
		end
		if time<=0.005 then
		script.Parent.Bar.Fill.Size=UDim2.new(0,0,1,0)
	
		script.Parent.Time.Text="00:00"
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health>0 and game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso") and bomb and bap and (bap.Position-game.Players.LocalPlayer.Character.UpperTorso.Position).magnitude<=6 then
			if bomb and bomb:FindFirstChild("Defused")==nil then
			game.Players.LocalPlayer.Backpack.Defuse:FireServer(bomb)
				if script.Parent.Defusing.Text=="Time:" then
					if game.Workspace.CurrentCamera:FindFirstChild("Arms2") then
						game.Workspace.CurrentCamera.Arms2:Destroy()
					end
					local arms2=game.ReplicatedStorage.Viewmodels.Arms2:clone()
					arms2.Parent=game.Workspace.CurrentCamera
				end
			end
		end
		else
			game.Players.LocalPlayer.Backpack.ReleaseDefuse:FireServer()
		end
	end
end)

function KeyUp(e)
if game.ReplicatedStorage.gametype.Value=="TTT" then
		return
	end
	if e:lower()=="e" then
	game.Players.LocalPlayer.Backpack.ReleaseDefuse:FireServer()
	script.Parent.Visible=false
	end

end

mouse.KeyUp:connect(function(e)
	KeyUp(e)
end)

_uis.InputBegan:Connect(function(key)
if key.KeyCode == Enum.KeyCode.ButtonX then
	KeyDown("e")
end
end)

_uis.InputEnded:Connect(function(key)
if key.KeyCode == Enum.KeyCode.ButtonX then
	KeyUp("e")
end
end)
