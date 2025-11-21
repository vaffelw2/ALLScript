local humanoid = script.Parent:WaitForChild('Humanoid')
humanoid.StateChanged:Connect(function(old,new)
	if new == Enum.HumanoidStateType.Jumping then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		wait(0.78)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
	end
end)
