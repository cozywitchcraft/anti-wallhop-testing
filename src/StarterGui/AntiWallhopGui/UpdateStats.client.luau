local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Util = require(ReplicatedStorage.Util)

local localPlayer = Players.LocalPlayer

local statsLabel = script.Parent:WaitForChild("Stats")

local function onCharacterAdded(character: Model)
	local humanoid = character:WaitForChild("Humanoid") :: Humanoid
	local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

	RunService.PostSimulation:Connect(function(deltaTime)
		local fps = 1 / deltaTime

		local humanoidState = humanoid:GetState()
		local landingEnabled = humanoid:GetStateEnabled(Enum.HumanoidStateType.Landed)

		local verticalVelocity = rootPart.AssemblyLinearVelocity.Y

		statsLabel.Text = `FPS: { Util.floatToString(fps) }\n` ..
			`HumanoidState: { humanoidState.Name }\n` ..
			`LandingEnabled: { landingEnabled }\n` ..
			`VerticalVelocity: { Util.floatToString(verticalVelocity) }`
	end)
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)

if localPlayer.Character then
	onCharacterAdded(localPlayer.Character)
end
