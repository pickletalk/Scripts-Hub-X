-- Scripts Hub X | Key System
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

-- Create key system GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsHubXKeySystem"
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 300, 0, 200)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
keyFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
keyFrame.BackgroundTransparency = 1
keyFrame.BorderSizePixel = 0
keyFrame.Parent = screenGui

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 10)
keyCorner.Parent = keyFrame

local keyStroke = Instance.new("UIStroke")
keyStroke.Color = Color3.fromRGB(80, 160, 255)
keyStroke.Thickness = 1
keyStroke.Transparency = 1
keyStroke.Parent = keyFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Key Verification"
titleLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1
titleLabel.Parent = keyFrame

-- Key Input
local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -40, 0, 40)
keyInput.Position = UDim2.new(0, 20, 0, 60)
keyInput.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = "Enter key here"
keyInput.TextColor3 = Color3.fromRGB(150, 180, 200)
keyInput.TextSize = 14
keyInput.Font = Enum.Font.Gotham
keyInput.TextTransparency = 1
keyInput.Parent = keyFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = keyInput

-- Description
local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(1, -40, 0, 40)
descLabel.Position = UDim2.new(0, 20, 0, 110)
descLabel.BackgroundTransparency = 1
descLabel.Text = "Join our Discord server to get the key."
descLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
descLabel.TextSize = 12
descLabel.Font = Enum.Font.Gotham
descLabel.TextWrapped = true
descLabel.TextTransparency = 1
descLabel.Parent = keyFrame

-- Buttons Frame
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, -40, 0, 40)
buttonsFrame.Position = UDim2.new(0, 20, 0, 160)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = keyFrame

-- Verify Button
local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(0.45, 0, 1, 0)
verifyButton.Position = UDim2.new(0, 0, 0, 0)
verifyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
verifyButton.BackgroundTransparency = 1
verifyButton.Text = "Verify"
verifyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
verifyButton.TextSize = 14
verifyButton.Font = Enum.Font.GothamBold
verifyButton.TextTransparency = 1
verifyButton.Parent = buttonsFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 8)
verifyCorner.Parent = verifyButton

-- Join Discord Button
local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0.45, 0, 1, 0)
joinButton.Position = UDim2.new(0.55, 0, 0, 0)
joinButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
joinButton.BackgroundTransparency = 1
joinButton.Text = "Join Discord"
joinButton.TextColor3 = Color3.fromRGB(230, 240, 255)
joinButton.TextSize = 14
joinButton.Font = Enum.Font.GothamBold
joinButton.TextTransparency = 1
joinButton.Parent = buttonsFrame

local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 8)
joinCorner.Parent = joinButton

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(230, 240, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.TextTransparency = 1
closeButton.Parent = keyFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Fade-in animation
local function fadeIn()
    local frameTween = TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.5
    })
    local strokeTween = TweenService:Create(keyStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0.4
    })
    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    local inputTween = TweenService:Create(keyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.6,
        TextTransparency = 0
    })
    local descTween = TweenService:Create(descLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    local verifyTween = TweenService:Create(verifyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    })
    local joinTween = TweenService:Create(joinButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    })
    local closeTween = TweenService:Create(closeButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    })

    frameTween:Play()
    strokeTween:Play()
    titleTween:Play()
    wait(0.1)
    inputTween:Play()
    wait(0.1)
    descTween:Play()
    wait(0.1)
    verifyTween:Play()
    joinTween:Play()
    closeTween:Play()
end

-- Fade-out animation
local function fadeOut()
    local frameTween = TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })
    local strokeTween = TweenService:Create(keyStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    })
    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })
    local inputTween = TweenService:Create(keyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local descTween = TweenService:Create(descLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })
    local verifyTween = TweenService:Create(verifyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local joinTween = TweenService:Create(joinButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local closeTween = TweenService:Create(closeButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    frameTween:Play()
    strokeTween:Play()
    titleTween:Play()
    inputTween:Play()
    descTween:Play()
    verifyTween:Play()
    joinTween:Play()
    closeTween:Play()

    frameTween.Completed:Wait()
    screenGui:Destroy()
end

-- Key verification logic
local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerKeyStatus_" .. player.UserId)
local isVerified = playerDataStore:GetAsync("IsPremium") or false
local isPremium = isVerified

if isPremium then
    fadeOut()
    return
end

local function verifyKey()
    local inputKey = keyInput.Text:upper()
    if inputKey == "07618-826391-192739-81625" then
        descLabel.Text = "Temporary key accepted. Re-enter next time."
        descLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        isVerified = true
        wait(2)
        descLabel.Text = "Join our Discord server to get the key."
        descLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
    elseif inputKey == "$PREMIUM$" then
        descLabel.Text = "Premium key accepted. No further verification needed."
        descLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        isVerified = true
        isPremium = true
        playerDataStore:SetAsync("IsPremium", true)
        wait(2)
        descLabel.Text = "Join our Discord server to get the key."
        descLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
    else
        descLabel.Text = "Invalid key. Try again or join Discord for help."
        descLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        keyInput.Text = ""
        wait(3)
        descLabel.Text = "Join our Discord server to get the key."
        descLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
    end
    if isVerified or isPremium then
        fadeOut()
    end
end

-- Button functions
verifyButton.MouseButton1Click:Connect(verifyKey)
joinButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/bpsNUH5sVb")
    joinButton.Text = "Copied!"
    joinButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
    wait(1)
    joinButton.Text = "Join Discord"
    joinButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
end)

closeButton.MouseButton1Click:Connect(fadeOut)

-- Public functions
return {
    showKeySystem = fadeIn,
    hideKeySystem = fadeOut,
    isKeyVerified = function() return isVerified or isPremium end
}
