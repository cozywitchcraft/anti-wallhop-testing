local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")

local MapFunctions = require(script.Parent.MapFunctions)
local Util = require(ReplicatedStorage.Util)

local systemMessageReceived = ReplicatedStorage.SystemMessageReceived

local mapsFolder = ServerStorage.Maps

local textChatCommands = TextChatService.TextChatCommands

local loadCommand = textChatCommands.AWHLoadCommand
local reloadCommand = textChatCommands.AWHReloadCommand

local infoCommand = textChatCommands.AWHInfoCommand
local listCommand = textChatCommands.AWHListCommand

local maps: { [string]: Folder } = {
	junkyard = mapsFolder.Junkyard,
	crossroads = mapsFolder.Crossroads,
	totl = mapsFolder.ToTL,
	toim = mapsFolder.ToIM,
}

local currentMap: Folder

local function isAdmin(userId: number)
	return RunService:IsStudio() or game.CreatorId == userId or
		game.PrivateServerId ~= "" and game.PrivateServerOwnerId == userId
end

local function getMapName(map: Folder)
	return map:GetAttribute("DisplayName") or map.Name
end

local function getMapList(): string
	local mapCount = 0
	local lines = {}

	for mapId, map in maps do
		local mapName = getMapName(map)
		local mapCreator = map:GetAttribute("Creator")

		table.insert(lines, `- { mapId }: { mapName } by { mapCreator }`)

		mapCount += 1
	end

	table.insert(lines, 1, `There are { mapCount } maps to choose from:`)

	return table.concat(lines, "\n")
end

local function changeMap(newMap: Folder)
	MapFunctions.clearMap()
	MapFunctions.loadMap(newMap)

	currentMap = newMap

	-- Reload characters
	for _, player in Players:GetPlayers() do
		player:LoadCharacter()
	end
end

loadCommand.Triggered:Connect(function(textSource: TextSource, message: string)
	local player = Players:GetPlayerByUserId(textSource.UserId)

	if not isAdmin(textSource.UserId) then
		systemMessageReceived:FireClient(player, "Must be private server owner to load map")
		return
	end

	local mapId = string.match(message, "%s(.*)")

	if not mapId then
		systemMessageReceived:FireClient(player, "Cannot load map without name")
		return
	end

	local newMap = maps[mapId]

	if not newMap then
		systemMessageReceived:FireClient(player, "Invalid map name")
		return
	end

	local start = os.clock()

	changeMap(newMap)

	local mapName = getMapName(currentMap)
	local duration = Util.floatToString(1e3 * (os.clock() - start))

	systemMessageReceived:FireClient(player, `Loaded { mapName } in { duration } ms`)
end)

reloadCommand.Triggered:Connect(function(textSource: TextSource)
	local player = Players:GetPlayerByUserId(textSource.UserId)

	if not isAdmin(textSource.UserId) then
		systemMessageReceived:FireClient(player, "Must be private server owner to reload map")
		return
	end

	local start = os.clock()

	changeMap(currentMap)

	local mapName = getMapName(currentMap)
	local duration = Util.floatToString(1e3 * (os.clock() - start))

	systemMessageReceived:FireClient(player, `Reloaded { mapName } in { duration } ms`)
end)

infoCommand.Triggered:Connect(function(textSource: TextSource, message: string)
	local player = Players:GetPlayerByUserId(textSource.UserId)

	local mapId = string.match(message, "%s(.*)")
	local map = maps[mapId] or currentMap

	local mapName = getMapName(map)
	local mapCreator = map:GetAttribute("Creator")
	local mapDescription = map:GetAttribute("Description")

	systemMessageReceived:FireClient(player, `{ mapName } by { mapCreator }: { mapDescription }`)
end)

-- TODO: Implement pages
local mapList = getMapList()

listCommand.Triggered:Connect(function(textSource: TextSource)
	local player = Players:GetPlayerByUserId(textSource.UserId)
	systemMessageReceived:FireClient(player, mapList)
end)

changeMap(maps.junkyard)
