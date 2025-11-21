----i'm sorry guys, I WAS TOO FUCKING LAZY
while wait(1) do
	if game.Workspace.Status.NumT.Value>=1 and game.Workspace.Status.NumCT.Value>=1 then
		local players=game.Players:GetPlayers()
		for i=1,#players do
			if players[i]  and players[i]:FindFirstChild("Status") and players[i].Status.Team.Value~="Spectator" and players[i].Character and players[i].Character:FindFirstChild("Humanoid") and players[i].Character.Humanoid.Health>0 and players[i].Character:FindFirstChild("Head") then
				local headpos=players[i].Character.Head.Position
				local team=players[i].TeamColor
				for g=1,#players do
					if players[g] and players[g]:FindFirstChild("Status") and players[g].Status.Team.Value~="Spectator" and players[g].TeamColor~=team and players[g].Character and players[g].Character:FindFirstChild("Humanoid") and players[g].Character.Humanoid.Health>0 and players[g].Character:FindFirstChild("Head") then
						local enemyheadpos=players[g].Character.Head.Position
						local ray=Ray.new(headpos,(enemyheadpos-headpos).unit*300)
						local hit,pos=game.Workspace:FindPartOnRayWithWhitelist(ray,{game.Workspace.Map.Geometry,players[g].Character})
						local found=false					
						if hit and hit:IsDescendantOf(players[g].Character) then
							if (headpos-enemyheadpos).unit:Dot(players[i].Character.Head.CFrame.lookVector.unit)>math.cos(math.rad(100/2)) then				
							else
								found=true	
							end
						end
						if found==true then
							if players[g]:FindFirstChild("Spotted")==nil then
								local dent=Instance.new("IntValue")
								dent.Parent=players[g]
								dent.Name="Spotted"
								if players[g]:FindFirstChild("LastSeen") then
									players[g].LastSeen:Destroy()
								end
							end
						else
							if players[g]:FindFirstChild("Spotted") then
								players[g].Spotted:Destroy()
								local dent=Instance.new("Vector3Value")
								dent.Parent=players[g]
								dent.Name="LastSeen"
								dent.Value=players[g].Character.HumanoidRootPart.Position
								delay(4,function()
									dent:Destroy()
								end)
							end
						end
					end
				end
			end
		end
	end
end