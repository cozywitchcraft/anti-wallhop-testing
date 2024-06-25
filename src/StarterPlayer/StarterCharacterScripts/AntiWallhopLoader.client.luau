local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AntiWallhop = require(ReplicatedStorage.Packages.AntiWallhop)

local antiWallhop = AntiWallhop.new(script.Parent)

local function toggleAntiWallhop()
	if script:GetAttribute("AntiWallhopEnabled") then
		antiWallhop:enable()
	else
		antiWallhop:disable()
	end
end

local function toggleDebugVisuals()
	if script:GetAttribute("ShowDebugVisuals") then
		antiWallhop:enableDebug()
	else
		antiWallhop:disableDebug()
	end
end

script:GetAttributeChangedSignal("AntiWallhopEnabled"):Connect(toggleAntiWallhop)
script:GetAttributeChangedSignal("ShowDebugVisuals"):Connect(toggleDebugVisuals)

toggleAntiWallhop()
toggleDebugVisuals()
