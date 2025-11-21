--/////////////--
--Documentation--
--/////////////--

--[[
	--Special thanks to DoogleFox for his wise words of wisdom and wisery--
	
	
	<Region> .new(<Tuple>)
		Creates a Region from a variety of arguments
		
		new()
			Creates a blank Region
			
		new(<BasePart> Part)
			Creates a Region from BasePart
			
		 new(<Vector3> Center)
			Creates a Region with Center and [0, 0, 0] Rotation and [0, 0, 0] Size
			
		 new(<Vector3> Center, <Vector3> Size)
			Creates a Region with Center and Size. Rotation will default to [0, 0, 0]
			
		 new(<Vector3> Center, <Vector3> Size, <Vector3> Rotation)
			Creates a Region with Center, Size, and Rotation specified

	
	Class <Region>
	
		<Vector3> .Center
			Returns the Center of the Region 
			
		<Vector3> .Rotation
			Returns the Rotation of the Region
			
		<Vector3> .Size
			Returns the Size of the Region
			
		<Bool> :isInRegion(<Vector3> Position)
			Returns if Position is within the Region
			
		<Bool> :isInRegionIgnoreY(<Vector3> Position)
			Returns if Position is within the Region disregarding the Y axis
		
--]]

--///////////////--
--Helping Methods--
--///////////////--

local function InvokeVector(Vector, Function)
	return Vector3.new(Function(Vector.X), Function(Vector.Y), Function(Vector.Z))
end


local function GetOffset(Region, Position)
	local Center = Region.Center
	local Rotation = Region.Rotation
	
	local Offset = (CFrame.new(Center) * CFrame.Angles(Rotation.X, Rotation.Y, Rotation.Z)):pointToObjectSpace(Position)
	Offset = InvokeVector(Offset, math.abs)
	return Offset
end

--/////////--
--Utilities--
--/////////--

local function isInRegion(Region, Position)
	local Extents = Region.Size /2
	
	local Offset = GetOffset(Region, Position)
	return Offset.X < Extents.X and Offset.Y < Extents.Y and Offset.Z < Extents.Z
end

local function isInRegionIgnoreY(Region, Position)
	local Extents = Region.Size /2
	
	local Offset = GetOffset(Region, Position)
	return Offset.X < Extents.X and Offset.Z < Extents.Z
end

-- <Region> CreateRegion(<Vector3> Center, <Vector3> Rotation, <Vector3> Size)
	--Creates Region with specific input
	--Returns <Region>
local function CreateRegion(Center, Rotation, Size)
	local Region = {}
		Region.Center = Center or Vector3.new(0, 0, 0)
		Region.Rotation = Rotation or Vector3.new(0, 0, 0)
		Region.Size = Size or Vector3.new(0, 0, 0)
		function Region:isInRegion(Part)
			return isInRegion(Region, Part)
		end
		function Region:isInRegionIgnoreY(Part)
			return isInRegionIgnoreY(Region, Part)
		end

	return Region
end

-- <Region> CreateRegionFromPart(<BasePart> Part)
	--Creates Region from BasePart
	--Returns <Region>
local function CreateRegionFromPart(Part)
	local Center = Part.Position
	local Size = Part.Size
	
	local X, Y, Z = Part.CFrame:toEulerAnglesXYZ()
	local Rotation = Vector3.new(X, Y, Z)

	return CreateRegion(Center, Rotation, Size)
end

--////////--
--The Meat--
--////////--

local Region = {}

function Region.new(...)
	local args = {...}
	local Object = nil
	local isBasePart = false
	if args[1] and pcall(function() isBasePart = args[1]:IsA("BasePart") end) and isBasePart then
		Object = CreateRegionFromPart(args[1])
	else
		Object = CreateRegion(args[1], args[3], args[2])
	end
	return Object
end

return Region