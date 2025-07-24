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
local particles = {}
local connections = {}

-- Main background frame with gradient
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

-- Background gradient
local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 18, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 25))
}
backgroundGradient.Rotation = 45
backgroundGradient.Parent = mainFrame

-- Floating orbs background
local orbContainer = Instance.new("Frame")
orbContainer.Size = UDim2.new(1, 0, 1, 0)
orbContainer.BackgroundTransparency = 1
orbContainer.Parent = mainFrame

-- Content frame with glassmorphism effect
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 480, 0, 360)
contentFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
contentFrame.BackgroundTransparency = 0.3
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame corner and effects
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 16)
contentFrameCorner.Parent = contentFrame

-- Glassmorphism stroke
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(100, 200, 255)
contentStroke.Thickness = 2
contentStroke.Transparency = 0.4
contentStroke.Parent = contentFrame

-- Inner glow effect
local innerGlow = Instance.new("UIStroke")
innerGlow.Color = Color3.fromRGB(255, 255, 255)
innerGlow.Thickness = 1
innerGlow.Transparency = 0.8
innerGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
innerGlow.Parent = contentFrame

-- Title label with typewriter effect
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 60)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = ""
titleLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
titleLabel.TextScaled = true
titleLabel.TextSize = 36
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 0
titleLabel.Parent = contentFrame

-- Subtitle with fade-in effect
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, -40, 0, 30)
subtitleLabel.Position = UDim2.new(0, 20, 0, 85)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Enhanced Loading Experience"
subtitleLabel.TextColor3 = Color3.fromRGB(160, 180, 200)
subtitleLabel.TextScaled = true
subtitleLabel.TextSize = 18
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextTransparency = 1
subtitleLabel.Parent = contentFrame

-- Animated logo/icon placeholder
local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(0, 60, 0, 60)
logoFrame.Position = UDim2.new(1, -80, 0, 20)
logoFrame.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
logoFrame.BackgroundTransparency = 0.2
logoFrame.BorderSizePixel = 0
logoFrame.Parent = contentFrame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 30)
logoCorner.Parent = logoFrame

local logoGradient = Instance.new("UIGradient")
logoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 160, 220))
}
logoGradient.Rotation = 45
logoGradient.Parent = logoFrame

-- Discord container with hover effect
local discordContainer = Instance.new("Frame")
discordContainer.Size = UDim2.new(1, -40, 0, 45)
discordContainer.Position = UDim2.new(0, 20, 0, 130)
discordContainer.BackgroundColor3 = Color3.fromRGB(35, 45, 60)
discordContainer.BackgroundTransparency = 0.3
discordContainer.BorderSizePixel = 0
discordContainer.Parent = contentFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 10)
discordCorner.Parent = discordContainer

local discordStroke = Instance.new("UIStroke")
discordStroke.Color = Color3.fromRGB(88, 101, 242)
discordStroke.Thickness = 1
discordStroke.Transparency = 0.6
discordStroke.Parent = discordContainer

-- Discord label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.65, -10, 1, -6)
discordLabel.Position = UDim2.new(0, 15, 0, 3)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(120, 200, 255)
discordLabel.TextScaled = true
discordLabel.TextSize = 14
discordLabel.Font = Enum.Font.Gotham
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.TextTransparency = 1
discordLabel.Parent = discordContainer

-- Enhanced copy button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 100, 0, 35)
copyButton.Position = UDim2.new(0.7, -5, 0, 5)
copyButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
copyButton.BackgroundTransparency = 0.2
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
    ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(108, 121, 262))
}
copyButtonGradient.Rotation = 90
copyButtonGradient.Parent = copyButton

-- Discord advertisement with pulse effect
local discordAdLabel = Instance.new("TextLabel")
discordAdLabel.Size = UDim2.new(1, -40, 0, 30)
discordAdLabel.Position = UDim2.new(0, 20, 0, 185)
discordAdLabel.BackgroundTransparency = 1
discordAdLabel.Text = "Join our Discord for the latest updates and scripts!"
discordAdLabel.TextColor3 = Color3.fromRGB(140, 200, 255)
discordAdLabel.TextScaled = true
discordAdLabel.TextSize = 14
discordAdLabel.Font = Enum.Font.Gotham
discordAdLabel.TextTransparency = 1
discordAdLabel.TextWrapped = true
discordAdLabel.Parent = contentFrame

-- Enhanced loading section
local loadingSection = Instance.new("Frame")
loadingSection.Size = UDim2.new(1, -40, 0, 80)
loadingSection.Position = UDim2.new(0, 20, 0, 225)
loadingSection.BackgroundTransparency = 1
loadingSection.Parent = contentFrame

-- Progress ring container
local progressRingContainer = Instance.new("Frame")
progressRingContainer.Size = UDim2.new(0, 50, 0, 50)
progressRingContainer.Position = UDim2.new(0, 0, 0, 0)
progressRingContainer.BackgroundTransparency = 1
progressRingContainer.Parent = loadingSection

-- Animated loading bar container
local loadingBarContainer = Instance.new("Frame")
loadingBarContainer.Size = UDim2.new(1, -70, 0, 8)
loadingBarContainer.Position = UDim2.new(0, 60, 0, 21)
loadingBarContainer.BackgroundColor3 = Color3.fromRGB(30, 40, 55)
loadingBarContainer.BackgroundTransparency = 0.5
loadingBarContainer.BorderSizePixel = 0
loadingBarContainer.Parent = loadingSection

local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(0, 4)
loadingBarCorner.Parent = loadingBarContainer

-- Gradient loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
loadingBarFill.BackgroundTransparency = 0
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarContainer

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 4)
loadingBarFillCorner.Parent = loadingBarFill

local loadingBarGradient = Instance.new("UIGradient")
loadingBarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 220, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
}
loadingBarGradient.Parent = loadingBarFill

-- Shimmer effect on loading bar
local shimmerFrame = Instance.new("Frame")
shimmerFrame.Size = UDim2.new(0, 30, 1, 0)
shimmerFrame.Position = UDim2.new(0, -30, 0, 0)
shimmerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shimmerFrame.BackgroundTransparency = 0.5
shimmerFrame.BorderSizePixel = 0
shimmerFrame.Parent = loadingBarFill

local shimmerGradient = Instance.new("UIGradient")
shimmerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
shimmerGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.3),
    NumberSequenceKeypoint.new(1, 1)
}
shimmerGradient.Parent = shimmerFrame

-- Percentage text with counter animation
local percentageText = Instance.new("TextLabel")
percentageText.Size = UDim2.new(1, -70, 0, 25)
percentageText.Position = UDim2.new(0, 60, 0, 35)
percentageText.BackgroundTransparency = 1
percentageText.Text = "0%"
percentageText.TextColor3 = Color3.fromRGB(200, 230, 255)
percentageText.TextScaled = true
percentageText.TextSize = 16
percentageText.Font = Enum.Font.GothamBold
percentageText.TextTransparency = 1
percentageText.Parent = loadingSection

-- Status text
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -70, 0, 15)
statusText.Position = UDim2.new(0, 60, 0, 55)
statusText.BackgroundTransparency = 1
statusText.Text = "Initializing..."
statusText.TextColor3 = Color3.fromRGB(160, 180, 200)
statusText.TextScaled = true
statusText.TextSize = 12
statusText.Font = Enum.Font.Gotham
statusText.TextTransparency = 1
statusText.Parent = loadingSection

-- Warning label with icon
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -40, 0, 35)
warningLabel.Position = UDim2.new(0, 20, 0, 315)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "⚠ Warning: For your safety, only use scripts from trusted developers."
warningLabel.TextColor3 = Color3.fromRGB(255, 180, 120)
warningLabel.TextScaled = true
warningLabel.TextSize = 12
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextTransparency = 1
warningLabel.TextWrapped = true
warningLabel.Parent = contentFrame

-- Floating orbs system
local function createFloatingOrb()
    local orb = Instance.new("Frame")
    orb.Size = UDim2.new(0, math.random(8, 20), 0, math.random(8, 20))
    orb.BackgroundColor3 = Color3.fromRGB(
        math.random(80, 150),
        math.random(150, 255),
        math.random(200, 255)
    )
    orb.BackgroundTransparency = math.random(70, 90) / 100
    orb.BorderSizePixel = 0
    orb.ZIndex = -2
    orb.Parent = orbContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = orb
    
    local glow = Instance.new("UIStroke")
    glow.Color = orb.BackgroundColor3
    glow.Thickness = 2
    glow.Transparency = 0.8
    glow.Parent = orb
    
    orb.Position = UDim2.new(
        math.random(-10, 110) / 100,
        0,
        math.random(-10, 110) / 100,
        0
    )
    
    -- Floating animation
    local floatTween = TweenService:Create(orb, TweenInfo.new(
        math.random(15, 25),
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Position = UDim2.new(
            math.random(-10, 110) / 100,
            math.random(-50, 50),
            math.random(-10, 110) / 100,
            math.random(-50, 50)
        ),
        Rotation = math.random(-180, 180)
    })
    floatTween:Play()
    
    -- Pulse effect
    local pulseTween = TweenService:Create(orb, TweenInfo.new(
        math.random(3, 6),
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        BackgroundTransparency = math.random(40, 80) / 100,
        Size = UDim2.new(0, orb.Size.X.Offset * 1.3, 0, orb.Size.Y.Offset * 1.3)
    })
    pulseTween:Play()
    
    table.insert(particles, {orb = orb, floatTween = floatTween, pulseTween = pulseTween})
end

-- Progress ring animation
local function createProgressRing()
    for i = 1, 12 do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 4, 0, 4)
        dot.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        dot.BackgroundTransparency = 0.8
        dot.BorderSizePixel = 0
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Parent = progressRingContainer
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = dot
        
        local angle = (i - 1) * 30
        local radian = math.rad(angle)
        local radius = 20
        local x = math.cos(radian) * radius + 25
        local y = math.sin(radian) * radius + 25
        
        dot.Position = UDim2.new(0, x, 0, y)
        
        -- Delayed animation for wave effect
        wait(0.05)
        local pulseTween = TweenService:Create(dot, TweenInfo.new(
            1.2,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            false,
            i * 0.1
        ), {
            BackgroundTransparency = 0.2,
            Size = UDim2.new(0, 6, 0, 6)
        })
        pulseTween:Play()
    end
end

-- Typewriter effect for title
local function typewriterEffect(text, label, speed)
    speed = speed or 0.05
    for i = 1, #text do
        label.Text = string.sub(text, 1, i)
        wait(speed)
    end
end

-- Copy button functionality with animation
copyButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        
        -- Button press animation
        local pressDown = TweenService:Create(copyButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 95, 0, 33)})
        local pressUp = TweenService:Create(copyButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 100, 0, 35)})
        local colorChange = TweenService:Create(copyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 180, 100)})
        
        pressDown:Play()
        pressDown.Completed:Connect(function()
            pressUp:Play()
            colorChange:Play()
        end)
        
        copyButton.Text = "Copied!"
        wait(1.5)
        copyButton.Text = "Copy"
        TweenService:Create(copyButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
    end)
    if not success then
        warn("Copy button failed: " .. tostring(err))
    end
end)

-- Enhanced loading bar animation with status updates
local function animateLoadingBar(callback)
    print("Starting enhanced loading bar animation")
    if not loadingBarFill or not loadingBarFill.Parent then
        warn("loadingBarFill is invalid or not parented")
        if callback then callback() end
        return
    end
    
    local success, err = pcall(function()
        local startTime = tick()
        local duration = 3
        
        -- Status messages
        local statusMessages = {
            {time = 0, text = "Initializing..."},
            {time = 0.5, text = "Loading modules..."},
            {time = 1.2, text = "Connecting to server..."},
            {time = 2.0, text = "Preparing interface..."},
            {time = 2.7, text = "Almost ready..."},
            {time = 3.0, text = "Complete!"}
        }
        
        local currentStatusIndex = 1
        
        -- Shimmer animation
        local shimmerTween = TweenService:Create(shimmerFrame, TweenInfo.new(
            1.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            false
        ), {Position = UDim2.new(1, 0, 0, 0)})
        shimmerTween:Play()
        
        -- Main progress animation
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            local progress = math.min(elapsed / duration, 1)
            
            -- Update loading bar
            loadingBarFill.Size = UDim2.new(progress, 0, 1, 0)
            
            -- Update percentage with smooth counting
            local percentage = math.floor(progress * 100)
            percentageText.Text = string.format("%d%%", percentage)
            
            -- Color transition
            local hue = progress * 120 / 360 -- From blue to green
            local color = Color3.fromHSV(hue, 0.8, 1)
            percentageText.TextColor3 = color
            
            -- Update status messages
            if currentStatusIndex <= #statusMessages and elapsed >= statusMessages[currentStatusIndex].time then
                statusText.Text = statusMessages[currentStatusIndex].text
                
                -- Status text pulse
                local statusPulse = TweenService:Create(statusText, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                    TextTransparency = 0.2,
                    TextSize = 13
                })
                statusPulse:Play()
                statusPulse.Completed:Connect(function()
                    TweenService:Create(statusText, TweenInfo.new(0.2), {
                        TextTransparency = 0,
                        TextSize = 12
                    }):Play()
                end)
                
                currentStatusIndex = currentStatusIndex + 1
            end
            
            -- Completion
            if progress >= 1 then
                connection:Disconnect()
                shimmerTween:Cancel()
                
                -- Success animation
                local successTween = TweenService:Create(loadingBarFill, TweenInfo.new(0.5), {
                    BackgroundColor3 = Color3.fromRGB(100, 255, 150)
                })
                successTween:Play()
                
                percentageText.TextColor3 = Color3.fromRGB(100, 255, 150)
                statusText.Text = "Ready!"
                statusText.TextColor3 = Color3.fromRGB(100, 255, 150)
                
                isComplete = true
                wait(0.5)
                if callback then callback() end
            end
        end)
        
        table.insert(connections, connection)
    end)
    
    if not success then
        warn("Loading bar animation failed: " .. tostring(err))
        percentageText.Text = "100%"
        statusText.Text = "Complete!"
        percentageText.TextColor3 = Color3.fromRGB(100, 255, 150)
        statusText.TextColor3 = Color3.fromRGB(100, 255, 150)
        isComplete = true
        if callback then callback() end
    end
end

-- Enhanced entrance animations
local function playEntranceAnimations()
    print("Starting enhanced entrance animations")
    local success, err = pcall(function()
        -- Initialize hidden states
        mainFrame.BackgroundTransparency = 1
        contentFrame.BackgroundTransparency = 1
        contentFrame.Position = UDim2.new(0.5, -240, 0.5, -200)
        contentFrame.Size = UDim2.new(0, 400, 0, 300)
        contentStroke.Transparency = 1
        titleLabel.TextTransparency = 1
        subtitleLabel.TextTransparency = 1
        discordLabel.TextTransparency = 1
        copyButton.TextTransparency = 1
        copyButton.BackgroundTransparency = 1
        discordAdLabel.TextTransparency = 1
        loadingBarContainer.BackgroundTransparency = 1
        percentageText.TextTransparency = 1
        statusText.TextTransparency = 1
        warningLabel.TextTransparency = 1
        logoFrame.BackgroundTransparency = 1
        
        -- Background fade in
        local bgTween = TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 0})
        bgTween:Play()
        
        wait(0.2)
        
        -- Content frame dramatic entrance
        local frameTween = TweenService:Create(contentFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.15,
            Position = UDim2.new(0.5, -240, 0.5, -180),
            Size = UDim2.new(0, 480, 0, 360)
        })
        frameTween:Play()
        
        local strokeTween = TweenService:Create(contentStroke, TweenInfo.new(1.0, Enum.EasingStyle.Sine), {Transparency = 0.3})
        strokeTween:Play()
        
        wait(0.3)
        
        -- Logo spin-in
        local logoTween = TweenService:Create(logoFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.1,
            Rotation = 360
        })
        logoTween:Play()
        
        -- Typewriter title effect
        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.5), {TextTransparency = 0})
        titleTween:Play()
        spawn(function()
            wait(0.2)
            typewriterEffect("Scripts Hub X", titleLabel, 0.08)
        end)
        
        wait(0.5)
        
        -- Staggered element animations
        local elements = {
            {element = subtitleLabel, delay = 0},
            {element = discordLabel, delay = 0.1},
            {element = copyButton, delay = 0.1},
            {element = discordAdLabel, delay = 0.2},
            {element = loadingBarContainer, delay = 0.3},
            {element = percentageText, delay = 0.3},
            {element = statusText, delay = 0.3},
            {element = warningLabel, delay = 0.4}
        }
        
        for _, item in pairs(elements) do
            wait(item.delay)
            local tween = TweenService:Create(item.element, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
                TextTransparency = 0,
                BackgroundTransparency = item.element.BackgroundTransparency
            })
            tween:Play()
        end
        
        wait(0.5)
        
        -- Start loading process
        createProgressRing()
        animateLoadingBar(function()
            print("Loading completed, starting exit")
            playExitAnimations()
        end)
    end)
    
    if not success then
        warn("Entrance animations failed: " .. tostring(err))
        -- Fallback
        mainFrame.BackgroundTransparency = 0
        contentFrame.BackgroundTransparency = 0.15
        titleLabel.Text = "Scripts Hub X"
        titleLabel.TextTransparency = 0
        animateLoadingBar(function() playExitAnimations() end)
    end
end

-- Enhanced exit animations
local function playExitAnimations(callback)
    print("Starting enhanced exit animations")
    local success, err = pcall(function()
        -- Clean up connections
        for _, connection in pairs(connections) do
            if connection then connection:Disconnect() end
        end
        
        -- Clean up particles
        for _, particle in pairs(particles) do
            if particle.floatTween then particle.floatTween:Cancel() end
            if particle.pulseTween then particle.pulseTween:Cancel() end
        end
        
        -- Success flash effect
        local flashFrame = Instance.new("Frame")
        flashFrame.Size = UDim2.new(1, 0, 1, 0)
        flashFrame.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
        flashFrame.BackgroundTransparency = 1
        flashFrame.Parent = mainFrame
        
        local flashTween = TweenService:Create(flashFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.7})
        flashTween:Play()
        flashTween.Completed:Connect(function()
            TweenService:Create(flashFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        end)
        
        wait(0.3)
        
        -- Slide out animation
        local slideOutTween = TweenService:Create(contentFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -240, -0.5, -180),
            Rotation = -5,
            Size = UDim2.new(0, 400, 0, 300)
        })
        slideOutTween:Play()
        
        -- Fade out background
        local bgFadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 1})
        bgFadeOut:Play()
        
        slideOutTween.Completed:Connect(function()
            wait(0.2)
            if screenGui and screenGui.Parent then
                screenGui:Destroy()
                print("Enhanced ScreenGui destroyed")
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

-- Dynamic pulse effects
local function animatePulse()
    local success, err = pcall(function()
        -- Content frame pulse
        local contentPulse = TweenService:Create(contentStroke, TweenInfo.new(
            2.0,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Transparency = 0.1, Thickness = 3})
        contentPulse:Play()
        
        -- Logo rotation
        local logoRotate = TweenService:Create(logoFrame, TweenInfo.new(
            8.0,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            -1,
            false
        ), {Rotation = 360})
        logoRotate:Play()
        
        -- Discord container hover effect
        local discordHover = TweenService:Create(discordStroke, TweenInfo.new(
            1.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {Transparency = 0.2, Thickness = 2})
        discordHover:Play()
        
        -- Warning label pulse
        local warningPulse = TweenService:Create(warningLabel, TweenInfo.new(
            3.0,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {TextTransparency = 0.3})
        warningPulse:Play()
    end)
    
    if not success then
        warn("Pulse animation failed: " .. tostring(err))
    end
end

-- Particle burst effect
local function createParticleBurst(x, y, count)
    count = count or 12
    for i = 1, count do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, 6, 0, 6)
        particle.BackgroundColor3 = Color3.fromRGB(
            math.random(100, 255),
            math.random(150, 255),
            math.random(200, 255)
        )
        particle.BackgroundTransparency = 0.3
        particle.BorderSizePixel = 0
        particle.ZIndex = 10
        particle.AnchorPoint = Vector2.new(0.5, 0.5)
        particle.Position = UDim2.new(x, 0, y, 0)
        particle.Parent = mainFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = particle
        
        -- Random direction
        local angle = (i / count) * 360 + math.random(-30, 30)
        local radian = math.rad(angle)
        local distance = math.random(50, 150)
        
        local targetX = x + math.cos(radian) * distance / screenGui.AbsoluteSize.X
        local targetY = y + math.sin(radian) * distance / screenGui.AbsoluteSize.Y
        
        local burstTween = TweenService:Create(particle, TweenInfo.new(
            math.random(8, 12) / 10,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ), {
            Position = UDim2.new(targetX, 0, targetY, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 2, 0, 2),
            Rotation = math.random(-180, 180)
        })
        
        burstTween:Play()
        burstTween.Completed:Connect(function()
            particle:Destroy()
        end)
    end
end

-- Mouse interaction effects
copyButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(copyButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 105, 0, 37),
        BackgroundColor3 = Color3.fromRGB(108, 121, 262)
    })
    hoverTween:Play()
end)

copyButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(copyButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 100, 0, 35),
        BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    })
    leaveTween:Play()
end)

-- Initialize floating orbs
local function initializeFloatingOrbs()
    for i = 1, 15 do
        createFloatingOrb()
        wait(0.1)
    end
end

-- Start the enhanced loading screen
local function initialize()
    print("Initializing enhanced loading screen")
    local success, err = pcall(function()
        -- Start background orbs
        spawn(function()
            initializeFloatingOrbs()
        end)
        
        -- Start main animations
        playEntranceAnimations()
        animatePulse()
        
        -- Particle burst on completion
        spawn(function()
            while not isComplete do
                wait(0.1)
            end
            wait(0.5)
            createParticleBurst(0.5, 0.5, 20)
        end)
    end)
    
    if not success then
        warn("Enhanced initialization failed: " .. tostring(err))
        -- Fallback
        mainFrame.BackgroundTransparency = 0
        contentFrame.BackgroundTransparency = 0.15
        contentStroke.Transparency = 0.3
        titleLabel.Text = "Scripts Hub X"
        titleLabel.TextTransparency = 0
        subtitleLabel.TextTransparency = 0
        discordLabel.TextTransparency = 0
        copyButton.TextTransparency = 0
        copyButton.BackgroundTransparency = 0
        discordAdLabel.TextTransparency = 0
        loadingBarContainer.BackgroundTransparency = 0.5
        percentageText.TextTransparency = 0
        statusText.TextTransparency = 0
        warningLabel.TextTransparency = 0
        animateLoadingBar(function()
            playExitAnimations()
        end)
    end
end

-- Expose enhanced loading screen functions
return {
    playEntranceAnimations = playEntranceAnimations,
    playExitAnimations = playExitAnimations,
    animatePulse = animatePulse,
    animateLoadingBar = animateLoadingBar,
    createParticleBurst = createParticleBurst,
    setLoadingText = function(text, color)
        local success, err = pcall(function()
            if percentageText and percentageText.Parent then
                percentageText.Text = text or "0%"
                percentageText.TextColor3 = color or Color3.fromRGB(200, 230, 255)
            end
        end)
        if not success then
            warn("setLoadingText failed: " .. tostring(err))
        end
    end,
    setStatusText = function(text, color)
        local success, err = pcall(function()
            if statusText and statusText.Parent then
                statusText.Text = text or "Loading..."
                statusText.TextColor3 = color or Color3.fromRGB(160, 180, 200)
            end
        end)
        if not success then
            warn("setStatusText failed: " .. tostring(err))
        end
    end,
    isComplete = function()
        return isComplete
    end,
    initialize = initialize
}
