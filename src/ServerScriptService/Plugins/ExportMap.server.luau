local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local MapFunctions = require(ServerScriptService.MapFunctions)
local Util = require(ReplicatedStorage.Util)

local start = os.clock()

MapFunctions.exportMap()

local duration = Util.floatToString(1e3 * (os.clock() - start))
print(`Exported map in { duration } ms`)

ChangeHistoryService:SetWaypoint("ExportMap")
