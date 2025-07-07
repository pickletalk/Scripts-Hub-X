-- Scripts Hub X | Official Loading Screen
-- Game detection and script loading function
local function checkGameSupport()
    local success, Games = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts/refs/heads/main/GameList.lua"))()
    end)
    
    if not success then
        warn("Failed to load game list: " .. tostring(Games))
        return false, "Failed to connect to script server"
    end
    
    -- Check if current game is supported
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            return true, Execute -- Game is supported, return the script URL
        end
    end
    
    return false, "Sorry but this game doesn't support our script!"
end

-- Function to load the actual script after loading screen
local function loadGameScript(scriptUrl)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(scriptUrl))()
    end)
    
    if not success then
        warn("Failed to load game script: " .. tostring(result))
        return false
    end
    
    return true
end

-- ========================================
-- LOADING SCREEN CODE STARTS BELOW
-- ========================================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsHubXLoading"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main background frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Gradient background
local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
})
backgroundGradient.Rotation = 45
backgroundGradient.Parent = mainFrame

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0.8, 0, 0.6, 0)
contentFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0.3, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X | Official"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = contentFrame

-- Title glow effect
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(100, 150, 255)
titleStroke.Thickness = 2
titleStroke.Transparency = 0.5
titleStroke.Parent = titleLabel

-- Credits label
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, 0, 0.1, 0)
creditsLabel.Position = UDim2.new(0, 0, 0.4, 0)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Text = "Credits to scripts owner"
creditsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
creditsLabel.TextScaled = true
creditsLabel.Font = Enum.Font.Gotham
creditsLabel.Parent = contentFrame

-- Discord link label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(1, 0, 0.1, 0)
discordLabel.Position = UDim2.new(0, 0, 0.55, 0)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "Discord: https://discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(114, 137, 218)
discordLabel.TextScaled = true
discordLabel.Font = Enum.Font.Gotham
discordLabel.Parent = contentFrame

-- Loading bar background
local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(0.8, 0, 0.02, 0)
loadingBarBg.Position = UDim2.new(0.1, 0, 0.75, 0)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.Parent = contentFrame

-- Loading bar background corner
local loadingBarBgCorner = Instance.new("UICorner")
loadingBarBgCorner.CornerRadius = UDim.new(0, 10)
loadingBarBgCorner.Parent = loadingBarBg

-- Loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.Position = UDim2.new(0, 0, 0, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarBg

-- Loading bar fill corner
local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 10)
loadingBarFillCorner.Parent = loadingBarFill

-- Loading bar gradient
local loadingBarGradient = Instance.new("UIGradient")
loadingBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255))
})
loadingBarGradient.Parent = loadingBarFill

-- Loading text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0.1, 0)
loadingText.Position = UDim2.new(0, 0, 0.85, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.Gotham
loadingText.Parent = contentFrame

-- Particles effect
local particlesFrame = Instance.new("Frame")
particlesFrame.Size = UDim2.new(1, 0, 1, 0)
particlesFrame.Position = UDim2.new(0, 0, 0, 0)
particlesFrame.BackgroundTransparency = 1
particlesFrame.Parent = mainFrame

-- Create floating particles
local particles = {}
for i = 1, 20 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    particle.BorderSizePixel = 0
    particle.BackgroundTransparency = 0.7
    particle.Parent = particlesFrame
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
    
    table.insert(particles, particle)
end

-- Animation functions
local function animateParticles()
    for _, particle in pairs(particles) do
        local randomX = math.random() * 2 - 1
        local randomY = math.random() * 2 - 1
        
        local tween = TweenService:Create(particle, TweenInfo.new(
            math.random(3, 8),
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {
            Position = UDim2.new(
                particle.Position.X.Scale + randomX * 0.1,
                0,
                particle.Position.Y.Scale + randomY * 0.1,
                0
            ),
            BackgroundTransparency = math.random(0.3, 0.9)
        })
        
        tween:Play()
    end
end

-- Animate loading bar
local function animateLoadingBar()
    local loadingSteps = {
        {progress = 0.2, text = "Initializing..."},
        {progress = 0.4, text = "Finding game script..."},
        wait(2)
        {progress = 0.6, text = "Loading script ..."},
        {progress = 0.8, text = "Setting up interface..."},
        {progress = 1.0, text = "Almost ready..."}
    }
    
    for i, step in ipairs(loadingSteps) do
        wait(math.random(0.5, 1.5))
        
        -- Update loading text
        loadingText.Text = step.text
        
        -- Animate loading bar
        local barTween = TweenService:Create(loadingBarFill, TweenInfo.new(
            0.8,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ), {
            Size = UDim2.new(step.progress, 0, 1, 0)
        })
        
        barTween:Play()
        barTween.Completed:Wait()
    end
end

-- Entrance animations
local function playEntranceAnimations()
    -- Start with everything transparent
    titleLabel.TextTransparency = 1
    creditsLabel.TextTransparency = 1
    discordLabel.TextTransparency = 1
    loadingBarBg.BackgroundTransparency = 1
    loadingText.TextTransparency = 1
    mainFrame.BackgroundTransparency = 1
    
    -- Animate main frame
    local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(
        1,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0
    })
    
    mainFrameTween:Play()
    mainFrameTween.Completed:Wait()
    
    -- Animate title
    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    titleTween:Play()
    wait(0.3)
    
    -- Animate credits
    local creditsTween = TweenService:Create(creditsLabel, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    creditsTween:Play()
    wait(0.2)
    
    -- Animate discord link
    local discordTween = TweenService:Create(discordLabel, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    discordTween:Play()
    wait(0.3)
    
    -- Animate loading bar background
    local loadingBarBgTween = TweenService:Create(loadingBarBg, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0
    })
    
    loadingBarBgTween:Play()
    
    -- Animate loading text
    local loadingTextTween = TweenService:Create(loadingText, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    loadingTextTween:Play()
    loadingTextTween.Completed:Wait()
end

-- Exit animations
local function playExitAnimations()
    local exitTween = TweenService:Create(mainFrame, TweenInfo.new(
        1,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    })
    
    -- Fade out all elements
    for _, element in pairs({titleLabel, creditsLabel, discordLabel, loadingText}) do
        TweenService:Create(element, TweenInfo.new(
            0.8,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {
            TextTransparency = 1
        }):Play()
    end
    
    TweenService:Create(loadingBarBg, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    }):Play()
    
    exitTween:Play()
    exitTween.Completed:Wait()
    
    screenGui:Destroy()
end

-- Title pulsing animation
local function animateTitlePulse()
    local pulseTween = TweenService:Create(titleStroke, TweenInfo.new(
        2,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Transparency = 0.1
    })
    
    pulseTween:Play()
end

-- Main execution
coroutine.wrap(function()
    
    -- Check if the current game is supported
    local isSupported, scriptUrlOrError = checkGameSupport()
    
    if not isSupported then
        -- Game not supported, show error and exit
        print(scriptUrlOrError)
        
        -- Update loading screen to show error
        loadingText.Text = scriptUrlOrError
        loadingText.TextColor3 = Color3.fromRGB(255, 100, 100) -- Red color for error
        
        wait(3) -- Show error for 3 seconds
        playExitAnimations()
        return -- Exit without loading
    end
    
    -- Game is supported, proceed with loading screen
    print("Game supported! Loading Scripts...")
    
    -- ========================================
    -- LOADING SCREEN EXECUTION
    -- ========================================
    
    playEntranceAnimations()
    animateParticles()
    animateTitlePulse()
    animateLoadingBar()
    wait(1)
    playExitAnimations()
    
    -- Load the actual game script
    local scriptLoaded = loadGameScript(scriptUrlOrError)
    
    if scriptLoaded then
        print("Scripts Hub X | Official - Loading Complete!")
        print("Game script loaded successfully!")
    else
        print("Scripts Hub X | Official - Script loading failed!")
    end
end)()

-- skip functionality
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
        -- Skip loading animation
        screenGui:Destroy()
        print("Loading skipped!")
    end
end)
