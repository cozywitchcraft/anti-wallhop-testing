local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local MapFunctions = require(ServerScriptService.MapFunctions)
local Util = require(ReplicatedStorage.Util)

local start = os.clock()

MapFunctions.loadMap(ServerStorage.Maps.Junkyard)

local duration = Util.floatToString(1e3 * (os.clock() - start))
print(`Loaded map in { duration } ms`)

ChangeHistoryService:SetWaypoint("LoadMap")
