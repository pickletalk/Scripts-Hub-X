-- Scripts Hub X | Enhanced Loading Screen with Debugging
-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Initialize player and PlayerGui
local success, player = pcall(function()
    return Players.LocalPlayer
end)
if not success or not player then
    warn("Failed to get LocalPlayer: " .. tostring(player))
    return
end

local playerGui = player:WaitForChild("PlayerGui", 5)
if not playerGui then
    warn("PlayerGui not found after 5 seconds")
    return
end
print("Script started, PlayerGui found")

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsHubXLoading"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Enabled = true
screenGui.Parent = playerGui
print("ScreenGui created and parented")

-- Completion flag
local isComplete = false

-- Main background frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

-- Content frame (cleaner, centered)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 350, 0, 280)
contentFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame corner
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 8)
contentFrameCorner.Parent = contentFrame

-- Content frame glow
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(80, 160, 255)
contentStroke.Thickness = 1.5
contentStroke.Transparency = 1
contentStroke.Parent = contentFrame

-- Title label
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

-- Subtitle label
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

-- Discord container
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

-- Discord label
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

-- Copy button
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

-- Warning label
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

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "Copied!"
        copyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
        wait(1)
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    end)
    if not success then
        warn("Copy button failed: " .. tostring(err))
    end
end)

-- Animate loading bar (3-second realistic fill)
local function animateLoadingBar(callback)
    print("Starting animateLoadingBar")
    if not loadingBarFill or not loadingBarFill.Parent then
        warn("loadingBarFill is invalid or not parented")
        if callback then callback() end
        return
    end
    local success, err = pcall(function()
        local loadingTween = TweenService:Create(loadingBarFill, TweenInfo.new(
            3,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.In
        ), {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
        local percentageTween = TweenService:Create(percentageText, TweenInfo.new(
            3,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.In
        ), {TextTransparency = 0})
        local startTime = tick()
        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            local percentage = math.min((elapsed / 3) * 100, 100)
            percentageText.Text = string.format("%d%%", math.floor(percentage))
            if percentage >= 100 then
                connection:Disconnect()
                percentageText.TextColor3 = Color3.fromRGB(0, 200, 0)
                isComplete = true
                wait(0.5)
                if callback then callback() end
            end
        end)
        loadingTween:Play()
        percentageTween:Play()
    end)
    if not success then
        warn("Loading bar animation failed: " .. tostring(err))
        percentageText.Text = "100%"
        percentageText.TextColor3 = Color3.fromRGB(0, 200, 0)
        isComplete = true
        if callback then callback() end
    end
end

-- Entrance animations (simplified, no water drop)
local function playEntranceAnimations()
    print("Starting playEntranceAnimations")
    local success, err = pcall(function()
        -- Initialize hidden states
        mainFrame.BackgroundTransparency = 1
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
        -- Content reveal tweens
        local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ), {BackgroundTransparency = 0.7})
        local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {BackgroundTransparency = 0.3})
        local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {Transparency = 0.2})
        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {TextTransparency = 0})
        local subtitleTween = TweenService:Create(subtitleLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {TextTransparency = 0})
        local discordTween = TweenService:Create(discordLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {TextTransparency = 0})
        local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {TextTransparency = 0, BackgroundTransparency = 0})
        local discordAdTween = TweenService:Create(discordAdLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {TextTransparency = 0})
        local loadingBarTween = TweenService:Create(loadingBarContainer, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {BackgroundTransparency = 0.5})
        local warningTween = TweenService:Create(warningLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {TextTransparency = 0})
        -- Play animations sequentially
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
            animateLoadingBar(function()
                print("Loading bar completed, starting exit animations")
                playExitAnimations()
            end)
        end)
    end)
    if not success then
        warn("Entrance animations failed: " .. tostring(err))
        -- Fallback: Show UI without animations
        mainFrame.BackgroundTransparency = 0.7
        contentFrame.BackgroundTransparency = 0.3
        contentStroke.Transparency = 0.2
        titleLabel.TextTransparency = 0
        subtitleLabel.TextTransparency = 0
        discordLabel.TextTransparency = 0
        copyButton.TextTransparency = 0
        copyButton.BackgroundTransparency = 0
        discordAdLabel.TextTransparency = 0
        loadingBarContainer.BackgroundTransparency = 0.5
        percentageText.TextTransparency = 0
        warningLabel.TextTransparency = 0
        animateLoadingBar(function()
            playExitAnimations()
        end)
    end
end

-- Exit animations (cleaner, simultaneous)
local function playExitAnimations(callback)
    print("Starting playExitAnimations")
    local success, err = pcall(function()
        local fadeTween = TweenService:Create(mainFrame, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {BackgroundTransparency = 1})
        local contentFadeTween = TweenService:Create(contentFrame, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {BackgroundTransparency = 1, Size = UDim2.new(0, 400, 0, 320), Position = UDim2.new(0.5, -200, 0.5, -160)})
        local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {Transparency = 1})
        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {TextTransparency = 1})
        local subtitleTween = TweenService:Create(subtitleLabel, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {TextTransparency = 1})
        local discordTween = TweenService:Create(discordLabel, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {TextTransparency = 1})
        local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {TextTransparency = 1, BackgroundTransparency = 1})
        local discordAdTween = TweenService:Create(discordAdLabel, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {TextTransparency = 1})
        local loadingBarTween = TweenService:Create(loadingBarContainer, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {BackgroundTransparency = 1})
        local loadingBarFillTween = TweenService:Create(loadingBarFill, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {BackgroundTransparency = 1})
        local percentageTween = TweenService:Create(percentageText, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {TextTransparency = 1})
        local warningTween = TweenService:Create(warningLabel, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {TextTransparency = 1})
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
            if callback then callback() end
        end)
    end)
    if not success then
        warn("Exit animations failed: " .. tostring(err))
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
            print("ScreenGui destroyed (fallback)")
        end
        if callback then callback() end
    end
end

-- Border pulse
local function animatePulse()
    local success, err = pcall(function()
        local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(
            2,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Transparency = 0.1})
        borderPulseTween:Play()
    end)
    if not success then
        warn("Pulse animation failed: " .. tostring(err))
    end
end

-- Start the loading screen
local function initialize()
    print("Initializing loading screen")
    local success, err = pcall(function()
        playEntranceAnimations()
        animatePulse()
    end)
    if not success then
        warn("Initialization failed: " .. tostring(err))
        mainFrame.BackgroundTransparency = 0.7
        contentFrame.BackgroundTransparency = 0.3
        contentStroke.Transparency = 0.2
        titleLabel.TextTransparency = 0
        subtitleLabel.TextTransparency = 0
        discordLabel.TextTransparency = 0
        copyButton.TextTransparency = 0
        copyButton.BackgroundTransparency = 0
        discordAdLabel.TextTransparency = 0
        loadingBarContainer.BackgroundTransparency = 0.5
        percentageText.TextTransparency = 0
        warningLabel.TextTransparency = 0
        animateLoadingBar(function()
            playExitAnimations()
        end)
    end
end

-- Expose loading screen functions
return {
    playEntranceAnimations = playEntranceAnimations,
    playExitAnimations = playExitAnimations,
    animatePulse = animatePulse,
    animateLoadingBar = animateLoadingBar,
    setLoadingText = function(text, color)
        local success, err = pcall(function()
            if percentageText and percentageText.Parent then
                percentageText.Text = text or "0%"
                percentageText.TextColor3 = color or Color3.fromRGB(80, 160, 255)
            end
        end)
        if not success then
            warn("setLoadingText failed: " .. tostring(err))
        end
    end,
    isComplete = function()
        return isComplete
    end,
    initialize = initialize
}
