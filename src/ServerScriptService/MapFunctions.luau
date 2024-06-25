local Lighting = game:GetService("Lighting")
local ServerStorage = game:GetService("ServerStorage")

local defaultLighting = ServerStorage.DefaultLighting:GetAttributes()

local terrain = workspace.Terrain

local function isLightingInstance(instance: Instance)
	return instance.ClassName == "Atmosphere" or instance.ClassName == "Sky" or instance:IsA("PostEffect")
end

local MapFunctions = {}

function MapFunctions.loadMap(newMap: Folder)
	local newGeometry = newMap:FindFirstChild("Geometry")
	local newTerrain = newMap:FindFirstChild("Terrain") :: TerrainRegion
	local newLighting = newMap:FindFirstChild("Lighting") :: Configuration

	if newGeometry then
		newGeometry:Clone().Parent = workspace
	end

	if newTerrain then
		terrain:PasteRegion(newTerrain, terrain.MaxExtents.Min, false)

		for _, instance in newTerrain:GetChildren() do
			instance:Clone().Parent = terrain
		end
	end

	if newLighting then
		for propertyName, value in newLighting:GetAttributes() do
			Lighting[propertyName] = value
		end

		for _, instance in newLighting:GetChildren() do
			instance:Clone().Parent = Lighting
		end
	end
end

function MapFunctions.clearMap()
	local oldGeometry = workspace:FindFirstChild("Geometry")

	if oldGeometry then
		oldGeometry:Destroy()
	end

	terrain:Clear()

	local clouds = terrain:FindFirstChildOfClass("Clouds")

	if clouds then
		clouds:Destroy()
	end

	for propertyName, value in defaultLighting do
		Lighting[propertyName] = value
	end

	for _, instance in Lighting:GetChildren() do
		if isLightingInstance(instance) then
			instance:Destroy()
		end
	end
end

function MapFunctions.exportMap()
	local exportedMap = Instance.new("Folder")

	-- Export geometry
	local geometry = workspace:FindFirstChild("Geometry")

	if geometry then
		geometry:Clone().Parent = exportedMap
	end

	-- Export terrain
	local exportedTerrain = terrain:CopyRegion(terrain.MaxExtents)

	local clouds = terrain:FindFirstChildOfClass("Clouds")

	if clouds then
		clouds:Clone().Parent = exportedTerrain
	end

	exportedTerrain.Name = "Terrain"
	exportedTerrain.Parent = exportedMap

	-- Export lighting
	local exportedLighting = Instance.new("Configuration")

	for propertyName, _ in defaultLighting do
		exportedLighting:SetAttribute(propertyName, Lighting[propertyName])
	end

	for _, instance in Lighting:GetChildren() do
		if isLightingInstance(instance) then
			instance:Clone().Parent = exportedLighting
		end
	end

	exportedLighting.Name = "Lighting"
	exportedLighting.Parent = exportedMap

	-- Export map to ServerStorage.Maps
	exportedMap.Name = "NewMap"

	exportedMap:SetAttribute("Creator", "Unknown")
	exportedMap:SetAttribute("Description", "Unknown")

	exportedMap.Parent = ServerStorage.Maps
end

return MapFunctions
