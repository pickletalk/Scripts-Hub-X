-- Key System for Scripts Hub X
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)
local screenGui = playerGui:WaitForChild("ScriptsHubXLoading")
local mainFrame = screenGui:WaitForChild("mainFrame")

local keyFrame = Instance.new("Frame")
keyFrame.Name = "keyFrame"
keyFrame.Size = UDim2.new(0, 320, 0, 180)
keyFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
keyFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
keyFrame.BackgroundTransparency = 1
keyFrame.BorderSizePixel = 0
keyFrame.Parent = mainFrame

local keyFrameCorner = Instance.new("UICorner")
keyFrameCorner.CornerRadius = UDim.new(0, 12)
keyFrameCorner.Parent = keyFrame

local keyFrameStroke = Instance.new("UIStroke")
keyFrameStroke.Color = Color3.fromRGB(80, 160, 255)
keyFrameStroke.Thickness = 1.5
keyFrameStroke.Transparency = 1
keyFrameStroke.Parent = keyFrame

local keyTitleLabel = Instance.new("TextLabel")
keyTitleLabel.Size = UDim2.new(1, -30, 0, 30)
keyTitleLabel.Position = UDim2.new(0, 15, 0, 15)
keyTitleLabel.BackgroundTransparency = 1
keyTitleLabel.Text = "Key Verification"
keyTitleLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
keyTitleLabel.TextScaled = true
keyTitleLabel.TextSize = 18
keyTitleLabel.Font = Enum.Font.GothamMedium
keyTitleLabel.TextTransparency = 1
keyTitleLabel.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -30, 0, 30)
keyInput.Position = UDim2.new(0, 15, 0, 50)
keyInput.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
keyInput.BackgroundTransparency = 1
keyInput.Text = ""
keyInput.PlaceholderText = "Enter your key"
keyInput.TextColor3 = Color3.fromRGB(150, 180, 200)
keyInput.TextScaled = true
keyInput.TextSize = 12
keyInput.Font = Enum.Font.Gotham
keyInput.TextTransparency = 1
keyInput.Parent = keyFrame

local keyInputCorner = Instance.new("UICorner")
keyInputCorner.CornerRadius = UDim.new(0, 6)
keyInputCorner.Parent = keyInput

local keyDescLabel = Instance.new("TextLabel")
keyDescLabel.Size = UDim2.new(1, -30, 0, 30)
keyDescLabel.Position = UDim2.new(0, 15, 0, 85)
keyDescLabel.BackgroundTransparency = 1
keyDescLabel.Text = "Join our Discord for the key!"
keyDescLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
keyDescLabel.TextScaled = true
keyDescLabel.TextSize = 10
keyDescLabel.Font = Enum.Font.Gotham
keyDescLabel.TextTransparency = 1
keyDescLabel.TextWrapped = true
keyDescLabel.Parent = keyFrame

local joinDiscordButton = Instance.new("TextButton")
joinDiscordButton.Size = UDim2.new(0, 100, 0, 28)
joinDiscordButton.Position = UDim2.new(0, 25, 0, 120)
joinDiscordButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
joinDiscordButton.BackgroundTransparency = 1
joinDiscordButton.Text = "Join Discord"
joinDiscordButton.TextColor3 = Color3.fromRGB(230, 240, 255)
joinDiscordButton.TextScaled = true
joinDiscordButton.TextSize = 10
joinDiscordButton.Font = Enum.Font.GothamMedium
joinDiscordButton.TextTransparency = 1
joinDiscordButton.Parent = keyFrame

local joinDiscordButtonCorner = Instance.new("UICorner")
joinDiscordButtonCorner.CornerRadius = UDim.new(0, 6)
joinDiscordButtonCorner.Parent = joinDiscordButton

local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(0, 100, 0, 28)
verifyButton.Position = UDim2.new(0.5, 15, 0, 120)
verifyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
verifyButton.BackgroundTransparency = 1
verifyButton.Text = "Verify"
verifyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
verifyButton.TextScaled = true
verifyButton.TextSize = 10
verifyButton.Font = Enum.Font.GothamMedium
verifyButton.TextTransparency = 1
verifyButton.Parent = keyFrame

local verifyButtonCorner = Instance.new("UICorner")
verifyButtonCorner.CornerRadius = UDim.new(0, 6)
verifyButtonCorner.Parent = verifyButton

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -32, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(230, 240, 255)
closeButton.TextScaled = true
closeButton.TextSize = 12
closeButton.Font = Enum.Font.GothamBold
closeButton.TextTransparency = 1
closeButton.Parent = keyFrame

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0.5, 0)
closeButtonCorner.Parent = closeButton

-- Button hover effects
local function addButtonHoverEffect(button)
    local originalSize = button.Size
    local hoverSize = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 4, originalSize.Y.Scale, originalSize.Y.Offset + 4)
    local originalColor = button.BackgroundColor3
    local hoverColor = Color3.fromRGB(originalColor.R * 255 + 20, originalColor.G * 255 + 20, originalColor.B * 255 + 20)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Size = hoverSize,
            BackgroundColor3 = hoverColor
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Size = originalSize,
            BackgroundColor3 = originalColor
        }):Play()
    end)
end

addButtonHoverEffect(joinDiscordButton)
addButtonHoverEffect(verifyButton)

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Rotation = 90,
        BackgroundColor3 = Color3.fromRGB(255, 120, 120)
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Rotation = 0,
        BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    }):Play()
end)

copyButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "Copied!"
        copyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
        wait(1)
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
        print("Discord link copied")
    end)
end)

joinDiscordButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        joinDiscordButton.Text = "Copied!"
        joinDiscordButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
        wait(1)
        joinDiscordButton.Text = "Join Discord"
        joinDiscordButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
        print("Discord link copied via Join Discord button")
    end)
end)

closeButton.MouseButton1Click:Connect(function()
    print("Close button clicked")
    local closeTween = TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 340, 0, 190),
        Position = UDim2.new(0.5, -170, 0.5, -95)
    })

    local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })

    local strokeTween = TweenService:Create(keyFrameStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    })

    for _, element in pairs({keyTitleLabel, keyInput, keyDescLabel, joinDiscordButton, verifyButton, closeButton}) do
        TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1,
            BackgroundTransparency = 1
        }):Play()
    end

    closeTween:Play()
    mainFrameTween:Play()
    strokeTween:Play()
    closeTween.Completed:Wait()
    screenGui:Destroy()
    print("ScreenGui destroyed")
end)

verifyButton.MouseButton1Click:Connect(function()
    print("Verify button clicked")
    verifyKey()
end)

local correctKey = "07618-826391-192739-81625"
local premiumKey = "$PREMIUM$"
keyVerified = false

local function verifyKey()
    local inputKey = keyInput.Text
    if inputKey == correctKey then
        print("Temporary key verified: " .. inputKey)
        keyVerified = true
        return true
    elseif inputKey == premiumKey then
        print("Premium key verified: " .. inputKey)
        keyVerified = true
        return true
    else
        keyDescLabel.Text = "Key is invalid"
        keyDescLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        wait(3)
        keyDescLabel.Text = "Join our Discord for the key!"
        keyDescLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
        print("Invalid key entered: " .. inputKey)
        return false
    end
end

local function showKeySystem()
    print("Attempting to show key system")
    if keyVerified then
        print("Key already verified, skipping GUI")
        hideKeySystem()
        return
    end

    contentFrame.Visible = false
    waterDropFrame.Visible = false

    local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.7
    })

    local keyFrameTween = TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 320, 0, 180)
    })

    local keyStrokeTween = TweenService:Create(keyFrameStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Transparency = 0.4
    })

    local keyTitleTween = TweenService:Create(keyTitleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })

    local keyInputTween = TweenService:Create(keyInput, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.6,
        TextTransparency = 0
    })

    local keyDescTween = TweenService:Create(keyDescLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })

    local joinDiscordTween = TweenService:Create(joinDiscordButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    })

    local verifyButtonTween = TweenService:Create(verifyButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    })

    local closeButtonTween = TweenService:Create(closeButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    })

    print("Playing key system animations")
    mainFrameTween:Play()
    keyFrameTween:Play()
    keyStrokeTween:Play()
    keyTitleTween:Play()
    wait(0.1)
    keyInputTween:Play()
    wait(0.1)
    keyDescTween:Play()
    wait(0.1)
    joinDiscordTween:Play()
    verifyButtonTween:Play()
    closeButtonTween:Play()
end

local function animateKeyPulse()
    local pulseTween = TweenService:Create(keyFrameStroke, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = 0.2
    })
    pulseTween:Play()
    print("Key pulse animation started")
end

local function hideKeySystem()
    print("Hiding key system")
    local keyFrameTween = TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 340, 0, 190)
    })

    local keyStrokeTween = TweenService:Create(keyFrameStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    })

    local keyTitleTween = TweenService:Create(keyTitleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })

    local keyInputTween = TweenService:Create(keyInput, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    local keyDescTween = TweenService:Create(keyDescLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })

    local joinDiscordTween = TweenService:Create(joinDiscordButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    local verifyButtonTween = TweenService:Create(verifyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    local closeButtonTween = TweenService:Create(closeButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    keyFrameTween:Play()
    keyStrokeTween:Play()
    keyTitleTween:Play()
    keyInputTween:Play()
    keyDescTween:Play()
    joinDiscordTween:Play()
    verifyButtonTween:Play()
    closeButtonTween:Play()

    keyFrameTween.Completed:Wait()
    keyFrame:Destroy()
    contentFrame.Visible = true
    waterDropFrame.Visible = true
    print("Key system hidden")
end

return {
    showKeySystem = showKeySystem,
    animateKeyPulse = animateKeyPulse,
    hideKeySystem = hideKeySystem,
    keyVerified = keyVerified,
    verifyKey = verifyKey
}
