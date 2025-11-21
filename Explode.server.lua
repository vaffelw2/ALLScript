local gunname=script.gun.Value
local gunsound=game.ReplicatedStorage.Weapons[gunname].Model.Shoot
local Creator = script.creator.Value
local TakeDamage = require(game.ReplicatedStorage.Modules.Damage)



script.Parent.ChildAdded:connect(function(OBJ)
	if OBJ.Name == "Fart" then
		repeat wait(0.5) until script.Parent.Velocity.magnitude<=0.5
		script.Parent.Anchored=true
		script.Parent.Sparkles.Enabled=true
		local starttime=tick()
		repeat
			local int=math.random(1,math.min(10,gunsound.Parent.Parent.Ammo.Value))
			for i=1,int do 
				wait(math.max(gunsound.Parent.Parent.FireRate.Value,1/int))
				local fs=gunsound:clone()
				fs.Parent=script.Parent
				fs:Play()
				delay(fs.TimeLength,function()
					fs:Destroy()
				end)
			end
			local interval=gunsound.Parent.Parent.ReloadTime.Value
			if int<=3 then
				interval=gunsound.Parent.Parent.Spread.RecoveryTime.Value/1.5
			end
			wait(interval)
			---make them think they're reloading lole
		until (tick()-starttime)>=15
		script.Parent.Sparkles.Enabled=false
		script.Parent.Handle2.Transparency=1
		---------------------------
		local explo=Instance.new("Explosion")
		explo.Name = "BoomBoom"
		explo.Parent=game.Workspace
		explo.Position=script.Parent.Position
		explo.BlastPressure=0
		explo.BlastRadius=20
		local Range = 20
		local Players = game.Players:GetPlayers()
		for i=1, #Players do
			if Players[i].Status.Team.Value ~= Creator.Status.Team.Value or Players[i] == Creator then
				if Players[i].Character then
					local distance = (Players[i].Character.UpperTorso.Position - script.Parent.Position).magnitude
					if Range>= distance then
						local Humanoid=Players[i].Character.Humanoid
						if Humanoid:FindFirstChild("creator") then
							Humanoid.creator:Destroy()
						end
						local c = Instance.new("ObjectValue")
						c.Name = "creator"
						c.Value = Creator
						delay(1,function()
							c:Destroy()
						end)
						c.Parent = Humanoid
						local piece=Instance.new("StringValue")
						piece.Parent=c
						piece.Name="NameTag"
						piece.Value="HE Grenade"
					--	print("Within range")
				--		print(distance .. " / " .. Range)
						local Damage=2
					--	print(MaxDamage .. "*" .. Gauge)
					--	print(Damage)
						--game.ReplicatedStorage.Events.Deafen:FireClient(Players[i],full,duration)
						TakeDamage.takeDamage(Creator,Players[i].Character.Humanoid,Damage,game.ReplicatedStorage.Weapons["Decoy Grenade"],false,false)
					end
				end
			end
		end
		script.Parent["Explode"..math.random(1,3)]:Play()
		wait(2)
		script.Parent:Destroy()
	end
end)
