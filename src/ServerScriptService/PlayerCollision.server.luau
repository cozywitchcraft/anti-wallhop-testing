local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function setCharacterCollision(character: Model)
	for _, instance in character:GetChildren() do
		if instance.Name == "HumanoidRootPart" then
			instance.CanCollide = false
		end

		if instance:IsA("BasePart") then
			instance.CollisionGroup = "Character"
		end
	end
end

local function setRootPartCollision(character: Model)
	for _, instance in character:GetChildren() do
		if instance.Name == "HumanoidRootPart" then
			instance.CanCollide = true
			instance.CollisionGroup = "Character"
		elseif instance:IsA("BasePart") then
			instance.CollisionGroup = "NoCollision"
		end
	end
end

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(setCharacterCollision)

	if player.Character then
		setCharacterCollision(player.Character)
	end
end

ReplicatedStorage.CollisionModeToggled.OnServerEvent:Connect(function(player, isRootPartCollidable: boolean)
	local character = player.Character

	if not character then
		return
	end

	if isRootPartCollidable then
		setRootPartCollision(character)
	else
		setCharacterCollision(character)
	end
end)

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end
