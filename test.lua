-- Game JobId Joiner Script
-- Clean UI for joining games by JobId

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Get current place ID
local currentPlaceId = game.PlaceId

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JobIdJoiner"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 200)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add corner rounding
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Add drop shadow effect
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 6, 1, 6)
shadow.Position = UDim2.new(0, -3, 0, -3)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.ZIndex = mainFrame.ZIndex - 1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🎮 Game Joiner"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- JobId Input Section
local inputLabel = Instance.new("TextLabel")
inputLabel.Name = "InputLabel"
inputLabel.Size = UDim2.new(1, -20, 0, 25)
inputLabel.Position = UDim2.new(0, 10, 0, 60)
inputLabel.BackgroundTransparency = 1
inputLabel.Text = "Enter Server JobId to join:"
inputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
inputLabel.TextScaled = true
inputLabel.Font = Enum.Font.Gotham
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Parent = mainFrame

-- JobId TextBox
local jobIdTextBox = Instance.new("TextBox")
jobIdTextBox.Name = "JobIdTextBox"
jobIdTextBox.Size = UDim2.new(1, -20, 0, 35)
jobIdTextBox.Position = UDim2.new(0, 10, 0, 90)
jobIdTextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
jobIdTextBox.BorderSizePixel = 0
jobIdTextBox.Text = ""
jobIdTextBox.PlaceholderText = "e.g., 12345678-1234-1234-1234-123456789012"
jobIdTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jobIdTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
jobIdTextBox.TextScaled = true
jobIdTextBox.Font = Enum.Font.Gotham
jobIdTextBox.ClearTextOnFocus = false
jobIdTextBox.Parent = mainFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 6)
textBoxCorner.Parent = jobIdTextBox

-- Join Button
local joinButton = Instance.new("TextButton")
joinButton.Name = "JoinButton"
joinButton.Size = UDim2.new(0, 120, 0, 35)
joinButton.Position = UDim2.new(0.5, -60, 0, 145)
joinButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
joinButton.BorderSizePixel = 0
joinButton.Text = "🚀 Join Game"
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.TextScaled = true
joinButton.Font = Enum.Font.GothamBold
joinButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = joinButton

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 1, -30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready to join!"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeButton

-- Functions
local function updateStatus(message, color)
    statusLabel.Text = message
    statusLabel.TextColor3 = color
end

local function animateButton(button, scale)
    local tween = TweenService:Create(
        button,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = button.Size * scale}
    )
    tween:Play()
    tween.Completed:Connect(function()
        local backTween = TweenService:Create(
            button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = button.Size / scale}
        )
        backTween:Play()
    end)
end

local function joinGameByJobId(jobId)
    if not jobId or jobId == "" then
        updateStatus("❌ Please enter a JobId!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    -- Remove any whitespace and validate JobId format
    jobId = string.gsub(jobId, "%s+", "")
    
    -- Basic JobId validation (should be a long string with hyphens)
    if not string.match(jobId, "%w+%-%w+%-%w+%-%w+%-%w+") then
        updateStatus("❌ Invalid JobId format!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    updateStatus("🔄 Teleporting to server...", Color3.fromRGB(255, 255, 100))
    
    -- Use spawn to prevent yielding issues
    spawn(function()
        local success, errorMessage = pcall(function()
            -- Use TeleportToPlaceInstance with current place ID and the JobId
            TeleportService:TeleportToPlaceInstance(currentPlaceId, jobId)
        end)
        
        if not success then
            updateStatus("❌ Teleport failed: " .. tostring(errorMessage), Color3.fromRGB(255, 100, 100))
            print("Teleport Error:", errorMessage)
        else
            updateStatus("✅ Teleporting...", Color3.fromRGB(100, 255, 100))
        end
    end)
end

-- Event Connections
joinButton.MouseButton1Click:Connect(function()
    animateButton(joinButton, 0.95)
    local jobId = jobIdTextBox.Text
    joinGameByJobId(jobId)
end)

-- Enter key support
jobIdTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local jobId = jobIdTextBox.Text
        joinGameByJobId(jobId)
    end
end)

-- Close button
closeButton.MouseButton1Click:Connect(function()
    animateButton(closeButton, 0.9)
    screenGui:Destroy()
end)

-- Hover effects
joinButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(
        joinButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(30, 180, 255)}
    )
    tween:Play()
end)

joinButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(
        joinButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(0, 162, 255)}
    )
    tween:Play()
end)

closeButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(
        closeButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(255, 120, 120)}
    )
    tween:Play()
end)

closeButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(
        closeButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(255, 85, 85)}
    )
    tween:Play()
end)

-- TextBox focus effects
jobIdTextBox.Focused:Connect(function()
    local tween = TweenService:Create(
        jobIdTextBox,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}
    )
    tween:Play()
end)

jobIdTextBox.FocusLost:Connect(function()
    local tween = TweenService:Create(
        jobIdTextBox,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}
    )
    tween:Play()
end)

-- Make the GUI draggable
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

updateStatus("Ready! Current Place: " .. tostring(currentPlaceId), Color3.fromRGB(150, 150, 255))
