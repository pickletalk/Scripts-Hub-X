-- Define the webhook URL
local WEBHOOK_URL = "https://discord.com/api/webhooks/1390952057296519189/n0SJoYfZq0PD4-vphnZw2d5RTesGZvkLSWm6RX_sBbCZC2QXxVdGQ5q7N338mZ4m9j5E"

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
        content = "# Scripts Hub X | Official\n**What We Have?**\n> • Roblox Game Scripts\n> • Every Games Scripts\n> • Scripts Suggestable\n> • No @everyone Pings\n> • Developer\n> • Much updates\n> • Active dev\n\nhttps://discord.gg/bpsNUH5sVb\n@everyone"
    }
    local jsonData = HttpService:JSONEncode(data)
    
    local success, response = pcall(function()
        return HttpService:PostAsync(WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)
    
    if success then
        print("Webhook sent successfully!")
    else
        warn("Failed to send webhook: " .. tostring(response))
    end
end

-- Connect button click to sendWebhookMessage
button.MouseButton1Click:Connect(sendWebhookMessage)
