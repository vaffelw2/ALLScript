local _Run = game:GetService("RunService")
local ANNOYANCE=true


local Player=game.Players.LocalPlayer

Player:GetMouse().KeyDown:connect(function(f)
	if f:lower()=="l" then
		ANNOYANCE=not ANNOYANCE
	end
end)
local myModule = require(game.ReplicatedStorage.GetIcon)
local Camera=game.Workspace.CurrentCamera

local last_va 						= 0
local last_va2 						= 0
local Radar = Player:WaitForChild("PlayerGui"):WaitForChild("GUI"):WaitForChild("Circle").Circle

local Position=Vector3.new(0,0,0)
local Positionx=Position.x
local Positiony=Position.y
local maxradius=100

local radarsize=400
function justdoit()
	Positionx=math.clamp(Positionx,0.23,0.67)
	Positiony=math.clamp(Positiony,0.23,0.67)
	--print(Positionx)
	--	print(Positionx)
end
local boop=script.Parent:WaitForChild("Objective")
local TweenService=game:GetService("TweenService")
spawn(function()
	while wait(1) do
		local garb=script.Parent.Objective:GetChildren()
		for i=1,4 do
			if garb[i]:IsA("ImageLabel") and garb[i].Visible==true then
				local color=garb[i].ImageColor3
				TweenService:Create(garb[i], TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3=Color3.new(0.7,0.7,0.7)}):Play()
				wait(0.75)
				TweenService:Create(garb[i], TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3=color}):Play()
			end
		end
	end
end)

--game:GetService("RunService").Stepped:Connect(function()
while wait() do
	script.Parent.Objective.Enabled=false
	script.Parent.Objective.pickup.Visible=false
	script.Parent.Objective.defuse.Visible=false
	script.Parent.Objective.plant.Visible=false
	script.Parent.Objective.protect.Visible=false
	if ANNOYANCE==true and game.Workspace:FindFirstChild("Map") and game.Workspace.Map:FindFirstChild("Gamemode") and game.Workspace.Map.Gamemode.Value=="defusal" then
		if game.Workspace.Debris:FindFirstChild("C4") then
			local csn=game.Workspace.Debris.C4
			script.Parent.Objective.Adornee=csn
			if game.Players.LocalPlayer.Status.Team.Value=="CT" then
				script.Parent.Objective.protect.Visible=true
			elseif game.Players.LocalPlayer.Status.Team.Value=="T" then 
				script.Parent.Objective.pickup.Visible=true
			end
			script.Parent.Objective.Enabled=true
		else
			if game.Workspace:FindFirstChild("C4") then
				local csn=game.Workspace.C4
				local df=false
				if game.Players.LocalPlayer.Status.Team.Value=="CT" then
					if game.Workspace.Map.SpawnPoints:FindFirstChild("C4Plant") and game.Workspace.Map.SpawnPoints.C4Plant.Planted.Value==true then
						csn=game.Workspace.Map.SpawnPoints.C4Plant	
						df=true				
					end
					if df==false and game.Workspace.Map.SpawnPoints:FindFirstChild("C4Plant2") and game.Workspace.Map.SpawnPoints.C4Plant2.Planted.Value==true then
						csn=game.Workspace.Map.SpawnPoints.C4Plant2				
					end
					script.Parent.Objective.defuse.Visible=true
				elseif game.Players.LocalPlayer.Status.Team.Value=="T" then 
					script.Parent.Objective.protect.Visible=true
				end
				script.Parent.Objective.Adornee=csn
				script.Parent.Objective.Enabled=true	
			else
				if game.Players.LocalPlayer.Status.Team.Value=="T" then
					local df=false
					if game.Workspace.Map.SpawnPoints:FindFirstChild("C4Plant") then
						local ep=game.Workspace.Map.SpawnPoints.C4Plant.Position
						if (Camera.CoordinateFrame.p-ep).magnitude<=50 then
							df=true
							local csn=game.Workspace.Map.SpawnPoints.C4Plant
							script.Parent.Objective.Adornee=csn
							script.Parent.Objective.plant.Visible=true
							script.Parent.Objective.Enabled=true						
						end
					end
					if df==false and game.Workspace.Map.SpawnPoints:FindFirstChild("C4Plant2") then
						local ep=game.Workspace.Map.SpawnPoints.C4Plant2.Position
						if (Camera.CoordinateFrame.p-ep).magnitude<=50 then
							local csn=game.Workspace.Map.SpawnPoints.C4Plant2
							script.Parent.Objective.Adornee=csn
							script.Parent.Objective.plant.Visible=true
							script.Parent.Objective.Enabled=true						
						end
					end
				end
			end		
		end	
	end
local froobarb=script.Parent.Nametags:GetChildren()
if #froobarb>0 then
	for i=1,#froobarb do
		froobarb[i].Enabled=false
	end
end
if game.ReplicatedStorage.gametype.Value=="TTT" or game.ReplicatedStorage.gametype.Value=="deathmatch" then
	return
end
if script.Parent:FindFirstChild("GUI") then
maxradius=100*(200/script.Parent.GUI.Circle.Circle.AbsoluteSize.X)
end
	if Radar.Visible==true and game.Players.LocalPlayer and script.Parent:FindFirstChild("GUI") and script.Parent.GUI.MapVote.Visible == false then
	
	
	
	
	if Player then
	local p_distance 				= (Camera.CoordinateFrame.p - Player:GetMouse().Hit.p).magnitude
		if p_distance == 0 then p_distance = 0.0001 end
	local p_height 					= Player:GetMouse().Hit.p.y - Camera.CoordinateFrame.p.y
	local view_angle
		if p_height ~= 0 then
		view_angle 					= math.deg(math.asin(math.abs(p_height) / p_distance)) * (math.abs(p_height) / p_height)
		else
		view_angle 					= 0
		end
	
	local cam_cf 					= Camera.CoordinateFrame
	local looking_at 				= cam_cf * CFrame.new(0, 0, -100)
	local view_angle2 				= math.deg(math.atan2(cam_cf.p.x - looking_at.p.x, cam_cf.p.z - looking_at.p.z)) + 180
	
	local v_delta2
	local dir2 				= 0
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
	
	last_va2 						= view_angle2
	Radar.Player.Position=UDim2.new(0.5,-Radar.Player.AbsoluteSize.X/2,0.5,-Radar.Player.AbsoluteSize.Y/2)
	Radar.Player.Rotation=180-view_angle2
	Radar.Player.Visible=true
	else
	Radar.Player.Visible=false
	end
	if game.Workspace:FindFirstChild("Map") and game.Workspace.Map:FindFirstChild("Gamemode") and game.Workspace.Map.Gamemode.Value=="defusal" then
			if Player.Status.Team.Value=="T" or Player.Status.Team.Value=="CT" then
				if workspace.Status.HasBomb.Value == "" and game.Workspace:FindFirstChild("Debris") and game.Workspace.Debris:FindFirstChild("C4") then
				local Distance = (Vector2.new(Camera.CoordinateFrame.x,Camera.CoordinateFrame.z)-Vector2.new(workspace.Debris.C4.CFrame.x,workspace.Debris.C4.CFrame.z)).magnitude
					if Distance <= 1000 and Player.Status.Team.Value=="T" or Distance<=40 then
					Position = -(Vector2.new(Camera.CoordinateFrame.x,Camera.CoordinateFrame.z)-Vector2.new(workspace.Debris.C4.CFrame.x,workspace.Debris.C4.CFrame.z))
					Position = Vector2.new((Position.x),(Position.y))
					Positionx=0.5+((Position.X)/radarsize)-(Radar.Bomb.Size.X.Scale/2)
					Positiony=0.5+((Position.Y)/radarsize)-(Radar.Bomb.Size.Y.Scale/2)
					justdoit()
					Radar:WaitForChild("Bomb").Position = UDim2.new(Positionx,0,Positiony,0)
					Radar:WaitForChild("Bomb").Visible = true
					else
					Radar:WaitForChild("Bomb").Visible = false
					end
				--Radar:WaitForChild("Bomb"):WaitForChild("ImageLabel").ImageColor3 = BrickColor.new("Really red").Color
				--Radar:WaitForChild("Bomb").Text = "B"
				elseif Player.Status.Team.Value=="T" and game.Players:FindFirstChild(workspace.Status.HasBomb.Value) and game.Players[workspace.Status.HasBomb.Value].Character and game.Players[workspace.Status.HasBomb.Value].Character:FindFirstChild("HumanoidRootPart") then
				local Distance = (Vector2.new(Camera.CoordinateFrame.x,Camera.CoordinateFrame.z)-Vector2.new(game.Players[workspace.Status.HasBomb.Value].Character:WaitForChild("HumanoidRootPart").CFrame.x,game.Players[workspace.Status.HasBomb.Value].Character:WaitForChild("HumanoidRootPart").CFrame.z)).magnitude
					if Distance <= 1000 then
					Position = -(Vector2.new(Camera.CoordinateFrame.x,Camera.CoordinateFrame.z)-Vector2.new(game.Players[workspace.Status.HasBomb.Value].Character:WaitForChild("HumanoidRootPart").CFrame.x,game.Players[workspace.Status.HasBomb.Value].Character:WaitForChild("HumanoidRootPart").CFrame.z))
					Position = Vector2.new((Position.x),(Position.y))
					Positionx=0.5+((Position.X)/radarsize)-(Radar.Bomb.Size.X.Scale/2)
					Positiony=0.5+((Position.Y)/radarsize)-(Radar.Bomb.Size.Y.Scale/2)
					justdoit()
					Radar:WaitForChild("Bomb").Position = UDim2.new(Positionx,0,Positiony,0)
					Radar:WaitForChild("Bomb").Visible = true
					else
					Radar:WaitForChild("Bomb").Visible = false
					end
				--Radar:WaitForChild("Bomb"):WaitForChild("ImageLabel").ImageColor3 = BrickColor.new("Bright red").Color
				--Radar:WaitForChild("Bomb").Text = "D"
				else
				Radar:WaitForChild("Bomb").Visible = false
				end
			else
			Radar:WaitForChild("Bomb").Visible = false
			end
			if workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant2"):WaitForChild("Planted").Value or workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant"):WaitForChild("Planted").Value then
			Radar:WaitForChild("Bomb").Visible = false
			end
		_Run.Heartbeat:wait() 
		local Distance = (Vector2.new(Camera.CoordinateFrame.x,Camera.CoordinateFrame.z)-Vector2.new(workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant").CFrame.x,workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant").CFrame.z)).magnitude
			if Distance <= 1000 then
			Position = -(Vector2.new(Camera.CoordinateFrame.x,Camera.CoordinateFrame.z)-Vector2.new(workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant").CFrame.x,workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant").CFrame.z))--((CFrame.new(Vector3.new(CameraCF.CFrame.x,0,CameraCF.CFrame.z),Vector3.new(Player.Character:WaitForChild("Head").CFrame.x,0,Player.Character:WaitForChild("Head").CFrame.z))-Vector3.new(CameraCF.CFrame.x,0,CameraCF.CFrame.z)+Vector3.new(Player.Character:WaitForChild("Head").CFrame.x,0,Player.Character:WaitForChild("Head").CFrame.z)):toObjectSpace(workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant").CFrame)).p
			Position = Vector2.new((Position.x),(Position.y))
			Positionx=0.5+((Position.X)/radarsize)-(Radar.B.Size.X.Scale/2)
			Positiony=0.5+((Position.Y)/radarsize)-(Radar.B.Size.Y.Scale/2)
			justdoit()
			Radar:WaitForChild("B").Position = UDim2.new(Positionx,0,Positiony,0)
			else
			Radar:WaitForChild("B").Visible = false
			end
		_Run.Heartbeat:wait() 
		local Distance = (Vector2.new(Camera.CoordinateFrame.x,Camera.CoordinateFrame.z)-Vector2.new(workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant2").CFrame.x,workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant2").CFrame.z)).magnitude
			if Distance <= 1000 then
			Position = -(Vector2.new(Camera.CoordinateFrame.x,Camera.CoordinateFrame.z)-Vector2.new(workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant2").CFrame.x,workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant2").CFrame.z))
			
			Position = Vector2.new((Position.x),(Position.y))
			Position = Vector2.new((Position.x),(Position.y))
			Positionx=0.5+((Position.X)/radarsize)-(Radar.A.Size.X.Scale/2)
			Positiony=0.5+((Position.Y)/radarsize)-(Radar.A.Size.Y.Scale/2)
			justdoit()
			Radar:WaitForChild("A").Position = UDim2.new(Positionx,0,Positiony,0)
			else
			Radar:WaitForChild("A").Visible = false
			end
			if workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant"):WaitForChild("Planted").Value then
			Radar:WaitForChild("A").TextColor = BrickColor.new("Bright yellow")
				if Player.Status.Team.Value=="T" then
				Radar:WaitForChild("B").TextColor = BrickColor.new("Bright red")
				Radar:WaitForChild("B").Text = "B"
				else
				Radar:WaitForChild("B").TextColor = BrickColor.new("Bright yellow")
				Radar:WaitForChild("B").Text = "B"
				end
			elseif workspace:WaitForChild("Map"):WaitForChild("SpawnPoints"):WaitForChild("C4Plant2"):WaitForChild("Planted").Value then
			Radar:WaitForChild("B").TextColor = BrickColor.new("Bright yellow")
				if Player.Status.Team.Value=="T" then
				Radar:WaitForChild("A").TextColor = BrickColor.new("Bright red")
				Radar:WaitForChild("A").Text = "A"
				else
				Radar:WaitForChild("A").TextColor = BrickColor.new("Bright yellow")
				Radar:WaitForChild("A").Text = "A"
				end
			else
				if Player.Status.Team.Value=="T" then
				Radar:WaitForChild("A").TextColor = BrickColor.new("Bright yellow")
				Radar:WaitForChild("B").TextColor = BrickColor.new("Bright yellow")
				Radar:WaitForChild("A").Text = "A"
				Radar:WaitForChild("B").Text = "B"
				else
				Radar:WaitForChild("A").TextColor = BrickColor.new("Bright yellow")
				Radar:WaitForChild("B").TextColor = BrickColor.new("Bright yellow")
				Radar:WaitForChild("A").Text = "A"
				Radar:WaitForChild("B").Text = "B"
				end
			Radar:WaitForChild("A").Visible = true
			Radar:WaitForChild("B").Visible = true
			end
		
			if not game.Workspace:FindFirstChild("Map") then
			Radar:WaitForChild("A").Visible = false
			Radar:WaitForChild("B").Visible = false
			Radar:WaitForChild("Bomb").Visible = false
			end
	else
		Radar.A.Visible=false
		Radar.B.Visible=false
		Radar.Bomb.Visible=false
		end
	--_Run.Heartbeat:wait() 
	--[[Radar:WaitForChild("Players"):ClearAllChildren()
		for Index,Noob in pairs (game.Players:GetChildren()) do
			local bepis=nil
			if script.Parent.Nametags:FindFirstChild(Noob.Name)==nil then
				bepis=script.NameTag:clone()
				bepis.Parent=script.Parent.Nametags
				bepis.Name=Noob.Name
				bepis.PersonName.Text=bepis.Name
			else
				bepis=script.Parent.Nametags[Noob.Name]
			end
			bepis.Enabled=false
			if Noob.Character and Noob.Character:FindFirstChild("HumanoidRootPart") and Noob.Character:FindFirstChild("Humanoid") and Noob.Character.Humanoid.Health > 0 and Noob ~= Player then
				if ( ( Noob:FindFirstChild("LastSeen") or Noob:FindFirstChild("Spotted") ) and Noob.TeamColor ~= Player.TeamColor) or Noob.TeamColor == Player.TeamColor or Player.Status.Team.Value=="Spectator" then
				local sps=Noob.Character:WaitForChild("HumanoidRootPart").CFrame
				local hidden=false
				if Player.Status.Team.Value=="Spectator" then
				else
					if Noob.TeamColor ~= Player.TeamColor and Noob:FindFirstChild("LastSeen") then
						hidden=true
						sps=CFrame.new(Noob.LastSeen.Value)
					end
				end
				local Distance = (Vector2.new(Camera.CoordinateFrame.x,Camera.CoordinateFrame.z)-Vector2.new(sps.x,sps.z)).magnitude
					if Distance <= 400 then
					Position = -(Vector2.new(Camera.CoordinateFrame.x,Camera.CoordinateFrame.z)-Vector2.new(sps.x,sps.z))
					Position = Vector2.new((Position.x),(Position.y))
					local Label = Radar:WaitForChild("Player"):Clone()
					Label:WaitForChild("ImageLabel"):Destroy()
					Label.Rotation=0
					Label.Visible=true
					Label.Name = Noob.Name
					Label.Parent = Radar:WaitForChild("Players")
					if Noob.TeamColor == Player.TeamColor or Player.Status.Team.Value=="Spectator" then
						Label.ImageColor3 = BrickColor.new("Bright green").Color
						if bepis then
							bepis.Adornee=Noob.Character.Head
							bepis.Enabled=true
							bepis.Health.TextColor3=Noob.TeamColor.Color
							bepis.PersonName.TextColor3=Noob.TeamColor.Color
							bepis.Pointer.ImageColor3=Noob.TeamColor.Color
							bepis.AlwaysOnTop=true
							if game.Workspace.Status.Preparation.Value==true or Noob:FindFirstChild("LockedIn") then
								bepis.Health.Visible=true
								bepis.PersonName.Visible=true
								if game.Workspace.Status.Preparation.Value==true then
									bepis.Pic.Visible=true
									bepis.Pic.Image=myModule.getWeaponOfKiller(Noob.Character.EquippedTool.Value)
								else
									bepis.Pic.Visible=false
								end
							else
								bepis.Pic.Visible=false
								bepis.Health.Visible=false
								bepis.PersonName.Visible=false
							end
							if bepis.Health.Visible==true then
								bepis.Health.Text=math.floor((Noob.Character.Humanoid.Health/Noob.Character.Humanoid.MaxHealth)*100).."%"
							end
						end
					else
						Label.ImageColor3 = BrickColor.new("Really red").Color
						Label.Hidden.ImageColor3 = BrickColor.new("Really red").Color
						Label.Hidden.Visible=hidden
						Label.ImageTransparency=hidden and 1 or 0
					end
					if Player.Status.Team.Value=="Spectator" then
						Label.ImageColor3 = Noob.TeamColor.Color
					end
					Positionx=0.5+((Position.X)/radarsize)-(Label.Size.X.Scale/2)
					Positiony=0.5+((Position.Y)/radarsize)-(Label.Size.Y.Scale/2)
					justdoit()
					Label.Position = UDim2.new(Positionx,0,Positiony,0)
					end
				end
			end
		end]]
----MAPPPPP POSITIONING OMFG
		if game.Workspace:FindFirstChild("Map") and game.Workspace.Map:FindFirstChild("Radar") then
			local rada=game.Workspace.Map.Radar
			if game.Workspace.Map:FindFirstChild("Origin") and game.ReplicatedStorage.Maps:FindFirstChild(game.Workspace.Map.Origin.Value) and game.ReplicatedStorage.Maps:FindFirstChild(game.Workspace.Map.Origin.Value).Clips.Locations:FindFirstChild(Player.Location.Value) and game.ReplicatedStorage.Maps:FindFirstChild(game.Workspace.Map.Origin.Value).Clips.Locations:FindFirstChild(Player.Location.Value):FindFirstChild("Radar2") then
				rada=game.Workspace.Map.Radar2
			end
			if rada:FindFirstChild("Decal") then
				Radar.Map.Image=rada.Decal.Texture
			end
			Radar.Map.Size=UDim2.new(rada.Size.X/radarsize,0,rada.Size.Z/radarsize,0)
			Position = -(Vector2.new(Camera.CoordinateFrame.x,Camera.CoordinateFrame.z)-Vector2.new(rada.CFrame.x,rada.CFrame.z))
			local mapsize=math.max(rada.Size.X,rada.Size.Z)
			maxradius=mapsize
			Position = Vector2.new((Position.x/maxradius)*mapsize,(Position.y/maxradius)*mapsize)
			--justdoit()
			--print(Position)
			--Radar:WaitForChild("Map").Position = UDim2.new(0.5,Position.X-(Radar.Map.AbsoluteSize.X/2),0.5,Position.Y-(Radar.Map.AbsoluteSize.Y/2))
			--print("original: "..Radar.Map.AbsolutePosition.X..","..Radar.Map.AbsolutePosition.Y)			
			Radar.Map.Position=UDim2.new(0.5+((Position.X-(mapsize/2))/radarsize),0,0.5+((Position.Y-(mapsize/2))/radarsize),0)
			--print("faked: "..Radar.Map.AbsolutePosition.X..","..Radar.Map.AbsolutePosition.Y)			
		end		
		-------------	
	else
		if #script.Parent.Nametags:GetChildren()>0 then
			script.Parent.Nametags:ClearAllChildren()
		end
	end
end
--end)