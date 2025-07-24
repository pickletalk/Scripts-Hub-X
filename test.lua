local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Webhook URL
local WEBHOOK_URL = "https://discord.com/api/webhooks/1396650841045209169/Mx_0dcjOVnzp5f5zMhYM2uOBCPGt9SPr908shfLh_FGKZJ5eFc4tMsiiNNp1CGDx_M21"

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WebhookSenderGui"
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Create main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add corner rounding
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

-- Create TextBox
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.9, 0, 0, 100)
textBox.Position = UDim2.new(0.05, 0, 0.1, 0)
textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderText = "Enter message here..."
textBox.Text = ""
textBox.TextScaled = true
textBox.TextWrapped = true
textBox.Font = Enum.Font.SourceSans
textBox.Parent = frame

-- Add TextBox corner rounding
local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 5)
textBoxCorner.Parent = textBox

-- Create Send Button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.4, 0, 0, 40)
sendButton.Position = UDim2.new(0.3, 0, 0.75, 0)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "Send"
sendButton.TextScaled = true
sendButton.Font = Enum.Font.SourceSansBold
sendButton.Parent = frame

-- Add Send Button corner rounding
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 5)
buttonCorner.Parent = sendButton

-- Function to send webhook
local function sendWebhookMessage()
    local message = textBox.Text
    if message == "" then return end

    local data = {
        content = message,
        username = "Stop With This Scam Script Leaking Their Profile Information!",
        avatar_url = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg" -- [INSERT YOUR WEBHOOK PROFILE THUMBNAIL URL HERE]
    }

    local success, response = pcall(function()
        return HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)

    if not success then
        warn("Failed to send webhook: " .. response)
    end
end

-- Connect Send Button
sendButton.MouseButton1Click:Connect(function()
    sendWebhookMessage()
end)

-- Add button hover effect
sendButton.MouseEnter:Connect(function()
    sendButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

sendButton.MouseLeave:Connect(function()
    sendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
end)
