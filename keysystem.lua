-- Scripts Hub X | Key System
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemGUI"
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250) -- Compact size
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 150, 255)
uiStroke.Thickness = 2
uiStroke.Transparency = 1
uiStroke.Parent = mainFrame

-- Close Button (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextTransparency = 1
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Key System"
titleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextTransparency = 1
titleLabel.Parent = mainFrame

-- Key Input
local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -40, 0, 40)
keyInput.Position = UDim2.new(0, 20, 0, 60)
keyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = "Enter Key Here"
keyInput.TextColor3 = Color3.fromRGB(200, 200, 200)
keyInput.TextSize = 14
keyInput.Font = Enum.Font.SourceSans
keyInput.TextTransparency = 1
keyInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = keyInput

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 40)
statusLabel.Position = UDim2.new(0, 20, 0, 110)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Enter the valid key to proceed!"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextWrapped = true
statusLabel.TextTransparency = 1
statusLabel.Parent = mainFrame

-- Buttons Frame
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, -40, 0, 80) -- Adjusted for smaller buttons
buttonsFrame.Position = UDim2.new(0, 20, 0, 160)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

-- Verify Button
local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(0, 70, 0, 25) -- Smaller button
verifyButton.Position = UDim2.new(0, 0, 0, 0)
verifyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
verifyButton.BackgroundTransparency = 1
verifyButton.Text = "Verify"
verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyButton.TextSize = 12 -- Adjusted text size
verifyButton.Font = Enum.Font.SourceSansBold
verifyButton.TextTransparency = 1
verifyButton.Parent = buttonsFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 8)
verifyCorner.Parent = verifyButton

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Size = UDim2.new(0, 70, 0, 25) -- Smaller button
getKeyButton.Position = UDim2.new(0, 75, 0, 0) -- Side by side
getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
getKeyButton.BackgroundTransparency = 1
getKeyButton.Text = "Get Key"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 12
getKeyButton.Font = Enum.Font.SourceSansBold
getKeyButton.TextTransparency = 1
getKeyButton.Parent = buttonsFrame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyButton

-- Join Discord Button
local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0, 70, 0, 25) -- Smaller button
joinButton.Position = UDim2.new(0, 115, 0, 30) -- Below the other two, centered
joinButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
joinButton.BackgroundTransparency = 1
joinButton.Text = "Join Discord"
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.TextSize = 12
joinButton.Font = Enum.Font.SourceSansBold
joinButton.TextTransparency = 1
joinButton.Parent = buttonsFrame

local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 8)
joinCorner.Parent = joinButton

local function ShowKeySystem()
    local frameTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2
    })
    local strokeTween = TweenService:Create(uiStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    })
    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    local inputTween = TweenService:Create(keyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.3,
        TextTransparency = 0
    })
    local statusTween = TweenService:Create(statusLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    local verifyTween = TweenService:Create(verifyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.3,
        TextTransparency = 0
    })
    local getKeyTween = TweenService:Create(getKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.3,
        TextTransparency = 0
    })
    local joinTween = TweenService:Create(joinButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.3,
        TextTransparency = 0
    })
    local closeTween = TweenService:Create(closeButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.3,
        TextTransparency = 0
    })

    frameTween:Play()
    strokeTween:Play()
    titleTween:Play()
    wait(0.1)
    inputTween:Play()
    wait(0.1)
    statusTween:Play()
    wait(0.1)
    verifyTween:Play()
    getKeyTween:Play()
    joinTween:Play()
    closeTween:Play()
end

local function HideKeySystem()
    local frameTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0) -- Evaporate effect
    })
    local strokeTween = TweenService:Create(uiStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    })
    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })
    local inputTween = TweenService:Create(keyInput, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local statusTween = TweenService:Create(statusLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })
    local verifyTween = TweenService:Create(verifyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local getKeyTween = TweenService:Create(getKeyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local joinTween = TweenService:Create(joinButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local closeTween = TweenService:Create(closeButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    frameTween:Play()
    strokeTween:Play()
    titleTween:Play()
    inputTween:Play()
    statusTween:Play()
    verifyTween:Play()
    getKeyTween:Play()
    joinTween:Play()
    closeTween:Play()

    frameTween.Completed:Wait()
    screenGui:Destroy()
end

local isVerified = false

local function VerifyKey()
    local inputKey = keyInput.Text:upper()
    if inputKey == "07618-826391-192739-81625" then
        statusLabel.Text = "Key accepted! Loading..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        isVerified = true
        wait(1)
        HideKeySystem()
    else
        statusLabel.Text = "Invalid key! Try again."
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        keyInput.Text = ""
        wait(2)
        statusLabel.Text = "Enter the valid key to proceed!"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("https://rekonise.com/scripts-hub-x-or-official-3i64w")
    getKeyButton.Text = "Copied!"
    getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    wait(1)
    getKeyButton.Text = "Get Key"
    getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

joinButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/bpsNUH5sVb") -- Replace with your actual invite link
    joinButton.Text = "Copied!"
    joinButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    wait(1)
    joinButton.Text = "Join Discord"
    joinButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

closeButton.MouseButton1Click:Connect(HideKeySystem)

verifyButton.MouseButton1Click:Connect(VerifyKey)

-- No initial verification check needed
return {
    ShowKeySystem = ShowKeySystem,
    HideKeySystem = HideKeySystem,
    IsKeyVerified = function() return isVerified end
}
