local cooldown = 0

script.Parent:WaitForChild("Map1")
script.Parent:WaitForChild("Map2")
script.Parent:WaitForChild("Map3")
script.Parent:WaitForChild("Map4")
 


local sunnyD = script.Parent:GetChildren()
for i=1,#sunnyD do
	if sunnyD[i]:IsA("ImageButton") then 
		local wwe = sunnyD[i]
		wwe.MouseButton1Click:Connect(function()   
			if wwe.BorderColor3 ~= Color3.new(1, 1, 1) and cooldown == 0 then
				cooldown = 1
					for i, v in pairs(script.Parent:GetChildren()) do
						if v.ClassName=="ImageButton" then
							v.BorderColor3 = Color3.new(71/255, 69/255, 64/255)
						end
					end
				script.Vote:Play()
				wwe.BorderColor3 = Color3.new(1,1,1)
				game.ReplicatedStorage.MapVoting.Submit:FireServer(game.ReplicatedStorage.MapVoting.Counts, wwe.Actual.Value)
				wait(1)
				cooldown = 0
			end
		end)
	end
end



function countvote(binga,value)
binga:WaitForChild("Votes").Text=value
end

local dict


local name, creator, icon = ""
function GimmieName(stink)
	icon=""
	if game.ReplicatedStorage.MapIcons:FindFirstChild(stink) then
		icon=game.ReplicatedStorage.MapIcons[stink].Image
	end
	if stink == "de_cache" then
		name = "Cache" creator = "Zeenyoo"
	elseif stink == "de_cobblestone" then
		name = "Cobblestone" creator = "marioredtoad & TimTimich6"
	elseif stink == "de_train" then
		name = "Train" creator = "Zeenyoo"
	elseif stink == "cs_office" then
		name = "Office" creator = ""
	elseif stink == "de_dust2" then
		name = "Dust II" creator = "Bluay"
	elseif stink == "hw_gust2" then
		name = "Gust II" creator = "ROLVe Developers"
	elseif stink == "de_fallen" or stink == "hw_fallen" then
		name = "Fallen" creator = "FWEEEEEEE"
	elseif stink == "de_inferno" then
		name = "Inferno" creator = "Pastel_BlitzSP"
	elseif stink == "de_mirage" then
		name = "Mirage" creator = "PrimE_RBLX"
	elseif stink == "de_nuke" or stink == "hw_nuke" then
		name = "Nuke" creator = "marioredtoad & squidmcduck"
	elseif stink == "de_metro" then
		name = "Metro" creator = "FWEEEEEEE"
	--elseif stink == "de_seaside" then
	--	name = "Seaside" creator = "TCtully"
	elseif stink == "de_vertigo" then
		name = "Vertigo" creator = "TCtully"
	elseif stink == "ttt_67thway" then
		name = "67th Way" creator = "Bluay"
	elseif stink == "ttt_wholesale" then
		name = "Wholesale" creator = "Capt_Tin"
	elseif stink == "ttt_fabrik" then
		name = "Fabrik" creator = "Nanterre"
	elseif stink == "ttt_santafe" then
		name = "Santa Fe" creator = "Nanterre"
	elseif stink == "ttt_metropolis" then
		name = "Metropolis" creator = "TCtully"
	elseif stink == "ttt_facility" then
		name = "Facility" creator = "Bluay"
	elseif stink == "ttt_devoffice" then
		name = "Office" creator = "Pastel_BlitzSP"
	elseif stink == "ttt_streetcorner" then
		name = "Street Corner" creator = "Bluay"
	elseif stink == "de_seaside" or stink == "hw_seaside" then
		name = "Seaside" creator = "MidnightKrystal"
	elseif stink == "de_aztec" then
		name = "Aztec" creator = "marioredtoad"
	elseif stink == "hw_cache" then
		name = "Cache" creator = "ROLVe Developers"
	elseif stink == "hw_inferno" then
		name = "Inferno" creator = "Zeenyoo & marioredtoad"
	end
	if creator == nil then
		creator = "Unknown"
	end
	creator="By: "..creator
	return name, creator, icon
end
local x, y, z = ""
function DecompileDetails()
	dict = game.ReplicatedStorage.Functions.SheHeckMe:InvokeServer()  
	x, y, z = GimmieName(dict[1])
	script.Parent.Map1.Title.Text = x script.Parent.Map1.Creator.Text  = y script.Parent.Map1.Image = z
	x, y, z = GimmieName(dict[2])
	script.Parent.Map2.Title.Text = x script.Parent.Map2.Creator.Text  = y script.Parent.Map2.Image = z
	x, y, z = GimmieName(dict[3])
	script.Parent.Map3.Title.Text = x script.Parent.Map3.Creator.Text  = y script.Parent.Map3.Image = z
	x, y, z = GimmieName(dict[4])
	script.Parent.Map4.Title.Text = x script.Parent.Map4.Creator.Text  = y script.Parent.Map4.Image = z
	script.Parent.Map1.Actual.Value=dict[1]
	script.Parent.Map2.Actual.Value=dict[2]
	script.Parent.Map3.Actual.Value=dict[3]
	script.Parent.Map4.Actual.Value=dict[4]
end

function UpdateVotes()
	while wait(.5) do
		local niggies=script.Parent:GetChildren()
		for i=1,#niggies do
		if niggies[i].className=="ImageButton" then
		local cunt=niggies[i]
		if game.ReplicatedStorage:WaitForChild("MapVoting").Counts:FindFirstChild(niggies[i].Actual.Value) then
		local faggot=game.ReplicatedStorage:WaitForChild("MapVoting").Counts:FindFirstChild(cunt.Actual.Value)
		countvote(cunt,#faggot:GetChildren())
		end
		end
		end
		
		if game.ReplicatedStorage.Voten.Value == false then
			--warn("Ending votemap loop - Vote time over")
			break
		end
		if script.Parent.Visible == false then
			--warn("Ending votemap loop - Frame not visible")
			break
		end
	end
end
_gui = game:GetService("GuiService")
istenfoot = _gui:IsTenFootInterface()
game.ReplicatedStorage.Voten.Changed:Connect(function()
	wait()
if game.ReplicatedStorage.Voten.Value == false then
		if game.ReplicatedStorage.gametype.Value~="TTT" then
		script.Parent.Parent.Scoreboard.Visible = false
		end
		script.Parent.Visible = false
	else
		spawn(function() UpdateVotes() end)
		DecompileDetails()
		if game.ReplicatedStorage.gametype.Value~="TTT" then
		script.Parent.Parent.Scoreboard.Visible = true
		end
		if istenfoot then
			if script.Parent.Parent.Parent["Menew-XB"].MainFrame.Visible == false then
				_gui.SelectedObject = script.Parent.Map1
			end
		end
		script.Parent.Visible = true
		script.Parent.Parent.TeamSelection.Visible = false
end
	
end)

if game.ReplicatedStorage.Voten.Value==true then
			spawn(function() UpdateVotes() end)
		DecompileDetails()
		if game.ReplicatedStorage.gametype.Value~="TTT" then
		script.Parent.Parent.Scoreboard.Visible = true
		end
		script.Parent.Visible = true
		script.Parent.Parent.TeamSelection.Visible = false
end

--[[game.ReplicatedStorage.Voten.Changed:Connect(function()
if game.ReplicatedStorage.Voten.Value == false then
script.Parent.Parent.LeaderboardGUI.Visible = false
script.Parent.Visible = false
script.Parent.Parent.TeamSelection.Visible = true
if script.Parent.Parent:FindFirstChild("LeaderboardSnapshot") then
script.Parent.Parent:FindFirstChild("LeaderboardSnapshot"):Destroy()
end
if game.Players.LocalPlayer:FindFirstChild("LeaderboardSnapshot") then
	game.Players.LocalPlayer:FindFirstChild("LeaderboardSnapshot"):Destroy()
end
end
end)]]
	






--[[while true do
	wait(1)
	
local niggies=script.Parent:GetChildren()
for i=1,#niggies do
if niggies[i].className=="ImageButton" then
local cunt=niggies[i]
if game.Workspace:WaitForChild("MapVotingV2").Counts:FindFirstChild(niggies[i].Title.Text) then
local faggot=game.Workspace:WaitForChild("MapVotingV2").Counts:FindFirstChild(cunt.Title.Text)
countvote(cunt,#faggot:GetChildren())
end
end
end

--[[if didsnap == false and game.Players.LocalPlayer:FindFirstChild("LeaderboardSnapshot") then
didsnap = true
local snap = game.Players.LocalPlayer:FindFirstChild("LeaderboardSnapshot"):Clone()
snap.Visible = true
snap.Parent = game.Players.LocalPlayer.PlayerGui.Stuff
delay(15,function()
	snap:Destroy()
end)
end]]

--[[for i, v in pairs (script.Parent:GetChildren()) do
	wait()
	if workspace.MapVotingV2:FindFirstChild(tostring(v)) then
		v.Title.Text = workspace.MapVotingV2:FindFirstChild(tostring(v)).Value
		v.Creator.Text = workspace.MapVotingV2:FindFirstChild(tostring(v)).Creator.Value
		v.Mode.Text = workspace.MapVotingV2:FindFirstChild(tostring(v)).Gamemode.Value
		v.Image = workspace.MapVotingV2:FindFirstChild(tostring(v)).Icon.Value
	end
end

	if game.ReplicatedStorage.Voten.Value==true then
    script.Parent.Visible=true
	--script.Parent.Parent.LeaderboardGUI.Visible = true
	script.Parent.Parent.Crosshairs.Visible = false
	script.Parent.Parent.TeamSelection.Visible = false
	else
    script.Parent.Visible=false	
	end
end ]]

