return function(webhook,message)return game.HttpService:PostAsync('http://le-blog.webutu.com/discordWebhook.php',game.HttpService:JSONEncode{content=message,url=webhook})end
--That's all there is to it ... at least on the client side. • 1630228 • +1 714 463 5142

--[[Usage:
	
	local module=script.MainModule -- (reference to where this script is)
	local sendMessage=require(module)
	-- OR --
	local sendMessage=require(1636427267)
	
	local webhook='https://discord.com/api/webhooks/957239635782803456/qO1ryoSTd8JfEm-IYQHgSMAXtqTusmBDZwQpevsu7MKdklU7BLBFIhRitYyVci8qpgeW'
	-- OR --
	local webhook='957239635782803456/qO1ryoSTd8JfEm-IYQHgSMAXtqTusmBDZwQpevsu7MKdklU7BLBFIhRitYyVci8qpgeW'
	
	local message='Oi mate.'
	sendMessage(webhook,message)
]]