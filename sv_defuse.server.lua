local defuseani=nil
local defusing=nil
local bbomb=nil


script.Parent:WaitForChild("PressDefuse")
script.Parent:WaitForChild("Defuse")
script.Parent:WaitForChild("ReleaseDefuse")


function removehostage(nam)
	if game.Workspace["Ray_Ignore"]:FindFirstChild(nam) then
		local shit=game.Workspace["Ray_Ignore"]:FindFirstChild(nam)
		local BOP=game.ReplicatedStorage.Hostage:clone()
		BOP.AssignAppearance:Destroy()
		BOP.Head.face.Texture=shit.Head.face.Texture
		shit.Hair:clone().Parent=BOP
		BOP.Parent=game.Workspace.Map.Regen.Hostages
		BOP.Humanoid:LoadAnimation(BOP["Idle"..math.random(1,2)]):Play()
		BOP.Hairs:Destroy()
		BOP:SetPrimaryPartCFrame(shit.PrimaryPart.CFrame)
		BOP.Humanoid.HipHeight=-1
		BOP.Humanoid.Sit=true
		BOP.Humanoid.PlatformStand=true
		shit:Destroy()
	end
end

game.Workspace.ChildRemoved:connect(function(c)
	if c and c:FindFirstChild("Humanoid") then
		removehostage(c.Name)
	end
end)

local died=false

script.Parent.Defuse.OnServerEvent:connect(function(player,bomb)
	bbomb=bomb
	if player and player.Character and player.Character:FindFirstChild("UpperTorso") and bomb and bomb:FindFirstChild("CANTDEFUSE")==nil then
	local name="DefuseEnd"
	if workspace.Map.Gamemode.Value=="hostages" then
		name="Pickup"
	end
		local sound=script[name]:clone()
		sound.Parent=player.Character:WaitForChild("UpperTorso")
		sound:Play()
		delay(2,function() sound:Destroy() end)
		local int=Instance.new("StringValue")
		int.Parent=bomb
		int.Name="Defused"
		int.Value=player.Name
		if name=="DefuseEnd" then
			player.Status.Score.Value=player.Status.Score.Value+2
			player.Score.Value=player.Score.Value+2
			player.Status.Score.Reasoning.Value=" for defusing the bomb."
		end
		if player and player.Character:FindFirstChild("Multimeter") then
		player.Character.Multimeter:Destroy()
		end
		if defuseani then
			defuseani:Stop(.4,nil,nil)
		end
		if name=="Pickup" then
			if bomb then
				local BOP=game.ReplicatedStorage.Hostage:clone()
				BOP.AssignAppearance:Destroy()
				BOP.Head.face.Texture=bomb.Head.face.Texture
				bomb.Hair:clone().Parent=BOP
				BOP.Name=player.Name
				BOP.Parent=game.Workspace["Ray_Ignore"]
				
				BOP.Humanoid:LoadAnimation(BOP.Carry):Play()
				
				BOP.Hairs:Destroy()
				local w=BOP.HumanoidRootPart.Weld
				BOP:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame*w.C0*CFrame.new(0,0.65,0))
				local mep=Instance.new("Motor6D")
				mep.Part0=player.Character.HumanoidRootPart
				mep.Part1=BOP.HumanoidRootPart
				mep.Parent=BOP.HumanoidRootPart
				mep.C0=w.C0*CFrame.new(0,0.65,0)
				w:Destroy()
				BOP.Humanoid.HipHeight=-1
				BOP.Humanoid.Sit=true
				BOP.Humanoid.PlatformStand=true
				player.Character.Humanoid.Died:connect(function()
					if died==false then
						died=true
						removehostage(player.Name)
					end
				end)
				local dag=BOP:GetDescendants()
				for i=1,#dag do
					if dag[i]:IsA("BasePart") then
						dag[i]:SetNetworkOwner(player)
					end
				end
				if game.Workspace.Status.FirstTime.Value==false then
					game.ReplicatedStorage.Events.SendMsg:FireAllClients("A hostage has been picked up, added a minute to the timer.")
					game.Workspace.Status.FirstTime.Value=true
					game.Workspace.Status.Timer.Value=game.Workspace.Status.Timer.Value+60
				end
				bomb:Destroy()
				---PICK UP MY BOI
			end
		else
			game.Workspace.Sounds.Defuse:Play()
			game.Workspace.Status.Defused.Value=true
		end
	end
end)


--script.Parent:WaitForChild("PressDefuse").OnServerEvent:connect(function(player,bomb)
script.Parent.PressDefuse.OnServerEvent:Connect(function(player,bomb)
	bbomb=bomb
	if player and player.Character and player.Character:FindFirstChild("UpperTorso") and (workspace.Status.Armed.Value == true or game.Workspace.Map.Gamemode.Value=="hostages") then
	defusing=Instance.new("ObjectValue")
	defusing.Name="Defusing"
	defusing.Value=player
	defusing.Parent=bomb
	local name="DefuseStart"
	if workspace.Map.Gamemode.Value=="hostages" then
		name="Rescue"
	end
	local sound=script[name]:clone()
	sound.Parent=player.Character:WaitForChild("UpperTorso")
	sound:Play()
	if workspace.Status.Armed.Value == true then

	if player:FindFirstChild("DefuseKit") then
		defuseani=player.Character.Humanoid:LoadAnimation(script.Defuse)
	else
		defuseani=player.Character.Humanoid:LoadAnimation(script.Defuse10)
	end
	if defuseani then
		defuseani:Play()
	end
	defuseani.KeyframeReached:connect(function(kf)
	if kf=="1" then
		if bbomb and bbomb:FindFirstChild("HUD")  and bbomb.HUD:FindFirstChild("SurfaceGui") then
			bbomb.HUD.SurfaceGui.TextLabel.Text="******7"
		end
	elseif kf=="2" then
		if bbomb and bbomb:FindFirstChild("HUD")  and bbomb.HUD:FindFirstChild("SurfaceGui") then
			bbomb.HUD.SurfaceGui.TextLabel.Text="*****73"
		end
	elseif kf=="3" then
		if bbomb and bbomb:FindFirstChild("HUD")  and bbomb.HUD:FindFirstChild("SurfaceGui") then
			bbomb.HUD.SurfaceGui.TextLabel.Text="****735"
		end
	elseif kf=="4" then
		if bbomb and bbomb:FindFirstChild("HUD")  and bbomb.HUD:FindFirstChild("SurfaceGui") then
			bbomb.HUD.SurfaceGui.TextLabel.Text="**7355"
		end
	elseif kf=="5" then
		if bbomb and bbomb:FindFirstChild("HUD")  and bbomb.HUD:FindFirstChild("SurfaceGui") then
			bbomb.HUD.SurfaceGui.TextLabel.Text="**73556"
		end
	elseif kf=="6" then
		if bbomb and bbomb:FindFirstChild("HUD")  and bbomb.HUD:FindFirstChild("SurfaceGui") then
			bbomb.HUD.SurfaceGui.TextLabel.Text="*735560"
		end
	elseif kf=="7" then
		if bbomb and bbomb:FindFirstChild("HUD")  and bbomb.HUD:FindFirstChild("SurfaceGui") then
			bbomb.HUD.SurfaceGui.TextLabel.Text="7355608"
		end
	end
end)
				local weaponinhand=game.ReplicatedStorage.Weapons.Multimeter:clone()
				weaponinhand.Parent=player.Character
				local gunweld=Instance.new("Motor6D")
				gunweld.Parent=weaponinhand
				gunweld.Part0=player.Character["LeftHand"]
				gunweld.Part1=weaponinhand
				gunweld.Name="GunWeld"
				--weaponinhand.LeftSpring.Attachment1=bbomb.Handle.Left
				--weaponinhand.RightSpring.Attachment1=bbomb.Handle.Right
end
	delay(2,function() sound:Destroy() end)
		while wait(1/30) do
			if defusing and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health>0 and player.TeamColor==BrickColor.new("Bright blue") and player.Character:FindFirstChild("UpperTorso") and bomb and bomb:FindFirstChild("Defusing") and bomb:FindFirstChild("Defusing").Value==player and bomb:FindFirstChild("Defused")==nil then
			else
			break
			end
		end
		
		if defusing then
		defusing:Destroy()
		end
	end
end)


--script.Parent:WaitForChild("ReleaseDefuse").OnServerEvent:connect(function(player)
script.Parent.ReleaseDefuse.OnServerEvent:Connect(function(player)
	if player and player.Character and player.Character:FindFirstChild("Multimeter") then
		if bbomb and bbomb:FindFirstChild("HUD")  and bbomb.HUD:FindFirstChild("SurfaceGui") then
			bbomb.HUD.SurfaceGui.TextLabel.Text="*******"
		end
	player.Character.Multimeter:Destroy()
		if defuseani then
			defuseani:Stop(.4,nil,nil)
		end
	end
	if defusing then
	defusing:Destroy()
	end
end)


