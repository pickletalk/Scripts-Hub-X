-- Scripts Hub X | Enhanced Loading Screen
-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsHubXLoading"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Completion flag
local isComplete = false

-- Main background frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

-- Content frame (cleaner, centered, slightly larger)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 350, 0, 280)
contentFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame corner (softer radius)
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 8)
contentFrameCorner.Parent = contentFrame

-- Content frame glow (subtle)
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(80, 160, 255)
contentStroke.Thickness = 1.5
contentStroke.Transparency = 1
contentStroke.Parent = contentFrame

-- Title label (cleaner, larger, centered)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X"
titleLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
titleLabel.TextScaled = true
titleLabel.TextSize = 28
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1
titleLabel.Parent = contentFrame

-- Subtitle label (smaller, aligned)
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, -40, 0, 30)
subtitleLabel.Position = UDim2.new(0, 20, 0, 70)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Official Loading"
subtitleLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
subtitleLabel.TextScaled = true
subtitleLabel.TextSize = 16
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextTransparency = 1
subtitleLabel.Parent = contentFrame

-- Discord container (compact, modern)
local discordContainer = Instance.new("Frame")
discordContainer.Size = UDim2.new(1, -40, 0, 40)
discordContainer.Position = UDim2.new(0, 20, 0, 110)
discordContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
discordContainer.BackgroundTransparency = 1
discordContainer.BorderSizePixel = 0
discordContainer.Parent = contentFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 6)
discordCorner.Parent = discordContainer

-- Discord label (cleaner alignment)
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.65, -10, 1, -6)
discordLabel.Position = UDim2.new(0, 10, 0, 3)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
discordLabel.TextScaled = true
discordLabel.TextSize = 12
discordLabel.Font = Enum.Font.Gotham
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.TextTransparency = 1
discordLabel.Parent = discordContainer

-- Copy button (sleek, compact)
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 80, 0, 28)
copyButton.Position = UDim2.new(0.7, 5, 0, 6)
copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
copyButton.BackgroundTransparency = 1
copyButton.Text = "Copy"
copyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
copyButton.TextScaled = true
copyButton.TextSize = 12
copyButton.Font = Enum.Font.GothamBold
copyButton.TextTransparency = 1
copyButton.Parent = discordContainer

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 5)
copyButtonCorner.Parent = copyButton

-- Discord advertisement label
local discordAdLabel = Instance.new("TextLabel")
discordAdLabel.Size = UDim2.new(1, -40, 0, 30)
discordAdLabel.Position = UDim2.new(0, 20, 0, 155)
discordAdLabel.BackgroundTransparency = 1
discordAdLabel.Text = "Join our Discord for updates!"
discordAdLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
discordAdLabel.TextScaled = true
discordAdLabel.TextSize = 12
discordAdLabel.Font = Enum.Font.Gotham
discordAdLabel.TextTransparency = 1
discordAdLabel.TextWrapped = true
discordAdLabel.Parent = contentFrame

-- Loading bar container
local loadingBarContainer = Instance.new("Frame")
loadingBarContainer.Size = UDim2.new(1, -40, 0, 10)
loadingBarContainer.Position = UDim2.new(0, 20, 0, 195)
loadingBarContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
loadingBarContainer.BackgroundTransparency = 1
loadingBarContainer.BorderSizePixel = 0
loadingBarContainer.Parent = contentFrame

local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(0, 5)
loadingBarCorner.Parent = loadingBarContainer

-- Loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
loadingBarFill.BackgroundTransparency = 1
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarContainer

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 5)
loadingBarFillCorner.Parent = loadingBarFill

-- Percentage text
local percentageText = Instance.new("TextLabel")
percentageText.Size = UDim2.new(1, -40, 0, 20)
percentageText.Position = UDim2.new(0, 20, 0, 210)
percentageText.BackgroundTransparency = 1
percentageText.Text = "0%"
percentageText.TextColor3 = Color3.fromRGB(80, 160, 255)
percentageText.TextScaled = true
percentageText.TextSize = 14
percentageText.Font = Enum.Font.Gotham
percentageText.TextTransparency = 1
percentageText.Parent = contentFrame

-- Warning label (compact, below loading bar)
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -40, 0, 30)
warningLabel.Position = UDim2.new(0, 20, 0, 235)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "Warning: Avoid scripts from unknown sources to protect your in-game items!"
warningLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
warningLabel.TextScaled = true
warningLabel.TextSize = 10
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextTransparency = 1
warningLabel.TextWrapped = true
warningLabel.Parent = contentFrame

-- Water drop frame (simplified for cleaner animation)
local waterDropFrame = Instance.new("Frame")
waterDropFrame.Size = UDim2.new(0, 40, 0, 40)
waterDropFrame.Position = UDim2.new(0.5, -20, 0, -60)
waterDropFrame.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
waterDropFrame.BackgroundTransparency = 0.3
waterDropFrame.BorderSizePixel = 0
waterDropFrame.Parent = mainFrame

local waterDropCorner = Instance.new("UICorner")
waterDropCorner.CornerRadius = UDim.new(0.5, 0)
waterDropCorner.Parent = waterDropFrame

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "Copied!"
        copyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
        wait(1)
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    end)
end)

-- Animate loading bar (3-second realistic fill)
local function animateLoadingBar(callback)
    print("Starting animateLoadingBar")
    if not loadingBarFill or not loadingBarFill.Parent then
        warn("loadingBarFill is invalid or not parented")
        return
    end

    local loadingTween = TweenService:Create(loadingBarFill, TweenInfo.new(
        3, -- 3 seconds to fill
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.In
    ), {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0
    })

    local percentage = 0
    local percentageTween = TweenService:Create(percentageText, TweenInfo.new(
        3,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.In
    ), {
        TextTransparency = 0
    })

    -- Update percentage text dynamically
    local startTime = tick()
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        percentage = math.min((elapsed / 3) * 100, 100)
        percentageText.Text = string.format("%d%%", math.floor(percentage))
        if percentage >= 100 then
            connection:Disconnect()
            percentageText.TextColor3 = Color3.fromRGB(0, 200, 0) -- Green when complete
            isComplete = true
            wait(0.5)
            if callback then
                callback()
            end
        end
    end)

    loadingTween:Play()
    percentageTween:Play()
end

-- Entrance animations (cleaner, sequential fade-in)
local function playEntranceAnimations()
    -- Initialize hidden states
    contentFrame.BackgroundTransparency = 1
    contentStroke.Transparency = 1
    titleLabel.TextTransparency = 1
    subtitleLabel.TextTransparency = 1
    discordLabel.TextTransparency = 1
    copyButton.TextTransparency = 1
    copyButton.BackgroundTransparency = 1
    discordAdLabel.TextTransparency = 1
    loadingBarContainer.BackgroundTransparency = 1
    loadingBarFill.BackgroundTransparency = 1
    percentageText.TextTransparency = 1
    warningLabel.TextTransparency = 1

    -- Water drop fall (smoother, subtle)
    local dropFallTween = TweenService:Create(waterDropFrame, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        Position = UDim2.new(0.5, -20, 0.5, -140)
    })

    -- Ripple effect (cleaner, centered)
    local rippleTween = TweenService:Create(waterDropFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.new(0, 350, 0, 280),
        Position = UDim2.new(0.5, -175, 0.5, -140),
        BackgroundTransparency = 1
    })

    -- Content reveal tweens
    local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0.7
    })

    local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0.3
    })

    local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        Transparency = 0.2
    })

    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    local subtitleTween = TweenService:Create(subtitleLabel, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    local discordTween = TweenService:Create(discordLabel, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0,
        BackgroundTransparency = 0
    })

    local discordAdTween = TweenService:Create(discordAdLabel, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    local loadingBarTween = TweenService:Create(loadingBarContainer, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0.5
    })

    local warningTween = TweenService:Create(warningLabel, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    -- Play animations sequentially
    dropFallTween:Play()
    dropFallTween.Completed:Connect(function()
        rippleTween:Play()
    end)

    rippleTween.Completed:Connect(function()
        mainFrameTween:Play()
        contentFrameTween:Play()
        contentStrokeTween:Play()
        titleTween:Play()
        wait(0.1)
        subtitleTween:Play()
        wait(0.1)
        discordTween:Play()
        copyButtonTween:Play()
        wait(0.1)
        discordAdTween:Play()
        wait(0.1)
        loadingBarTween:Play()
        warningTween:Play()
        loadingBarTween.Completed:Connect(function()
            waterDropFrame:Destroy()
            animateLoadingBar(function()
                print("Loading bar completed")
            end)
        end)
    end)
end

-- Exit animations (cleaner, fade and scale)
local function playExitAnimations(callback)
    print("Starting playExitAnimations")
    local fadeTween = TweenService:Create(mainFrame, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    })

    local contentFadeTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 400, 0, 320),
        Position = UDim2.new(0.5, -200, 0.5, -160)
    })

    local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        Transparency = 1
    })

    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        TextTransparency = 1
    })

    local subtitleTween = TweenService:Create(subtitleLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        TextTransparency = 1
    })

    local discordTween = TweenService:Create(discordLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        TextTransparency = 1
    })

    local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        TextTransparency = 1,
        BackgroundTransparency = 1
    })

    local discordAdTween = TweenService:Create(discordAdLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        TextTransparency = 1
    })

    local loadingBarTween = TweenService:Create(loadingBarContainer, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    })

    local loadingBarFillTween = TweenService:Create(loadingBarFill, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    })

    local percentageTween = TweenService:Create(percentageText, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        TextTransparency = 1
    })

    local warningTween = TweenService:Create(warningLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        TextTransparency = 1
    })

    -- Play all exit animations simultaneously
    fadeTween:Play()
    contentFadeTween:Play()
    contentStrokeTween:Play()
    titleTween:Play()
    subtitleTween:Play()
    discordTween:Play()
    copyButtonTween:Play()
    discordAdTween:Play()
    loadingBarTween:Play()
    loadingBarFillTween:Play()
    percentageTween:Play()
    warningTween:Play()

    contentFadeTween.Completed:Connect(function()
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
            print("ScreenGui destroyed")
        end
        if callback then
            callback()
        end
    end)
end

-- Border pulse (subtle, modern)
local function animatePulse()
    local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(
        2,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Transparency = 0.1
    })
    borderPulseTween:Play()
end

-- Expose loading screen functions
return {
    playEntranceAnimations = playEntranceAnimations,
    playExitAnimations = playExitAnimations,
    animatePulse = animatePulse,
    animateLoadingBar = animateLoadingBar,
    setLoadingText = function(text, color)
        if percentageText and percentageText.Parent then
            percentageText.Text = text or "0%"
            percentageText.TextColor3 = color or Color3.fromRGB(80, 160, 255)
        end
    end,
    isComplete = function()
        return isComplete
    end
}
