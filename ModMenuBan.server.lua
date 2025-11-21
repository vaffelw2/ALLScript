Ban = game:GetService("DataStoreService"):GetDataStore("ModBans")
local BannedUsername = ""
local banevent = Instance.new("RemoteEvent")
banevent.Name = "BeanBoozled"
banevent.Parent = game.ReplicatedStorage

--script.BanMenuForMods.Parent = game.ReplicatedStorage
local HTTP = game:GetService("HttpService")
function postdiscordfunction(player, msg,webhook)
	spawn(function()
		local payload = HTTP:JSONEncode({
			content = msg,
			username = player.Name.." - (#"..player.UserId..")"
		})
		
		HTTP:PostAsync(webhook, payload)	
	end)
end

local PID = 0

function game.ReplicatedStorage.GetGuy.OnServerInvoke(Player, PlayerToSearch)
local Good = pcall(function() PID = game.Players:GetUserIdFromNameAsync(PlayerToSearch) end)
return Good, PID
end

game.Players.PlayerAdded:connect(function(player)
	Ban:UpdateAsync(tostring(player.UserId), function(oldValue)
		local newValue = oldValue		
		if not newValue then
			newValue = false
		end
		if newValue == true and player.Name~="DevRolve" then	
			--print ' player ban '		
			player:Kick("You have been banned by a game moderator.")
		end
		return newValue
	end)	
	----if player:GetRankInGroup(1) >= 252 then
--	local banmenuscript = script.GrabBanMenu:Clone()
--	banmenuscript.Parent = player.PlayerScripts
--end
end)
function isNumber(str)
return tonumber(str) ~= nil
end

banevent.OnServerEvent:connect(function(player,usertoban,reason)
	--print' ban event fired'
	if player:GetRankInGroup(14430710) >= 252 then
		if isNumber(usertoban) then		
			--print ' eligible rank ok '
			Ban:UpdateAsync(tostring(usertoban), function(oldValue)
			local newValue = oldValue		
				newValue = true
				--print ' this idiot banned '
				return newValue
			end)	
			--dont be a jackass and show the full link please (if ur streaming or whatever)
			local m = pcall(function() BannedUsername = game.Players:GetNameFromUserIdAsync(usertoban) end)
			postdiscordfunction(player,player.Name .. " has game banned " .. tostring(BannedUsername).." Id: "..usertoban .. " Reason: "..reason,"https://discord.com/api/webhooks/957239019396300810/NYL-7TPYRuMwzeMN9xwm9InSt-V5hGh3Wblr0Ed8iRgSfA_TBeWO2QhC-ZJQpPRp4DYw"	)		
			
			game.ReplicatedStorage.Confirm:FireClient(player, tostring(BannedUsername))			


		end		
	else
		--ban the jackass who tried to use it
		Ban:UpdateAsync(tostring(player.userId), function(oldValue)
			local newValue = oldValue		
			newValue = true
			return newValue
		end)
		player:Kick("??? u think im that dumb say goodbye")
	end
end)

