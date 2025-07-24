-- Define the webhook URL
local WEBHOOK_URL = "https://discord.com/api/webhooks/1396650841045209169/Mx_0dcjOVnzp5f5zMhYM2uOBCPGt9SPr908shfLh_FGKZJ5eFc4tMsiiNNp1CGDx_M21"

-- Get services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Wait for player to load
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Name = "WebhookUI"
screenGui.ResetOnSpawn = false

-- Create main frame with rounded corners
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 140)
frame.Position = UDim2.new(0.5, -140, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(40, 42, 54)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add corner radius to frame
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Add drop shadow effect
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 6, 1, 6)
shadow.Position = UDim2.new(0, -3, 0, 3)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.8
shadow.BorderSizePixel = 0
shadow.ZIndex = frame.ZIndex - 1
shadow.Parent = frame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- Create title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = frame

-- Create status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready to send webhook"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame

-- Create send button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 120, 0, 35)
sendButton.Position = UDim2.new(0.5, -60, 1, -50)
sendButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
sendButton.BorderSizePixel = 0
sendButton.Text = "Send Webhook"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.TextScaled = true
sendButton.Font = Enum.Font.GothamSemibold
sendButton.Parent = frame

-- Add corner radius to button
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = sendButton

-- Create close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 47)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Animation tweens
local buttonHoverTween = TweenService:Create(
    sendButton,
    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {BackgroundColor3 = Color3.fromRGB(134, 157, 238)}
)

local buttonLeaveTween = TweenService:Create(
    sendButton,
    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {BackgroundColor3 = Color3.fromRGB(114, 137, 218)}
)

-- Function to update status
local function updateStatus(message, color)
    statusLabel.Text = message
    statusLabel.TextColor3 = color or Color3.fromRGB(150, 150, 150)
end

-- Function to send message to Discord webhook
local function sendWebhookMessage()
    -- Disable button during sending
    sendButton.Enabled = false
    sendButton.Text = "Sending..."
    updateStatus("Sending webhook...", Color3.fromRGB(255, 193, 7))
    
    -- Fixed message content (removed invalid escape sequence)
    local data = {
        content = "# Scripts Hub X | Official\n**What We Have?**\n> • Roblox Game Scripts\n> • Every Games Scripts\n> • Scripts Suggestable\n> • No @ everyone Pings\n> • Developer\n> • Much updates\n> • Active dev\n\nhttps://discord.gg/bpsNUH5sVb\n@everyone"
    }
    
    -- Convert to JSON
    local success, jsonData = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    
    if not success then
        updateStatus("JSON encoding failed!", Color3.fromRGB(220, 50, 47))
        sendButton.Enabled = true
        sendButton.Text = "Send Webhook"
        return
    end
    
    -- Send the webhook
    local httpSuccess, response = pcall(function()
        return HttpService:PostAsync(
            WEBHOOK_URL,
            jsonData,
            Enum.HttpContentType.ApplicationJson,
            false,
            {["Content-Type"] = "application/json"}
        )
    end)
    
    -- Handle response
    if httpSuccess then
        updateStatus("Webhook sent successfully!", Color3.fromRGB(40, 167, 69))
        sendButton.Text = "✓ Sent"
        wait(2)
        sendButton.Text = "Send Webhook"
    else
        updateStatus("Failed to send webhook!", Color3.fromRGB(220, 50, 47))
        warn("Webhook error: " .. tostring(response))
        sendButton.Text = "Retry"
    end
    
    -- Re-enable button
    sendButton.Enabled = true
end

-- Button hover effects
sendButton.MouseEnter:Connect(function()
    if sendButton.Enabled then
        buttonHoverTween:Play()
    end
end)

sendButton.MouseLeave:Connect(function()
    if sendButton.Enabled then
        buttonLeaveTween:Play()
    end
end)

-- Connect button click to sendWebhookMessage
sendButton.MouseButton1Click:Connect(sendWebhookMessage)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Make frame draggable
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
