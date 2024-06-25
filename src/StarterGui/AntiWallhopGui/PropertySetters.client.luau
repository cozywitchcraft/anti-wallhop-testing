local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Util = require(ReplicatedStorage.Util)

local localPlayer = Players.LocalPlayer

local gui = script.Parent

local setWalkSpeed = gui:WaitForChild("SetWalkSpeed")
local setJumpPower = gui:WaitForChild("SetJumpPower")
local setHipHeight = gui:WaitForChild("SetHipHeight")
local setMaxSlopeAngle = gui:WaitForChild("SetMaxSlopeAngle")

local function bindPropertySetter(textBox: TextBox, humanoid: Humanoid, propertyName: string)
	local value = humanoid[propertyName]

	textBox.Text = `{ propertyName }: { Util.floatToString(value) }`

	humanoid:GetPropertyChangedSignal(propertyName):Connect(function()
		value = humanoid[propertyName]
		textBox.Text = `{ propertyName }: { Util.floatToString(value) }`
	end)

	textBox.FocusLost:Connect(function(enterPressed: boolean)
		if enterPressed then
			humanoid[propertyName] = tonumber(textBox.Text) or value
		else
			textBox.Text = `{ propertyName }: { Util.floatToString(value) }`
		end
	end)
end

local function onCharacterAdded(character: Model)
	local humanoid = character:WaitForChild("Humanoid")

	bindPropertySetter(setWalkSpeed, humanoid, "WalkSpeed")
	bindPropertySetter(setJumpPower, humanoid, "JumpPower")
	bindPropertySetter(setHipHeight, humanoid, "HipHeight")
	bindPropertySetter(setMaxSlopeAngle, humanoid, "MaxSlopeAngle")
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)

if localPlayer.Character then
	onCharacterAdded(localPlayer.Character)
end
