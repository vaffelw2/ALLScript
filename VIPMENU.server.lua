local studio	= game:GetService("RunService"):IsStudio()
local PhysicsService=game:GetService("PhysicsService")
if game.VIPServerId ~= "" or string.len(tostring(game.VIPServerId)) > 1 or studio then
--	print("WELCOME TO THE VIP SERVER!!")
	vipowner = game.VIPServerOwnerId
	gameowner = game.CreatorId
	
	if studio then
		vipowner	= 65945437
	end
	
	game.ReplicatedStorage.Events.VIPevent.OnServerEvent:connect(function(player,args)
		--obviously check if they are actual owner
		--/dab
		if vipowner == player.userId or gameowner == player.userId or player:GetRankInGroup(14430710) >= 254 or player:GetRankInGroup(14673267) >= 1 then
			if args[1] == "Restart" then
				workspace.Status.Timer.Value = 1
				script.STOP.Value = true
				game.ReplicatedStorage.Events.SendMsg:FireAllClients("Game Ends After This Round",Color3.new(1, 1, 1))
				--print('set ')
			elseif args[1] == "Cash-in-pocket" then
				local players = game.Players:GetPlayers()
				for i=1,#players do
					players[i].Cash.Value = 99999999
					
				end
				game.ReplicatedStorage.Events.SendMsg:FireAllClients("Cash in pocket",Color3.new(1, 1, 1))
			elseif args[1] == "Kick" then
				game.Players:FindFirstChild(args[2]):Kick()
			elseif args[1] == "Comp" then
				game.ReplicatedStorage.gametype.Value="competitive"
				PhysicsService:CollisionGroupSetCollidable("CT", "CT", true)
				PhysicsService:CollisionGroupSetCollidable("T", "T", true)
				workspace.Status.Timer.Value = 1
				script.STOP.Value = true
			elseif args[1] == "Changemap" then
				workspace.Status.Timer.Value = 1
				script.forcemap.Value = args[2]
				script.STOP.Value = true
				game.ReplicatedStorage.Events.SendMsg:FireAllClients("Map changes to :"..args[2].." after this round",Color3.new(1, 1, 1))
			elseif args[1] == "Warmup" then
				script.forcewarmup.Value = not script.forcewarmup.Value		
				game.ReplicatedStorage.Events.SendMsg:FireAllClients("Toggling warmup to "..tostring(script.forcewarmup.Value),Color3.new(1, 1, 1))
			elseif args[1] == "Cleanup" then
				workspace.Debris:ClearAllChildren()		
			elseif args[1] == "Killtrade" then
				
				workspace.Status.Killtrade.Value = not workspace.Status.Killtrade.Value
				game.ReplicatedStorage.Events.SendMsg:FireAllClients("Killtrade setting set to :"..tostring(workspace.Status.Killtrade.Value),Color3.new(1, 1, 1))
			end
		end
		
	end)
	function game.ReplicatedStorage.Functions.GetOwner.OnServerInvoke(player)
		--print ' HAS RECIEVED LOL '
		-- oh hell no you ain't hittin me with a fucking PRINT YOU MOTHER FUCKIN' apostrophe GET THIS SHIT OUT OF HERE NOW
		--print(is_vip_server[2])
		if player.userId==vipowner or gameowner == player.userId then
			return true
		else
			return false
		end
	end
else
	--print("not a vip server")

	
end