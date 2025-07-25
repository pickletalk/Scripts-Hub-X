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
local isInitialized = false

-- Main background frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 28, 35) -- Darker, desaturated blue
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

-- Content frame (cleaner, centered)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 450, 0, 320) -- Slightly larger
contentFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 50, 65) -- Deeper blue
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame corner
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 12) -- Smoother corners
contentFrameCorner.Parent = contentFrame

-- Content frame glow
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(80, 180, 220) -- Brighter, more vibrant blue
contentStroke.Thickness = 2
contentStroke.Transparency = 1
contentStroke.Parent = contentFrame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X"
titleLabel.TextColor3 = Color3.fromRGB(210, 220, 240) -- Softer white
titleLabel.TextScaled = true
titleLabel.TextSize = 32
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1
titleLabel.Parent = contentFrame

-- Subtitle label
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, -40, 0, 30)
subtitleLabel.Position = UDim2.new(0, 20, 0, 75)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Official"
subtitleLabel.TextColor3 = Color3.fromRGB(160, 170, 190) -- Lighter gray
subtitleLabel.TextScaled = true
subtitleLabel.TextSize = 18
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextTransparency = 1
subtitleLabel.Parent = contentFrame

-- Discord container
local discordContainer = Instance.new("Frame")
discordContainer.Size = UDim2.new(1, -40, 0, 40)
discordContainer.Position = UDim2.new(0, 20, 0, 120)
discordContainer.BackgroundColor3 = Color3.fromRGB(30, 35, 45) -- Darker container
discordContainer.BackgroundTransparency = 1
discordContainer.BorderSizePixel = 0
discordContainer.Parent = contentFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 8)
discordCorner.Parent = discordContainer

-- Discord label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.65, -10, 1, -6)
discordLabel.Position = UDim2.new(0, 15, 0, 3)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(100, 180, 255) -- Vibrant blue
discordLabel.TextScaled = true
discordLabel.TextSize = 14
discordLabel.Font = Enum.Font.Gotham
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.TextTransparency = 1
discordLabel.Parent = discordContainer

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 90, 0, 30)
copyButton.Position = UDim2.new(0.7, 0, 0, 5)
copyButton.BackgroundColor3 = Color3.fromRGB(80, 190, 230) -- Teal accent
copyButton.BackgroundTransparency = 1
copyButton.Text = "Copy"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextScaled = true
copyButton.TextSize = 14
copyButton.Font = Enum.Font.GothamBold
copyButton.TextTransparency = 1
copyButton.Parent = discordContainer

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 6)
copyButtonCorner.Parent = copyButton

-- Discord advertisement label
local discordAdLabel = Instance.new("TextLabel")
discordAdLabel.Size = UDim2.new(1, -40, 0, 30)
discordAdLabel.Position = UDim2.new(0, 20, 0, 165)
discordAdLabel.BackgroundTransparency = 1
discordAdLabel.Text = "Join our Discord for the latest updates and scripts!"
discordAdLabel.TextColor3 = Color3.fromRGB(120, 190, 255) -- Softer blue
discordAdLabel.TextScaled = true
discordAdLabel.TextSize = 14
discordAdLabel.Font = Enum.Font.Gotham
discordAdLabel.TextTransparency = 1
discordAdLabel.TextWrapped = true
discordAdLabel.Parent = contentFrame

-- Loading bar container
local loadingBarContainer = Instance.new("Frame")
loadingBarContainer.Size = UDim2.new(1, -40, 0, 12)
loadingBarContainer.Position = UDim2.new(0, 20, 0, 210)
loadingBarContainer.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
loadingBarContainer.BackgroundTransparency = 1
loadingBarContainer.BorderSizePixel = 0
loadingBarContainer.Parent = contentFrame

local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(0, 6)
loadingBarCorner.Parent = loadingBarContainer

-- Loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(80, 180, 220) -- Vibrant blue
loadingBarFill.BackgroundTransparency = 1
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarContainer

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 6)
loadingBarFillCorner.Parent = loadingBarFill

-- Loading bar glow
local loadingBarGlow = Instance.new("UIStroke")
loadingBarGlow.Color = Color3.fromRGB(180, 230, 255) -- Bright glow
loadingBarGlow.Thickness = 3
loadingBarGlow.Transparency = 0.6
loadingBarGlow.Parent = loadingBarFill

-- Percentage text
local percentageText = Instance.new("TextLabel")
percentageText.Size = UDim2.new(1, -40, 0, 20)
percentageText.Position = UDim2.new(0, 20, 0, 230)
percentageText.BackgroundTransparency = 1
percentageText.Text = "0%"
percentageText.TextColor3 = Color3.fromRGB(180, 220, 240) -- Softer white
percentageText.TextScaled = true
percentageText.TextSize = 16
percentageText.Font = Enum.Font.Gotham
percentageText.TextTransparency = 1
percentageText.Parent = contentFrame

-- Warning label
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -40, 0, 30)
warningLabel.Position = UDim2.new(0, 20, 0, 265)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "Warning: For your safety, only use scripts from trusted developers."
warningLabel.TextColor3 = Color3.fromRGB(220, 120, 120) -- Slightly more vibrant red
warningLabel.TextScaled = true
warningLabel.TextSize = 12
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextTransparency = 1
warningLabel.TextWrapped = true
warningLabel.Parent = contentFrame

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "Copied!"
        copyButton.BackgroundColor3 = Color3.fromRGB(60, 160, 210) -- Darker teal on click
        wait(1.5)
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Color3.fromRGB(80, 190, 230)
    end)
    if not success then
        warn("Copy button failed: " .. tostring(err))
    end
end)

-- Particle system
local function spawnParticle()
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, 12, 0, 12)
    particle.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    particle.BackgroundTransparency = 0.7
    particle.BorderSizePixel = 0
    particle.ZIndex = -1
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = particle
    particle.Parent = mainFrame

    local x = math.random()
    local y = math.random()
    particle.Position = UDim2.new(x, 0, y, 0)

    local directionX = math.random(-60, 60)
    local directionY = math.random(-60, 60)
    local targetPosition = UDim2.new(x, directionX, y, directionY)

    local tween = TweenService:Create(particle, TweenInfo.new(
        math.random(4, 6),
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ), {Position = targetPosition, BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        particle:Destroy()
    end)
end

local function spawnInitialParticles(num)
    for i = 1, num do
        spawnParticle()
    end
end

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
            Enum.EasingStyle.Quint, -- More energetic easing
            Enum.EasingDirection.Out
        ), {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
        local percentageTween = TweenService:Create(percentageText, TweenInfo.new(
            3,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ), {TextTransparency = 0})
        local glowTween = TweenService:Create(loadingBarGlow, TweenInfo.new(
            1.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Transparency = 0.3, Thickness = 4})
        glowTween:Play()
        local startTime = tick()
        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            local percentage = math.min((elapsed / 3) * 100, 100)
            percentageText.Text = string.format("%d%%", math.floor(percentage))
            if percentage >= 100 then
                connection:Disconnect()
                percentageText.TextColor3 = Color3.fromRGB(100, 220, 180) -- Greenish-teal for complete
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
        percentageText.TextColor3 = Color3.fromRGB(100, 220, 180)
        isComplete = true
        if callback then callback() end
    end
end

-- Entrance animations (enhanced with slight movement)
local function playEntranceAnimations(callback)
    print("Starting playEntranceAnimations")
    local success, err = pcall(function()
        -- Initialize hidden states
        mainFrame.BackgroundTransparency = 1
        contentFrame.BackgroundTransparency = 1
        contentFrame.Position = UDim2.new(0.5, -225, 0.5, -150) -- Start slightly lower
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

        -- Staggered animation timings
        local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.6})
        local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2, Position = UDim2.new(0.5, -225, 0.5, -160)})
        local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.3})
        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})
        local subtitleTween = TweenService:Create(subtitleLabel, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})
        local discordTween = TweenService:Create(discordLabel, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})
        local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0, BackgroundTransparency = 0})
        local discordAdTween = TweenService:Create(discordAdLabel, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})
        local loadingBarTween = TweenService:Create(loadingBarContainer, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
        local warningTween = TweenService:Create(warningLabel, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})

        -- Play animations with delays
        mainFrameTween:Play()
        wait(0.1)
        contentFrameTween:Play()
        contentStrokeTween:Play()
        wait(0.15)
        titleTween:Play()
        wait(0.05)
        subtitleTween:Play()
        wait(0.1)
        discordTween:Play()
        copyButtonTween:Play()
        wait(0.05)
        discordAdTween:Play()
        wait(0.1)
        loadingBarTween:Play()
        warningTween:Play()
        loadingBarTween.Completed:Connect(function()
            if callback then callback() end
        end)
    end)
    if not success then
        warn("Entrance animations failed: " .. tostring(err))
        -- Fallback to ensure UI is visible
        mainFrame.BackgroundTransparency = 0.6
        contentFrame.BackgroundTransparency = 0.2
        contentStroke.Transparency = 0.3
        titleLabel.TextTransparency = 0
        subtitleLabel.TextTransparency = 0
        discordLabel.TextTransparency = 0
        copyButton.TextTransparency = 0
        copyButton.BackgroundTransparency = 0
        discordAdLabel.TextTransparency = 0
        loadingBarContainer.BackgroundTransparency = 0.5
        percentageText.TextTransparency = 0
        warningLabel.TextTransparency = 0
        if callback then callback() end
    end
end

-- Exit animations (cleaner, simultaneous)
local function playExitAnimations(callback)
    print("Starting playExitAnimations")
    local success, err = pcall(function()
        local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        local fadeTween = TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 1})
        local contentFadeTween = TweenService:Create(contentFrame, tweenInfo, {BackgroundTransparency = 1, Position = UDim2.new(0.5, -225, 0.5, -150)})

        -- Play all fades simultaneously
        fadeTween:Play()
        contentFadeTween:Play()
        TweenService:Create(contentStroke, tweenInfo, {Transparency = 1}):Play()
        TweenService:Create(titleLabel, tweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(subtitleLabel, tweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(discordLabel, tweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(copyButton, tweenInfo, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        TweenService:Create(discordAdLabel, tweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(loadingBarContainer, tweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(loadingBarFill, tweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(percentageText, tweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(warningLabel, tweenInfo, {TextTransparency = 1}):Play()
        
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
            2.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Transparency = 0.1, Thickness = 2.5})
        borderPulseTween:Play()
    end)
    if not success then
        warn("Pulse animation failed: " .. tostring(err))
    end
end

-- Start the loading screen with automatic progression
local function initialize(callback)
    print("Initializing loading screen")
    if isInitialized then
        warn("Loading screen already initialized")
        return
    end
    isInitialized = true
    
    local success, err = pcall(function()
        spawnInitialParticles(8) -- More particles for a richer effect
        animatePulse()
        
        -- Start entrance animations and then automatically start loading bar
        playEntranceAnimations(function()
            print("Entrance animations completed, starting loading bar")
            animateLoadingBar(function()
                print("Loading bar completed, starting exit animations")
                playExitAnimations(callback)
            end)
        end)
    end)
    if not success then
        warn("Initialization failed: " .. tostring(err))
        -- Fallback initialization
        mainFrame.BackgroundTransparency = 0.6
        contentFrame.BackgroundTransparency = 0.2
        contentStroke.Transparency = 0.3
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
            playExitAnimations(callback)
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
                percentageText.TextColor3 = color or Color3.fromRGB(180, 220, 240)
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
