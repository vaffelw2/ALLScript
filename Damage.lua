local Damage={}

repst = game.ReplicatedStorage

local function removecash(player,cash,context)
	if player and player:FindFirstChild("Cash") then
	player.Cash.Value=math.max(player.Cash.Value-cash,0)
		if context then
		repst.Events.SendMsg:FireClient(player,context,Color3.new(210/255, 0, 0))
		end
	end
end



function Damage.takeDamage(player,hum,damage,gun,headshot,leg,dealminimum)
	if repst.gametype.Value=="TTT" then
		damage=damage*0.6
	end
	if hum and hum.Parent and hum.Parent:FindFirstChild("Hostage") then
		removecash(player,150,"-$150: Injuring the hostage.")
		return
	end
	if hum.Health<=0 and gun and gun:FindFirstChild("Grenade")==nil or repst.Damage:FindFirstChild(player.Name) then
		return
	end
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and hum.Parent:FindFirstChild("HumanoidRootPart") then
		local ray = Ray.new(player.Character.HumanoidRootPart.CFrame.p, (hum.Parent.HumanoidRootPart.CFrame.p - player.Character.HumanoidRootPart.CFrame.p).unit * 300)
		local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character, workspace.CurrentCamera}, false, true)
		
		if not hit:IsDescendantOf(hum.Parent) and not hit.Material == Enum.Material.Wood and not hit.Material == Enum.Material.WoodPlanks and not hit.Material == Enum.Material.Metal and not hit.Material == Enum.Material.Glass then
			return
		end
	end
	if game.Workspace.Status.Preparation.Value==true then
		return
	end
	if hum and hum.Parent and hum.Parent:FindFirstChild("ForceField") then
		return
	end
	local enemyplayer=nil
	if game.Players:GetPlayerFromCharacter(hum.Parent) then
		enemyplayer=game.Players:GetPlayerFromCharacter(hum.Parent)
	end
	if repst.gametype.Value=="TTT" then
		local df = 1 + -0.0000025 * ((player.Status.Karma.Value-1000)^2)
		if player.Status.Role.Value=="Traitor" then
			df=1
		end
		df=math.clamp(df, 0.1, 1.0)
		damage=damage*df
	end

	local mmax=math.max
	local mmin=math.min
	local nope=false
	local armordmg=false
	local origdamage=0
	if leg==false and enemyplayer and enemyplayer:FindFirstChild("Kevlar") and gun:FindFirstChild("ArmorPenetration") then
		if headshot==true and enemyplayer:FindFirstChild("Helmet") or headshot==false then
			origdamage=damage
			damage=damage*(gun.ArmorPenetration.Value/100)
			armordmg=true
		end
	end
	if repst.gametype.Value=="TTT" then
		damage=math.min(hum.Health,damage)
	end
	if repst.gametype.Value=="TTT" and game.Workspace.Status.RoundOver.Value==false then
		if player and player.Status.Role.Value=="Traitor" and enemyplayer and enemyplayer.Status.Role.Value=="Traitor" then
			return
		end
		if enemyplayer.Name~=player.Name and enemyplayer.Character:FindFirstChild("RDMProtection") and player.Status.Role.Value~="Traitor" then
			if player.Character and player.Character:FindFirstChild("RDMProtection") then
				player.Character.RDMProtection:Destroy()
			end
			if enemyplayer:FindFirstChild("Status") then
				player.Status.Karma.Value=mmax(100,(player.Status.Karma.Value-(damage*(enemyplayer.Status.Karma.Value*.0025))))
				if enemyplayer.Status.Role.Value=="Detective" then
					player.Status.Karma.Value=mmax(100,(player.Status.Karma.Value-(damage*(enemyplayer.Status.Karma.Value*.0025))))
				end
				if (hum.Health-damage)<=0 then
					player.Status.Kills.Value=player.Status.Kills.Value-1
					player.Status.Karma.Value=mmax(100,(player.Status.Karma.Value-15))
					nope=true
				end
				if player:FindFirstChild("RDM")==nil then
					local dent=Instance.new("IntValue")
					dent.Parent=player
					dent.Name="RDM"
				end
			end
		else
			if enemyplayer:FindFirstChild("RDM")==nil and enemyplayer.Character:FindFirstChild("RDMProtection")==nil and enemyplayer.Status.Role.Value~="Traitor" then
				local dent=Instance.new("IntValue")
				dent.Parent=enemyplayer
				dent.Name="RDM"
			end
			if player:FindFirstChild("RDM")==nil and player.Status.Role.Value~="Traitor" then
				player.Status.Karma.Value=mmin(1000,(player.Status.Karma.Value+(damage*(1000*0.0003))))
			end
			if (hum.Health-damage)<=0 then
				if player.Status.Role.Value~="Traitor"  then
					player.Status.Kills.Value=player.Status.Kills.Value+1
				end
				player.Status.Karma.Value=mmin(1000,(player.Status.Karma.Value+40))
			end
			if player.Status.Role.Value~="Traitor" and player.Character and player.Character:FindFirstChild("Proven")==nil and enemyplayer.Character:FindFirstChild("RDMProtection")==nil and player.Character:FindFirstChild("RDMProtection") then
				local int = Instance.new("IntValue")
				int.Parent = player.Character
				int.Name = "Proven"
			end		
			if player.Status.Role.Value=="Traitor" then
				if enemyplayer and enemyplayer:FindFirstChild("RDM")==nil then
					if player.Character and player.Character:FindFirstChild("RDMProtection") then
						player.Character.RDMProtection:Destroy()
					end
				end
			end
			if player.Status.Role.Value=="Traitor" and enemyplayer.Status.Role.Value~="Traitor" and enemyplayer.Character:FindFirstChild("Proven")==nil and enemyplayer.Character:FindFirstChild("RDMProtection") then
				local int=Instance.new("IntValue")
				int.Parent=enemyplayer.Character
				int.Name="Proven"
			end
		end
	end		
	if enemyplayer and player then
		if player:FindFirstChild("Damaged") then
			player.Damaged:Destroy()
		end
	local dent=Instance.new("StringValue")
	dent.Name="Damaged"
	dent.Value=enemyplayer.Name
	dent.Parent=player
	delay(1,function()
		dent:Destroy()
	end)
	end
	local dmgfold=nil
	if player:FindFirstChild("DamageLogs") and enemyplayer then
		if player.DamageLogs:FindFirstChild(enemyplayer.Name) then
		dmgfold=player.DamageLogs[enemyplayer.Name]
		else
		local niga=Instance.new("Folder")
		niga.Name=enemyplayer.Name
		niga.Parent=player.DamageLogs
		dmgfold=niga
		local bitch=Instance.new("IntValue")
		bitch.Name="DMG"
		local hits=Instance.new("IntValue")
		hits.Name="Hits"
		hits.Parent=dmgfold
		bitch.Parent=dmgfold
		end
	end

			local instance=Instance.new("NumberValue")
			instance.Parent=hum
			instance.Name="Tagged"
			instance.Value=gun.Tagging.Value
			local d=2
			if game.ReplicatedStorage.gametype.Value=="juggernaut" then
				if gun:FindFirstChild("ShotgunThing") or gun:FindFirstChild("Scoped") then
					instance.Value=instance.Value*3
				else
					instance.Value=instance.Value*1.5
				end
				d=0.5
			end
			delay(math.clamp(d*(gun.Tagging.Value),0,2),function()
				instance:Destroy()
			end)

	if player and player:FindFirstChild("Additionals") then
		player.Additionals.TotalDamage.Value=player.Additionals.TotalDamage.Value+damage
	end
	if player and player.Status.Team.Value~="Terrorist" and hum and hum.Parent and player.Name~=hum.Parent.Name and game.Players:GetPlayerFromCharacter(hum.Parent) and game.Players:GetPlayerFromCharacter(hum.Parent).TeamColor==player.TeamColor and hum.Parent.Name~=player.Name then
		

		if repst.gametype.Value ~= "deathmatch" then
			damage=damage*0.5
			if player.Name~="DevRolve" and player.Name~="mightybaseplate" then
				player.TeamDamage.Value=player.TeamDamage.Value+damage
			end
			if damage>=50 then
				repst.Events.SendMsg:FireAllClients(player.Name.." has attacked a teammate.",Color3.new(210/255, 0, 0))
			end
		end
		if player.TeamDamage.Value>=500 then
			if repst.gametype.Value ~= "deathmatch" then
				if player and player.Character and player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid.Health=0
				end
				repst.Events.SendMsg:FireAllClients(player.Name.." has been kicked for doing too much team damage",Color3.new(210/255, 0, 0))
				player:Kick("You have been kicked for doing too much team damage.")
				local ban=Instance.new("StringValue")
				ban.Parent=game.ServerStorage.Banned
				ban.Name=player.Name	
				return
			end
		end
	end
	if dealminimum==true then
		if game.Workspace.Status.Killtrade.Value == false then
			damage=0
		else
			damage=math.min(damage/2,hum.Health-1)
		end
	end
	if nope==false then
		damage=math.max(0,damage)
		if dmgfold and damage>0 then
			if dmgfold:FindFirstChild("RDM")==nil and enemyplayer and enemyplayer.Character and enemyplayer.Character:FindFirstChild("RDMProtection") and player.Status.Role.Value~="Traitor" then
				local bp=Instance.new("IntValue")
				bp.Parent=dmgfold
				bp.Name="RDM"
			end
		dmgfold.DMG.Value=dmgfold.DMG.Value+damage
		dmgfold.Hits.Value=dmgfold.Hits.Value+1
		end
		if armordmg==true then
		enemyplayer.Kevlar.Value=math.max(0,enemyplayer.Kevlar.Value-(origdamage*((100-gun.ArmorPenetration.Value)/100)))
		end
		if hum and hum.Parent and hum.Parent:FindFirstChild("Rage") and hum.Parent.Rage.Value<100 then
			hum.Parent.Rage.Value=math.clamp(hum.Parent.Rage.Value+((damage*100)/1000),0,100)
			
		end
		
		if hum.Parent:FindFirstChild("HumanoidRootPart") and hum.Parent.HumanoidRootPart:FindFirstChild("damage1") then	
			if hum.Parent:FindFirstChild("DMG") then -- hey tc here, idk how the fuck this script works ok
			hum.Parent.DMG.Value=hum.Parent.DMG.Value+damage
			if hum.Parent.DMG.Value>=100 then
				hum.Parent.DMG.Value=0
				hum.Parent.HumanoidRootPart["damage"..math.random(1,3)]:Play()
			end
			end
		end
		hum:TakeDamage(damage)
	end
	if (hum.Health-damage)<=0 then
		if enemyplayer and enemyplayer.Character and enemyplayer.Character:FindFirstChild("RDMProtection") and player:FindFirstChild("RDM") and player.Status.Role.Value~="Traitor" then
			local bap=repst.Sounds["Damage"..math.random(1,3)]:clone()
			bap.Parent=game.Workspace
			bap.PlayOnRemove=true
			bap:Destroy()
			repst.Events.SendMsg:FireAllClients(player.Character.Name.." has been slain for RDM!",Color3.new(210/255,0,0))
			player.Character.Humanoid.Health=0
		end
		if player:FindFirstChild("RDM")==nil and player.Status.Role.Value~="Traitor" then
			player.Status.Karma.Value=mmin(1000,(player.Status.Karma.Value+40))
		end
	end
end


return Damage