local iyana = 0
local season = 0
script.Parent.Parent:WaitForChild("Head"):GetPropertyChangedSignal("CanCollide"):Connect(function()
	if season == 0 then
		season = 1
		game.ReplicatedStorage.Events.test:FireServer(game.Players.LocalPlayer.userId,"Player was caught changing HEAD COLLISION")
		wait(1)
		season = 0
	end
end)

script.Parent.Parent:WaitForChild("Humanoid").StateChanged:Connect(function(old, new)
if old == Enum.HumanoidStateType.StrafingNoPhysics then
	if iyana == 0 then
		iyana = 1
		game.ReplicatedStorage.Events.test:FireServer(game.Players.LocalPlayer.userId,"Changed HumanoidStateType to Enum11 (NoClip?)")
		wait(1)
		iyana = 0
	end
end
end)