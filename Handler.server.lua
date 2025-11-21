local dss = game:GetService("DataStoreService")
local TimedBans = dss:GetDataStore("TimedBans")
local Group_ID = 14673267

local url = "https://hooks.hyra.io/api/webhooks/967116320648872066/4bssjhgF4LB6fXElhg3zvD3BdPGdjFawwOQAiGEgX7xr7AlglKVe86Qt7U-m_J1Gz0-y"
local http = game:GetService("HttpService")

local function BanWEBHOOK(plr,username,uid,reason,days)
	--[[local data = {
		["content"] = " ```USER BANNED```\n\n**[MODERATOR]:** "..plr.Name.."\n**[USER]:** "..username.."\n**[REASON]:** "..reason.."\n**[TIME]:** "..days.." Days",
	}]]
	
	
	local avatar = game.Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
	
	local data = {
		{
			["content"] = "",
			["embeds"] = {
				{
					["title"] = "USER BANNED",
					["description"] = "**[MODERATOR]**: "..plr.Name.."\n**[USER]**: "..username.."\n**[REASON]**: "..reason.."\n**[TIME]**: "..days.."Days",
					["color"] = 16711680,
					["thumbnail"] = {
						["url"] = avatar
					}
				}
			},
			["attachments"] = {}
		}
	}

	data = http:JSONEncode(data)
	http:PostAsync(url, data)
end

local function UnbanWEBHOOK(plr,username,uid)
	--[[local data = {
		["content"] = " ```USER UNBANNED```\n\n**[MODERATOR]:** "..plr.Name.."\n**[USER]:** "..username.."",
	}]]
	
	local avatar = game.Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)

	local data = {
		{
			["content"] = "",
			["embeds"] = {
				{
					["title"] = "USER BANNED",
					["description"] = "**[MODERATOR]**: "..plr.Name.."\n**[USER]**: "..username.."",
					["color"] = 16711680,
					["thumbnail"] = {
						["url"] = avatar
					}
				}
			},
			["attachments"] = {}
		}
	}

	
	data = http:JSONEncode(data)
	http:PostAsync(url, data)
end

local function KickWEBHOOK(plr,username,uid,reason)
	--[[local data = {
		["content"] = " ```USER KICKED```\n\n**[MODERATOR]:** "..plr.Name.."\n**[USER]:** "..username.."\n**[REASON]:** "..reason.."",
	}]]
	
	--[[local data = {
		["content"] = "",["embeds"] = {{{["description"] = "➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖",["color"] = 16711680,["fields"] = {{["name"] = "Moderator:",["value"] = "```"..plr.Name.."```"},{["name"] = "Banned Player:",["value"] = "```"..username.."```"},{["name"] = "Reason:",["value"] = "```"..reason.."```"}},["author"] = {["name"] = "❌ Player Kicked!"},["attachments"] = {}
	}}}}]]
	
	local avatar = game.Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)

	local data = {
		{
			["content"] = "",
			["embeds"] = {
				{
					["title"] = "USER KICKED",
					["description"] = "**[MODERATOR]**: "..plr.Name.."\n**[USER]**: "..username.."\n**[REASON]**: "..reason.."",
					["color"] = 16711680,
					["thumbnail"] = {
						["url"] = avatar
					}
				}
			},
			["attachments"] = {}
		}
	}


	data = http:JSONEncode(data)
	http:PostAsync(url, data)
end

game.ReplicatedStorage.Ban.OnServerEvent:Connect(function(plr,fun,username,reason,days,ServerLock)
	if plr:IsInGroup(Group_ID) then
		if fun == "Ban" then
			local uid = game.Players:GetUserIdFromNameAsync(username)

			local ostime = os.time()
			local da = tonumber(days)
			local d = da * 86400
			local length = d + ostime

			local tabl = {uid,reason,length}

			TimedBans:SetAsync(uid,tabl)
			
			--BanWEBHOOK(plr,username,uid,reason,days)
			game.Workspace.RacBanFeed.Value = username
			
			if game.Players:FindFirstChild(username) == nil then
				print("User is not in-game!")
			else
				game.Players:FindFirstChild(username):Kick("\nYou've Been Banned By: RAC\nFor The Reason of: "..reason.."\n"..days.." Days Remaining Until Unban")
			end
		end
		if fun == "Unban" then
			local uid = game.Players:GetUserIdFromNameAsync(username)
			TimedBans:SetAsync(uid,{".",".","."})
			--UnbanWEBHOOK(plr,username,uid)
		end
		if fun == "Kick" then
			if game.Players:FindFirstChild(username) == nil then
				print("User is not in-game!")
			else			
				local uid = game.Players:GetUserIdFromNameAsync(username)
				--KickWEBHOOK(plr,username,uid,reason)
				game.Players:FindFirstChild(username):Kick("\nYou've Been Kicked By: RAC\nFor The Reason of: "..reason.."\n Rejoin The Game To Play Again")
			end
		end
		if fun == "ServerLock" then
			if ServerLock == "SERVER:LOCKED" then
				_G.Locked = true
			elseif ServerLock == "SERVER:UNLOCKED" then
				_G.Locked = false
			end
		end
	end
end)