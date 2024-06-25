local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Util = require(ReplicatedStorage.Util)

local localPlayer = Players.LocalPlayer

local setCharacterScale = script.Parent:WaitForChild("SetCharacterScale")

local function onCharacterAdded(character: Model)
	local scale = character:GetScale()

	setCharacterScale.Text = `CharacterScale: { Util.floatToString(scale) }`

	setCharacterScale.FocusLost:Connect(function(enterPressed: boolean)
		if enterPressed then
			scale = tonumber(setCharacterScale.Text) or scale
			character:ScaleTo(scale)
		end

		setCharacterScale.Text = `CharacterScale: { Util.floatToString(scale) }`
	end)
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)

if localPlayer.Character then
	onCharacterAdded(localPlayer.Character)
end
