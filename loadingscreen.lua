-- Scripts Hub X | Enhanced Blue Loading Screen with Advanced Animations
-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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

-- Enhanced Blue Color Palette
local Colors = {
    Background = Color3.fromRGB(8, 12, 25),           -- Deep midnight blue
    CardBackground = Color3.fromRGB(15, 25, 45),      -- Dark blue-gray
    Primary = Color3.fromRGB(64, 156, 255),           -- Bright blue
    Secondary = Color3.fromRGB(147, 197, 253),        -- Light blue
    Accent = Color3.fromRGB(99, 102, 241),            -- Blue-purple
    Success = Color3.fromRGB(16, 185, 129),           -- Blue-green
    Warning = Color3.fromRGB(245, 158, 11),           -- Warm amber
    Text = Color3.fromRGB(226, 232, 240),             -- Light blue-white
    TextSecondary = Color3.fromRGB(148, 163, 184),    -- Muted blue-gray
    Glow = Color3.fromRGB(59, 130, 246),              -- Electric blue
    Particles = Color3.fromRGB(125, 211, 252)         -- Cyan blue
}

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

-- Main background frame with animated gradient effect
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Colors.Background
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

-- Animated background particles container
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = mainFrame

-- Content frame (glassmorphism effect)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 450, 0, 350)
contentFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
contentFrame.BackgroundColor3 = Colors.CardBackground
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame corner with larger radius
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 16)
contentFrameCorner.Parent = contentFrame

-- Multiple stroke layers for glow effect
local contentStroke1 = Instance.new("UIStroke")
contentStroke1.Color = Colors.Glow
contentStroke1.Thickness = 2
contentStroke1.Transparency = 1
contentStroke1.Parent = contentFrame

local contentStroke2 = Instance.new("UIStroke")
contentStroke2.Color = Colors.Primary
contentStroke2.Thickness = 1
contentStroke2.Transparency = 1
contentStroke2.Parent = contentFrame

-- Animated logo container
local logoContainer = Instance.new("Frame")
logoContainer.Size = UDim2.new(0, 80, 0, 80)
logoContainer.Position = UDim2.new(0.5, -40, 0, 25)
logoContainer.BackgroundColor3 = Colors.Primary
logoContainer.BackgroundTransparency = 1
logoContainer.Parent = contentFrame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 20)
logoCorner.Parent = logoContainer

-- Logo text (X symbol)
local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "X"
logoText.TextColor3 = Colors.Text
logoText.TextScaled = true
logoText.Font = Enum.Font.GothamBold
logoText.TextTransparency = 1
logoText.Parent = logoContainer

-- Title label with typewriter effect
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 115)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = ""
titleLabel.TextColor3 = Colors.Text
titleLabel.TextScaled = true
titleLabel.TextSize = 32
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 0
titleLabel.Parent = contentFrame

-- Subtitle label
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, -40, 0, 25)
subtitleLabel.Position = UDim2.new(0, 20, 0, 165)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Premium Script Hub"
subtitleLabel.TextColor3 = Colors.Secondary
subtitleLabel.TextScaled = true
subtitleLabel.TextSize = 16
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextTransparency = 1
subtitleLabel.Parent = contentFrame

-- Discord container with enhanced styling
local discordContainer = Instance.new("Frame")
discordContainer.Size = UDim2.new(1, -40, 0, 45)
discordContainer.Position = UDim2.new(0, 20, 0, 200)
discordContainer.BackgroundColor3 = Colors.CardBackground
discordContainer.BackgroundTransparency = 1
discordContainer.BorderSizePixel = 0
discordContainer.Parent = contentFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 8)
discordCorner.Parent = discordContainer

local discordStroke = Instance.new("UIStroke")
discordStroke.Color = Colors.Accent
discordStroke.Thickness = 1
discordStroke.Transparency = 1
discordStroke.Parent = discordContainer

-- Discord icon
local discordIcon = Instance.new("TextLabel")
discordIcon.Size = UDim2.new(0, 30, 0, 30)
discordIcon.Position = UDim2.new(0, 10, 0.5, -15)
discordIcon.BackgroundTransparency = 1
discordIcon.Text = "💬"
discordIcon.TextColor3 = Colors.Primary
discordIcon.TextScaled = true
discordIcon.Font = Enum.Font.Gotham
discordIcon.TextTransparency = 1
discordIcon.Parent = discordContainer

-- Discord label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.55, -50, 1, -10)
discordLabel.Position = UDim2.new(0, 45, 0, 5)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Colors.Primary
discordLabel.TextScaled = true
discordLabel.TextSize = 14
discordLabel.Font = Enum.Font.GothamBold
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.TextTransparency = 1
discordLabel.Parent = discordContainer

-- Enhanced copy button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 90, 0, 32)
copyButton.Position = UDim2.new(1, -100, 0.5, -16)
copyButton.BackgroundColor3 = Colors.Primary
copyButton.BackgroundTransparency = 1
copyButton.Text = "Copy"
copyButton.TextColor3 = Colors.Text
copyButton.TextScaled = true
copyButton.TextSize = 12
copyButton.Font = Enum.Font.GothamBold
copyButton.TextTransparency = 1
copyButton.Parent = discordContainer

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 8)
copyButtonCorner.Parent = copyButton

-- Loading section
local loadingSection = Instance.new("Frame")
loadingSection.Size = UDim2.new(1, -40, 0, 80)
loadingSection.Position = UDim2.new(0, 20, 0, 255)
loadingSection.BackgroundTransparency = 1
loadingSection.Parent = contentFrame

-- Animated loading text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0, 25)
loadingText.Position = UDim2.new(0, 0, 0, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Initializing Scripts Hub X..."
loadingText.TextColor3 = Colors.TextSecondary
loadingText.TextScaled = true
loadingText.TextSize = 14
loadingText.Font = Enum.Font.Gotham
loadingText.TextTransparency = 1
loadingText.Parent = loadingSection

-- Modern progress bar container
local progressContainer = Instance.new("Frame")
progressContainer.Size = UDim2.new(1, 0, 0, 6)
progressContainer.Position = UDim2.new(0, 0, 0, 35)
progressContainer.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
progressContainer.BackgroundTransparency = 1
progressContainer.BorderSizePixel = 0
progressContainer.Parent = loadingSection

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 3)
progressCorner.Parent = progressContainer

-- Animated progress fill
local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Colors.Primary
progressFill.BackgroundTransparency = 1
progressFill.BorderSizePixel = 0
progressFill.Parent = progressContainer

local progressFillCorner = Instance.new("UICorner")
progressFillCorner.CornerRadius = UDim.new(0, 3)
progressFillCorner.Parent = progressFill

-- Progress glow effect
local progressGlow = Instance.new("Frame")
progressGlow.Size = UDim2.new(0, 20, 1, 4)
progressGlow.Position = UDim2.new(0, -10, 0, -2)
progressGlow.BackgroundColor3 = Colors.Glow
progressGlow.BackgroundTransparency = 1
progressGlow.BorderSizePixel = 0
progressGlow.Parent = progressFill

local progressGlowCorner = Instance.new("UICorner")
progressGlowCorner.CornerRadius = UDim.new(0, 5)
progressGlowCorner.Parent = progressGlow

-- Percentage display
local percentageLabel = Instance.new("TextLabel")
percentageLabel.Size = UDim2.new(1, 0, 0, 20)
percentageLabel.Position = UDim2.new(0, 0, 0, 50)
percentageLabel.BackgroundTransparency = 1
percentageLabel.Text = "0%"
percentageLabel.TextColor3 = Colors.Primary
percentageLabel.TextScaled = true
percentageLabel.TextSize = 16
percentageLabel.Font = Enum.Font.GothamBold
percentageLabel.TextTransparency = 1
percentageLabel.Parent = loadingSection

-- Enhanced particle system
local particleConnections = {}

local function createAdvancedParticle()
    local particle = Instance.new("Frame")
    local size = math.random(4, 12)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.BackgroundColor3 = Colors.Particles
    particle.BackgroundTransparency = math.random(70, 90) / 100
    particle.BorderSizePixel = 0
    particle.ZIndex = -1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = particle
    particle.Parent = particleContainer

    -- Random starting position
    local startX = math.random(-10, 110) / 100
    local startY = math.random(-10, 110) / 100
    particle.Position = UDim2.new(startX, 0, startY, 0)

    -- Create floating motion
    local endX = startX + (math.random(-30, 30) / 100)
    local endY = startY + (math.random(-30, 30) / 100)
    
    local moveTween = TweenService:Create(particle, TweenInfo.new(
        math.random(8, 15),
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut
    ), {
        Position = UDim2.new(endX, 0, endY, 0),
        BackgroundTransparency = 1
    })
    
    -- Add pulse effect
    local pulseTween = TweenService:Create(particle, TweenInfo.new(
        math.random(2, 4),
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Size = UDim2.new(0, size * 1.5, 0, size * 1.5)
    })
    
    moveTween:Play()
    pulseTween:Play()
    
    moveTween.Completed:Connect(function()
        pulseTween:Cancel()
        particle:Destroy()
    end)
end

-- Continuous particle spawning
local function startParticleSystem()
    local connection = RunService.Heartbeat:Connect(function()
        if math.random() < 0.1 then -- 10% chance each frame
            createAdvancedParticle()
        end
    end)
    table.insert(particleConnections, connection)
end

-- Typewriter effect for title
local function typeWriterEffect(label, text, speed)
    label.Text = ""
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        wait(speed or 0.05)
    end
end

-- Enhanced loading animation with stages
local loadingStages = {
    "Initializing Scripts Hub X...",
    "Loading premium features...",
    "Connecting to secure servers...",
    "Finalizing setup..."
}

local function animateEnhancedLoadingBar(callback)
    print("Starting enhanced loading bar animation")
    
    local startTime = tick()
    local currentStage = 1
    local stageInterval = 3 / #loadingStages
    
    -- Start progress animation
    local progressTween = TweenService:Create(progressFill, TweenInfo.new(
        3,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0
    })
    
    -- Animate progress container
    local containerTween = TweenService:Create(progressContainer, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {BackgroundTransparency = 0.3})
    
    -- Glow animation
    local glowTween = TweenService:Create(progressGlow, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {BackgroundTransparency = 0.4})
    
    containerTween:Play()
    progressTween:Play()
    glowTween:Play()
    
    -- Update percentage and stages
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local percentage = math.min((elapsed / 3) * 100, 100)
        
        percentageLabel.Text = string.format("%d%%", math.floor(percentage))
        
        -- Update loading stage
        local newStage = math.min(math.floor(elapsed / stageInterval) + 1, #loadingStages)
        if newStage ~= currentStage and newStage <= #loadingStages then
            currentStage = newStage
            loadingText.Text = loadingStages[currentStage]
            
            -- Flash effect on stage change
            local flashTween = TweenService:Create(loadingText, TweenInfo.new(
                0.2,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut,
                1,
                true
            ), {TextTransparency = 0.3})
            flashTween:Play()
        end
        
        if percentage >= 100 then
            connection:Disconnect()
            percentageLabel.TextColor3 = Colors.Success
            loadingText.Text = "Ready! Launching Scripts Hub X..."
            loadingText.TextColor3 = Colors.Success
            
            -- Success pulse effect
            local successTween = TweenService:Create(progressFill, TweenInfo.new(
                0.3,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut,
                2,
                true
            ), {BackgroundColor3 = Colors.Success})
            successTween:Play()
            
            isComplete = true
            wait(0.8)
            if callback then callback() end
        end
    end)
end

-- Copy button enhanced functionality
copyButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "Copied!"
        copyButton.BackgroundColor3 = Colors.Success
        
        -- Success animation
        local successTween = TweenService:Create(copyButton, TweenInfo.new(
            0.2,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ), {Size = UDim2.new(0, 95, 0, 34)})
        successTween:Play()
        
        wait(1.5)
        
        local resetTween = TweenService:Create(copyButton, TweenInfo.new(
            0.2,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ), {Size = UDim2.new(0, 90, 0, 32)})
        resetTween:Play()
        
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Colors.Primary
    end)
    if not success then
        warn("Copy button failed: " .. tostring(err))
    end
end)

-- Enhanced entrance animations
local function playEnhancedEntranceAnimations()
    print("Starting enhanced entrance animations")
    
    -- Background fade in
    local bgTween = TweenService:Create(mainFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {BackgroundTransparency = 0})
    
    -- Content frame slide up with scale
    contentFrame.Position = UDim2.new(0.5, -225, 0.5, -125)
    contentFrame.Size = UDim2.new(0, 400, 0, 300)
    
    local contentTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        Position = UDim2.new(0.5, -225, 0.5, -175),
        Size = UDim2.new(0, 450, 0, 350),
        BackgroundTransparency = 0.1
    })
    
    -- Glow effects
    local glow1Tween = TweenService:Create(contentStroke1, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {Transparency = 0.3})
    
    local glow2Tween = TweenService:Create(contentStroke2, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {Transparency = 0.5})
    
    -- Logo animation
    local logoTween = TweenService:Create(logoContainer, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out,
        0,
        false,
        0.3
    ), {BackgroundTransparency = 0.2})
    
    local logoTextTween = TweenService:Create(logoText, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out,
        0,
        false,
        0.5
    ), {TextTransparency = 0})
    
    -- Start animations
    bgTween:Play()
    contentTween:Play()
    glow1Tween:Play()
    glow2Tween:Play()
    logoTween:Play()
    logoTextTween:Play()
    
    -- Typewriter effect for title
    wait(0.4)
    spawn(function()
        typeWriterEffect(titleLabel, "Scripts Hub X", 0.08)
    end)
    
    -- Fade in other elements
    wait(0.3)
    local subtitleTween = TweenService:Create(subtitleLabel, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {TextTransparency = 0})
    subtitleTween:Play()
    
    wait(0.2)
    local discordTweens = {
        TweenService:Create(discordContainer, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}),
        TweenService:Create(discordStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.4}),
        TweenService:Create(discordIcon, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}),
        TweenService:Create(discordLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}),
        TweenService:Create(copyButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0, BackgroundTransparency = 0})
    }
    
    for _, tween in ipairs(discordTweens) do
        tween:Play()
    end
    
    wait(0.3)
    local loadingTweens = {
        TweenService:Create(loadingText, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}),
        TweenService:Create(percentageLabel, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
    }
    
    for _, tween in ipairs(loadingTweens) do
        tween:Play()
    end
    
    wait(0.5)
    animateEnhancedLoadingBar(function()
        playEnhancedExitAnimations()
    end)
end

-- Enhanced exit animations
local function playEnhancedExitAnimations()
    print("Starting enhanced exit animations")
    
    -- Stop particles
    for _, connection in ipairs(particleConnections) do
        connection:Disconnect()
    end
    
    -- Scale down and fade
    local exitTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In
    ), {
        Size = UDim2.new(0, 350, 0, 250),
        Position = UDim2.new(0.5, -175, 0.5, -125),
        BackgroundTransparency = 1
    })
    
    local fadeTween = TweenService:Create(mainFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.In
    ), {BackgroundTransparency = 1})
    
    exitTween:Play()
    fadeTween:Play()
    
    exitTween.Completed:Connect(function()
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
            print("Enhanced loading screen completed")
        end
    end)
end

-- Pulsing glow animation
local function startGlowAnimation()
    local glow1Pulse = TweenService:Create(contentStroke1, TweenInfo.new(
        2.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {Transparency = 0.1, Thickness = 3})
    
    local glow2Pulse = TweenService:Create(contentStroke2, TweenInfo.new(
        1.8,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {Transparency = 0.2})
    
    glow1Pulse:Play()
    glow2Pulse:Play()
end

-- Initialize the enhanced loading screen
local function initializeEnhanced()
    print("Initializing enhanced loading screen")
    startParticleSystem()
    startGlowAnimation()
    playEnhancedEntranceAnimations()
end

-- Return enhanced loading screen functions
return {
    playEntranceAnimations = playEnhancedEntranceAnimations,
    playExitAnimations = playEnhancedExitAnimations,
    animateLoadingBar = animateEnhancedLoadingBar,
    setLoadingText = function(text, color)
        if loadingText and loadingText.Parent then
            loadingText.Text = text or "Initializing..."
            loadingText.TextColor3 = color or Colors.TextSecondary
        end
    end,
    isComplete = function()
        return isComplete
    end,
    initialize = initializeEnhanced
}
