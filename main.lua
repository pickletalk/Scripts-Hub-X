-- Scripts Hub X | Official Loading Screen with Profile
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
mainFrame.Size = UDim2.new(0, 550, 0, 350)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Content frame (centered container)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 550, 0, 350)
contentFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame corner radius
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 20)
contentFrameCorner.Parent = contentFrame

-- Content frame border glow
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(200, 100, 100)
contentStroke.Thickness = 2
contentStroke.Transparency = 0.3
contentStroke.Parent = contentFrame

-- Profile frame (circular)
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(0, 80, 0, 80)
profileFrame.Position = UDim2.new(0.5, -40, 0, 20)
profileFrame.BackgroundColor3 = Color3.fromRGB(50, 35, 35)
profileFrame.BorderSizePixel = 0
profileFrame.Parent = contentFrame

-- Profile frame corner (make it circular)
local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0.5, 0)
profileCorner.Parent = profileFrame

-- Profile frame border
local profileStroke = Instance.new("UIStroke")
profileStroke.Color = Color3.fromRGB(255, 150, 150)
profileStroke.Thickness = 3
profileStroke.Transparency = 0.2
profileStroke.Parent = profileFrame

-- Profile image (placeholder - you can replace with actual image)
local profileImage = Instance.new("ImageLabel")
profileImage.Size = UDim2.new(1, -10, 1, -10)
profileImage.Position = UDim2.new(0, 5, 0, 5)
profileImage.BackgroundTransparency = 1
profileImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId -- Default Roblox face, replace with your image
profileImage.ScaleType = Enum.ScaleType.Fit
profileImage.Parent = profileFrame

-- Profile image corner (make it circular)
local profileImageCorner = Instance.new("UICorner")
profileImageCorner.CornerRadius = UDim.new(0.5, 0)
profileImageCorner.Parent = profileImage

-- Title label (moved down to accommodate profile)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 110)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X | Official"
titleLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = contentFrame

-- Title glow effect
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(255, 100, 100)
titleStroke.Thickness = 2
titleStroke.Transparency = 0.5
titleStroke.Parent = titleLabel

-- Credits label
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, -40, 0, 25)
creditsLabel.Position = UDim2.new(0, 20, 0, 170)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Text = "Credits to scripts owners"
creditsLabel.TextColor3 = Color3.fromRGB(200, 150, 150)
creditsLabel.TextScaled = true
creditsLabel.Font = Enum.Font.Gotham
creditsLabel.Parent = contentFrame

-- Discord link label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(1, -40, 0, 25)
discordLabel.Position = UDim2.new(0, 20, 0, 200)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "https://discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(200, 120, 120)
discordLabel.TextScaled = true
discordLabel.Font = Enum.Font.Gotham
discordLabel.Parent = contentFrame

-- Loading bar background
local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(1, -60, 0, 8)
loadingBarBg.Position = UDim2.new(0, 30, 0, 250)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.Parent = contentFrame

-- Loading bar background corner
local loadingBarBgCorner = Instance.new("UICorner")
loadingBarBgCorner.CornerRadius = UDim.new(0, 15)
loadingBarBgCorner.Parent = loadingBarBg

-- Loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.Position = UDim2.new(0, 0, 0, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarBg

-- Loading bar fill corner
local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 15)
loadingBarFillCorner.Parent = loadingBarFill

-- Loading bar gradient
local loadingBarGradient = Instance.new("UIGradient")
loadingBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100))
})
loadingBarGradient.Parent = loadingBarFill

-- Loading text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -40, 0, 30)
loadingText.Position = UDim2.new(0, 20, 0, 290)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(220, 180, 180)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.Gotham
loadingText.Parent = contentFrame

-- Particles effect
local particlesFrame = Instance.new("Frame")
particlesFrame.Size = UDim2.new(1, 0, 1, 0)
particlesFrame.Position = UDim2.new(0, 0, 0, 0)
particlesFrame.BackgroundTransparency = 1
particlesFrame.Parent = screenGui

-- Create floating particles
local particles = {}
for i = 1, 25 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
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
        {progress = 0.6, text = "Loading script..."},
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

-- Profile animation
local function animateProfile()
    -- Profile pulsing animation
    local profilePulseTween = TweenService:Create(profileStroke, TweenInfo.new(
        2,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Transparency = 0.0
    })
    
    profilePulseTween:Play()
    
    -- Profile rotation animation
    local profileRotateTween = TweenService:Create(profileFrame, TweenInfo.new(
        10,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut,
        -1,
        false
    ), {
        Rotation = 360
    })
    
    profileRotateTween:Play()
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
    contentFrame.BackgroundTransparency = 1
    contentStroke.Transparency = 1
    profileFrame.BackgroundTransparency = 1
    profileImage.ImageTransparency = 1
    profileStroke.Transparency = 1
    
    -- Animate content frame with scale effect
    contentFrame.Size = UDim2.new(0, 0, 0, 0)
    contentFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.new(0, 550, 0, 350),
        Position = UDim2.new(0.5, -275, 0.5, -175),
        BackgroundTransparency = 0
    })
    
    local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        Transparency = 0.3
    })
    
    contentFrameTween:Play()
    contentStrokeTween:Play()
    contentFrameTween.Completed:Wait()
    
    -- Animate profile frame first
    profileFrame.Size = UDim2.new(0, 0, 0, 0)
    profileFrame.Position = UDim2.new(0.5, 0, 0, 60)
    
    local profileFrameTween = TweenService:Create(profileFrame, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0.5, -40, 0, 20),
        BackgroundTransparency = 0
    })
    
    local profileStrokeTween = TweenService:Create(profileStroke, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        Transparency = 0.2
    })
    
    local profileImageTween = TweenService:Create(profileImage, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        ImageTransparency = 0
    })
    
    profileFrameTween:Play()
    profileStrokeTween:Play()
    profileImageTween:Play()
    profileFrameTween.Completed:Wait()
    
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
    
    TweenService:Create(profileFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(profileImage, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        ImageTransparency = 1
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
    
    -- Also animate the content frame border
    local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(
        3,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Transparency = 0.1
    })
    
    borderPulseTween:Play()
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
    print("Game supported! Loading Scripts Hub X...")
    
    -- ========================================
    -- LOADING SCREEN EXECUTION
    -- ========================================
    
    playEntranceAnimations()
    animateParticles()
    animateProfile()
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

-- Add click to skip functionality
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
        -- Skip loading animation
        screenGui:Destroy()
        print("Loading skipped!")
    end
end)
