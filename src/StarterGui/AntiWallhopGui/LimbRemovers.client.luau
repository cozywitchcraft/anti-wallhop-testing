local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local gui = script.Parent

local removeLeftLeg = gui:WaitForChild("RemoveLeftLeg")
local removeRightLeg = gui:WaitForChild("RemoveRightLeg")

local function bindLimbRemover(button: TextButton, character: Model, limbName: string)
	button.Activated:Connect(function()
		local limb = character:FindFirstChild(limbName)

		if limb then
			limb:Destroy()
		end
	end)
end

local function onCharacterAdded(character: Model)
	bindLimbRemover(removeLeftLeg, character, "Left Leg")
	bindLimbRemover(removeRightLeg, character, "Right Leg")
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)

if localPlayer.Character then
	onCharacterAdded(localPlayer.Character)
end
