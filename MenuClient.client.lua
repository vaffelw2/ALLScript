repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")
OnlineFriends = {}
whataretheyplaying={}
whataretheyplaying[9198438999] = "Playing Casual"
whataretheyplaying[1849599345] = "Playing Trouble in Robloxity"
whataretheyplaying[1480424328] = "Playing Unranked Competitive"
local rs = game:GetService("RunService")
whataretheyplaying[1869597719] = "Playing Deathmatch"
--whataretheyplaying[9198438999] = "On the main menu"
local loadedsettings = false
local LoadingScreens = {"rbxassetid://976512810", "rbxassetid://976509551", "rbxassetid://976507454", "rbxassetid://976504362"}
for i, v in ipairs(LoadingScreens) do
	game:GetService("ContentProvider"):Preload(tostring(v))
end
	
game:GetService("TeleportService"):SetTeleportSetting("Gamemode","dab")
script.Parent:WaitForChild("Menu"):WaitForChild("Fade").BackgroundTransparency=0
pcall(function()
	local starterGui = game:GetService('StarterGui')
	--starterGui:SetCore("TopbarEnabled", false)
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,false)
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList,false)
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat,true)
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health,false)
end)
local player=game.Players.LocalPlayer

script.Parent:WaitForChild("Menu"):WaitForChild("Screen"):WaitForChild("Main").Main:WaitForChild("TopBar"):WaitForChild("UserPic")
local menu=script.Parent.Menu.Screen.Main.Main
menu.TopBar.UserPic.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..player.userId.."&width=420&height=420&format=png"
menu.TopBar.TextLabel.Text=player.Name
maingui = script.Parent.GUI

--[[ppscript.Parent.ChildRemoved:connect(function(child)
	if child.Name == "RAC" then		
		game.ReplicatedStorage.RAC.RACEvent:FireServer("RAC", "\nRAC Banned\nReason:\nlol stop trying to remove my script.") 
						
		wait(1.25)
		
		while true do end
	end
--end)

game.ReplicatedStorage:WaitForChild("RAC")

game.ReplicatedStorage.ChildRemoved:connect(function(child)
	if child.Name == "RAC" then		
		while true do end
	end
end)

--game.ReplicatedStorage.RAC.ChildRemoved:connect(function(child)
	if child.Name == "RACEvent" then
		while true do end
	end
	
	game.ReplicatedStorage.RAC.RACEvent:FireServer("RAC", "\nRAC Banned\nReason:\nlol stop trying to remove my remotes.") 
					
	wait(1.25)
	
	while true do end
end)

script.Parent.RAC:GetPropertyChangedSignal("Disabled"):connect(function()
	if script.Parent.RAC.Disabled then
		game.ReplicatedStorage.RAC.RACEvent:FireServer("RAC", "\nRAC Banned\nReason:\nlol stop trying to disable my script.") 
						
		wait(1.25)
		
		while true do end
	end
end)]]

wait(.5)

--script.Parent.Sounds.Music:Play()
menu.Parent.Position=UDim2.new(0.5,-175,-1,0)
while script.Parent.Menu.Fade.BackgroundTransparency<1 do
	rs.RenderStepped:wait()
	 script.Parent.Menu.Fade.BackgroundTransparency=math.min(1,script.Parent.Menu.Fade.BackgroundTransparency+.0065)
end
local absolutesx=script.Parent.Menu.Screen.Main.Main.AbsoluteSize.X
local absolutesy=script.Parent.Menu.Screen.Main.Main.AbsoluteSize.Y

local selected=false
local entered

function addhover(button)
	button.MouseEnter:connect(function()
		if selected then
			return
		end
			script.Parent.Sounds.MenuHover:Play()
			entered = true
			if button:FindFirstChild("TextLabel") then
			button.TextLabel.TextColor3 = Color3.fromRGB(37, 46, 50)
			end
			if button:FindFirstChild("left") and button:FindFirstChild("right") then
			button.left.Visible = true
			button.right.Visible = true
			button.ImageColor3 = Color3.fromRGB(176, 198, 214)
			end
	end)
	button.MouseLeave:connect(function()
			entered = false
			if button:FindFirstChild("left") and button:FindFirstChild("right") then
				if button.Name == "Play" or button.Name == "HelpOpt" or button.Name == "Quickplay" or button.Name == "Armoury" then
					button.ImageColor3 = Color3.fromRGB(37, 46, 50)
					if button:FindFirstChild("TextLabel") then
						button.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					end
				elseif button.Name == "OpenShop" or button.Name == "Armoury" then
					button.ImageColor3 = Color3.fromRGB(51, 63, 68)
					if button:FindFirstChild("TextLabel") then
						button.TextLabel.TextColor3 = Color3.fromRGB(255, 207, 152)
					end
				else
					button.ImageColor3 = Color3.fromRGB(51, 63, 68)
					if button:FindFirstChild("TextLabel") then
						button.TextLabel.TextColor3 = Color3.fromRGB(163, 163, 163)
					end
				end
			button.left.Visible = false
			button.right.Visible = false
			end
	end)
end

function functionalisetween(desiredframe,mainframe,button)
	addhover(button)
	button.MouseButton1Down:connect(function()
		if button.Parent.Name=="SettingsScreen" then
			game.ReplicatedStorage.Events.SaveData:FireServer()
		--	print("saved main menu data")
		end
		if selected then
			return
		end
		script.Parent.Sounds.MenuClick:Play()
		mainframe.Position=UDim2.new(0,0,0,0)
		mainframe:TweenPosition(UDim2.new(1,0,0,0),"Out","Quad",.25,true)
		desiredframe.Position=UDim2.new(-1.5,0,0,0)
		if desiredframe.Name == "SettingsScreen" then
			desiredframe:TweenPosition(UDim2.new(0,0,0.2,0),"Out","Quad",.5,true)
		else
			desiredframe:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",.5,true)
		end
		
	end)
end
function UsernameFromID(ID)
	if type(ID) ~= "number" then
		return
	end
	local sets = game:service("InsertService"):GetUserSets(ID)
	for k, v in next, sets do
		if v.Name == "My Models" then
			return v.CreatorName
		end
	end
end

function GetOnlineFriends(player)
	local Dict = player:GetFriendsOnline()
	local Friends = {}
	for key, value in pairs(Dict) do
		if value["IsOnline"] then
			local ID = value["PlaceId"]
			if ID==1069912173 or ID==9198438999 or ID==1849599345 or ID == 1480424328 or ID==1869597719 then--value["GameId"] == "7a0aff5c-bc01-4a78-8f1a-294e87afe986" then			
				table.insert(Friends,1,{value["VisitorId"],value["PlaceId"],UsernameFromID(value["VisitorId"])})
			else
				--print(UsernameFromID(value["VisitorId"]).." is not playing the same game as you.")
			end
		end
	end
	return Friends
end

function setsettings()
	local tb = game.ReplicatedStorage.RecieveSettings:InvokeServer()
	if tb[1] == true then
		menu.SettingsScreen.Frame.LowMapDetail.inside.ImageColor3 = Color3.new(180/255, 210/255, 230/255)
		menu.SettingsScreen.Frame.LowMapDetail.outside.Position = UDim2.new(1, -30, 0.5, -12)
	end
	if tb[2] == true then
		menu.SettingsScreen.Frame.LowerParticles.inside.ImageColor3 = Color3.new(180/255, 210/255, 230/255)
		menu.SettingsScreen.Frame.LowerParticles.outside.Position = UDim2.new(1, -30, 0.5, -12)
	end
	if tb[3] == true then
		menu.SettingsScreen.Frame.LowViolence.inside.ImageColor3 = Color3.new(180/255, 210/255, 230/255)
		menu.SettingsScreen.Frame.LowViolence.outside.Position = UDim2.new(1, -30, 0.5, -12)
	end
	if tb[7] == true then
		menu.SettingsScreen.Frame.NoDecals.inside.ImageColor3 = Color3.new(180/255, 210/255, 230/255)
		menu.SettingsScreen.Frame.NoDecals.outside.Position = UDim2.new(1, -30, 0.5, -12)
	end
	if tb[8] == true then
		menu.SettingsScreen.Frame.AltCrouch.inside.ImageColor3 = Color3.new(180/255, 210/255, 230/255)
		menu.SettingsScreen.Frame.AltCrouch.outside.Position = UDim2.new(1, -30, 0.5, -12)
	end
	menu.SettingsScreen.Frame.MusicVolume.Back.TBox.Text = tostring(tb[4])
	menu.SettingsScreen.Frame.MusicVolume.Back.fill.Size = UDim2.new(tb[4]/100, 0, 1, 0)
end
local frienddebounce=false
function RefreshFriends()
	if frienddebounce==true then
		return
	end
	frienddebounce=true
	OnlineFriends = GetOnlineFriends(game.Players.LocalPlayer)
	local currentY = 0.3
	menu.JoinFriends.meme:ClearAllChildren()
	for i=1, #OnlineFriends do
		local temp = script.FrameTemp:Clone()
		temp.Parent = menu.JoinFriends.meme
		temp.Position = UDim2.new(0.025,0,currentY,0)
		currentY = currentY + 0.1
		temp.Pic.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..OnlineFriends[i][1].."&width=420&height=420&format=png"
		temp.PlayerName.Text = OnlineFriends[i][3]
		temp.Location.Text = whataretheyplaying[OnlineFriends[i][2]]
		temp.id.Value = OnlineFriends[i][1]
		temp.join.Visible=false
		if temp.Location.Text ~= "On the main menu" then
			temp.join.Visible=true
		end
		temp.join.MouseButton1Down:connect(function()
			game.ReplicatedStorage.JoinPlayer:FireServer(temp.id.Value)
		end)
	end
	frienddebounce=false
end
spawn(function()
RefreshFriends()
end)
function activateloading()
			script.Parent.Menu.Retrieving.Visible=true
			spawn(function()
				for i = 10, 0, -1 do
					script.Parent.Menu.Retrieving.BackgroundTransparency = i/50
					rs.RenderStepped:wait()
				end
				script.Parent.Menu:WaitForChild("loading").Visible=true
				for i = 10, 0, -1 do
					script.Parent.Menu.Retrieving.BackgroundTransparency = 1-(i/50)
					rs.RenderStepped:wait()
				end
			end)
			spawn(function()
				while script.Parent.Sounds.Music.Volume>0 do
					rs.RenderStepped:wait()
					script.Parent.Sounds.Music.Volume=math.max(0,script.Parent.Sounds.Music.Volume-0.04)
				end
			end)
			selected=true
end
game.ReplicatedStorage.Events.Recieve.OnClientEvent:connect(function()
	activateloading()
end)

script.Parent:WaitForChild("teleport").Changed:connect(function(value)
	if value==true then
		activateloading()
	end
end)
function teleport(teleportid)
	activateloading()
	game:GetService('TeleportService'):Teleport(teleportid, game.Players.LocalPlayer, {}, game.ReplicatedStorage.Loading)
end

function functionalisebutton(button)
	addhover(button)
	button.MouseButton1Down:connect(function()
		if selected then
			return
		end
		script.Parent.Sounds.MenuClick:Play()
		if button.Name=="Browse" then
			script.Parent.Menu.Screen.Visible=false
			script.Parent.Menu.Sections.Visible=true
		end
		if button.Name=="Refresh" then
			--print("refresh works")
			spawn(function()
			RefreshFriends()
			end)
		end
		if button.Name == "HelpOpt" then
			if loadedsettings == false then
				loadedsettings = true
				--print("Requesting Settings")
				game.ReplicatedStorage.GetSettings:InvokeServer()
				setsettings()
			end
		end
		
		if button.Name == "outside" then -- fill collor 180, 210, 230
			if button.Parent.inside.ImageColor3 == Color3.new(1,1,1) then
				button:TweenPosition(UDim2.new(1, -30, 0.5, -12), nil, nil, 0.25)
				button.Parent.inside.ImageColor3 = Color3.new(180/255, 210/255, 230/255)
				game.ReplicatedStorage.ChangeSetting:InvokeServer(tostring(button.Parent), true)
			else
				button:TweenPosition(UDim2.new(1, -60, 0.5, -12), nil, nil, 0.25)
				button.Parent.inside.ImageColor3 = Color3.new(1, 1, 1)
				game.ReplicatedStorage.ChangeSetting:InvokeServer(tostring(button.Parent), false)
			end
		end
		
	end)
end

functionalisetween(menu.PlayScreen,menu.MainScreen,menu.MainScreen.Play)
functionalisetween(menu.MainScreen,menu.PlayScreen,menu.PlayScreen.back)
functionalisebutton(menu.PlayScreen.Casual)
functionalisebutton(menu.PlayScreen.CasualAlt)
functionalisebutton(menu.PlayScreen.TTT)
functionalisebutton(menu.PlayScreen.Deathmatch)
functionalisebutton(menu.PlayScreen.Browse)
functionalisebutton(menu.PlayScreen.CBRO)
addhover(menu.MainScreen.Quickplay)
menu.MainScreen.Quickplay.MouseButton1Down:connect(function()
	script.Parent.Menu.Enabled = false
end)
addhover(menu.MainScreen.Armoury)

--SHOP
functionalisetween(menu.ArmouryScreen,menu.MainScreen,menu.MainScreen.Armoury)
functionalisetween(menu.MainScreen,menu.ArmouryScreen,menu.ArmouryScreen.back)

menu.ArmouryScreen.OpenInventory.MouseButton1Down:connect(function()
	script.Parent.Menu.Enabled = false
	maingui["Inventory&Loadout"].Visible = true
end)

menu.ArmouryScreen.Tweeter.MouseButton1Down:connect(function()
	script.Parent.Menu.Enabled	= false
	maingui["TwitterFrame"].Visible	= true
end)

menu.ArmouryScreen.Trade.MouseButton1Down:connect(function()
	script.Parent.Menu.Enabled	= false
	maingui["TradeUps"].Visible	= true
end)

maingui["TradeUps"].Back.MouseButton1Down:connect(function()
	script.Parent.Menu.Enabled	= true
	maingui["TradeUps"].Visible	= false
end)

maingui["TwitterFrame"].Back.MouseButton1Down:connect(function()
	script.Parent.Menu.Enabled	= true
	maingui["TwitterFrame"].Visible	= false
end)

maingui["TwitterFrame"].Code.FocusLost:connect(function()
	if not string.find(maingui["TwitterFrame"].Code.Text, "Code") then
		local status	= game.ReplicatedStorage.Remotes.RedeemCode:InvokeServer(maingui["TwitterFrame"].Code.Text)
		maingui["TwitterFrame"].Code.Text	= status
		
		wait(1)
		
		maingui["TwitterFrame"].Code.Text	= "Twitter Code Here!"
	end
end)

maingui["Inventory&Loadout"].Back.MouseButton1Down:connect(function()
	script.Parent.Menu.Enabled = true
	maingui["Inventory&Loadout"].Visible = false
end)

menu.ArmouryScreen.OpenFunds.MouseButton1Click:Connect(function() 
	--game:GetService("TeleportService"):Teleport(385792440, game.Players.LocalPlayer)
end)

menu.PlayScreen.JoinFriends.MouseButton1Click:connect(function()
	--game:GetService("TeleportService"):Teleport(980888491, game.Players.LocalPlayer)
end)

menu.ArmouryScreen.OpenShop.MouseButton1Down:connect(function()
	script.Parent.Menu.Enabled = false
	maingui["ShopMenu"].Visible = true
end)
maingui["ShopMenu"].TempMenu.Back.MouseButton1Down:connect(function()
	script.Parent.Menu.Enabled = true
	maingui["ShopMenu"].Visible = false
end)
menu.MainScreen.Zombies.MouseButton1Click:connect(function()
	--game:GetService("TeleportService"):Teleport(391595633, game.Players.LocalPlayer)
end)
--end of shop

functionalisetween(menu.MainScreen,menu.SettingsScreen,menu.SettingsScreen.back)

functionalisetween(menu.SettingsScreen,menu.MainScreen,menu.MainScreen.HelpOpt)

functionalisebutton(menu.MainScreen.HelpOpt)


-- settings buttons
functionalisebutton(menu.SettingsScreen.Frame.LowMapDetail.outside)
functionalisebutton(menu.SettingsScreen.Frame.LowerParticles.outside)
functionalisebutton(menu.SettingsScreen.Frame.LowViolence.outside)
functionalisebutton(menu.SettingsScreen.Frame.NoDecals.outside)
functionalisebutton(menu.SettingsScreen.Frame.AltCrouch.outside)

menu.SettingsScreen.Frame.MusicVolume.Back.TBox.Focused:Connect(function()
menu.SettingsScreen.Frame.MusicVolume.Back.TBox.Prev.Value = tonumber(menu.SettingsScreen.Frame.MusicVolume.Back.TBox.Text)
end)
menu.SettingsScreen.Frame.MusicVolume.Back.TBox.FocusLost:Connect(function()
	local b, nib = pcall(function() local ye = tonumber(menu.SettingsScreen.Frame.MusicVolume.Back.TBox.Text) return ye end)
	if nib then
		if nib >= 0 and nib <= 100 then
		game.ReplicatedStorage.ChangeSetting:InvokeServer("MusicVolume", nib)
		menu.SettingsScreen.Frame.MusicVolume.Back.fill:TweenSize(UDim2.new(nib/100, 0, 1, 0), nil, nil, .35)
		else
		menu.SettingsScreen.Frame.MusicVolume.Back.TBox.Text = tostring(menu.SettingsScreen.Frame.MusicVolume.Back.TBox.Prev.Value)
		end
	else
	menu.SettingsScreen.Frame.MusicVolume.Back.TBox.Text = tostring(menu.SettingsScreen.Frame.MusicVolume.Back.TBox.Prev.Value)
	end
end)

rs.RenderStepped:connect(function()
local absolutesx=script.Parent.Menu.Screen.Main.Main.AbsoluteSize.X
local absolutesy=script.Parent.Menu.Screen.Main.Main.AbsoluteSize.Y
menu.Parent:TweenPosition(UDim2.new(0.5,-absolutesx/2,0.55,-absolutesy/2),"Out","Quad",.5,false)
end)

game.ReplicatedStorage.Kick.OnClientEvent:connect(function()
	game.StarterGui:ClearAllChildren()
	script.Parent:ClearAllChildren()
end)