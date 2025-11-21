game:GetService("ReplicatedStorage").Events.HitPart.OnServerEvent:Connect(function(plr,val,val2,val3,val4,val5,val6,val7)
	
	local Value = "nil"
	local Value2 = "nil"
	local Value3 = "nil"
	local Value4 = "nil"
	local Value5 = "nil"
	local Value6 = "nil"
	local Value7 = "nil"
	
	if val ~= nil then
		Value = tostring(val)
	end
	if val2 ~= nil then
		Value2 = tostring(val2)
	end
	if val3 ~= nil then
		Value3 = tostring(val3)
	end
	if val4 ~= nil then
		Value4 = tostring(val4)
	end
	if val5 ~= nil then
		Value5 = tostring(val5)
	end
	if val6 ~= nil then
		Value6 = tostring(val6)
	end
	if val7 ~= nil then
		Value7 = tostring(val7)
	end
	
	local Args = {}
	
	if Value ~= "nil" then
		table.insert(Args,Value)
	end
	if Value2 ~= "nil" then
		table.insert(Args,Value2)
	end
	if Value3 ~= "nil" then
		table.insert(Args,Value3)
	end
	if Value4 ~= "nil" then
		table.insert(Args,Value4)
	end
	if Value5 ~= "nil" then
		table.insert(Args,Value5)
	end
	if Value6 ~= "nil" then
		table.insert(Args,Value6)
	end
	if Value7 ~= "nil" then
		table.insert(Args,Value7)
	end
	
	plr:Kick("Kill All - Detected")
	
	print(plr.Name.." Tried to use KILL ALL SCRIPT, Agruments that were used:")
	print(" ")
	
	for i,v in pairs(Args) do
		print(v.." - Arg"..i)
	end
	
	
	print(" ")
	print("SCRIPT USED:")
	print("game.ReplicatedStorage.Events.HitPart:FireServer("..Value..","..Value2,","..Value3..","..Value4..","..Value5..","..Value6..","..Value7..")")
end)