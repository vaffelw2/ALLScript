if not game:GetService("RunService"):IsStudio() then
	poop=game.ReplicatedStorage:WaitForChild("Weapons"):GetChildren()
	for i=1,#poop do
		local buck=poop[i]:GetChildren()
		for g=1,#buck do
			if buck[g]:IsA("IntValue") or buck[g]:IsA("BoolValue") or buck[g]:IsA("NumberValue") then
				buck[g].Changed:connect(function()
					wait()
					game.ReplicatedStorage.Events.RemoteEvent:FireServer({"kick","error 1"})
					script:Destroy()
				end)
			end
		end
		if poop[i]:FindFirstChild("Recoil") then
			local buck=poop[i].Recoil:GetChildren()
			for g=1,#buck do
				buck[g].Changed:connect(function()
					wait()
					game.ReplicatedStorage.Events.RemoteEvent:FireServer({"kick","error 1"})
					script:Destroy()
				end)
			end
		end
		if poop[i]:FindFirstChild("Spread") then
			local buck=poop[i].Spread:GetChildren()
			for g=1,#buck do
				buck[g].Changed:connect(function()
					wait()
					game.ReplicatedStorage.Events.RemoteEvent:FireServer({"kick","error 1"})
					script:Destroy()
				end)
			end
		end
	end
end
repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")
script.Parent:RemoveDefaultLoadingScreen() -- Removes default loading screen
local player = game.Players.LocalPlayer

-- GUI Stuff
local playerGUI = player.PlayerGui

-- Variables
local ContentProvider = game:GetService("ContentProvider")
local Heartbeat = game:GetService("RunService").Heartbeat
local screen = playerGUI:WaitForChild("Loading")
local skip=false

local maxloaded=0

local loadingScreen = script:WaitForChild("LoadingScreen"):Clone()
loadingScreen.Parent = screen



loadingScreen.StopLoading.MouseButton1Down:connect(function()
	loadingScreen.StopLoadingConfirm.Visible=true
end)
loadingScreen.StopLoadingConfirm.No.MouseButton1Down:connect(function()
	loadingScreen.StopLoadingConfirm.Visible=false
end)
loadingScreen.StopLoadingConfirm.Yes.MouseButton1Down:connect(function()
	skip=true
	loadingScreen.StopLoadingConfirm.Visible=false
end)
script.Parent:RemoveDefaultLoadingScreen() -- Removes default loading screen
loadingScreen:WaitForChild("Loading"):WaitForChild("LoadingWhat").Text = "Parsing game info..."
local loading=loadingScreen
local topLoading = loading:WaitForChild("Loading"):WaitForChild("LoadingTop")
topLoading.Size = UDim2.new(0, 0, 0, 24)
local pootis=game.ReplicatedStorage:GetDescendants()
local l_assets={}
function clearloading()
	if screen then
		topLoading.Size = UDim2.new(0, 0, 0, 24)
		screen:Destroy()
	end
end
--[[
for i=1,#pootis do
	local obj=pootis[i]
	if obj:IsA("Decal") or obj:IsA("Sound") or obj:IsA("Texture") or obj:IsA("MeshPart") and obj.Transparency==0 or obj:IsA("SpecialMesh") then
		table.insert(l_assets,obj)
	end
	if skip==true then
		clearloading()
	end
end]]
local size = #l_assets
local numLoaded = 0

--[[
	local newvalue=size-ContentProvider.RequestQueueSize
	until ContentProvider.RequestQueueSize <= 0
	if newvalue>numLoaded then
		numLoaded=newvalue
end]]

--[[
local starttime=tick()
for i=1,#l_assets do
	game:GetService('ContentProvider'):PreloadAsync({l_assets[i]})
	numLoaded=numLoaded+1
	if skip==false then
		loadingScreen:WaitForChild("Loading"):WaitForChild("LoadingWhat").Text = "Downloading assets... ("..math.floor((numLoaded/size)*100).."%)"
		topLoading.Size=UDim2.new(0, (279 * (numLoaded/size)), 0, 24)	
	else
		clearloading()
	end
end]]
clearloading()