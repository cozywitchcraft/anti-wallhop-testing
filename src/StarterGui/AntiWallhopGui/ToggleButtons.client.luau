local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ON_COLOR = Color3.fromRGB(65, 154, 65)
local OFF_COLOR = Color3.fromRGB(255, 89, 89)

local localPlayer = Players.LocalPlayer

local antiWallhopToggled = ReplicatedStorage.AntiWallhopToggled
local collisionModeToggled = ReplicatedStorage.CollisionModeToggled
local forcefieldToggled = ReplicatedStorage.ForcefieldToggled

local gui = script.Parent

local toggleAntiWallhop = gui:WaitForChild("ToggleAntiWallhop")
local toggleDebugVisuals = gui:WaitForChild("ToggleDebugVisuals")

local toggleForcefield = gui:WaitForChild("ToggleForcefield")

local toggleCharacterVisibility = gui:WaitForChild("ToggleCharacterVisibility")
local toggleRootVisibility = gui:WaitForChild("ToggleRootVisibility")

local toggleCollisionMode = gui:WaitForChild("ToggleCollisionMode")

local function bindToggleButton(options: {
	button: TextButton,
	onText: string,
	offText: string,
	useToggleColors: boolean,
	defaultValue: boolean,
	callback: (value: boolean) -> (),
})
	local button = options.button
	local onText = options.onText
	local offText = options.offText
	local useToggleColors = options.useToggleColors
	local callback = options.callback

	local value = options.defaultValue

	button.Activated:Connect(function()
		value = not value

		button.Text = if value then onText else offText

		if useToggleColors then
			button.BackgroundColor3 = if value then ON_COLOR else OFF_COLOR
		end

		callback(value)
	end)
end

-- too lazy to move this anywhere else, pretend this isn't here...
local function hasTransparency(instance: Instance)
	return (instance:IsA("BasePart") or instance:IsA("Decal")) and instance.Name ~= "HumanoidRootPart"
end

local function setCharacterTransparency(character: Model, transparency: number)
	for _, instance in character:GetDescendants() do
		if hasTransparency(instance) then
			instance.Transparency = transparency
		end
	end
end

local function onCharacterAdded(character: Model)
	local antiWallhop = character:WaitForChild("AntiWallhopLoader")
	local rootPart = character:WaitForChild("HumanoidRootPart")

	bindToggleButton({
		button = toggleAntiWallhop,
		onText = "Anti-Wallhop: ON",
		offText = "Anti-Wallhop: OFF",
		useToggleColors = true,
		defaultValue = true,
		callback = function(antiWallhopEnabled)
			antiWallhop:SetAttribute("AntiWallhopEnabled", antiWallhopEnabled)
			antiWallhopToggled:FireServer(antiWallhopEnabled)
		end,
	})

	bindToggleButton({
		button = toggleDebugVisuals,
		onText = "Debug Visuals: ON",
		offText = "Debug Visuals: OFF",
		useToggleColors = true,
		defaultValue = false,
		callback = function(showDebugVisuals)
			antiWallhop:SetAttribute("ShowDebugVisuals", showDebugVisuals)
		end,
	})

	bindToggleButton({
		button = toggleForcefield,
		onText = "Forcefield: ON",
		offText = "Forcefield: OFF",
		useToggleColors = true,
		defaultValue = false,
		callback = function(isForcefieldEnabled)
			forcefieldToggled:FireServer(isForcefieldEnabled)
		end,
	})

	bindToggleButton({
		button = toggleCharacterVisibility,
		onText = "Hide Character",
		offText = "Show Character",
		useToggleColors = true,
		defaultValue = true,
		callback = function(isCharacterVisible)
			setCharacterTransparency(character, if isCharacterVisible then 0 else 0.8)
		end,
	})

	bindToggleButton({
		button = toggleRootVisibility,
		onText = "Hide Root Part",
		offText = "Show Root Part",
		useToggleColors = true,
		defaultValue = false,
		callback = function(isRootPartVisible)
			rootPart.Transparency = if isRootPartVisible then 0.4 else 1
		end,
	})

	bindToggleButton({
		button = toggleCollisionMode,
		onText = "Collision: Root Part",
		offText = "Collision: Character",
		useToggleColors = false,
		defaultValue = false,
		callback = function(isRootPartCollidable)
			collisionModeToggled:FireServer(isRootPartCollidable)
		end,
	})
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)

if localPlayer.Character then
	onCharacterAdded(localPlayer.Character)
end
