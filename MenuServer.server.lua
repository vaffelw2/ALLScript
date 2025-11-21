local BoolSettings = {"LowQuality" ,"LowViolence", "AltCrouch"}
local NumberSettings = {"MusicVolume", "FOV"}
DS = game:GetService("DataStoreService"):GetDataStore("stinky2")
CB = game:GetService("DataStoreService"):GetDataStore("CBRBans")
local LoadingScreens = {"rbxassetid://976512810", "rbxassetid://976509551", "rbxassetid://976507454", "rbxassetid://976504362"}
local hng = math.random(1,4)
game.ReplicatedStorage.Loading.Retrieving.BG.Image = LoadingScreens[hng]


game.ReplicatedStorage.JoinPlayer.OnServerEvent:connect(function(player,tit)
    local success, errorMsg, placeId, instanceId=game:GetService('TeleportService'):GetPlayerPlaceInstanceAsync(tit)
    if placeId and instanceId then
		game.ReplicatedStorage.Events.Recieve:FireClient(player)
        game:GetService('TeleportService'):TeleportToPlaceInstance(placeId, instanceId, player, nil, nil, game.ReplicatedStorage.Loading)
    else
		--print(tit)
       -- print("Teleport error:", errorMsg)
    end
end)



function datasave(p)
	local path = game.ServerStorage.PlayerData:FindFirstChild(tostring(p))
	if path then
		--print("Data location accessed")
		if path:FindFirstChild("Cooldown") == nil then
		if path.SetChanged.Value == true then
		local data2save = {path.Settings.LowViolence.Value, path.Settings.LowQuality.Value, path.Settings.MusicVolume.Value, path.Settings.AltCrouch.Value,
			path.Settings.FOV.Value}
			local stinker, help = pcall(function() 
			DS:SetAsync("config2-"..p.UserId, data2save)				
			end)
			if stinker == true then
			--	print("Saved data woo")
			else
			--	warn("poo"..help)
			end
		local nb = Instance.new("IntValue")
		nb.Name = "Cooldown"
		nb.Parent = path
		end
		end
		end
end

function getdata(p)
	local pdata = DS:GetAsync("config2-"..p.UserId)
		if pdata then
			for i, v in ipairs(pdata) do
				--print(v)
			end
			local path = game.ServerStorage.PlayerData:FindFirstChild(tostring(p))
			path.Settings.LowViolence.Value = pdata[1]
			path.Settings.LowQuality.Value = pdata[2]
			path.Settings.MusicVolume.Value = pdata[3]
			path.Settings.AltCrouch.Value = pdata[4]
			path.Settings.FOV.Value = pdata[5]

			--print("Loaded settings.")
			
		else --print("no data")
		end
end

function game.ReplicatedStorage.GetFollowServer.OnServerInvoke(p, v)
local bl, err, place, jobid = game:GetService("TeleportService"):GetPlayerPlaceInstanceAsync(v)	
if bl then
	return place, jobid
else
	return err
end
end



function game.ReplicatedStorage.ChangeSetting.OnServerInvoke( p, setting, setv) 
--print("changing: "..setting.." to: "..tostring(setv).." for: "..tostring(p))
game.ServerStorage.PlayerData:FindFirstChild(tostring(p)).SetChanged.Value = true
if setv == true or setv == false then
if game.ServerStorage.PlayerData:FindFirstChild(tostring(p)) then
	game.ServerStorage.PlayerData:FindFirstChild(tostring(p)).Settings:FindFirstChild(tostring(setting)).Value = setv
	--print("Changed boolean!")
end
end
if tonumber(setv) then
	game.ServerStorage.PlayerData:FindFirstChild(tostring(p)).Settings:FindFirstChild(tostring(setting)).Value = setv
	--print("Changed number!")
end
	
end

function game.ReplicatedStorage.GetSettings.OnServerInvoke(p)
	getdata(p)
end

function game.ReplicatedStorage.RecieveSettings.OnServerInvoke(p)
	local path = game.ServerStorage.PlayerData:FindFirstChild(tostring(p))
	local data2send = {path.Settings.FOV.Value}
	return data2send
end


game.Players.PlayerAdded:connect(function(p) 
	CB:UpdateAsync(tostring(p.userId), function(oldValue)
		local newValue = oldValue
		if newValue == nil then
			newValue = false
		end
		if newValue == true then
			game.ReplicatedStorage.Kick:FireClient(p)
			p:Kick("Your case has been reviewed and have been permanently RAC banned")
			
		end
		return newValue
	end)
	repeat wait() until p and p:FindFirstChild("PlayerGui")

--		local f = Instance.new("Folder")
--		f.Name = p.Name
--		f.Parent = game.ServerStorage.PlayerData
--		local f2 = Instance.new("Folder")
--		f2.Name = "Settings"
--		f2.Parent = f
--		
--		for i, v in ipairs(BoolSettings) do
--			local b = Instance.new("BoolValue")
--			b.Value = false
--			b.Name = v 
--			b.Parent = f2
--		end
--		
--		for i, v in ipairs (NumberSettings) do
--			local n = Instance.new("IntValue")
--			n.Value = 0
--			n.Name = v 
--			n.Parent = f2
--		end
--		
--			f2.LowMapDetail.Value = false
--			f2.LowerParticles.Value = false
--			f2.LowViolence.Value = false
--			f2.AltCrouch.Value = false
--			f2.MusicVolume.Value = 50
--			f2.GamepadSensitivity.Value = 70
--			f2.MouseSensitivity.Value = 100
--			
--		local bo = Instance.new("BoolValue")
--		bo.Value = false
--		bo.Name = "SetChanged"
--		bo.Parent = f
		hng = math.random(1,4)

		game.ReplicatedStorage.Loading.Retrieving.BG.Image = LoadingScreens[hng]
		if p.FollowUserId and tonumber(p.FollowUserId) and tonumber(p.FollowUserId)>0 then
			local targetUserId=p.FollowUserId
			local success, errorMsg, placeId, instanceId = game:GetService("TeleportService"):GetPlayerPlaceInstanceAsync(targetUserId)
			--print(p.FollowUserId)
			if placeId and instanceId then
				--print("following")
				game:GetService("TeleportService"):TeleportToPlaceInstance(placeId,instanceId,p, nil, nil, game.ReplicatedStorage.Loading)
			end
		end
end)

game.Players.PlayerRemoving:Connect(function(p)
	if game.ServerStorage.PlayerData:FindFirstChild(tostring(p)) then
		game.ServerStorage.PlayerData:FindFirstChild(tostring(p)):Destroy()
		--print("Cleared server cache")
	end
end)
game.ReplicatedStorage.Events.SaveData.OnServerEvent:connect(function(player)
	datasave(player)
end)
