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

-- Main background frame with animated gradient
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

-- Create animated background gradient
local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 28, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 45, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 20, 30))
}
backgroundGradient.Rotation = 45
backgroundGradient.Parent = mainFrame

-- Content frame (enhanced with glow)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 480, 0, 360)
contentFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame gradient
local contentGradient = Instance.new("UIGradient")
contentGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 50, 65)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 40, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 25, 35))
}
contentGradient.Rotation = 135
contentGradient.Parent = contentFrame

-- Content frame corner with larger radius
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 16)
contentFrameCorner.Parent = contentFrame

-- Enhanced content frame glow with animation
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(100, 200, 255)
contentStroke.Thickness = 3
contentStroke.Transparency = 1
contentStroke.Parent = contentFrame

-- Secondary glow effect
local contentGlow = Instance.new("UIStroke")
contentGlow.Color = Color3.fromRGB(150, 220, 255)
contentGlow.Thickness = 1
contentGlow.Transparency = 1
contentGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
contentGlow.Parent = contentFrame

-- Animated logo/icon area
local logoContainer = Instance.new("Frame")
logoContainer.Size = UDim2.new(0, 80, 0, 80)
logoContainer.Position = UDim2.new(0.5, -40, 0, 15)
logoContainer.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
logoContainer.BackgroundTransparency = 1
logoContainer.Parent = contentFrame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 12)
logoCorner.Parent = logoContainer

local logoGradient = Instance.new("UIGradient")
logoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 180, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 160, 240)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 140, 220))
}
logoGradient.Rotation = 45
logoGradient.Parent = logoContainer

-- Logo text
local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "SHX"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextScaled = true
logoText.TextSize = 32
logoText.Font = Enum.Font.GothamBold
logoText.TextTransparency = 1
logoText.Parent = logoContainer

-- Enhanced title label with gradient
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 60)
titleLabel.Position = UDim2.new(0, 20, 0, 105)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.TextSize = 36
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1
titleLabel.Parent = contentFrame

-- Title gradient effect
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 200, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 200, 255))
}
titleGradient.Rotation = 0
titleGradient.Parent = titleLabel

-- Enhanced subtitle with typewriter effect
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, -40, 0, 25)
subtitleLabel.Position = UDim2.new(0, 20, 0, 170)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = ""
subtitleLabel.TextColor3 = Color3.fromRGB(180, 200, 220)
subtitleLabel.TextScaled = true
subtitleLabel.TextSize = 16
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextTransparency = 1
subtitleLabel.Parent = contentFrame

-- Discord container with enhanced styling
local discordContainer = Instance.new("Frame")
discordContainer.Size = UDim2.new(1, -40, 0, 45)
discordContainer.Position = UDim2.new(0, 20, 0, 205)
discordContainer.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
discordContainer.BackgroundTransparency = 1
discordContainer.BorderSizePixel = 0
discordContainer.Parent = contentFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 10)
discordCorner.Parent = discordContainer

local discordGradient = Instance.new("UIGradient")
discordGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 45, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 30, 40))
}
discordGradient.Rotation = 90
discordGradient.Parent = discordContainer

-- Discord container glow
local discordStroke = Instance.new("UIStroke")
discordStroke.Color = Color3.fromRGB(88, 101, 242)
discordStroke.Thickness = 1
discordStroke.Transparency = 1
discordStroke.Parent = discordContainer

-- Discord label with enhanced styling
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.65, -15, 1, -8)
discordLabel.Position = UDim2.new(0, 15, 0, 4)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
discordLabel.TextScaled = true
discordLabel.TextSize = 14
discordLabel.Font = Enum.Font.GothamMedium
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.TextTransparency = 1
discordLabel.Parent = discordContainer

-- Enhanced copy button with hover effects
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 100, 0, 35)
copyButton.Position = UDim2.new(0.7, -5, 0, 5)
copyButton.BackgroundColor3 = Color3.fromRGB(80, 190, 230)
copyButton.BackgroundTransparency = 1
copyButton.Text = "Copy"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextScaled = true
copyButton.TextSize = 14
copyButton.Font = Enum.Font.GothamBold
copyButton.TextTransparency = 1
copyButton.Parent = discordContainer

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 8)
copyButtonCorner.Parent = copyButton

local copyButtonGradient = Instance.new("UIGradient")
copyButtonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 160, 220))
}
copyButtonGradient.Rotation = 45
copyButtonGradient.Parent = copyButton

-- Enhanced loading bar container
local loadingBarContainer = Instance.new("Frame")
loadingBarContainer.Size = UDim2.new(1, -40, 0, 16)
loadingBarContainer.Position = UDim2.new(0, 20, 0, 270)
loadingBarContainer.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
loadingBarContainer.BackgroundTransparency = 1
loadingBarContainer.BorderSizePixel = 0
loadingBarContainer.Parent = contentFrame

local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(0, 8)
loadingBarCorner.Parent = loadingBarContainer

-- Loading bar background gradient
local loadingBarBgGradient = Instance.new("UIGradient")
loadingBarBgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 40, 50))
}
loadingBarBgGradient.Rotation = 90
loadingBarBgGradient.Parent = loadingBarContainer

-- Enhanced loading bar fill with animated gradient
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(80, 180, 220)
loadingBarFill.BackgroundTransparency = 1
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarContainer

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 8)
loadingBarFillCorner.Parent = loadingBarFill

-- Animated loading bar gradient
local loadingBarGradient = Instance.new("UIGradient")
loadingBarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 200, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 180, 240)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 160, 220))
}
loadingBarGradient.Rotation = 0
loadingBarGradient.Parent = loadingBarFill

-- Enhanced loading bar glow with multiple layers
local loadingBarGlow = Instance.new("UIStroke")
loadingBarGlow.Color = Color3.fromRGB(150, 220, 255)
loadingBarGlow.Thickness = 4
loadingBarGlow.Transparency = 1
loadingBarGlow.Parent = loadingBarFill

-- Secondary glow
local loadingBarGlow2 = Instance.new("UIStroke")
loadingBarGlow2.Color = Color3.fromRGB(200, 240, 255)
loadingBarGlow2.Thickness = 2
loadingBarGlow2.Transparency = 1
loadingBarGlow2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
loadingBarGlow2.Parent = loadingBarFill

-- Enhanced percentage text
local percentageText = Instance.new("TextLabel")
percentageText.Size = UDim2.new(1, -40, 0, 25)
percentageText.Position = UDim2.new(0, 20, 0, 295)
percentageText.BackgroundTransparency = 1
percentageText.Text = "0%"
percentageText.TextColor3 = Color3.fromRGB(200, 220, 240)
percentageText.TextScaled = true
percentageText.TextSize = 18
percentageText.Font = Enum.Font.GothamBold
percentageText.TextTransparency = 1
percentageText.Parent = contentFrame

-- Status text for different loading phases
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -40, 0, 20)
statusText.Position = UDim2.new(0, 20, 0, 325)
statusText.BackgroundTransparency = 1
statusText.Text = "Initializing..."
statusText.TextColor3 = Color3.fromRGB(140, 160, 180)
statusText.TextScaled = true
statusText.TextSize = 12
statusText.Font = Enum.Font.Gotham
statusText.TextTransparency = 1
statusText.Parent = contentFrame

-- Enhanced particle system with multiple types
local particles = {}
local particleTypes = {
    {size = 8, color = Color3.fromRGB(120, 200, 255), speed = 4},
    {size = 6, color = Color3.fromRGB(150, 220, 255), speed = 6},
    {size = 4, color = Color3.fromRGB(180, 240, 255), speed = 8},
    {size = 10, color = Color3.fromRGB(100, 180, 240), speed = 3}
}

local function spawnParticle(particleType)
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, particleType.size, 0, particleType.size)
    particle.BackgroundColor3 = particleType.color
    particle.BackgroundTransparency = 0.4
    particle.BorderSizePixel = 0
    particle.ZIndex = -1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = particle
    particle.Parent = mainFrame

    local x = math.random() * 0.8 + 0.1
    local y = math.random() * 0.8 + 0.1
    particle.Position = UDim2.new(x, 0, y, 0)

    local directionX = math.random(-100, 100)
    local directionY = math.random(-100, 100)
    local targetPosition = UDim2.new(x, directionX, y, directionY)

    local tween = TweenService:Create(particle, TweenInfo.new(
        math.random(particleType.speed, particleType.speed + 3),
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ), {
        Position = targetPosition, 
        BackgroundTransparency = 1, 
        Size = UDim2.new(0, 0, 0, 0),
        Rotation = math.random(-180, 180)
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        particle:Destroy()
    end)
    
    table.insert(particles, particle)
end

local function spawnInitialParticles(num)
    for i = 1, num do
        local particleType = particleTypes[math.random(1, #particleTypes)]
        spawnParticle(particleType)
    end
end

-- Continuous particle spawning
local particleConnection
local function startParticleSystem()
    particleConnection = RunService.Heartbeat:Connect(function()
        if math.random() < 0.1 then -- 10% chance each frame
            local particleType = particleTypes[math.random(1, #particleTypes)]
            spawnParticle(particleType)
        end
    end)
end

local function stopParticleSystem()
    if particleConnection then
        particleConnection:Disconnect()
        particleConnection = nil
    end
end

-- Copy button functionality with enhanced feedback
copyButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "Copied!"
        copyButton.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
        
        -- Success pulse effect
        local pulseUp = TweenService:Create(copyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 105, 0, 38)})
        local pulseDown = TweenService:Create(copyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 100, 0, 35)})
        
        pulseUp:Play()
        pulseUp.Completed:Connect(function()
            pulseDown:Play()
        end)
        
        wait(2)
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Color3.fromRGB(80, 190, 230)
    end)
    if not success then
        warn("Copy button failed: " .. tostring(err))
        copyButton.Text = "Failed"
        copyButton.BackgroundColor3 = Color3.fromRGB(220, 100, 100)
        wait(2)
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Color3.fromRGB(80, 190, 230)
    end
end)

-- Typewriter effect for subtitle
local function typewriterEffect(textLabel, fullText, speed)
    textLabel.Text = ""
    for i = 1, #fullText do
        textLabel.Text = string.sub(fullText, 1, i)
        wait(speed or 0.05)
    end
end

-- Status messages during loading
local statusMessages = {
    "Initializing secure connection...",
    "Verifying user credentials...",
    "Loading game scripts...",
    "Establishing communication...",
    "Finalizing setup...",
    "Ready to launch!"
}

-- Enhanced loading bar animation with status updates
local function animateLoadingBar(callback)
    print("Starting enhanced loading bar animation")
    if not loadingBarFill or not loadingBarFill.Parent then
        warn("loadingBarFill is invalid or not parented")
        if callback then callback() end
        return
    end
    
    local success, err = pcall(function()
        -- Main loading animation
        local loadingTween = TweenService:Create(loadingBarFill, TweenInfo.new(
            3,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ), {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
        
        -- Glow animations
        local glowTween = TweenService:Create(loadingBarGlow, TweenInfo.new(
            1.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Transparency = 0.2, Thickness = 6})
        
        local glow2Tween = TweenService:Create(loadingBarGlow2, TweenInfo.new(
            2,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Transparency = 0.4, Thickness = 3})
        
        -- Gradient animation
        local gradientTween = TweenService:Create(loadingBarGradient, TweenInfo.new(
            2,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            -1,
            false
        ), {Rotation = 360})
        
        glowTween:Play()
        glow2Tween:Play()
        gradientTween:Play()
        
        local startTime = tick()
        local currentStatusIndex = 1
        local lastStatusUpdate = 0
        
        local connection = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            local percentage = math.min((elapsed / 3) * 100, 100)
            
            -- Update percentage with smooth animation
            percentageText.Text = string.format("%d%%", math.floor(percentage))
            
            -- Update status messages
            if elapsed - lastStatusUpdate > 0.5 and currentStatusIndex <= #statusMessages then
                statusText.Text = statusMessages[currentStatusIndex]
                currentStatusIndex = currentStatusIndex + 1
                lastStatusUpdate = elapsed
                
                -- Pulse effect on status change
                local statusPulse = TweenService:Create(statusText, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextTransparency = 0.3})
                local statusPulseBack = TweenService:Create(statusText, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextTransparency = 0})
                statusPulse:Play()
                statusPulse.Completed:Connect(function()
                    statusPulseBack:Play()
                end)
            end
            
            -- Color transition as loading progresses
            local progress = percentage / 100
            local currentColor = Color3.fromRGB(
                math.floor(200 + (55 * progress)),
                math.floor(220 + (35 * progress)),
                math.floor(240 + (15 * progress))
            )
            percentageText.TextColor3 = currentColor
            
            if percentage >= 100 then
                connection:Disconnect()
                percentageText.TextColor3 = Color3.fromRGB(120, 255, 180)
                statusText.Text = "Complete!"
                isComplete = true
                wait(0.5)
                if callback then callback() end
            end
        end)
        
        loadingTween:Play()
    end)
    
    if not success then
        warn("Enhanced loading bar animation failed: " .. tostring(err))
        percentageText.Text = "100%"
        percentageText.TextColor3 = Color3.fromRGB(120, 255, 180)
        statusText.Text = "Complete!"
        isComplete = true
        if callback then callback() end
    end
end

-- Enhanced entrance animations with staggered effects
local function playEntranceAnimations(callback)
    print("Starting enhanced entrance animations")
    local success, err = pcall(function()
        -- Initialize all elements as hidden
        mainFrame.BackgroundTransparency = 1
        contentFrame.BackgroundTransparency = 1
        contentFrame.Position = UDim2.new(0.5, -240, 0.5, -200)
        contentStroke.Transparency = 1
        contentGlow.Transparency = 1
        logoContainer.BackgroundTransparency = 1
        logoText.TextTransparency = 1
        titleLabel.TextTransparency = 1
        subtitleLabel.TextTransparency = 1
        discordContainer.BackgroundTransparency = 1
        discordStroke.Transparency = 1
        discordLabel.TextTransparency = 1
        copyButton.TextTransparency = 1
        copyButton.BackgroundTransparency = 1
        loadingBarContainer.BackgroundTransparency = 1
        percentageText.TextTransparency = 1
        statusText.TextTransparency = 1

        -- Background entrance
        local bgTween = TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
        bgTween:Play()
        
        wait(0.2)
        
        -- Content frame entrance with bounce
        local contentTween = TweenService:Create(contentFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.1, 
            Position = UDim2.new(0.5, -240, 0.5, -180)
        })
        contentTween:Play()
        
        -- Border glows
        local strokeTween = TweenService:Create(contentStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.3})
        local glowTween = TweenService:Create(contentGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.6})
        strokeTween:Play()
        glowTween:Play()
        
        wait(0.3)
        
        -- Logo entrance with spin
        local logoTween = TweenService:Create(logoContainer, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
        local logoTextTween = TweenService:Create(logoText, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})
        logoTween:Play()
        logoTextTween:Play()
        
        -- Logo spin effect
        local logoSpin = TweenService:Create(logoContainer, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 360})
        logoSpin:Play()
        
        wait(0.2)
        
        -- Title entrance with scale
        titleLabel.Size = UDim2.new(1, -40, 0, 40)
        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            Size = UDim2.new(1, -40, 0, 60)
        })
        titleTween:Play()
        
        wait(0.3)
        
        -- Subtitle typewriter effect
        local subtitleTween = TweenService:Create(subtitleLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})
        subtitleTween:Play()
        coroutine.wrap(function()
            typewriterEffect(subtitleLabel, "Enhanced Loading Experience", 0.08)
        end)()
        
        wait(0.4)
        
        -- Discord section entrance
        local discordContainerTween = TweenService:Create(discordContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2})
        local discordStrokeTween = TweenService:Create(discordStroke, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.5})
        local discordLabelTween = TweenService:Create(discordLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})
        local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            TextTransparency = 0, 
            BackgroundTransparency = 0
        })
        
        discordContainerTween:Play()
        discordStrokeTween:Play()
        discordLabelTween:Play()
        copyButtonTween:Play()
        
        wait(0.3)
        
        -- Loading bar section
        local loadingBarTween = TweenService:Create(loadingBarContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.3})
        local percentageTween = TweenService:Create(percentageText, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})
        local statusTween = TweenService:Create(statusText, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})
        
        loadingBarTween:Play()
        percentageTween:Play()
        statusTween:Play()
        
        loadingBarTween.Completed:Connect(function()
            if callback then callback() end
        end)
    end)
    
    if not success then
        warn("Enhanced entrance animations failed: " .. tostring(err))
        -- Fallback to ensure UI is visible
        mainFrame.BackgroundTransparency = 0
        contentFrame.BackgroundTransparency = 0.1
        contentStroke.Transparency = 0.3
        contentGlow.Transparency = 0.6
        logoContainer.BackgroundTransparency = 0
        logoText.TextTransparency = 0
        titleLabel.TextTransparency = 0
        subtitleLabel.TextTransparency = 0
        subtitleLabel.Text = "Enhanced Loading Experience"
        discordContainer.BackgroundTransparency = 0.2
        discordStroke.Transparency = 0.5
        discordLabel.TextTransparency = 0
        copyButton.TextTransparency = 0
        copyButton.BackgroundTransparency = 0
        loadingBarContainer.BackgroundTransparency = 0.3
        percentageText.TextTransparency = 0
        statusText.TextTransparency = 0
        if callback then callback() end
    end
end

-- Enhanced exit animations with spectacular effects
local function playExitAnimations(callback)
    print("Starting enhanced exit animations")
    local success, err = pcall(function()
        -- Stop particle system
        stopParticleSystem()
        
        -- Final success pulse
        local successPulse = TweenService:Create(contentFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 2, true), {
            Size = UDim2.new(0, 490, 0, 370)
        })
        successPulse:Play()
        
        -- Success glow intensification
        local finalGlow = TweenService:Create(contentStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Transparency = 0,
            Thickness = 6,
            Color = Color3.fromRGB(120, 255, 180)
        })
        finalGlow:Play()
        
        wait(0.8)
        
        -- Staggered exit animations
        local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        
        -- Start with status and percentage
        TweenService:Create(statusText, tweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(percentageText, tweenInfo, {TextTransparency = 1}):Play()
        
        wait(0.1)
        
        -- Loading bar section
        TweenService:Create(loadingBarContainer, tweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(loadingBarFill, tweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(loadingBarGlow, tweenInfo, {Transparency = 1}):Play()
        TweenService:Create(loadingBarGlow2, tweenInfo, {Transparency = 1}):Play()
        
        wait(0.1)
        
        -- Discord section
        TweenService:Create(discordContainer, tweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(discordStroke, tweenInfo, {Transparency = 1}):Play()
        TweenService:Create(discordLabel, tweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(copyButton, tweenInfo, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        
        wait(0.1)
        
        -- Subtitle
        TweenService:Create(subtitleLabel, tweenInfo, {TextTransparency = 1}):Play()
        
        wait(0.1)
        
        -- Title with scale down
        TweenService:Create(titleLabel, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            TextTransparency = 1,
            Size = UDim2.new(1, -40, 0, 40)
        }):Play()
        
        wait(0.1)
        
        -- Logo with spin out
        local logoExitSpin = TweenService:Create(logoContainer, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Rotation = -360,
            Size = UDim2.new(0, 40, 0, 40)
        })
        TweenService:Create(logoText, tweenInfo, {TextTransparency = 1}):Play()
        logoExitSpin:Play()
        
        wait(0.2)
        
        -- Final content frame and background
        local contentExitTween = TweenService:Create(contentFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -240, 0.5, -200),
            Size = UDim2.new(0, 400, 0, 300)
        })
        TweenService:Create(contentStroke, tweenInfo, {Transparency = 1}):Play()
        TweenService:Create(contentGlow, tweenInfo, {Transparency = 1}):Play()
        contentExitTween:Play()
        
        wait(0.3)
        
        local bgExitTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        bgExitTween:Play()
        
        bgExitTween.Completed:Connect(function()
            -- Clean up remaining particles
            for _, particle in pairs(particles) do
                if particle and particle.Parent then
                    particle:Destroy()
                end
            end
            particles = {}
            
            if screenGui and screenGui.Parent then
                screenGui:Destroy()
                print("Enhanced ScreenGui destroyed with style")
            end
            if callback then callback() end
        end)
    end)
    
    if not success then
        warn("Enhanced exit animations failed: " .. tostring(err))
        stopParticleSystem()
        for _, particle in pairs(particles) do
            if particle and particle.Parent then
                particle:Destroy()
            end
        end
        particles = {}
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
            print("ScreenGui destroyed (fallback)")
        end
        if callback then callback() end
    end
end

-- Enhanced border pulse with color cycling
local function animatePulse()
    local success, err = pcall(function()
        -- Main border pulse
        local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(
            3,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Transparency = 0.1, Thickness = 4})
        
        -- Secondary glow pulse
        local glowPulseTween = TweenService:Create(contentGlow, TweenInfo.new(
            2.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Transparency = 0.3, Thickness = 2})
        
        -- Color cycling
        local colorCycleTween = TweenService:Create(contentStroke, TweenInfo.new(
            4,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            -1,
            false
        ), {Color = Color3.fromRGB(150, 100, 255)})
        
        -- Background gradient animation
        local bgGradientTween = TweenService:Create(backgroundGradient, TweenInfo.new(
            8,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Rotation = 90})
        
        -- Title gradient animation
        local titleGradientTween = TweenService:Create(titleGradient, TweenInfo.new(
            6,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            -1,
            false
        ), {Rotation = 360})
        
        borderPulseTween:Play()
        glowPulseTween:Play()
        colorCycleTween:Play()
        bgGradientTween:Play()
        titleGradientTween:Play()
        
        -- Logo floating animation
        local logoFloat = TweenService:Create(logoContainer, TweenInfo.new(
            2,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Position = UDim2.new(0.5, -40, 0, 10)})
        logoFloat:Play()
    end)
    
    if not success then
        warn("Enhanced pulse animation failed: " .. tostring(err))
    end
end

-- Enhanced initialization with full sequence
local function initialize(callback)
    print("Initializing enhanced loading screen")
    if isInitialized then
        warn("Loading screen already initialized")
        return
    end
    isInitialized = true
    
    local success, err = pcall(function()
        -- Start particle system
        spawnInitialParticles(15)
        startParticleSystem()
        
        -- Start ambient animations
        animatePulse()
        
        -- Begin entrance sequence
        playEntranceAnimations(function()
            print("Enhanced entrance animations completed, starting loading sequence")
            animateLoadingBar(function()
                print("Enhanced loading bar completed, starting epic exit")
                playExitAnimations(callback)
            end)
        end)
    end)
    
    if not success then
        warn("Enhanced initialization failed: " .. tostring(err))
        -- Enhanced fallback
        mainFrame.BackgroundTransparency = 0
        contentFrame.BackgroundTransparency = 0.1
        contentStroke.Transparency = 0.3
        contentGlow.Transparency = 0.6
        logoContainer.BackgroundTransparency = 0
        logoText.TextTransparency = 0
        titleLabel.TextTransparency = 0
        subtitleLabel.TextTransparency = 0
        subtitleLabel.Text = "Enhanced Loading Experience"
        discordContainer.BackgroundTransparency = 0.2
        discordStroke.Transparency = 0.5
        discordLabel.TextTransparency = 0
        copyButton.TextTransparency = 0
        copyButton.BackgroundTransparency = 0
        loadingBarContainer.BackgroundTransparency = 0.3
        percentageText.TextTransparency = 0
        statusText.TextTransparency = 0
        
        startParticleSystem()
        animatePulse()
        
        animateLoadingBar(function()
            playExitAnimations(callback)
        end)
    end
end

-- Expose enhanced loading screen functions
return {
    playEntranceAnimations = playEntranceAnimations,
    playExitAnimations = playExitAnimations,
    animatePulse = animatePulse,
    animateLoadingBar = animateLoadingBar,
    setLoadingText = function(text, color)
        local success, err = pcall(function()
            if percentageText and percentageText.Parent then
                percentageText.Text = text or "0%"
                percentageText.TextColor3 = color or Color3.fromRGB(200, 220, 240)
            end
            if statusText and statusText.Parent then
                statusText.Text = "Custom Status: " .. (text or "Loading...")
                statusText.TextColor3 = color or Color3.fromRGB(140, 160, 180)
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
