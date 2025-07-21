-- Scripts Hub X | Enhanced Loading Screen
-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 12, 18)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Background gradient
local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 12, 18)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 18, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 12, 18))
}
backgroundGradient.Rotation = 45
backgroundGradient.Parent = mainFrame

-- Content container (cleaner positioning)
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(0, 400, 0, 280)
contentContainer.Position = UDim2.new(0.5, -200, 0.5, -140)
contentContainer.BackgroundColor3 = Color3.fromRGB(18, 25, 35)
contentContainer.BackgroundTransparency = 0.1
contentContainer.BorderSizePixel = 0
contentContainer.Parent = mainFrame

-- Container corner and shadow
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 16)
containerCorner.Parent = contentContainer

local containerStroke = Instance.new("UIStroke")
containerStroke.Color = Color3.fromRGB(45, 85, 140)
containerStroke.Thickness = 1
containerStroke.Transparency = 0.4
containerStroke.Parent = contentContainer

-- Drop shadow effect
local shadowFrame = Instance.new("Frame")
shadowFrame.Size = UDim2.new(1, 20, 1, 20)
shadowFrame.Position = UDim2.new(0, -10, 0, -10)
shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame.BackgroundTransparency = 0.8
shadowFrame.BorderSizePixel = 0
shadowFrame.ZIndex = contentContainer.ZIndex - 1
shadowFrame.Parent = contentContainer

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 20)
shadowCorner.Parent = shadowFrame

-- Logo/Brand section
local logoSection = Instance.new("Frame")
logoSection.Size = UDim2.new(1, -40, 0, 80)
logoSection.Position = UDim2.new(0, 20, 0, 20)
logoSection.BackgroundTransparency = 1
logoSection.Parent = contentContainer

-- Main title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = false
titleLabel.TextSize = 28
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = logoSection

-- Subtitle
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, 0, 0, 20)
subtitleLabel.Position = UDim2.new(0, 0, 0, 40)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Premium Script Hub"
subtitleLabel.TextColor3 = Color3.fromRGB(120, 160, 220)
subtitleLabel.TextScaled = false
subtitleLabel.TextSize = 14
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
subtitleLabel.Parent = logoSection

-- Version label
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(1, 0, 0, 16)
versionLabel.Position = UDim2.new(0, 0, 0, 62)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v2.4.1"
versionLabel.TextColor3 = Color3.fromRGB(80, 120, 180)
versionLabel.TextScaled = false
versionLabel.TextSize = 12
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextXAlignment = Enum.TextXAlignment.Center
versionLabel.Parent = logoSection

-- Loading section
local loadingSection = Instance.new("Frame")
loadingSection.Size = UDim2.new(1, -40, 0, 60)
loadingSection.Position = UDim2.new(0, 20, 0, 120)
loadingSection.BackgroundTransparency = 1
loadingSection.Parent = contentContainer

-- Loading text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0, 20)
loadingText.Position = UDim2.new(0, 0, 0, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Initializing..."
loadingText.TextColor3 = Color3.fromRGB(180, 200, 230)
loadingText.TextScaled = false
loadingText.TextSize = 13
loadingText.Font = Enum.Font.Gotham
loadingText.TextXAlignment = Enum.TextXAlignment.Left
loadingText.Parent = loadingSection

-- Progress percentage
local progressText = Instance.new("TextLabel")
progressText.Size = UDim2.new(1, 0, 0, 20)
progressText.Position = UDim2.new(0, 0, 0, 0)
progressText.BackgroundTransparency = 1
progressText.Text = "0%"
progressText.TextColor3 = Color3.fromRGB(45, 140, 255)
progressText.TextScaled = false
progressText.TextSize = 13
progressText.Font = Enum.Font.GothamBold
progressText.TextXAlignment = Enum.TextXAlignment.Right
progressText.Parent = loadingSection

-- Loading bar background
local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(1, 0, 0, 6)
loadingBarBg.Position = UDim2.new(0, 0, 0, 30)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.Parent = loadingSection

local loadingBarBgCorner = Instance.new("UICorner")
loadingBarBgCorner.CornerRadius = UDim.new(0, 3)
loadingBarBgCorner.Parent = loadingBarBg

-- Loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.Position = UDim2.new(0, 0, 0, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(45, 140, 255)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarBg

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 3)
loadingBarFillCorner.Parent = loadingBarFill

-- Loading bar gradient
local loadingBarGradient = Instance.new("UIGradient")
loadingBarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 120, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 140, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 160, 255))
}
loadingBarGradient.Parent = loadingBarFill

-- Loading bar glow effect
local glowFrame = Instance.new("Frame")
glowFrame.Size = UDim2.new(1, 4, 1, 4)
glowFrame.Position = UDim2.new(0, -2, 0, -2)
glowFrame.BackgroundColor3 = Color3.fromRGB(45, 140, 255)
glowFrame.BackgroundTransparency = 0.7
glowFrame.BorderSizePixel = 0
glowFrame.ZIndex = loadingBarFill.ZIndex - 1
glowFrame.Parent = loadingBarFill

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 5)
glowCorner.Parent = glowFrame

-- Discord section
local discordSection = Instance.new("Frame")
discordSection.Size = UDim2.new(1, -40, 0, 45)
discordSection.Position = UDim2.new(0, 20, 0, 200)
discordSection.BackgroundColor3 = Color3.fromRGB(30, 40, 55)
discordSection.BackgroundTransparency = 0.3
discordSection.BorderSizePixel = 0
discordSection.Parent = contentContainer

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 8)
discordCorner.Parent = discordSection

-- Discord label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.7, -10, 1, -10)
discordLabel.Position = UDim2.new(0, 15, 0, 5)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
discordLabel.TextScaled = false
discordLabel.TextSize = 12
discordLabel.Font = Enum.Font.GothamBold
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.TextYAlignment = Enum.TextYAlignment.Center
discordLabel.Parent = discordSection

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 80, 0, 28)
copyButton.Position = UDim2.new(1, -90, 0.5, -14)
copyButton.BackgroundColor3 = Color3.fromRGB(45, 140, 255)
copyButton.BackgroundTransparency = 0.1
copyButton.Text = "COPY"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextScaled = false
copyButton.TextSize = 11
copyButton.Font = Enum.Font.GothamBold
copyButton.Parent = discordSection

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 6)
copyButtonCorner.Parent = copyButton

-- Warning section
local warningSection = Instance.new("Frame")
warningSection.Size = UDim2.new(1, -40, 0, 20)
warningSection.Position = UDim2.new(0, 20, 0, 255)
warningSection.BackgroundTransparency = 1
warningSection.Parent = contentContainer

local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, 0, 1, 0)
warningLabel.Position = UDim2.new(0, 0, 0, 0)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "⚠️ Only use scripts from trusted developers"
warningLabel.TextColor3 = Color3.fromRGB(255, 180, 80)
warningLabel.TextScaled = false
warningLabel.TextSize = 11
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextXAlignment = Enum.TextXAlignment.Center
warningLabel.Parent = warningSection

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "COPIED!"
        copyButton.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
        
        wait(1.5)
        
        copyButton.Text = "COPY"
        copyButton.BackgroundColor3 = Color3.fromRGB(45, 140, 255)
    end)
end)

-- Realistic loading function
local function animateRealisticLoading(callback)
    local startTime = tick()
    local duration = 3 -- 3 seconds total
    local currentProgress = 0
    
    -- Loading stages with realistic text and timing
    local loadingStages = {
        {progress = 0, text = "Initializing...", delay = 0},
        {progress = 15, text = "Loading modules...", delay = 0.3},
        {progress = 35, text = "Connecting to servers...", delay = 0.6},
        {progress = 55, text = "Authenticating user...", delay = 0.9},
        {progress = 75, text = "Loading scripts...", delay = 1.4},
        {progress = 90, text = "Finalizing setup...", delay = 2.2},
        {progress = 100, text = "Complete!", delay = 2.8}
    }
    
    local stageIndex = 1
    
    -- Create smooth progress animation
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local targetProgress = math.min((elapsed / duration) * 100, 100)
        
        -- Smooth interpolation with slight randomness for realism
        local lerp = 0.05 + (math.random() * 0.02) -- Variable speed for realism
        currentProgress = currentProgress + (targetProgress - currentProgress) * lerp
        
        -- Update progress bar with easing
        local progressScale = math.max(0, math.min(1, currentProgress / 100))
        loadingBarFill.Size = UDim2.new(progressScale, 0, 1, 0)
        progressText.Text = math.floor(currentProgress) .. "%"
        
        -- Update loading text at specific stages
        if stageIndex <= #loadingStages and elapsed >= loadingStages[stageIndex].delay then
            loadingText.Text = loadingStages[stageIndex].text
            if loadingStages[stageIndex].text == "Complete!" then
                loadingText.TextColor3 = Color3.fromRGB(80, 220, 120)
                progressText.TextColor3 = Color3.fromRGB(80, 220, 120)
            end
            stageIndex = stageIndex + 1
        end
        
        -- Complete when progress reaches 100%
        if currentProgress >= 99.8 then
            connection:Disconnect()
            loadingBarFill.Size = UDim2.new(1, 0, 1, 0)
            progressText.Text = "100%"
            loadingText.Text = "Complete!"
            loadingText.TextColor3 = Color3.fromRGB(80, 220, 120)
            progressText.TextColor3 = Color3.fromRGB(80, 220, 120)
            
            wait(0.5)
            isComplete = true
            if callback then
                callback()
            end
        end
    end)
end

-- Smooth entrance animation
local function playEntranceAnimation()
    -- Hide all elements initially
    contentContainer.BackgroundTransparency = 1
    containerStroke.Transparency = 1
    shadowFrame.BackgroundTransparency = 1
    titleLabel.TextTransparency = 1
    subtitleLabel.TextTransparency = 1
    versionLabel.TextTransparency = 1
    loadingText.TextTransparency = 1
    progressText.TextTransparency = 1
    loadingBarBg.BackgroundTransparency = 1
    loadingBarFill.BackgroundTransparency = 1
    discordLabel.TextTransparency = 1
    copyButton.TextTransparency = 1
    copyButton.BackgroundTransparency = 1
    warningLabel.TextTransparency = 1
    
    -- Scale and fade in main container
    contentContainer.Size = UDim2.new(0, 350, 0, 250)
    contentContainer.Position = UDim2.new(0.5, -175, 0.5, -125)
    
    local containerTween = TweenService:Create(contentContainer, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.new(0, 400, 0, 280),
        Position = UDim2.new(0.5, -200, 0.5, -140),
        BackgroundTransparency = 0.1
    })
    
    containerTween:Play()
    
    -- Fade in elements sequentially
    wait(0.3)
    
    local fadeElements = {
        {element = containerStroke, property = "Transparency", target = 0.4, delay = 0},
        {element = shadowFrame, property = "BackgroundTransparency", target = 0.8, delay = 0.05},
        {element = titleLabel, property = "TextTransparency", target = 0, delay = 0.1},
        {element = subtitleLabel, property = "TextTransparency", target = 0, delay = 0.15},
        {element = versionLabel, property = "TextTransparency", target = 0, delay = 0.2},
        {element = loadingText, property = "TextTransparency", target = 0, delay = 0.3},
        {element = progressText, property = "TextTransparency", target = 0, delay = 0.35},
        {element = loadingBarBg, property = "BackgroundTransparency", target = 0, delay = 0.4},
        {element = discordLabel, property = "TextTransparency", target = 0, delay = 0.5},
        {element = copyButton, property = "TextTransparency", target = 0, delay = 0.55},
        {element = copyButton, property = "BackgroundTransparency", target = 0.1, delay = 0.55},
        {element = warningLabel, property = "TextTransparency", target = 0, delay = 0.6}
    }
    
    for _, fadeData in ipairs(fadeElements) do
        spawn(function()
            wait(fadeData.delay)
            local tween = TweenService:Create(fadeData.element, TweenInfo.new(
                0.4,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out
            ), {
                [fadeData.property] = fadeData.target
            })
            tween:Play()
        end)
    end
    
    wait(0.8)
    animateRealisticLoading(function()
        print("Loading completed")
    end)
end

-- Smooth exit animation
local function playExitAnimation(callback)
    local exitTween = TweenService:Create(contentContainer, TweenInfo.new(
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
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 1
    })
    
    exitTween:Play()
    fadeTween:Play()
    
    exitTween.Completed:Wait()
    
    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end
    
    if callback then
        callback()
    end
end

-- Start the loading sequence
playEntranceAnimation()

-- Return the loading screen API
return {
    playEntranceAnimation = playEntranceAnimation,
    playExitAnimation = playExitAnimation,
    animateRealisticLoading = animateRealisticLoading,
    isComplete = function()
        return isComplete
    end
}
