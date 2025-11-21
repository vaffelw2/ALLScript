local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

if game:GetService("RunService"):IsStudio() == false then 
	game:BindToClose(function()
		if (#Players:GetPlayers() == 0) then
			return
		end
		
		if game:GetService("RunService"):IsStudio() then
			-- Offline
			return
		end
		game.ReplicatedStorage.Events.SendMsg:FireAllClients("WARNING: The server will shutdown for updates shortly.",Color3.new(210/255, 0, 0))
		game.Workspace.ServerShutdown.Value=true
		local placeId=game.PlaceId
		--TeleportService:TeleportPartyAsync(placeId, Players:GetPlayers())
		local pp=game.Players:GetPlayers()
		for i=1,#pp do
			spawn(function()
				game:GetService("TeleportService"):Teleport(game.PlaceId,pp[i])
			end)
		end
		while (#Players:GetPlayers() > 0) do
			wait()
		end	
	end)
	end