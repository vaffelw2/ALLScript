--	services

local ReplicatedStorage	= game:GetService("ReplicatedStorage")
local DataStoreService	= game:GetService("DataStoreService")
local Players			= game:GetService("Players")
local banurl            = "https://discord.com/api/webhooks/957240069608058941/CjMUTz2pVnbl5PNTTzK9u-_LBHkNX5g49AC79GM1QfaepuenHsfjshsj-U_dsdrWQXPC"
local http              = game:GetService("HttpService")
webhook                 = require(script.Parent.Webhook)

--	constants

local GroupId	= 14430710
local Webhook	= require(script.Parent.Webhook)
local Bans		= DataStoreService:GetDataStore("NewBans")
local Ban		= ReplicatedStorage:FindFirstChild("Ban")

--	functions

local function getDay(seconds)	
	return math.floor(seconds/86400)
end

local function kickUser(user, banner, reason, length)
	local timer = os.time()
	length		= length-getDay(timer)
	
	user:Kick("\nYou've been banned by "..banner.." for :\n"..reason.."\nYou'll be unbanned in "..length.." day(s)")
end

local function banUser(banner, user, reason, length)
	local timer = os.time()
	local data = {
		['embeds'] = {
			{
				['title'] = user,
				['description'] = user .. " got banned for "..reason.." for ".." days "..length,
				['color'] = 0
			}
		}
	}
	local finalData = http:JSONEncode(data)
	http:PostAsync(banurl, finalData)("https://discord.com/api/webhooks/957239847393849384/mNgLpA7RlSproDLkmb9Gq_g4sReFHcsMY7ar-6V4RdetM0N7g-R_MWRvKA9-KLw-jKrG")
	
	Bans:SetAsync(user, {banner, reason, getDay(timer+(86400*(length)))})
end

Ban.OnServerEvent:connect(function(player, user, reason, length)
	if player:IsInGroup(GroupId) and player:GetRankInGroup(GroupId) >= 251 then
		banUser(player.Name, Players:GetUserIdFromNameAsync(user), reason, tonumber(length))
		
		if Players:FindFirstChild(user) then
			local timer = os.time()
			length		= getDay(timer+(86400*(length)))
			
			kickUser(Players:FindFirstChild(user), player.Name, reason, length)
		end
	end
end)

Players.PlayerAdded:connect(function(player)
	spawn(function()
		local timer		= os.time()
		local BanData	= Bans:GetAsync(player.userId)
		
		if BanData and BanData[3]-getDay(timer) >= 1 and BanData[2] ~= "Aimbot" and BanData[2] ~= "Aimbots" then
			wait(0.5)
			
			kickUser(player, BanData[1], BanData[2], BanData[3])
		end
	end)
end)