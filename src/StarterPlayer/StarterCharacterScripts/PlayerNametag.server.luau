local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ON_COLOR = Color3.fromRGB(65, 154, 65)
local OFF_COLOR = Color3.fromRGB(255, 89, 89)

local antiWallhopToggled = ReplicatedStorage.AntiWallhopToggled
local collisionModeToggled = ReplicatedStorage.CollisionModeToggled

local nametagGuiTemplate = ReplicatedStorage.NametagGui

local character = script.Parent
local rootPart = character:WaitForChild("HumanoidRootPart")

local nametagGui = nametagGuiTemplate:Clone()
nametagGui.Parent = rootPart

local antiWallhopLabel = nametagGui.AntiWallhop
local collisionModeLabel = nametagGui.CollisionMode

-- kinda bad since our source of truth is the client but whatever
antiWallhopToggled.OnServerEvent:Connect(function(player, antiWallhopEnabled: boolean)
	if player.Character ~= character then
		return
	end

	if antiWallhopEnabled then
		antiWallhopLabel.Text = "Anti-Wallhop: ON"
		antiWallhopLabel.TextColor3 = ON_COLOR
	else
		antiWallhopLabel.Text = "Anti-Wallhop: OFF"
		antiWallhopLabel.TextColor3 = OFF_COLOR
	end
end)

collisionModeToggled.OnServerEvent:Connect(function(player, isRootPartCollidable: boolean)
	if player.Character ~= character then
		return
	end

	if isRootPartCollidable then
		collisionModeLabel.Text = "Collision: Root Part"
	else
		collisionModeLabel.Text = "Collision: Character"
	end
end)
