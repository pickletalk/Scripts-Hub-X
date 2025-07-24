-- Define the webhook URL
local WEBHOOK_URL = "https://discord.com/api/webhooks/1396650841045209169/Mx_0dcjOVnzp5f5zMhYM2uOBCPGt9SPr908shfLh_FGKZJ5eFc4tMsiiNNp1CGDx_M21"

-- Get services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.Name = "WebhookUI"

-- Create Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Create Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0.5, -50, 0.5, -25)
button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Send"
button.Parent = frame

-- Function to send message to Discord webhook
local function sendWebhookMessage()
    local data = {
        content = "# Scripts Hub X | Official\n**What We Have?**\n> • Roblox Game Scripts\n> • Every Games Scripts\n> • Scripts Suggestable\n> • No @ everyone Pings\n> • Developer\n> • Much updates\n> • Active dev\n\nhttps://discord.gg/bpsNUH5sVb/n@everyone"
    }
    local jsonData = HttpService:JSONEncode(data)
    
    local success, errorMessage = pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)
    
    if not success then
        warn("Failed to send webhook: " .. errorMessage)
    end
end

-- Connect button click to sendWebhookMessage
button.MouseButton1Click:Connect(sendWebhookMessage)
