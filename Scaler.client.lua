
function update()	
	script.Parent.Position=UDim2.new(0.5,(-script.Parent.AbsoluteSize.X/2)-120,0,0)	
end

local positiony=0



while true do
	wait(.5)
	if positiony~=script.Parent.AbsoluteSize.Y then
	positiony=script.Parent.AbsoluteSize.Y
	update()
	end
end