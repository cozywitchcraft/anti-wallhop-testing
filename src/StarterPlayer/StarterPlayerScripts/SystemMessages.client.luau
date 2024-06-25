local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local systemMessageReceived = ReplicatedStorage.SystemMessageReceived

local generalChannel = TextChatService.TextChannels.RBXGeneral

systemMessageReceived.OnClientEvent:Connect(function(message: string)
	generalChannel:DisplaySystemMessage("[Server] " .. message)
end)
