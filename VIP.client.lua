themapframe = script.Parent.map
script.Parent.RestartRound.MouseButton1Click:connect(function()
	game.ReplicatedStorage.Events.VIPevent:FireServer({"Restart"})
end)
script.Parent.Cash.MouseButton1Down:connect(function()
	game.ReplicatedStorage.Events.VIPevent:FireServer({"Cash-in-pocket"})
end)
script.Parent.Kick.MouseButton1Click:connect(function()
	game.ReplicatedStorage.Events.VIPevent:FireServer({"Kick",script.Parent.PlebHere.Text})
end)
script.Parent.ForceWarmup.MouseButton1Click:connect(function()
	game.ReplicatedStorage.Events.VIPevent:FireServer({"Warmup"})
end)
script.Parent["Force Map"].MouseButton1Down:connect(function()
	themapframe.Visible = true
end)
script.Parent.Comp.MouseButton1Click:connect(function()
	game.ReplicatedStorage.Events.VIPevent:FireServer({"Comp"})
end)
script.Parent.Cleanup.MouseButton1Click:connect(function()
	game.ReplicatedStorage.Events.VIPevent:FireServer({"Cleanup"})
end)
script.Parent.OptimizeKillTrade.MouseButton1Click:connect(function()
	game.ReplicatedStorage.Events.VIPevent:FireServer({"Killtrade"})
end)
themapframe.back.MouseButton1Down:connect(function()
	themapframe.Visible = false
end)

maps = {"de_dust2","de_fallen","de_inferno","de_nuke","de_vertigo","de_cache", "de_mirage", "de_cobblestone", "de_train", "br_1v1"}
currentypos = .1
for i=1, #maps do
	local temp = script.template:Clone()
	temp.Parent = script.Parent.map
	temp.Text = maps[i]
	temp.MouseButton1Down:connect(function()
		game.ReplicatedStorage.Events.VIPevent:FireServer({"Changemap",maps[i]})
	end)
	temp.Visible = true
	temp.Position = UDim2.new(0,0,currentypos,0)
	currentypos = currentypos + .1
end

game:GetService("UserInputService").InputBegan:connect(function(k)
local key=k.KeyCode
if key==Enum.KeyCode.Equals then
	if game.ReplicatedStorage.Functions.GetOwner:InvokeServer() then
		script.Parent.Visible = not script.Parent.Visible
	end
end
end)
