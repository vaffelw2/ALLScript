script.Parent.Touched:connect(function(h)
	if h and h.Parent and h.Parent:FindFirstChild("Humanoid") and h.Name == "Head" then
		h.Parent.Humanoid.Health = 0
	end
end)