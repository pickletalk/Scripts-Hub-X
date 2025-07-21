-- Scripts Hub X | Key System
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)
if not playerGui then
    warn("PlayerGui not found after 5 seconds")
    return {}
end
print("Key system started, PlayerGui found")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemGUI"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui
print("KeySystemGUI created")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 100, 200)
uiStroke.Thickness = 1.5
uiStroke.Transparency = 1
uiStroke.Parent = mainFrame

-- Close Button (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.TextTransparency = 1
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Key System"
titleLabel.TextColor3 = Color3.fromRGB(0, 120, 220)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1
titleLabel.Parent = mainFrame

-- Key Input
local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -30, 0, 35)
keyInput.Position = UDim2.new(0, 15, 0, 50)
keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = "Enter Key Here"
keyInput.TextColor3 = Color3.fromRGB(180, 180, 200)
keyInput.TextSize = 12
keyInput.Font = Enum.Font.Gotham
keyInput.TextTransparency = 1
keyInput.Text = ""
keyInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = keyInput

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -30, 0, 30)
statusLabel.Position = UDim2.new(0, 15, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Get key or join Discord server to get the key!" -- Fixed typo
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextWrapped = true
statusLabel.TextTransparency = 1
statusLabel.Parent = mainFrame

-- Buttons Frame
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, -30, 0, 30)
buttonsFrame.Position = UDim2.new(0, 15, 0, 130)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

-- Verify Button
local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(0, 60, 0, 25)
verifyButton.Position = UDim2.new(0, 15, 0, 0)
verifyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
verifyButton.BackgroundTransparency = 1
verifyButton.Text = "Verify"
verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyButton.TextSize = 11
verifyButton.Font = Enum.Font.GothamBold
verifyButton.TextTransparency = 1
verifyButton.Parent = buttonsFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 8)
verifyCorner.Parent = verifyButton

-- Join Discord Button
local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0, 60, 0, 25)
joinButton.Position = UDim2.new(0, 85, 0, 0)
joinButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
joinButton.BackgroundTransparency = 1
joinButton.Text = "Join Discord"
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.TextSize = 11
joinButton.Font = Enum.Font.GothamBold
joinButton.TextTransparency = 1
joinButton.Parent = buttonsFrame

local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 8)
joinCorner.Parent = joinButton

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Size = UDim2.new(0, 60, 0, 25)
getKeyButton.Position = UDim2.new(0, 155, 0, 0)
getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
getKeyButton.BackgroundTransparency = 1
getKeyButton.Text = "Get Key"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 11
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextTransparency = 1
getKeyButton.Parent = buttonsFrame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyButton

local isVerified = false
local maxAttempts = 5
local attemptCount = 0

local function ShowKeySystem()
    print("Showing key system UI")
    local success, err = pcall(function()
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
        inputTween:Play()
        statusTween:Play()
        verifyTween:Play()
        getKeyTween:Play()
        joinTween:Play()
        closeTween:Play()
    end)
    if not success then
        warn("Failed to show key system UI: " .. tostring(err))
        -- Fallback: Set visible properties
        mainFrame.BackgroundTransparency = 0.2
        uiStroke.Transparency = 0
        titleLabel.TextTransparency = 0
        keyInput.BackgroundTransparency = 0.3
        keyInput.TextTransparency = 0
        statusLabel.TextTransparency = 0
        verifyButton.BackgroundTransparency = 0.3
        verifyButton.TextTransparency = 0
        getKeyButton.BackgroundTransparency = 0.3
        getKeyButton.TextTransparency = 0
        joinButton.BackgroundTransparency = 0.3
        joinButton.TextTransparency = 0
        closeButton.BackgroundTransparency = 0.3
        closeButton.TextTransparency = 0
    end
end

local function HideKeySystem()
    print("Hiding key system UI")
    local success, err = pcall(function()
        local frameTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 250, 0, 200) -- Reset size to avoid glitches
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
        frameTween.Completed:Connect(function()
            if screenGui and screenGui.Parent then
                screenGui:Destroy()
                print("KeySystemGUI destroyed")
            end
        end)
    end)
    if not success then
        warn("Failed to hide key system UI: " .. tostring(err))
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
            print("KeySystemGUI destroyed (fallback)")
        end
    end
end

local function VerifyKey()
    attemptCount = attemptCount + 1
    print("Verification attempt #" .. attemptCount .. ", Input Key: " .. keyInput.Text)
    if attemptCount > maxAttempts then
        statusLabel.Text = "Max attempts reached!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        wait(2)
        HideKeySystem()
        return
    end
    local inputKey = keyInput.Text:upper()
    if inputKey == "PICKLE" then
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
        statusLabel.Text = "Get key or join Discord server to get the key!"
        statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    end
end

getKeyButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        setclipboard("https://rekonise.com/scripts-hub-x-or-official-3i64w")
        getKeyButton.Text = "Copied!"
        getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
        wait(1)
        getKeyButton.Text = "Get Key"
        getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    end)
    if not success then
        warn("Get Key button failed: " .. tostring(err))
    end
end)

joinButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        joinButton.Text = "Copied!"
        joinButton.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
        wait(1)
        joinButton.Text = "Join Discord"
        joinButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    end)
    if not success then
        warn("Join Discord button failed: " .. tostring(err))
    end
end)

closeButton.MouseButton1Click:Connect(function()
    print("Close button clicked")
    HideKeySystem()
end)

verifyButton.MouseButton1Click:Connect(function()
    print("Verify button clicked")
    VerifyKey()
end)

return {
    ShowKeySystem = ShowKeySystem,
    HideKeySystem = HideKeySystem,
    IsKeyVerified = function() return isVerified end
}
